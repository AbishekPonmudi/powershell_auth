
# Windows Powershell authenticator

The Windows Authenticator is a security script designed to provide an additional layer of authentication for Windows PowerShell and Command Prompt users. It ensures advanced-level security by authenticating users before granting access to sensitive operations or resources.

Why Windows Authenticator?
While Windows is generally considered secure, it may lack some of the authentication features commonly found in Linux systems, such as the sudo command. The Windows Authenticator addresses this gap by introducing an authentication mechanism similar to the one found in Linux systems, ensuring enhanced security and user control.

# let's discuss How It Works ?

• Registry Configuration: The script sets a registry key to control access to PowerShell and Command Prompt.

• User Authentication: Users are prompted to enter their credentials when attempting to access PowerShell or Command Prompt.

• Credential Validation: The entered credentials are validated against predefined username and password variables.

• Access Granting: If the credentials match, access to PowerShell and Command Prompt is granted. Otherwise, access is denied.


This is mainly used for secure authentication and secure from unauthorished usages within the administration previlages , which secures from reverse shell and even powershell related backdoor , 

which is further integrated with reverse shell detection, ssh authentication and further related to powershell acticity , if the reverse shell , ssh detected it ask user credintial to login which act like a security guard for the powershell even it is not accessable even it hacked.

And lot understanble while using .




## Installation

for more information first Run the 'install.bat' , first save and navigate into the location of the folder in my case : 

```bash
 C:\Users\Abishek\Desktop\powershell project>
 C:\Users\path\Desktop\powershell project>
            |
        Add your path
```

```bash
./install.bat

```

powershell Installation or manuallly installing either a choice


For uninstall this authenticator Simply run this application either powershell or manuallly

```bash
./uninstall.bat
```

This feature may not applicable with windows 10 and below that so then after installation run this command whether using windows 10 or below that

```bash
./preview_auth.bat

```



    
## code preview 

change the username and password on the ``` popup.ps1``` script
```bash
change username 
change passowrd
```

```powershell
# Define variables
$registryKey = "HKCU:\Software\MyApplication"
$registryValueName = "DisableCMD"
$username = "username"--->    #change the username for your desire
$password = "password"--->    #change the password for your desire

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
    # Prompt user for credentials
    $credential = Get-Credential -Message "Enter your credentials"

    # Check if the user canceled the prompt
    if ($credential -eq $null) {
        Write-Host "Credential prompt canceled. PowerShell remains usable."
        Close-PowerShellWindow
    }

    # Validate user credentials
    elseif ($credential.UserName -eq $username -and $credential.GetNetworkCredential().Password -eq $password) {
        Write-Host "Authentication successful. Access granted."
        return $true
    } else {
        Write-Host "Authentication failed. Access denied."
        return $false
    }
}

# Enable command prompt and PowerShell with user authentication
try {
    # Set registry value to enable command prompt
    Set-RegistryValue -Key $registryKey -ValueName $registryValueName -ValueData 0

    $authenticated = $false
    $attempts = 0

    while (-not $authenticated) {
        $authenticated = Prompt-ForCredentials

        # Increment attempt count if authentication fails
        if (-not $authenticated) {
            $attempts++
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


```


## Video reference


[![Alt text](https://img.youtube.com/vi/x5J5b6u99pM/0.jpg)](https://www.youtube.com/watch?v=x5J5b6u99pM)

## Related

Here are some related projects

[Awesome README](https://www.bing.com/ck/a?!&&p=6b8285be0210fe7dJmltdHM9MTcwNzc4MjQwMCZpZ3VpZD0yZDJiMWM2ZS1kOGI0LTYzMWYtMDVmZi0wZmI1ZDkxOTYyOTYmaW5zaWQ9NTI1NA&ptn=3&ver=2&hsh=3&fclid=2d2b1c6e-d8b4-631f-05ff-0fb5d9196296&psq=powershell+authenticator&u=a1aHR0cHM6Ly9sZWFybi5taWNyb3NvZnQuY29tL2VuLXVzL3Bvd2Vyc2hlbGwvbWljcm9zb2Z0Z3JhcGgvYXV0aGVudGljYXRpb24tY29tbWFuZHM_dmlldz1ncmFwaC1wb3dlcnNoZWxsLTEuMA&ntb=1)

