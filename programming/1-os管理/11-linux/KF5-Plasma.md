<!--
+++
title       = "KF5 & Plasma"
description = "1. KDE Framework 5.x; 2. KDE Plasma; 3. ubuntu18.10中安装Plasma"
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

## 1. KDE Framework 5.x

`KDE Frameworks 5` 是一个由KDE社区打造的众多二进制包和自由软件框架的集合，它是KDE4迈向更加独立和特别的重要一步，跨平台组件使其可以运行几乎所有基于QT的应用程序。

## 2. KDE Plasma

KDE Plasma 5是基于QT5开发的，是 KDE工作空间的下一代版本。新版本带来了大量的bug修复和性能提升，同时伴随有新的一些特点，Breeze的深色主题、更多的插件、改进的任务转换器以及重新设计的图标等等……

## 3. ubuntu18.10中安装Plasma

1. 添加Kubuntu Backports PPA

    `sudo add-apt-repository ppa:kubuntu-ppa/backports`

2. 安装

    运行命令以安装Plasma桌面：

    `sudo apt update && sudo apt install plasma-desktop`

    或通过命令安装完整的KDE桌面环境：

    `sudo apt update && sudo apt install kubuntu-desktop`

3. 卸载

    您可以清除Kubuntu Backports PPA，它将Plasma桌面降级到Ubuntu 18.10存储库中的库存版本（5.13.5）。

    `sudo apt install ppa-purge && sudo ppa-purge ppa:kubuntu-ppa/backports`
