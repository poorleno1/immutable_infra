$ProgressPreference='SilentlyContinue'
Write-Host "Disabling automatinc restart"
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f

Write-Host "Downloading Windows Updates"

#Get-WUInstall -WindowsUpdate -AcceptAll -UpdateType Software -IgnoreReboot
#Get-WUInstall -WindowsUpdate -AcceptAll -Download -verbose
#Write-Host "Finished downloading Windows Updates"

Write-Host "Installing Windows Updates"
Get-WUInstall -WindowsUpdate -AcceptAll -Install -IgnoreReboot -verbose

Write-Host "Finished installing Windows Updates"