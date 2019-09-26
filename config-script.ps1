winrm quickconfig -q

New-SMBShare –Name "Shared" –Path "D:\" –FullAccess "Everyone"

$url = "https://go.microsoft.com/fwlink/?LinkId=287166"
$output = "$PSScriptRoot\WebPlatformInstaller_amd64_en-US.msi"
$start_time = Get-Date

Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
C:\WebPlatformInstaller_amd64_en-US.msi /quiet

&"C:\Program Files\Microsoft\Web Platform Installer\WebpiCmd.exe" /Install /Products:WDeploy /AcceptEula
