@echo off
:: Auto-run as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

:: Run PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0debloat_gaming.ps1"
pause