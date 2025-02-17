@echo off
setlocal

echo Stopping miner...
taskkill /F /IM t-rex.exe >nul 2>&1

echo Removing startup entry...
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\miner.lnk" >nul 2>&1

echo Deleting hidden miner files...
del "%APPDATA%\WindowsSystem\miner.bat" >nul 2>&1
del "%APPDATA%\WindowsSystem\run_hidden.vbs" >nul 2>&1

echo Removing hidden directory...
rmdir /S /Q "%APPDATA%\WindowsSystem" >nul 2>&1

echo Cleanup complete! The miner has been fully removed.
pause
exit
