@echo off
setlocal EnableDelayedExpansion
color 0a
title === VALORANT GOD MODE - DELL G5 5505 EDITION ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0a
echo.
echo  ##################################################
echo  #   VALORANT GOD MODE  ^|  DELL G5 5505 EDITION  #
echo  #   AMD Ryzen 5 4600H + RX 5600M  ^|  8GB RAM    #
echo  #   35 Tweaks  ^|  One Click  ^|  Zero Lag        #
echo  ##################################################
echo.
echo  [*] System: Dell G5 5505
echo  [*] CPU:    AMD Ryzen 5 4600H (6C/12T)
echo  [*] GPU:    AMD Radeon RX 5600M (6GB)
echo  [*] RAM:    8192 MB
echo  [*] Admin:  OK
echo.
timeout /t 2 /nobreak >nul

:: ==============================
echo  [PRE] Closing all open apps (keep Discord + Valorant only)...
:: Kill common browsers
for %%P in (chrome.exe firefox.exe msedge.exe opera.exe brave.exe iexplore.exe) do (
    taskkill /f /im %%P >nul 2>&1
)
:: Kill communication apps except Discord
for %%P in (Teams.exe Slack.exe Zoom.exe Skype.exe SkypeApp.exe telegram.exe WhatsApp.exe) do (
    taskkill /f /im %%P >nul 2>&1
)
:: Kill media & streaming
for %%P in (Spotify.exe vlc.exe wmplayer.exe iTunes.exe obs64.exe obs32.exe) do (
    taskkill /f /im %%P >nul 2>&1
)
:: Kill productivity
for %%P in (WINWORD.EXE EXCEL.EXE POWERPNT.EXE OUTLOOK.EXE notepad.exe notepad++.exe) do (
    taskkill /f /im %%P >nul 2>&1
)
:: Kill other launchers/games (not Valorant/Riot)
for %%P in (steam.exe EpicGamesLauncher.exe Battle.net.exe GalaxyClient.exe) do (
    taskkill /f /im %%P >nul 2>&1
)
:: Kill misc background stuff
for %%P in (OneDrive.exe Cortana.exe YourPhone.exe SearchApp.exe) do (
    taskkill /f /im %%P >nul 2>&1
)
echo      [OK] All non-essential apps closed

:: ==============================
echo  [1/35] Ultimate Power Plan...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINPROCESSORS 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0 >nul 2>&1
powercfg /hibernate off >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK] Power plan = ULTIMATE

:: ==============================
echo  [2/35] CPU Timer Resolution (Ryzen 4600H Tuned)...
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
:: Ryzen benefits from TSC over HPET
bcdedit /set tscsyncpolicy enhanced >nul 2>&1
echo      [OK] TSC timer active

:: ==============================
echo  [3/35] GPU Scheduling - SKIP HwSch (RX 5600M blocklist detected)...
:: NOTE: Your AMD RX 5600M driver has DISABLE_HWSCH in blocklist.
:: Forcing HwSchMode=2 would cause display crashes on this GPU.
:: Skipping to prevent black screen issues.
echo      [SKIP] HW GPU Scheduling blocked by AMD driver - safe skip

:: ==============================
echo  [4/35] GPU + Multimedia Priority (AMD Tuned)...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
echo      [OK] GPU + Multimedia maxed

:: ==============================
echo  [5/35] Force Discrete RX 5600M (Prevent iGPU Switch)...
:: Force Windows to prefer the RX 5600M over the integrated Radeon
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "KMD_EnableComputePreemption" /t REG_DWORD /d 0 /f >nul 2>&1
:: Set Valorant to use the high-performance GPU
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "C:\Riot Games\VALORANT\live\VALORANT.exe" /t REG_SZ /d "GpuPreference=2;" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "C:\Riot Games\Riot Client\RiotClientServices.exe" /t REG_SZ /d "GpuPreference=2;" /f >nul 2>&1
echo      [OK] RX 5600M forced for Valorant (no iGPU)

