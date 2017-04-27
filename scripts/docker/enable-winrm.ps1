Enable-PSRemoting -Force
winrm quickconfig -q
winrm quickconfig -transport:http
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="800"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'
# Set-Service winrm -startuptype "auto"
# Restart-Service winrm

#Write-Host "Install Containers"
#Install-WindowsFeature -Name Containers
if (Test-Path a:\oracle-cert.cer) {
  Write-Host "Skipping installation of Hyper-V in VirtualBox basebox"
} else {
  Write-Host "Install Hyper-V"
  Install-WindowsFeature -Name Hyper-V
  Install-WindowsFeature Hyper-V-Tools
}

Stop-Service winrm
. sc.exe config winrm start= delayed-auto

netsh advfirewall firewall set rule group="Windows Remote Administration" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=allow

Restart-Computer
