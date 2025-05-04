# Baidu Cloud Download Sync Script

# 设置PowerShell输出编码为UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Get main tool directory
$mainToolDir = Split-Path -Parent $scriptDir

# Get sync tool path
$syncToolPath = Join-Path $mainToolDir "sync_with_delete.ps1"

Write-Host "========================================"
Write-Host "    Baidu Cloud Sync Tool - Download"
Write-Host "========================================"
Write-Host "Starting to sync files from Baidu Cloud to local..."
Write-Host "Local directory: $scriptDir"
Write-Host ""

# Execute sync tool
if (Test-Path $syncToolPath) {
    # Make sure the current directory is set to where the script lives
    $oldLocation = Get-Location
    Set-Location $mainToolDir
    
    try {
        & $syncToolPath sync_from_remote
    }
    finally {
        # Restore original location
        Set-Location $oldLocation
    }
} else {
    Write-Host "ERROR: Could not find sync tool script at '$syncToolPath'" -ForegroundColor Red
    Write-Host "Please ensure the sync tool script is in the correct location, or modify this script" -ForegroundColor Red
}

Write-Host ""
Write-Host "Sync operation completed. Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 