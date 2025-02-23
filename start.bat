@echo off
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1
net config server /srvcomment:"Windows Server 2019 By administrator " > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d D:\a\wallpaper.bat
net user administrator OLDUSER#6 /add >nul
net localgroup administrators administrator /add >nul
net user administrator /active:yes >nul
net user installer /delete
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul
ICACLS C:\Windows\Temp /grant administrator:F >nul
ICACLS C:\Windows\installer /grant administrator:F >nul

echo Successfully installed! If RDP is dead, rebuild again.

:: Wait a few seconds to let ngrok initialize
ping -n 10 127.0.0.1 >nul

:: Retrieve public URL from ngrok API using curl and jq
for /f "delims=" %%i in ('curl -s localhost:4040/api/tunnels ^| jq -r .tunnels[0].public_url') do set PUBLIC_URL=%%i

if defined PUBLIC_URL (
    echo IP: %PUBLIC_URL%
) else (
    echo Failed to retrieve ngrok public URL - check your authtoken and ngrok status.
)

echo Username: administrator 
echo Password: OLDUSER#6
echo You can login now
ping -n 10 127.0.0.1 >nul
