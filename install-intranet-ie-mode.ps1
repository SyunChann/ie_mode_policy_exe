$ErrorActionPreference = "Stop"

$companyName = "ExampleCompany"
$installRoot = Join-Path $env:ProgramData "$companyName\EdgeIEMode"
$siteListUrl = "https://intranet.example.com/iemode/sites.xml"
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
$logPath = Join-Path $installRoot "install.log"

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
    if (-not (Test-Path -LiteralPath $policyPath)) {
        New-Item -Path $policyPath -Force | Out-Null
    }

    # Enable IE mode in Edge and point it at the central Enterprise Mode site list.
    New-ItemProperty -Path $policyPath -Name "InternetExplorerIntegrationLevel" -PropertyType DWord -Value 1 -Force | Out-Null
    New-ItemProperty -Path $policyPath -Name "InternetExplorerIntegrationSiteList" -PropertyType String -Value $siteListUrl -Force | Out-Null

    Write-Host ""
    Write-Host "Installed Edge IE mode configuration."
    Write-Host "Target sites: intranet.example.com, legacy-crm.example.com"
    Write-Host "Site list: $siteListUrl"
    Write-Host ""
    Write-Host "Restart Microsoft Edge to apply the change."
}
finally {
    Stop-Transcript | Out-Null
}

Read-Host "Press Enter to close"
