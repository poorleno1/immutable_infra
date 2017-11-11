$ProgressPreference='SilentlyContinue'

Write-Host "Downloading Windows Updates"

#Get-WUInstall -WindowsUpdate -AcceptAll -UpdateType Software -IgnoreReboot
Get-WUInstall -WindowsUpdate -AcceptAll -Download -verbose
Write-Host "Finished downloading Windows Updates"

Write-Host "Installing Windows Updates"
Get-WUInstall -WindowsUpdate -AcceptAll -Install -IgnoreReboot -verbose

Write-Host "Finished installing Windows Updates"