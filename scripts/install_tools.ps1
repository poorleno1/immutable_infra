if (!(test-path c:\temp)) { New-Item c:\temp -ItemType Directory }
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://download.sysinternals.com/files/SysinternalsSuite.zip -OutFile c:\temp\SysinternalsSuite.zip
Invoke-WebRequest -Uri https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml -OutFile c:\temp\sysmonconfig-export.xml
if (test-path C:\temp\SysinternalsSuite.zip -PathType Leaf ) { write-host "C:\temp\SysinternalsSuite.zip found.Extracting" -ForegroundColor Cyan; Expand-Archive C:\temp\SysinternalsSuite.zip -DestinationPath C:\Tools -Force }
else
{ write-host "C:\temp\SysinternalsSuite.zip not found." -ForegroundColor red }


# if (Test-Path c:\tools\sysmon.exe) {
#     Write-Host "c:\tools\sysmon.exe found." -ForegroundColor Cyan
# }
# else {
#     Write-Host "c:\tools\sysmon.exe not found." -ForegroundColor Red
#     break
# }
# if (Test-Path c:\temp\sysmonconfig-export.xml) {
#     Write-Host "Config c:\temp\sysmonconfig-export.xml found. Installing" -ForegroundColor Cyan
#     c:\tools\sysmon.exe -accepteula -i c:\temp\sysmonconfig-export.xml
# }
# else {
#     Write-Host "Config c:\temp\sysmonconfig-export.xml missing." -ForegroundColor Red
#     break
# }

if (!(test-path c:\temp)) { New-Item c:\temp -ItemType Directory } 
[xml]$XmlDocument = invoke-webrequest -Uri https://raw.githubusercontent.com/poorleno1/systemlocale/master/USRegion.xml -UseBasicParsing | Select-Object -ExpandProperty content
$XmlDocument.Save("c:\temp\USRegion.xml")
# Set Locale, language etc.
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"c:\temp\USRegion.xml`""
  
# Set Timezone
& tzutil /s "Central European Standard Time"
   
# Set languages/culture
Set-Culture en-US

Remove-Item c:\temp\USRegion.xml