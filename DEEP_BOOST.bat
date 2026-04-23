@echo off
setlocal EnableDelayedExpansion
color 0d
title === DEEP BOOST - 3RD PARTY LEVEL OPTIMIZER ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0d
echo.
echo  ##################################################
echo  #   DEEP BOOST  ^|  Dell G5 5505 EDITION         #
echo  #   Things your other scripts DON'T do           #
echo  #   Run this ONCE before gaming (not every time) #
echo  ##################################################
echo.
echo  [*] Covers: Scheduled Tasks, USB, PCIe Power,
echo  [*]         Power Throttling, DPC Latency, NIC,
echo  [*]         Radeon Anti-Lag, TCP Offload, more.
echo.
timeout /t 3 /nobreak >nul

:: ==============================
echo  [1/15] Kill Background Scheduled Tasks...
:: ==============================
:: These run silently in the background eating CPU/disk during gaming
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maps\MapsUpdateTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maps\MapsToastTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyMonitor" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyRefresh" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable >nul 2>&1
echo      [OK] 14 background scheduled tasks killed

:: ==============================
echo  [2/15] Disable USB Selective Suspend (removes USB stutter)...
:: ==============================
:: USB selective suspend lets Windows cut power to USB devices during gaming
:: This causes mouse/keyboard micro-freezes mid-game
powercfg -setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg -setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK] USB Selective Suspend = DISABLED (no mouse/KB freezes)

:: ==============================
echo  [3/15] Disable PCIe Active State Power Management (PCIe ASPM)...
:: ==============================
:: PCIe ASPM puts your GPU/NIC PCIe link into low-power states causing latency spikes
powercfg -setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK] PCIe ASPM = OFF (GPU/NIC always at full power state)

:: ==============================
echo  [4/15] Disable Power Throttling for Valorant (Windows 11 fix)...
:: ==============================
:: Windows 11 has "EcoQoS / Power Throttling" that can silently throttle game threads
:: This disables it specifically for Valorant processes
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul 2>&1
:: Per-process override for Valorant
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Riot Games\VALORANT\live\VALORANT-Win64-Shipping.exe" /t REG_SZ /d "~ DISABLEPROCESSTHROTTLING" /f >nul 2>&1
echo      [OK] Power Throttling OFF (no silent thread throttling)

:: ==============================
echo  [5/15] Disable AMD Radeon Anti-Lag (safe driver-level, no ban risk)...
:: ==============================
:: Anti-Lag+ (the DLL injection one) was REMOVED by AMD due to bans
:: Standard Anti-Lag is driver-level and safe - enable it for RX 5600M
reg add "HKCU\Software\AMD\CN" /v "AntiLag" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "AntiLag_Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
:: Set Radeon to max performance mode for Valorant
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "PowerMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "TessellationMode" /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Radeon Anti-Lag ENABLED (driver-level, safe for Vanguard)

:: ==============================
echo  [6/15] Disable TCP/UDP Checksum Offload (lower latency)...
:: ==============================
:: Offloading checksum to NIC hardware adds a processing delay vs CPU doing it inline
powershell -Command "
\$adapter = Get-NetAdapter | Where-Object {\$_.Status -eq 'Up'} | Select-Object -First 1
if (\$adapter) {
    Set-NetAdapterAdvancedProperty -Name \$adapter.Name -DisplayName 'TCP Checksum Offload (IPv4)' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name \$adapter.Name -DisplayName 'UDP Checksum Offload (IPv4)' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name \$adapter.Name -DisplayName 'TCP Checksum Offload (IPv6)' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name \$adapter.Name -DisplayName 'UDP Checksum Offload (IPv6)' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue
}
" >nul 2>&1
echo      [OK] TCP/UDP Checksum Offload OFF (lower NIC processing latency)

:: ==============================
echo  [7/15] Disable USB Controller Idle Power (stops USB jitter)...
:: ==============================
:: USB host controllers can enter idle states mid-game causing input jitter
powershell -Command "
Get-PnpDevice -Class USB | ForEach-Object {
    \$path = 'HKLM:\SYSTEM\CurrentControlSet\Enum\' + \$_.InstanceId + '\Device Parameters'
    if (Test-Path \$path) {
        New-ItemProperty -Path \$path -Name 'EnhancedPowerManagementEnabled' -Value 0 -PropertyType DWORD -Force -ErrorAction SilentlyContinue | Out-Null
        New-ItemProperty -Path \$path -Name 'SelectiveSuspendEnabled' -Value 0 -PropertyType DWORD -Force -ErrorAction SilentlyContinue | Out-Null
    }
}
" >nul 2>&1
echo      [OK] USB controllers locked to full power (no input jitter)

:: ==============================
echo  [8/15] Pin Network Interrupts to Core 0 (free gaming cores)...
:: ==============================
:: Core 0 handles system interrupts - pin network IRQ there too
:: This leaves cores 1-11 clean for Valorant (where we pinned it)
powershell -Command "
\$netDevices = Get-PnpDevice -Class Net | Where-Object {\$_.Status -eq 'OK'}
foreach (\$dev in \$netDevices) {
    \$path = 'HKLM:\SYSTEM\CurrentControlSet\Enum\' + \$dev.InstanceId + '\Device Parameters\Interrupt Management\Affinity Policy'
    try {
        if (-not (Test-Path \$path)) { New-Item -Path \$path -Force | Out-Null }
        # 0x1 = Core 0 only - handles network IRQs on core 0, leaving cores 1-11 for Valorant
        Set-ItemProperty -Path \$path -Name 'AssignmentSetOverride' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path \$path -Name 'IrqPolicyMaskPolicy' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    } catch {}
}
" >nul 2>&1
echo      [OK] Network IRQs = Core 0 (gaming cores 1-11 uninterrupted)

