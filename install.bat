@echo off
setlocal

:: Set the name of the PowerShell script file
set "ps_script_name=popup.ps1"

:: Prompt user for username
set /p username=Enter username: 

:: Prompt user for password
set /p password=Enter password: 

:: Save username and password to XML file
(
  echo ^<credentials^>
  echo    ^<username^>%username%^</username^>
  echo    ^<password^>%password%^</password^>
  echo ^</credentials^>
) > credentials.xml

:: Prompt the user to choose whether to apply credentials for administration only
set /p apply_admin=Apply for ADMINISTRATION (Press 1) OR WHOLE POWERSHELL (Press 0): 

:: Ensure the directory structure exists for PowerShell profile script
mkdir "%USERPROFILE%\Documents\WindowsPowerShell" 2>nul

:: Set the PowerShell profile script path
set "profile_script=%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

:: Set the full path to the PowerShell script
set "ps_script_path=%~dp0%ps_script_name%"

:: Add the command to run the PowerShell script with the chosen execution mode to the profile script
echo . '%ps_script_path%' %apply_admin% >> "%profile_script%"

:: Notify the user about the setup
echo PowerShell startup script has been configured.
echo Your PowerShell profile script is located at: %profile_script%

:: Pause to allow the user to see the message
pause
