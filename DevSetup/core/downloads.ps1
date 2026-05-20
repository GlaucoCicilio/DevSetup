# downloads.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Download-File {
    param(
        [string]$Url,
        [string]$Destination
    )

    if (Test-Path $Destination) {
        Log "Cache encontrado: $Destination"
        return
    }

    $maxRetries = 3

    for ($i = 1; $i -le $maxRetries; $i++) {

        try {

            Log "Download: $Url"

            Invoke-WebRequest `
                -Uri $Url `
                -OutFile $Destination

            Log "Download concluído"

            return
        }
        catch {

            Log-Warn "Tentativa $i falhou"

            if ($i -eq $maxRetries) {
                throw
            }

            Start-Sleep -Seconds 3
        }
    }
}
