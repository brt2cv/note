<!--
+++
title       = "RaspberryPi安装OpenCV"
description = "1. pip安装; 2. 通过whl包安装"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","12-设备端"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

树莓派是arm平台，用pip安装时，默认从源码构建，编译耗时过长，甚至编译失败。

## 1. pip安装

在 `/etc/pip.conf` 添加如下内容，启用源

```
[global]
extra-index-url=https://www.piwheels.org/simple
```

`pip3 install opencv-python`

可能会由于网速问题导致失败：

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200617141851450-1426305383.jpg) <!-- RaspberryPi安装OpenCV/RaspberryPi安装OpenCV0.jpg -->

不用试图采用国内源加速了——我都试过了，国内源仅仅提供了大部分的X86架构的Windows/Linux编译二进制包，但对于树莓派版本，则不支持——最后依然是连接到国外服务器，然后龟速下载，最后失败结束……

## 2. 通过whl包安装

那么，最好的方式就是直接下载。`www.piwheels.org` 提供树莓派预编译二进制包，安装步骤：

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200617141851779-1353086901.jpg) <!-- RaspberryPi安装OpenCV/RaspberryPi安装OpenCV1.jpg -->

如上图，选择合适的opencv版本，以及Python版本：

+ Buster: cp37
+ Stretch: cp35

执行 `pip install $file_name.whl` 安装。
