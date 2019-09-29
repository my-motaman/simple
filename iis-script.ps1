param
(
    [string] $hostname,
    [string] $protocol
)

Install-WindowsFeature -name Web-Server -IncludeManagementTools
Install-WindowsFeature Web-Asp-Net45
Install-WindowsFeature -Name Web-Mgmt-Service

& ./config-script.ps1 $hostname $protocol
