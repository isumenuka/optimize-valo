# =========================================
#   EXTREME WINDOWS DEBLOAT (GAMING MODE)
# =========================================

Write-Host "Starting EXTREME debloat..." -ForegroundColor Red

# -----------------------------------------
# KEEP LIST (IMPORTANT - DO NOT REMOVE)
# -----------------------------------------
$keepApps = @(
"*store*",                 # Microsoft Store
"*windowscalculator*",     # Calculator
"*photos*",                # Photos (optional but safe)
"*netframework*",          # .NET (important)
"*vclibs*",                # C++ libs
"*ui.xaml*",               # UI framework
"*windows.shell*",         # Core shell
"*windows.startmenu*",     # Start menu
"*windows.defender*"       # Security core
)

# -----------------------------------------
# REMOVE ALL OTHER APPS
# -----------------------------------------
Get-AppxPackage -AllUsers | ForEach-Object {
    $appName = $_.Name
    $remove = $true

    foreach ($keep in $keepApps) {
        if ($appName -like $keep) {
            $remove = $false
        }
    }

    if ($remove) {
        Write-Host "Removing: $appName"
        Remove-AppxPackage -Package $_.PackageFullName -ErrorAction SilentlyContinue
    }
}

# -----------------------------------------
# REMOVE PROVISIONED APPS (NEW USERS)
# -----------------------------------------
Get-AppxProvisionedPackage -Online | ForEach-Object {
    $appName = $_.DisplayName
    $remove = $true

    foreach ($keep in $keepApps) {
        if ($appName -like $keep) {
            $remove = $false
        }
    }

    if ($remove) {
        Write-Host "Removing provisioned: $appName"
        Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
    }
}

# -----------------------------------------
# REMOVE XBOX COMPLETELY
# -----------------------------------------
Get-AppxPackage *xbox* -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
Get-Service *xbox* | Stop-Service -Force -ErrorAction SilentlyContinue
Get-Service *xbox* | Set-Service -StartupType Disabled

# -----------------------------------------
# DISABLE TELEMETRY
# -----------------------------------------
Stop-Service "DiagTrack" -ErrorAction SilentlyContinue
Set-Service "DiagTrack" -StartupType Disabled

# -----------------------------------------
# DISABLE CORTANA
# -----------------------------------------
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f

# -----------------------------------------
# REMOVE ONEDRIVE
# -----------------------------------------
taskkill /f /im OneDrive.exe 2>$null
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall 2>$null

# -----------------------------------------
# DISABLE BACKGROUND APPS
# -----------------------------------------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f

# -----------------------------------------
# DISABLE ADS / SUGGESTIONS
# -----------------------------------------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f

# -----------------------------------------
# FINAL CLEANUP
# -----------------------------------------
Write-Host "Cleaning temp files..."
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "=========================================" -ForegroundColor Green
Write-Host "   EXTREME DEBLOAT COMPLETE!" -ForegroundColor Green
Write-Host "   RESTART YOUR PC NOW" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Green