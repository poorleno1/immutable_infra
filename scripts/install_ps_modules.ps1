$ErrorActionPreference = "Stop"
. a:/Test-Command.ps1

Write-Host "Install NuGet package provider"

Install-PackageProvider -Name NuGet -Force

Install-Module PSWindowsUpdate -Force
Install-Module xNetworking -Force
Install-Module xRemoteDesktopAdmin -Force
Install-Module xCertificate -Force