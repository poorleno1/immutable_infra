mkdir c:\temp
Write-host "Downloading Powershell 5.1" -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(New-Object System.Net.WebClient).DownloadFile('https://go.microsoft.com/fwlink/?linkid=839516', "c:\\temp\\Win8.1AndW2K12R2-KB3191564-x64.msu")
Write-host "Downloaded Powershell 5.1" -ForegroundColor Cyan

Write-host "Installing PowerShell 5.1" -ForegroundColor Red
write-host "Extracting file" -ForegroundColor Cyan
winrs -r:localhost c:\windows\system32\wusa.exe c:\temp\Win8.1AndW2K12R2-KB3191564-x64.msu /extract:c:\temp
write-host "Installing file" -ForegroundColor Cyan
winrs -r:localhost dism /online /add-package /PackagePath:c:\temp\WindowsBlue-KB3191564-x64.cab /norestart
write-host "Finished Installing file" -ForegroundColor Cyan

del c:\temp\*