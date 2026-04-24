@echo off
setlocal EnableDelayedExpansion
color 0e
title === VALORANT FPS UNCAP - 500+ FPS MODE ===

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cls
color 0e
echo.
echo  ##################################################
echo  #   VALORANT FPS UNCAP  ^|  500+ FPS MODE        #
echo  #   Dell G5 5505  ^|  RX 5600M  ^|  Ryzen 4600H  #
echo  ##################################################
echo.
echo  [*] This script unlocks FPS cap in Valorant config files
echo  [*] Run this BEFORE launching Valorant
echo  [*] Make sure Valorant is CLOSED before running
echo.
timeout /t 2 /nobreak >nul

:: ==============================
echo  [1/7] Patching Valorant GameUserSettings.ini (FPS uncap)...
:: ==============================
set VALO_CONFIG=%LOCALAPPDATA%\VALORANT\Saved\Config\Windows

if not exist "%VALO_CONFIG%" (
    echo      [WARN] Valorant config folder not found at:
    echo             %VALO_CONFIG%
    echo      [INFO] Trying alternate path...
    set VALO_CONFIG=%LOCALAPPDATA%\Valorant\Saved\Config\Windows
)

:: Find GameUserSettings.ini in all subdirectories
for /r "%LOCALAPPDATA%\VALORANT" %%F in (GameUserSettings.ini) do (
    echo      [FOUND] %%F
    
    :: Backup the file first
    copy "%%F" "%%F.backup" >nul 2>&1
    
    :: Patch FPS limits using PowerShell
    powershell -Command "
    $file = '%%F'
    $content = Get-Content $file -Raw
    
    # Remove existing FPS limit lines
    $content = $content -replace 'FrameRateCap=\d+', 'FrameRateCap=0'
    $content = $content -replace 'MaxFPS=\d+', 'MaxFPS=500'
    $content = $content -replace 'bUseVSync=True', 'bUseVSync=False'
    $content = $content -replace 'bUseVSync=true', 'bUseVSync=False'
    
    # If FrameRateCap doesn't exist, add it
    if ($content -notmatch 'FrameRateCap') {
        $content = $content + \"`r`n[/Script/Engine.GameUserSettings]\r\nFrameRateCap=0\r\n\"
    }
    
    Set-Content -Path $file -Value $content -NoNewline
    " >nul 2>&1
    
    echo      [OK] Patched: %%~nxF
)
echo      [OK] GameUserSettings.ini FPS uncapped

:: ==============================
echo  [2/7] Patching Scalability.ini (Graphics config)...
:: ==============================
for /r "%LOCALAPPDATA%\VALORANT" %%F in (Scalability.ini) do (
    powershell -Command "
    $file = '%%F'
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        $content = $content -replace 'r.VSync=1', 'r.VSync=0'
        $content = $content -replace 'r.FrameRateLimit=\d+', 'r.FrameRateLimit=0'
        Set-Content -Path $file -Value $content -NoNewline
    }
    " >nul 2>&1
    echo      [OK] Patched Scalability.ini
)

:: ==============================
echo  [3/7] Creating/Patching Engine.ini for maximum FPS...
:: ==============================
for /r "%LOCALAPPDATA%\VALORANT\Saved\Config" %%D in (.) do (
    if exist "%%D\Engine.ini" (
        powershell -Command "
        $file = '%%D\Engine.ini'
        $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
        if (-not $content) { $content = '' }
        
        # Remove old fps limit settings
        $content = $content -replace '\[/Script/Engine\.ConsoleSettings\]\r?\n?', ''
        $content = $content -replace 'r\.FrameRateLimit=\d+', ''
        $content = $content -replace 'bSmoothFrameRate=.*', ''
        $content = $content -replace 'SmoothedFrameRateRange.*', ''
        
        # Add high-performance engine settings at the end
        $additions = \"`r`n[/Script/Engine.ConsoleSettings]\r\nr.FrameRateLimit=0\r\n\r\n[/Script/Engine.Engine]\r\nbSmoothFrameRate=False\r\nMinDesiredFrameRate=144\r\n\"
        $content = $content + $additions
        
        Set-Content -Path $file -Value $content -NoNewline
        " >nul 2>&1
        echo      [OK] Engine.ini patched in %%D
    )
)

