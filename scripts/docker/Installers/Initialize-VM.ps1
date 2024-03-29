################################################################################
##  File:  Initialize-VM.ps1
##  Desc:  VM initialization script, machine level configuration
################################################################################

function Get-WinVersion {
    (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
}

function Test-IsWin19 {
    (Get-WinVersion) -match "2019"
}

function Test-IsWin16 {
    (Get-WinVersion) -match "2016"
}


function Choco-Install {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $PackageName,
        [string[]] $ArgumentList,
        [int] $RetryCount = 5
    )

    process {
        $count = 1
        while ($true) {
            Write-Host "Running [#$count]: choco install $packageName -y $argumentList"
            choco install $packageName -y @argumentList

            $pkg = choco list --localonly $packageName --exact --all --limitoutput
            if ($pkg) {
                Write-Host "Package installed: $pkg"
                break
            }
            else {
                $count++
                if ($count -ge $retryCount) {
                    Write-Host "Could not install $packageName after $count attempts"
                    exit 1
                }
                Start-Sleep -Seconds 30
            }
        }
    }
}


function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force

    $ieProcess = Get-Process -Name Explorer -ErrorAction SilentlyContinue

    if ($ieProcess) {
        Stop-Process -Name Explorer -Force -ErrorAction Continue
    }

    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled."
}

function Disable-InternetExplorerWelcomeScreen {
    $AdminKey = "HKLM:\Software\Policies\Microsoft\Internet Explorer\Main"
    New-Item -Path $AdminKey -Value 1 -Force
    Set-ItemProperty -Path $AdminKey -Name "DisableFirstRunCustomize" -Value 1 -Force
    Write-Host "Disabled IE Welcome screen"
}

function Disable-UserAccessControl {
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000 -Force
    Write-Host "User Access Control (UAC) has been disabled."
}

# Set TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor "Tls12"

Write-Host "Disable Server Manager on Logon"
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask

Write-Host "Disable 'Allow your PC to be discoverable by other PCs' popup"
New-Item -Path HKLM:\System\CurrentControlSet\Control\Network -Name NewNetworkWindowOff -Force

Write-Host "Disable Antivirus"
Set-MpPreference -DisableRealtimeMonitoring $true

Write-Host "Disable Defender"
Uninstall-WindowsFeature -Name Windows-Defender

# Disable Windows Update
$AutoUpdatePath = "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
If (Test-Path -Path $AutoUpdatePath) {
    Set-ItemProperty -Path $AutoUpdatePath -Name NoAutoUpdate -Value 1
    Write-Host "Disabled Windows Update"
}
else {
    Write-Host "Windows Update key does not exist"
}

# Install .NET Framework 3.5 (required by Chocolatey)
# Explicitly install all 4.7 sub features to include ASP.Net.
# As of  1/16/2019, WinServer 19 lists .Net 4.7 as NET-Framework-45-Features
#Install-WindowsFeature -Name NET-Framework-Features -IncludeAllSubFeature
#Install-WindowsFeature -Name NET-Framework-45-Features -IncludeAllSubFeature
# if (Test-IsWin16) {
#     Install-WindowsFeature -Name BITS -IncludeAllSubFeature
#     Install-WindowsFeature -Name DSC-Service
# }

#Write-Host "Disable UAC"
#Disable-UserAccessControl

Write-Host "Disable IE Welcome Screen"
Disable-InternetExplorerWelcomeScreen

Write-Host "Disable IE ESC"
Disable-InternetExplorerESC

Write-Host "Setting local execution policy"
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine  -ErrorAction Continue | Out-Null
Get-ExecutionPolicy -List

Write-Host "Enable long path behavior"
# See https://docs.microsoft.com/en-us/windows/desktop/fileio/naming-a-file#maximum-path-length-limitation
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1

Write-Host "Install chocolatey"
$chocoExePath = 'C:\ProgramData\Chocolatey\bin'

if ($($env:Path).ToLower().Contains($($chocoExePath).ToLower())) {
    Write-Host "Chocolatey found in PATH, skipping install..."
    Exit
}

# Add to system PATH
$systemPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
$systemPath += ';' + $chocoExePath
[Environment]::SetEnvironmentVariable("PATH", $systemPath, [System.EnvironmentVariableTarget]::Machine)

# Update local process' path
$userPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
if ($userPath) {
    $env:Path = $systemPath + ";" + $userPath
}
else {
    $env:Path = $systemPath
}

# Run the installer
Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Turn off confirmation
choco feature enable -n allowGlobalConfirmation

# https://github.com/chocolatey/choco/issues/89
# Remove some of the command aliases, like `cpack` #89
if (test-path $env:ChocolateyInstall\bin\cpack.exe) {
    Remove-Item -Path $env:ChocolateyInstall\bin\cpack.exe -Force
}



# if (Test-IsWin16) {
#     # Install vcredist140
#     Choco-Install -PackageName vcredist140
# }

# if (Test-IsWin19) {
#     # Install vcredist2010
#     Choco-Install -PackageName vcredist2010
# }

Write-Host "Finished executing script Initializ-VM.ps1" -ForegroundColor Cyan

# Expand disk size of OS drive
#New-Item -Path d:\ -Name cmds.txt -ItemType File -Force
#Add-Content -Path d:\cmds.txt "SELECT VOLUME=C`r`nEXTEND"

#$expandResult = (diskpart /s 'd:\cmds.txt')
#Write-Host $expandResult

#Write-Host "Disk sizes after expansion"
#wmic logicaldisk get size, freespace, caption
