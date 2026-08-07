$rootPath = Split-Path -Parent $PSScriptRoot
$uiPath = Join-Path $rootPath 'src\Owen-MemTool.ps1'
$collectorPath = Join-Path $rootPath 'src\Collect-MemoryDiagnostics.ps1'

Describe 'Owen MemTool UI' {
    It 'loads the XAML and required controls' {
        $result = & powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File $uiPath -ValidateOnly |
            Out-String

        $LASTEXITCODE | Should Be 0
        $result | Should Match 'Owen MemTool'
        $result | Should Match 'Valid\s+: True'
    }

    It 'keeps command focus free of rims and focus-only border changes' {
        Add-Type -AssemblyName PresentationFramework
        $xamlPath = Join-Path $rootPath 'src\MemTools.xaml'
        $reader = [System.Xml.XmlReader]::Create($xamlPath)
        try { $window = [System.Windows.Markup.XamlReader]::Load($reader) }
        finally { $reader.Close() }

        $window.ShowInTaskbar = $false
        $window.Left = -10000
        $window.Show()
        try {
            foreach ($name in @('RunButton', 'StopButton', 'Duration15Button', 'SummaryNavButton')) {
                $button = $window.FindName($name)
                $borderBefore = $button.BorderBrush.ToString()
                [void]$button.Focus()
                $window.Dispatcher.Invoke([Action]{ }, [System.Windows.Threading.DispatcherPriority]::Render)

                $button.FocusVisualStyle | Should BeNullOrEmpty
                $button.Effect | Should BeNullOrEmpty
                $button.BorderBrush.ToString() | Should Be $borderBefore
            }

            $window.FindName('EmptyState').Visibility = 'Collapsed'
            foreach ($target in @(
                @{ View = 'ProcessesView'; Grid = 'ProcessGrid' },
                @{ View = 'DriversView'; Grid = 'DriverGrid' }
            )) {
                $window.FindName('ProcessesView').Visibility = 'Collapsed'
                $window.FindName('DriversView').Visibility = 'Collapsed'
                $window.FindName($target.View).Visibility = 'Visible'
                $grid = $window.FindName($target.Grid)
                $borderBefore = $grid.BorderBrush.ToString()
                [void]$grid.Focus()
                $window.Dispatcher.Invoke([Action]{ }, [System.Windows.Threading.DispatcherPriority]::Render)

                $grid.IsKeyboardFocusWithin | Should Be $true
                $grid.FocusVisualStyle | Should BeNullOrEmpty
                $grid.Effect | Should BeNullOrEmpty
                $grid.BorderBrush.ToString() | Should Be $borderBefore
            }
        }
        finally {
            $window.Close()
        }
    }
}

Describe 'Owen MemTool collector' {
    It 'creates parseable JSON and Markdown reports' {
        $testRoot = Join-Path $env:TEMP ('OwenMemTool-Test-' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $testRoot -Force | Out-Null
        $jsonPath = Join-Path $testRoot 'report.json'
        $markdownPath = Join-Path $testRoot 'report.md'
        $statusPath = Join-Path $testRoot 'status.json'

        try {
            & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $collectorPath `
                -OutputJson $jsonPath `
                -OutputMarkdown $markdownPath `
                -StatusPath $statusPath `
                -DurationSeconds 2

            $LASTEXITCODE | Should Be 0
            (Test-Path $jsonPath) | Should Be $true
            (Test-Path $markdownPath) | Should Be $true
            $report = Get-Content $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
            $report.Snapshot.SchemaVersion | Should Be 1
            $report.Assessment.Headline | Should Not BeNullOrEmpty
            @($report.Assessment.Findings).Count | Should BeGreaterThan 0
            $report.Snapshot.Cpu.InterruptTimePercent | Should Not BeNullOrEmpty
            $report.Snapshot.Cpu.DpcTimePercent | Should Not BeNullOrEmpty
            $report.Snapshot.Handles.TotalCount | Should BeGreaterThan 0
            @($report.Snapshot.Handles.TopGrowth).Count | Should BeGreaterThan 0
            $report.Snapshot.Handles.Scope | Should Match 'kernel handles'
            $driver = @($report.Snapshot.Drivers | Where-Object { $_.Path } | Select-Object -First 1)
            $driver.Count | Should Be 1
            ($driver[0].PSObject.Properties.Name -contains 'Company') | Should Be $true
            ($driver[0].PSObject.Properties.Name -contains 'SignatureStatus') | Should Be $true
            ($driver[0].PSObject.Properties.Name -contains 'AssociatedApps') | Should Be $true
        }
        finally {
            Remove-Item $testRoot -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}