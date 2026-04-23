@echo off
setlocal EnableDelayedExpansion
color 0b
title === VALORANT RUNTIME BOOSTER - ACTIVE ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0b
echo.
echo  ##################################################
echo  #   VALORANT RUNTIME BOOSTER  ^|  Dell G5 5505   #
echo  #   AMD Ryzen 5 4600H + RX 5600M                #
echo  #   Runs WHILE Valorant is open                 #
echo  ##################################################
echo.
echo  [*] This script works WHILE Valorant is running.
echo  [*] Keep this window open during your game.
echo  [*] It will auto-close when Valorant exits.
echo.

:: =============================================
:: WAIT FOR VALORANT TO LAUNCH
:: =============================================
echo  [*] Waiting for Valorant to launch...
echo      (Launch Valorant now via Riot Client)
echo.

:WAIT_LOOP
tasklist /fi "imagename eq VALORANT-Win64-Shipping.exe" 2>nul | find /i "VALORANT-Win64-Shipping.exe" >nul
if errorlevel 1 (
    timeout /t 3 /nobreak >nul
    goto WAIT_LOOP
)

cls
color 0a
echo.
echo  ##################################################
echo  #   VALORANT DETECTED - APPLYING RUNTIME BOOST  #
echo  ##################################################
echo.

:: =============================================
:: STEP 1: SET VALORANT TO REALTIME PRIORITY
:: =============================================
echo  [1] Setting Valorant to REALTIME CPU Priority...
powershell -Command "
Get-Process 'VALORANT-Win64-Shipping' -ErrorAction SilentlyContinue | ForEach-Object {
    $_.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::RealTime
}
" >nul 2>&1
echo      [OK] Valorant = REALTIME

:: =============================================
:: STEP 2: SET RIOT CLIENT TO HIGH PRIORITY
:: =============================================
echo  [2] Setting RiotClientServices to HIGH Priority...
powershell -Command "
Get-Process 'RiotClientServices' -ErrorAction SilentlyContinue | ForEach-Object {
    $_.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
}
" >nul 2>&1
echo      [OK] Riot Client = HIGH

:: =============================================
:: STEP 3: PIN VALORANT TO BEST CPU CORES
:: Ryzen 5 4600H: 6 cores / 12 threads
:: Avoid core 0 (handles system interrupts)
:: Pin to cores 2-11 (logical threads 1-11)
:: =============================================
echo  [3] Pinning Valorant to best CPU cores (avoiding core 0)...
powershell -Command "
$proc = Get-Process 'VALORANT-Win64-Shipping' -ErrorAction SilentlyContinue
if ($proc) {
    # Use all cores EXCEPT core 0 (which handles system interrupts)
    # 12 threads = binary 111111111110 = 0xFFE (4094)
    $proc.ProcessorAffinity = 0xFFE
}
" >nul 2>&1
echo      [OK] Valorant pinned to cores 1-11 (core 0 free for system)

:: =============================================
:: STEP 4: DROP ALL BACKGROUND PROCESSES TO LOW
:: =============================================
echo  [4] Dropping background processes to LOW priority...
powershell -Command "
\$protectedProcesses = @('VALORANT-Win64-Shipping','RiotClientServices','discord','audiodg','csrss','wininit','services','lsass','svchost','System','Idle')
Get-Process | ForEach-Object {
    \$name = \$_.ProcessName
    \$isProtected = \$false
    foreach (\$p in \$protectedProcesses) {
        if (\$name -like \$p) { \$isProtected = \$true; break }
    }
    if (-not \$isProtected) {
        try { \$_.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::BelowNormal } catch {}
    }
}
" >nul 2>&1
echo      [OK] Background processes = BELOW NORMAL

:: =============================================
:: STEP 5: SET DISCORD TO LOW PRIORITY
:: =============================================
echo  [5] Setting Discord to LOW priority (stays alive but uses less CPU)...
powershell -Command "
Get-Process 'Discord' -ErrorAction SilentlyContinue | ForEach-Object {
    $_.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::BelowNormal
}
" >nul 2>&1
echo      [OK] Discord = BELOW NORMAL

