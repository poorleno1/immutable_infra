echo "Enabling LocalAccountTokenFilterPolicy"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f /v EnableLUA /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1
echo "Finished enabling LocalAccountTokenFilterPolicy"