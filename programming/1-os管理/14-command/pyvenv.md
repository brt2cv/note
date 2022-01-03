<!--
+++
title       = "python -m venv 的使用"
description = "1. 常见虚拟环境; 2. 基于系统已有的包"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","14-command"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 常见虚拟环境

* virtualenv: 一个解释器，项目隔离(包隔离)，第三方pypi。支持 2.6~3.5 版本；
* pyvenv: 一个解释器，项目隔离(包隔离) python3.4开始自带默认；
* `python -m venv`: 替代 `bin/pyvenv` 脚本的工具
* pyenv: 多个解释器，Python不同版本的隔离；
* <font color=#FF0000>pipenv: 基于项目（文件夹）的虚拟环境；</font>


## 2. 基于系统已有的包

默认的venv创建命令，会建立一个干净的虚拟环境，只包括两个基础包：

* pip
* setuptools

创建选项：

* --without-pip: 选项用于排除pip作为默认安装包；
* --system-site-packages: <font color=#FF0000>让虚拟环境使用系统的已经安装的包</font>。

  即，给予虚拟环境访问系统 site-packages 目录的权限。

* --symlinks: 当系统默认不是符号链接的方式时，尝试使用符号链接而不是复制。
