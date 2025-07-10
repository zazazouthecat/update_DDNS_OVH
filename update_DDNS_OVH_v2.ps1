# === Paramètres utilisateur ===
$LOGIN_OVH = "IDENTIFIANT DYNHOST OVH"
$PWD_OVH = "MDP DYNHOST OVH"
$URL_OVH = "MONDOMAINE.OVH.FR"

# === Récupérer l'IP publique ===
try {
    $PublicIP = Invoke-RestMethod -Uri "https://ifconfig.me/ip"
    Write-Host "IP publique détectée : $PublicIP"
} catch {
    Write-Error "Impossible de récupérer l'adresse IP publique."
    exit 1
}

# === Construction de l'URL de mise à jour DynHost OVH ===
$DynHostURL = "https://www.ovh.com/nic/update?system=dyndns&hostname=$URL_OVH&myip=$PublicIP"
#debug
#write-host $DynHostURL
# === Authentification basique ===
$pair = "$LOGIN_OVH`:$PWD_OVH"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [Convert]::ToBase64String($bytes)
$headers = @{ Authorization = "Basic $base64" }

# === Envoi de la requête DynHost ===
try {
    $response = Invoke-WebRequest -Uri $DynHostURL -Headers $headers -UseBasicParsing
    Write-Host "Réponse OVH : $($response.Content)"
} catch {
    Write-Error "Erreur lors de la mise à jour DynHost : $($_.Exception.Message)"
    exit 1
}
