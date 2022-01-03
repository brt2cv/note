<!--
+++
title       = "create_ap: Linux的热点工具"
description = "1. Installation; 2. 临时运行; 3. 系统环境启动; 4. Error处理"
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

> [github: Home](https://github.com/oblique/create_ap)

## 1. Installation

```sh
# 安装依赖库
sudo apt-get install util-linux procps hostapd iproute2 iw haveged dnsmasq

git clone https://github.com/oblique/create_ap
cd create_ap
make install
```

## 2. 临时运行

No passphrase (open network):

```
create_ap wlan0 eth0 MyAccessPoint
```

WPA + WPA2 passphrase:

```
create_ap wlan0 eth0 MyAccessPoint MyPassPhrase
```

AP without Internet sharing:

```
create_ap -n wlan0 MyAccessPoint MyPassPhrase
```

## 3. 系统环境启动

配置create_ap, 路径：`/etc/create_ap.conf`

```
# 至少修改这四项，其他的可以不用更改
WIFI_IFACE=wlp3s0 #网卡名称
INTERNET_IFACE=enp9s0 #网卡名称
SSID=AP_Ali #热点名称
PASSPHRASE=apap_1234 #热点密码
```

开启热点和关闭热点：

```
sudo systemctl start create_ap # 开启热点
sudo systemctl stop create_ap # 关闭热点
sudo systemctl enable create_ap.service # 开机启动
```

## 4. Error处理

若是无法启动热点，报错如: `ERROR: Failed to initialize lock` ，执行命令 `rm /tmp/create_ap.all.lock` 即可。参考：[https://github.com/oblique/create_ap/issues/384](https://github.com/oblique/create_ap/issues/384)
