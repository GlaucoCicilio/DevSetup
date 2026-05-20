# qtcreator.ps1
# 2026-05-20

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-QtCreator {

    if (Is-Installed "qtcreator") {
        Log "Qt Creator já instalado"
        return
    }

    Log "Tentando instalar Qt Creator via WinGet..."
    
    try {
        Invoke-WinGetInstall -Id "QtProject.QtCreator" -ErrorAction Stop
        Mark-Installed "qtcreator"
        Log "Qt Creator instalado com sucesso"
    }
    catch {
        Log-Warn "Não foi possível instalar Qt Creator via WinGet: $_"
        Log-Warn "Qt Creator é opcional e pode ser instalado manualmente de: https://www.qt.io/download-open-source"
        # Não bloqueia a instalação - Qt Creator é opcional
    }
}
