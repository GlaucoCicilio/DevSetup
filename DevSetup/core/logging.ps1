# logging.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Log {
    param([string]$Message)

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "[$timestamp] $Message"

    Write-Host $entry

    Add-Content -Path $Global:LogFile -Value $entry
}

function Log-Warn {
    param([string]$Message)
    Log "[WARN] $Message"
}

function Log-Error {
    param([string]$Message)
    Log "[ERROR] $Message"
}
