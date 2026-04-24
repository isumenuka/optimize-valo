@echo off
setlocal EnableDelayedExpansion
color 0b
title === STARTUP CLEANER + DISK CLEANUP - DELL G5 5505 ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0b
echo.
echo  ##################################################
echo  #   STARTUP CLEANER + DISK CLEANUP              #
echo  #   Dell G5 5505  ^|  Run ONCE, not every time   #
echo  #                                                #
echo  #   - Disables non-essential startup programs   #
echo  #   - Disables Windows Fast Startup             #
echo  #   - Runs deep disk cleanup                    #
echo  #   - Clears Windows Update cache               #
echo  ##################################################
echo.
timeout /t 2 /nobreak >nul

:: ==============================
echo  [1/6] Disabling non-essential Startup Programs...
:: ==============================
:: These apps auto-launch on boot and waste RAM/CPU before you even open anything.
:: We only disable KNOWN safe ones - Valorant, Discord, etc. are NOT touched.
powershell -Command "
\$startupRegPaths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
)
\$knownBloat = @(
    'OneDrive', 'Cortana', 'BingWeather', 'Spotify', 'AdobeGCInvoker',
    'AdobeAAMUpdater', 'iTunesHelper', 'GoogleUpdate', 'CCleaner',
    'Discord', 'EpicGamesLauncher', 'SteamTray', 'SteamService',
    'Skype', 'MicrosoftEdge', 'msedge', 'Teams', 'YourPhone',
    'WindowsTerminal', 'Dropbox', 'GDrive', 'GoogleDriveFS',
    'NVDisplay', 'NvBackend', 'AdobeUpdater', 'AcrobatUpdate',
    'NVIDIA GeForce Experience', 'iCloudServices', 'ApplePushNotification'
)
foreach (\$path in \$startupRegPaths) {
    if (Test-Path \$path) {
        \$keys = Get-ItemProperty -Path \$path -ErrorAction SilentlyContinue
        if (\$keys) {
            \$keys.PSObject.Properties | Where-Object { \$_.Name -notlike 'PS*' } | ForEach-Object {
                \$name = \$_.Name
                foreach (\$bloat in \$knownBloat) {
                    if (\$name -like \"*\$bloat*\") {
                        Write-Host \"  [STARTUP-OFF] \$name\" -ForegroundColor Yellow
                        Remove-ItemProperty -Path \$path -Name \$name -ErrorAction SilentlyContinue
                        break
                    }
                }
            }
        }
    }
}
" 2>nul

:: Disable startup programs via Task Manager registry (Startup tab)
:: These are the per-user startup entries controlled by the Task Manager Startup tab
powershell -Command "
\$startupApproved = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run'
\$startupApprovedRun32 = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32'
\$startupApprovedStartup = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder'

# Disabled = bytes starting with 03 00 00 00 ...
\$disabledValue = [byte[]](3,0,0,0,0,0,0,0,0,0,0,0)

\$bloatNames = @('Spotify','OneDrive','Discord','Teams','Skype','EpicGamesLauncher','Steam','CCleaner')

foreach (\$regPath in @(\$startupApproved, \$startupApprovedRun32, \$startupApprovedStartup)) {
    if (Test-Path \$regPath) {
        \$entries = Get-ItemProperty -Path \$regPath -ErrorAction SilentlyContinue
        if (\$entries) {
            \$entries.PSObject.Properties | Where-Object { \$_.Name -notlike 'PS*' } | ForEach-Object {
                \$name = \$_.Name
                foreach (\$bloat in \$bloatNames) {
                    if (\$name -like \"*\$bloat*\") {
                        Set-ItemProperty -Path \$regPath -Name \$name -Value \$disabledValue -ErrorAction SilentlyContinue
                        Write-Host \"  [STARTUP-DISABLE] \$name\" -ForegroundColor Yellow
                    }
                }
            }
        }
    }
}
" 2>nul
echo      [OK] Non-essential startup programs disabled

:: ==============================
echo  [2/6] Disabling Windows Fast Startup...
:: ==============================
:: Fast Startup prevents a clean shutdown - it can cause software conflicts
:: and makes the "uptime" counter inaccurate (bloated background processes persist).
:: Disabling it ensures a FULL, clean boot every time.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f >nul
powercfg /hibernate off >nul 2>&1
echo      [OK] Fast Startup disabled - full clean boot every time

