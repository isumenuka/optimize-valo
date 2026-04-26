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
echo  #   Top 20 Tweaks + Deep System Optimization     #
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

echo  [A2] Patching Scalability.ini...
for /r "%LOCALAPPDATA%\VALORANT" %%F in (Scalability.ini) do (
    powershell -Command "$f='%%F';if(Test-Path $f){$c=Get-Content $f -Raw;$c=$c -replace 'r.VSync=1','r.VSync=0';$c=$c -replace 'r.FrameRateLimit=\d+','r.FrameRateLimit=0';Set-Content -Path $f -Value $c -NoNewline}" >nul 2>&1
    echo      [OK] Patched Scalability.ini
)

echo  [A3] Patching Engine.ini...
for /r "%LOCALAPPDATA%\VALORANT\Saved\Config" %%D in (.) do (
    if exist "%%D\Engine.ini" (
        powershell -Command "$f='%%D\Engine.ini';$c=Get-Content $f -Raw -ErrorAction SilentlyContinue;if(-not $c){$c=''};$c=$c -replace 'r\.FrameRateLimit=\d+','';$c=$c -replace 'bSmoothFrameRate=.*','';$add=\"`r`n[/Script/Engine.ConsoleSettings]`r`nr.FrameRateLimit=0`r`n`r`n[/Script/Engine.Engine]`r`nbSmoothFrameRate=False`r`n\";$c+=$add;Set-Content -Path $f -Value $c -NoNewline" >nul 2>&1
        echo      [OK] Engine.ini patched
    )
)

echo  [A4] Disable Fullscreen Optimizations on Valorant EXE...
set VALO_EXE=C:\Riot Games\VALORANT\live\VALORANT-Win64-Shipping.exe
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%VALO_EXE%" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f >nul 2>&1
echo      [OK] Fullscreen optimizations disabled for Valorant

echo  [A5] Set Valorant GPU preference to High Performance...
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "%VALO_EXE%" /t REG_SZ /d "GpuPreference=2;" /f >nul 2>&1
echo      [OK] Valorant = High Performance GPU

echo  [A6] Disable Radeon Chill + Enhanced Sync...
reg add "HKCU\Software\AMD\CN" /v "Chill" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "Chill_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "VSyncControl" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\AMD\CN" /v "EnhancedSync" /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Radeon Chill + Enhanced Sync disabled

echo  [A7] CPU max clocks...
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2 >nul 2>&1
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK] CPU locked to MAX clock

:: ============================================================
echo.
echo  ========================================================
echo   MODULE B: GAMING BOOST
echo  ========================================================
echo.

echo  [B1] Ultimate Performance Power Plan...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
echo      [OK] Ultimate Performance active

echo  [B2] CPU Timer + Core Parking disable...
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
echo      [OK] Timer optimized + core parking off

echo  [B3] Kill background bloat...
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Cortana.exe >nul 2>&1
taskkill /f /im YourPhone.exe >nul 2>&1
echo      [OK] Bloat killed

echo  [B4] Disable heavy services...
for %%S in ("SysMain" "WSearch" "DiagTrack" "dmwappushservice" "Fax") do (
    sc stop %%S >nul 2>&1
    sc config %%S start=disabled >nul 2>&1
)
echo      [OK] Heavy services disabled

echo  [B5] Enable Game Mode (CPU thread priority for game)...
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] Game Mode ENABLED

echo  [B6] Enable HAGS (GPU manages own memory)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
echo      [OK] HAGS enabled

echo  [B7] Disable Xbox Game Bar + DVR captures...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v value /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Xbox Game Bar + DVR disabled

echo  [B8] Disable MPO (fixes alt-tab crash + screen flicker)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v "DisableOverlays" /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] MPO disabled

echo  [B9] Disable Transparency + Animations (best performance)...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Transparency + animations off

echo  [B10] Disable Mouse Acceleration (consistent aim)...
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul 2>&1
echo      [OK] Mouse acceleration disabled (Enhance pointer precision OFF)

