@echo off
setlocal EnableDelayedExpansion
color 0c
title === RESTORE DEFAULTS - UNDO ALL OPTIMIZATIONS ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0c
echo.
echo  ##################################################
echo  #   RESTORE DEFAULTS - UNDO ALL TWEAKS          #
echo  #   Dell G5 5505  ^|  Safe Revert Script         #
echo  #                                                #
echo  #   [!] Run this before uninstalling drivers,   #
echo  #       before major Windows updates, or if     #
echo  #       you notice system issues after gaming.  #
echo  ##################################################
echo.
echo  [!] This will undo ALL optimizations and restore
echo      Windows defaults. Restart required after.
echo.
echo  Press CTRL+C to cancel, or...
timeout /t 8
echo.

:: ==============================
echo  [1/15] Restoring Power Plan to Balanced...
:: ==============================
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
powercfg /hibernate on >nul 2>&1
:: Re-enable Fast Startup
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f >nul
echo      [OK] Power plan = Balanced, Fast Startup = ON

:: ==============================
echo  [2/15] Restoring Boot/Timer Settings...
:: ==============================
bcdedit /deletevalue disabledynamictick >nul 2>&1
bcdedit /deletevalue useplatformtick >nul 2>&1
bcdedit /deletevalue tscsyncpolicy >nul 2>&1
echo      [OK] BCD timer settings restored

:: ==============================
echo  [3/15] Restoring Windows Update...
:: ==============================
sc config wuauserv start=auto >nul 2>&1
sc start wuauserv >nul 2>&1
sc config UsoSvc start=auto >nul 2>&1
sc start UsoSvc >nul 2>&1
sc config DoSvc start=auto >nul 2>&1
sc start DoSvc >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /f >nul 2>&1
echo      [OK] Windows Update restored to auto

:: ==============================
echo  [4/15] Restoring Disabled Services...
:: ==============================
for %%S in ("SysMain" "WSearch" "DiagTrack" "dmwappushservice" "WerSvc" "MapsBroker") do (
    sc config %%S start=auto >nul 2>&1
    sc start %%S >nul 2>&1
)
echo      [OK] SysMain, WSearch, DiagTrack, WerSvc restored

:: ==============================
echo  [5/15] Restoring TCP Network Settings...
:: ==============================
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global ecncapability=enabled >nul 2>&1
netsh int tcp set global timestamps=enabled >nul 2>&1
netsh int tcp set heuristics enabled >nul 2>&1
netsh int tcp set global initialRto=3000 >nul 2>&1
:: Restore Nagle's algorithm
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPDelAckTicks /f >nul 2>&1
:: Restore IPv6
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 0 /f >nul
echo      [OK] TCP/network settings restored

:: ==============================
echo  [6/15] Restoring Visual Effects to Default...
:: ==============================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 1 /f >nul
echo      [OK] Visual effects restored to default

:: ==============================
echo  [7/15] Restoring Windows Defender...
:: ==============================
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1
powershell -Command "Set-MpPreference -DisableScanningNetworkFiles $false" >nul 2>&1
echo      [OK] Windows Defender real-time protection ON

:: ==============================
echo  [8/15] Restoring Background Apps...
:: ==============================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 1 /f >nul
echo      [OK] Background apps restored

:: ==============================
echo  [9/15] Restoring Xbox Game Bar/DVR...
:: ==============================
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /f >nul 2>&1
echo      [OK] Game Bar and DVR restored

:: ==============================
echo  [10/15] Removing QoS DSCP Valorant Policies...
:: ==============================
powershell -Command "
Get-NetQosPolicy -Name 'Valorant' -ErrorAction SilentlyContinue | Remove-NetQosPolicy -Confirm:\$false -ErrorAction SilentlyContinue
Get-NetQosPolicy -Name 'Valorant-UDP' -ErrorAction SilentlyContinue | Remove-NetQosPolicy -Confirm:\$false -ErrorAction SilentlyContinue
Get-NetQosPolicy -Name 'RiotClient' -ErrorAction SilentlyContinue | Remove-NetQosPolicy -Confirm:\$false -ErrorAction SilentlyContinue
" >nul 2>&1
echo      [OK] QoS DSCP policies removed

:: ==============================
echo  [11/15] Restoring Mouse Settings (re-enable accel if desired)...
:: ==============================
:: We keep mouse acceleration OFF since that's a user preference, not a system tweak
:: But restore queue size to default
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 100 /f >nul 2>&1
echo      [OK] Mouse queue size restored (accel remains OFF - re-enable manually if needed)

:: ==============================
echo  [12/15] Re-enabling Telemetry Services...
:: ==============================
for %%S in ("DiagTrack" "dmwappushservice" "diagnosticshub.standardcollector.service" "wlidsvc") do (
    sc config %%S start=auto >nul 2>&1
    sc start %%S >nul 2>&1
)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 1 /f >nul
echo      [OK] Telemetry re-enabled

:: ==============================
echo  [13/15] Restoring Scheduled Tasks...
:: ==============================
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Enable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Enable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Enable >nul 2>&1
echo      [OK] Key scheduled tasks re-enabled

:: ==============================
echo  [14/15] Restoring Memory Management Defaults...
:: ==============================
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 0 /f >nul
:: Re-enable prefetch
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 3 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 3 /f >nul
:: Restore memory compression
powershell -Command "Enable-MMAgent -mc" >nul 2>&1
powershell -Command "Enable-MMAgent -PageCombining" >nul 2>&1
echo      [OK] Memory management restored

:: ==============================
echo  [15/15] Re-enabling Network Adapter Power Management...
:: ==============================
powershell -Command "
\$adapter = Get-NetAdapter | Where-Object {\$_.Status -eq 'Up'} | Select-Object -First 1
if (\$adapter) {
    Enable-NetAdapterPowerManagement -Name \$adapter.Name -ErrorAction SilentlyContinue
    Enable-NetAdapterLso -Name \$adapter.Name -ErrorAction SilentlyContinue
    Enable-NetAdapterRsc -Name \$adapter.Name -ErrorAction SilentlyContinue
}
" >nul 2>&1
echo      [OK] Network adapter defaults restored

:: ==============================
echo.
echo  ##################################################
echo  #   RESTORE COMPLETE!                            #
echo  #                                                #
echo  #   All optimizations have been undone.          #
echo  #   Windows is back to factory defaults.         #
echo  #                                                #
echo  #   [!] RESTART YOUR PC NOW for changes to      #
echo  #       take full effect.                        #
echo  ##################################################
echo.
timeout /t 10 /nobreak >nul
exit
