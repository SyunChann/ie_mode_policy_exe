$ErrorActionPreference = "Stop"

$companyName = "Baroyeon"
$installRoot = Join-Path $env:ProgramData "$companyName\EdgeIEMode"
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
$logPath = Join-Path $installRoot "uninstall.log"

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $argList = @(
        "-NoProfile"
        "-ExecutionPolicy", "Bypass"
        "-File", ('"{0}"' -f $PSCommandPath)
    )
    Start-Process -FilePath "PowerShell.exe" -Verb RunAs -ArgumentList $argList -Wait
    exit $LASTEXITCODE
}

New-Item -ItemType Directory -Path $installRoot -Force | Out-Null
Start-Transcript -Path $logPath -Force | Out-Null

try {
    if (Test-Path -LiteralPath $policyPath) {
        Remove-ItemProperty -Path $policyPath -Name "InternetExplorerIntegrationSiteList" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $policyPath -Name "InternetExplorerIntegrationLevel" -ErrorAction SilentlyContinue
    }

    if (Test-Path -LiteralPath $installRoot) {
        $remaining = Get-ChildItem -LiteralPath $installRoot -Force -ErrorAction SilentlyContinue
        if (-not $remaining) {
            Remove-Item -LiteralPath $installRoot -Force
        }
    }

    Write-Host ""
    Write-Host "Removed Edge IE mode configuration."
    Write-Host "Restart Microsoft Edge to apply the change."
}
finally {
    Stop-Transcript | Out-Null
}

Read-Host "Press Enter to close"
