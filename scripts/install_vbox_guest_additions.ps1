Write-Host "Installing Guest Additions"


#Get-ChildItem E:/cert/ -Filter vbox*.cer | ForEach-Object {
#        E:/cert/VBoxCertUtil.exe add-trusted-publisher $_.FullName --root $_.FullName
#    }
#mkdir "C:/Windows/Temp/virtualbox" -ErrorAction SilentlyContinue

#if(Test-Path "e:/VBoxWindowsAdditions.exe") {
#	Write-Host "e:/VBoxWindowsAdditions.exe found."
#	Start-Process -FilePath "e:/VBoxWindowsAdditions.exe" -ArgumentList "/S" -WorkingDirectory "C:/Windows/Temp/virtualbox" -Wait
#}
#else
#{
#	Write-Host "e:/VBoxWindowsAdditions.exe not found."
#}
#Remove-Item C:/Windows/Temp/virtualbox -Recurse -Force




if(-not (Test-Path "C:\Windows\Temp\VBoxGuestAdditions.iso")) {
		#(New-Object System.Net.WebClient).DownloadFile('http://download.virtualbox.org/virtualbox/5.0.14/VBoxGuestAdditions_5.0.14.iso', 'C:\Windows\Temp\VBoxGuestAdditions.iso')
		#(New-Object System.Net.WebClient).DownloadFile('http://download.virtualbox.org/virtualbox/5.1.22/VBoxGuestAdditions_5.1.22.iso', 'C:\Windows\Temp\VBoxGuestAdditions.iso')
		(New-Object System.Net.WebClient).DownloadFile('http://download.virtualbox.org/virtualbox/5.2.0/VBoxGuestAdditions_5.2.0.iso', 'C:\Windows\Temp\VBoxGuestAdditions.iso')
        Write-Host "Iso file downloaded. Proceeding with installation."
        certutil -addstore -f "TrustedPublisher" A:\oracle-cert.cer
        #cinst 7zip.commandline -y
		
		
		Mount-DiskImage C:\Windows\Temp\VBoxGuestAdditions.iso
		$drive = (Get-DiskImage -ImagePath C:\Windows\Temp\VBoxGuestAdditions.iso | Get-Volume).DriveLetter
		$name = -join($drive,":")
		certutil -addstore -f "TrustedPublisher" $name\cert\vbox-sha1.cer
		certutil -addstore -f "TrustedPublisher" $name\cert\vbox-sha256.cer
		certutil -addstore -f "TrustedPublisher" $name\cert\vbox-sha256-r3.cer
		
		Write-Host "Starting installation."
        Start-Process -FilePath "$name\VBoxWindowsAdditions.exe" -ArgumentList "/S" -WorkingDirectory "C:\Windows\Temp\" -Wait
		Write-Host "Finishing installation. Unmounting ISO.."
        Dismount-DiskImage C:\Windows\Temp\VBoxGuestAdditions.iso
		
		
		##This is a working method using 7zip
        #."C:\ProgramData\chocolatey\lib\7zip.portable\tools\7z.exe" x C:\Windows\Temp\VBoxGuestAdditions.iso -oC:\Windows\Temp\vb
		#certutil -addstore -f "TrustedPublisher" C:\Windows\Temp\vb\cert\vbox-sha1.cer
		#certutil -addstore -f "TrustedPublisher" C:\Windows\Temp\vb\cert\vbox-sha256.cer
		#certutil -addstore -f "TrustedPublisher" C:\Windows\Temp\vb\cert\vbox-sha256-r3.cer
		#Write-Host "Starting installation."
        #Start-Process -FilePath "C:\Windows\Temp\vb\VBoxWindowsAdditions.exe" -ArgumentList "/S" -WorkingDirectory "C:\Windows\Temp\vb" -Wait
		#Write-Host "Finishing installation."
        #Remove-Item C:\Windows\Temp\vb -Recurse -Force
    }
else 
{
	Write-Host "ISO file already there ?? WTF."
}

Write-Host "Finished installing Guest Additions."