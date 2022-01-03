<!--
+++
title       = "Android测试与ADB的使用"
description = "1. 搭建测试环境; 2. ADB 架构; 3. 实体机的投屏与测试（基于scrcpy，无需Root）"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","12-设备端"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 搭建测试环境

### 1.1. 安卓模拟器

强烈推荐：Genymotion，个人用户可以下载免费版（但需要注册）【[官网下载](https://www.genymotion.com/fun-zone/)】

Genymotion号称最快的安卓模拟器，它是通过VirtualBox实现的。如果你的电脑上已经安装了VirtualBox虚拟机，可以下载独立的Genymotion（约44MB）版本，完成软件安装。

注意：这里仅仅是安装Genymotion软件，而Android虚拟机则是在Genymotion运行时，需要联网下载的。

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152018804-203462498.jpg) <!-- adb/adb-2.jpg -->

注意，如果没有打包安装VirtualBox，需要在配置中指定VirtualBox在本机的安装目录

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152018987-898070979.jpg) <!-- adb/adb-3.jpg -->

安装Android虚拟机

有可能安装不成功，我在安装Android 8.0的时候就失败了，于是退回到Android7.1版本，成功！

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152019195-1576812352.png) <!-- adb/keepng_2_1077750-20181210130443734-2078032073.png -->

启动虚拟机

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152019411-1300526833.jpg) <!-- adb/3_1077750-20181210130722383-208073272.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152019629-631288989.jpg) <!-- adb/4_1077750-20181210130753348-485516490.jpg -->

此时，打开VirtualBox，可以看到增加了虚拟机，并默认提供了出厂备份（不过无法通过VBox直接打开该Android系统）

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152019829-207162813.png) <!-- adb/keepng_5_1077750-20181210131346929-990578249.png -->

### 1.2. 安装SDK Platform Tools

Linux：


```sh
sudo apt-get install android-tools-adb android-tools-fastboot
```

Windows：

[官网地址](https://developer.android.google.cn/studio/releases/platform-tools)：https://developer.android.google.cn/studio/releases/platform-tools

解压到任何目录，直接执行adb程序即可运行

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152020021-2063447983.png) <!-- adb/keepng_6_1077750-20181210132356824-2085372278.png -->


### 1.3. 通过ADB连接到Genymotion安卓虚拟机

Genymotion对ADB有两种支持方式，我直接使用的默认形式，如图：

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152020228-1056967507.jpg) <!-- adb/adb-4.jpg -->

但此时，运行adb，却无法检测到设备……提示版本不匹配

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152020416-1294065047.png) <!-- adb/keepng_8_1077750-20181210133041047-768841495.png -->

于是，在我更新SDK Platform Tools之后，正常运行了……

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152020593-42137034.png) <!-- adb/keepng_9_1077750-20181210132923228-2071184050.png -->

但我很好奇，adb命令只启动了对应版本的client，而同样运行在PC端的ADB-Server却是40版本，说明Server的程序并不在SDK Platform Tools工具包之中，而是随安卓系统而运行的。看来adb的启动原理还得继续探索学习……

## 2. ADB 架构

详见：《[adb概览及协议参考](https://blog.csdn.net/zhubaitian/article/details/40260783)》

简单来说，就是两层 C/S 结构，构件包括了：

  * Client
  * Server
  * ADB Daemon

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152020812-1088090562.jpg) <!-- adb/10_1077750-20181216223647148-806795423.jpg -->

架构图如下：

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152020977-1298217535.jpg) <!-- adb/11_1077750-20181216223837093-118431038.jpg -->

看起来，ADB的概念有点凌乱——Client 作为客户端，与Server却是同一个程序（adb.exe），都运行在PC端。我觉得，所谓的ADB-Server，更像是一个集成在客户端的多路路由（Router, or Dispatcher），负责将来自于 Console、IDE 等各处ADB的调试命令转发到设备端。

设备作为终端，需要响应客户端的调试请求，这个任务由 ADB Daemon 完成：它具备root权限，用于调用Android系统底层shell，添加、修改文件或程序，或是将请求转发给其他的Android-APP。然后，在通过TCP网络将数据反馈给客户端（PC）。

这样，ADB中至少存在着两组TCP连接：

  * PC内部: Client-Server的连接，主要用于实现PC上多个客户端的调用模式；
  * 设备之间: Server-Daemon的连接，用于 PC-Andorid 设备间通信；
  * adb forward 模式时: Daemon将数据通过TCP转发到其他节点。

思考：

但有一点我目前还不能理解——既然 Server 通过5037端口监听着 Client 的连接，并保持着与 Device-Daemon 的连接（例如，通过与5555端口），为何还要动态分配 5554-5585 这些端口？这个设计既笨重，又丑陋，还限制了能否连接Devices的数量（16个）。而实际上，Device-Daemon 可以固定使用一个端口监听，通过Msg_Header指定消息的发送源，ADB-Server有能力实现对不同线路消息的区分……


### 2.1. ADB forward 转发模式

在PC端执行以下命令：

    adb forward tcp:6100 tcp:7100

