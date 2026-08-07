param(
    [switch]$ValidateOnly,
    [switch]$AutoStart,
    [ValidateSet(15, 60, 300)]
    [int]$DurationSeconds = 15,
    [string]$LoadReportPath,
    [ValidateRange(0, 3600)]
    [int]$CloseAfterSeconds = 0
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$rootPath = Split-Path -Parent $PSScriptRoot
$reportsPath = Join-Path $rootPath 'reports'
$collectorPath = Join-Path $PSScriptRoot 'Collect-MemoryDiagnostics.ps1'
$modulePath = Join-Path $PSScriptRoot 'MemTools.Core.psm1'
$xamlPath = Join-Path $PSScriptRoot 'MemTools.xaml'
Import-Module $modulePath -Force

if (-not (Test-Path $reportsPath)) {
    New-Item -ItemType Directory -Path $reportsPath -Force | Out-Null
}

$xamlReader = [System.Xml.XmlReader]::Create($xamlPath)
try {
    $script:MainWindow = [System.Windows.Markup.XamlReader]::Load($xamlReader)
}
finally {
    $xamlReader.Close()
}

$controlNames = @(
    'Duration15Button', 'Duration60Button', 'Duration300Button', 'StopButton', 'RunButton',
    'SummaryNavButton', 'ProcessesNavButton', 'DriversNavButton', 'CapabilityText',
    'EmptyState', 'LoadingState', 'LoadingTitleText', 'LoadingMessageText', 'DiagnosticProgress', 'ProgressText',
    'SummaryView', 'RiskHero', 'RiskBadge', 'RiskLevelText', 'HeadlineText', 'CollectedAtText',
    'OpenReportButton', 'OpenFolderButton', 'UsedMemoryText', 'AvailableMemoryText', 'KernelPoolText', 'CommitText', 'InterruptText', 'HandleText',
    'FindingCountText', 'FindingList', 'FindingTitleText', 'FindingSummaryText', 'EvidenceList', 'RelatedDriversHeading', 'RelatedDriverList', 'NextStepsList',
    'ProcessesView', 'ProcessSummaryText', 'ProcessGrid', 'DriversView', 'DriverSummaryText', 'DriverGrid', 'StatusText'
)

foreach ($controlName in $controlNames) {
    $control = $script:MainWindow.FindName($controlName)
    if ($null -eq $control) { throw "XAML control not found: $controlName" }
    Set-Variable -Name $controlName -Value $control -Scope Script
}

if ($ValidateOnly) {
    [pscustomobject]@{
        Valid        = $true
        ProductName  = $script:MainWindow.Title
        ControlCount = $controlNames.Count
        Collector    = Test-Path $collectorPath
        Module       = Test-Path $modulePath
    }
    $script:MainWindow.Close()
    return
}

function New-SolidBrush {
    param([string]$Color)
    return [System.Windows.Media.BrushConverter]::new().ConvertFromString($Color)
}

function Format-ByteValue {
    param(
        [double]$Bytes,
        [int]$Digits = 1
    )

    if ($Bytes -ge 1TB) { return ('{0:N' + $Digits + '} TB') -f ($Bytes / 1TB) }
    if ($Bytes -ge 1GB) { return ('{0:N' + $Digits + '} GB') -f ($Bytes / 1GB) }
    if ($Bytes -ge 1MB) { return ('{0:N' + $Digits + '} MB') -f ($Bytes / 1MB) }
    if ($Bytes -ge 1KB) { return ('{0:N' + $Digits + '} KB') -f ($Bytes / 1KB) }
    return ('{0:N0} B' -f $Bytes)
}

function Format-BytePair {
    param(
        [double]$FirstBytes,
        [double]$SecondBytes
    )

    $largest = [Math]::Max($FirstBytes, $SecondBytes)
    if ($largest -ge 1TB) { return '{0:N1} / {1:N1} TB' -f ($FirstBytes / 1TB), ($SecondBytes / 1TB) }
    if ($largest -ge 1GB) { return '{0:N1} / {1:N1} GB' -f ($FirstBytes / 1GB), ($SecondBytes / 1GB) }
    if ($largest -ge 1MB) { return '{0:N1} / {1:N1} MB' -f ($FirstBytes / 1MB), ($SecondBytes / 1MB) }
    if ($largest -ge 1KB) { return '{0:N1} / {1:N1} KB' -f ($FirstBytes / 1KB), ($SecondBytes / 1KB) }
    return '{0:N0} / {1:N0} B' -f $FirstBytes, $SecondBytes
}

function Get-UiPropertyValue {
    param(
        [AllowNull()][object]$InputObject,
        [string]$Name,
        $DefaultValue = $null
    )
    if ($null -eq $InputObject) { return $DefaultValue }
    $property = $InputObject.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) { return $DefaultValue }
    return $property.Value
}

