# vcpkg.ps1
# 2026-05-20

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Vcpkg {
    if (Test-Path "$Global:VcpkgRoot\vcpkg.exe") {
        Log "vcpkg já instalado"
        return
    }
    
    # Limpar diretório se existir mas sem vcpkg.exe (instalação incompleta)
    if (Test-Path $Global:VcpkgRoot) {
        Log-Warn "Removendo instalação incompleta de vcpkg..."
        Remove-Item -Path $Global:VcpkgRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    Log "Clonando vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git $Global:VcpkgRoot
    
    Log "Executando bootstrap-vcpkg.bat..."
    & "$Global:VcpkgRoot\bootstrap-vcpkg.bat"
    
    Log "Integrando vcpkg..."
    & "$Global:VcpkgRoot\vcpkg.exe" integrate install
    
    Mark-Installed "vcpkg"
}
