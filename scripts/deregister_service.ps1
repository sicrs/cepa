#Requires -RunAsAdministrator

Write-Output "Deregistering the tor service..."
tor --service remove