function ConvertTo-DriverDisplay {
    param([object]$Driver)

    $apps = @((Get-UiPropertyValue $Driver 'AssociatedApps' @()) | ForEach-Object {
        $state = if ($_.Type -eq 'Running') { '실행 중' } else { '설치됨' }
        '{0} ({1})' -f $_.Name, $state
    } | Select-Object -Unique)
    $appsText = if ($apps.Count -gt 0) { $apps -join ', ' } else { '자동 식별 안 됨' }
    $product = [string](Get-UiPropertyValue $Driver 'ProductName' '')
    if ([string]::IsNullOrWhiteSpace($product)) { $product = [string](Get-UiPropertyValue $Driver 'DisplayName' '') }
    [pscustomobject]@{
        NameLine        = '{0} · {1}' -f (Get-UiPropertyValue $Driver 'Name' '-'), (Get-UiPropertyValue $Driver 'Company' '벤더 미상')
        ProductLine     = '{0} · {1} · 서명 {2}' -f $product, (Get-UiPropertyValue $Driver 'FileVersion' '버전 미상'), (Get-UiPropertyValue $Driver 'SignatureStatus' 'Unknown')
        PathLine        = '경로: {0}' -f (Get-UiPropertyValue $Driver 'Path' '-')
        AppsLine        = '연관 앱(추정): {0}' -f $appsText
        AssociatedApps  = $appsText
        ProductName     = $product
    }
}

function Get-SeverityLabel {
    param([string]$Severity)
    switch ($Severity) {
        'Critical' { return '위험' }
        'Warning' { return '주의' }
        default { return '정보' }
    }
}

function Get-ConfidenceLabel {
    param([string]$Confidence)
    switch ($Confidence) {
        'Observed' { return '관측됨' }
        'Suspected' { return '추정' }
        'Probable' { return '가능성 높음' }
        'Confirmed' { return '확정' }
        default { return $Confidence }
    }
}

function Set-DurationSelection {
    param([int]$Seconds)

    $script:SelectedDuration = $Seconds
    foreach ($button in @($script:Duration15Button, $script:Duration60Button, $script:Duration300Button)) {
        $selected = [int]$button.Tag -eq $Seconds
        $button.Background = if ($selected) { New-SolidBrush '#E9F4F4' } else { New-SolidBrush '#FFFFFF' }
        $button.BorderBrush = if ($selected) { New-SolidBrush '#8CB8BC' } else { New-SolidBrush '#DDE2E7' }
        $button.Foreground = if ($selected) { New-SolidBrush '#105B64' } else { New-SolidBrush '#18212B' }
        $button.FontWeight = if ($selected) { [System.Windows.FontWeights]::SemiBold } else { [System.Windows.FontWeights]::Normal }
    }
}