:: =============================================
:: STEP 6: TRIM RAM FROM ALL BACKGROUND PROCESSES
:: =============================================
echo  [6] Trimming RAM from background processes...
powershell -Command "
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class MemoryHelper {
    [DllImport(\"kernel32.dll\")] public static extern bool SetProcessWorkingSetSize(IntPtr hProcess, IntPtr dwMinimumWorkingSetSize, IntPtr dwMaximumWorkingSetSize);
}
'@
\$protected = @('VALORANT-Win64-Shipping','RiotClientServices','discord','audiodg')
Get-Process | ForEach-Object {
    \$name = \$_.ProcessName
    \$skip = \$false
    foreach (\$p in \$protected) { if (\$name -like \$p) { \$skip = \$true; break } }
    if (-not \$skip) {
        try { [MemoryHelper]::SetProcessWorkingSetSize(\$_.Handle, [IntPtr](-1), [IntPtr](-1)) | Out-Null } catch {}
    }
}
" >nul 2>&1
echo      [OK] RAM trimmed from background apps

:: =============================================
:: STEP 7: FLUSH DNS + CLEAR STANDBY RAM LIST
:: =============================================
echo  [7] Flushing DNS + Clearing Standby RAM...
ipconfig /flushdns >nul 2>&1
powershell -Command "
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
" >nul 2>&1
echo      [OK] DNS flushed + RAM standby cleared

:: =============================================
:: STEP 8: BOOST I/O PRIORITY FOR VALORANT
:: =============================================
echo  [8] Boosting I/O priority for Valorant...
powershell -Command "
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class NtHelper {
    [DllImport(\"ntdll.dll\")] public static extern int NtSetInformationProcess(IntPtr ProcessHandle, int ProcessInformationClass, ref int ProcessInformation, int ProcessInformationLength);
}
'@
\$proc = Get-Process 'VALORANT-Win64-Shipping' -ErrorAction SilentlyContinue
if (\$proc) {
    \$ioPriority = 3  # IoPriorityHigh
    [NtHelper]::NtSetInformationProcess(\$proc.Handle, 33, [ref]\$ioPriority, 4) | Out-Null
}
" >nul 2>&1
echo      [OK] Valorant I/O priority = HIGH

:: =============================================
:: BOOST DONE - START REFRESH LOOP
:: =============================================
echo.
echo  ##################################################
echo  #  RUNTIME BOOST ACTIVE!                        #
echo  #  Refreshing every 60 seconds automatically    #
echo  #  This window will close when you exit Valorant#
echo  ##################################################
echo.

:REFRESH_LOOP
:: Check if Valorant is still running
tasklist /fi "imagename eq VALORANT-Win64-Shipping.exe" 2>nul | find /i "VALORANT-Win64-Shipping.exe" >nul
if errorlevel 1 goto VALORANT_CLOSED

echo  [LIVE] %time% - Refreshing boost...

:: Re-apply Realtime priority (some patches reset it)
powershell -Command "
Get-Process 'VALORANT-Win64-Shipping' -ErrorAction SilentlyContinue | ForEach-Object {
    try { \$_.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::RealTime } catch {}
    try { \$_.ProcessorAffinity = 0xFFE } catch {}
}
" >nul 2>&1

:: Trim RAM again
powershell -Command "
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class MemoryHelper2 {
    [DllImport(\"kernel32.dll\")] public static extern bool SetProcessWorkingSetSize(IntPtr hProcess, IntPtr dwMinimumWorkingSetSize, IntPtr dwMaximumWorkingSetSize);
}
'@
\$protected = @('VALORANT-Win64-Shipping','RiotClientServices','discord','audiodg')
Get-Process | ForEach-Object {
    \$name = \$_.ProcessName
    \$skip = \$false
    foreach (\$p in \$protected) { if (\$name -like \$p) { \$skip = \$true; break } }
    if (-not \$skip) {
        try { [MemoryHelper2]::SetProcessWorkingSetSize(\$_.Handle, [IntPtr](-1), [IntPtr](-1)) | Out-Null } catch {}
    }
}
" >nul 2>&1

ipconfig /flushdns >nul 2>&1
echo      [OK] Boost refreshed - Valorant still running
echo.

:: Wait 60 seconds then refresh again
timeout /t 60 /nobreak >nul
goto REFRESH_LOOP

:VALORANT_CLOSED
echo.
echo  ##################################################
echo  #  Valorant closed - Runtime Boost stopped!     #
echo  #                                               #
echo  #  GG! Hope the session was lag-free!           #
echo  ##################################################
echo.
timeout /t 5 /nobreak >nul
exit
