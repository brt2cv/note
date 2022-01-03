<!--
+++
title       = "pip应用实例"
description = "1. 安装; 2. 镜像源; 3. 仅下载; 4. 卸载; 5. 列举已安装包; 6. 查看已安装包的信息; 7. 查询; 8. 缓存管理"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","14-command"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

> [homepage](https://pip.pypa.io/en/stable/)

[TOC]

---

## 1. 安装

### 1.1. 指定版本

```
$ pip install SomePackage
$ pip install SomePackage==1.0.4
$ pip install 'SomePackage>=1.0.4,<2'   # 多个版本条件
```

安装whl文件包

`$ pip install SomePackage-1.0-py2.py3-none-any.whl`

### 1.2. 用户权限

`sudo pip3 install packagename`

代表进行全局安装，安装后全局可用。如果是信任的安装包可用使用该命令进行安装。

`pip3 install --user packagename`

代表仅该用户的安装，安装后仅该用户可用。处于安全考虑，尽量使用该命令进行安装。

### 1.3. 读取requirments.txt

安装：

`pip install -r requirements.txt`

Freeze

`pip freeze > requirments.txt`

### 1.4. 不使用缓存文件

有时我们不希望使用缓存文件，而是从服务器重新下载（不同版本等）：

`pip --no-cache-dir install packagename`

当然，你也可以直接干掉缓存目录。

### 1.5. 指定extras_require

使用 `pip install -e` 指定extras_require

## 2. 镜像源

### 2.1. 临时使用

`pip install pythonModuleName -i https://pypi.douban.com/simple`

### 2.2. 修改配置文件

为了修改默认的镜像源，在Linux系统中，需要修改~/.pip/pip.conf

```
[global]
index-url = https://pypi.douban.com/simple
```

或者使用命令： `pip config`

### 2.3. 国内镜像源

* [清华](https://pypi.tuna.tsinghua.edu.cn/simple) : https://pypi.tuna.tsinghua.edu.cn/simple)
* [阿里云](https://mirrors.aliyun.com/pypi/) : https://mirrors.aliyun.com/pypi/)
* [中国科技大学](https://pypi.mirrors.ustc.edu.cn/simple/) : https://pypi.mirrors.ustc.edu.cn/simple/)
* [华中理工大学](https://pypi.hustunique.com/) : http://pypi.hustunique.com/)
* [山东理工大学](http://pypi.sdutlinux.org/) : http://pypi.sdutlinux.org/)
* [豆瓣](https://pypi.doubanio.com/simple/) : https://pypi.doubanio.com/simple/)

## 3. 仅下载

`pip download`

## 4. 卸载

`$ pip uninstall SomePackage`

## 5. 列举已安装包

```
$ pip list
docutils (0.9.1)
Jinja2 (2.6)
Pygments (1.5)
Sphinx (1.1.2)
```

查询可升级的包：

`pip list -o`

## 6. 查看已安装包的信息

```
$ pip show sphinx
---
Name: Sphinx
Version: 1.1.3
Location: /my/env/lib/pythonx.x/site-packages
Requires: Pygments, Jinja2, docutils
```

## 7. 查询

```
$ pip search "query"
$ pip show -f somePackage  # 显示指定包的详细信息
```

查看所有可用包的列表:

`pip search *`

你可以在此处找到完整的包列表： https://pypi.python.org/pypi/

可以在此处找到具有更简单标记的索引，以便于自动使用： https://pypi.python.org/simple/

## 8. 缓存管理

### 8.1. 指定缓存目录

```
[global]
download_cache = ~/.cache/pip
```

### 8.2. 无网络环境下使用缓存的旧版本

如果pip没有连接上服务器，但本地有缓存的包（尽管不一定是最新的）。

```
pip install --no-index --find-links=file:///C:/pip_downloads/ptipython
```

* --no-index 是忽略包索引（仅仅从--find-links的链接地址中去查找包)
* --find-links <url> 如果指定某个机器的连接地址，就会从该地址进行查找包依赖并进行下载，如果指定的是本地的文件，则直接从本地文件夹下载

### 8.3. 提取缓存文件

如果包已经安装，但需要提取whl文件，留作备用，可以使用：

![](https://img2020.cnblogs.com/blog/2039866/202005/2039866-20200527100838213-1342349400.png) <!-- pip\keepng_2019-11-30-09-55-10.png -->

可以看到，如果是已经缓存的包，将直接save到 `当前目录`。不过，依赖包为什么又要重新下载？额...

### 8.4. 使用pip2tgz

因为pip默认缓存文件比较凌乱，目录如下：

![](https://img2020.cnblogs.com/blog/2039866/202005/2039866-20200527100838486-1372003998.png) <!-- pip\keepng_2019-11-30-09-28-29.png -->

但如果下载时使用pip2tgz，则可以备份成本地的pip源。

```
# 使用pip2tgz下载所有程序包
$ pip2tgz /var/lib/packages -r requirement.txt
```

如果需要重新安装，使用本地pip源即可：

`pip install -r requirement.txt --no-index --find-links=/var/lib/packages`
