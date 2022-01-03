<!--
+++
title       = "Pyinstaller最流行的打包程序"
description = "1. 命令行使用; 2. spec文件，定义编译流"
date        = "2021-12-21"
tags        = []
categories  = ["3-syntax","33-python","3rd-modules"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 命令行使用
> [Using PyInstaller to Easily Distribute Python Applications](https://realpython.com/pyinstaller-python/)
>
> [使用PyInstaller轻松分发Python应用程序](https://cloud.tencent.com/developer/news/432246)

```sh
pyinstaller.exe ../build_xxx.py -i "../app/xxx/res/yyy.ico" -p '../runtime/win32/python37/lib/;../runtime/win32/python37/libex/' -w
```

* `-i` : 图标文件；
* `-p` : PythonPath，Python的库目录路径；
* `-w` : Windows环境下，不启动命令行运行GUI程序；
* `--name`
* `-F` ( `--onefile` )
* `--hidden-import` : 声明隐式导入的依赖包；
* `--add-data`
* `--add-binary`
* `--exclude-module`

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200803183235916-497117824.jpg) <!-- pyinstaller\2019-12-12-15-39-36.jpg -->

## 2. spec文件，定义编译流

执行指令： `pyinstaller xxx.spec`

```py
# -*- mode: python ; coding: utf-8 -*-
# pyinstaller.exe ../build_xxx.py -i "../app/xxx/res/yyy.ico" -p '../runtime/win32/python37/lib/;../runtime/win32/python37/libex/' -w

block_cipher = None

a = Analysis(['../build_demo.py'],
             pathex=['../runtime/win64/Lib/site-packages'],
             binaries=[],
             datas=[
                ("../app/demo/view/ui", "app/demo/view/ui"),
             ],
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          [],
          exclude_binaries=True,
          name='Demo',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          console=True,
          icon='../app/ocrkit/res/ocr.ico')
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=False,
               upx=True,
               upx_exclude=[],
               name='Demo')

```

* `pathex` : 同 `cmd -p` 选项，对应PythonPath；
* `datas` : 复制文件或文件夹；
* `console` : 同 `cmd -w` 选项；
* `icon` : 同 `cmd -i` 选项；
