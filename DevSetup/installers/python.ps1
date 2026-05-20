# python.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Python {

    if (Is-Installed "python") {
        Log "Python já instalado"
        return
    }

    Invoke-WinGetInstall -Id "Python.Python.3.12"


    Mark-Installed "python"
}
