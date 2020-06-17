# BERGEZ-CASALOU 
## Maitrise du poste TP1

* Self-footprinting
* Host OS

Get-computerInfo 
```bash
CsName                                                  : DESKTOP-I1SH0L8
```

```bash
WindowsProductName                                      : Windows 10 Pro
WindowsVersion                                          : 1903
```

```bash
CsSystemType                                            : x64-based PC
```

```bash
CsNumberOfProcessors                                    : 1
CsProcessors                                            : {Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz}
```
systeminfo
Get-CimInstance win32_physicalmemory
```bash
Mémoire physique totale:                    8 036 Mo

Manufacturer         : Kingston
```

* Devices

- CPU

systeminfo
```bash
Processeur(s):                              1 processeur(s) installé(s).
                                            [01] : Intel64 Family 6 Model 158 Stepping 10 GenuineIntel ~2201 MHz
```

wmic cpu get name
```bash
Name
Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz
```
je n'ai pas réussi a trouver son nom en command line mais je sais que le nom de la microarchitecture de mon proccesseur est ```coffee lake``` ce qui signifie qu'il est ``` manufactured on Intel's 3rd generation enhanced 14nm++ process``` (merci wikichip)


- enceintes integrés

Get-PnpDevice
```
Unknown    AudioEndpoint   SONY PJ (Son Intel(R) pour écrans)
```

- RAM

Get-WmiObject win32_physicalmemory | Format-Table Manufacturer,Banklabel,Configuredclockspeed,Devicelocator,Capacity,Serialnumber -autosize
```bash
Manufacturer Banklabel Configuredclockspeed Devicelocator    Capacity Serialnumber
------------ --------- -------------------- -------------    -------- ------------
Kingston     BANK 0                    2667 ChannelA-DIMM0 8589934592 091D9775
```

- marque, model et taille de mes disques

wmic diskdrive get model,serialNumber,size,mediaType
```bash
MediaType              Model                 SerialNumber     Size
Fixed hard disk media  WDC WD10SPZX-17Z10T0  WD-WXD1A489ESSE  1000202273280
Fixed hard disk media  SanDisk SD9SN8W256G   182281802072     256052966400
```

- taille de mes disques avec diskpart

list disk
```  N° disque  Statut         Taille   Libre    Dyn  GPT
  ---------  -------------  -------  -------  ---  ---
  Disque 0    En ligne        238 G octets      0 octets        *
  Disque 1    En ligne        931 G octets  1024 K octets        *
  ```

- mes partitions
Get-Partition
- dans mon ssd
```bash
PartitionNumber  DriveLetter Offset                                        Size Type
---------------  ----------- ------                                        ---- ----
1                            1048576                                     529 MB Recovery
2                            555745280                                   100 MB System
3                            660602880                                    16 MB Reserved
4                C           677380096                                203.66 GB Basic
5                            219360002048                              34.18 GB Unknown
```
1 : partition de récupération
2 : fichiers systeme
3 : réservé a windows
4 : en acces direct
5 : ubuntu (merci msi qui bloque le dual-boot)

- dans mon disque dur
```bash
PartitionNumber  DriveLetter Offset                                        Size Type
---------------  ----------- ------                                        ---- ----
1                D           1048576                                  921.51 GB Basic
2                A           989466722304                                 10 GB Basic
```
1 : les donnés de mon disque dur
2 : mes drivers 

Tout ce qui est est "basic" est ce qui est en acces direct

* Network

- liste des cartes réseaux

Get-NetAdapter | fl Name, InterfaceIndex
```bash
Name           : VirtualBox Host-Only Network #4
InterfaceIndex : 28

Name           : VirtualBox Host-Only Network
InterfaceIndex : 22

Name           : VirtualBox Host-Only Network #8
InterfaceIndex : 21

Name           : VirtualBox Host-Only Network #6
InterfaceIndex : 20

Name           : VMware Network Adapter VMnet1
InterfaceIndex : 19

Name           : VirtualBox Host-Only Network #5
InterfaceIndex : 17

Name           : VirtualBox Host-Only Network #7
InterfaceIndex : 15

Name           : Ethernet
InterfaceIndex : 11

Name           : VirtualBox Host-Only Network #2
InterfaceIndex : 10

Name           : VMware Network Adapter VMnet8
InterfaceIndex : 7

Name           : Wi-Fi
InterfaceIndex : 6

Name           : VirtualBox Host-Only Network #3
InterfaceIndex : 5

Name           : VirtualBox Host-Only Network #9
InterfaceIndex : 2
```

