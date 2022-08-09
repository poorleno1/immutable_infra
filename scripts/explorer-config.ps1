if (!(test-path c:\tools)) {
    mkdir c:\tools
}

Invoke-WebRequest "https://raw.githubusercontent.com/poorleno1/ExplorerConfig/main/explorerConfig.ps1" -OutFile "c:\tools\ExplorerConfig.ps1"
#Start-BitsTransfer "https://raw.githubusercontent.com/poorleno1/ExplorerConfig/main/explorerConfig.ps1" -Destination "c:\tools\ExplorerConfig.ps1"

$action = New-ScheduledTaskAction -Execute "C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-WindowStyle Hidden -File `"C:\tools\ExplorerConfig.ps1`""
$trigger = New-ScheduledTaskTrigger -AtLogon
$trigger.Delay = 'PT3S'
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
Register-ScheduledTask "ExplorerConfig" -InputObject $task