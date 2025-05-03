#!/bin/bash

# 百度云盘同步依赖检查脚本
# 作者：Claude
# 版本：1.0

# 检查是否有错误发生
ERROR=0

# 检查命令是否存在
check_command() {
    local cmd="$1"
    local package="$2"
    local install_cmd="$3"
    
    echo -n "检查 $cmd..."
    
    if command -v "$cmd" > /dev/null 2>&1; then
        echo " 已安装"
        return 0
    else
        echo " 未安装"
        echo "请运行: $install_cmd 安装 $package"
        ERROR=1
        return 1
    fi
}

# 安装依赖
install_dependencies() {
    local choice
    echo ""
    echo "是否自动安装所有缺少的依赖? [y/N]"
    read -r choice
    
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "正在安装依赖..."
        
        # 安装系统包
        if ! command -v jq > /dev/null 2>&1; then
            echo "安装 jq..."
            sudo apt-get update && sudo apt-get install -y jq
        fi
        
        if ! command -v inotifywait > /dev/null 2>&1; then
            echo "安装 inotify-tools..."
            sudo apt-get update && sudo apt-get install -y inotify-tools
        fi
        
        # 安装 pip
        if ! command -v pip3 > /dev/null 2>&1; then
            echo "安装 python3-pip..."
            sudo apt-get update && sudo apt-get install -y python3-pip
        fi
        
        # 安装 bypy
        if ! command -v bypy > /dev/null 2>&1; then
            echo "安装 bypy..."
            pip3 install bypy
        fi
        
        echo "依赖安装完成，请重新运行同步脚本"
    else
        echo "跳过自动安装，请手动安装依赖后重试"
    fi
}

# 显示标题
echo "====================================="
echo "    百度云盘同步依赖检查"
echo "====================================="
echo ""

# 检查必要的系统命令
check_command "jq" "jq" "sudo apt-get install -y jq"
check_command "inotifywait" "inotify-tools" "sudo apt-get install -y inotify-tools"

# 检查 Python 和 pip
check_command "python3" "python3" "sudo apt-get install -y python3"
check_command "pip3" "python3-pip" "sudo apt-get install -y python3-pip"

# 检查 bypy
check_command "bypy" "bypy" "pip3 install bypy"

# 如果有错误，询问是否自动安装
if [ $ERROR -ne 0 ]; then
    install_dependencies
    exit 1
fi

echo ""
echo "所有依赖已安装，系统满足运行百度云盘同步的要求"
exit 0 