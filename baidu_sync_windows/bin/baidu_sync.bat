@echo off
setlocal enabledelayedexpansion

:: 百度云盘同步工具 - Windows版（简化版）
:: 基于bypy实现本地目录与百度云盘指定路径的同步
:: 版本：2.0

:: 设置路径变量
set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%.."
set "CONFIG_DIR=%PROJECT_DIR%\config"
set "LOG_DIR=%PROJECT_DIR%\logs"
set "LOG_FILE=%LOG_DIR%\sync_%date:~0,4%%date:~5,2%%date:~8,2%.log"
set "CONFIG_FILE=%CONFIG_DIR%\sync_config.json"

:: 如果不存在日志目录，则创建
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"

:: 记录日志函数
call :log "INFO" "启动百度云盘同步工具 - Windows版（简化版）"

:: 检查命令行参数
if "%~1"=="" (
    call :show_help
    exit /b 0
)

:: 处理命令行参数
if "%~1"=="status" (
    call :check_status
) else if "%~1"=="config" (
    call :configure_sync
) else if "%~1"=="sync_to_remote" (
    call :sync_to_remote
) else if "%~1"=="sync_from_remote" (
    call :sync_from_remote
) else if "%~1"=="help" (
    call :show_help
) else (
    echo 未知命令: %~1
    call :show_help
    exit /b 1
)

exit /b 0

:: ===== 函数定义 =====

:log
:: 参数: %~1=日志级别, %~2=消息
set "timestamp=%date% %time%"
echo [%timestamp%] [%~1] %~2
echo [%timestamp%] [%~1] %~2 >> "%LOG_FILE%"
exit /b 0

:show_help
echo 百度云盘同步工具 - Windows版（简化版）
echo.
echo 用法: %~nx0 [选项]
echo.
echo 选项:
echo   status          查看同步状态
echo   config          配置同步参数
echo   sync_to_remote  从本地同步到云盘（上传）
echo   sync_from_remote  从云盘同步到本地（下载）
echo   help            显示帮助信息
echo.
echo 注意: 您也可以直接使用独立脚本:
echo   sync_to_remote.bat    从本地同步到云盘
echo   sync_from_remote.bat  从云盘同步到本地
echo.
exit /b 0

:check_dependencies
call :log "INFO" "检查依赖..."

:: 检查Python是否安装
python --version >nul 2>&1
if errorlevel 1 (
    call :log "ERROR" "未找到Python，请先安装Python 3.6或更高版本"
    exit /b 1
)

:: 检查bypy是否安装
bypy --help >nul 2>&1
if errorlevel 1 (
    call :log "ERROR" "未找到bypy命令，请先安装: pip install bypy"
    exit /b 1
)

call :log "INFO" "依赖检查通过"
exit /b 0

:create_default_config
call :log "INFO" "创建默认配置..."

:: 创建一个包含默认值的JSON配置文件
> "%CONFIG_FILE%" (
    echo {
    echo     "local_path": "%USERPROFILE%\\baidu_sync",
    echo     "remote_path": "/sync_folder",
    echo     "max_retries": 3,
    echo     "exclude_patterns": ".git .svn .DS_Store *.tmp *.temp"
    echo }
)

call :log "INFO" "默认配置已创建: %CONFIG_FILE%"
exit /b 0

:load_config
call :log "INFO" "加载配置..."

:: 如果配置文件不存在，则创建默认配置
if not exist "%CONFIG_FILE%" (
    call :log "WARNING" "配置文件不存在，创建默认配置"
    call :create_default_config
)

:: 使用PowerShell读取JSON配置
for /f "usebackq delims=" %%a in (`powershell -Command "Get-Content '%CONFIG_FILE%' | ConvertFrom-Json | Select-Object -ExpandProperty local_path"`) do set "LOCAL_PATH=%%a"
for /f "usebackq delims=" %%a in (`powershell -Command "Get-Content '%CONFIG_FILE%' | ConvertFrom-Json | Select-Object -ExpandProperty remote_path"`) do set "REMOTE_PATH=%%a"
for /f "usebackq delims=" %%a in (`powershell -Command "Get-Content '%CONFIG_FILE%' | ConvertFrom-Json | Select-Object -ExpandProperty max_retries"`) do set "MAX_RETRIES=%%a"
for /f "usebackq delims=" %%a in (`powershell -Command "Get-Content '%CONFIG_FILE%' | ConvertFrom-Json | Select-Object -ExpandProperty exclude_patterns"`) do set "EXCLUDE_PATTERNS=%%a"

