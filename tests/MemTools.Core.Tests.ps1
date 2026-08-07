$modulePath = Join-Path $PSScriptRoot '..\src\MemTools.Core.psm1'
Import-Module $modulePath -Force

function New-TestSnapshot {
    param(
        [double]$PhysicalBytes = 32GB,
        [double]$UsedBytes = 16GB,
        [double]$AvailableBytes = 16GB,
        [double]$NonPagedBytes = 512MB,
        [double]$PagedBytes = 512MB,
        [double]$CommitBytes = 18GB,
        [double]$CommitLimitBytes = 48GB,
        [double]$DwmPrivateBytes = 256MB,
        [double]$DurationSeconds = 30,
        [double]$NonPagedDeltaBytes = 0,
        [double]$InterruptPercent = 0.5,
        [double]$DpcPercent = 0.5,
        [double]$HandleCount = 120000,
        [double]$HandleDelta = 0,
        [object[]]$Drivers = @(),
        [object[]]$Software = @(),
        [object[]]$Processes = @()
    )

    [pscustomobject]@{
        CollectedAt = '2026-08-07T12:00:00+09:00'
        IsElevated  = $false
        Computer    = [pscustomobject]@{ PhysicalMemoryBytes = $PhysicalBytes }
        Memory      = [pscustomobject]@{
            UsedPhysicalMemoryBytes      = $UsedBytes
            AvailablePhysicalMemoryBytes = $AvailableBytes
            NonPagedPoolBytes            = $NonPagedBytes
            PagedPoolBytes               = $PagedBytes
            CommitBytes                  = $CommitBytes
            CommitLimitBytes             = $CommitLimitBytes
        }
        Processes  = [pscustomobject]@{
            TotalWorkingSetBytes = 8GB
            Items                = @($Processes)
        }
        Dwm        = [pscustomobject]@{ PrivateBytes = $DwmPrivateBytes }
        Gpu        = [pscustomobject]@{
            ActiveDisplayCount = 1
            SharedUsageBytes   = 0
            Adapters           = @([pscustomobject]@{ Name = 'Test GPU' })
        }
        Cpu        = [pscustomobject]@{
            InterruptTimePercent = $InterruptPercent
            DpcTimePercent       = $DpcPercent
            InterruptsPerSecond  = 12000
            DpcRate              = 40
        }
        Handles    = [pscustomobject]@{
            TotalCount = $HandleCount
            Delta      = $HandleDelta
            TopGrowth  = @([pscustomobject]@{ Name = 'sample'; Delta = $HandleDelta; StartCount = 1000; EndCount = 1000 + $HandleDelta })
        }
        Trend      = [pscustomobject]@{
            DurationSeconds        = $DurationSeconds
            NonPagedPoolDeltaBytes = $NonPagedDeltaBytes
        }
        Drivers    = @($Drivers)
        Software   = @($Software)
    }
}

Describe 'Get-MemoryAssessment' {
    It 'does not confirm Synology as the cause from correlation alone' {
        $driver = [pscustomobject]@{
            Name = 'cbfltfs4'; Path = 'C:\Windows\System32\drivers\cbfltfs4.sys'; Company = '/n software, Inc.'
            FileVersion = '4.1.105.114'; StartMode = 'Boot'; State = 'Running'; ProductName = 'CallbackFilter'
            AssociatedApps = @([pscustomobject]@{ Name = 'Synology Drive Client' })
        }
        $software = [pscustomobject]@{ Name = 'Synology Drive Client'; Version = '8.0.3' }
        $process = [pscustomobject]@{ Name = 'cloud-drive-daemon'; Path = 'C:\Users\test\SynologyDrive\cloud-drive-daemon.exe' }
        $snapshot = New-TestSnapshot -NonPagedBytes 3.5GB -PagedBytes 2.2GB -Drivers @($driver) -Software @($software) -Processes @($process)

        $assessment = Get-MemoryAssessment -Snapshot $snapshot
        $finding = $assessment.Findings | Where-Object Id -eq 'synology-callback-filter'

        $finding | Should Not BeNullOrEmpty
        $finding.Confidence | Should Be 'Suspected'
        $finding.Summary | Should Match '확정하지 않습니다'
        $finding.RelatedDrivers[0].Path | Should Match 'cbfltfs4.sys'
    }

    It 'raises confidence only when long-running pool growth is observed' {
        $driver = [pscustomobject]@{
            Name = 'cbfltfs4'; Path = 'C:\Windows\System32\drivers\cbfltfs4.sys'; Company = '/n software, Inc.'
            FileVersion = '4.1.105.114'; StartMode = 'Boot'; State = 'Running'
        }
        $software = [pscustomobject]@{ Name = 'Synology Drive Client'; Version = '8.0.3' }
        $snapshot = New-TestSnapshot -NonPagedBytes 3.5GB -DurationSeconds 600 -NonPagedDeltaBytes 128MB -Drivers @($driver) -Software @($software)

        $assessment = Get-MemoryAssessment -Snapshot $snapshot
        $finding = $assessment.Findings | Where-Object Id -eq 'synology-callback-filter'

        $finding.Confidence | Should Be 'Probable'
        ($assessment.Findings | Where-Object Id -eq 'nonpaged-growth') | Should Not BeNullOrEmpty
    }

    It 'reports a healthy baseline when thresholds are not exceeded' {
        $assessment = Get-MemoryAssessment -Snapshot (New-TestSnapshot)

        $assessment.RiskLevel | Should Be 'Healthy'
        @($assessment.Findings | Where-Object Severity -in @('Critical', 'Warning')).Count | Should Be 0
    }

    It 'marks extreme commit pressure as critical' {
        $snapshot = New-TestSnapshot -CommitBytes 46GB -CommitLimitBytes 48GB
        $assessment = Get-MemoryAssessment -Snapshot $snapshot

        $assessment.RiskLevel | Should Be 'Critical'
        ($assessment.Findings | Where-Object Id -eq 'commit-critical') | Should Not BeNullOrEmpty
    }

    It 'reports sustained CPU interrupt or DPC pressure' {
        $snapshot = New-TestSnapshot -InterruptPercent 8 -DpcPercent 7
        $assessment = Get-MemoryAssessment -Snapshot $snapshot

        ($assessment.Findings | Where-Object Id -eq 'cpu-interrupt-pressure') | Should Not BeNullOrEmpty
    }

    It 'reports long-running handle growth without calling every handle a file handle' {
        $snapshot = New-TestSnapshot -DurationSeconds 600 -HandleCount 180000 -HandleDelta 8000
        $assessment = Get-MemoryAssessment -Snapshot $snapshot
        $finding = $assessment.Findings | Where-Object Id -eq 'handle-growth'

        $finding | Should Not BeNullOrEmpty
        $finding.Summary | Should Match '모든 커널 핸들'
    }
}

Describe 'ConvertTo-MemoryMarkdown' {
    It 'includes findings and interpretation warning' {
        $snapshot = New-TestSnapshot
        $report = [pscustomobject]@{
            Snapshot   = $snapshot
            Assessment = Get-MemoryAssessment -Snapshot $snapshot
        }

        $markdown = ConvertTo-MemoryMarkdown -Report $report

        $markdown | Should Match 'MemTools 메모리 진단 보고서'
        $markdown | Should Match '해석 주의'
    }
}