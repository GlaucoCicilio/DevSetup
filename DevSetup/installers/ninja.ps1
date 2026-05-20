# ninja.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Ninja {

    if (Get-Command ninja -ErrorAction SilentlyContinue) {
        Log "Ninja já instalado"
        return
    }

    $ninjaZip = "$Global:InstallerCache\ninja-win.zip"
    $destination = "$Global:DevRoot\Ninja"

    Download-File `
        -Url "https://github.com/ninja-build/ninja/releases/latest/download/ninja-win.zip" `
        -Destination $ninjaZip

    Expand-Archive `
        -Path $ninjaZip `
        -DestinationPath $destination `
        -Force

    Add-ToPath $destination

    Mark-Installed "ninja"
}
