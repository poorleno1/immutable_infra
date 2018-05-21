mkdir c:\tools\
(New-Object System.Net.WebClient).DownloadFile('https://download.sysinternals.com/files/SysinternalsSuite.zip', "c:\\tools\\SysinternalsSuite.zip")
Expand-Archive C:\tools\SysinternalsSuite.zip -DestinationPath C:\tools\
del c:\tools\SysinternalsSuite.zip
