# === Paramètres utilisateur ===
$LOGIN_OVH = "IDENTIFIANT DYNHOST OVH"
$PWD_OVH   = "MDP DYNHOST OVH"
$URL_OVH   = "MONDOMAINE.OVH.FR"

# Fonction pour récupérer une IP en testant plusieurs services
function Get-IPv6 {
    $services = @(
        "https://ident.me/ipv6",
        "https://ifconfig.co/ip"
    )

    foreach ($s in $services) {
        try {
            $ip = Invoke-RestMethod -Uri $s -TimeoutSec 5
            if ($ip -match ":") { return $ip }  # Confirmation IPv6
        } catch { continue }
    }
    return $null
}

function Get-IPv4 {
    $services = @(
        "https://ifconfig.me/ip",
        "https://ident.me"
    )

    foreach ($s in $services) {
        try {
            $ip = Invoke-RestMethod -Uri $s -TimeoutSec 5
            if ($ip -match "^\d{1,3}(\.\d{1,3}){3}$") { return $ip }
        } catch { continue }
    }
    return $null
}

# === Tentative IPv6 ===
$PublicIP = Get-IPv6

if ($PublicIP) {
    Write-Host "IPv6 détectée : $PublicIP"
} else {
    Write-Warning "IPv6 inaccessible, bascule vers IPv4..."
    $PublicIP = Get-IPv4

    if ($PublicIP) {
        Write-Host "IPv4 détectée : $PublicIP"
    } else {
        Write-Error "Impossible de déterminer l'adresse IP publique (IPv6 ou IPv4)."
        exit 1
    }
}

# === Construction URL DynHost OVH ===
$DynHostURL = "https://dns.eu.ovhapis.com/nic/update?system=dyndns&hostname=$URL_OVH&myip=$PublicIP"

# === Authentification basique ===
$pair = "$LOGIN_OVH`:$PWD_OVH"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [Convert]::ToBase64String($bytes)
$headers = @{ Authorization = "Basic $base64" }

# === Envoi requête DynHost ===
try {
    $response = Invoke-WebRequest -Uri $DynHostURL -Headers $headers -UseBasicParsing
    Write-Host "Réponse OVH : $($response.Content)"
} catch {
    Write-Error "Erreur durant la mise à jour DynHost : $($_.Exception.Message)"
    exit 1
}
