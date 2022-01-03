<!--
+++
title       = "解决Win7下，vscode启动黑屏 & 无法运行"
description = "1. Win7::vscode-1.41+，打开黑屏？; 2. Win7安装 `.NET 4.7` 错误: 产生阻滞的问题怎么办？; 3. 安装Windows6.1-KB4019990-x64.msu提示：安装程序遇到错误"
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

## 1. Win7::vscode-1.41+，打开黑屏？
> [博客园：解决vscode打开空白的问题](https://www.cnblogs.com/syui-terra/p/11834275.html)

问题：打开后窗口全黑，但是原按钮对应位置还有触摸手势，显示tag等，卸载重装等无效。

解决：<font color=#FF0000>启动方式后加 `--disable-gpu` </font>

其他方式：

1. 在设备管理器中禁用显卡，但可能导致显示问题
2. 以兼容方式启动该程序，但终端无法启动了（无论cmd/powershell或Git-Bash）

## 2. Win7安装 `.NET 4.7` 错误: 产生阻滞的问题怎么办？

[文章导读] 最近很多网友上问，win7 在安装. NET Framework 4.7 的时候遇到无法安装的问题，错误提示：产生阻滞的问题，然后就是一串英文。一般情况这是由于缺少补丁引起，那么如何解决呢？

最近很多网友上问，win7 在安装. NET Framework 4.7 的时候遇到无法安装的问题，错误提示：产生阻滞的问题，然后就是一串英文。一般情况这是由于缺少补丁引起，那么如何解决呢？

![](http://www.dnxtc.net/d/file/zixun/WIN7yingyong/2018-12-28/1ad7f22a8fb886683d926412f0935b2b.jpg)

原因分析：

当计算机没有 D3DComplier 的更新时，会发生此问题 (D3DCompiler_47.dll) 安装。

**.NET 4.7 错误: 产生阻滞的问题解决方法：**

要变通解决此问题，i 那里 d3dcompiler 更新从以下链接之前安装. NET Framework 4.7。此更新还会对 Microsoft 更新目录，并通过 Windows Update。

*   在 x86 的 Windows 7 SP1，使用[此链接](http://go.microsoft.com/fwlink/?LinkId=848159)。
*   在 Windows 7 SP1 或 Windows Server 2008 R2 x64 上，使用[此链接](http://go.microsoft.com/fwlink/?LinkId=848158)。
*   在 Windows Server 2012 x64，使用[此链接](http://go.microsoft.com/fwlink/?LinkId=848160)。

按上面给出的连接下载补丁安装后，再安装. net 4.7 即可正常安装了，如下图所示；

![](http://www.dnxtc.net/d/file/zixun/WIN7yingyong/2018-12-28/126916916f15e8911f8e20ff6c62b31c.jpg)

[.NET Framework 4.7 离线包下载](http://download.microsoft.com/download/D/D/3/DD35CC25-6E9C-484B-A746-C5BE0C923290/NDP47-KB3186497-x86-x64-AllOS-ENU.exe)

[.NET Framework 4.7 简体中文语言包下载](ttps://download.microsoft.com/download/4/4/7/447FC039-EAA9-41EB-B96F-86D6146D7A92/NDP47-KB3186497-x86-x64-AllOS-CHS.exe)

以上就是 WIN7 系统无法安装. NET Framework 4.7 错误: 产生阻滞的问题解决方法，如果有别的用户安装别的版本. net 也可以按上面的方法进行操作。

## 3. 安装Windows6.1-KB4019990-x64.msu提示：安装程序遇到错误

根据这个错误信息，可能由于Windows Update相关的服务没有启动导致。

请首先根据以下步骤确认服务状态：

1. 单击开始按钮，在搜索框内输入services.msc，按回车。
2. 双击Background Intelligent Transfer Service，确保启动类型为“手动”，服务状态为已启动，点击确定。
3. 双击Windows Update，确保启动类型为“手动”，服务状态为已启动，点击确定。

然后即可正常安装。如有必要，安装后可恢复services.msc的原有设定
