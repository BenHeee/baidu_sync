# 百度云盘同步工具

## 项目简介

百度云盘同步工具是一个基于`bypy`开发的命令行工具，用于在本地目录与百度云盘之间进行文件同步。本工具提供简单易用的命令行界面，支持文件和目录的上传下载，以及完全同步功能。

## 主要特性

- 支持单文件/整个目录上传到云端
- 支持单文件/整个目录从云端下载
- 完全同步功能，支持删除远端/本地不存在的文件
- 简单直观的命令行界面，使用更方便
- 灵活的配置选项，支持文件过滤

## 快速开始

### 1. 安装

执行以下命令进行安装：

```bash
cd ~/baidu_sync_project/scripts
./install_baidu_sync.sh
```

安装后，您可以使用`baidu_sync`命令或其简短别名`bsync`。

### 2. 授权百度云盘

首次使用前，需要授权bypy访问您的百度云盘账号：

```bash
bypy info
```

此命令会打开浏览器并引导您完成授权流程。

### 3. 配置同步参数

```bash
baidu_sync -config
# 或使用简短别名
bsync -config
```

配置过程中，您需要设置以下参数：
- 本地同步目录路径
- 远程同步目录路径
- 排除模式（不需要同步的文件类型）

### 4. 使用同步命令

```bash
# 上传整个同步目录到云盘(不删除远端文件)
baidu_sync -up

# 仅上传单个文件或目录
baidu_sync -up file.txt
baidu_sync -up folder/

# 完全同步(会删除远端不存在的文件)
baidu_sync -sync

# 从云盘下载整个同步目录(不删除本地文件)
baidu_sync -down

# 反向同步(会删除本地不存在的文件)
baidu_sync -rsync

# 仅下载单个文件或目录
baidu_sync -down document.pdf

# 查看同步状态
baidu_sync -status

# 显示帮助信息
baidu_sync -h
```

## 项目结构

```
baidu_sync_project/
├── bin/                       # 可执行脚本目录
│   └── baidu_sync             # 百度云盘同步工具脚本
├── config/                    # 配置文件目录
│   └── sync_config.json       # 配置文件
├── logs/                      # 日志目录
│   └── sync_*.log             # 同步日志文件
└── scripts/                   # 辅助脚本目录
    ├── check_dependencies.sh  # 依赖检查脚本
    └── install_baidu_sync.sh  # 安装脚本
```

## 命令选项说明

| 命令 | 功能 | 是否删除文件 |
|------|------|------------|
| `-up` | 上传本地文件到云盘 | 不删除云端任何文件 |
| `-sync` | 完全同步，使云端与本地一致 | 删除云端上本地不存在的文件 |
| `-down` | 下载云盘文件到本地 | 不删除本地任何文件 |
| `-rsync` | 反向同步，使本地与云端一致 | 删除本地上云端不存在的文件 |
| `-config` | 配置同步参数 | - |
| `-status` | 查看同步状态 | - |
| `-h` | 显示帮助信息 | - |

## 日志文件

如果遇到问题，请查看日志文件以获取详细信息：

```bash
tail -f ~/baidu_sync_project/logs/sync_$(date +%Y%m%d).log
```

## 依赖项目

- [bypy](https://github.com/houtianze/bypy) - 百度云盘命令行工具
- jq - JSON处理工具

## 许可协议

本项目基于 MIT 许可协议开源。 