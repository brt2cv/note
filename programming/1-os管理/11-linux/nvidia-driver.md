<!--
+++
title       = "Linux安装NVIDIA显卡驱动"
description = "1. 命令行搜索集显和独显; 2. 集显与独显的切换; 3. Nvidia驱动安装"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","11-linux"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> [csdn: Linux安装NVIDIA显卡驱动的正确姿势](https://blog.csdn.net/wf19930209/article/details/81877822)

本文将介绍四种NVIDIA驱动安装方式。具体选择需要根据你的情况而定。

+ 使用标准Ubuntu仓库进行自动化安装
+ 使用PPA仓库进行自动化安装
+ 使用官方的NVIDIA驱动进行手动安装

## 1. 命令行搜索集显和独显

打开终端执行以下命令：

```
lspci | grep VGA     # 查看集成显卡
lspci | grep NVIDIA  # 查看NVIDIA显卡

# 实例
$ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
01:00.0 VGA compatible controller: NVIDIA Corporation GF119M [GeForce 610M] (rev a1)
```

## 2. 集显与独显的切换

当我们需要切换独显与集显的时候，一般就是外出的时候，想节省电量，增长待机时间。下面讲解两种切换方式。

### 2.1. 使用nvidia-setting切换

终端执行nvidia-setting,在弹的界面中选择独显与集显:

## 3. Nvidia驱动安装

这种方式安装同样也是使用ubuntu官方源的形式安装的，你可以选择不同的驱动版本来安装，但是本质上和标准仓库进行自动化安装是一样的。

其实ubuntu自带命令行版本安装工具ubuntu-drivers,终端输入:

```
ubuntu-drivers devices  # 查询所有ubuntu推荐的驱动
```

我的老电脑显示如下：

```sh
$ ubuntu-drivers devices
== /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 ==
modalias : pci:v000010DEd00001058sv000017AAsd00005005bc03sc00i00
vendor   : NVIDIA Corporation
model    : GF119M [GeForce 610M]
driver   : nvidia-340 - distro non-free
driver   : nvidia-driver-390 - distro non-free recommended
driver   : xserver-xorg-video-nouveau - distro free builtin
```

这里推荐下 `nvidia-driver-390` 。

```sh
sudo apt install nvidia-driver-390
```

*提示：Nvidia的驱动，都是依赖的i386版本的gcc……所以下载了一大堆的32位依赖，额。。。*

### 3.1. 显卡驱动切换

NVIDIA提供了一个切换显卡的命令：

```sh
sudo prime-select query  # 查看当前使用的显卡
sudo prime-select nvidia # 切换nvidia显卡
sudo prime-select intel  # 切换intel显卡
```
