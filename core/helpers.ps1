# helpers.ps1
# 2026-05-20

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
    }

    if ($env:Path -notlike "*$PathToAdd*") {
        $env:Path += ";$PathToAdd"
    }
    
    return $true
}

function Invoke-WinGetInstall {
    param(
        [Parameter(Mandatory)]
        [string]$Id,

        [string]$ExtraArgs = "",
        
        [int]$MaxRetries = 3
    )

    Log "Instalando pacote WinGet: $Id"

    $retryCount = 0

    while ($retryCount -lt $MaxRetries) {
        try {
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

            if ($process.ExitCode -eq 0) {
                Log "Pacote instalado com sucesso: $Id"
                return $true
            }
            else {
                $retryCount++
                if ($retryCount -lt $MaxRetries) {
                    Log-Warn "Falha ao instalar $Id (tentativa $retryCount/$MaxRetries, código: $($process.ExitCode)). Aguardando 5 segundos..."
                    Start-Sleep -Seconds 5
                }
                else {
                    throw "Falha ao instalar pacote após $MaxRetries tentativas: $Id (código de saída: $($process.ExitCode))"
                }
            }
        }
        catch {
            $retryCount++
            if ($retryCount -lt $MaxRetries) {
                Log-Warn "Erro ao instalar $Id (tentativa $retryCount/$MaxRetries): $_ - Aguardando 5 segundos..."
                Start-Sleep -Seconds 5
            }
            else {
                throw $_
            }
        }
    }
}
