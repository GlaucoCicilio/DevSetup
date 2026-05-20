# setup.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "PowerShell 7+ requerido." -ForegroundColor Red
    exit 1
}

# Core
. .\core\paths.ps1
. .\core\logging.ps1
. .\core\helpers.ps1
. .\core\downloads.ps1
. .\core\state.ps1
. .\core\validation.ps1

# Installers
. .\installers\git.ps1
. .\installers\cmake.ps1
. .\installers\ninja.ps1
. .\installers\msys2.ps1
. .\installers\visualstudio.ps1
. .\installers\llvm.ps1
. .\installers\vscode.ps1
. .\installers\qtcreator.ps1
. .\installers\python.ps1
. .\installers\node.ps1
. .\installers\vcpkg.ps1
. .\installers\libraries.ps1
. .\installers\mysql.ps1

Initialize-Directories
Ensure-Admin

Log "Iniciando DevSetup"

Ensure-Git
Ensure-Python
Ensure-Node
Ensure-VisualStudioBuildTools
Ensure-LLVM
Ensure-MSYS2
Ensure-Ninja
Ensure-CMake
Ensure-Vcpkg
Install-DefaultLibraries
Ensure-VSCode
Ensure-QtCreator
Ensure-MySQL

Test-ToolchainComplete

Log "DevSetup concluído com sucesso"
