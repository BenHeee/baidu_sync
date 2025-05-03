@echo off
setlocal enabledelayedexpansion

:: 百度云盘同步工具 - Windows安装脚本（简化版）
:: 用于安装依赖和设置快捷方式

echo ====================================
echo   百度云盘同步工具 - Windows版安装
echo   (简化版 - 无实时同步)
echo ====================================
echo.

:: 设置路径变量
set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%.."
set "BIN_DIR=%PROJECT_DIR%\bin"
set "DESKTOP_DIR=%USERPROFILE%\Desktop"

:: 检查Python安装
echo 检查Python安装...
python --version > nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Python，请先安装Python 3.6或更高版本
    echo 您可以从 https://www.python.org/downloads/ 下载并安装Python
    pause
    exit /b 1
) else (
    for /f "tokens=2" %%V in ('python --version 2^>^&1') do set PYTHON_VERSION=%%V
    echo [成功] 检测到Python版本: %PYTHON_VERSION%
)

:: 检查pip安装
echo 检查pip安装...
pip --version > nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到pip，请确保Python安装正确
    pause
    exit /b 1
) else (
    for /f "tokens=2" %%V in ('pip --version') do set PIP_VERSION=%%V
    echo [成功] 检测到pip版本: %PIP_VERSION%
)

:: 安装bypy
echo 安装bypy...
pip install bypy
if errorlevel 1 (
    echo [错误] bypy安装失败
    pause
    exit /b 1
) else (
    echo [成功] bypy安装完成
)

:: 询问是否创建桌面快捷方式
echo.
set /p "create_shortcut=是否创建桌面快捷方式? (Y/N): "
if /i "%create_shortcut%"=="Y" (
    echo 创建桌面快捷方式...
    
    :: 创建上传快捷方式
    powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%DESKTOP_DIR%\百度云盘上传.lnk'); $Shortcut.TargetPath = '%BIN_DIR%\sync_to_remote.bat'; $Shortcut.WorkingDirectory = '%BIN_DIR%'; $Shortcut.Description = '将本地文件同步到百度云盘'; $Shortcut.Save()"
    
    :: 创建下载快捷方式
    powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%DESKTOP_DIR%\百度云盘下载.lnk'); $Shortcut.TargetPath = '%BIN_DIR%\sync_from_remote.bat'; $Shortcut.WorkingDirectory = '%BIN_DIR%'; $Shortcut.Description = '从百度云盘同步文件到本地'; $Shortcut.Save()"
    
    echo [成功] 已创建桌面快捷方式
)

:: 询问是否立即授权和配置
echo.
set /p "config_now=是否现在进行百度云盘授权和配置? (Y/N): "
if /i "%config_now%"=="Y" (
    echo 运行授权和配置...
    call "%BIN_DIR%\baidu_sync.bat" config
)

echo.
echo ====================================
echo      安装完成!
echo ====================================
echo.
echo 使用方法:
echo 1. 运行配置: %BIN_DIR%\baidu_sync.bat config
echo 2. 上传同步: %BIN_DIR%\sync_to_remote.bat
echo 3. 下载同步: %BIN_DIR%\sync_from_remote.bat
echo 4. 查看状态: %BIN_DIR%\baidu_sync.bat status
echo.
echo 同步数据目录: %USERPROFILE%\baidu_sync (默认，可在配置中修改)
echo.

pause 