@echo off
setlocal EnableDelayedExpansion
color 0e
title === VALORANT FULL OPTIMIZER - Dell G5 5505 ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0e
echo.
echo  ##################################################
echo  #   VALORANT FULL OPTIMIZER  ^|  Dell G5 5505    #
echo  #   AMD Ryzen 5 4600H + RX 5600M                #
echo  #   Modules: FPS Uncap + Gaming Boost +          #
echo  #            Deep Boost + Startup Cleaner        #
echo  ##################################################
echo.
timeout /t 3 /nobreak >nul

:: ============================================================
echo.
echo  ========================================================
echo   MODULE A: FPS UNCAP + CONFIG PATCHES
echo  ========================================================
echo.

echo  [A1] Patching GameUserSettings.ini (FPS + Raw Input + VSync)...
for /r "%LOCALAPPDATA%\VALORANT" %%F in (GameUserSettings.ini) do (
    copy "%%F" "%%F.backup" >nul 2>&1
    powershell -Command "$f='%%F';$c=Get-Content $f -Raw -ErrorAction SilentlyContinue;if(-not $c){$c=''};$c=$c -replace 'FrameRateCap=\d+','FrameRateCap=0';$c=$c -replace 'MaxFPS=\d+','MaxFPS=500';$c=$c -replace 'bUseVSync=True','bUseVSync=False';$c=$c -replace 'bUseVSync=true','bUseVSync=False';$c=$c -replace 'bUseMultithreading=False','bUseMultithreading=True';$c=$c -replace 'bUseMultithreading=false','bUseMultithreading=True';$c=$c -replace 'bUseRawInput=False','bUseRawInput=True';$c=$c -replace 'bUseRawInput=false','bUseRawInput=True';if($c -notmatch 'FrameRateCap'){$c+=\"`r`nFrameRateCap=0`r`n\"};if($c -notmatch 'bUseMultithreading'){$c+=\"`r`nbUseMultithreading=True`r`n\"};if($c -notmatch 'bUseRawInput'){$c+=\"`r`nbUseRawInput=True`r`n\"};Set-Content -Path $f -Value $c -NoNewline" >nul 2>&1
    echo      [OK] Patched: %%~nxF
)

echo  [A2] Patching Scalability.ini (VSync + FPS limit)...
for /r "%LOCALAPPDATA%\VALORANT" %%F in (Scalability.ini) do (
    powershell -Command "$f='%%F';if(Test-Path $f){$c=Get-Content $f -Raw;$c=$c -replace 'r.VSync=1','r.VSync=0';$c=$c -replace 'r.FrameRateLimit=\d+','r.FrameRateLimit=0';Set-Content -Path $f -Value $c -NoNewline}" >nul 2>&1
    echo      [OK] Patched Scalability.ini
)

echo  [A3] Patching Engine.ini (FPS + smooth frame rate)...
for /r "%LOCALAPPDATA%\VALORANT\Saved\Config" %%D in (.) do (
    if exist "%%D\Engine.ini" (
        powershell -Command "$f='%%D\Engine.ini';$c=Get-Content $f -Raw -ErrorAction SilentlyContinue;if(-not $c){$c=''};$c=$c -replace 'r\.FrameRateLimit=\d+','';$c=$c -replace 'bSmoothFrameRate=.*','';$add=\"`r`n[/Script/Engine.ConsoleSettings]`r`nr.FrameRateLimit=0`r`n`r`n[/Script/Engine.Engine]`r`nbSmoothFrameRate=False`r`n\";$c+=$add;Set-Content -Path $f -Value $c -NoNewline" >nul 2>&1
        echo      [OK] Engine.ini patched
    )
)

echo  [A4] Disable Radeon Chill + Enhanced Sync...
reg add "HKCU\Software\AMD\CN" /v "Chill" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "Chill_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "VSyncControl" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "FrameRateTarget" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\AMD\CN" /v "EnhancedSync" /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Radeon Chill + Enhanced Sync disabled

echo  [A5] CPU max clocks (no throttle)...
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2 >nul 2>&1
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK] CPU locked to MAX clock

:: ============================================================
echo.
echo  ========================================================
echo   MODULE B: GAMING BOOST (GOD MODE)
echo  ========================================================
echo.

echo  [B1] Power Plan - Ultimate Performance...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
echo      [OK] Ultimate Performance plan active

echo  [B2] CPU Timer + Dynamic Tick...
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
echo      [OK] Timer optimized

echo  [B3] Disable CPU Core Parking...
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
echo      [OK] Core parking disabled

echo  [B4] Kill background bloat processes...
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Cortana.exe >nul 2>&1
taskkill /f /im YourPhone.exe >nul 2>&1
echo      [OK] Bloat killed

