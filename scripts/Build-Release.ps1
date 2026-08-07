param(
    [string]$Version = (Get-Content (Join-Path (Split-Path -Parent $PSScriptRoot) 'VERSION') -Raw).Trim(),
    [string]$OutputDirectory = (Join-Path (Split-Path -Parent $PSScriptRoot) 'dist')
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

if ($Version -notmatch '^\d+\.\d+\.\d+$') {
    throw "Version must use the numeric x.y.z format: $Version"
}

$rootPath = Split-Path -Parent $PSScriptRoot
$stagingPath = Join-Path $env:TEMP ('Owen-MemTool-' + [guid]::NewGuid().ToString('N'))
$packageRoot = Join-Path $stagingPath ("Owen-MemTool-$Version")
$archivePath = Join-Path $OutputDirectory ("Owen-MemTool-$Version.zip")

try {
    New-Item -ItemType Directory -Path $packageRoot -Force | Out-Null
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

    foreach ($directory in @('src', 'docs')) {
        Copy-Item -Path (Join-Path $rootPath $directory) -Destination (Join-Path $packageRoot $directory) -Recurse -Force
    }
    foreach ($file in @('Start-Owen-MemTool.cmd', 'README.md', 'CHANGELOG.md', 'VERSION')) {
        Copy-Item -Path (Join-Path $rootPath $file) -Destination (Join-Path $packageRoot $file) -Force
    }
    New-Item -ItemType Directory -Path (Join-Path $packageRoot 'reports') -Force | Out-Null

    if (Test-Path $archivePath) { Remove-Item $archivePath -Force }
    Compress-Archive -Path $packageRoot -DestinationPath $archivePath -CompressionLevel Optimal

    [pscustomobject]@{
        Version     = $Version
        ArchivePath = $archivePath
        SizeBytes   = (Get-Item $archivePath).Length
    }
}
finally {
    Remove-Item $stagingPath -Recurse -Force -ErrorAction SilentlyContinue
}