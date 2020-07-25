#Requires -RunAsAdministrator

Write-Output "Registering tor as a service..."
tor --service install --options -f $env:LOCALAPPDATA\tor\torrc --allow-missing-torrc --HTTPTunnelPort 8118
