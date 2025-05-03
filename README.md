# Baidu Sync - 百度云盘同步工具

## 项目概述

Baidu Sync是一个跨平台的百度云盘同步工具，提供Linux和Windows双平台支持，帮助用户在本地目录与百度云盘之间高效同步文件。本工具基于`bypy`开发，提供简单易用的命令行界面，满足不同操作系统用户的同步需求。

## 主要特性

- **跨平台支持**：提供Linux和Windows完整解决方案
- **双向同步**：支持本地到云端和云端到本地的文件同步
- **增量同步**：只传输变化的文件，节省时间和带宽
- **文件过滤**：可排除特定类型的文件不参与同步
- **命令行界面**：简单直观的命令行操作
- **详细日志**：完整的日志记录，方便排查问题
- **配置灵活**：可自定义同步目录、过滤规则等参数

## 平台支持

### Linux版本

Linux版本提供了完整的功能集，包括：
- 单文件/整个目录上传下载
- 完全同步功能（包括删除远端/本地不存在的文件）
- 灵活的配置选项
- 详细的命令行参数

[查看Linux版详情](./baidu_sync_linux/README.md)

### Windows版本

Windows版本提供了简化的操作体验，包括：
- 从本地同步到云盘（上传）
- 从云盘同步到本地（下载）
- 批处理脚本和PowerShell脚本支持
- 简化的命令行界面

[查看Windows版详情](./baidu_sync_windows/README.md)

## 项目结构

```
baidu_sync/
├── baidu_sync_linux/         # Linux版本
│   ├── bin/                  # 可执行脚本
│   ├── config/               # 配置文件
│   ├── logs/                 # 日志文件
│   ├── scripts/              # 辅助脚本
│   └── README.md             # Linux版说明文档
│
├── baidu_sync_windows/       # Windows版本
│   ├── bin/                  # 可执行脚本
│   ├── config/               # 配置文件
│   ├── logs/                 # 日志文件
│   ├── docs/                 # 文档
│   ├── scripts/              # 辅助脚本
│   └── README.md             # Windows版说明文档
│
└── README.md                 # 主项目说明文档
```

## 快速开始

### Linux安装

```bash
cd baidu_sync_linux/scripts
./install_baidu_sync.sh
```

### Windows安装

```batch
cd baidu_sync_windows\scripts
install.bat
```

## 依赖项目

- [bypy](https://github.com/houtianze/bypy) - 百度云盘命令行工具
- Python 3.6+ - 运行环境
- jq (Linux) - JSON处理工具

## 贡献指南

欢迎通过以下方式参与项目：
1. 提交bug报告或功能建议
2. 提交Pull Request改进代码
3. 完善文档和使用示例

## 许可协议

本项目基于MIT许可协议开源。详见[LICENSE](LICENSE)文件。 
