# qtcreator.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-QtCreator {

    if (Is-Installed "qtcreator") {
        Log "Qt Creator já instalado"
        return
    }

    Invoke-WinGetInstall -Id "QtProject.QtCreator"


    Mark-Installed "qtcreator"
}
