# update_DDNS_OVH


## 🖥️ Windows distribution 
✅ Windows 10  ✅ Windows 7   ✅ Windows Serveur 2016/2019

## PowerShell
✅ Version 2.0 et +

# 🏁 Installation 🏁

### Télécharger le script directement depuis :

https://git.io/JuQs0

### Editer les variables :
# Variables - Script
$WORK_DIR="C:\majip"

# Variables - OVH
$LOGIN_OVH = "LOGIN_OVH"
$PWD_OVH = "PASSWORD_OVH"
$URL_OVH = "DDNS.MYWEBSITE.COM"


### Créer une tache plannifée toutes les X minutes

powershell -Noninteractive -Noprofile -ExecutionPolicy ByPass -Command "C:\ENDROIT_DE_VOTRE_SCRIPT\update_DDNS_OVH.ps1"

