<!--
+++
title       = "apt用法详解"
description = "1. 常规操作; 2. update & upgrade; 3. apt-cache; 4. 配置apt-get的缓存路径; 5. dpkg"
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

## 1. 常规操作

* 更新仓库
`sudo apt-get update`

* 升级所有已安装的包
`sudo apt-get upgrade`

* 更新特定的包
`sudo apt-get install filezilla --only-upgrade`

* 卸载包
`sudo apt-get remove skype`

* <font color=#FF0000>上面的命令只会删除skype包，如果你想要删除它的配置文件，在apt-get命令中使用“purge”选项</font>：
`sudo apt-get purge skype`

* 我们可以结合使用上面的两个命令：
`sudo apt-get remove --purge skype`

* <font color=#FF0000>在当前的目录中下载包</font>
`sudo apt-get download icinga`

* <font color=#FF0000>清理本地包占用的磁盘空间</font>
`sudo apt-get clean`

* 我们也可以使用“autoclean”选项来代替“clean”，两者之间主要的区别是<font color=#FF0000> `autoclean` 清理不再使用且没用的下载</font>：
`sudo apt-get autoclean`

* autoremove：删除为了满足依赖而安装且现在没用的包
`sudo apt-get autoremove icinga`

* 展示包的更新日志
`sudo apt-get changelog apache2`

* 显示损坏的依赖关系
`sudo apt-get check`

## 2. update & upgrade

`apt update`：将远程软件库和本地软件库做对比，检查哪些软件可以更新，以及软件包依赖关系，给出一个分析报告。只检查不更新。

`apt upgrade`：在执行upgrade 之前要先执行update ，根据update的分析报告去下载并更新软件。在以下几种情况，某个待升级的软件包不会被升级。

+ 新软件包和系统的某个软件包有冲突
+ 新软件包有新的依赖，但系统不满足依赖
+ 安装新软件包时，要求先移除旧的软件包

`apt dist-upgrade`：在执行dist-upgrade 之前也要先执行update ，dist-upgrade 包含upgrade，同时增添了以下功能：

+ 可以智能处理新软件包的依赖
+ 智能冲突解决系统
+ 安装新软件包时，可以移除旧软件包，但不是所有软件都可以。

`apt full-upgrade`：在执行full-upgrade 之前也要先执行update ，升级整个系统，必要时可以移除旧软件包。

## 3. apt-cache

* 列出所有可用包
`apt-cache pkgnames`

* 用关键字搜索包
`apt-cache search "web server"`

* 如果你安装了“apt-file”包，我们就可以用配置文件搜索包：
`apt-file search nagios.cfg`

* 显示特定包的基本信息
`apt-cache show postfix`

* 列出包的依赖
`apt-cache depends postfix`

* 显示缓存统计
`apt-cache stats`

## 4. 配置apt-get的缓存路径

`man apt.conf`

在文档发现了这么一句：
> In general the sample configuration file in /usr/share/doc/apt/examples/apt.conf /usr/share/doc/apt/examples/configure-index.gz is a good guide for how it should look.

然后在 `/usr/share/doc/apt/examples/configure-index.gz` 中找到了如下内容：

```
...
// Directory layout
Dir "/"
{
...
  // Location of the cache dir
  Cache "var/cache/apt/" {
     Archives "archives/";
     // backup directory created by /etc/cron.daily/apt
...
```

同时，注意到了<font color=#FF0000>“// backup directory created by /etc/cron.daily/apt”</font>这句注释，打开 `/etc/cron.daily/apt` 看看，发现其中含有 `var/cache/apt` 这个apt-get的默认缓存路径，于是编辑 `/etc/cron.daily/apt` ，替换此默认路径为自定义路径即可。

## 5. dpkg

dpkg -i --instdir=/dest/dir/path some.deb
