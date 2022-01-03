<!--
+++
title       = "Ubuntu系统环境及配置"
description = "1. 系统安装常见问题; 2. 常用工具集; 3. 输入法配置; 4. 第三方工具; 5. Xfce4; 6. 浏览器; 7. AMD锐龙CPU在Linux环境下死机"
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

## 1. 系统安装常见问题

> [UEFI如何引导](https://help.ubuntu.com/community/UEFI#Set_up_the_BIOS_in_EFI_or_Legacy_mode)
>
> [Windows如何将系统刷USB引导](https://ubuntu.com/tutorials/create-a-usb-stick-on-windows)
>
> [ubuntu如何将系统刷USB引导](https://ubuntu.com/tutorials/create-a-usb-stick-on-ubuntu)
>
> [增强工具mkusb：在Linux系统上创建USB引导盘](https://help.ubuntu.com/community/mkusb)

## 2. 常用工具集

### 2.1. 开发工具

```
gcc g++ gdb cgdb tcc
cmake
python3-dev python3-pip python3-venv  # ipython3
sqlite3  # libsqlite3-dev
libssl-dev(openssl)
libev-dev(libev)

vim nano mousepad
tigervnc/tightvncserver xtightvncviewer

libwxgtk3.0-dev
    libwxbase3.0-dev
    libwxbase3.0-0v5
    libwxgtk3.0-0v5

libzmq5 libzmq3-dev(libczmq3  libczmq-dev)
python3-zmq

qtbase5-dev(qt5-default)
qt5-assistant
qtcreator ~ 300MB
qttools5-dev-tools ~ 2MB
```

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200606181054448-1336193010.jpg) <!-- apt用法详解/apt用法详解0.jpg -->

### 2.2. 系统辅助

```
procps busybox p7zip
tmux colordiff ack
guake tilda
vnc4server
dos2unix

flameshot  # 截图工具
parcellite  # 剪切板工具
cmus  # 音乐播放器
pango
pngquant  # 图像压缩
ffmpeg  # 视频处理

qupzilla
w3m-img

xfce4
lxde-core
```

## 3. 输入法配置
> [博客园: Fcitx输入法配置](https://www.cnblogs.com/brt2/p/13236926.html)

## 4. 第三方工具

如果官网下载工具比较慢，可以参考这里：[http://downloads.yaolinux.org/sources/](http://downloads.yaolinux.org/sources/)

> [sublime_text_3_build_3211_x64.tar.bz2](http://downloads.yaolinux.org/sources/sublime_text_3_build_3211_x64.tar.bz2)
>
> [code_1.52.1-1608136922_amd64.deb](http://downloads.yaolinux.org/sources/code_1.52.1-1608136922_amd64.deb)
>
> [google-chrome-stable_current_amd64.deb](http://downloads.yaolinux.org/sources/google-chrome-stable_current_amd64.deb)
>
> [VirtualBox-6.1.16-140961-Linux_amd64.run](http://downloads.yaolinux.org/sources/VirtualBox-6.1.16-140961-Linux_amd64.run)

### 4.1. 其他

## 5. Xfce4

### 5.1. 系统快捷键工具（键盘工具）

配置文件路径： `~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml` .

自定义的快捷键配置：

+ ctrl+shif+H: `dbus-send --session --dest=tophats.desktool --type=method_call / local.Snipper.take_snapshot`
+ ctrl+shift+W: `dbus-send --session --dest=tophats.desktool --type=method_call / local.Snipper.translate`
+ super+W: `xfce4-appfinder`
+ ~~ctrl+shift+A: `xfce4-screenshooter -rc`  # xfce4默认的截图工具~~
+ ctrl+shift+A: `flameshot gui`  # 推荐使用火焰截图
+ alt+空格: `wmctrl-launch.sh 'Mozilla Firefox' firefox`
+ alt+2: `wmctrl-launch.sh 'Sublime Text' subl`
+ alt+4: `wmctrl-launch.sh 文件管理器 thunar`
+ alt+5: `wmctrl-launch.sh 'Terminal' xfce4-terminal`
+ alt+6: `wmctrl-launch.sh 'Visual Studio Code' code`

## 6. 浏览器

### 6.1. Firefox的搜索引擎更新
> [正确给Firefox添加自定义搜索引擎的三种姿势](https://www.jianshu.com/p/3408144ea99c)

用现成的，[mycroftproject](https://mycroftproject.com/)上面去搜索。大多数搜索引擎都是支持的，比如：知乎、dogedoge什么的，上面都已经备好了。

### 6.2. 搜索拐杖

+ [ ] CSDN: https://so.csdn.net/so/search/s.do?q=%s
+ [x] 多吉: https://www.dogedoge.com/results?q=%s
+ [x] 知乎: https://www.zhihu.com/search?type=content&q=%s
+ [x] 微信: https://weixin.sogou.com/weixin?type=2&query=%s

## 7. AMD锐龙CPU在Linux环境下死机
> [华为论坛: MagickBook锐龙版，在Linux下卡死的原因以及临时解决办法](https://club.huawei.com/thread-18992322-1-2.html)
>
> [ubuntu: 添加/编译KernelBootParameters](https://wiki.ubuntu.com/Kernel/KernelBootParameters)

1. 编辑grub文件，增加参数：

    ```sh
    sudo mousepad /etc/default/grub
    ```

1. 在kernel parameter 里加入 "idle=nomwait"，最后的结果为：

    ```
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash idle=nomwait"
    ```

    > In the editor window, use the arrow keys to move the cursor to the line beginning with "GRUB_CMDLINE_LINUX_DEFAULT" then edit that line, adding your parameter(s) to the text inside the double-quotes after the words "quiet splash". (Be sure to add a SPACE after "splash" before adding your new parameter.) Click the Save button, then close the editor window.

1. 更新grub: `sudo update-grub`
1. 重启系统