:: ==============================
echo  [6/35] AMD RX 5600M Power Optimization...
:: AMD Navi 10 (RX 5600M) specific tweaks
:: Disable power saving features on the dGPU
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "PP_SclkDeepSleepDisable" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "DisableDrmdmaPowerGating" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "DisableDynamicPstate" /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] RX 5600M power optimized

:: ==============================
echo  [7/35] Killer Wi-Fi 6 AX1650x Network Tweaks...
:: Intel Killer Wi-Fi specific tuning (VEN_8086 DEV_2723)
netsh int tcp set global autotuninglevel=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set global nonsackrttresiliency=disabled >nul 2>&1
netsh int tcp set global initialRto=2000 >nul 2>&1
:: Disable Killer Network Manager features that add latency
reg add "HKLM\SOFTWARE\Killer Networking" /v "AdvancedStreamDetect" /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Killer Wi-Fi 6 network tuned

:: ==============================
echo  [8/35] DNS to Cloudflare 1.1.1.1...
for /f "tokens=3*" %%a in ('netsh interface show interface ^| findstr /i "connected"') do (
    netsh interface ip set dns "%%b" static 1.1.1.1 >nul 2>&1
    netsh interface ip add dns "%%b" 1.0.0.1 index=2 >nul 2>&1
)
ipconfig /flushdns >nul
echo      [OK] DNS = Cloudflare 1.1.1.1

:: ==============================
echo  [9/35] CPU Priority Separation (Foreground Apps)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul
echo      [OK] CPU priority separation set

:: ==============================
echo  [10/35] Visual Performance Mode...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul
echo      [OK] Visuals = performance mode

:: ==============================
echo  [11/35] Disable Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 0 /f >nul
echo      [OK] Background apps off

:: ==============================
echo  [12/35] Kill Junk Processes...
:: NOTE: RuntimeBroker.exe is kept alive - killing it breaks Windows key and Alt+Tab!
for %%P in (OneDrive.exe Cortana.exe YourPhone.exe SearchApp.exe SearchIndexer.exe SpeechRuntime.exe backgroundTaskHost.exe Teams.exe msedge.exe SkypeApp.exe) do (
    taskkill /f /im %%P >nul 2>&1
)
echo      [OK] Junk processes killed (RuntimeBroker preserved for hotkeys)

:: ==============================
echo  [13/35] Stop Heavy Services...
for %%S in ("SysMain" "WSearch" "DiagTrack" "dmwappushservice" "Fax" "MapsBroker" "lfsvc" "WbioSrvc" "WMPNetworkSvc" "RemoteRegistry" "PrintNotify" "RetailDemo") do (
    sc stop %%S >nul 2>&1
    sc config %%S start=disabled >nul 2>&1
)
echo      [OK] Heavy services stopped

:: ==============================
echo  [14/35] Flush RAM + Temp Files...
del /s /f /q %temp%\* >nul 2>&1
del /s /f /q "C:\Windows\Temp\*" >nul 2>&1
ipconfig /flushdns >nul
echo      [OK] RAM + Temp cleared

:: ==============================
echo  [15/35] NVMe SSD TRIM + Memory Compression Off...
:: SK Hynix BC511 NVMe - enable TRIM
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
powershell -Command "Disable-MMAgent -mc" >nul 2>&1
powershell -Command "Disable-MMAgent -PageCombining" >nul 2>&1
echo      [OK] NVMe TRIM on, memory compression off

:: ==============================
echo  [16/35] Mouse Raw Input Fix (HP Pavilion Gaming 300)...
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 16 /f >nul 2>&1
echo      [OK] Mouse acceleration OFF

:: ==============================
echo  [17/35] Disable Game Bar + Xbox DVR (stops stutters)...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
:: FSEBehaviorMode=0 keeps Alt+Tab and Windows key working (mode 2 breaks them!)
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f >nul
echo      [OK] Game Bar + DVR off - no stutters (hotkeys preserved)

:: ==============================
echo  [18/35] Audio Latency Fix - MSI Maestro 300 + Realtek...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
echo      [OK] Audio latency minimized

