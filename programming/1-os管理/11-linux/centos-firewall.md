<!--
+++
title       = "centos防火墙配置"
description = "1. 关闭防火墙; 2. 开放端口"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","11-linux"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 关闭防火墙

CentOS 7、RedHat 7 之前的 Linux 发行版防火墙开启和关闭( iptables ):

即时生效，重启失效

```
#开启
service iptables start
#关闭
service iptables stop
```

重启生效

```
#开启
chkconfig iptables on
#关闭
chkconfig iptables off
```

CentOS 7、RedHat 7 之后的 Linux 发行版防火墙开启和关闭:

`systemctl stop firewalld.service`

## 2. 开放端口

CentOS 7、RedHat 7 之前的 Linux 发行版开放端口

```
#命令方式开放5212端口命令

#开启5212端口接收数据
/sbin/iptables -I INPUT -p tcp --dport 5212 -j ACCEPT


#开启5212端口发送数据
/sbin/iptables -I OUTPUT -p tcp --dport 5212 -j ACCEPT

#保存配置
/etc/rc.d/init.d/iptables save

#重启防火墙服务
/etc/rc.d/init.d/iptables restart

#查看是否开启成功
/etc/init.d/iptables status
```

CentOS 7、RedHat 7 之后的 Linux 发行版开放端口

```
firewall-cmd --zone=public --add-port=5121/tcp --permanent
# --zone 作用域
# --add-port=5121/tcp 添加端口，格式为：端口/通讯协议
# --permanent 永久生效，没有此参数重启后失效
```
