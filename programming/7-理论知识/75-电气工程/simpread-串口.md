<!--
+++
title       = "COM串口，了解下"
description = "1. 串口概念; 2. 电平间转换"
date        = "2021-12-21"
tags        = []
categories  = ["7-理论知识","75-电气工程"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> [csdn: 串口、COM口、UART口, TTL、RS-232、RS-485区别详解](https://blog.csdn.net/zhuyongxin\_6688/article/details/78001767)

## 1. 串口概念

UART是一种异步通信协议。

TTL、RS-232、RS-485是指的电平标准。

+ TTL标准是低电平为0，高电平为1（+5V电平）
+ RS-232标准是正电平为0，负电平为1（±15V电平）。
+ RS-485与RS-232类似，但是采用差分信号负逻辑。

COM口即串行通讯端口，简称串口。这里区别于USB的“通用串行总线”和硬盘的“SATA”。

UART可以使用rs232物理层来进行通信，也可以用TTL等其他物理接口类型。而rs232作为物理层也可以用其他不同于UART的协议来做通信。

一般我们见到的是两种物理标准（物理层的电气接口，或者说是外形）：

+ D型9针插头
+ 4针杜邦头

这是常见的 4 针串口，在电路板上常见，经常上边还带有杜邦插针。还有时候有第五根针，3.3V 电源端。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200901095423942-870099020.jpg) <!-- simpread-串口/simpread-串口-2.jpg -->

由于是预留在电路板上的，协议可以有很多种，要看具体设备。

串口常见的有4个pin（VCC, GND, RX, TX），用的 TTL 电平，低电平为 0(0V)，高电平为 1（3.3V 或以上）。


下面这个就是 `D型9针串口` (通俗说法)。在台式电脑后边都可以看到。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200901095424182-1187740180.jpg) <!-- simpread-串口/simpread-串口-0.jpg -->

记住，这种接口的协议只有两种：RS-232 和 RS-485。不会是 TTL 电平的 (除非特殊应用)。

9针串口的定义可以参考这里：[http://wenku.baidu.com/view/5c170c6925c52cc58bd6be6e.html](http://wenku.baidu.com/view/5c170c6925c52cc58bd6be6e.html)

接设备的时候，一般只接GND RX TX。不会接Vcc或者+3.3v的电源线，避免与目标设备上的供电冲突。

## 2. 电平间转换

+ PL2303、CP2102芯片是 `USB转TTL串口` 的芯片，用USB来扩展串口(TTL电平)。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200901095424379-1663225913.jpg) <!-- simpread-串口/simpread-串口-1.jpg -->

+ MAX232芯片是TTL电平与RS232电平的专用双向转换芯片，可以TTL转RS-232，也可以RS-232转TTL。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200901095424581-149706581.jpg) <!-- simpread-串口/simpread-串口-4.jpg -->
