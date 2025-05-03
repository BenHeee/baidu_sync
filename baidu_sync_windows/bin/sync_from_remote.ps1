# Baidu Cloud Download Sync Script

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Get main tool directory
$mainToolDir = "D:\RK3588\baidu_sync_windows"

# If not found, try to find it by looking up from current directory
if (-not (Test-Path $mainToolDir)) {
    $mainToolDir = Join-Path (Split-Path -Parent $scriptDir) "baidu_sync_windows"
}

# Get sync tool path
$syncToolPath = "$mainToolDir\sync_with_delete.ps1"

# If still not found, try using a relative path
if (-not (Test-Path $syncToolPath)) {
    $syncToolPath = "..\sync_with_delete.ps1"
}

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