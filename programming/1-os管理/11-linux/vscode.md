<!--
+++
title       = "Linux安装vscode"
description = "1. 安装"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","11-linux"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 安装
> [官网](https://code.visualstudio.com/docs/setup/linux)

### 1.1. 基于Debian和Ubuntu的发行版

网页下载： https://code.visualstudio.com/Download

```sh
sudo apt install ./<file>.deb

# If you're on an older Linux distribution, you will need to run this instead:
# sudo dpkg -i <file>.deb
# sudo apt-get install -f # Install dependencies
```

### 1.2. Ubuntu::VNC 环境下无法启动
> [github: issue](https://github.com/Microsoft/vscode/issues/3451)

打开之后完全没反应，虽然~/.config/Code正常生成了配置文件。

1. 备份/usr/lib/x86_64-linux-gnu/libxcb.so.1.1.0
2. `$ sudo sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /usr/lib/x86_64-linux-gnu/libxcb.so.1.1.0`
