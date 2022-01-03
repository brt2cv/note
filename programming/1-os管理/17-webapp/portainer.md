<!--
+++
title       = "使用GUI工具Portainer.io管控Docker容器"
description = "1. 单机版运行; 2. 配置container"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","17-webapp"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200927202221436-805781557.jpg) <!-- portainer/portainer-0.jpg -->

Portainer是Docker的图形化管理工具，提供状态显示面板、应用模板快速部署、容器镜像网络数据卷的基本操作（包括上传下载镜像，创建容器等操作）、事件日志显示、容器控制台操作、Swarm集群和服务等集中管理和操作、登录用户管理和控制等功能。功能十分全面，基本能满足中小型单位对容器管理的全部需求。

+ 轻量级 （2,3个命令就可启动，镜像少于30M）
+ 可以用于Docker监控和构建
+ 可在界面管理 Container、Image、Network、Volume、Config
+ 提供许多内置的操作模板，如Wordpress
+ 尽乎实时的 监视Container、Image...
+ 支持 Docker-Swarm 集群监视

## 1. 单机版运行

```sh
docker run -d -p 9000:9000 \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name prtainer-test \
    docker.io/portainer/portainer
```

## 2. 配置container

如图所示，非常易用。从此告别docker的各种复杂命令。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200927202221770-1110667883.jpg) <!-- portainer/portainer-1.jpg -->
