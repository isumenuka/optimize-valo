@echo off
setlocal EnableDelayedExpansion
color 0b
title === SETUP CLI TOOLS - ONE TIME DOWNLOAD ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0b
echo.
echo  ##################################################
echo  #   CLI TOOLS SETUP  ^|  One-Time Download        #
echo  #   Downloads command-line tools only (no UI)    #
echo  #   All tools auto-used by your .bat scripts     #
echo  ##################################################
echo.

set TOOLS=%~dp0tools
set TEMP_PS=%TOOLS%\build_temp

if not exist "%TOOLS%" mkdir "%TOOLS%"
if not exist "%TEMP_PS%" mkdir "%TEMP_PS%"

echo  [*] Downloading to: %TOOLS%\
echo  [*] Sources: Microsoft Sysinternals (official)
echo.
timeout /t 2 /nobreak >nul

:: ==============================
echo  [1/6] pskill.exe - Kill processes better than taskkill...
:: ==============================
powershell -NoProfile -NonInteractive -Command "Invoke-WebRequest -Uri 'https://live.sysinternals.com/pskill.exe' -OutFile '%TOOLS%\pskill.exe' -UseBasicParsing"
if exist "%TOOLS%\pskill.exe" (
    echo      [OK] pskill.exe downloaded
    reg add "HKCU\Software\Sysinternals\PsKill" /v EulaAccepted /t REG_DWORD /d 1 /f >nul 2>&1
) else (
    echo      [WARN] pskill.exe failed
)

:: ==============================
echo  [2/6] pslist.exe - List running processes from CMD...
:: ==============================
powershell -NoProfile -NonInteractive -Command "Invoke-WebRequest -Uri 'https://live.sysinternals.com/pslist.exe' -OutFile '%TOOLS%\pslist.exe' -UseBasicParsing"
if exist "%TOOLS%\pslist.exe" (
    echo      [OK] pslist.exe downloaded
    reg add "HKCU\Software\Sysinternals\PsList" /v EulaAccepted /t REG_DWORD /d 1 /f >nul 2>&1
) else (
    echo      [WARN] pslist.exe failed
)

:: ==============================
echo  [3/6] autorunsc.exe - Manage startup items from CMD...
:: ==============================
powershell -NoProfile -NonInteractive -Command "Invoke-WebRequest -Uri 'https://live.sysinternals.com/autorunsc.exe' -OutFile '%TOOLS%\autorunsc.exe' -UseBasicParsing"
if exist "%TOOLS%\autorunsc.exe" (
    echo      [OK] autorunsc.exe downloaded
    reg add "HKCU\Software\Sysinternals\Autoruns" /v EulaAccepted /t REG_DWORD /d 1 /f >nul 2>&1
) else (
    echo      [WARN] autorunsc.exe failed
)

:: ==============================
echo  [4/6] RAMMap.exe - Deep standby RAM flush tool...
:: ==============================
powershell -NoProfile -NonInteractive -Command "Invoke-WebRequest -Uri 'https://live.sysinternals.com/RAMMap.exe' -OutFile '%TOOLS%\RAMMap.exe' -UseBasicParsing"
if exist "%TOOLS%\RAMMap.exe" (
    echo      [OK] RAMMap.exe downloaded
    reg add "HKCU\Software\Sysinternals\RAMMap" /v EulaAccepted /t REG_DWORD /d 1 /f >nul 2>&1
) else (
    echo      [WARN] RAMMap.exe failed
)

:: ==============================
echo  [5/6] Building EmptyStandbyList.exe (clears standby RAM pool)...
:: ==============================
:: Uses a pre-written .ps1 file - no heredoc issues inside .bat
copy /y "%~dp0tools\build_esl.ps1" "%TOOLS%\build_esl.ps1" >nul 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%TOOLS%\build_esl.ps1"
if exist "%TOOLS%\EmptyStandbyList.exe" (
    echo      [OK] EmptyStandbyList.exe compiled OK
) else (
    echo      [WARN] Compile failed - GAMING_BOOST uses native fallback
)

:: ==============================
echo  [6/6] Building PingCheck.exe (Valorant server ping monitor)...
:: ==============================
copy /y "%~dp0tools\build_ping.ps1" "%TOOLS%\build_ping.ps1" >nul 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%TOOLS%\build_ping.ps1"
if exist "%TOOLS%\PingCheck.exe" (
    echo      [OK] PingCheck.exe compiled OK
) else (
    echo      [WARN] PingCheck compile failed
)

:: Clean up temp build folder
rd /s /q "%TEMP_PS%" >nul 2>&1

:: ==============================
echo.
echo  ##################################################
echo  #   TOOLS READY IN: %TOOLS%
echo  ##################################################
echo.
echo  Files installed:
dir "%TOOLS%" /b
echo.
echo  ##################################################
echo  #   HOW TOOLS ARE USED:                          #
echo  #                                                #
echo  #   pskill.exe        ^ GAMING_BOOST kills bloat  #
echo  #   pslist.exe        ^ view all processes        #
echo  #   EmptyStandbyList  ^ clears standby RAM pool   #
echo  #   PingCheck.exe     ^ live ping to Valorant AP  #
echo  #   autorunsc.exe     ^ manage startup from CMD   #
echo  #   RAMMap.exe        ^ deep RAM flush             #
echo  #                                                #
echo  #   GAMING_BOOST auto-detects these each loop!   #
echo  ##################################################
echo.
timeout /t 5 /nobreak >nul
exit
