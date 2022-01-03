<!--
+++
title       = "NextCloud: 打造自己的网盘"
description = "1. 自建网盘方案选择; 2. 推荐使用docker镜像; 3. 使用Python做客户端"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","17-webapp"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

> 几年前还百家争锋的国内网盘市场，如今只剩下百度网盘一枝独秀了。虽然还有一些稳定的国外网盘，如 OneDrive、DropBox、Google Drive 等，但国内访问并不友好。

[TOC]

---

> [github: homepage](https://github.com/nextcloud/server)
>
> [bilibili: Docker全自动搭建Nextcloud私人云网盘教程](https://www.bilibili.com/video/BV1Eb411x72U)

+ 源自[ownCloud](https://owncloud.com/)
+ 服务端程序基于php
+ 功能丰富，可安装插件实现各种云端功能。

## 1. 自建网盘方案选择

推荐的比较多的有三个：

+ Nextcloud
+ ownCloud
+ Seafile

## 2. 推荐使用docker镜像
> [docker: ](https://hub.docker.com/_/nextcloud)

*注意：docker镜像只开放了80端口。所以如果你开启了SSL，会发现443端口未开启。*

## 3. 使用Python做客户端
> [](https://github.com%2Fmatejak%2Fnextcloud-API)

```py
from nextcloud import NextCloud

NEXTCLOUD_URL = 'http://localhost'
NEXTCLOUD_USERNAME = 'admin'
NEXTCLOUD_PASSWORD = 'admin'
to_js = True

nxc = NextCloud(endpoint=NEXTCLOUD_URL, user=NEXTCLOUD_USERNAME, password=NEXTCLOUD_PASSWORD, json_output=to_js)
# 获取用户的列表
a = nxc.get_users()
print(a.data)

# 获取用户的文件夹信息
c = nxc.list_folders('admin')
print(c.data)

# 上传图片
local_filepath = '/Users/Pictures/pap.er/8.jpg'
upload_filepath = 'Photos/8.jpg'

b = nxc.upload_file('admin', local_filepath, upload_filepath)
print(b.data)

# 分享图片到公共链接
d = nxc.create_share('Photos/8.jpg', 3)
print(d.data)
```
