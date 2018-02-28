mkdir c:\temp
Write-host "Downloading Powershell 5.1"
(New-Object System.Net.WebClient).DownloadFile('https://go.microsoft.com/fwlink/?linkid=839516', "c:\\temp\\Win8.1AndW2K12R2-KB3191564-x64.msu")
Write-host "Downloaded Powershell 5.1"

Write-host "Installing PowerShell 5.1"
write-host "Extracting file"
winrs -r:localhost c:\windows\system32\wusa.exe c:\temp\Win8.1AndW2K12R2-KB3191564-x64.msu /extract:c:\temp
write-host "Installing file"
#Start-Process -FilePath "winrs" -ArgumentList "-r:localhost dism /online /add-package /PackagePath:c:\temp\WindowsBlue-KB3191564-x64.cab /quiet /norestart" -WorkingDirectory "C:\Temp\" -Wait
winrs -r:localhost dism /online /add-package /PackagePath:c:\temp\WindowsBlue-KB3191564-x64.cab /norestart
write-host "Finished Installing file"

#Start-Process -FilePath "c:\temp\Win8.1AndW2K12R2-KB3191564-x64.msu " -ArgumentList "/quiet /log:c:\ps5.log" -WorkingDirectory "C:\Temp\" -Wait

#Start-Process -FilePath "c:\windows\system32\wusa.exe" -ArgumentList "c:\vagrant\Win8.1AndW2K12R2-KB3191564-x64.msu /quiet /log:c:\vagrant\ps5.1.evtx" -WorkingDirectory "C:\Temp\" -Wait

#c:\temp\Win8.1AndW2K12R2-KB3191564-x64.msu /quiet
