# node.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Node {

    if (Is-Installed "node") {
        Log "Node.js já instalado"
        return
    }

    Invoke-WinGetInstall -Id "OpenJS.NodeJS.LTS"

    Mark-Installed "node"
}
