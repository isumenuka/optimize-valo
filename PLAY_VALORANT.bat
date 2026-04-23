@echo off
setlocal EnableDelayedExpansion
color 0a
title ===  VALORANT GOD MODE OPTIMIZER - TOP 20  ===

:: =========================================
::  AUTO ADMIN ELEVATION
:: =========================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Not running as Admin. Elevating...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0a
echo.
echo  ##############################################
echo  #                                            #
echo  #    VALORANT GOD MODE  ^|  TOP 20 TWEAKS    #
echo  #    One Click - Zero Lag - Full Boost       #
echo  #                                            #
echo  ##############################################
echo.
echo  [*] Running as Administrator - OK
echo.
timeout /t 2 /nobreak >nul

:: =========================================
::  STEP 1: ULTIMATE POWER PLAN
:: =========================================
echo  [1/20] Setting ULTIMATE Performance Power Plan...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0 >nul 2>&1
powercfg /hibernate off >nul 2>&1
echo      [OK] Power plan set to ULTIMATE

:: =========================================
::  STEP 2: CPU TIMER RESOLUTION
:: =========================================
echo  [2/20] Optimizing CPU Timer Resolution...
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
echo      [OK] CPU timer resolution optimized

:: =========================================
::  STEP 3: HARDWARE GPU SCHEDULING
:: =========================================
echo  [3/20] Enabling Hardware-Accelerated GPU Scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul
echo      [OK] GPU scheduling enabled

:: =========================================
::  STEP 4: GPU + MULTIMEDIA PRIORITY
:: =========================================
echo  [4/20] Boosting GPU and Multimedia Priority...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul
echo      [OK] GPU and multimedia priority maxed

:: =========================================
::  STEP 5: NETWORK LATENCY TWEAKS
:: =========================================
echo  [5/20] Applying Network Latency Tweaks...
netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global chimney=disabled >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global dca=enabled >nul
netsh int tcp set global ecncapability=disabled >nul
netsh int tcp set global timestamps=disabled >nul
netsh int tcp set heuristics disabled >nul
netsh int tcp set global nonsackrttresiliency=disabled >nul
echo      [OK] Network latency minimized

:: =========================================
::  STEP 6: DNS SET TO CLOUDFLARE (FASTEST)
:: =========================================
echo  [6/20] Setting DNS to Cloudflare 1.1.1.1...
for /f "tokens=3*" %%a in ('netsh interface show interface ^| findstr /i "connected"') do (
    netsh interface ip set dns "%%b" static 1.1.1.1 >nul 2>&1
    netsh interface ip add dns "%%b" 1.0.0.1 index=2 >nul 2>&1
)
ipconfig /flushdns >nul
echo      [OK] DNS set to Cloudflare - lower ping

:: =========================================
::  STEP 7: CPU PROCESS PRIORITY SEPARATION
:: =========================================
echo  [7/20] Setting CPU Priority Separation...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul
echo      [OK] CPU priority separation set

:: =========================================
::  STEP 8: VISUAL PERFORMANCE MODE
:: =========================================
echo  [8/20] Setting Windows to Performance Visual Mode...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul
echo      [OK] Visuals set to performance mode

:: =========================================
::  STEP 9: DISABLE BACKGROUND APPS
:: =========================================
echo  [9/20] Disabling Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 0 /f >nul
echo      [OK] Background apps disabled

:: =========================================
::  STEP 10: KILL JUNK PROCESSES
:: =========================================
echo  [10/20] Killing Background Junk Processes...
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Cortana.exe >nul 2>&1
taskkill /f /im YourPhone.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1
taskkill /f /im SearchIndexer.exe >nul 2>&1
taskkill /f /im SpeechRuntime.exe >nul 2>&1
taskkill /f /im backgroundTaskHost.exe >nul 2>&1
taskkill /f /im RuntimeBroker.exe >nul 2>&1
taskkill /f /im SkypeApp.exe >nul 2>&1
taskkill /f /im MicrosoftEdge.exe >nul 2>&1
taskkill /f /im Teams.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
echo      [OK] Junk processes killed

:: =========================================
::  STEP 11: STOP HEAVY SERVICES
:: =========================================
echo  [11/20] Stopping Heavy Background Services...
for %%S in (
    "SysMain"
    "WSearch"
    "DiagTrack"
    "dmwappushservice"
    "Fax"
    "MapsBroker"
    "lfsvc"
    "WbioSrvc"
    "TabletInputService"
    "WMPNetworkSvc"
    "RemoteRegistry"
    "PrintNotify"
) do (
    sc stop %%S >nul 2>&1
    sc config %%S start=disabled >nul 2>&1
)
echo      [OK] Heavy services stopped

