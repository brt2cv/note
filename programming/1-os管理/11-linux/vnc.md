<!--
+++
title       = "VNC-Server安装配置详解"
description = "1. 品类; 2. 安装tigervnc; 3. x11vnc"
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

## 1. 品类

* tightvnc（已于2009年停止更新）
* tigervnc
* x11vnc

## 2. 安装tigervnc

即vnc4server。

坑：

* Qt运行报错（xkb...）
* QtCreator无法使用

## 3. x11vnc

1. 安装

    `sudo apt-get install x11vnc`

2. 配置vnc密码

    `x11vnc -storepasswd`

    默认生成到 `$HOME/.vnc/passwd` 。

3. 启动vnc服务

    `x11vnc -forever -shared -rfbauth ~/.vnc/passwd`

### 3.1. 运行报错 & 解决

以上方法在Ubuntu18.04会遇到报错：

```
** If NO ONE is logged into an X session yet, but there is a greeter login
   program like "gdm", "kdm", "xdm", or "dtlogin" running, you will need
   to find and use the raw display manager MIT-MAGIC-COOKIE file.
   Some examples for various display managers:

     gdm:     -auth /var/gdm/:0.Xauth
              -auth /var/lib/gdm/:0.Xauth
     kdm:     -auth /var/lib/kdm/A:0-crWk72
              -auth /var/run/xauth/A:0-crWk72
     xdm:     -auth /var/lib/xdm/authdir/authfiles/A:0-XQvaJk
     dtlogin: -auth /var/dt/A:0-UgaaXa

   Sometimes the command "ps wwwwaux | grep auth" can reveal the file location.

   Starting with x11vnc 0.9.9 you can have it try to guess by using:

              -auth guess

   (see also the x11vnc -findauth option.)

   Only root will have read permission for the file, and so x11vnc must be run
   as root (or copy it).  The random characters in the filenames will of course
   change and the directory the cookie file resides in is system dependent.

See also: http://www.karlrunge.com/x11vnc/faq.html
```

原因大概是因为，ubuntu18以后默认不再使用lightdm作为desktop管理器，这需要x11vnc指定配置dm。

解决方法：启动lightdm: `sudo lightdm &` 。

然后执行： `x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /home/liang/.vnc/passwd -rfbport 5900 -shared`

选项说明：

* -forever, 在客户端断开连接时保持服务，而不是关闭
* -loop, 在服务终止时进入循环，并自动重启服务
* -timeout, 在timeout时间内允许客户端连接，否则将关闭服务
* -capslock
* -repeat
* -bg

### 3.2. 系统默认启动x11vnc

除非配置了默认启动 `lightdm` ，否则x11vnc无法自启（环境依赖）。

1. 生成秘钥： `x11vnc -storepasswd`
2. 启动配置： `sudo vi /lib/systemd/system/x11vnc.service`

    ```
    [Unit]
    Description=Start x11vnc at startup.
    After=multi-user.target

    [Service]
    Type=simple
    ExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /home/liang/.vnc/passwd -rfbport 5900 -shared

    [Install]
    WantedBy=multi-user.target
    ```

3. 启动lightdm： `sudo lightdm &`
4. 添加到服务中：

    ```
    sudo systemctl daemon-reload
    sudo systemctl enable x11vnc.service
    sudo systemctl start x11vnc.service
    ```

