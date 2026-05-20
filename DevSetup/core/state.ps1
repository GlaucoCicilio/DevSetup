# state.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-InstallState {

    if (!(Test-Path $Global:StateFile)) {
        return @{}
    }

    return Get-Content $Global:StateFile -Raw |
        ConvertFrom-Json -AsHashtable
}

function Save-InstallState {
    param($State)

    $State |
        ConvertTo-Json -Depth 10 |
        Set-Content $Global:StateFile
}

function Mark-Installed {
    param([string]$Package)

    $state = Get-InstallState

    $state[$Package] = @{
        installed = $true
        timestamp = (Get-Date)
    }

    Save-InstallState $state
}

function Is-Installed {
    param([string]$Package)

    $state = Get-InstallState

    return $state.ContainsKey($Package)
}
