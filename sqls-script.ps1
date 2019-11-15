param
(
    [string] $hostname,
    [string] $protocol
)

#Step 1: Force TLS 1.2 to avoid network error
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Step 2: Install chocolatey
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

#Step 3: Install tools / software
#choco install sql-server-express -y -v
choco install sql-server-management-studio -y -v 

#Step 4: Enabling SQLServer default instance port 1433
New-NetFirewallRule -DisplayName "Allow inbound TCP Port 1433" –Direction inbound –LocalPort 1433 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow outbound TCP Port 1433" –Direction outbound –LocalPort 1433 -Protocol TCP -Action Allow

& ./config-script.ps1 $hostname $protocol
