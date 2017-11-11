mkdir c:\tools\	
Start-BitsTransfer -Source "https://download.sysinternals.com/files/SysinternalsSuite.zip" -Description C:\tools\
Expand-Archive C:\tools\SysinternalsSuite.zip -DestinationPath C:\tools\
del c:\tools\SysinternalsSuite.zip
