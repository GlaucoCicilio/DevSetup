# libraries.ps1
# 2026-05-20

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Install-DefaultLibraries {
    $libraries = @(
        "boost",
        "fmt",
        "spdlog",
        "nlohmann-json",
        "sqlite3",
        "openssl",
        "openxlsx"
    )

    $failed = @()

    foreach ($lib in $libraries) {
        Log "Instalando biblioteca: $lib"
        
        try {
            & "$Global:VcpkgRoot\vcpkg.exe" install "$lib:x64-windows"
            Log "Biblioteca instalada: $lib"
        }
        catch {
            Log-Error "Falha ao instalar: $lib"
            $failed += $lib
        }
    }

    if ($failed.Count -gt 0) {
        Log-Warn "Bibliotecas que falharam: $($failed -join ', ')"
    }
}