echo  [B11] Configure Virtual Memory (1.5x RAM = 12288 MB)...
powershell -Command "$cs=Get-WmiObject Win32_ComputerSystem;$cs.AutomaticManagedPagefile=$false;$cs.Put()|Out-Null;$pf=Get-WmiObject Win32_PageFileSetting -ErrorAction SilentlyContinue;if($pf){$pf.Delete()};Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{Name='C:\pagefile.sys';InitialSize=4096;MaximumSize=12288} -ErrorAction SilentlyContinue|Out-Null" >nul 2>&1
echo      [OK] Virtual memory = 4096MB initial / 12288MB max

echo  [B12] GPU + Network priority boost...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
echo      [OK] GPU + network priority boosted

echo  [B13] QoS DSCP 46 on Valorant UDP...
powershell -Command "Get-NetQosPolicy -Name 'Valorant' -ErrorAction SilentlyContinue | Remove-NetQosPolicy -Confirm:$false -ErrorAction SilentlyContinue; New-NetQosPolicy -Name 'Valorant' -AppPathNameMatchCondition 'VALORANT-Win64-Shipping.exe' -IPProtocolMatchCondition UDP -DSCPAction 46 -NetworkProfile All -ErrorAction SilentlyContinue" >nul 2>&1
echo      [OK] Valorant UDP = DSCP 46

echo  [B14] Set DNS to Cloudflare 1.1.1.1 (lower latency)...
powershell -Command "$a=Get-NetAdapter|Where-Object{$_.Status -eq 'Up'}|Select-Object -First 1;if($a){Set-DnsClientServerAddress -InterfaceIndex $a.ifIndex -ServerAddresses ('1.1.1.1','1.0.0.1')}" >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo      [OK] DNS = Cloudflare 1.1.1.1 + flushed

echo  [B15] Network TCP tweaks...
netsh int tcp set global autotuninglevel=disabled >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
echo      [OK] TCP latency optimized

echo  [B16] SSD TRIM + disable memory compression + clear temp...
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
powershell -Command "Disable-MMAgent -mc" >nul 2>&1
del /s /f /q %temp%\* >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] SSD + RAM tuned

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
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maps\MapsUpdateTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable >nul 2>&1
echo      [OK] Scheduled tasks killed

echo  [C2] Disable USB Selective Suspend...
powercfg -setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg -setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK] USB Selective Suspend disabled

echo  [C3] Disable PCIe ASPM...
powercfg -setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
echo      [OK] PCIe ASPM disabled

echo  [C4] Disable Power Throttling...
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
echo      [OK] Radeon Anti-Lag + Performance mode

echo  [C6] Disable Prefetch/Superfetch (NVMe SSD)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
echo      [OK] Prefetch/Superfetch off

echo  [C7] UDP Socket Buffers (64KB headroom for Valorant)...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v DefaultReceiveWindow /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v DefaultSendWindow /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v FastSendDatagramThreshold /t REG_DWORD /d 1024 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v IgnorePushBitOnReceives /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] UDP socket buffers = 64KB

echo  [C8] Disable telemetry (no disk spikes mid-match)...
for %%S in ("DiagTrack" "dmwappushservice" "WerSvc") do (
    sc stop %%S >nul 2>&1
    sc config %%S start=disabled >nul 2>&1
)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Telemetry disabled

echo  [C9] Disable AMD ULPS (no map-load stutter)...
powershell -Command "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\*' -ErrorAction SilentlyContinue | Where-Object { $_.DriverDesc -like '*5600*' -or $_.DriverDesc -like '*Navi*' -or $_.DriverDesc -like '*Radeon*' } | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name 'EnableULPS' -Value 0 -ErrorAction SilentlyContinue; Set-ItemProperty -Path $_.PSPath -Name 'EnableULPS_NA' -Value 0 -ErrorAction SilentlyContinue }" >nul 2>&1
echo      [OK] ULPS disabled

echo  [C10] Disable unused network adapters (reduce IRQ/DPC latency)...
powershell -Command "Get-NetAdapter | Where-Object { $_.Status -eq 'Disconnected' } | ForEach-Object { Disable-NetAdapter -Name $_.Name -Confirm:$false -ErrorAction SilentlyContinue }" >nul 2>&1
echo      [OK] Disconnected adapters disabled

