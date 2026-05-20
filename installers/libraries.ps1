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

    # Validar vcpkg antes de começar
    if (!(Test-Path "$Global:VcpkgRoot\vcpkg.exe")) {
        Log-Error "vcpkg.exe não encontrado em: $Global:VcpkgRoot\vcpkg.exe"
        return
    }

    # Atualizar vcpkg antes de instalar bibliotecas
    Log "Atualizando repositório vcpkg..."
    try {
        & "$Global:VcpkgRoot\vcpkg.exe" update
        Log "Repositório vcpkg atualizado"
    }
    catch {
        Log-Warn "Falha ao atualizar vcpkg: $_"
    }

    foreach ($lib in $libraries) {
        Log "Instalando biblioteca: $lib"
        
        try {
            # Executar instalação com triplet correto
            $installSpec = "$lib`:x64-windows"
            Log "Executando: vcpkg install $installSpec"
            
            & "$Global:VcpkgRoot\vcpkg.exe" install $installSpec 2>&1 | ForEach-Object {
                # Log cada linha da saída do vcpkg
                Write-Host $_
            }
            
            Log "Biblioteca instalada com sucesso: $lib"
        }
        catch {
            Log-Error "Falha ao instalar: $lib - $_"
            $failed += $lib
        }
    }

    if ($failed.Count -gt 0) {
        Log-Warn "Bibliotecas com falha crítica ($($failed.Count)): $($failed -join ', ')"
        Log-Warn "Sugestão: Execute manualmente 'vcpkg install <biblioteca>:x64-windows' para diagnosticar"
    } else {
        Log "Processo de instalação de bibliotecas concluído"
    }
}
