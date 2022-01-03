<!--
+++
title       = "文件标签神器: TMSU"
description = "1. 安装; 2. 初始化TMSU数据库; 3. 标记文件; 4. 标签查询; 5. \*查找文件; 6. 虚拟文件系统; 7. 标签管理"
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

TMSU是用于标记文件的工具。它提供了一个简单的命令行实用程序，用于应用标签和虚拟文件系统，从而为您提供来自任何其他程序的文件的基于标签的视图。

![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200720172259409-1252897734.png) <!-- tmsu/keepng_tmsu.png -->

TMSU不会以任何方式更改您的文件：无论您将它们放在磁盘上还是在网络上，它们都保持不变。TMSU维护自己的数据库，您只需获得一个其他视图即可根据设置的标签将其安装在所需的位置。

> [homepage](https://tmsu.org/)
>
> [github](https://github.com/oniony/TMSU)

## 1. 安装

经测试，通过源的方式并不适用于Ubuntu20.04。

所以，建议直接下载release程序：

[github: tmsu-releases](https://github.com/oniony/TMSU/releases)

## 2. 初始化TMSU数据库

在获得标记之前，您需要初始化TMSU数据库：

```
$ cd $project_dir
$ tmsu init
```

实际上，会创建一个 `$project_dir/.tmsu/db` 的数据库文件。

这样，只要您位于该目录下，该数据库就会自动使用。

## 3. 标记文件

使用tag命令将标签应用于文件：

```
$ tmsu tag summer.mp3 music big-jazz mp3
tmsu: New tag 'music'
tmsu: New tag 'big-jazz'
tmsu: New tag 'mp3'
```

### 3.1. 标记多个文件

如果您有一组文件，并且希望对每个文件应用相同的标签，那么可以使用另一种形式的命令将文件放在最后。例如，我们可以将当前目录中的所有MP3文件标记为 `music` 和 `mp3` ：

```
$ tmsu tag --tags "music mp3" *.mp3
```

### 3.2. 替换（删除）标签

我们可以使用merge命令修复此问题，将意外创建的umsic标签合并到现有的音乐标签中：

```
$ tmsu merge <tag_err> <tag_true>
```

### 3.3. 指定标签的值

```
$ tmsu tag spring.mp3 year=2003
$ tmsu tag summer.mp3 year=2008
$ tmsu tag winter.mp3 year=2010
```

## 4. 标签查询

我们可以使用tags命令查看新创建的标记文件的标记：

### 4.1. 列出全部标签

```
$ tmsu tags
```

### 4.2. 查询某文件的标签

```
$ tmsu tags summer.mp3
big-jazz
mp3
music
year=2008
```

### 4.3. 一次查询多个文件的标签

```
$ tmsu tags *.mp3
spring.mp3: folk mp3 music year=2003
summer.mp3: big-jazz mp3 music year=2008
winter.mp3: mp3 music year=2010
```

## 5. \*查找文件

现在我们有了一组标记文件，我们可以开始使用标记信息来进行一些简单的查询。让我们用files命令列出我们的mp3文件：

```
$ tmsu files mp3
spring.mp3
summer.mp3
winter.mp3
```

或者，我们可以更具体一些，列出同时包含了 `mp3` 和 `big-jazz` 的文件：

```
$ tmsu files mp3 big-jazz  # 中间也可以加一个 and 符号
summer.mp3
```

### 5.1. 高级筛选（逻辑运算：与或非）

```
$ tmsu files "(mp3 or flac) and not big-jazz"
spring.mp3
winter.mp3
```

### 5.2. 通过数值进行筛选

您还可以根据标签的值检索文件。我们可以检索2010年以来的所有文件，例如：

```
$ tmsu files year = 2010
winter.mp3

$ tmsu files "music and year >= 2000 and year < 2010"
spring.mp3
summer.mp3
```

## 6. 虚拟文件系统

从命令行列出文件非常好，但是当我们要从其他程序（尤其是具有图形界面的程序）访问文件时，它并不是很有用。TMSU还支持我们可以挂载的虚拟文件系统（VFS）：

```
$ mkdir mp
$ tmsu mount mp
$ ls mp
queries
tags
$ ls mp/tags
big-jazz mp3 music
$ ls -l mp/tags/music
drwxr-xr-x 0 paul paul 0 2012-04-13 20:00 big-jazz
drwxr-xr-x 0 paul paul 0 2012-04-13 20:00 mp3
drwxr-xr-x 0 paul paul 0 2012-04-13 20:00 spring.2.mp3 -> /home/paul/spring.mp3
drwxr-xr-x 0 paul paul 0 2012-04-13 20:00 summer.1.mp3 -> /home/paul/summer.mp3
drwxr-xr-x 0 paul paul 0 2012-04-13 20:00 winter.3.mp3 -> /home/paul/winter.mp3
                                                 ↑
                                             file id
```

![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200720172259634-1227818387.jpg) <!-- tmsu/tmsu-0.jpg -->

虚拟文件系统中的文件实际上只是<font color=#FF0000>符号链接</font>，指向指向标记文件在文件系统上其他位置的真实位置。这意味着它们可以像任何应用程序中的常规文件一样使用。

### 6.1. 标签目录

自动将所有文件按标签进行归类。同一个文件可能被link到不同的tag文件夹下。

### 6.2. 查询目录

除了标签视图之外，还有一个查询目录，您可以在其中运行视图查询，就像我们先前使用files命令运行的查询一样（优势在于，它直接以视图方式显示出来，并停留在当前目录下，直到你手动删除）。

要获得基于查询的视图，您只需要创建一个包含查询文本的目录（在“查询”下）：

```
$ ls mp/queries
README.md
$ mkdir "mp/queries/mp3 and not folk"
$ ls "mp/queries/mp3 and not folk"
summer.1.mp3
winter.3.mp3
```

实际上，它甚至比这更容易，因为TMSU会自动为您创建目录：

```
$ ls mp/queries
mp3 and not folk
$ ls "mp/queries/mp3 and big-jazz"
summer.1.mp3
$ ls mp/queries
mp3 and not folk  mp3 and big-jazz
```

通过自动创建查询目录，只需键入查询即可在图形程序的文件选择器中使用新文件查询。

不需要的查询目录可以用'rmdir'删除。

## 7. 标签管理

TMSU还允许您通过虚拟文件系统限制标签管理操作。例如，您可以通过创建新目录来创建新标签：

```
$ mkdir mp/tags/lounge
```

通过删除标签目录中的符号链接，从文件中删除特定标签：

```
$ rm mp/tags/mp3/summer.1.mp3
```

通过删除空标签目录来删除未使用的标签：

```
$ rmdir mp/tags/house
```

或通过执行递归删除来删除使用的标签：

```
$ rm -r mp/tags/big-jazz
```
