# git.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Git {

    if (Is-Installed "git") {
        Log "Git já instalado"
        return
    }

    Invoke-WinGetInstall -Id "Git.Git"

    Add-ToPath "C:\Program Files\Git\cmd"

    Mark-Installed "git"
}