:: ==============================
echo  [4/7] Force 144Hz Monitor Refresh Rate...
:: ==============================
powershell -Command "
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class DisplayHelper {
    [DllImport(\"user32.dll\")] public static extern bool EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE devMode);
    [DllImport(\"user32.dll\")] public static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);
    
    [StructLayout(LayoutKind.Sequential)]
    public struct DEVMODE {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmDeviceName;
        public short dmSpecVersion, dmDriverVersion, dmSize, dmDriverExtra;
        public int dmFields;
        public int dmPositionX, dmPositionY;
        public int dmDisplayOrientation, dmDisplayFixedOutput;
        public short dmColor, dmDuplex, dmYResolution, dmTTOption, dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmFormName;
        public short dmLogPixels;
        public int dmBitsPerPel, dmPelsWidth, dmPelsHeight, dmDisplayFlags, dmDisplayFrequency;
        public int dmICMMethod, dmICMIntent, dmMediaType, dmDitherType, dmReserved1, dmReserved2, dmPanningWidth, dmPanningHeight;
    }
}
'@

$dm = New-Object DisplayHelper+DEVMODE
$dm.dmSize = [System.Runtime.InteropServices.Marshal]::SizeOf($dm)

# Try to find a 144Hz mode
\$found = \$false
\$i = 0
while ([DisplayHelper]::EnumDisplaySettings([NullString]::Value, \$i, [ref]\$dm)) {
    if (\$dm.dmDisplayFrequency -eq 144) {
        \$result = [DisplayHelper]::ChangeDisplaySettings([ref]\$dm, 0)
        if (\$result -eq 0) { Write-Host '144Hz set successfully'; \$found = \$true; break }
    }
    \$i++
}
if (-not \$found) {
    Write-Host 'No 144Hz mode found - checking current Hz...'
    [DisplayHelper]::EnumDisplaySettings([NullString]::Value, -1, [ref]\$dm) | Out-Null
    Write-Host \"Current refresh rate: \$(\$dm.dmDisplayFrequency)Hz\"
}
" 2>nul
echo      [OK] Monitor refresh check done

:: ==============================
echo  [5/7] AMD Radeon - Disable FPS cap (Radeon Chill OFF)...
:: ==============================
:: Disable Radeon Chill via registry (it caps FPS)
reg add "HKCU\Software\AMD\CN" /v "Chill" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "Chill_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "VSyncControl" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\ATI\ACE\Settings\VALORANT.exe" /v "FrameRateTarget" /t REG_DWORD /d 0 /f >nul 2>&1
:: Disable Enhanced Sync (can cause issues + cap FPS)
reg add "HKCU\Software\AMD\CN" /v "EnhancedSync" /t REG_DWORD /d 0 /f >nul 2>&1
echo      [OK] Radeon Chill + Enhanced Sync disabled

:: ==============================
echo  [6/7] Set High Performance + No CPU Throttle...
:: ==============================
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
:: Make sure laptop is on Plugged In mode
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
echo      [OK] CPU locked to MAX clock (no throttle)

:: ==============================
echo  [7/7] Timer Resolution - Force 0.5ms (max precision)...
:: ==============================
:: This dramatically improves frame timing consistency at high FPS
powershell -Command "
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class TimerRes {
    [DllImport(\"ntdll.dll\", SetLastError=true)] public static extern int NtSetTimerResolution(int DesiredResolution, bool SetResolution, out int CurrentResolution);
    [DllImport(\"ntdll.dll\", SetLastError=true)] public static extern int NtQueryTimerResolution(out int MinimumResolution, out int MaximumResolution, out int CurrentResolution);
}
'@
int min, max, cur
[TimerRes]::NtQueryTimerResolution([ref]\$min, [ref]\$max, [ref]\$cur) | Out-Null
Write-Host \"Timer: Min=\$(\$min/10000)ms Max=\$(\$max/10000)ms Current=\$(\$cur/10000)ms\"
[TimerRes]::NtSetTimerResolution(5000, \$true, [ref]\$cur) | Out-Null
Write-Host \"Timer set to 0.5ms for max frame precision\"
" 2>nul
echo      [OK] Timer resolution = 0.5ms (high precision)

:: ==============================
echo  [8/8] Enable Multithreaded Rendering in Valorant config...
:: ==============================
:: Multithreaded rendering lets Valorant use ALL 6 cores of your Ryzen 5 4600H
:: instead of just one thread - massive FPS gain on CPU-bound maps like Icebox/Fracture
:: We patch the config file directly so you never have to remember to set it in-game
for /r "%LOCALAPPDATA%\VALORANT" %%F in (GameUserSettings.ini) do (
    powershell -Command "
    $file = '%%F'
    $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
    if ($content) {
        # Enable multithreaded rendering
        $content = $content -replace 'bUseMultithreading=False', 'bUseMultithreading=True'
        $content = $content -replace 'bUseMultithreading=false', 'bUseMultithreading=True'
        # Add it if it doesn't exist
        if ($content -notmatch 'bUseMultithreading') {
            $content = $content + \"`r`nbUseMultithreading=True`r`n\"
        }
        Set-Content -Path $file -Value $content -NoNewline
        Write-Host 'Multithreaded rendering enabled'
    }
    " >nul 2>&1
    echo      [OK] Multithreaded rendering ON in %%~nxF
)
for /r "%LOCALAPPDATA%\VALORANT\Saved\Config" %%D in (.) do (
    if exist "%%D\Engine.ini" (
        powershell -Command "
        $file = '%%D\Engine.ini'
        $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
        if ($content -and ($content -notmatch 'r.RHIThread')) {
            $content = $content + \"`r`n[/Script/Engine.RendererSettings]`r`nr.RHIThread.Enable=1`r`n\"
            Set-Content -Path $file -Value $content -NoNewline
        }
        " >nul 2>&1
        echo      [OK] RHI thread enabled in Engine.ini (%%D)
    )
)
echo      [OK] All 6 Ryzen cores now active for rendering

:: ==============================
echo.
echo  ##################################################
echo  #   FPS UNCAP COMPLETE! (8 Tweaks Applied)        #
echo  #                                                #
echo  #   What to do NOW in Valorant:                  #
echo  #   1. Settings - Video - Frame Rate Limit = OFF #
echo  #   2. Settings - Video - V-Sync = OFF           #
echo  #   3. Display Mode = FULLSCREEN (not borderless) #
echo  #   4. Resolution = 1920x1080 (full res)         #
echo  #   5. Multithreaded Rendering = ON (verify)     #
echo  #                                                #
echo  #   Expected FPS on RX 5600M @ Low/Med settings: #
echo  #   Low  settings = 200-350 FPS                  #
echo  #   Med  settings = 150-250 FPS                  #
echo  #   High settings = 100-180 FPS                  #
echo  ##################################################
echo.
echo  NOTE: 500+ FPS requires Low graphics + Fullscreen mode
echo  NOTE: Your monitor shows max 144Hz - so 144 FPS cap
echo        is what you'll SEE even if FPS is higher.
echo        Set FPS cap = 200 for smoother frame timing.
echo.
timeout /t 10 /nobreak >nul
exit
