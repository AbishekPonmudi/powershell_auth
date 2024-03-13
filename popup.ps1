# Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrative privileges. Please run PowerShell as administrator."
    Exit
}

# Check if the script is running in non-administration mode (based on user input from install.bat)
$executeMode = $args[0]

# If the script is running in non-administration mode, do something specific
if ($executeMode -eq "0") {
    Write-Host "Running in administration mode."
    # You can add non-administrative specific functionality here
}

# If the script is running in administration mode (1), or the user chose non-administration mode (0) and entered credentials
if ($executeMode -eq "1" -or $executeMode -eq "0") {
    # Define variables
    $registryKey = "HKCU:\Software\MyApplication"
    $registryValueName = "DisableCMD"

    # Function to set registry value
    function Set-RegistryValue {
        param (
            [string]$key,
            [string]$valueName,
            [int]$valueData
        )

        try {
            # Check if the registry key exists, if not, create it
            if (-not (Test-Path -Path $key)) {
                New-Item -Path $key -Force | Out-Null
            }

            Set-ItemProperty -Path $key -Name $valueName -Value $valueData -ErrorAction Stop
            Write-Host "Registry value set successfully."
        } catch {
            Write-Host "Error setting registry value: $_"
        }
    }

    # Function to close the PowerShell window
    function Close-PowerShellWindow {
        $host.SetShouldExit(0)
    }

    # Function to prompt for credentials
    function Prompt-ForCredentials {
        param (
            [int]$attempt
        )

        # Get the directory where the script is located using $PSScriptRoot
        $scriptDirectory = $PSScriptRoot

        # Construct the path to the credentials file relative to the script's location
        $credentialsFile = Join-Path -Path $scriptDirectory -ChildPath "credentials.xml"

        # Load credentials from XML file
        try {
            $xml = [xml](Get-Content $credentialsFile)
            $storedUsername = $xml.credentials.username
            $storedPassword = $xml.credentials.password

            # Prompt user for credentials
            if ($attempt -lt 3) {
                $usernameInput = Read-Host "Enter your username"
                $passwordInput = Read-Host -Prompt "Enter your password" -AsSecureString
                $credential = New-Object System.Management.Automation.PSCredential ($usernameInput, $passwordInput)
            } else {
                $credential = Get-Credential -Message "Enter your credentials"
            }

            # Check if the user canceled the prompt
            if ($credential -eq $null) {
                Write-Host "Credential prompt canceled. PowerShell remains usable."
                Close-PowerShellWindow
            }

            # Validate user credentials
            elseif (($credential.UserName -eq $storedUsername) -and ($credential.GetNetworkCredential().Password -eq ($storedPassword))) {
                Write-Host "Authentication successful. Access granted."
                return $true
            } else {
                Write-Host "Authentication failed. Access denied."
                return $false
            }
        } catch {
            Write-Host "Error occurred while loading credentials: $_"
        }
    }

    # Enable command prompt and PowerShell with user authentication
    try {
        # Set registry value to enable command prompt
        Set-RegistryValue -Key $registryKey -ValueName $registryValueName -ValueData 0

        $authenticated = $false
        $attempts = 0

        while (-not $authenticated) {
            $authenticated = Prompt-ForCredentials -attempt $attempts

            # Increment attempt count if authentication fails
            if (-not $authenticated) {
                $attempts++
                if ($attempts -ge 3) {
                    Write-Host "Maximum attempts reached. Opening popup window for credential entry."
                    $authenticated = Prompt-ForCredentials -attempt $attempts
                }
                if ($attempts -ge 3) {
                    Write-Host "Maximum attempts reached. Exiting script."
                    Close-PowerShellWindow
                }
            }
        }

        # Additional operations can be performed here if needed after successful authentication

    } catch {
        Write-Host "Error occurred: $_"
    }
}
