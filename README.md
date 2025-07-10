# update_DDNS_OVH


## 🖥️ Windows distribution 
✅ Windows 10 (v2.0) ✅ Windows 7 (V1.0)   ✅ Windows Serveur 2016/2019 (v2.0)

## PowerShell
✅ Version 2.0 et +

# 🏁 Installation 🏁

### Télécharger le script directement depuis :

V1.0
https://git.io/JuQs0

V2.0
https://github.com/zazazouthecat/update_DDNS_OVH/raw/refs/heads/main/update_DDNS_OVH_v2.ps1

### Editer les variables dans le script :

> `$WORK_DIR="C:\majip"`

> `$LOGIN_OVH = "LOGIN_OVH_DYNHOST"`

> `$PWD_OVH = "PASSWORD_OVH_DYNHOST"`

> `$URL_OVH = "DDNS.MYWEBSITE.COM"`


### Créer une tache plannifée toutes les X minutes

powershell -Noninteractive -Noprofile -ExecutionPolicy ByPass -Command "C:\ENDROIT_DE_VOTRE_SCRIPT\update_DDNS_OVH.ps1"