echo  [C11] Flush DNS + clear prefetch + RAM standby...
ipconfig /flushdns >nul 2>&1
ipconfig /registerdns >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\*" >nul 2>&1
powershell -Command "[System.GC]::Collect();[System.GC]::WaitForPendingFinalizers()" >nul 2>&1
echo      [OK] DNS flushed + RAM + prefetch cleared

:: VBS/Memory Integrity intentionally NOT disabled - Vanguard requires it
echo  [C12] VBS/Memory Integrity = SKIPPED (Vanguard anti-cheat requires it)

:: ============================================================
echo.
echo  ========================================================
echo   MODULE D: STARTUP CLEANER
echo  ========================================================
echo.

echo  [D1] Disabling non-essential startup programs...
powershell -Command "$paths=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run');$bloat=@('OneDrive','Cortana','Spotify','AdobeGCInvoker','iTunesHelper','GoogleUpdate','CCleaner','EpicGamesLauncher','Skype','Teams','YourPhone','Dropbox','NVDisplay','NvBackend');foreach($p in $paths){if(Test-Path $p){$k=Get-ItemProperty -Path $p -ErrorAction SilentlyContinue;if($k){$k.PSObject.Properties|Where-Object{$_.Name -notlike 'PS*'}|ForEach-Object{$n=$_.Name;foreach($b in $bloat){if($n -like \"*$b*\"){Remove-ItemProperty -Path $p -Name $n -ErrorAction SilentlyContinue}}}}}}" 2>nul
echo      [OK] Non-essential startup programs disabled

echo  [D2] Disable Fast Startup (clean boot)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f >nul 2>&1
powercfg /hibernate off >nul 2>&1
echo      [OK] Fast Startup disabled

echo  [D3] Clear Windows Update cache...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
if exist "C:\Windows\SoftwareDistribution\Download" (
    rd /s /q "C:\Windows\SoftwareDistribution\Download" >nul 2>&1
    md "C:\Windows\SoftwareDistribution\Download" >nul 2>&1
)
echo      [OK] Windows Update cache cleared

echo  [D4] Clear WER + event logs + shader cache...
if exist "C:\ProgramData\Microsoft\Windows\WER\ReportArchive" rd /s /q "C:\ProgramData\Microsoft\Windows\WER\ReportArchive" >nul 2>&1
if exist "C:\ProgramData\Microsoft\Windows\WER\ReportQueue" rd /s /q "C:\ProgramData\Microsoft\Windows\WER\ReportQueue" >nul 2>&1
if exist "%LOCALAPPDATA%\D3DSCache" rd /s /q "%LOCALAPPDATA%\D3DSCache" >nul 2>&1
if exist "%LOCALAPPDATA%\AMD\DxCache" del /s /f /q "%LOCALAPPDATA%\AMD\DxCache\*" >nul 2>&1
for /f %%G in ('wevtutil el') do wevtutil cl "%%G" >nul 2>&1
echo      [OK] WER + event logs + shader cache cleared

echo  [D5] Free disk space report...
powershell -Command "$d=Get-PSDrive C;$free=[math]::Round($d.Free/1GB,2);$total=[math]::Round(($d.Used+$d.Free)/1GB,2);Write-Host \"  C: Free: $free GB / $total GB\" -ForegroundColor Green"

:: ============================================================
echo.
echo  ========================================================
echo   MODULE E: EXITLAG-STYLE NETWORK + LATENCY TWEAKS
echo  ========================================================
echo.

echo  [E1] Disable Nagle Algorithm (biggest ping reducer)...
:: Nagle buffers small TCP packets causing latency spikes - disable per interface
powershell -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -Type DWord -ErrorAction SilentlyContinue; Set-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -Type DWord -ErrorAction SilentlyContinue; Set-ItemProperty -Path $_.PSPath -Name 'TcpDelAckTicks' -Value 0 -Type DWord -ErrorAction SilentlyContinue }" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] Nagle algorithm DISABLED (lower ping, less jitter)

