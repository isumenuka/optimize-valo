@echo off
setlocal EnableDelayedExpansion
color 0a
title === VALORANT MASTER LAUNCHER - DELL G5 5505 ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0a
echo.
echo  ##################################################
echo  #   VALORANT MASTER LAUNCHER                    #
echo  #   Dell G5 5505  ^|  Just double-click and go   #
echo  #                                               #
echo  #   Auto-runs everything in the right order:    #
echo  #   [A] Startup Cleaner   (once a month auto)  #
echo  #   [B] Deep Boost        (once ever auto)      #
echo  #   [C] Engine Boost      (once ever auto)      #
echo  #   [D] Play Valorant     (every session)       #
echo  #   [E] Gaming Boost      (auto starts after)   #
echo  ##################################################
echo.
echo  [*] Checking what needs to run today...
echo.
timeout /t 2 /nobreak >nul

:: =====================================================
:: DETECT SCRIPT DIRECTORY (scripts must be same folder)
:: =====================================================
set "SCRIPT_DIR=%~dp0"

:: =====================================================
:: REGISTRY KEY FOR TRACKING WHAT WAS ALREADY RUN
:: =====================================================
set "REG_ROOT=HKCU\Software\ValorantLauncher"

:: =====================================================
:: STEP A: STARTUP CLEANER - ONCE A MONTH CHECK
:: =====================================================
echo  ================================================
echo  [A] Checking STARTUP CLEANER (runs once a month)
echo  ================================================

:: Get current year+month as YYYYMM
for /f "tokens=1-3 delims=/-" %%a in ('powershell -Command "Get-Date -Format 'yyyy/MM'"') do set "CURRENT_MONTH=%%a%%b"
for /f %%i in ('powershell -Command "Get-Date -Format 'yyyyMM'"') do set "CURRENT_MONTH=%%i"

:: Check last run month from registry
for /f "tokens=3" %%i in ('reg query "%REG_ROOT%" /v "LastCleanerMonth" 2^>nul ^| findstr /i "LastCleanerMonth"') do set "LAST_CLEANER_MONTH=%%i"

if "!LAST_CLEANER_MONTH!" == "!CURRENT_MONTH!" (
    echo      [SKIP] Startup Cleaner already ran this month ^(!CURRENT_MONTH!^)
) else (
    echo      [RUN] Startup Cleaner hasn't run this month - running now...
    echo.
    call "%SCRIPT_DIR%STARTUP_CLEANER.bat"
    cls
    color 0a
    :: Save this month to registry so we skip next time this month
    reg add "%REG_ROOT%" /v "LastCleanerMonth" /t REG_SZ /d "!CURRENT_MONTH!" /f >nul 2>&1
    echo      [DONE] Startup Cleaner complete for month !CURRENT_MONTH!
)
echo.

:: =====================================================
:: STEP B: DEEP BOOST - ONCE EVER (unless reset)
:: =====================================================
echo  ================================================
echo  [B] Checking DEEP BOOST (runs once ever)
echo  ================================================

for /f "tokens=3" %%i in ('reg query "%REG_ROOT%" /v "DeepBoostDone" 2^>nul ^| findstr /i "DeepBoostDone"') do set "DEEP_DONE=%%i"

if "!DEEP_DONE!" == "1" (
    echo      [SKIP] Deep Boost already applied - skipping
) else (
    echo      [RUN] Deep Boost not yet applied - running now...
    echo.
    call "%SCRIPT_DIR%DEEP_BOOST.bat"
    cls
    color 0a
    reg add "%REG_ROOT%" /v "DeepBoostDone" /t REG_DWORD /d 1 /f >nul 2>&1
    echo      [DONE] Deep Boost applied and saved
)
echo.

:: =====================================================
:: STEP C: ENGINE BOOST - ONCE EVER (unless reset)
:: =====================================================
echo  ================================================
echo  [C] Checking ENGINE BOOST (runs once ever)
echo  ================================================

for /f "tokens=3" %%i in ('reg query "%REG_ROOT%" /v "EngineBoostDone" 2^>nul ^| findstr /i "EngineBoostDone"') do set "ENGINE_DONE=%%i"

if "!ENGINE_DONE!" == "1" (
    echo      [SKIP] Engine Boost already applied - skipping
) else (
    echo      [RUN] Engine Boost not yet applied - running now...
    echo.
    call "%SCRIPT_DIR%ENGINE_BOOST.bat"
    cls
    color 0a
    reg add "%REG_ROOT%" /v "EngineBoostDone" /t REG_DWORD /d 1 /f >nul 2>&1
    echo      [DONE] Engine Boost applied and saved
)
echo.

:: =====================================================
:: STEP D: PLAY VALORANT - RUNS EVERY SESSION
:: =====================================================
echo  ================================================
echo  [D] Running PLAY VALORANT (every session)
echo  ================================================
echo      [RUN] Applying all 44 session tweaks...
echo.
call "%SCRIPT_DIR%PLAY_VALORANT.bat"
cls
color 0a
echo      [DONE] Play Valorant tweaks applied + Game launching...
echo.

:: =====================================================
:: STEP E: GAMING BOOST - STARTS IN BACKGROUND WINDOW
:: =====================================================
echo  ================================================
echo  [E] Starting GAMING BOOST (background monitor)
echo  ================================================
echo      [RUN] Launching Gaming Boost in separate window...
echo      [*]   It will wait for Valorant to start automatically
echo      [*]   Keep that window open during your game
echo.
start "GAMING BOOST - KEEP OPEN" "%SCRIPT_DIR%GAMING_BOOST.bat"
timeout /t 2 /nobreak >nul

:: =====================================================
:: DONE
:: =====================================================
echo  ##################################################
echo  #   ALL STEPS COMPLETE - GLHF!                  #
echo  #                                               #
echo  #   [A] Startup Cleaner  -  DONE / SKIPPED      #
echo  #   [B] Deep Boost       -  DONE / SKIPPED      #
echo  #   [C] Engine Boost     -  DONE / SKIPPED      #
echo  #   [D] Play Valorant    -  DONE                 #
echo  #   [E] Gaming Boost     -  RUNNING (other win) #
echo  #                                               #
echo  #   Valorant is launching - this window closes  #
echo  #   in 8 seconds automatically.                 #
echo  ##################################################
echo.
echo  TIP: If you re-run DEEP_BOOST or ENGINE_BOOST manually,
echo  they will be re-applied next time you run LAUNCH.bat
echo  (or run RESET_FLAGS.bat to force re-run everything)
echo.
timeout /t 8 /nobreak >nul
exit
