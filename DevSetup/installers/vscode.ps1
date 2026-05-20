# vscode.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-VSCode {

    if (Is-Installed "vscode") {
        Log "VSCode já instalado"
        return
    }

    Invoke-WinGetInstall -Id "Microsoft.VisualStudioCode"


    Mark-Installed "vscode"
}
