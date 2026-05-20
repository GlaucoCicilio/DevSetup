# zero.ps1
# 2026-05-20

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)

if (!$principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Host "Elevando privilégios..."

    Start-Process `
        powershell `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
        -Verb RunAs

    exit
}

if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "WinGet não encontrado."
}

# ✅ Corrigido - Adicionar ao PATH da máquina permanentemente
if (!(Get-Command pwsh -ErrorAction SilentlyContinue)) {
    winget install `
        --id Microsoft.PowerShell `
        -e `
        --silent `
        --accept-source-agreements `
        --accept-package-agreements
    
    # Adicionar ao PATH da máquina (persistente)
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    if ($machinePath -notlike "*C:\Program Files\PowerShell\7*") {
        [Environment]::SetEnvironmentVariable(
            "Path",
            "$machinePath;C:\Program Files\PowerShell\7",
            "Machine"
        )
    }
    
    # Também adicionar à sessão atual
    $env:Path += ";C:\Program Files\PowerShell\7"
}

Set-Location $PSScriptRoot

pwsh -NoProfile -ExecutionPolicy Bypass -File ".\setup.ps1"
