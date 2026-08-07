param(
    [Parameter(Mandatory = $true)]
    [string]$OutputJson,

    [Parameter(Mandatory = $true)]
    [string]$OutputMarkdown,

    [Parameter(Mandatory = $true)]
    [string]$StatusPath,

    [ValidateRange(2, 1800)]
    [int]$DurationSeconds = 15
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

$modulePath = Join-Path $PSScriptRoot 'MemTools.Core.psm1'
Import-Module $modulePath -Force
$utf8Bom = New-Object System.Text.UTF8Encoding($true)

function Write-DiagnosticStatus {
    param(
        [string]$Phase,
        [string]$Message,
        [int]$Progress,
        [AllowNull()]
        [string]$ErrorMessage = $null
    )

    $status = [ordered]@{
        UpdatedAt    = (Get-Date).ToString('o')
        Phase        = $Phase
        Message      = $Message
        Progress     = $Progress
        ErrorMessage = $ErrorMessage
    }
    $statusJson = $status | ConvertTo-Json -Depth 4
    [System.IO.File]::WriteAllText($StatusPath, $statusJson, $utf8Bom)
}

function Get-IsElevated {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-CounterValue {
    param(
        [string]$Path,
        [double]$DefaultValue = 0
    )

    try {
        $sample = Get-Counter -Counter $Path -ErrorAction Stop
        $values = @($sample.CounterSamples | ForEach-Object { $_.CookedValue })
        if ($values.Count -eq 0) { return $DefaultValue }
        return [double](($values | Measure-Object -Sum).Sum)
    }
    catch {
        return $DefaultValue
    }
}

function Resolve-DriverPath {
    param([string]$PathName)

    if ([string]::IsNullOrWhiteSpace($PathName)) { return $null }
    $resolved = $PathName.Trim('"')
    $resolved = $resolved -replace '^\\SystemRoot', $env:SystemRoot
    $resolved = $resolved -replace '^System32', (Join-Path $env:SystemRoot 'System32')
    if ($resolved.StartsWith('\??\')) { $resolved = $resolved.Substring(4) }
    if ($resolved -match '^(.*?\.sys)(\s+.*)?$') { $resolved = $Matches[1] }
    return $resolved
}

function Get-ProcessInventory {
    $processes = @(Get-Process -ErrorAction SilentlyContinue)
    $items = foreach ($process in $processes) {
        $path = $null
        try { $path = $process.Path } catch { $path = $null }
        [pscustomobject]@{
            Name            = $process.ProcessName
            Id              = $process.Id
            Path            = $path
            WorkingSetBytes = [double]$process.WorkingSet64
            PrivateBytes    = [double]$process.PrivateMemorySize64
            HandleCount     = [int]$process.HandleCount
        }
    }

    $groups = @($items | Group-Object Name | ForEach-Object {
        $workingSet = [double](($_.Group | Measure-Object WorkingSetBytes -Sum).Sum)
        $privateBytes = [double](($_.Group | Measure-Object PrivateBytes -Sum).Sum)
        [pscustomobject]@{
            Name            = $_.Name
            Count           = $_.Count
            WorkingSetBytes = $workingSet
            PrivateBytes    = $privateBytes
            HandleCount     = [int](($_.Group | Measure-Object HandleCount -Sum).Sum)
        }
    } | Sort-Object PrivateBytes -Descending)

    [pscustomobject]@{
        Count                = $items.Count
        TotalWorkingSetBytes = [double](($items | Measure-Object WorkingSetBytes -Sum).Sum)
        TotalPrivateBytes    = [double](($items | Measure-Object PrivateBytes -Sum).Sum)
        TotalHandleCount     = [int](($items | Measure-Object HandleCount -Sum).Sum)
        Items                = $items
        Groups               = $groups
        TopGroups            = @($groups | Select-Object -First 30)
    }
}

function Get-DriverInventory {
    $drivers = @(Get-CimInstance Win32_SystemDriver -ErrorAction SilentlyContinue | Where-Object State -eq 'Running')
    $items = foreach ($driver in $drivers) {
        $path = Resolve-DriverPath -PathName $driver.PathName
        $versionInfo = $null
        if ($path -and (Test-Path $path)) {
            try { $versionInfo = (Get-Item $path -ErrorAction Stop).VersionInfo } catch { $versionInfo = $null }
        }
        $signature = $null
        if ($path -and (Test-Path $path)) {
            try { $signature = Get-AuthenticodeSignature -FilePath $path -ErrorAction Stop } catch { $signature = $null }
        }

        $company = if ($null -ne $versionInfo) { [string]$versionInfo.CompanyName } else { '' }
        $includeDriver = $driver.ServiceType -match 'File System' -or
            $driver.Name -ieq 'cbfltfs4' -or
            ($company -and $company -notmatch '^Microsoft')
        if (-not $includeDriver) { continue }

        [pscustomobject]@{
            Name         = $driver.Name
            DisplayName  = $driver.DisplayName
            State        = $driver.State
            StartMode    = $driver.StartMode
            ServiceType  = $driver.ServiceType
            Path         = $path
            Company      = $company
            FileDescription = if ($null -ne $versionInfo) { [string]$versionInfo.FileDescription } else { '' }
            ProductName  = if ($null -ne $versionInfo) { [string]$versionInfo.ProductName } else { '' }
            FileVersion  = if ($null -ne $versionInfo) { [string]$versionInfo.FileVersion } else { '' }
            ProductVersion = if ($null -ne $versionInfo) { [string]$versionInfo.ProductVersion } else { '' }
            OriginalFilename = if ($null -ne $versionInfo) { [string]$versionInfo.OriginalFilename } else { '' }
            SignatureStatus = if ($null -ne $signature) { [string]$signature.Status } else { 'Unknown' }
            Signer       = if ($null -ne $signature -and $null -ne $signature.SignerCertificate) { [string]$signature.SignerCertificate.Subject } else { '' }
            IsFileSystem = [bool]($driver.ServiceType -match 'File System')
            AssociatedApps = @()
        }
    }
    return @($items | Sort-Object -Property @{ Expression = 'IsFileSystem'; Descending = $true }, Company, Name)
}

function Get-InstalledSoftware {
    $uninstallRoots = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    $software = @(Get-ItemProperty $uninstallRoots -ErrorAction SilentlyContinue |
        Where-Object {
            $nameProperty = $_.PSObject.Properties['DisplayName']
            $null -ne $nameProperty -and -not [string]::IsNullOrWhiteSpace([string]$nameProperty.Value)
        } |
        ForEach-Object {
            $versionProperty = $_.PSObject.Properties['DisplayVersion']
            $publisherProperty = $_.PSObject.Properties['Publisher']
            [pscustomobject]@{
                Name      = [string]$_.PSObject.Properties['DisplayName'].Value
                Version   = if ($null -ne $versionProperty) { [string]$versionProperty.Value } else { '' }
                Publisher = if ($null -ne $publisherProperty) { [string]$publisherProperty.Value } else { '' }
            }
        } |
        Sort-Object Name, Version -Unique)
    return $software
}

function Add-DriverAssociations {
    param(
        [object[]]$Drivers,
        [object[]]$Software,
        [object]$Processes
    )

    $rules = @(
        [pscustomobject]@{ Driver = '(?i)^cbfltfs4$'; App = '(?i)Synology Drive'; Process = '(?i)cloud-drive|synology'; Reason = '제품 구성요소 매핑' },
        [pscustomobject]@{ Driver = '(?i)^nv|nvidia'; App = '(?i)NVIDIA'; Process = '(?i)^nv|NVIDIA'; Reason = '드라이버 벤더 매핑' },
        [pscustomobject]@{ Driver = '(?i)^amd|radeon'; App = '(?i)AMD Software|Radeon'; Process = '(?i)^amd|radeon'; Reason = '드라이버 벤더 매핑' },
        [pscustomobject]@{ Driver = '(?i)^rtc|realtek'; App = '(?i)Realtek'; Process = '(?i)realtek|rtk'; Reason = '드라이버 벤더 매핑' },
        [pscustomobject]@{ Driver = '(?i)^mtk|mediatek'; App = '(?i)MediaTek'; Process = '(?i)mediatek|mtk'; Reason = '드라이버 벤더 매핑' }
    )

    foreach ($driver in $Drivers) {
        $apps = New-Object System.Collections.Generic.List[object]
        $identity = '{0} {1} {2} {3}' -f $driver.Name, $driver.Company, $driver.ProductName, $driver.FileDescription
        $rule = $rules | Where-Object { $identity -match $_.Driver } | Select-Object -First 1
        if ($null -ne $rule) {
            foreach ($app in @($Software | Where-Object { $_.Name -match $rule.App -or $_.Publisher -match $rule.App } | Select-Object -First 6)) {
                $apps.Add([pscustomobject]@{
                    Name        = $app.Name
                    Type        = 'Installed'
                    Version     = $app.Version
                    Publisher   = $app.Publisher
                    ProcessId   = $null
                    Path        = $null
                    MatchReason = $rule.Reason
                })
            }
            $runningGroups = @($Processes.Items | Where-Object { $_.Name -match $rule.Process -or $_.Path -match $rule.Process } | Group-Object Name)
            foreach ($group in @($runningGroups | Select-Object -First 6)) {
                $sample = $group.Group | Select-Object -First 1
                $apps.Add([pscustomobject]@{
                    Name        = $group.Name
                    Type        = 'Running'
                    Version     = ''
                    Publisher   = ''
                    ProcessId   = $sample.Id
                    Path        = $sample.Path
                    MatchReason = $rule.Reason
                })
            }
        }
        $driver.AssociatedApps = @($apps | Sort-Object Type, Name -Unique)
    }
    return $Drivers
}

function Get-HandleGrowth {
    param(
        [object]$Before,
        [object]$After
    )

    $beforeCounts = @{}
    foreach ($group in $Before.Groups) { $beforeCounts[$group.Name] = [double]$group.HandleCount }
    $growth = foreach ($group in $After.Groups) {
        $startCount = if ($beforeCounts.ContainsKey($group.Name)) { [double]$beforeCounts[$group.Name] } else { 0 }
        $endCount = [double]$group.HandleCount
        [pscustomobject]@{
            Name       = $group.Name
            StartCount = $startCount
            EndCount   = $endCount
            Delta      = $endCount - $startCount
        }
    }
    return @($growth | Sort-Object Delta -Descending | Select-Object -First 20)
}

function Get-GpuInventory {
    $adapters = @(Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue | ForEach-Object {
        [pscustomobject]@{
            Name                        = $_.Name
            DriverVersion               = $_.DriverVersion
            DriverDate                  = if ($_.DriverDate) { $_.DriverDate.ToString('o') } else { $null }
            AdapterRamBytes             = [double]$_.AdapterRAM
            CurrentHorizontalResolution = $_.CurrentHorizontalResolution
            CurrentVerticalResolution   = $_.CurrentVerticalResolution
            CurrentRefreshRate          = $_.CurrentRefreshRate
            Status                      = $_.Status
        }
    })
    $activeDisplays = @(Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams -ErrorAction SilentlyContinue | Where-Object Active)

    [pscustomobject]@{
        Adapters           = $adapters
        ActiveDisplayCount = $activeDisplays.Count
        DedicatedUsageBytes = Get-CounterValue -Path '\GPU Adapter Memory(*)\Dedicated Usage'
        SharedUsageBytes    = Get-CounterValue -Path '\GPU Adapter Memory(*)\Shared Usage'
        TotalCommittedBytes = Get-CounterValue -Path '\GPU Adapter Memory(*)\Total Committed'
    }
}

function Get-TrendData {
    param([int]$Seconds)

    $counterPaths = @(
        '\Memory\Pool Nonpaged Bytes',
        '\Memory\Pool Paged Bytes',
        '\Memory\Committed Bytes',
        '\Process(dwm)\Private Bytes',
        '\Processor(_Total)\% Interrupt Time',
        '\Processor(_Total)\% DPC Time',
        '\Processor(_Total)\Interrupts/sec',
        '\Processor(_Total)\DPC Rate',
        '\Process(_Total)\Handle Count'
    )
    $sampleCount = [Math]::Max(2, $Seconds)
    $samples = Get-Counter -Counter $counterPaths -SampleInterval 1 -MaxSamples $sampleCount -ErrorAction Stop
    $grouped = @($samples.CounterSamples | Group-Object Path)

    $result = @{}
    foreach ($group in $grouped) {
        $values = @($group.Group | ForEach-Object { [double]$_.CookedValue })
        $result[$group.Name] = [pscustomobject]@{
            StartBytes = $values[0]
            EndBytes   = $values[-1]
            DeltaBytes = $values[-1] - $values[0]
            MinBytes   = [double](($values | Measure-Object -Minimum).Minimum)
            MaxBytes   = [double](($values | Measure-Object -Maximum).Maximum)
            AverageValue = [double](($values | Measure-Object -Average).Average)
        }
    }

    $computerName = $env:COMPUTERNAME.ToLowerInvariant()
    $nonPagedKey = "\\$computerName\memory\pool nonpaged bytes"
    $pagedKey = "\\$computerName\memory\pool paged bytes"
    $commitKey = "\\$computerName\memory\committed bytes"
    $dwmKey = "\\$computerName\process(dwm)\private bytes"
    $interruptKey = "\\$computerName\processor(_total)\% interrupt time"
    $dpcKey = "\\$computerName\processor(_total)\% dpc time"
    $interruptRateKey = "\\$computerName\processor(_total)\interrupts/sec"
    $dpcRateKey = "\\$computerName\processor(_total)\dpc rate"
    $handleKey = "\\$computerName\process(_total)\handle count"

    [pscustomobject]@{
        DurationSeconds        = $Seconds
        SampleCount            = $sampleCount
        NonPagedPoolDeltaBytes = if ($result.ContainsKey($nonPagedKey)) { $result[$nonPagedKey].DeltaBytes } else { 0 }
        PagedPoolDeltaBytes    = if ($result.ContainsKey($pagedKey)) { $result[$pagedKey].DeltaBytes } else { 0 }
        CommitDeltaBytes       = if ($result.ContainsKey($commitKey)) { $result[$commitKey].DeltaBytes } else { 0 }
        DwmPrivateDeltaBytes   = if ($result.ContainsKey($dwmKey)) { $result[$dwmKey].DeltaBytes } else { 0 }
        InterruptTimePercent   = if ($result.ContainsKey($interruptKey)) { $result[$interruptKey].AverageValue } else { 0 }
        DpcTimePercent         = if ($result.ContainsKey($dpcKey)) { $result[$dpcKey].AverageValue } else { 0 }
        InterruptsPerSecond    = if ($result.ContainsKey($interruptRateKey)) { $result[$interruptRateKey].AverageValue } else { 0 }
        DpcRate                = if ($result.ContainsKey($dpcRateKey)) { $result[$dpcRateKey].AverageValue } else { 0 }
        CounterHandleDelta     = if ($result.ContainsKey($handleKey)) { $result[$handleKey].DeltaBytes } else { 0 }
        Series                 = $result
    }
}

try {
    foreach ($path in @($OutputJson, $OutputMarkdown, $StatusPath)) {
        $directory = Split-Path -Parent $path
        if ($directory -and -not (Test-Path $directory)) {
            New-Item -ItemType Directory -Path $directory -Force | Out-Null
        }
    }

    Write-DiagnosticStatus -Phase 'Starting' -Message '진단 환경을 확인하는 중입니다.' -Progress 4
    $isElevated = Get-IsElevated
    $operatingSystem = Get-CimInstance Win32_OperatingSystem
    $computerSystem = Get-CimInstance Win32_ComputerSystem
    $bootTime = $operatingSystem.LastBootUpTime

    Write-DiagnosticStatus -Phase 'Processes' -Message '프로세스와 메모리 지표를 수집하는 중입니다.' -Progress 14
    $processInventory = Get-ProcessInventory
    $memoryCompression = $processInventory.Items | Where-Object Name -eq 'Memory Compression' | Select-Object -First 1
    $dwmProcess = $processInventory.Items | Where-Object Name -eq 'dwm' | Select-Object -First 1

    $availableBytes = [double]$operatingSystem.FreePhysicalMemory * 1KB
    $visibleMemoryBytes = [double]$operatingSystem.TotalVisibleMemorySize * 1KB
    $memory = [pscustomobject]@{
        UsedPhysicalMemoryBytes      = $visibleMemoryBytes - $availableBytes
        AvailablePhysicalMemoryBytes = $availableBytes
        TotalVisibleMemoryBytes      = $visibleMemoryBytes
        CommitBytes                  = Get-CounterValue -Path '\Memory\Committed Bytes'
        CommitLimitBytes             = Get-CounterValue -Path '\Memory\Commit Limit'
        NonPagedPoolBytes            = Get-CounterValue -Path '\Memory\Pool Nonpaged Bytes'
        PagedPoolBytes               = Get-CounterValue -Path '\Memory\Pool Paged Bytes'
        CacheBytes                   = Get-CounterValue -Path '\Memory\Cache Bytes'
        StandbyBytes                 = (Get-CounterValue -Path '\Memory\Standby Cache Normal Priority Bytes') +
            (Get-CounterValue -Path '\Memory\Standby Cache Core Bytes') +
            (Get-CounterValue -Path '\Memory\Standby Cache Reserve Bytes')
        CompressionBytes             = if ($null -ne $memoryCompression) { $memoryCompression.WorkingSetBytes } else { 0 }
        PagesInputPerSecond          = Get-CounterValue -Path '\Memory\Pages Input/sec'
        PagesOutputPerSecond         = Get-CounterValue -Path '\Memory\Pages Output/sec'
    }

    Write-DiagnosticStatus -Phase 'Drivers' -Message '드라이버와 설치 프로그램의 연관성을 확인하는 중입니다.' -Progress 28
    $driverInventory = Get-DriverInventory
    $softwareInventory = Get-InstalledSoftware
    $driverInventory = Add-DriverAssociations -Drivers $driverInventory -Software $softwareInventory -Processes $processInventory

    Write-DiagnosticStatus -Phase 'Graphics' -Message 'GPU와 디스플레이 메모리를 확인하는 중입니다.' -Progress 38
    $gpuInventory = Get-GpuInventory
    $pageFiles = @(Get-CimInstance Win32_PageFileUsage -ErrorAction SilentlyContinue | ForEach-Object {
        [pscustomobject]@{
            Name           = $_.Name
            AllocatedBytes = [double]$_.AllocatedBaseSize * 1MB
            CurrentBytes   = [double]$_.CurrentUsage * 1MB
            PeakBytes      = [double]$_.PeakUsage * 1MB
        }
    })

    Write-DiagnosticStatus -Phase 'Trend' -Message ("{0}초 동안 누수 추세를 관측하는 중입니다." -f $DurationSeconds) -Progress 46
    $trend = Get-TrendData -Seconds $DurationSeconds

    Write-DiagnosticStatus -Phase 'Analyze' -Message '관측값을 비교하고 추정 원인을 계산하는 중입니다.' -Progress 88
    $finalProcessInventory = Get-ProcessInventory
    $handleGrowth = Get-HandleGrowth -Before $processInventory -After $finalProcessInventory
    $dwmProcess = $finalProcessInventory.Items | Where-Object Name -eq 'dwm' | Select-Object -First 1
    $snapshot = [pscustomobject]@{
        SchemaVersion = 1
        CollectedAt   = (Get-Date).ToString('o')
        IsElevated    = $isElevated
        Computer      = [pscustomobject]@{
            Name                = $env:COMPUTERNAME
            OperatingSystem     = $operatingSystem.Caption
            Version             = $operatingSystem.Version
            BuildNumber         = $operatingSystem.BuildNumber
            Architecture        = $operatingSystem.OSArchitecture
            PhysicalMemoryBytes = [double]$computerSystem.TotalPhysicalMemory
            BootTime            = $bootTime.ToString('o')
            UptimeDays          = [Math]::Round(((Get-Date) - $bootTime).TotalDays, 2)
        }
        Memory        = $memory
        Processes     = $finalProcessInventory
        Dwm           = [pscustomobject]@{
            WorkingSetBytes = if ($null -ne $dwmProcess) { $dwmProcess.WorkingSetBytes } else { 0 }
            PrivateBytes    = if ($null -ne $dwmProcess) { $dwmProcess.PrivateBytes } else { 0 }
            HandleCount     = if ($null -ne $dwmProcess) { $dwmProcess.HandleCount } else { 0 }
        }
        Gpu           = $gpuInventory
        Cpu           = [pscustomobject]@{
            InterruptTimePercent = $trend.InterruptTimePercent
            DpcTimePercent       = $trend.DpcTimePercent
            InterruptsPerSecond  = $trend.InterruptsPerSecond
            DpcRate              = $trend.DpcRate
        }
        Handles       = [pscustomobject]@{
            TotalCount                = $finalProcessInventory.TotalHandleCount
            Delta                     = $finalProcessInventory.TotalHandleCount - $processInventory.TotalHandleCount
            TopGrowth                 = $handleGrowth
            FileHandleDetailAvailable = [bool](Get-Command handle.exe, handle64.exe -ErrorAction SilentlyContinue | Select-Object -First 1)
            Scope                     = 'All process kernel handles; exact File type handles require Sysinternals Handle or WPR.'
        }
        Drivers       = $driverInventory
        Software      = $softwareInventory
        PageFiles     = $pageFiles
        Trend         = $trend
        Capabilities  = [pscustomobject]@{
            FilterManagerAvailable = [bool](Get-Command fltmc.exe -ErrorAction SilentlyContinue)
            PoolMonAvailable       = [bool](Get-Command poolmon.exe -ErrorAction SilentlyContinue)
            WprAvailable           = [bool](Get-Command wpr.exe -ErrorAction SilentlyContinue)
            HandleToolAvailable    = [bool](Get-Command handle.exe, handle64.exe -ErrorAction SilentlyContinue | Select-Object -First 1)
            DetailedPoolOwnerData  = $false
        }
    }

    $assessment = Get-MemoryAssessment -Snapshot $snapshot
    $report = [pscustomobject]@{
        Snapshot   = $snapshot
        Assessment = $assessment
    }

    Write-DiagnosticStatus -Phase 'Report' -Message '보고서를 저장하는 중입니다.' -Progress 96
    $json = $report | ConvertTo-Json -Depth 10
    $markdown = ConvertTo-MemoryMarkdown -Report $report
    [System.IO.File]::WriteAllText($OutputJson, $json, $utf8Bom)
    [System.IO.File]::WriteAllText($OutputMarkdown, $markdown, $utf8Bom)
    Write-DiagnosticStatus -Phase 'Completed' -Message '진단이 완료되었습니다.' -Progress 100
}
catch {
    $errorText = $_.Exception.Message
    try { Write-DiagnosticStatus -Phase 'Failed' -Message '진단을 완료하지 못했습니다.' -Progress 100 -ErrorMessage $errorText } catch { }
    Write-Error $errorText
    exit 1
}