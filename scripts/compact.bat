net stop wuauserv
rmdir /S /Q C:\Windows\SoftwareDistribution\Download
mkdir C:\Windows\SoftwareDistribution\Download
net start wuauserv

#choco install sdelete -y --ignore-checksums

cmd /c %SystemRoot%\System32\reg.exe ADD HKCU\Software\Sysinternals\SDelete /v EulaAccepted /t REG_DWORD /d 1 /f
cmd /c c:\tools\sdelete.exe -q -z C:
