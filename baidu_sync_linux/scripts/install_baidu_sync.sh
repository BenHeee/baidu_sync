#!/bin/bash

# 百度云盘同步工具安装脚本 - 合并版
# 作者：Claude
# 版本：1.0

# 设置路径变量
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$PROJECT_DIR/bin"
TARGET_DIR="/usr/local/bin"

# 显示安装信息
echo "======================================"
echo "   百度云盘同步工具安装 - 合并版"
echo "======================================"
echo ""

# 检查是否具有sudo权限
echo "检查权限..."
if [ "$EUID" -ne 0 ]; then
    echo "需要管理员权限安装。请输入密码:"
    sudo -v
    if [ $? -ne 0 ]; then
        echo "错误: 无法获取管理员权限，请使用 sudo 运行此脚本"
        exit 1
    fi
fi

# 检查依赖软件
echo "检查依赖软件..."

# 检查bypy
if ! command -v bypy &> /dev/null; then
    echo "bypy未安装，正在安装..."
    pip3 install bypy
fi

# 检查jq
if ! command -v jq &> /dev/null; then
    echo "jq未安装，正在安装..."
    sudo apt-get install -y jq
fi

# 设置执行权限
echo "设置权限..."
chmod +x "$BIN_DIR/baidu_sync"

# 创建符号链接前检查目标文件是否已存在，如果存在则先删除
echo "创建命令链接..."
if [ -e "$TARGET_DIR/baidu_sync" ]; then
    sudo rm -f "$TARGET_DIR/baidu_sync"
fi

# 创建通过复制文件而不是符号链接
sudo cp "$BIN_DIR/baidu_sync" "$TARGET_DIR/baidu_sync"

# 同时创建bsync别名
if [ -e "$TARGET_DIR/bsync" ]; then
    sudo rm -f "$TARGET_DIR/bsync"
fi
sudo ln -s "$TARGET_DIR/baidu_sync" "$TARGET_DIR/bsync"

echo ""
echo "安装完成！"
echo ""
echo "现在您可以使用以下命令使用百度云盘同步工具："
echo "  baidu_sync -up             上传整个同步目录到云盘"
echo "  baidu_sync -up file.txt    仅上传指定文件到云盘"
echo "  baidu_sync -down           下载整个同步目录到本地"
echo "  baidu_sync -down doc.pdf   仅下载指定文件到本地"
echo "  baidu_sync -sync           完全同步，远端将与本地完全一致"
echo "  baidu_sync -rsync          反向同步，本地将与远端完全一致"
echo "  baidu_sync -config         配置同步参数"
echo "  baidu_sync -status         查看同步状态"
echo "  baidu_sync -h              显示帮助信息"
echo ""
echo "您也可以使用简短的别名 'bsync' 代替 'baidu_sync'"
echo ""
echo "首次使用请运行 'baidu_sync -config' 进行配置"
echo "" 