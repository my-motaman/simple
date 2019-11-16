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
choco install googlechrome -y -v
choco install notepadplusplus -y -vv
choco install 7zip -y -v
choco install git -y -v
choco install nodejs -y -v
choco install jdk8 -y -v
choco install azurepowershell -y -v
choco install visualstudio2017enterprise -y -v
choco install vscode -y -v
choco install sql-server-management-studio -y -v
choco install pgadmin4 -y -v
choco install azure-cli -y -v 

#Step 4: Set build agent
$agentPool = "zz-it-pool"
$agentNamePrefix = "$env:computername-Agent-"
$agentSource = "$HOME\Downloads\vsts-agent-win-x64-2.158.0.zip"
$vstsUrl = "https://dev.azure.com/symphonyvsts-training"
$vstsToken = "n7m52vakh5dsqogzko34ompwy723vx3grvbqpet3g33ax2mu5gyq"
$agentUrl = "https://vstsagentpackage.azureedge.net/agent/2.160.0/vsts-agent-win-x64-2.160.0.zip"
$agentFilename = Split-Path $agentUrl -leaf
$agentSource = "$HOME\Downloads\$agentFilename"
$agentDestination = "C:\Work"
Write-Host $agentSource

Invoke-WebRequest -Uri "$agentUrl" -OutFile "$agentSource"

for($i=1; $i -le 1; $i++) {  
$agentName = "$agentNamePrefix$i"
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$agentSource", "$agentDestination\$agentName")
&"$agentDestination\$agentName\config.cmd" --unattended --url "$vstsUrl" --auth pat --token $vstsToken --pool $agentPool --agent $agentName --runAsService
Get-CimInstance win32_service -filter "name='vstsagent.symphonyvsts.$agentPool.$agentName'" | Invoke-CimMethod -Name Change -Arguments @{StartName="LocalSystem"}	
} 

& ./config-script.ps1 $hostname $protocol
