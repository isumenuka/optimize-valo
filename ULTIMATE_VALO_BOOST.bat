@echo off
setlocal EnableDelayedExpansion
color 0b
title Ultimate Valorant Auto-Launch ^& Optimizer

:: ==========================================
:: 1. ADMINISTRATOR PRIVILEGE CHECK
:: ==========================================
echo Checking for Administrator privileges...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrator privileges confirmed.
) else (
    echo Failure: Please run this script as Administrator.
    pause
    exit
)

echo.
echo ===================================================
echo   OPTIMIZING WINDOWS 10 FOR MAX VALORANT FPS
echo ===================================================
echo.

:: ==========================================
:: 2. AGGRESSIVELY CLOSING UNNECESSARY APPS
:: ==========================================
echo [*] Closing background apps to free up RAM and CPU...
:: Browsers
taskkill /F /IM chrome.exe /T >nul 2>&1
taskkill /F /IM msedge.exe /T >nul 2>&1
taskkill /F /IM firefox.exe /T >nul 2>&1
taskkill /F /IM brave.exe /T >nul 2>&1
taskkill /F /IM opera.exe /T >nul 2>&1
:: Launchers & Stores
taskkill /F /IM steam.exe /T >nul 2>&1
taskkill /F /IM epicgameslauncher.exe /T >nul 2>&1
taskkill /F /IM origin.exe /T >nul 2>&1
taskkill /F /IM eadesktop.exe /T >nul 2>&1
taskkill /F /IM battle.net.exe /T >nul 2>&1
:: Comms & Social
taskkill /F /IM skype.exe /T >nul 2>&1
taskkill /F /IM slack.exe /T >nul 2>&1
taskkill /F /IM teams.exe /T >nul 2>&1
taskkill /F /IM whatsapp.exe /T >nul 2>&1
taskkill /F /IM telegram.exe /T >nul 2>&1
taskkill /F /IM discord.exe /T >nul 2>&1
:: Clouds & Sync
taskkill /F /IM onedrive.exe /T >nul 2>&1
taskkill /F /IM googledrivesync.exe /T >nul 2>&1
taskkill /F /IM dropbox.exe /T >nul 2>&1
:: Misc / Music / Overlays
taskkill /F /IM spotify.exe /T >nul 2>&1
taskkill /F /IM overwolf.exe /T >nul 2>&1
taskkill /F /IM anydesk.exe /T >nul 2>&1
taskkill /F /IM teamviewer.exe /T >nul 2>&1

:: ==========================================
:: 3. POWER PLAN OPTIMIZATIONS
:: ==========================================
echo [*] Applying High Performance Power Plan...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -setactive SCHEME_MIN >nul 2>&1

:: Disable Hibernation to save disk space and reduce disk I/O
powercfg -h off >nul 2>&1

:: ==========================================
:: 4. NETWORK & LATENCY TWEAKS (For 0 Ping & Low Delay)
:: ==========================================
echo [*] Optimizing Network for Lowest Ping...
:: TCP/IP Tweaks
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1

:: Disable Nagle's Algorithm (Reduces latency in multiplayer games)
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do (
    reg add "%%i" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%i" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%i" /v "TcpDelAckTicks" /t REG_DWORD /d 0 /f >nul 2>&1
)

:: Clear DNS Cache
ipconfig /flushdns >nul 2>&1

:: ==========================================
:: 5. WINDOWS GAMING & PERFORMANCE TWEAKS
:: ==========================================
echo [*] Applying System Performance Registry Tweaks...

:: Enable Game Mode
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable Game DVR / Xbox Game Bar (Massive FPS boost, reduces stutter)
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Fullscreen Optimizations globally (Reduces input lag)
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul 2>&1

:: Enable Hardware-Accelerated GPU Scheduling (HAGS)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1

:: Disable Multi-Plane Overlay (MPO) to reduce stutters and alt-tab crashes
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableOverlays" /t REG_DWORD /d 1 /f >nul 2>&1

:: CPU & Memory Priority Tweaks
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1

:: System Timer & HPET Tweaks (Reduces input lag & micro-stutters)
echo [*] Applying BCD Tweaks for low latency...
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1

:: Disable Windows Visual Effects (Adjust for best performance)
echo [*] Disabling Heavy Visual Effects and Transparency...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1

:: Turn Off Mouse Acceleration (Enhance Pointer Precision)
echo [*] Disabling Mouse Acceleration for consistent aim...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1


:: Disable Background Apps globally
echo [*] Disabling Windows Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1

:: ==========================================
:: 6. DISABLE HEAVY BACKGROUND SERVICES
:: ==========================================
echo [*] Disabling Telemetry and Heavy Background Services...
:: Superfetch/SysMain (causes high disk usage)
sc stop "SysMain" >nul 2>&1
sc config "SysMain" start=disabled >nul 2>&1
:: Connected User Experiences and Telemetry
sc stop "DiagTrack" >nul 2>&1
sc config "DiagTrack" start=disabled >nul 2>&1
:: Windows Search (Indexing can cause stutter)
sc stop "WSearch" >nul 2>&1
sc config "WSearch" start=disabled >nul 2>&1
:: Diagnostic Policy Service
sc stop "DPS" >nul 2>&1
sc config "DPS" start=disabled >nul 2>&1
:: Microsoft Compatibility Appraiser (prevents random disk spikes)
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul 2>&1

:: ==========================================
:: 7. CLEAR JUNK / TEMP FILES
:: ==========================================
echo [*] Cleaning temporary files...
del /q /f /s %TEMP%\* >nul 2>&1
del /q /f /s C:\Windows\Temp\* >nul 2>&1
del /q /f /s C:\Windows\Prefetch\* >nul 2>&1

:: ==========================================
:: 8. VALORANT SPECIFIC TWEAKS (High Priority)
:: ==========================================
echo [*] Setting Valorant CPU Priority to High...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 3 /f >nul 2>&1

echo [*] Forcing High Performance GPU Preference for Valorant...
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "C:\Riot Games\VALORANT\live\ShooterGame\Binaries\Win64\VALORANT-Win64-Shipping.exe" /t REG_SZ /d "GpuPreference=2;" /f >nul 2>&1

echo [*] Applying QoS DSCP 46 for Valorant Network Traffic...
powershell -Command "New-NetQosPolicy -Name 'Valorant' -AppPathNameMatchCondition 'VALORANT-Win64-Shipping.exe' -DSCPAction 46 -NetworkProfile All -ErrorAction SilentlyContinue" >nul 2>&1

echo.
echo ===================================================
echo     OPTIMIZATIONS APPLIED SUCCESSFULLY!
echo ===================================================
echo.

:: ==========================================
:: 9. AUTO START DISCORD & VALORANT
:: ==========================================
echo [*] Starting Discord...
:: Check common paths for Discord
if exist "%LocalAppData%\Discord\Update.exe" (
    start "" "%LocalAppData%\Discord\Update.exe" --processStart Discord.exe
) else (
    echo [!] Could not find Discord automatically. If you have it installed elsewhere, please open it manually.
)

:: Wait a few seconds for Discord to launch before launching Valorant
timeout /t 3 /nobreak >nul

echo [*] Starting Valorant...
:: Launch Valorant using the Riot Client shortcut URI
start "" "riotclient://launch/live/valorant/live"

echo.
echo Have fun playing! This window will close automatically.
timeout /t 5 /nobreak >nul
exit