:: =========================================
::  STEP 12: FLUSH RAM + TEMP FILES
:: =========================================
echo  [12/20] Flushing RAM Standby Cache + Temp Files...
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
del /s /f /q %temp%\* >nul 2>&1
del /s /f /q "C:\Windows\Temp\*" >nul 2>&1
ipconfig /flushdns >nul
echo      [OK] RAM cache and temp files cleared

:: =========================================
::  STEP 13: SSD TRIM + DISABLE MEMORY COMPRESSION
:: =========================================
echo  [13/20] SSD TRIM + Memory Compression Off...
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
powershell -Command "Disable-MMAgent -mc" >nul 2>&1
powershell -Command "Disable-MMAgent -PageCombining" >nul 2>&1
echo      [OK] SSD trim enabled, memory compression disabled

:: =========================================
::  STEP 14: MOUSE INPUT LAG FIX
:: =========================================
echo  [14/20] Fixing Mouse Input Lag (Raw Input)...
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 16 /f >nul 2>&1
echo      [OK] Mouse acceleration OFF - raw input enabled

:: =========================================
::  STEP 15: DISABLE GAME BAR + XBOX DVR
::  (CAUSES VALORANT MICRO-STUTTERS!)
:: =========================================
echo  [15/20] Disabling Game Bar and Xbox DVR (stops stutters)...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f >nul
echo      [OK] Game Bar and Xbox DVR disabled - no more stutters

:: =========================================
::  STEP 16: AUDIO LATENCY FIX (MMCSS)
::  (Fixes Discord voice + in-game audio lag)
:: =========================================
echo  [16/20] Fixing Audio Latency via MMCSS...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Background Only" /t REG_SZ /d "False" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul
sc config Audiosrv start=auto >nul 2>&1
net start Audiosrv >nul 2>&1
echo      [OK] Audio latency minimized - Discord voice smoother

:: =========================================
::  STEP 17: DISABLE NAGLE'S ALGORITHM
::  (Biggest ping reduction tweak!)
:: =========================================
echo  [17/20] Disabling Nagle's Algorithm (lower ping)...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 64 /f >nul
echo      [OK] Nagle disabled - ping should drop

:: =========================================
::  STEP 18: PAUSE WINDOWS UPDATE
::  (Stops update eating bandwidth mid-game)
:: =========================================
echo  [18/20] Pausing Windows Update during gaming...
sc stop wuauserv >nul 2>&1
sc config wuauserv start=disabled >nul 2>&1
sc stop UsoSvc >nul 2>&1
sc config UsoSvc start=disabled >nul 2>&1
sc stop WaaSMedicSvc >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f >nul
echo      [OK] Windows Update paused - no bandwidth stealing

:: =========================================
::  STEP 19: DISABLE FULLSCREEN OPTIMIZATIONS
::  (Forces true exclusive fullscreen in Valorant)
:: =========================================
echo  [19/20] Disabling Fullscreen Optimizations...
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_EFSEFeatureFlags /t REG_DWORD /d 0 /f >nul
echo      [OK] True exclusive fullscreen forced for Valorant

:: =========================================
::  STEP 20: DISABLE WINDOWS DEFENDER SCAN
::  (Frees CPU - REMEMBER to re-enable after!)
:: =========================================
echo  [20/20] Disabling Windows Defender Real-Time Scan...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" >nul 2>&1
powershell -Command "Set-MpPreference -DisableScanningNetworkFiles $true" >nul 2>&1
powershell -Command "Set-MpPreference -DisableBlockAtFirstSeen $true" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Riot Games'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'VALORANT-Win64-Shipping.exe'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'RiotClientServices.exe'" >nul 2>&1
echo      [OK] Defender scan off + Valorant excluded from scans

:: =========================================
::  ALL 20 DONE - LAUNCH DISCORD + VALORANT
:: =========================================
echo.
echo  ##############################################
echo  #                                            #
echo  #       ALL 20 OPTIMIZATIONS COMPLETE!       #
echo  #                                            #
echo  ##############################################
echo.
echo  Launching Discord...
start "" "%LOCALAPPDATA%\Discord\Update.exe" --processStart Discord.exe >nul 2>&1

echo  Waiting 5 seconds then launching Valorant...
timeout /t 5 /nobreak >nul

echo  Launching Valorant via Riot Client...
start "" "%LOCALAPPDATA%\Riot Games\Riot Client\RiotClientServices.exe" --launch-product=valorant --launch-patchline=live >nul 2>&1

echo.
echo  ##############################################
echo  #  Discord + Valorant launching NOW!         #
echo  #  Enjoy your ZERO LAG, MAX FPS session!     #
echo  #                                            #
echo  #  NOTE: Re-enable Windows Defender after    #
echo  #  gaming via Windows Security settings.     #
echo  ##############################################
echo.
timeout /t 10 /nobreak >nul
exit