Name           : Wi-Fi
InterfaceIndex : 6
est mon interface wifi

Name           : Ethernet
InterfaceIndex : 11
est mon interface ethernet

les reste est pour mes VMs (faut que je fasse le tri)


- voir les pors tcp udp utilisés

netstat -abn
```bash
beaucoup trop de ports en utilisation
```


* Users

net user
```bash
comptes d’utilisateurs de \\DESKTOP-I1SH0L8

-------------------------------------------------------------------------------
Administrateur           DefaultAccount           Invité
Malory                   WDAGUtilityAccount       YNOV01
YNOV02                   YNOV03                   YNOV04
YNOV05                   YNOV06                   YNOV07
YNOV08                   YNOV09                   YNOV10
YNOV11                   YNOV12                   YNOV13
YNOV14                   YNOV15                   YNOV16
YNOV17                   YNOV18                   YNOV19
YNOV20
La commande s’est terminée correctement.
```
l'admin est "Administrateur"

* Processus

tasklist
```bash
KillerControlCenter.exe      12988 Console                    1   110 064 Ko
Dragon Center.exe            14096 Console                    1    17 292 Ko
firefox.exe                   7880 Console                    1   366 424 Ko
Discord.exe                  12456 Console                    1    66 524 Ko
Code.exe                     10828 Console                    1   121 740 Ko
```
KillerControlCenter.exe : ma carte ethernet
Dragon Center.exe : l'app qui gere mes perf msi
firefox.exe : pas besoin d'expliquer je pense
Discord.exe : pareil
Code.exe : Visual Studio Code

* Scripting
1er
```ps1
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
```


2eme
```ps1
Start-Sleep -s 10
Restart-Computer
```


* Gestion de soft

- pertinence d'utiliser un gestionnaire de paquets :
Pouvoir télécharger des dizaines de paquets simplement, voir tout ce qui est installé lors de l'installation

- Utiliser un gestionnaire de paquet propres à votre OS pour
lister tous les paquets déjà installés

