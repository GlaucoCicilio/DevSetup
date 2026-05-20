# llvm.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-LLVM {

    if (Is-Installed "llvm") {
        Log "LLVM já instalado"
        return
    }

    Invoke-WinGetInstall -Id "LLVM.LLVM"

    Add-ToPath "C:\Program Files\LLVM\bin"

    Mark-Installed "llvm"
}