可以将 PC-Client 发送向 127.0.0.1:6100 的消息，传送给监听着 127.0.0.1:7100 的设备端程序。但注意，无论是 PC-Client，还是设备端的 Application，他们的通信的对象都是本机运行的中间件，而不是二者直接点对点连接。由于127.0.0.1内通讯完全不受网络干扰，所以 PC-Client 的连接一定是成功的（它连接的对象是 PC-Server），但并不能保证 Server-Daemon 之间的通讯环境稳定，获取消息并转发给 Device-Application。

注意：这是一个非常显著的区别——你甚至无法通过TCP-API判断是否连接成功，验证方式只能是接受到真正来自于 App 的 Response。

这种区别，也将导致我们在 socket 的连接时，修改代码的验证方式。

### 2.2. 利用ADB转发，通过USB让Android访问PC端服务？

首先，这是一个本不该使用ADB实现的需求——Android可以利用USB共享网络，与PC建立局域网，何必非要ADB？

其次，ADB本身也是为了从PC端下发调试信息，设备是作为服务端响应PC请求的……与Android向PC请求的节奏并不符。

尽管如此，如果就遇到了这么一个“反人类”的需求，能不能完成呢？（不考虑PC端轮询的丑陋方式）

既然 ADB forward tcp2tcp 中，是三组TCP网络连接，而TCP是全双工的连接，建立连接后，请求端和应答端的地位是对等的。也就是说，ADB-Server-Appliaction 作为Server的唯一要点，仅仅是在建立连接时。而一旦完成了连接，则由 PC-Client 进入recv阻塞，直到 Request 到来……看上去，只是节奏稍有不同，但一切并不与技术框架相违背。

## 3. 实体机的投屏与测试（基于scrcpy，无需Root）

必要条件：

+ 至少是5.0+版本的 Android 设备
+ 需要启用ADB调试

    在某些设备上,还需要在安全模式选项中启用USB调试（这对于通过USB管理Android设备至关重要）。

+ 已安装ADB和Fastboot

### 3.1. 安装 scrcpy & 运行

安装：

+ Linux: `sudo apt install scrcpy`
+ Windows: [github: releases](https://github.com/Genymobile/scrcpy/releases)

运行：

1. 连接手机，并且启动USB调试。
2. 启动scrcpy

运行之后，就可以看到手机界面出现在了电脑屏幕上。这个界面是可以交互的，在这里的操作会同步到手机上，如下图。

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152021247-186923903.jpg) <!-- adb/adb-0.jpg -->

### 3.2. 命令行选项 & 快捷键

+ 启动程序

    如果有多个设备，需要指定序列号（序列号可以从 `adb devices` 获得）

    scrcpy -s a1171b8

+ 设置端口

    scrcpy -p 27184

+ 查看帮助

    scrcpy --help

+ 设置码率（默认8M）

    scrcpy -b 8M

+ 限制投屏尺寸

    scrcpy -m 1024

+ 裁剪投屏屏幕(长:宽:偏移x:偏移y)

    scrcpy -c 800:800:0:0

+ 投屏并录屏

    scrcpy -r file.mp4

+ 不投屏只录屏

    scrcpy -Nr file.mp4

+ 手指触摸的时候显示轨迹球

    scrcpy -t

+ 显示版本信息

    scrcpy -v

快捷键：

+ 切换全屏模式: Ctrl+f
+ 将窗口调整为`1:1`: Ctrl+g
+ 调整窗口大小以删除黑色边框: Ctrl+x | 双击黑色背景
+ 设备HOME键: Ctrl+h | 鼠标中键
+ 设备BACK键: Ctrl+b | 鼠标右键
+ 设备任务管理键: Ctrl+s
+ 设备菜单键: Ctrl+m
+ 设备音量+键: Ctrl+↑
+ 设备音量-键: Ctrl+↓
+ 设备电源键: Ctrl+p
+ 点亮手机屏幕: 鼠标右键
+ 复制内容到设备: Ctrl+v
+ 启用:/禁用FPS计数器（stdout）: Ctrl+i
+ 安装APK: 将apk文件拖入投屏
+ 传输文件到设备: 将文件拖入投屏（非apk）

### 3.3. 利用无线模式运行
> [Ubuntu安卓手机投屏](https://blog.csdn.net/zekdot/article/details/94782904)

正确的启动顺序：

1. 连接数据线
2. 允许USB调试
3. 连接电脑相同WIFI
4. 找到手机IP
5. 在手机上开启5555端口: `adb tcpip 5555`
6. adb连接手机无线网卡: `adb connect 10.42.0.78:5555`

    记得要在手机上点击"确定"。

    此时通过 `adb devices` 可以看到adb列表中已经出现了新的设备：

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152021583-1206283389.jpg) <!-- adb/adb-1.jpg -->

7. 此时可以拔掉数据线了
8. 强制未授权的设备重新链接: `adb reconnect offline`
9. adb再次连接设备: `adb connect 10.42.0.78:5555`
10. 运行scrcpy即可