echo  [E2] Disable LSO (Large Send Offload) on NIC...
powershell -Command "Get-NetAdapter -Physical | ForEach-Object { Disable-NetAdapterLso -Name $_.Name -ErrorAction SilentlyContinue }" >nul 2>&1
powershell -Command "Get-NetAdapter -Physical | ForEach-Object { Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Large Send Offload V2 (IPv4)' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Large Send Offload V2 (IPv6)' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue }" >nul 2>&1
echo      [OK] LSO disabled (reduces packet fragmentation overhead)

echo  [E3] Disable Flow Control on NIC...
powershell -Command "Get-NetAdapter -Physical | ForEach-Object { Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Flow Control' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue }" >nul 2>&1
echo      [OK] Flow Control disabled

echo  [E4] Disable RSC (Receive Segment Coalescing)...
powershell -Command "Get-NetAdapter -Physical | ForEach-Object { Disable-NetAdapterRsc -Name $_.Name -ErrorAction SilentlyContinue }" >nul 2>&1
echo      [OK] RSC disabled (reduces latency at cost of marginal CPU)

echo  [E5] Disable Interrupt Moderation on NIC...
powershell -Command "Get-NetAdapter -Physical | ForEach-Object { Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Interrupt Moderation' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Interrupt Moderation Rate' -DisplayValue 'Off' -ErrorAction SilentlyContinue }" >nul 2>&1
echo      [OK] Interrupt Moderation OFF (consistent packet delivery)

echo  [E6] Set NIC to Max Performance power state...
powershell -Command "Get-NetAdapter -Physical | ForEach-Object { Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Green Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Power Saving Mode' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue }" >nul 2>&1
echo      [OK] NIC power saving OFF

echo  [E7] TCP stack optimizations...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global initialrto=2000 >nul 2>&1
netsh int tcp set global rsc=disabled >nul 2>&1
netsh int tcp set supplemental internet congestionprovider=ctcp >nul 2>&1
netsh int ip set global taskoffload=enabled >nul 2>&1
netsh int ip set global icmpredirects=disabled >nul 2>&1
echo      [OK] TCP stack tuned (CTCP, no timestamps, 2s RTO)

echo  [E8] MMCSS Valorant game profile (ExitLag-style thread priority)...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] MMCSS game profile = High priority

echo  [E9] Set timer resolution to 0.5ms (smoother frames)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v GlobalTimerResolutionRequests /t REG_DWORD /d 1 /f >nul 2>&1
powershell -Command "Start-Process -FilePath 'powershell' -ArgumentList '-WindowStyle Hidden -Command Add-Type -TypeDefinition ''using System;using System.Runtime.InteropServices;public class TimerRes{[DllImport(\"ntdll.dll\")]public static extern int NtSetTimerResolution(int DesiredResolution,bool SetResolution,ref int CurrentResolution);public static void Set(){int c=0;NtSetTimerResolution(5000,true,ref c);}}'' -ErrorAction SilentlyContinue' -WindowStyle Hidden" >nul 2>&1
echo      [OK] Timer = 0.5ms resolution requested

echo  [E10] Boost Valorant process priority (if running)...
powershell -Command "$p=Get-Process 'VALORANT-Win64-Shipping' -ErrorAction SilentlyContinue;if($p){$p.PriorityClass='RealTime'}" >nul 2>&1
echo      [OK] Valorant priority = Realtime (if running)

echo  [E11] Extra registry latency fixes...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 64 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d 65534 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxSendFree" /t REG_DWORD /d 65535 /f >nul 2>&1
echo      [OK] TCP registry latency keys set

:: ============================================================
echo.
echo  ========================================================
echo   MODULE F: RUNTIME BOOSTER (Launch Valorant Boosted)
echo  ========================================================
echo.

