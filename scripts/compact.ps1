$ErrorActionPreference = "Stop"
. a:/Test-Command.ps1


$pause_time = 120

Write-Host "Waiting to finish possible updates for $pause_time seconds."
Start-Sleep -s $pause_time

Write-Host "Cleaning SxS..."
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

# @(
#     "$env:localappdata\Nuget",
#     "$env:localappdata\temp\*",
#     "$env:windir\logs",
#     "$env:windir\panther",
#     "$env:windir\temp\*",
#     "$env:windir\winsxs\manifestcache",
#     "$env:TEMP"
#     "c:\TEMP"
# ) | % {
#     if (Test-Path $_) {
#         Write-Host "Removing $_"
#         try {
#             Takeown /d Y /R /f $_
#             Icacls $_ /GRANT:r administrators:F /T /c /q  2>&1 | Out-Null
#             Remove-Item $_ -Recurse -Force | Out-Null 
#         }
#         catch { $global:error.RemoveAt(0) }
#     }
# }

	
Write-Host "Removing Page File."
$pageFileMemoryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
Set-ItemProperty -Path $pageFileMemoryKey -Name PagingFiles -Value ""

Write-Host "defragging..."
if (Test-Command -cmdname 'Optimize-Volume') {
    Optimize-Volume -DriveLetter C
}
else {
    Defrag.exe c: /H
}

Write-Host "0ing out empty space..."
$FilePath = "c:\zero.tmp"
$Volume = Get-WmiObject win32_logicaldisk -filter "DeviceID='C:'"
$ArraySize = 64kb
$SpaceToLeave = $Volume.Size * 0.05
$FileSize = $Volume.FreeSpace - $SpacetoLeave
$ZeroArray = new-object byte[]($ArraySize)
 
$Stream = [io.File]::OpenWrite($FilePath)
try {
    $CurFileSize = 0
    while ($CurFileSize -lt $FileSize) {
        $Stream.Write($ZeroArray, 0, $ZeroArray.Length)
        $CurFileSize += $ZeroArray.Length
    }
}
finally {
    if ($Stream) {
        $Stream.Close()
    }
}

Del $FilePath


Write-Host "Disable automatic updates" -ForegroundColor Cyan
$p = Start-Process "C:\Windows\System32\cscript.exe" -ArgumentList "C:\windows\System32\SCregEdit.wsf /AU 1" -Wait -PassThru

Write-Host "exit code is: $($p.ExitCode)"


# Write-Host "Setting time zone"

 
# if (!(test-path c:\temp)) { New-Item c:\temp -ItemType Directory } 
# [xml]$XmlDocument = invoke-webrequest -Uri https://raw.githubusercontent.com/poorleno1/systemlocale/master/USRegion.xml -UseBasicParsing | Select-Object -ExpandProperty content
# $XmlDocument.Save("c:\temp\USRegion.xml")
# # Set Locale, language etc.
# & $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"c:\temp\USRegion.xml`""
  
# # Set Timezone
# & tzutil /s "Central European Standard Time"
   
# # Set languages/culture
# Set-Culture en-US