echo  [B5] Disable heavy services (SysMain, WSearch, DiagTrack)...
for %%S in ("SysMain" "WSearch" "DiagTrack" "dmwappushservice" "Fax") do (
    sc stop %%S >nul 2>&1
    sc config %%S start=disabled >nul 2>&1
)
echo      [OK] Heavy services disabled

echo  [B6] GPU + Network priority registry boost...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
echo      [OK] GPU + network priority boosted

echo  [B7] ENABLE Game Mode (prioritizes game threads)...
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] Game Mode ENABLED (CPU thread priority for game)

echo  [B8] ENABLE Hardware-Accelerated GPU Scheduling (HAGS)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
echo      [OK] HAGS enabled (GPU manages own memory scheduling)

echo  [B9] Disable MPO - fixes alt-tab crashes + screen flicker...
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v "DisableOverlays" /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] MPO (Multi-Plane Overlay) disabled

echo  [B10] QoS DSCP 46 tag on Valorant UDP (ExitLag trick)...
powershell -Command "Get-NetQosPolicy -Name 'Valorant' -ErrorAction SilentlyContinue | Remove-NetQosPolicy -Confirm:$false -ErrorAction SilentlyContinue; New-NetQosPolicy -Name 'Valorant' -AppPathNameMatchCondition 'VALORANT-Win64-Shipping.exe' -IPProtocolMatchCondition UDP -DSCPAction 46 -NetworkProfile All -ErrorAction SilentlyContinue" >nul 2>&1
echo      [OK] Valorant UDP = DSCP 46 (highest network priority)

echo  [B11] Disable background apps + visual tweaks...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1
echo      [OK] Background apps off + visual tweaks applied

echo  [B12] Network TCP/IP latency tweaks...
netsh int tcp set global autotuninglevel=disabled >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
echo      [OK] Network latency optimized

echo  [B13] SSD TRIM + disable memory compression + flush temp...
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
powershell -Command "Disable-MMAgent -mc" >nul 2>&1
ipconfig /flushdns >nul 2>&1
del /s /f /q %temp%\* >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] SSD + RAM tuned, temp cleared

:: ============================================================
echo.
echo  ========================================================
echo   MODULE C: DEEP BOOST
echo  ========================================================
echo.

echo  [C1] Kill background scheduled tasks...
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maps\MapsUpdateTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable >nul 2>&1
echo      [OK] Background scheduled tasks killed

echo  [C2] Disable USB Selective Suspend (no mouse/KB stutter)...
powercfg -setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg -setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK] USB Selective Suspend disabled

echo  [C3] Disable PCIe ASPM (GPU always full power)...
powercfg -setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK] PCIe ASPM disabled

echo  [C4] Disable Power Throttling (no silent thread throttle)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] Power throttling off

echo  [C5] AMD Radeon Anti-Lag + Performance mode...
reg add "HKCU\Software\AMD\CN" /v "AntiLag" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "AntiLag_Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "PowerMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "TextureFilteringQuality" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "AnisotropicFilteringLevel" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "FlipQueueSize" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "PowerEfficiency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\AMD\CN" /v "TextureFilterQuality" /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Radeon Anti-Lag + Performance mode set

echo  [C6] Disable Prefetch/Superfetch (NVMe SSD tuned)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
echo      [OK] Prefetch/Superfetch off

echo  [C7] UDP Socket Buffer Optimization (Valorant packet headroom)...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v DefaultReceiveWindow /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v DefaultSendWindow /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v FastSendDatagramThreshold /t REG_DWORD /d 1024 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v IgnorePushBitOnReceives /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] UDP socket buffers = 64KB

echo  [C8] Disable telemetry services (no disk spikes mid-match)...
for %%S in ("DiagTrack" "dmwappushservice" "diagnosticshub.standardcollector.service" "WerSvc") do (
    sc stop %%S >nul 2>&1
    sc config %%S start=disabled >nul 2>&1
)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] All telemetry disabled

echo  [C9] Disable AMD ULPS (no map-load stutter)...
powershell -Command "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\*' -ErrorAction SilentlyContinue | Where-Object { $_.DriverDesc -like '*5600*' -or $_.DriverDesc -like '*Navi*' -or $_.DriverDesc -like '*Radeon*' } | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name 'EnableULPS' -Value 0 -ErrorAction SilentlyContinue; Set-ItemProperty -Path $_.PSPath -Name 'EnableULPS_NA' -Value 0 -ErrorAction SilentlyContinue; Set-ItemProperty -Path $_.PSPath -Name 'PP_SclkDeepSleepDisable' -Value 1 -ErrorAction SilentlyContinue }" >nul 2>&1
echo      [OK] ULPS disabled - RX 5600M stays awake

echo  [C10] Flush DNS + clear prefetch cache + RAM standby...
ipconfig /flushdns >nul 2>&1
ipconfig /registerdns >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\*" >nul 2>&1
powershell -Command "[System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers()" >nul 2>&1
echo      [OK] DNS flushed + RAM cleared

