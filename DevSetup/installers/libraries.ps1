# libraries.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Install-DefaultLibraries {

    $libraries = @(
        "boost",
        "fmt",
        "spdlog",
        "nlohmann-json",
        "sqlite3",
        "openssl"
    )

    foreach ($lib in $libraries) {

        Log "Instalando biblioteca: $lib"

        & "$Global:VcpkgRoot\vcpkg.exe" install "$lib:x64-windows"
    }
}
