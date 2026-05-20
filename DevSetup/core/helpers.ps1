# helpers.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Initialize-Directories {

    $dirs = @(
        $Global:DevRoot,
        $Global:DownloadRoot,
        $Global:InstallerCache,
        $Global:CacheRoot,
        $Global:TempRoot,
        $Global:LogRoot,
        $Global:StateRoot,
        $Global:ManifestRoot,
        $Global:TestRoot
    )

    foreach ($dir in $dirs) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
}

# Em helpers.ps1, melhorar Add-ToPath
function Add-ToPath {
    param([string]$PathToAdd)

    # Verificar se path existe
    if (!(Test-Path $PathToAdd)) {
        Log-Warn "PATH não encontrado, pulando: $PathToAdd"
        return $false
    }

    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    
    if ($machinePath -notlike "*$PathToAdd*") {
        [Environment]::SetEnvironmentVariable(
            "Path",
            "$machinePath;$PathToAdd",
            "Machine"
        )
        Log "PATH atualizado: $PathToAdd"
        return $true
    }
    
    return $true
}

    if ($env:Path -notlike "*$PathToAdd*") {
        $env:Path += ";$PathToAdd"
    }
}

function Invoke-WinGetInstall {
    param(
        [Parameter(Mandatory)]
        [string]$Id,

        [string]$ExtraArgs = ""
    )

    Log "Instalando pacote WinGet: $Id"

    $arguments = @(
        "install",
        "--id", $Id,
        "-e",
        "--silent",
        "--accept-source-agreements",
        "--accept-package-agreements"
    )

    if ($ExtraArgs) {
        $arguments += $ExtraArgs
    }

    $process = Start-Process `
        -FilePath "winget" `
        -ArgumentList $arguments `
        -Wait `
        -PassThru `
        -NoNewWindow

    if ($process.ExitCode -ne 0) {
        throw "Falha ao instalar pacote: $Id"
    }
}