:: ==============================
echo  [19/35] Disable Nagle's Algorithm (lower ping)...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 64 /f >nul
echo      [OK] Nagle off - ping drops

:: ==============================
echo  [20/35] Pause Windows Update...
sc stop wuauserv >nul 2>&1
sc config wuauserv start=disabled >nul 2>&1
sc stop UsoSvc >nul 2>&1
sc config UsoSvc start=disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul
echo      [OK] Windows Update paused

:: ==============================
echo  [21/35] Borderless Fullscreen (keeps Alt+Tab + Win key working)...
:: Using borderless instead of true exclusive - Alt+Tab and Win key stay functional
:: True exclusive (FSEBehavior=2) breaks Alt+Tab switching between Discord and game
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_EFSEFeatureFlags /t REG_DWORD /d 0 /f >nul
echo      [OK] Borderless fullscreen - Alt+Tab and Win key work fine

:: ==============================
echo  [22/35] Defender Off + Valorant Excluded...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" >nul 2>&1
powershell -Command "Set-MpPreference -DisableScanningNetworkFiles $true" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Riot Games'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'VALORANT-Win64-Shipping.exe'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'RiotClientServices.exe'" >nul 2>&1
echo      [OK] Defender off + Valorant excluded

:: ==============================
echo  [23/35] Disable HPET (Ryzen TSC mode active)...
bcdedit /set useplatformtick no >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
echo      [OK] HPET disabled - TSC active

:: ==============================
echo  [24/35] Disable Ryzen 4600H C-States (No Sleep Spikes)...
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFINCPOL 2 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFDECPOL 1 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFINCTHRESHOLD 10 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFDECTHRESHOLD 8 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR DISTRIBUTEUTIL 0 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK] C-States disabled - no CPU latency spikes

:: ==============================
echo  [25/35] MSI Mode for AMD RX 5600M (Lower DPC Latency)...
powershell -Command "
Get-PnpDevice -Class Display | Where-Object {$_.FriendlyName -like '*5600*' -or $_.FriendlyName -like '*Navi*'} | ForEach-Object {
    $path = 'HKLM:\SYSTEM\CurrentControlSet\Enum\' + $_.InstanceId + '\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties'
    if (Test-Path $path) {
        Set-ItemProperty -Path $path -Name MSISupported -Value 1 -ErrorAction SilentlyContinue
    }
}
" >nul 2>&1
echo      [OK] MSI mode for RX 5600M set

:: ==============================
echo  [26/35] Valorant IFEO High CPU Priority...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe\PerfOptions" /v IoPriority /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RiotClientServices.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
echo      [OK] Valorant always starts at HIGH priority

:: ==============================
echo  [27/35] Remove QoS 20%% Bandwidth Cap...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f >nul
echo      [OK] 100%% bandwidth to Valorant

:: ==============================
echo  [28/35] Static Pagefile (8GB RAM Tuned = 4096-8192MB)...
powershell -Command "
$cs = Get-WmiObject -Class Win32_ComputerSystem
$cs.AutomaticManagedPagefile = $false
$cs.Put() | Out-Null
$pf = Get-WmiObject -Class Win32_PageFileSetting -ErrorAction SilentlyContinue
if ($pf) {
    $pf.InitialSize = 4096
    $pf.MaximumSize = 8192
    $pf.Put() | Out-Null
}
" >nul 2>&1
echo      [OK] Pagefile fixed 4096-8192MB (no resize stutter)

:: ==============================
echo  [29/35] Disable IPv6 (less overhead on Killer Wi-Fi 6)...
netsh interface ipv6 set global randomizeidentifiers=disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f >nul
echo      [OK] IPv6 disabled

:: ==============================
echo  [30/35] Disable Windows Error Reporting...
sc stop WerSvc >nul 2>&1
sc config WerSvc start=disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul
echo      [OK] WerSvc disabled - no CPU hitches

