# 百度云盘同步工具 - Windows版（简化版）

## 项目简介

百度云盘同步工具是一个基于`bypy`开发的本地目录与百度云盘同步解决方案。此简化版本只保留核心上传和下载功能，移除了实时监控功能，提供更简洁直观的操作体验。

## 主要特性

- 支持从本地同步到云盘（上传）
- 支持从云盘同步到本地（下载）
- 文件过滤，可排除特定类型文件
- 详细的日志记录，方便问题排查
- 精简的命令行界面，操作更简单

## 快速开始

### 1. 安装依赖

```batch
cd scripts
install.bat
```

安装脚本会自动检查并安装`bypy`和其他必要的依赖。

### 2. 配置同步参数

```batch
bin\baidu_sync.bat config
```

### 3. 运行同步命令

从本地同步到云盘：

```batch
bin\sync_to_remote.bat
```

从云盘同步到本地：

```batch
bin\sync_from_remote.bat
```

### 4. 查看状态

```batch
bin\baidu_sync.bat status
```

## 目录结构

```
baidu_sync_windows/
├── bin/                       # 可执行脚本目录
│   ├── baidu_sync.bat         # 主同步脚本
│   ├── sync_to_remote.bat     # 上传到云盘脚本
│   └── sync_from_remote.bat   # 从云盘下载脚本
├── config/                    # 配置文件目录
├── logs/                      # 日志目录
└── scripts/                   # 辅助脚本目录
    └── install.bat            # 安装脚本
```

## 配置文件

配置文件位于`config/sync_config.json`，包含以下参数：

- `local_path`: 本地同步目录路径
- `remote_path`: 百度云盘上的同步目录路径
- `max_retries`: 上传/下载失败重试次数
- `exclude_patterns`: 排除的文件模式（空格分隔）

## PowerShell脚本支持

项目同时提供了PowerShell版本的同步脚本，可以放置在需要同步的目录中直接使用：

- `sync_to_remote.ps1` - 用于上传当前目录到百度云盘
- `sync_from_remote.ps1` - 用于从百度云盘下载到当前目录

## 依赖项目

- [bypy](https://github.com/houtianze/bypy) - 百度云盘命令行工具
- Python 3.6+ - 运行环境 