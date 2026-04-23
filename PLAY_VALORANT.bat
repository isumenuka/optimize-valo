@echo off
setlocal EnableDelayedExpansion
color 0a
title === VALORANT GOD MODE - 35 TWEAKS ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0a
echo.
echo  #################################################
echo  #   VALORANT GOD MODE  ^|  35 EXTREME TWEAKS    #
echo  #   One Click - Auto GPU^&RAM Detection         #
echo  #################################################
echo.
echo  [*] Admin OK
echo.
timeout /t 1 /nobreak >nul

:: Auto-detect RAM
for /f "skip=1 tokens=2" %%R in ('wmic computersystem get TotalPhysicalMemory') do (
    set /a RAM_MB=%%R/1048576
    goto :doneRAM
)
:doneRAM
set /a PF_INIT=%RAM_MB%
set /a PF_MAX=%RAM_MB%*2
if %PF_MAX% GTR 16384 set PF_MAX=16384
echo  [*] RAM Detected: %RAM_MB% MB

:: Auto-detect GPU
set GPU_BRAND=UNKNOWN
for /f "tokens=*" %%G in ('wmic path win32_VideoController get Name ^| findstr /i "NVIDIA"') do set GPU_BRAND=NVIDIA
for /f "tokens=*" %%G in ('wmic path win32_VideoController get Name ^| findstr /i "AMD Radeon"') do (
    if "!GPU_BRAND!"=="UNKNOWN" set GPU_BRAND=AMD
)
echo  [*] GPU Detected: %GPU_BRAND%
echo.
timeout /t 1 /nobreak >nul

:: ==============================
echo  [1/35] Ultimate Power Plan...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0 >nul 2>&1
powercfg /hibernate off >nul 2>&1
echo      [OK]

:: ==============================
echo  [2/35] CPU Timer Resolution...
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
echo      [OK]

:: ==============================
echo  [3/35] Hardware GPU Scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul
echo      [OK]

:: ==============================
echo  [4/35] GPU + Multimedia Priority...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul
echo      [OK]

:: ==============================
echo  [5/35] Network TCP Tweaks...
netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global dca=enabled >nul
netsh int tcp set global ecncapability=disabled >nul
netsh int tcp set global timestamps=disabled >nul
netsh int tcp set heuristics disabled >nul
echo      [OK]

:: ==============================
echo  [6/35] DNS to Cloudflare...
for /f "tokens=3*" %%a in ('netsh interface show interface ^| findstr /i "connected"') do (
    netsh interface ip set dns "%%b" static 1.1.1.1 >nul 2>&1
    netsh interface ip add dns "%%b" 1.0.0.1 index=2 >nul 2>&1
)
ipconfig /flushdns >nul
echo      [OK]

:: ==============================
echo  [7/35] CPU Priority Separation...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul
echo      [OK]

:: ==============================
echo  [8/35] Visual Performance Mode...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul
echo      [OK]

:: ==============================
echo  [9/35] Disable Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul
echo      [OK]

:: ==============================
echo  [10/35] Kill Junk Processes...
for %%P in (OneDrive.exe Cortana.exe YourPhone.exe SearchApp.exe SearchIndexer.exe SpeechRuntime.exe backgroundTaskHost.exe RuntimeBroker.exe Teams.exe msedge.exe) do (
    taskkill /f /im %%P >nul 2>&1
)
echo      [OK]

:: ==============================
echo  [11/35] Stop Heavy Services...
for %%S in ("SysMain" "WSearch" "DiagTrack" "dmwappushservice" "Fax" "MapsBroker" "lfsvc" "WbioSrvc" "WMPNetworkSvc" "RemoteRegistry" "PrintNotify") do (
    sc stop %%S >nul 2>&1
    sc config %%S start=disabled >nul 2>&1
)
echo      [OK]

:: ==============================
echo  [12/35] Flush RAM + Temp Files...
del /s /f /q %temp%\* >nul 2>&1
del /s /f /q "C:\Windows\Temp\*" >nul 2>&1
ipconfig /flushdns >nul
echo      [OK]

:: ==============================
echo  [13/35] SSD TRIM + Memory Compression Off...
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
powershell -Command "Disable-MMAgent -mc" >nul 2>&1
powershell -Command "Disable-MMAgent -PageCombining" >nul 2>&1
echo      [OK]

:: ==============================
echo  [14/35] Mouse Input Lag Fix...
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul
echo      [OK]

:: ==============================
echo  [15/35] Disable Game Bar + Xbox DVR...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul
echo      [OK]

:: ==============================
echo  [16/35] Audio Latency Fix (MMCSS)...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul
echo      [OK]

:: ==============================
echo  [17/35] Disable Nagle's Algorithm...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d 0 /f >nul
echo      [OK]

:: ==============================
echo  [18/35] Pause Windows Update...
sc stop wuauserv >nul 2>&1
sc config wuauserv start=disabled >nul 2>&1
sc stop UsoSvc >nul 2>&1
sc config UsoSvc start=disabled >nul 2>&1
echo      [OK]

:: ==============================
echo  [19/35] Force True Exclusive Fullscreen...
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul
echo      [OK]

:: ==============================
echo  [20/35] Defender Real-Time Off + Valorant Excluded...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Riot Games'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'VALORANT-Win64-Shipping.exe'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'RiotClientServices.exe'" >nul 2>&1
echo      [OK]

