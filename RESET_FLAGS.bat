@echo off
setlocal EnableDelayedExpansion
color 0c
title === RESET FLAGS - Force Re-Run All Scripts ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0c
echo.
echo  ##################################################
echo  #   RESET FLAGS                                 #
echo  #   Forces LAUNCH.bat to re-run everything      #
echo  #   including Deep Boost + Engine Boost         #
echo  ##################################################
echo.
echo  [*] This will reset all "already done" flags.
echo  [*] Next time you run LAUNCH.bat, ALL scripts
echo  [*] will run again from scratch (useful after
echo  [*] a Windows update or driver reinstall).
echo.
timeout /t 3 /nobreak >nul

reg delete "HKCU\Software\ValorantLauncher" /f >nul 2>&1
echo      [OK] All flags cleared!
echo.
echo  ##################################################
echo  #   DONE - Now run LAUNCH.bat to apply all      #
echo  #   optimizations fresh from scratch.           #
echo  ##################################################
echo.
timeout /t 5 /nobreak >nul
exit
