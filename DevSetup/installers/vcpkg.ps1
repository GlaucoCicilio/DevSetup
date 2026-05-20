# vcpkg.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Vcpkg {

    if (Test-Path "$Global:VcpkgRoot\vcpkg.exe") {
        Log "vcpkg já instalado"
        return
    }

    git clone https://github.com/microsoft/vcpkg.git $Global:VcpkgRoot

    & "$Global:VcpkgRoot\bootstrap-vcpkg.bat"

    & "$Global:VcpkgRoot\vcpkg.exe" integrate install

    Mark-Installed "vcpkg"
}