:: ==============================
echo  [21/35] Disable HPET (Better Frame Timing)...
bcdedit /set useplatformtick no >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
echo      [OK]

:: ==============================
echo  [22/35] Disable CPU C-States (No Sleep Spikes)...
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFINCPOL 2 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFDECPOL 1 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFINCTHRESHOLD 10 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFDECTHRESHOLD 8 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK]

:: ==============================
echo  [23/35] MSI Mode for GPU (Low DPC Latency)...
powershell -Command "Get-PnpDevice -Class Display | ForEach-Object { $path = 'HKLM:\SYSTEM\CurrentControlSet\Enum\' + $_.InstanceId + '\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties'; if (Test-Path $path) { Set-ItemProperty -Path $path -Name MSISupported -Value 1 -ErrorAction SilentlyContinue } }" >nul 2>&1
echo      [OK]

:: ==============================
echo  [24/35] Valorant IFEO High CPU Priority...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe\PerfOptions" /v IoPriority /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RiotClientServices.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
echo      [OK]

:: ==============================
echo  [25/35] Remove QoS 20%% Bandwidth Cap...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f >nul
echo      [OK]

:: ==============================
echo  [26/35] Static Pagefile (No Resize Stutter)...
powershell -Command "
$cs = Get-WmiObject -Class Win32_ComputerSystem
$cs.AutomaticManagedPagefile = $false
$cs.Put() | Out-Null
$pf = Get-WmiObject -Class Win32_PageFileSetting -ErrorAction SilentlyContinue
if ($pf) { $pf.InitialSize = %PF_INIT%; $pf.MaximumSize = %PF_MAX%; $pf.Put() | Out-Null }
" >nul 2>&1
echo      [OK] Pagefile: %PF_INIT%MB - %PF_MAX%MB

:: ==============================
echo  [27/35] Disable IPv6 (Less Network Overhead)...
netsh interface ipv6 set global randomizeidentifiers=disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f >nul
echo      [OK]

:: ==============================
echo  [28/35] Disable Windows Error Reporting...
sc stop WerSvc >nul 2>&1
sc config WerSvc start=disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul
echo      [OK]

:: ==============================
echo  [29/35] NIC Interrupt Moderation Off...
powershell -Command "
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object -First 1
if ($adapter) {
    Disable-NetAdapterPowerManagement -Name $adapter.Name -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName 'Interrupt Moderation' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue
}
" >nul 2>&1
echo      [OK]

:: ==============================
echo  [30/35] NTFS Last Access Time Off...
fsutil behavior set disablelastaccess 1 >nul 2>&1
echo      [OK]

:: ==============================
echo  [31/35] Disable Transparency + Animations...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f >nul
echo      [OK]

:: ==============================
echo  [32/35] Discord Hardware Accel Off...
set DISCORD_SETTINGS=%APPDATA%\discord\settings.json
if exist "%DISCORD_SETTINGS%" (
    powershell -Command "(Get-Content '%DISCORD_SETTINGS%') -replace '\"hardwareAcceleration\": true', '\"hardwareAcceleration\": false' | Set-Content '%DISCORD_SETTINGS%'" >nul 2>&1
)
echo      [OK]

:: ==============================
echo  [33/35] Valorant DPI Scaling Bypass...
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Riot Games\VALORANT\live\VALORANT.exe" /t REG_SZ /d "~ GDIDPISCALING DPIUNAWARE" /f >nul 2>&1
echo      [OK]

:: ==============================
echo  [34/35] GPU Max Performance Mode...
if "%GPU_BRAND%"=="NVIDIA" (
    for /f %%K in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /s /v "DriverDesc" 2^>nul ^| findstr /i "nvidia" ^| findstr "HKLM"') do (
        set NVKEY=%%K
    )
    if defined NVKEY (
        reg add "!NVKEY!" /v "PerfLevelSrc" /t REG_DWORD /d 8738 /f >nul 2>&1
        reg add "!NVKEY!" /v "PowerMizerEnable" /t REG_DWORD /d 0 /f >nul 2>&1
    )
    echo      [OK] NVIDIA Max Performance set
) else if "%GPU_BRAND%"=="AMD" (
    reg add "HKLM\SOFTWARE\AMD\CN" /v "PP_SclkDeepSleepDisable" /t REG_DWORD /d 1 /f >nul 2>&1
    echo      [OK] AMD Max Performance set
) else (
    echo      [SKIP] GPU brand unknown - set manually in GPU control panel
)

:: ==============================
echo  [35/35] Kernel Priority + Large Cache Off...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul
echo      [OK]

:: ==============================
:: LAUNCH DISCORD + VALORANT
:: ==============================
echo.
echo  #################################################
echo  #      ALL 35 TWEAKS COMPLETE!                  #
echo  #      GPU: %GPU_BRAND%  ^|  RAM: %RAM_MB% MB          #
echo  #################################################
echo.
echo  Launching Discord...
start "" "%LOCALAPPDATA%\Discord\Update.exe" --processStart Discord.exe >nul 2>&1
echo  Waiting 5s then launching Valorant...
timeout /t 5 /nobreak >nul
start "" "%LOCALAPPDATA%\Riot Games\Riot Client\RiotClientServices.exe" --launch-product=valorant --launch-patchline=live >nul 2>&1
echo  Valorant launched!
echo.
echo  NOTE: Re-enable Windows Defender after gaming!
echo  (Windows Security - Virus protection - ON)
echo.
timeout /t 8 /nobreak >nul
exit
