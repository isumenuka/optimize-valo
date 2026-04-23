@echo off
color 0a
title GOD MODE - INSANE GAMING BOOST

echo =========================================
echo     GOD MODE + INSANE OPTIMIZATION
echo =========================================

:: ==============================
:: POWER PLAN (ULTIMATE)
:: ==============================
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61

:: ==============================
:: CPU + TIMER OPTIMIZATION
:: ==============================
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1

:: ==============================
:: CPU CORE PARKING DISABLE
:: ==============================
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1

:: ==============================
:: KILL BACKGROUND APPS
:: ==============================
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Cortana.exe >nul 2>&1
taskkill /f /im YourPhone.exe >nul 2>&1

:: ==============================
:: DISABLE HEAVY SERVICES
:: ==============================
for %%S in (
"SysMain"
"WSearch"
"DiagTrack"
"dmwappushservice"
"Fax"
"Spooler"
) do (
  sc stop %%S >nul 2>&1
  sc config %%S start=disabled >nul 2>&1
)

:: ==============================
:: PRIORITY + GPU + NETWORK BOOST
:: ==============================
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul

:: ==============================
:: BACKGROUND APPS OFF
:: ==============================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul

:: ==============================
:: VISUAL PERFORMANCE BOOST
:: ==============================
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul

:: ==============================
:: NETWORK LATENCY TWEAKS
:: ==============================
netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global chimney=enabled >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global dca=enabled >nul
netsh int tcp set global ecncapability=disabled >nul

:: ==============================
:: SSD OPTIMIZATION
:: ==============================
fsutil behavior set DisableDeleteNotify 0 >nul

:: ==============================
:: DISABLE MEMORY COMPRESSION
:: ==============================
powershell -Command "Disable-MMAgent -mc" >nul 2>&1

:: ==============================
:: CLEAR CACHE + TEMP
:: ==============================
ipconfig /flushdns >nul
del /s /f /q %temp%\* >nul 2>&1
rd /s /q %temp% >nul 2>&1
md %temp%

:: ==============================
:: DISABLE STARTUP DELAY
:: ==============================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul

:: ==============================
:: OPTIONAL: DISABLE UPDATE (COMMENTED SAFE)
:: ==============================
:: sc stop wuauserv
:: sc config wuauserv start=disabled

:: ==============================
:: FINAL MESSAGE
:: ==============================
echo =========================================
echo   INSANE MODE COMPLETE!
echo   RESTART YOUR PC NOW
echo =========================================
pause