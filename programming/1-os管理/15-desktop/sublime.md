<!--
+++
title       = "Linux安装Sublime及使用"
description = "1. sublime; 2. 分享一个Sublime_Text-3211的注册码; 3. 插件; 4. Anaconda; 5. SublimeLinter; 6. GitConflictResolver"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","15-desktop"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. sublime

> [sublime_text_3_build_3211_x64.tar.bz2](http://downloads.yaolinux.org/sources/sublime_text_3_build_3211_x64.tar.bz2)

```sh
tar xjvf sublime_text_3_build_3211_x64.tar.bz2
mv sublime_text_3/ /opt/
```

## 2. 分享一个Sublime_Text-3211的注册码

对应版本：3211

```
----- BEGIN LICENSE -----
Member J2TeaM
Single User License
EA7E-1011316
D7DA350E 1B8B0760 972F8B60 F3E64036
B9B4E234 F356F38F 0AD1E3B7 0E9C5FAD
FA0A2ABE 25F65BD8 D51458E5 3923CE80
87428428 79079A01 AA69F319 A1AF29A4
A684C2DC 0B1583D4 19CBD290 217618CD
5653E0A0 BACE3948 BB2EE45E 422D2C87
DD9AF44B 99C49590 D2DBDEE1 75860FD2
8C8BB2AD B2ECE5A4 EFC08AF2 25A9B864
------ END LICENSE ------
```

## 3. 插件

### 3.1. Package Control（手动下载）

问题：无法连接到服务器，应该是被墙了……

手动下载一个package control的包：[https://github.com/wbond/package_control/release](https://github.com/wbond/package_control/release)

把下载下来的包解压，将解压后的文件夹重命名为 `Package Control` ，拷贝到 `.config/sublime-text-3/Packages` 目录下就完成了安装。

重新点击菜单栏Perferences，会发现多了 `Package Settings` 和 `Package Control` 这两个菜单，这就说明 `Package Control` 安装成功了。

不过，当你安装插件时，会提示无法访问 `https://packagecontrol.io/channel_v3.json` 。这个应该也是被墙了...

解决方法：

打开 `Package Settings -> Package Control -> Settings` ，添加

```json
    "channels":
    [
        "http://cst.stu.126.net/u/json/cms/channel_v3.json"
    ],
```

### 3.2. MarkdownEditing
> [sublime_page](https://packagecontrol.io/packages/MarkdownEditing)
>
> [github_release](https://github.com/SublimeText-Markdown/MarkdownEditing/releases)

解压至 `.config/sublime-text-3/Packages` 目录下即可。

### 3.3. MarkdownPreview & LiveReload
> [sublime_page](https://packagecontrol.io/packages/MarkdownPreview)
>
> [github_release](https://github.com/facelessuser/MarkdownPreview/releases)

解压后，提示缺少依赖。如果网络正常，会自动下载到 Packages 目录。如果网络不通，建议手动拷贝以下四个文件夹至 `Lib/python3.3/` 目录：

+ pygments
+ pyyaml
+ python-markdown
+ pymdownx

另，插件独立运行时，不支持文件更新后的html的刷新。如果需要该功能，请下载 `LiveReload` 插件。

### 3.4. SublimeImagePaste2
> [gitee](https://gitee.com:brt2/subl_imgpaste2)

用于Markdown中粘贴剪切板中的图片到本地目录。

### 3.5. SublimeFileTemplates
> [gitee](https://gitee.com:brt2/subl_ftpl)

通过模板，快速创建特定格式的文件。

## 4. Anaconda

Python的运行环境插件。

### 4.1. 代码的静态检查
> [homepage](https://github.com/DamnWidget/anaconda/blob/master/Anaconda.sublime-settings)

anaconda自带了静态检查（默认使用pep8）工具，也可以支持pylint。常用的设置项如下：

```
    "anaconda_linting": true,
    "anaconda_linting_behaviour": "save-only",  // always
    "anaconda_linter_underlines": false,
    "anaconda_linter_mark_style": "squiggly_underline",
    // "use_pylint": true
    "pep8_rcfile": false,
    "pep8_max_line_length": 128,
```

## 5. SublimeLinter
> [sublime_page: SublimeLinter](https://packagecontrol.io/packages/SublimeLinter)
>
> [github: SublimeLinter](https://github.com/SublimeLinter/SublimeLinter)
>
> [sublime_page: SublimeLinter-pylint](https://packagecontrol.io/packages/SublimeLinter-pylint)
>
> [github: SublimeLinter_pylint](https://github.com/SublimeLinter/SublimeLinter-pylint)

用于语法检查。个人目前只是用sublime编写python，所以真正用到的，就是 `SublimeLinter-pylint` 。

`SublimeLinter-pylint` 依赖 `SublimeLinter` ，所以把两个包下载后放到 Packages 目录下即可。

注意，SublimeLinter-pylint 依赖于Python模块：

+ jsonschema

## 6. GitConflictResolver