function Set-NavigationSelection {
    param([string]$ViewName)

    $navigation = @(
        [pscustomobject]@{ Name = 'Summary'; Button = $script:SummaryNavButton },
        [pscustomobject]@{ Name = 'Processes'; Button = $script:ProcessesNavButton },
        [pscustomobject]@{ Name = 'Drivers'; Button = $script:DriversNavButton }
    )
    foreach ($item in $navigation) {
        $selected = $item.Name -eq $ViewName
        $item.Button.Background = if ($selected) { New-SolidBrush '#E9F4F4' } else { [System.Windows.Media.Brushes]::Transparent }
        $item.Button.Foreground = if ($selected) { New-SolidBrush '#105B64' } else { New-SolidBrush '#45515C' }
        $item.Button.FontWeight = if ($selected) { [System.Windows.FontWeights]::SemiBold } else { [System.Windows.FontWeights]::Normal }
    }
}

function Show-PrimaryState {
    param([ValidateSet('Empty', 'Loading', 'Summary', 'Processes', 'Drivers')][string]$State)

    $script:EmptyState.Visibility = if ($State -eq 'Empty') { 'Visible' } else { 'Collapsed' }
    $script:LoadingState.Visibility = if ($State -eq 'Loading') { 'Visible' } else { 'Collapsed' }
    $script:SummaryView.Visibility = if ($State -eq 'Summary') { 'Visible' } else { 'Collapsed' }
    $script:ProcessesView.Visibility = if ($State -eq 'Processes') { 'Visible' } else { 'Collapsed' }
    $script:DriversView.Visibility = if ($State -eq 'Drivers') { 'Visible' } else { 'Collapsed' }
    if ($State -in @('Summary', 'Processes', 'Drivers')) { Set-NavigationSelection -ViewName $State }
}

function Set-NavigationEnabled {
    param([bool]$Enabled)
    $script:SummaryNavButton.IsEnabled = $Enabled
    $script:ProcessesNavButton.IsEnabled = $Enabled
    $script:DriversNavButton.IsEnabled = $Enabled
}

function Show-FindingDetails {
    param([AllowNull()][object]$Finding)

    if ($null -eq $Finding) {
        $script:FindingTitleText.Text = '원인을 선택하세요'
        $script:FindingSummaryText.Text = ''
        $script:EvidenceList.ItemsSource = $null
        $script:RelatedDriversHeading.Visibility = 'Collapsed'
        $script:RelatedDriverList.ItemsSource = $null
        $script:NextStepsList.ItemsSource = $null
        return
    }

    $script:FindingTitleText.Text = $Finding.Title
    $script:FindingSummaryText.Text = $Finding.Summary
    $script:EvidenceList.ItemsSource = @($Finding.Evidence | ForEach-Object { "• $_" })
    $driverDisplays = @($Finding.RelatedDrivers | ForEach-Object { ConvertTo-DriverDisplay $_ })
    $script:RelatedDriversHeading.Visibility = if ($driverDisplays.Count -gt 0) { 'Visible' } else { 'Collapsed' }
    $script:RelatedDriverList.ItemsSource = $driverDisplays
    $stepNumber = 0
    $script:NextStepsList.ItemsSource = @($Finding.NextSteps | ForEach-Object { $stepNumber++; "${stepNumber}. $_" })
}

function Set-RiskAppearance {
    param([string]$RiskLevel)

    switch ($RiskLevel) {
        'Critical' {
            $script:RiskBadge.Background = New-SolidBrush '#FDECEC'
            $script:RiskLevelText.Foreground = New-SolidBrush '#B93838'
            $script:RiskLevelText.Text = '즉시 확인'
        }
        'Review' {
            $script:RiskBadge.Background = New-SolidBrush '#FFF4DF'
            $script:RiskLevelText.Foreground = New-SolidBrush '#A15C09'
            $script:RiskLevelText.Text = '검토 필요'
        }
        default {
            $script:RiskBadge.Background = New-SolidBrush '#EAF6F0'
            $script:RiskLevelText.Foreground = New-SolidBrush '#267154'
            $script:RiskLevelText.Text = '안정'
        }
    }
}