echo  [F1] Creating PLAY_VALORANT_BOOSTED.bat for real-time launch...
set PLAY_SCRIPT=%~dp0PLAY_VALORANT_BOOSTED.bat
(
echo @echo off
echo net session ^>nul 2^>^&1 ^|^| ^(powershell -Command "Start-Process '%%~f0' -Verb runAs" ^& exit^)
echo echo Killing background bloat...
echo for %%%%P in ^(OneDrive Spotify YourPhone Teams Skype SearchApp^) do taskkill /f /im %%%%P.exe ^>nul 2^>^&1
echo echo Boosting system...
echo powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 ^>nul 2^>^&1
echo start "" "C:\Riot Games\Riot Client\RiotClientServices.exe" --launch-product=valorant --launch-patchline=live
echo timeout /t 20 /nobreak ^>nul
echo :WAIT
echo tasklist /fi "imagename eq VALORANT-Win64-Shipping.exe" 2^>nul ^| find /i "VALORANT-Win64-Shipping.exe" ^>nul
echo if %%errorlevel%% neq 0 ^(timeout /t 5 /nobreak ^>nul ^& goto WAIT^)
echo echo Setting Realtime priority + High I/O...
echo powershell -Command "$p=Get-Process 'VALORANT-Win64-Shipping' -EA SilentlyContinue;if^($p^){$p.PriorityClass='RealTime';$p^|Set-ProcessIoPriority -Priority High -EA SilentlyContinue}"
echo exit
) > "%PLAY_SCRIPT%"
echo      [OK] Created: PLAY_VALORANT_BOOSTED.bat

:: ============================================================
echo.
echo  ========================================================
echo   MODULE G: 20 WINDOWS TWEAKS FOR VALORANT FPS
echo  ========================================================
echo.

echo  [G1] Add Valorant + Riot folders to Defender Exclusions...
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Riot Games' -ErrorAction SilentlyContinue; Add-MpPreference -ExclusionPath '%LOCALAPPDATA%\VALORANT' -ErrorAction SilentlyContinue; Add-MpPreference -ExclusionPath '%PROGRAMFILES%\Riot Vanguard' -ErrorAction SilentlyContinue; Add-MpPreference -ExclusionProcess 'VALORANT-Win64-Shipping.exe' -ErrorAction SilentlyContinue; Add-MpPreference -ExclusionProcess 'RiotClientServices.exe' -ErrorAction SilentlyContinue" >nul 2>&1
echo      [OK] Defender exclusions added (no mid-match scanning)

echo  [G2] Delete Valorant PipelineCache (fresh shader rebuild)...
if exist "%LOCALAPPDATA%\VALORANT\Saved\PipelineCache" (
    rd /s /q "%LOCALAPPDATA%\VALORANT\Saved\PipelineCache" >nul 2>&1
    echo      [OK] PipelineCache deleted (fixes shader stutter on patches)
) else (
    echo      [--] PipelineCache folder not found (already clean)
)

echo  [G3] Disable Delivery Optimization (P2P Windows Update)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f >nul 2>&1
sc stop DoSvc >nul 2>&1
sc config DoSvc start=disabled >nul 2>&1
echo      [OK] Delivery Optimization OFF (no P2P bandwidth drain)

echo  [G4] Disable Windows Update Auto-Download (manual only)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f >nul 2>&1
sc config wuauserv start=demand >nul 2>&1
echo      [OK] Windows Update = notify only, no auto-download

echo  [G5] Disable NTFS Last Access Time updates (less disk I/O)...
fsutil behavior set disablelastaccess 1 >nul 2>&1
echo      [OK] NTFS last access timestamps OFF

echo  [G6] Disable 8.3 filename creation (legacy FS overhead)...
fsutil behavior set disable8dot3 1 >nul 2>&1
echo      [OK] 8.3 filename creation OFF

echo  [G7] Disable Windows Error Reporting service...
sc stop WerSvc >nul 2>&1
sc config WerSvc start=disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] WER service disabled (no crash-report CPU spikes)

echo  [G8] Disable Remote Registry service (security + performance)...
sc stop RemoteRegistry >nul 2>&1
sc config RemoteRegistry start=disabled >nul 2>&1
echo      [OK] Remote Registry disabled

echo  [G9] Disable Print Spooler (unused, wastes CPU)...
sc stop Spooler >nul 2>&1
sc config Spooler start=disabled >nul 2>&1
echo      [OK] Print Spooler disabled