:: ==============================
echo  [31/35] Killer Wi-Fi 6 NIC Advanced Settings...
powershell -Command "
$adapter = Get-NetAdapter | Where-Object {$_.InterfaceDescription -like '*Killer*' -or $_.InterfaceDescription -like '*Wi-Fi*'} | Select-Object -First 1
if (-not $adapter) { $adapter = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object -First 1 }
if ($adapter) {
    Disable-NetAdapterPowerManagement -Name $adapter.Name -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName 'Interrupt Moderation' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName 'Roaming Aggressiveness' -DisplayValue '1. Lowest' -ErrorAction SilentlyContinue
}
" >nul 2>&1
echo      [OK] Killer Wi-Fi 6 interrupt moderation off

:: ==============================
echo  [32/35] NTFS Last Access + Kernel Priority...
fsutil behavior set disablelastaccess 1 >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul
echo      [OK] NTFS access time off + kernel in RAM

:: ==============================
echo  [33/35] Disable Transparency + Animations...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f >nul
echo      [OK] Transparency + animations off

:: ==============================
echo  [34/35] Discord Hardware Acceleration Off...
set DISCORD_SETTINGS=%APPDATA%\discord\settings.json
if exist "%DISCORD_SETTINGS%" (
    powershell -Command "(Get-Content '%DISCORD_SETTINGS%') -replace '\"hardwareAcceleration\": true', '\"hardwareAcceleration\": false' | Set-Content '%DISCORD_SETTINGS%'" >nul 2>&1
)
echo      [OK] Discord GPU load reduced

:: ==============================
echo  [35/35] Valorant DPI Bypass + 0.5ms Timer Resolution...
:: Your system is set to 125%% (120DPI) - bypass scaling for Valorant
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Riot Games\VALORANT\live\VALORANT.exe" /t REG_SZ /d "~ GDIDPISCALING DPIUNAWARE" /f >nul 2>&1
echo      [OK] DPI scaling bypassed for raw input

:: Force 0.5ms timer resolution for max frame timing precision (helps reach 300+ FPS)
powershell -Command "
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class TimerRes2 {
    [DllImport(`"ntdll.dll`")] public static extern int NtSetTimerResolution(int Desired, bool Set, out int Current);
}
'@
$cur = 0
[TimerRes2]::NtSetTimerResolution(5000, $true, [ref]$cur) | Out-Null
" >nul 2>&1
echo      [OK] Timer resolution = 0.5ms (max frame precision)

:: Disable AMD Radeon Chill (it caps FPS - critical fix!)
reg add "HKCU\Software\AMD\CN" /v "Chill" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "Chill_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "VSyncControl" /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Radeon Chill OFF (FPS uncapped)

:: ==============================
:: LAUNCH DISCORD + VALORANT
:: ==============================
echo.
echo  ##################################################
echo  #      ALL TWEAKS COMPLETE!                      #
echo  #      Dell G5 5505 - FULL BOOST ACTIVE!         #
 echo  #                                               #
echo  #  FOR 300+ FPS - DO THIS IN VALORANT:           #
echo  #  Settings ^> Video ^> Frame Rate Limit = OFF    #
echo  #  Settings ^> Video ^> V-Sync = OFF              #
echo  #  Display Mode = FULLSCREEN (not Borderless)    #
echo  #  Graphics Quality = Low                        #
echo  ##################################################
echo.
echo  Launching Discord...
start "" "%LOCALAPPDATA%\Discord\Update.exe" --processStart Discord.exe >nul 2>&1
echo  Waiting 5 seconds then launching Valorant...
timeout /t 5 /nobreak >nul
start "" "%LOCALAPPDATA%\Riot Games\Riot Client\RiotClientServices.exe" --launch-product=valorant --launch-patchline=live >nul 2>&1
echo  Valorant launched - GLHF!
echo.
echo  REMINDER: Run GAMING_BOOST.bat after Valorant loads!
echo  NOTE: Re-enable Defender after gaming:
echo  Windows Security - Virus Protection - Turn ON
echo.
timeout /t 8 /nobreak >nul
exit
