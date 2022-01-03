<!--
+++
title       = "VBox虚拟机安装【增强功能】"
description = "1. 前期准备; 2. 2 安装内核头文件（root执行）; 3. 安装 VBox 增强功能（root 用户下执行）; 4. 共享文件夹; 5. 重启; 6. 其他设置"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","13-windows"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

虚拟机系统使用Debian：

+ VirtualBox 版本：VirtualBox 5.2.6
+ Debian 版本：Linux debian 4.9.0-4-amd64

## 1. 前期准备

打开 Debian 虚拟机并登陆，依次点击 VirtualBox 的 “设备 -> 安装增强功能”。

这时我们可以在 Debian 的桌面上看到一个光盘图标，例如我的计算机上图标的名称是： `VBox_GAs_5.2.6` 。

在 VBox_GAs_5.2.6 图标上右键选择 “挂载卷”，之后我们就可以在“/media/cdrom0” 路径下看到 VBox_GAs_5.2.6 中的内容了。

切换到 / media/cdrom0 路径下：

```
cd /media/cdrom0
```

## 2. 2 安装内核头文件（root执行）

**_注：如果不执行这一步，直接执行下一步（第 3 步）可能会出现如下报错：_**

> This system is currently not set up to build kernel modules.
>
> Please install the gcc make perl packages from your distribution.
>
> Please install the Linux kernel “header” files matching the current kernel for adding new hardware support to the system.
>
> The distribution packages containing the headers are probably.

报错的原因是没有安装内核头文件，因此，我们首先安装内核头文件。

获取系统内核版本信息：

```
uname -r
```

例如在我的计算机上上述命令的执行结果是：

```
4.9.0-4-amd64
```

下一步命令我们需要使用这个参数。

安装内核头文件，命令：

```
apt-get install build-essential linux-headers-内核版本号
```

例如在我的计算机上需要执行的命令就是：

```
apt-get install build-essential linux-headers-4.9.0-4-amd64
```

## 3. 安装 VBox 增强功能（root 用户下执行）

进入 `/media/cdrom0`  路径：

```
cd /media/cdrom0
```

开始安装：

```
sh ./VBoxLinuxAdditions.run
```

## 4. 共享文件夹

用户访问共享文件夹需要 vboxsf 权限：

```
sudo usermod -aG vboxsf $(whoami)  # sudo adduser $(whoami) vboxsf
```

重启系统组设置或者虚拟机重启生效。

## 5. 重启

## 6. 其他设置

在 VirtualBox 的 “设备” 选项下依次将 “共享粘贴板” 和“拖放”设置成 “双向” 即可在虚拟机与物理机之间共享粘贴板并实现文件的互相拖放，Debian 的显示分辨率也会自动调整。
