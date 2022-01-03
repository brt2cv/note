<!--
+++
title       = "【转载】Win10：右键以管理员方式打开cmd"
description = "1. 麻烦; 2. 效果; 3. 设置步骤"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","13-windows"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 https://blog.csdn.net/hiudawn/article/details/80701935

[TOC]

---

## 1. 麻烦

每次都要 win+r->cmd 然后 cd 到各种目录下执行命令，真是麻烦。<font color=#FF0000>`shift + 右键` 的 powershell 还没有默认管理员权限</font>，真是够麻烦的。

这里直接想办法让右键出现以管理员方式打开的 cmd 窗口。

## 2. 效果

右键效果

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200803181752080-581430864.jpg) <!-- 右键以管理员方式打开cmd/右键以管理员方式打开cmd-2.jpg -->

打开后

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200803181752319-1765175688.jpg) <!-- 右键以管理员方式打开cmd/右键以管理员方式打开cmd-3.jpg -->

## 3. 设置步骤

1. 打开注册表

    按win+r在“运行”中，执行regedit打开注册表。

2. 找到下面路径 `HKEY_CLASSES_ROOT\Directory\Background\shell\`
3. 新建项

    在shell目录右键新建一个叫runas的项（必须为这个名称！）

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200803181752505-2090760756.jpg) <!-- 右键以管理员方式打开cmd/右键以管理员方式打开cmd-4.jpg -->

    在runas目录右键新建一个叫command的项

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200803181752700-78914992.jpg) <!-- 右键以管理员方式打开cmd/右键以管理员方式打开cmd-5.jpg -->

4. 更改值

    在 runas 上右键，新建一个 `DWORD32` 类型叫 `ShowBasedOnVelocityId` 的项目，填入十六进制值 `639bc8` 。

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200803181752996-1277612232.jpg) <!-- 右键以管理员方式打开cmd/右键以管理员方式打开cmd-0.jpg -->

    点到 command 里面，右键那个默认，填入 `cmd.exe /s /k pushd "%V"`

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200803181753211-1523224173.jpg) <!-- 右键以管理员方式打开cmd/右键以管理员方式打开cmd-1.jpg -->
