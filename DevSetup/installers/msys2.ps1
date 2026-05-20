# msys2.ps1
# 2026-05-20

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-MSYS2 {
    $bash = "C:\msys64\usr\bin\bash.exe"
    
    # Verificação melhorada
    if ((Test-Path "C:\msys64") -and (Test-Path $bash)) {
        Log "MSYS2 já instalado e configurado"
        return
    }
    
    if (!(Test-Path "C:\msys64")) {
        Log "Instalando MSYS2..."
        Invoke-WinGetInstall -Id "MSYS2.MSYS2"
        Start-Sleep -Seconds 5  # Aguarda instalação completar
    }
    
    # Atualizar e instalar ferramentas
    Log "Configurando MSYS2..."
    Start-Process `
        -FilePath $bash `
        -ArgumentList "-lc `"pacman -Syu --noconfirm`"" `
        -Wait
    
    Start-Process `
        -FilePath $bash `
        -ArgumentList "-lc `"pacman -S --noconfirm mingw-w64-x86_64-gcc mingw-w64-x86_64-gdb mingw-w64-x86_64-make`"" `
        -Wait
    
    Add-ToPath "C:\msys64\mingw64\bin"
    Mark-Installed "msys2"
}
