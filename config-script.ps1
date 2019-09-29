param
(
    [string] $hostname,
    [string] $protocol
)
$winrmHttpsPort=5986

Set-Item wsman:\localhost\Client\TrustedHosts * -Force
Get-Item wsman:\localhost\Client\TrustedHosts

winrm set winrm/config '@{MaxEnvelopeSizekb = "8192"}'

#Configure-WinRMHttpsListener
#Delete-WinRMListener
$config = winrm enumerate winrm/config/listener
    foreach($conf in $config)
    {
        if($conf.Contains("HTTPS"))
        {
            winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
            break
        }
    }

# Create a test certificate
$thumbprint = (New-SelfSignedCertificate -DnsName $hostname -CertStoreLocation "cert:\LocalMachine\My").Thumbprint
if(-not $thumbprint)
{
    throw "Failed to create the test certificate."
}

# Configure WinRM
$WinrmCreate= "winrm create --% winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=`"$hostname`";CertificateThumbprint=`"$thumbprint`"}"
invoke-expression $WinrmCreate
winrm set winrm/config/service/auth '@{Basic="true"}'

netsh advfirewall firewall delete rule name="Windows Remote Management (HTTPS-In)" dir=in protocol=TCP localport=$winrmHttpsPort | Out-Null

netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=$winrmHttpsPort | Out-Null

winrm enumerate winrm/config/listener
