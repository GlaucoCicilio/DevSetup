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
    $triplet = "x64-windows"

    foreach ($lib in $libraries) {
        Log "Instalando biblioteca: $lib"
        
        try {
            # Validar vcpkg.exe existe
            if (!(Test-Path "$Global:VcpkgRoot\vcpkg.exe")) {
                throw "vcpkg.exe não encontrado em: $Global:VcpkgRoot\vcpkg.exe"
            }

            # Executar instalação com triplet válido
            $libSpec = "$lib`:$triplet"
            Log-Debug "Executando: vcpkg install $libSpec"
            
            & "$Global:VcpkgRoot\vcpkg.exe" install $libSpec --triplet $triplet
            
            Log "Biblioteca instalada com sucesso: $lib"
        }
        catch {
            Log-Error "Falha ao instalar: $lib - $_"
            $failed += $lib
        }
    }

    if ($failed.Count -gt 0) {
        Log-Warn "Bibliotecas que falharam ($($failed.Count)): $($failed -join ', ')"
    } else {
        Log "Todas as bibliotecas foram instaladas com sucesso"
    }
}