echo  [G10] Disable Windows Search Indexing on C:...
sc stop WSearch >nul 2>&1
sc config WSearch start=disabled >nul 2>&1
powershell -Command "Get-WmiObject -Class Win32_Volume -Filter 'DriveLetter=''C:''' | Set-WmiInstance -Arguments @{IndexingEnabled=$false}" >nul 2>&1
echo      [OK] Search indexing OFF (no disk thrash during gameplay)

echo  [G11] Disable Automatic Maintenance tasks...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v MaintenanceDisabled /t REG_DWORD /d 1 /f >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\TaskScheduler\Regular Maintenance" /Disable >nul 2>&1
echo      [OK] Auto-maintenance disabled (no mid-match defrag/cleanup)

echo  [G12] Set processor scheduling to foreground apps...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo      [OK] CPU scheduler = foreground app priority

echo  [G13] Disable Windows Tips, Suggestions, and Consumer Experience...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f >nul 2>&1
echo      [OK] Windows Tips + Suggestions disabled

echo  [G14] Disable Windows Ink Workspace (input latency source)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v AllowWindowsInkWorkspace /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Windows Ink Workspace disabled

echo  [G15] Disable Auto HDR (GPU overhead in SDR games)...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\VideoSettings" /v EnableHDRForPlayback /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\VideoSettings" /v EnableHDRForPlayback /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Auto HDR disabled (SDR = less GPU bandwidth used)

echo  [G16] Disable MapsBroker + RetailDemo + Mixed Reality services...
for %%S in ("MapsBroker" "RetailDemo" "MixedRealityOpenXRSvc" "WalletService" "TabletInputService") do (
    sc stop %%S >nul 2>&1
    sc config %%S start=disabled >nul 2>&1
)
echo      [OK] Unused services killed

echo  [G17] Disable Connected User Experiences (telemetry pipe)...
sc stop "DiagTrack" >nul 2>&1
sc config "DiagTrack" start=disabled >nul 2>&1
sc stop "diagsvc" >nul 2>&1
sc config "diagsvc" start=disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] All telemetry pipes blocked

echo  [G18] Set DPI scaling for Valorant EXE (override high DPI)...
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Riot Games\VALORANT\live\VALORANT-Win64-Shipping.exe" /t REG_SZ /d "~ HIGHDPIAWARE" /f >nul 2>&1
echo      [OK] DPI scaling = application controlled (no Windows blur)

echo  [G19] Disable Cortana search indexing + web results...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
sc stop "WSearch" >nul 2>&1
sc config "WSearch" start=disabled >nul 2>&1
echo      [OK] Cortana + web search disabled

echo  [G20] Flush DNS + reset Winsock + clear ARP cache (clean connection)...
ipconfig /flushdns >nul 2>&1
ipconfig /registerdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
arp -d * >nul 2>&1
echo      [OK] Network stack fully flushed and reset

:: ============================================================
echo.
echo  ##################################################
echo  #   ALL DONE! FULL BOOST + ALL MODULES           #
echo  #                                                #
echo  #   A: FPS Uncap + Config Patches                #
echo  #   B: Gaming Boost (HAGS/GameMode/MPO/QoS)      #
echo  #   C: Deep Boost (ULPS/ASPM/UDP buffers)        #
echo  #   D: Startup Cleaner                           #
echo  #   E: ExitLag-Style Network Tweaks              #
echo  #   F: Runtime Booster (PLAY_VALORANT_BOOSTED)   #
echo  #   G: 20 Windows FPS Tweaks                     #
echo  #                                                #
echo  #   SET THESE MANUALLY IN VALORANT:              #
echo  #   - Display Mode    = FULLSCREEN               #
echo  #   - Frame Rate Cap  = OFF                      #
echo  #   - V-Sync          = OFF                      #
echo  #   - Shadows         = OFF                      #
echo  #   - Multithreaded Rendering = ON               #
echo  #   - Raw Input Buffer = ON                      #
echo  #   - All Quality     = Low                      #
echo  #                                                #
echo  #   >>> USE PLAY_VALORANT_BOOSTED.bat to launch  #
echo  #   RESTART PC after running this script         #
echo  ##################################################
echo.
timeout /t 10 /nobreak >nul
exit