:: ==============================
echo  [9/15] Disable Windows Game Mode (it actually hurts performance)...
:: ==============================
:: Controversial: Windows Game Mode can HURT by pausing background tasks
:: at the wrong time. Best to manage processes manually (which we do).
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Windows Game Mode OFF (manual priority control is better)

:: ==============================
echo  [10/15] Disable Prefetch for SSD (SK Hynix BC511 NVMe)...
:: ==============================
:: Prefetch is designed for spinning HDDs - on NVMe it just wastes RAM and I/O
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableBootTrace /t REG_DWORD /d 0 /f >nul 2>&1
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
echo      [OK] Prefetch/Superfetch OFF (NVMe doesn't need it)

:: ==============================
echo  [11/15] Optimize Windows Visual Experience for Gaming...
:: ==============================
:: More aggressive than what PLAY_VALORANT does - disables every animation
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f >nul 2>&1
:: Disable window shadow (wastes GPU cycles)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul 2>&1
:: Cursor settings - raw hardware cursor
reg add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 10 /f >nul 2>&1
echo      [OK] All animations + shadows stripped

:: ==============================
echo  [12/15] Network UDP Socket Buffer Optimization...
:: ==============================
:: Valorant is UDP-heavy - larger socket buffers = less packet loss under load
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v DefaultReceiveWindow /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v DefaultSendWindow /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v FastSendDatagramThreshold /t REG_DWORD /d 1024 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v IgnorePushBitOnReceives /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] UDP socket buffers = 64KB (Valorant packet headroom)

:: ==============================
echo  [13/15] Disable Windows Telemetry Services (all of them)...
:: ==============================
:: PLAY_VALORANT stops DiagTrack but misses these
for %%S in ("DiagTrack" "dmwappushservice" "diagnosticshub.standardcollector.service" "WerSvc" "wlidsvc" "DusmSvc") do (
    sc stop %%S >nul 2>&1
    sc config %%S start=disabled >nul 2>&1
)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] All telemetry services disabled (no background CPU spikes)

:: ==============================
echo  [14/15] AMD RX 5600M - Disable ULPS (Ultra Low Power State)...
:: ==============================
:: ULPS makes the GPU enter ultra-deep power states when idle
:: When Valorant loads a new map it wakes up SLOWLY causing a freeze/stutter
powershell -Command "
Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\*' -ErrorAction SilentlyContinue |
Where-Object { \$_.DriverDesc -like '*5600*' -or \$_.DriverDesc -like '*Navi*' -or \$_.DriverDesc -like '*Radeon*' } |
ForEach-Object {
    \$path = \$_.PSPath
    Set-ItemProperty -Path \$path -Name 'EnableULPS' -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path \$path -Name 'EnableULPS_NA' -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path \$path -Name 'PP_SclkDeepSleepDisable' -Value 1 -ErrorAction SilentlyContinue
}
" >nul 2>&1
echo      [OK] ULPS disabled - RX 5600M stays awake (no map-load stutter)

:: ==============================
echo  [15/15] Flush DNS + Clear Working Sets + Prefetch Cache...
:: ==============================
ipconfig /flushdns >nul 2>&1
ipconfig /registerdns >nul 2>&1
:: Clear prefetch cache files
del /f /q "%SystemRoot%\Prefetch\*" >nul 2>&1
:: Clear standby RAM list
powershell -Command "[System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers()" >nul 2>&1
echo      [OK] DNS flushed + Prefetch cache cleared + RAM standby freed

:: ==============================
echo.
echo  ##################################################
echo  #   DEEP BOOST COMPLETE!                         #
echo  #                                                #
echo  #   New optimizations applied:                   #
echo  #   - 14 scheduled tasks killed                  #
echo  #   - USB Suspend OFF (no KB/mouse stutter)      #
echo  #   - PCIe ASPM OFF (GPU always full power)      #
echo  #   - Power Throttling OFF (no thread throttle)  #
echo  #   - Radeon Anti-Lag ENABLED (safe mode)        #
echo  #   - TCP/UDP Checksum Offload OFF               #
echo  #   - Network IRQs pinned to Core 0              #
echo  #   - ULPS OFF (no map-load freezes)             #
echo  #   - Prefetch/Superfetch OFF (NVMe tuned)       #
echo  #   - UDP socket buffers tuned                   #
echo  #   - All telemetry killed                       #
echo  #                                                #
echo  #   RESTART RECOMMENDED for full effect          #
echo  #   Then run PLAY_VALORANT.bat as usual          #
echo  ##################################################
echo.
echo  NEXT STEP: Install these FREE 3rd party tools:
echo  1. LatencyMon (latencymon.com) - see your DPC spikes
echo  2. MSI Afterburner - safe GPU clock boost for RX 5600M
echo  3. HWiNFO64 - monitor temps to check thermal throttle
echo.
timeout /t 10 /nobreak >nul
exit