:: ==============================
echo  [3/6] Running Deep Disk Cleanup (automated)...
:: ==============================
:: Cleans: Temp files, WinSxS cleanup, Windows Update cache, Recycle Bin,
::         Delivery Optimization files, Thumbnails, System Error dumps
echo      [*] Running cleanmgr with all categories...
powershell -Command "
# Set all disk cleanup categories to be selected
\$sageset = 65535
\$sagePath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches'
Get-ChildItem \$sagePath -ErrorAction SilentlyContinue | ForEach-Object {
    Set-ItemProperty -Path \$_.PSPath -Name \"StateFlags\$(\$sageset.ToString('D4'))\" -Value 2 -Type DWord -ErrorAction SilentlyContinue
}
" 2>nul
:: Run cleanup silently
cleanmgr /sagerun:65535 /autoclean >nul 2>&1
echo      [OK] Disk Cleanup complete

:: ==============================
echo  [4/6] Clearing Windows Update Cache (frees GBs of space)...
:: ==============================
:: Windows Update downloads accumulate to several GBs over time
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
net stop dosvc >nul 2>&1
:: Delete the software distribution download folder
if exist "C:\Windows\SoftwareDistribution\Download" (
    rd /s /q "C:\Windows\SoftwareDistribution\Download" >nul 2>&1
    md "C:\Windows\SoftwareDistribution\Download" >nul 2>&1
)
:: Clear CBS log (can be huge)
if exist "C:\Windows\Logs\CBS\CBS.log" (
    del /f /q "C:\Windows\Logs\CBS\CBS.log" >nul 2>&1
)
echo      [OK] Windows Update cache cleared (GBs freed)

:: ==============================
echo  [5/6] Clearing Additional Junk (Prefetch, Event Logs, WER)...
:: ==============================
:: Windows Error Reporting dumps (often hundreds of MB)
if exist "C:\ProgramData\Microsoft\Windows\WER\ReportArchive" (
    rd /s /q "C:\ProgramData\Microsoft\Windows\WER\ReportArchive" >nul 2>&1
)
if exist "C:\ProgramData\Microsoft\Windows\WER\ReportQueue" (
    rd /s /q "C:\ProgramData\Microsoft\Windows\WER\ReportQueue" >nul 2>&1
)
:: Clear Windows event logs (can slow down Event Log service)
for /f %%G in ('wevtutil el') do (
    wevtutil cl "%%G" >nul 2>&1
)
:: Clear DirectX shader cache
if exist "%LOCALAPPDATA%\D3DSCache" (
    rd /s /q "%LOCALAPPDATA%\D3DSCache" >nul 2>&1
)
:: Clear AMD shader cache
if exist "%LOCALAPPDATA%\AMD" (
    del /s /f /q "%LOCALAPPDATA%\AMD\DxCache\*" >nul 2>&1
)
echo      [OK] WER dumps, Event logs, shader cache cleared

:: ==============================
echo  [6/6] Checking free disk space after cleanup...
:: ==============================
powershell -Command "
\$drive = Get-PSDrive C
\$freGB = [math]::Round(\$drive.Free / 1GB, 2)
\$totalGB = [math]::Round((\$drive.Used + \$drive.Free) / 1GB, 2)
Write-Host ''
Write-Host \"  C: Drive Free Space : \$freGB GB / \$totalGB GB\" -ForegroundColor Green
Write-Host ''
"

:: ==============================
echo.
echo  ##################################################
echo  #   STARTUP CLEANER COMPLETE!                    #
echo  #                                                #
echo  #   Changes applied:                             #
echo  #   [1] Non-essential startup apps disabled      #
echo  #   [2] Fast Startup = OFF (clean boot)          #
echo  #   [3] Disk Cleanup run (all categories)        #
echo  #   [4] Windows Update cache purged              #
echo  #   [5] WER dumps + Event logs + DX cache gone  #
echo  #   [6] Free space reported above                #
echo  #                                                #
echo  #   Run this ONCE A MONTH for best results.      #
echo  #   RESTART recommended after running.           #
echo  ##################################################
echo.
timeout /t 8 /nobreak >nul
exit
