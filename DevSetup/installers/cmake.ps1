# cmake.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-CMake {

    if (Is-Installed "cmake") {
        Log "CMake já instalado"
        return
    }

    Invoke-WinGetInstall -Id "Kitware.CMake"

    Add-ToPath "C:\Program Files\CMake\bin"

    Mark-Installed "cmake"
}
