Write-Host "NGen: Microsoft.PowerShell.Utility.Activities"
Start-Process "$env:SystemRoot\Microsoft.NET\Framework64\v4.0.30319\ngen.exe" -ArgumentList "install", "Microsoft.PowerShell.Utility.Activities, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" -Wait -PassThru
#$null = & $env:SystemRoot\Microsoft.NET\Framework64\v4.0.30319\ngen.exe install "Microsoft.PowerShell.Utility.Activities, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
Write-Host "NGen: Framework64"
Start-process "$env:SystemRoot\Microsoft.NET\Framework64\v4.0.30319\ngen.exe" -ArgumentList "update" -Wait -PassThru
Write-Host "NGen: Framework"
Start-Process "$env:SystemRoot\Microsoft.NET\Framework\v4.0.30319\ngen.exe" -ArgumentList "update" -Wait -PassThru
