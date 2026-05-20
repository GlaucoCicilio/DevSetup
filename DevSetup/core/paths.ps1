# paths.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Global:DevRoot = "D:\DevSetup"

$Global:DownloadRoot = "D:\Downloads\DevSetup"
$Global:InstallerCache = "$Global:DownloadRoot\installers"
$Global:CacheRoot = "$Global:DownloadRoot\cache"
$Global:TempRoot = "$Global:DownloadRoot\temp"

$Global:LogRoot = "$Global:DevRoot\logs"
$Global:StateRoot = "$Global:DevRoot\state"
$Global:ManifestRoot = "$Global:DevRoot\manifests"

$Global:LogFile = "$Global:LogRoot\setup-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
$Global:StateFile = "$Global:StateRoot\install-state.json"

$Global:VcpkgRoot = "$Global:DevRoot\vcpkg"
$Global:TestRoot = "$Global:DevRoot\tests"
