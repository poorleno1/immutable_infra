netsh advfirewall add rule name="SMB" dir=in action=allow protocol=TCP localport=139
netsh advfirewall firewall add rule name="SMB" dir=in action=allow protocol=TCP localport=445
netsh advfirewall firewall add rule name="SMB" dir=in action=allow protocol=TCP localport=135
netsh advfirewall firewall add rule name="RPC_In" dir=in action=allow protocol=TCP localport=49152-65535