Write-Host "Compiling .net assemblies"
%windir%\Microsoft.NET\Framework64\v2.0.50727\ngen.exe executeQueuedItems
%windir%\Microsoft.NET\Framework64\v4.0.30319\ngen.exe executequeueditems
%windir%\Microsoft.NET\Framework\v4.0.30319\ngen.exe executeQueuedItems
rem schTasks /run /Tn "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319"