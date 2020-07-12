param (
		[string]$do
	  )

function Add-TorPath {
	Set-Item -Path Env:Path -Value ($env:Path + (";" + $env:LOCALAPPDATA + "\tor\Tor"))
}

function Install-Tor {
	if(Test-Path $env:LOCALAPPDATA\tor -PathType Container) {
		Write-Output "Removing old dir"
		Remove-Item -Path $env:LOCALAPPDATA\tor
	}
	try {
		Write-Output "Downloading latest expert-bundle binary..."
		Invoke-WebRequest -Uri "https://www.torproject.org/dist/torbrowser/9.5.1/tor-win32-0.4.3.5.zip" -Outfile "bin.zip"
		Write-Output "Finished downloading."
		Write-Output "Unzipping"
		Expand-Archive -Path "bin.zip" -DestinationPath $env:LOCALAPPDATA\tor
		Write-Output "Finished unzipping"
		Remove-Item -Path bin.zip
	}
	catch {
		Write-Error ("Oof: " + $Error)
	}
}

function Start-Tor {
	Write-Output "Starting tor..."
	tor --service start 
}

function Stop-Tor {
	Write-Output "Stopping tor..."
	tor --service stop
}

function Register-Tor {
	.\scripts\register_service.ps1 
}

function Deregister-Tor {
	.\scripts\deregister_service.ps1 
}

if ($do -eq "") {
	# default: check if binaries are found
	if (Test-Path $env:LOCALAPPDATA\tor -PathType Container) {
		# found, therefore run
			
	} else {
		Install-Tor
	}
	Add-TorPath
	# Start-Tor
	tor -f $env:LOCALAPPDATA\tor\torrc --allow-missing-torrc
} else {
	Add-TorPath

	if ($do -eq "start") {
		Start-Tor
	} elseif ($do -eq "stop") {
		Stop-Tor
	} elseif ($do -eq "register") {
		Register-Tor
	} elseif ($do -eq "deregister") {
		Deregister-Tor
	} elseif ($do -eq "hard-start") {
		tor -f $env:LOCALAPPDATA\tor\torrc --allow-missing-torrc
	} elseif ($do -eq "install") {
		Install-Tor
	} elseif ($do -eq "help") {
		Write-Output "
Syntax: powershell .\cepa.ps1 [-do <action>]
action:
	start: start tor as a service
	stop: stop tor (service)
	hard-start: start tor in the same command window
	register: register tor as a service (Requires admin privileges) (currently not working) 
	deregister: deregister tor as a service (Requires admin privileges) (currently not working)
	install: install
	help: show this message
		"
	} else {
		Write-Error ("Invalid action: " + $do)
	}
}
