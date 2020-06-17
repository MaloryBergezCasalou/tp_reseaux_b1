echo "Nom de la machine : $env:COMPUTERNAME" 
echo "Adress IP principal : "
Get-NetIPAddress -InterfaceIndex 23 | Format-Table
echo "OS : $env:OS" 
echo "Version de l'OS : $((Get-CimInstance Win32_OperatingSystem).version)"  
echo "Uptime : $((get-date) - $((gcim Win32_OperatingSystem)).LastBootUpTime)"
echo "Is OS up-to-date : "
echo "RAM : " 
echo "Utilisation : "
echo "Espace libre : $(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | Foreach {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))})"
echo "Espace disque"
echo "Espace disque utilise : "
gwmi win32_logicaldisk | Format-Table DeviceId, @{n="Size";e={[math]::Round($_.Size/1GB,2)}},@{n="UsedSpace";e={[math]::Round(($_.Size-$_.FreeSpace)/1GB,2)}}
echo "Espace disque dispo : "
gwmi win32_logicaldisk | Format-Table DeviceId, @{n="Size";e={[math]::Round($_.Size/1GB,2)}},@{n="FreeSpace";e={[math]::Round($_.FreeSpace/1GB,2)}}
echo "Liste des Utilisateur : "
Get-LocalUser | Format-Table
ping 8.8.8.8