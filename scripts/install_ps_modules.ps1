$ErrorActionPreference = "Stop"
. a:/Test-Command.ps1

Write-Host "Install NuGet package provider"

Install-PackageProvider -Name NuGet -Force

Install-Module PSWindowsUpdate -Force
Install-Module xNetworking -Force
Install-Module xRemoteDesktopAdmin -Force
Install-Module xCertificate -Force


Write-Host "Downloading Choco client and tools"
#(New-Object System.Net.WebClient).DownloadFile('https://chocolatey.org/install.ps1', "c:\\temp\\install.ps1")
#(New-Object System.Net.WebClient).DownloadFile('https://chocolatey.org/install.ps1',"c:\temp\install.ps1")
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "Installing Choco client and tools"
#Invoke-Expression "& `"c:\\temp\\install.ps1`""