function Load-DiagnosticReport {
    param([Parameter(Mandatory = $true)][string]$Path)

    $json = [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
    $report = $json | ConvertFrom-Json
    $script:CurrentReport = $report
    $script:CurrentJsonPath = $Path
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $script:CurrentMarkdownPath = Join-Path (Split-Path -Parent $Path) ($baseName + '.md')

    $snapshot = $report.Snapshot
    $assessment = $report.Assessment
    $physicalBytes = [double]$snapshot.Computer.PhysicalMemoryBytes
    $usedBytes = [double]$snapshot.Memory.UsedPhysicalMemoryBytes
    $availableBytes = [double]$snapshot.Memory.AvailablePhysicalMemoryBytes
    $kernelPoolBytes = [double]$snapshot.Memory.NonPagedPoolBytes + [double]$snapshot.Memory.PagedPoolBytes
    $commitBytes = [double]$snapshot.Memory.CommitBytes
    $commitLimitBytes = [double]$snapshot.Memory.CommitLimitBytes
    $cpu = Get-UiPropertyValue $snapshot 'Cpu' $null
    $handles = Get-UiPropertyValue $snapshot 'Handles' $null

    Set-RiskAppearance -RiskLevel $assessment.RiskLevel
    $script:HeadlineText.Text = $assessment.Headline
    $collectedAt = [DateTimeOffset]::Parse([string]$snapshot.CollectedAt).ToLocalTime()
    $script:CollectedAtText.Text = '수집 {0:yyyy-MM-dd HH:mm:ss} · 관측 {1}초 · 가동 {2:N1}일' -f $collectedAt, $snapshot.Trend.DurationSeconds, $snapshot.Computer.UptimeDays
    $script:UsedMemoryText.Text = Format-BytePair $usedBytes $physicalBytes
    $script:AvailableMemoryText.Text = Format-ByteValue $availableBytes
    $script:KernelPoolText.Text = Format-ByteValue $kernelPoolBytes
    $script:CommitText.Text = Format-BytePair $commitBytes $commitLimitBytes
    $script:InterruptText.Text = '{0:N1}% / {1:N1}%' -f (Get-UiPropertyValue $cpu 'InterruptTimePercent' 0), (Get-UiPropertyValue $cpu 'DpcTimePercent' 0)
    $script:HandleText.Text = '{0:N0} ({1:+#,0;-#,0;0})' -f (Get-UiPropertyValue $handles 'TotalCount' $snapshot.Processes.TotalHandleCount), (Get-UiPropertyValue $handles 'Delta' 0)

    $findingRows = @($assessment.Findings | ForEach-Object {
        [pscustomobject]@{
            Id         = $_.Id
            Severity   = Get-SeverityLabel $_.Severity
            Confidence = Get-ConfidenceLabel $_.Confidence
            Title      = $_.Title
            Summary    = $_.Summary
            Evidence   = @($_.Evidence)
            NextSteps  = @($_.NextSteps)
            RelatedDrivers = @((Get-UiPropertyValue $_ 'RelatedDrivers' @()))
            Score      = $_.Score
        }
    })
    $script:FindingList.ItemsSource = $findingRows
    $script:FindingCountText.Text = '{0}개' -f $findingRows.Count

    $handleGrowth = @((Get-UiPropertyValue $handles 'TopGrowth' @()))
    $processRows = @($snapshot.Processes.TopGroups | ForEach-Object {
        $processName = $_.Name
        $growth = $handleGrowth | Where-Object Name -eq $processName | Select-Object -First 1
        $delta = if ($null -ne $growth) { [double]$growth.Delta } else { 0 }
        [pscustomobject]@{
            Name               = $_.Name
            Count              = $_.Count
            WorkingSetDisplay  = Format-ByteValue ([double]$_.WorkingSetBytes)
            PrivateDisplay     = Format-ByteValue ([double]$_.PrivateBytes)
            HandleCountDisplay = '{0:N0}' -f [double]$_.HandleCount
            HandleDeltaDisplay = '{0:+#,0;-#,0;0}' -f $delta
        }
    })
    $script:ProcessGrid.ItemsSource = $processRows
    $script:ProcessSummaryText.Text = '전체 {0:N0}개 프로세스 · 핸들 {1:N0} ({2:+#,0;-#,0;0}) · 작업 집합 {3}' -f $snapshot.Processes.Count, (Get-UiPropertyValue $handles 'TotalCount' $snapshot.Processes.TotalHandleCount), (Get-UiPropertyValue $handles 'Delta' 0), (Format-ByteValue ([double]$snapshot.Processes.TotalWorkingSetBytes))

    $driverRows = @($snapshot.Drivers | ForEach-Object {
        $display = ConvertTo-DriverDisplay $_
        [pscustomobject]@{
            Name        = $_.Name
            ProductName = $display.ProductName
            Company     = $_.Company
            FileVersion = $_.FileVersion
            SignatureStatus = Get-UiPropertyValue $_ 'SignatureStatus' 'Unknown'
            AssociatedApps = $display.AssociatedApps
            Path        = $_.Path
        }
    })
    $script:DriverGrid.ItemsSource = $driverRows
    $script:DriverSummaryText.Text = '실행 중인 분석 대상 드라이버 {0:N0}개 · 파일시스템 필터 {1:N0}개' -f $driverRows.Count, @($snapshot.Drivers | Where-Object IsFileSystem).Count

    if ($snapshot.Capabilities.PoolMonAvailable -and $snapshot.IsElevated) {
        $script:CapabilityText.Text = '정밀 Pool Tag 진단 사용 가능'
    }
    elseif ($snapshot.Capabilities.WprAvailable) {
        $script:CapabilityText.Text = '표준 진단 · WPR 사용 가능'
    }
    else {
        $script:CapabilityText.Text = '표준 진단'
    }

    $script:HasReport = $true
    Set-NavigationEnabled -Enabled $true
    Show-PrimaryState -State 'Summary'
    if ($findingRows.Count -gt 0) { $script:FindingList.SelectedIndex = 0 }
    $script:StatusText.Text = '진단 완료 · {0}' -f $assessment.Headline
}

function Complete-DiagnosticRun {
    $script:ProgressTimer.Stop()
    $script:RunButton.IsEnabled = $true
    $script:StopButton.Visibility = 'Collapsed'
    foreach ($button in @($script:Duration15Button, $script:Duration60Button, $script:Duration300Button)) { $button.IsEnabled = $true }

    if ($script:DiagnosticProcess.ExitCode -eq 0 -and (Test-Path $script:CurrentJsonPath)) {
        try {
            Load-DiagnosticReport -Path $script:CurrentJsonPath
        }
        catch {
            Show-DiagnosticFailure -Message $_.Exception.Message
        }
    }
    else {
        $message = '수집 프로세스가 보고서를 만들지 못했습니다.'
        if (Test-Path $script:CurrentStatusPath) {
            try {
                $status = [System.IO.File]::ReadAllText($script:CurrentStatusPath, [System.Text.Encoding]::UTF8) | ConvertFrom-Json
                if ($status.ErrorMessage) { $message = $status.ErrorMessage }
            }
            catch { }
        }
        Show-DiagnosticFailure -Message $message
    }
    if (Test-Path $script:CurrentStatusPath) { Remove-Item $script:CurrentStatusPath -Force -ErrorAction SilentlyContinue }
}

function Show-DiagnosticFailure {
    param([string]$Message)

    $script:LoadingTitleText.Text = '진단을 완료하지 못했습니다'
    $script:LoadingMessageText.Text = $Message
    $script:DiagnosticProgress.Value = 100
    $script:DiagnosticProgress.Foreground = New-SolidBrush '#B93838'
    $script:ProgressText.Text = '실패'
    Show-PrimaryState -State 'Loading'
    $script:StatusText.Text = '진단 실패 · 다시 실행할 수 있습니다'
    Set-NavigationEnabled -Enabled $script:HasReport
}

function Start-DiagnosticRun {
    if ($null -ne $script:DiagnosticProcess -and -not $script:DiagnosticProcess.HasExited) { return }

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $script:CurrentJsonPath = Join-Path $reportsPath ("report-$timestamp.json")
    $script:CurrentMarkdownPath = Join-Path $reportsPath ("report-$timestamp.md")
    $script:CurrentStatusPath = Join-Path $env:TEMP ("owen-memtool-$timestamp-$PID.status.json")
    $script:RunStartedAt = Get-Date
    $script:RunDuration = $script:SelectedDuration

    $script:LoadingTitleText.Text = '메모리 사용을 관측하고 있습니다'
    $script:LoadingMessageText.Text = '진단 환경을 확인하는 중입니다.'
    $script:DiagnosticProgress.Value = 0
    $script:DiagnosticProgress.Foreground = New-SolidBrush '#166A75'
    $script:ProgressText.Text = '0%'
    $script:StatusText.Text = '진단 시작 · 관측값을 수집하는 중입니다'
    Show-PrimaryState -State 'Loading'
    Set-NavigationEnabled -Enabled $false
    $script:RunButton.IsEnabled = $false
    $script:StopButton.Visibility = 'Visible'
    foreach ($button in @($script:Duration15Button, $script:Duration60Button, $script:Duration300Button)) { $button.IsEnabled = $false }

    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = 'powershell.exe'
    $arguments = @(
        '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $collectorPath,
        '-OutputJson', $script:CurrentJsonPath,
        '-OutputMarkdown', $script:CurrentMarkdownPath,
        '-StatusPath', $script:CurrentStatusPath,
        '-DurationSeconds', [string]$script:RunDuration
    )
    $processInfo.Arguments = ($arguments | ForEach-Object { '"' + ([string]$_).Replace('"', '\"') + '"' }) -join ' '
    $processInfo.WorkingDirectory = $rootPath
    $processInfo.UseShellExecute = $false
    $processInfo.CreateNoWindow = $true
    $processInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden

    $script:DiagnosticProcess = New-Object System.Diagnostics.Process
    $script:DiagnosticProcess.StartInfo = $processInfo
    try {
        if (-not $script:DiagnosticProcess.Start()) { throw '진단 프로세스를 시작하지 못했습니다.' }
        $script:ProgressTimer.Start()
    }
    catch {
        Show-DiagnosticFailure -Message $_.Exception.Message
        $script:RunButton.IsEnabled = $true
        $script:StopButton.Visibility = 'Collapsed'
    }
}

function Stop-DiagnosticRun {
    if ($null -ne $script:DiagnosticProcess -and -not $script:DiagnosticProcess.HasExited) {
        try { $script:DiagnosticProcess.Kill() } catch { }
    }
    $script:ProgressTimer.Stop()
    $script:RunButton.IsEnabled = $true
    $script:StopButton.Visibility = 'Collapsed'
    foreach ($button in @($script:Duration15Button, $script:Duration60Button, $script:Duration300Button)) { $button.IsEnabled = $true }
    if (Test-Path $script:CurrentStatusPath) { Remove-Item $script:CurrentStatusPath -Force -ErrorAction SilentlyContinue }
    $script:StatusText.Text = '진단이 중지되었습니다'
    Set-NavigationEnabled -Enabled $script:HasReport
    if ($script:HasReport) { Show-PrimaryState -State 'Summary' } else { Show-PrimaryState -State 'Empty' }
}

$script:HasReport = $false
$script:SelectedDuration = $DurationSeconds
$script:DiagnosticProcess = $null
$script:CurrentReport = $null
$script:CurrentJsonPath = $null
$script:CurrentMarkdownPath = $null
$script:CurrentStatusPath = $null
$script:RunStartedAt = $null
$script:RunDuration = $DurationSeconds

$script:ProgressTimer = New-Object System.Windows.Threading.DispatcherTimer
$script:ProgressTimer.Interval = [TimeSpan]::FromMilliseconds(500)
$script:ProgressTimer.Add_Tick({
    if ($null -eq $script:DiagnosticProcess) { return }

    if (Test-Path $script:CurrentStatusPath) {
        try {
            $status = [System.IO.File]::ReadAllText($script:CurrentStatusPath, [System.Text.Encoding]::UTF8) | ConvertFrom-Json
            $progress = [double]$status.Progress
            if ($status.Phase -eq 'Trend') {
                $elapsed = ((Get-Date) - $script:RunStartedAt).TotalSeconds
                $trendProgress = 46 + ([Math]::Min(1, $elapsed / [Math]::Max(1, $script:RunDuration)) * 40)
                $progress = [Math]::Max($progress, $trendProgress)
            }
            $script:DiagnosticProgress.Value = [Math]::Min(100, $progress)
            $script:ProgressText.Text = '{0:N0}%' -f $script:DiagnosticProgress.Value
            $script:LoadingMessageText.Text = $status.Message
            $script:StatusText.Text = $status.Message
        }
        catch { }
    }

    if ($script:DiagnosticProcess.HasExited) { Complete-DiagnosticRun }
})

$script:Duration15Button.Add_Click({ Set-DurationSelection -Seconds 15 })
$script:Duration60Button.Add_Click({ Set-DurationSelection -Seconds 60 })
$script:Duration300Button.Add_Click({ Set-DurationSelection -Seconds 300 })
$script:RunButton.Add_Click({ Start-DiagnosticRun })
$script:StopButton.Add_Click({ Stop-DiagnosticRun })
$script:SummaryNavButton.Add_Click({ if ($script:HasReport) { Show-PrimaryState -State 'Summary' } })
$script:ProcessesNavButton.Add_Click({ if ($script:HasReport) { Show-PrimaryState -State 'Processes' } })
$script:DriversNavButton.Add_Click({ if ($script:HasReport) { Show-PrimaryState -State 'Drivers' } })
$script:FindingList.Add_SelectionChanged({ Show-FindingDetails -Finding $script:FindingList.SelectedItem })
$script:OpenReportButton.Add_Click({
    if ($script:CurrentMarkdownPath -and (Test-Path $script:CurrentMarkdownPath)) { Start-Process notepad.exe -ArgumentList $script:CurrentMarkdownPath }
})
$script:OpenFolderButton.Add_Click({ Start-Process explorer.exe -ArgumentList $reportsPath })
$script:MainWindow.Add_Closing({
    if ($null -ne $script:DiagnosticProcess -and -not $script:DiagnosticProcess.HasExited) {
        try { $script:DiagnosticProcess.Kill() } catch { }
    }
    $script:ProgressTimer.Stop()
})

Set-DurationSelection -Seconds $DurationSeconds
Set-NavigationEnabled -Enabled $false
Show-PrimaryState -State 'Empty'

$reportToLoad = $LoadReportPath
if ([string]::IsNullOrWhiteSpace($reportToLoad)) {
    $latestReport = Get-ChildItem -Path $reportsPath -Filter 'report-*.json' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($null -ne $latestReport) { $reportToLoad = $latestReport.FullName }
}
if ($reportToLoad -and (Test-Path $reportToLoad)) {
    try { Load-DiagnosticReport -Path $reportToLoad } catch { Show-DiagnosticFailure -Message $_.Exception.Message }
}

$script:MainWindow.Add_ContentRendered({
    if ($AutoStart) { Start-DiagnosticRun }
})

if ($CloseAfterSeconds -gt 0) {
    $closeTimer = New-Object System.Windows.Threading.DispatcherTimer
    $closeTimer.Interval = [TimeSpan]::FromSeconds($CloseAfterSeconds)
    $closeTimer.Add_Tick({
        $closeTimer.Stop()
        $script:MainWindow.Close()
    })
    $closeTimer.Start()
}

$null = $script:MainWindow.ShowDialog()