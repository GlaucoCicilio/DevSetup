# visualstudio.ps1
# 2026-05-19

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-VisualStudioBuildTools {

    Invoke-WinGetInstall `
        -Id "Microsoft.VisualStudio.2022.BuildTools" `
        -ExtraArgs '--override "--wait --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended"'

    Mark-Installed "visualstudio"
}
