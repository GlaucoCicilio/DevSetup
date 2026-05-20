# validation.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Admin {

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)

    if (!$principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "Execute como Administrador."
    }
}

function Test-Tool {
    param(
        [string]$Command,
        [string]$Name
    )

    if (Get-Command $Command -ErrorAction SilentlyContinue) {
        Log "$Name operacional"
    }
    else {
        Log-Error "$Name não encontrado"
    }
}

function Test-ToolchainComplete {

    Test-Tool -Command "git" -Name "Git"
    Test-Tool -Command "cmake" -Name "CMake"
    Test-Tool -Command "ninja" -Name "Ninja"
    Test-Tool -Command "clang" -Name "LLVM/Clang"
    Test-Tool -Command "python" -Name "Python"
    Test-Tool -Command "node" -Name "Node.js"
    Test-Tool -Command "g++" -Name "GCC"

    if (Test-Path "$Global:VcpkgRoot\vcpkg.exe") {
        Log "vcpkg operacional"
    }
    else {
        Log-Error "vcpkg não encontrado"
    }
}
