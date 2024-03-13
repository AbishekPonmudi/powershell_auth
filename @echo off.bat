@echo off
setlocal

:: Define variables
set "registryKey=HKCU\Software\MyApplication"
set "registryValueName=DisableCMD"
set "username=admin"
set "password=admin"

:: Function to set registry value
:SetRegistryValue
reg add "%registryKey%" /v "%registryValueName%" /t REG_DWORD /d 0 /f > nul 2>&1
if %errorlevel% neq 0 (
    echo Error setting registry value.
    exit /b 1
) else (
    echo Registry value set successfully.
)

:: Function to prompt for credentials
:PromptForCredentials
set /p "inputUsername=Enter your username: "
set /p "inputPassword=Enter your password: "
if "%inputUsername%"=="%username%" (
    if "%inputPassword%"=="%password%" (
        echo Authentication successful. Access granted.
        exit /b 0
    ) else (
        echo Authentication failed. Access denied.
        set /a "attempts+=1"
        if %attempts% geq 3 (
            echo Maximum attempts reached. Exiting script.
            exit /b 1
        )
        goto :PromptForCredentials
    )
) else (
    echo Authentication failed. Access denied.
    set /a "attempts+=1"
    if %attempts% geq 3 (
        echo Maximum attempts reached. Exiting script.
        exit /b 1
    )
    goto :PromptForCredentials
)
