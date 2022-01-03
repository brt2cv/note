<!--
+++
title       = "Python多版本启动器"
description = "1. 安装; 2. Customization via INI files"
date        = "2022-01-03"
tags        = []
categories  = ["3-syntax","33-python","tools"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 安装
> [homepage](https://docs.python.org/3/using/windows.html#python-launcher-for-windows)

1. Windows环境下，如果需要同时安装多个版本的python，请先安装Python3.3+（自带python laucher.exe），会对多版本进行注册和管理。

1. 依次安装多个版本的python程序。

1. 设置环境变量： `PY_PYTHON=3` ，用于指定默认的python版本（否则默认为python2）

1. 命令行通过 `py -0` 验证 launcher 的启动状态，以及常用指令

    * py -0 （同 py --list）
    * py -3
    * py -2.7
    * py -3.6-32

1. 目前的 shebang: "#!/usr/bin/env python3" 并不能被启动器自动识别。

    解决方案： 在python3的安装目录中复制 python.exe -> python3.exe

## 2. Customization via INI files

Two .ini files will be searched by the launcher—— `py.ini` in the current user’s “application data” directory (i.e. the directory returned by calling the Windows function `SHGetFolderPath` with `CSIDL_LOCAL_APPDATA` ) and `py.ini` in the same directory as the launcher. The same .ini files are used for both the ‘console’ version of the launcher (i.e. py.exe) and for the ‘windows’ version (i.e. pyw.exe).

Customization specified in the “application directory” will have precedence over the one next to the executable, so a user, who may not have write access to the .ini file next to the launcher, can override commands in that global .ini file.

Setting `PY_PYTHON=3` and `PY_PYTHON3=3.1` is equivalent to the INI file containing:

```
[defaults]
python=3
python3=3.1
```

Examples:

* If no relevant options are set, the commands python and python2 will use the latest Python 2.x version installed and the command python3 will use the latest Python 3.x installed.

* The commands python3.1 and python2.7 will not consult any options at all as the versions are fully specified.

* If PY_PYTHON=3, the commands python and python3 will both use the latest installed Python 3 version.

* If PY_PYTHON=3.1-32, the command python will use the 32-bit implementation of 3.1 whereas the command python3 will use the latest installed Python (PY_PYTHON was not considered at all as a major version was specified.)

* If PY_PYTHON=3 and PY_PYTHON3=3.1, the commands python and python3 will both use specifically 3.1

### 2.1. UTF-8 mode

New in version 3.7.

Windows still uses legacy encodings for the system encoding (the ANSI Code Page). Python uses it for the default encoding of text files (e.g. locale.getpreferredencoding()).

This may cause issues because UTF-8 is widely used on the internet and most Unix systems, including WSL (Windows Subsystem for Linux).

You can use UTF-8 mode to change the default text encoding to UTF-8. You can enable UTF-8 mode via the `-X utf8` command line option, or the `PYTHONUTF8=1` environment variable. See PYTHONUTF8 for enabling UTF-8 mode, and Excursus: Setting environment variables for how to modify environment variables.