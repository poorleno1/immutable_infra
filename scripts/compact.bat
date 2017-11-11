

net stop wuauserv
rmdir /S /Q C:\Windows\SoftwareDistribution\Download
mkdir C:\Windows\SoftwareDistribution\Download
net start wuauserv

echo Compiling .net assemblies
%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\ngen.exe executequeueditems

choco install sdelete -y

cmd /c %SystemRoot%\System32\reg.exe ADD HKCU\Software\Sysinternals\SDelete /v EulaAccepted /t REG_DWORD /d 1 /f
REM cmd /c sdelete.exe -q -z C:
