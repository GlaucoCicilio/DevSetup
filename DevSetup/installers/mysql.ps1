# mysql.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-MySQL {

    if (Is-Installed "mysql") {
        Log "MySQL já instalado"
        return
    }

    Invoke-WinGetInstall -Id "Oracle.MySQL"

    

    Mark-Installed "mysql"
}