:: 替换环境变量
set "LOCAL_PATH=%LOCAL_PATH:%%USERPROFILE%%=%USERPROFILE%%%"

call :log "INFO" "配置加载完成:"
call :log "INFO" "  - 本地路径: %LOCAL_PATH%"
call :log "INFO" "  - 远程路径: %REMOTE_PATH%"

:: 确保本地目录存在
if not exist "%LOCAL_PATH%" mkdir "%LOCAL_PATH%"

exit /b 0

:authorize_baidu
call :log "INFO" "授权百度云盘账号..."
bypy info
if errorlevel 1 (
    call :log "ERROR" "百度云盘账号授权失败"
    exit /b 1
) else (
    call :log "INFO" "百度云盘账号已授权"
    exit /b 0
)

:full_sync_to_baidu
call :log "INFO" "执行同步: 本地 -> 百度云盘"

:: 使用bypy上传整个目录
bypy syncup "%LOCAL_PATH%" "%REMOTE_PATH%"

if errorlevel 1 (
    call :log "ERROR" "同步失败: %LOCAL_PATH% -> %REMOTE_PATH%"
    exit /b 1
) else (
    call :log "INFO" "同步成功: %LOCAL_PATH% -> %REMOTE_PATH%"
    exit /b 0
)

:full_sync_from_baidu
call :log "INFO" "执行同步: 百度云盘 -> 本地"

:: 使用bypy下载整个目录
bypy syncdown "%REMOTE_PATH%" "%LOCAL_PATH%"

if errorlevel 1 (
    call :log "ERROR" "同步失败: %REMOTE_PATH% -> %LOCAL_PATH%"
    exit /b 1
) else (
    call :log "INFO" "同步成功: %REMOTE_PATH% -> %LOCAL_PATH%"
    exit /b 0
)

:sync_to_remote
call :log "INFO" "开始同步: 本地 -> 百度云盘"
call :check_dependencies
call :load_config
call :authorize_baidu

echo 正在同步本地文件到百度云盘...
echo 本地路径: %LOCAL_PATH%
echo 云盘路径: %REMOTE_PATH%

:: 执行同步到云盘
call :full_sync_to_baidu

call :log "INFO" "同步完成: 本地 -> 百度云盘"
exit /b 0

:sync_from_remote
call :log "INFO" "开始同步: 百度云盘 -> 本地"
call :check_dependencies
call :load_config
call :authorize_baidu

echo 正在同步百度云盘文件到本地...
echo 云盘路径: %REMOTE_PATH%
echo 本地路径: %LOCAL_PATH%

:: 执行同步到本地
call :full_sync_from_baidu

call :log "INFO" "同步完成: 百度云盘 -> 本地"
exit /b 0

:check_status
call :log "INFO" "检查同步状态"
call :load_config
    
:: 显示统计信息
echo 百度云盘同步工具状态:
echo =======================
echo 本地路径: %LOCAL_PATH%
echo 远程路径: %REMOTE_PATH%
echo 日志文件: %LOG_FILE%
echo =======================
    
:: 显示百度云盘信息
bypy info
exit /b 0

:configure_sync
call :log "INFO" "配置同步参数..."

:: 加载当前配置
call :load_config

echo 配置百度云盘同步参数
echo =======================

:: 读取用户输入
set /p "input=本地路径 [%LOCAL_PATH%]: "
if not "%input%"=="" set "LOCAL_PATH=%input%"

set /p "input=远程路径 [%REMOTE_PATH%]: "
if not "%input%"=="" set "REMOTE_PATH=%input%"

set /p "input=排除模式 [%EXCLUDE_PATTERNS%]: "
if not "%input%"=="" set "EXCLUDE_PATTERNS=%input%"

:: 保存配置到PowerShell生成的JSON
powershell -Command "$config = @{ local_path='%LOCAL_PATH%'; remote_path='%REMOTE_PATH%'; max_retries=%MAX_RETRIES%; exclude_patterns='%EXCLUDE_PATTERNS%' } | ConvertTo-Json | Set-Content -Path '%CONFIG_FILE%'"

call :log "INFO" "配置已保存: %CONFIG_FILE%"
echo 配置已保存！
exit /b 0 