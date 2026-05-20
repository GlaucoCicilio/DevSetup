# msys2.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-MSYS2 {

    if (Test-Path "C:\msys64") {
        Log "MSYS2 já instalado"
        return
    }
    else {
        Invoke-WinGetInstall -Id "MSYS2.MSYS2"
    }

    $bash = "C:\msys64\usr\bin\bash.exe"

    Start-Process `
        -FilePath $bash `
        -ArgumentList "-lc `"pacman -Syu --noconfirm`"" `
        -Wait

    Start-Process `
        -FilePath $bash `
        -ArgumentList "-lc `"pacman -S --noconfirm mingw-w64-x86_64-gcc mingw-w64-x86_64-gdb mingw-w64-x86_64-make`"" `
        -Wait

    Add-ToPath "C:\msys64\mingw64\bin"

    Mark-Installed "msys2"
}
