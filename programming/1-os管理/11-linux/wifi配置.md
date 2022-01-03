<!--
+++
title       = "Wifi配置"
description = "1. Ubuntu::NetworkManager; 2. Raspberry-Pi（Debian::Buster)"
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

## 1. Ubuntu::NetworkManager
> [cnblog](https://www.cnblogs.com/EasonJim/p/8072298.html)
>
> [ubuntu](https://help.ubuntu.com/community/NetworkManager)

NetworkManager工具是Ubuntu桌面版的GUI设置工具。这个工具推荐直接在GUI上操作，不建议用命令行进行管理，比如Wifi这些配置等。

当然，这个工具能带有命令行工具：`nmcli` ，如果使用了NetworkManager进行配置网络，那么IP、网关、DNS都可以通过这个工具进行查询。

注意：如果配置了命令行的网络设置（例如：/etc/netwok/interface），那么<font color=#FF0000>NetworkManager就会失效</font>。

![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200703194112744-2049675630.jpg) <!-- wifi配置/wifi配置0.jpg -->

那我哪儿知道都有哪些WiFi信号？！

`nnmcli device wifi list`

![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200703194113054-580314895.jpg) <!-- wifi配置/wifi配置1.jpg -->

我也不太明白，Wifi列表的查询这么重要的功能，并没有集成到GUI里，而是console操作。或许我还没有找到那个精巧的入口？

查看IP、网关、DNS: `nmcli device show` .

NetworkManager服务常用操作

```sh
#启动
sudo systemctl start NetworkManager
# sudo service network-manager start

#停止
sudo systemctl stop NetworkManager
# sudo service network-manager stop
```

## 2. Raspberry-Pi（Debian::Buster)

```sh
cd /etc/wpa_supplicant/
sudo nano wpa_supplicant.conf
```

内容如下

```py
country=CN
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="brt3@Z2"
    psk="qq123123"
    key_mgmt=WPA-PSK
    priority=5
}

network={
    ssid="Heroje"
    psk="hejiewifi"
    key_mgmt=WPA-PSK
    priority=1
}
```

直接填入内容即可。
