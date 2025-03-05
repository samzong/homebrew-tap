# Samzong 的 Homebrew 软件仓库

[English](README.md) | [中文](README_zh.md)

这是一个用于存放我个人开发的应用程序和工具的 Homebrew 软件仓库。

## 安装

```bash
brew tap samzong/tap
```

## 可用应用

| 应用名称 | 类型 | 描述 | 最新版本 | 最近更新 |
|---------|------|------|----------|----------|
| HF Model Downloader | GUI 应用 | 一个跨平台的 GUI 应用程序，用于轻松下载 Hugging Face 模型 | v0.0.4 | 2025-03-04 |
| Mac Music Player | GUI 应用 | 一个现代化的 macOS 音乐播放器 | v0.1.7 | 2025-02-21 |
| mdctl | 命令行工具 | 一个用于管理 Markdown 文件的命令行工具 | v0.0.10 | 2025-02-25 |

## 使用方法

安装应用程序：

```bash
# 安装 GUI 应用
brew install --cask samzong/tap/应用名称

# 安装命令行工具
brew install samzong/tap/工具名称

# 示例：
brew install --cask samzong/tap/hf-model-downloader
brew install samzong/tap/mdctl
```

## 文档

- `brew help`
- `man brew`
- [Homebrew 文档](https://docs.brew.sh)
