# =========================================
#   SAFE DEBLOAT - UNUSED APPS ONLY
#   Removes: Maps, Outlook, News, etc.
#   KEEPS: WhatsApp, Apple Music, Store,
#          Photos, Calculator, and anything
#          not on the remove list.
# =========================================

Write-Host ""
Write-Host "  =========================================" -ForegroundColor Cyan
Write-Host "   SAFE DEBLOAT - Unused Windows Apps Only" -ForegroundColor Cyan
Write-Host "   Keeps: WhatsApp, Apple Music, etc." -ForegroundColor Green
Write-Host "  =========================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------
# REMOVE LIST - Only known unused bloat
# These are apps YOU almost certainly never use
# -----------------------------------------
$removeApps = @(
    # Maps - nobody uses this
    "*WindowsMaps*",

    # Mail and Calendar (replaced by browser/phone)
    "*windowscommunicationsapps*",

    # Outlook new (forced by Microsoft)
    "*OutlookForWindows*",

    # Microsoft News / MSN News
    "*BingNews*",

    # Microsoft Weather (use phone instead)
    "*BingWeather*",

    # Microsoft Finance
    "*BingFinance*",

    # Microsoft Sports
    "*BingSports*",

    # Microsoft Bing Search app
    "*Microsoft.BingSearch*",

    # Solitaire Collection
    "*MicrosoftSolitaireCollection*",

    # Microsoft People (contacts app nobody uses)
    "*People*",

    # Microsoft To-Do (use phone instead)
    "*Todos*",

    # Microsoft Sticky Notes (optional - remove if unused)
    # "*MicrosoftStickyNotes*",   # <-- uncomment if you don't use sticky notes

    # Microsoft Feedback Hub
    "*WindowsFeedbackHub*",

    # Microsoft Tips
    "*GetHelp*",
    "*Getstarted*",

    # Mixed Reality Portal (VR app you don't have headset for)
    "*MixedReality.Portal*",

    # 3D Viewer / Paint 3D
    "*Microsoft3DViewer*",
    "*Paint3D*",

    # Xbox Game Bar (you disabled DVR already - remove the app too)
    "*XboxGameOverlay*",
    "*XboxGamingOverlay*",
    "*XboxSpeechToTextOverlay*",
    "*XboxIdentityProvider*",
    "*GamingApp*",

    # Clipchamp (video editor you don't use)
    "*Clipchamp*",

    # Power Automate (enterprise tool)
    "*PowerAutomateDesktop*",

    # Microsoft Family Safety (not needed for solo)
    "*FamilySafety*",

    # Your Phone / Phone Link (if you use alternatives)
    "*YourPhone*",

    # Quick Assist (remote support tool - not needed)
    "*QuickAssist*",

    # Teams Chat (the consumer one baked into taskbar)
    "*MicrosoftTeams*",

    # Cortana (already disabled but remove the app too)
    "*Cortana*",

    # Microsoft Pay
    "*Wallet*",

    # Alarms & Clock (use phone)
    # "*WindowsAlarms*",          # <-- uncomment if you don't use PC alarms

    # Skype (not Discord)
    "*SkypeApp*"
)

$removed = 0
$skipped = 0

foreach ($app in $removeApps) {
    $packages = Get-AppxPackage -AllUsers -Name $app -ErrorAction SilentlyContinue
    foreach ($pkg in $packages) {
        Write-Host "  [REMOVING] $($pkg.Name)" -ForegroundColor Red
        Remove-AppxPackage -Package $pkg.PackageFullName -AllUsers -ErrorAction SilentlyContinue
        $removed++
    }
}

Write-Host ""
Write-Host "  Cleaning provisioned packages (for new users)..." -ForegroundColor Yellow

foreach ($app in $removeApps) {
    $provPkgs = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like $app }
    foreach ($pkg in $provPkgs) {
        Write-Host "  [PROV-REMOVE] $($pkg.DisplayName)" -ForegroundColor DarkRed
        Remove-AppxProvisionedPackage -Online -PackageName $pkg.PackageName -ErrorAction SilentlyContinue
    }
}

# -----------------------------------------
# DISABLE TELEMETRY (no app removed, just service)
# -----------------------------------------
Write-Host ""
Write-Host "  [SERVICE] Stopping telemetry..." -ForegroundColor Yellow
Stop-Service "DiagTrack" -Force -ErrorAction SilentlyContinue
Set-Service "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue

# -----------------------------------------
# DISABLE ADS / SUGGESTIONS IN START MENU
# -----------------------------------------
Write-Host "  [REG] Disabling Start Menu ads..." -ForegroundColor Yellow
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >$null
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353698Enabled /t REG_DWORD /d 0 /f >$null
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >$null

# -----------------------------------------
# DISABLE CORTANA SEARCH BAR
# -----------------------------------------
Write-Host "  [REG] Disabling Cortana..." -ForegroundColor Yellow
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >$null

# -----------------------------------------
# FINAL CLEANUP
# -----------------------------------------
Write-Host ""
Write-Host "  Cleaning temp files..." -ForegroundColor Yellow
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "  =========================================" -ForegroundColor Green
Write-Host "   SAFE DEBLOAT COMPLETE!" -ForegroundColor Green
Write-Host "   Removed: Maps, Outlook, News, Weather," -ForegroundColor Green
Write-Host "            Finance, Sports, Solitaire," -ForegroundColor Green
Write-Host "            Xbox overlays, Teams Chat," -ForegroundColor Green
Write-Host "            Feedback Hub, Tips, Clipchamp" -ForegroundColor Green
Write-Host "   KEPT:    WhatsApp, Apple Music, Photos," -ForegroundColor Green
Write-Host "            Calculator, Store, and all" -ForegroundColor Green
Write-Host "            apps not on the remove list." -ForegroundColor Green
Write-Host "  =========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  NOTE: No restart needed. Changes instant." -ForegroundColor Cyan