###############################
## Script Update_DDNS_OVH.ps1
## Auth : The Nerd Cat
## Date : 09/2021
################################

# Variables - Script
$WORK_DIR="C:\majip"

# Variables - OVH
$LOGIN_OVH = "LOGIN_OVH"
$PWD_OVH = "PASSWORD_OVH"
$URL_OVH = "DDNS.MYWEBSITE.COM"

# Variables - IP Wan
$url = "http://ifconfig.me/ip"
$webclient = new-object System.Net.WebClient
$WANIP = [IPAddress]$webclient.DownloadString($url)

# Variables - Crendenital OVH
$securepasswd = ConvertTo-SecureString $PWD_OVH -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($LOGIN_OVH, $securepasswd)
$wc = New-Object system.Net.WebClient;
$credCache = new-object System.Net.CredentialCache
$creds = new-object System.Net.NetworkCredential($LOGIN_OVH,$PWD_OVH)

# Regex IP
$pattern = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"



# On Vérifie l'espace de travail
if(Test-Path $WORK_DIR){
   Write-Host "L'espace de travail ok"
}else{
   Write-Host "L'espace de travail n'existe pas"
   # Création de l'espace de travail
   New-Item $WORK_DIR -itemType Directory

   New-Item -Path $WORK_DIR\maj_ip.txt -ItemType File
   echo '0.0.0.0' | Out-File -FilePath $WORK_DIR\maj_ip.txt -Encoding ASCII -Force
   
}

# On Vérifie que le format ip récupéré est correct
If ($WANIP -match $pattern)
{
	# On essaye d'accéder au fichier maj_ip.txt
	Try { Get-ChildItem $WORK_DIR\"maj_ip.txt" -ErrorAction Stop > $null }
	# Si il existe, on récupère l'ip déjà présente dans le fichier maj_ip.txt
	Catch { Write-Output $WANIP > $WORK_DIR\maj_ip.txt }
	[IPAddress]$IP = Get-Content $WORK_DIR\maj_ip.txt 
	# On check si l'adresse ip a changée, Inutile d'appeler la page web OVH toutes les X minustes si l'ip est inchangée.
	If ([IPAddress]$WANIP -eq [IPAddress]$IP)
	{
		Write-Host "Votre adresse ip n'a pas changée."
	}
	Else
	{
		Write-Host "** Votre adresse ip à changée **"
		Write-Host "Mise à jour de votre nouvelle ip chez OVH"
        
        $credCache.Add("https://${LOGIN_OVH}:${PWD_OVH}@www.ovh.com/nic/update?myip=${WANIP}&hostname=${URL_OVH}&system=dyndns", "Basic", $creds)
        $wc.Credentials = $credCache
        $majurl="https://${LOGIN_OVH}:${PWD_OVH}@www.ovh.com/nic/update?myip=${WANIP}&hostname=${URL_OVH}&system=dyndns"
        write-host $majurl
        $wc.downloadString($majurl)
		
		# On enregistre la nouvelle ip dans le fichier maj_ip.txt
		Write-Output $WANIP.IPAddressToString > $WORK_DIR\maj_ip.txt 

	}
}
Else
{
	# Problème avec le format d'ip récupéré
	Write-Host "Impossible de récupérer votre adresse IP Public"
}
