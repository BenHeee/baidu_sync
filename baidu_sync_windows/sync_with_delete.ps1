param(
    [Parameter(Position=0)]
    [string] $SyncMode = "sync_from_remote"
)

# Baidu Cloud Sync Tool with Delete Support
# 支持删除操作的百度云同步工具

# 设置PowerShell输出编码为UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 获取配置信息
$configFile = "$PSScriptRoot\config\sync_config.json"
if (Test-Path $configFile) {
    $config = Get-Content $configFile -Raw | ConvertFrom-Json
    $localDir = $config.local_dir
    $remoteDir = $config.remote_dir
} else {
    $localDir = "$env:USERPROFILE\baidu_sync"
    $remoteDir = "/"
}

# 确保本地目录存在
if (-not (Test-Path $localDir)) {
    New-Item -Path $localDir -ItemType Directory -Force | Out-Null
    Write-Host "Created local directory: $localDir" -ForegroundColor Green
}

# 记录同步开始时间
$startTime = Get-Date
Write-Host "Sync started at $startTime" -ForegroundColor Cyan

# 根据同步模式执行相应操作
if ($SyncMode -eq "sync_from_remote") {
    Write-Host "Syncing FROM Baidu Cloud TO local directory ($localDir)..." -ForegroundColor Yellow
    
    # 使用bypy同步，包含删除选项
    $bypy = Get-Command bypy -ErrorAction SilentlyContinue
    
    if ($bypy) {
        Write-Host "Running: bypy syncdown '$remoteDir' '$localDir' true" -ForegroundColor Gray
        # 使用syncdown命令，最后的true参数表示删除本地文件
        bypy syncdown "$remoteDir" "$localDir" true
    } else {
        Write-Host "ERROR: bypy command not found. Please ensure bypy is installed." -ForegroundColor Red
        Write-Host "Run: pip install bypy" -ForegroundColor Red
        exit 1
    }
} elseif ($SyncMode -eq "sync_to_remote") {
    Write-Host "Syncing FROM local directory ($localDir) TO Baidu Cloud..." -ForegroundColor Yellow
    
    # 使用bypy同步，包含删除选项
    $bypy = Get-Command bypy -ErrorAction SilentlyContinue
    
    if ($bypy) {
        Write-Host "Running: bypy syncup '$localDir' '$remoteDir' true" -ForegroundColor Gray
        # 使用syncup命令，最后的true参数表示删除远程文件
        bypy syncup "$localDir" "$remoteDir" true
    } else {
        Write-Host "ERROR: bypy command not found. Please ensure bypy is installed." -ForegroundColor Red
        Write-Host "Run: pip install bypy" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "ERROR: Unknown sync mode: $SyncMode" -ForegroundColor Red
    Write-Host "Valid modes: sync_from_remote, sync_to_remote" -ForegroundColor Red
    exit 1
}

# 记录同步结束时间
$endTime = Get-Date
$duration = $endTime - $startTime
Write-Host "Sync completed at $endTime" -ForegroundColor Cyan
Write-Host "Duration: $($duration.Minutes) minutes, $($duration.Seconds) seconds" -ForegroundColor Cyan 