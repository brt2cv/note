<!--
+++
title       = "Termux安卓上的Linux开发环境"
description = "1. 安装; 2. 更新源; 3. 系统配置; 4. 配置ssh; 5. Python库的安装; 6. 定制常用按键; 7. 默认程序; 8. Termux:API"
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

> [Termux 使用教程 #1 - Android 手机安装 Linux](https://p3terx.com/archives/termux-tutorial-1.html)

Termux 是一个 An­droid 下的终端模拟器，可以在手机上模拟 Linux 环境。它是一个手机 App，可以从应用商店直接下载安装，打开就能使用，它提供一个命令行界面，让用户与系统交互。它支持 apt 软件包管理，可以十分方便安装软件包，而且完美支持 Python、PHP、Ruby、Go、Nodejs、MySQL 等工具。

随着智能设备的普及和性能的不断提升，如今手机、平板等设备的硬件标准已经直逼入门级桌面计算机，使用 Ter­mux 完全可以把手机变成一个强大的小型服务器。

你甚至可以使用 Ter­mux 通过 Nmap、Sqlmap、BB­Scan、sub­Do­mains­Brute、Hy­dra、Router­Sploit 等工具实现端口扫描、注入检测、子域名爆破、多协议弱口令爆破、路由器漏洞检测框架多种功能，把手机打造成一个随身携带的渗透神器，成为现实版的艾登・皮尔斯。

## 1. 安装
> [homepage](https://termux.com/)
>
> [F-Droid安装包](https://f-droid.org/packages/com.termux/)

Termux 是运行在 Android 上的 terminal。不需要root，运行于内部存储（不在SD卡上）。

自带了一个包管理器 `pkg` ，可以安装许多现代化的开发和系统维护工具。比如：

+ <font color=#FF0000>neovim</font>
+ tmux
+ zsh
+ clang
+ gcc
+ python
+ <font color=#FF0000>weechat</font>
+ <font color=#FF0000>irssi</font>

注意：在Google和F-Droid上发布的安装包由于签名不同，并不能相互替换，尤其是在匹配其插件（如Termux-API）时，可能造成意外的错误。

插件列表：

+ API: 用于调用安卓的原生功能，如拨打电话、拍照、GPS定位信息等

    * termux-share
    * termux-open-url

+ Termux:API

    Access Android and Chrome hardware features.

+ Termux:Boot

    Run script(s) when your device boots.

+ Termux:Float

    Run Termux in a floating window.

+ Termux:Styling

    Have color schemes and powerline-ready fonts customize the appearance of the Termux terminal.

+ Termux:Tasker

    An easy way to call Termux executables from Tasker and compatible apps.

+ Termux:Widget

    Start small scriptlets from the home screen.


## 2. 更新源

```sh
# The termux repository mirror from TUNA:
deb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main

# The termux repository mirror from TUNA:
deb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable

# The termux repository mirror from TUNA:
deb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable
```

然后执行 `pkg update` ，注意，提示更新系统命令时，选择 `n` ，否则会造成系统不稳定！

推荐安装以下软件：

```sh
pkg install openssh htop tsu proot git nano neofetch python
```

+ tsu：切换账户（root）
+ proot：无root权限执行需要root的命令
+ neofetch：查看系统信息

## 3. 系统配置

```sh
termux-setup-storage  # 获取对sdcard的读取权限
pkg install termux-services
pkg install termux-api
termux-wake-lock  # 息屏时保持Termux后台运行（否则cpu严重降速甚至ssh卡断）
```

## 4. 配置ssh

```sh
pkg install openssh
```

安装好之后，我们需要手工启动: `sshd`

需要指出的是, sshd 监听的是<font color=#FF0000>8022端口而不是22号端口</font>，因此可以使用下面命令来验证ssh服务是否开启。

```sh
ssh localhost -p 8022
```

若要查看sshd的日志，则可以在Termux上执行

```sh
logcat -s 'syslog:*'
```

为了方便，我们可以配置一下ssh client的配置文件,将下面内容加入到 `~/.ssh/config` 文件中：

```
Host termux
User u0_a171
HostName 192.168.31.145
Port 8022
```

这样只需要执行 ssh termux 就能登陆termx了。

## 5. Python库的安装

+ lxml:

    `pkg install libxml2 libxslt && pip install lxml`

    经测试，在0.73版本下，安装报错：

    `fatal error: 'iconv.h' file not found`

    解决方案：

    `pkg install libiconv`

+ Pillow:

    `pkg install libjpeg-turbo && pip install pillow`

    经验证，还需要手动安装 zlib: `pkg install zlib`

+ numpy:

    `pip install numpy`

+ pandas:

    最新版本失败，但 `pip install pandas==1.0.5` 成功

## 6. 定制常用按键
> [国光blog: Termux高级终端安装使用配置教程](https://www.sqlsec.com/2018/05/termux.html)

在 Termux v0.66 的版本之后我们可以通过 `~/.termux/termux.properties` 文件来定制我们的常用功能按键，默认是不存在这个文件的，我们得自己配置创建一下这个文件。

下面做尝试简单配置一下这个文件:

```
extra-keys = [\
  ['CTRL','ALT','TAB','LEFT','RIGHT','|','/','UP','DOWN'],\
  ['ESC','SHIFT','HOME','END','DEL','PGUP','PGDN','BKSP']]
```

## 7. 默认程序

将运行脚本放于目录: `~/.shortcuts/`

## 8. Termux:API
> [homepage](https://wiki.termux.com/wiki/Termux:API)

In Google Play Store, besides installing the Termux app, also install "Termux:API" app. This solves the hanging issue described below on Android 7.

To use Termux:API you also need to install the termux-api package.

```
pkg install termux-api
```

Current API implementations:

+ termux-battery-status

    Get the status of the device battery.

+ termux-brightness

    Set the screen brightness between 0 and 255.

+ termux-call-log

    List call log history.

+ termux-camera-info

    Get information about device camera(s).

+ termux-camera-photo

    Take a photo and save it to a file in JPEG format.

+ termux-clipboard-get

    Get the system clipboard text.

+ termux-clipboard-set

    Set the system clipboard text.

+ termux-contact-list

    List all contacts.

+ termux-dialog

    Show a text entry dialog.

+ termux-download

    Download a resource using the system download manager.

+ termux-fingerprint

    Use fingerprint sensor on device to check for authentication.

+ termux-infrared-frequencies

    Query the infrared transmitter's supported carrier frequencies.

+ termux-infrared-transmit

    Transmit an infrared pattern.

+ termux-job-scheduler

    Schedule a Termux script to run later, or periodically.

+ termux-location

    Get the device location.

+ termux-media-player

    Play media files.

+ termux-media-scan

    MediaScanner interface, make file changes visible to Android Gallery

+ termux-microphone-record

    Recording using microphone on your device.

+ termux-notification

    Display a system notification.

+ termux-notification-remove

    Remove a notification previously shown with termux-notification --id.

+ termux-sensor

    Get information about types of sensors as well as live data.

+ termux-share

    Share a file specified as argument or the text received on stdin.

+ termux-sms-list

    List SMS messages.

+ termux-sms-send

    Send a SMS message to the specified recipient number(s).

+ termux-storage-get

    Request a file from the system and output it to the specified file.

+ termux-telephony-call

    Call a telephony number.

+ termux-telephony-cellinfo

    Get information about all observed cell information from all radios on the device including the primary and neighboring cells.

+ termux-telephony-deviceinfo

    Get information about the telephony device.

+ termux-toast

    Show a transient popup notification.

+ termux-torch

    Toggle LED Torch on device.

+ termux-tts-engines

    Get information about the available text-to-speech engines.

+ termux-tts-speak

    Speak text with a system text-to-speech engine.

+ termux-usb

    List or access USB devices.

+ termux-vibrate

    Vibrate the device.

+ termux-volume

    Change volume of audio stream.

+ termux-wallpaper

    Change wallpaper on your device.

+ termux-wifi-connectioninfo

    Get information about the current wifi connection.

+ termux-wifi-enable

    Toggle Wi-Fi On/Off.

+ termux-wifi-scaninfo

    Get information about the last wifi scan.