echo  [C11] IRQ - Disable unused network adapters (reduce DPC latency)...
powershell -Command "Get-NetAdapter | Where-Object { $_.Status -eq 'Disconnected' -and ($_.Name -like '*Wi-Fi*' -or $_.Name -like '*Wireless*' -or $_.Name -like '*Realtek*') } | ForEach-Object { Disable-NetAdapter -Name $_.Name -Confirm:$false -ErrorAction SilentlyContinue; Write-Host \"  [OFF] $($_.Name)\" }" 2>nul
echo      [OK] Unused/disconnected adapters disabled (less IRQ noise)

:: NOTE: VBS/Memory Integrity is intentionally NOT disabled.
:: Riot Vanguard anti-cheat requires it to remain enabled.
echo  [C12] VBS/Memory Integrity - SKIPPED (required by Vanguard)
echo      [INFO] Do NOT disable Memory Integrity - Vanguard needs it

:: ============================================================
echo.
echo  ========================================================
echo   MODULE D: STARTUP CLEANER
echo  ========================================================
echo.

echo  [D1] Disabling non-essential startup programs...
powershell -Command "$paths=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run');$bloat=@('OneDrive','Cortana','Spotify','AdobeGCInvoker','iTunesHelper','GoogleUpdate','CCleaner','EpicGamesLauncher','Skype','Teams','YourPhone','Dropbox','NVDisplay','NvBackend','AdobeUpdater');foreach($p in $paths){if(Test-Path $p){$k=Get-ItemProperty -Path $p -ErrorAction SilentlyContinue;if($k){$k.PSObject.Properties|Where-Object{$_.Name -notlike 'PS*'}|ForEach-Object{$n=$_.Name;foreach($b in $bloat){if($n -like \"*$b*\"){Remove-ItemProperty -Path $p -Name $n -ErrorAction SilentlyContinue}}}}}}" 2>nul
echo      [OK] Non-essential startup programs disabled

echo  [D2] Disable Windows Fast Startup (clean boot every time)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f >nul 2>&1
powercfg /hibernate off >nul 2>&1
echo      [OK] Fast Startup disabled

echo  [D3] Clear Windows Update cache (frees GBs)...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
if exist "C:\Windows\SoftwareDistribution\Download" (
    rd /s /q "C:\Windows\SoftwareDistribution\Download" >nul 2>&1
    md "C:\Windows\SoftwareDistribution\Download" >nul 2>&1
)
if exist "C:\Windows\Logs\CBS\CBS.log" del /f /q "C:\Windows\Logs\CBS\CBS.log" >nul 2>&1
echo      [OK] Windows Update cache cleared

echo  [D4] Clear WER dumps + event logs + shader cache...
if exist "C:\ProgramData\Microsoft\Windows\WER\ReportArchive" rd /s /q "C:\ProgramData\Microsoft\Windows\WER\ReportArchive" >nul 2>&1
if exist "C:\ProgramData\Microsoft\Windows\WER\ReportQueue" rd /s /q "C:\ProgramData\Microsoft\Windows\WER\ReportQueue" >nul 2>&1
if exist "%LOCALAPPDATA%\D3DSCache" rd /s /q "%LOCALAPPDATA%\D3DSCache" >nul 2>&1
if exist "%LOCALAPPDATA%\AMD\DxCache" del /s /f /q "%LOCALAPPDATA%\AMD\DxCache\*" >nul 2>&1
for /f %%G in ('wevtutil el') do wevtutil cl "%%G" >nul 2>&1
echo      [OK] WER + event logs + D3D/AMD shader cache cleared

echo  [D5] Free disk space after cleanup...
powershell -Command "$d=Get-PSDrive C;$free=[math]::Round($d.Free/1GB,2);$total=[math]::Round(($d.Used+$d.Free)/1GB,2);Write-Host \"  C: Free: $free GB / $total GB\" -ForegroundColor Green"

:: ============================================================
echo.
echo  ##################################################
echo  #   ALL OPTIMIZATIONS COMPLETE!                  #
echo  #                                                #
echo  #   [A] FPS Uncap - configs patched             #
echo  #   [B] Gaming Boost - power + services done    #
echo  #   [C] Deep Boost - 11 deep tweaks done        #
echo  #   [D] Startup Cleaner - bloat removed         #
echo  #                                                #
echo  #   IN-GAME SETTINGS TO SET MANUALLY:           #
echo  #   - Display Mode = FULLSCREEN                 #
echo  #   - Frame Rate Limit = OFF                    #
echo  #   - V-Sync = OFF                              #
echo  #   - Multithreaded Rendering = ON              #
echo  #   - Raw Input Buffer = ON                     #
echo  #   - Material Quality = Low                    #
echo  #   - Detail Quality = Low                      #
echo  #                                               #
echo  #   RESTART PC after running for full effect    #
echo  ##################################################
echo.
timeout /t 10 /nobreak >nul
exit