choco list -li
```bash
Chocolatey v0.10.15
chocolatey 0.10.15
1 packages installed.

Active Directory Authentication Library pour SQL Server|14.0.800.90
Adobe Creative Cloud|5.1.0.407
Amazon Redshift ODBC Driver 64-bit|1.3.7.1000
Assistant de téléchargement|6.70.0
Battery Calibration|1.0.1609.1901
Browser pour SQL Server 2016|13.1.4001.0
CodeBlocks|17.12
Discord|0.0.306
Dragon Center|2.1.1804.1102
EasyBCD 2.4|2.4
Enregistreur VSS Microsoft pour SQL Server 2016|13.1.4001.0
Fichiers de support d'installation de Microsoft SQL Server 2008|10.3.5500.0
GanttProject|
Git version 2.23.0.windows.1|2.23.0.windows.1
GNS3|2.2.5
Google Chrome|81.0.4044.138
Installation de Microsoft SQL Server 2016 (Français)|13.1.4001.0
Java 8 Update 241 (64-bit)|8.0.2410.7
Microsoft .NET Framework 4.5 Multi-Targeting Pack|4.5.50710
Microsoft .NET Framework 4.5.1 Multi-Targeting Pack|4.5.50932
Microsoft .NET Framework 4.5.1 Multi-Targeting Pack (Français)|4.5.50932
Microsoft .NET Framework 4.5.1 SDK|4.5.51641
Microsoft .NET Framework 4.5.1 SDK (Français)|4.5.51641
Microsoft .NET Framework 4.5.2 Multi-Targeting Pack|4.5.51209
Microsoft .NET Framework 4.5.2 Multi-Targeting Pack (Français)|4.5.51209
Microsoft Help Viewer 1.1|1.1.40219
Microsoft Help Viewer 1.1 Language Pack - FRA|1.1.40219
Microsoft Help Viewer 2.2|2.2.23107
Microsoft MPI (7.0.12437.8)|7.0.12437.8
Microsoft ODBC Driver 13 for SQL Server|14.0.800.90
Microsoft ODBC Driver 17 for SQL Server|17.1.0.1
Microsoft Office 365 ProPlus - fr-fr|16.0.12527.20442
Microsoft OneDrive|19.232.1124.0012
Microsoft SQL Server 2012 Native Client |11.3.6518.0
Microsoft SQL Server 2016 T-SQL Language Service |13.0.14500.10
Microsoft SQL Server 2017 RC1|
Microsoft SQL Server Data-Tier Application Framework (x86) - fr-FR|14.0.3757.2
Microsoft SQL Server Management Studio - 17.2|14.0.17177.0
Microsoft SQL Server 2014 Management Objects |12.0.2000.8
Microsoft SQL Server 2016 (64 bits)|
Microsoft SQL Server 2016 T-SQL ScriptDom|13.1.4001.0
Microsoft System CLR Types pour SQL Server 2017 RC1|14.0.800.90
Microsoft System CLR Types pour SQL Server 2014|12.0.2402.11
Microsoft Teams|1.3.00.12058
Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.6161|9.0.30729.6161
Microsoft Visual C++ 2010  x64 Redistributable - 10.0.40219|10.0.40219
Microsoft Visual C++ 2010  x86 Redistributable - 10.0.40219|10.0.40219
Microsoft Visual C++ 2012 Redistributable (x64) - 11.0.61030|11.0.61030.0
Microsoft Visual C++ 2012 Redistributable (x86) - 11.0.61030|11.0.61030.0
Microsoft Visual C++ 2013 Redistributable (x64) - 12.0.21005|12.0.21005.1
Microsoft Visual C++ 2013 Redistributable (x64) - 12.0.40660|12.0.40660.0
Microsoft Visual C++ 2013 Redistributable (x86) - 12.0.21005|12.0.21005.1
Microsoft Visual C++ 2013 Redistributable (x86) - 12.0.40660|12.0.40660.0
Microsoft Visual C++ 2015-2019 Redistributable (x64) - 14.24.28127|14.24.28127.4
Microsoft Visual C++ 2015-2019 Redistributable (x86) - 14.23.27820|14.23.27820.0
Microsoft Visual Studio Code (User)|1.45.0
Module linguistique Microsoft Help Viewer 2.2 - FRA|2.2.23107
Mozilla Firefox 75.0 (x64 fr)|75.0
Mozilla Maintenance Service|69.0
MSI Interceptor DS100 Gaming Mouse|1.1
MySQL Connector/ODBC 8.0|8.0.19
Nmap 7.80|7.80
Notepad++ (32-bit x86)|7.8.1
Npcap 0.9983|0.9983
NVIDIA Logiciel système PhysX 9.19.0218|9.19.0218
NVIDIA Pilote graphique 436.15|436.15
Oracle VM VirtualBox 6.0.14|6.0.14
Prise en charge linguistique de Microsoft Visual Studio Tools for Applications 2015|14.0.23107.20
psqlODBC_x64|09.06.0504
Python 3.7.4 (64-bit)|3.7.4150.0
Python Launcher|3.7.6762.0
Service de langage T-SQL Microsoft SQL Server 2017 RC1|14.0.17177.0
Stratégies Microsoft SQL Server 2017 RC1|14.0.800.90
Tableau 2019.3 (20193.19.1211.1636)|19.3.735
Talend Open Studio|
Teams Machine-Wide Installer|1.2.0.22654
Wampserver64 3.2.0|3.2.0
WinRAR 5.71 (64-bit)|5.71.0
Wireshark 3.0.6 64-bit|3.0.6
XAMPP|7.4.5-0
XMind ZEN 9.3.1|9.3.1
81 applications not managed with Chocolatey.
```

* Partage de fichiers

* Chiffrement et notion de confiance
- Expliquer en détail l'utilisation de certificats
Un certificat transporte l'identité d'une personne,c'est son information principale, elle chiffre aussi des échanges

* Chiffrement de mails
j'utilise protonmail donc mes mails sont deja chiffrés


* TLS
HTTP sert juste à afficher des informations ce qui signifie que les informations peuvent etre interceptés, le "S" de HTTPS signifie "secure" il fonctionne grace au protocole TLS pour établir une connexion chiffrée entre un serveur web et un navigateur, donc le HTTPS est plus avancé et plus sécurisé

* Client
- Clés générés : clé publique et privée
- on dépose la clé publique, on ne dévoile jamais sa clé privée
- Chiffrer le contenu







