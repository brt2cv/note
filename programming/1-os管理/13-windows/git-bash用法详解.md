<!--
+++
title       = "git-bash用法详解"
description = "1. 开启Windows的 sshd 服务; 2. git log: 中文乱码"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","13-windows"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 开启Windows的 sshd 服务

```sh
# 必须生成在指定路径
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ED25519_key

# 或者
ssh-keygen -A

/usr/bin/sshd  # 不能直接 sshd 命令，而必须全路径调用
```

此时服务已经开启了，如果你的Windows用户已经配置了password，那么就可以远程密码登录了：

`ssh admin@192.168.0.76`

### 1.1. ssh 高级配置

但如果你当前登录的Windows账号没有设置密码，那么会ssh连接会要求你输入密码，额……

其实，配置选项重点就这么几项：

```
PermitRootLogin without-password
StrictModes no  # 启用严格模式
....
PasswordAuthentication yes
PermitEmptyPasswords yes
```

#### 1.1.1. 生成秘钥

所以，先从生成秘钥开始：

```sh
ssh-keygen [-t rsa] [-b 4096] [-C "your_email@example.com"] [-f path_private_key]
```

这将创建以所提供的电子邮件地址为标签的新 SSH 密钥，如下所示：

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDX51IW2PhMfSHjGNwJgwCnykBMhbgeSEq7SUM27a/
...
6cislV1UsiA2T3tDykWZ4LvdegTGW7cs4yX5qS1vAv4YhqOeS8Sea60BXj21L9/VpYsqkUim99me0VZ
F3aaCiLG+OIuyar+4tmCNBsf8YLEWFhq84ALMtv8TU0eoZQ== brt2@qq.com
```

#### 1.1.2. 添加或更改密码

使用 SSH 密钥时，如果有人获得您计算机的访问权限，他们也可以使用该密钥访问每个系统。 要添加额外的安全层，可以向 SSH 密钥添加密码。 您可以使用 ssh-agent 安全地保存密码，从而不必重新输入。

```
> Enter passphrase (empty for no passphrase): [Type a passphrase]
> Enter same passphrase again: [Type passphrase again]
```

注意：此密码并非ssh连接时的登录密码，而是为保护 ssh秘钥 的密码。

如果生成key时没有设定密码，或者需要修改key的密码：

```sh
$ ssh-keygen -p
# Start the SSH key creation process
> Enter file in which the key is (/Users/you/.ssh/id_rsa): [Hit enter]
> Key has comment '/Users/you/.ssh/id_rsa'
> Enter new passphrase (empty for no passphrase): [Type new passphrase]
> Enter same passphrase again: [One more time for luck]
> Your identification has been saved with the new passphrase.
```

如果您的密钥已有密码，系统将提示您输入该密码，然后才能更改为新密码。

#### 1.1.3. 分发公钥

通过分发的形式，可以代替 (scp + 手动导入authorized_keys) 的过程：

`ssh-copy-id -i ~/.ssh/id_rsa.pub target@192.168.0.xxx`

#### 1.1.4. 允许以root身份ssh连接

配置文件 `sshd_config` 中，改写： `PermitRootLogin without-password` ，可选项：

* yes: 允许root用户以任何认证方式登录，也就是不限制使用password认证
* without-password: 限制密码认证，即只能通过公钥认证方式登录root账号
* no

#### 1.1.5. 允许密码认证

`PasswordAuthentication yes`

#### 1.1.6. 免密登录

```
PermitEmptyPasswords yes
StrictModes no
```

> StrictModes no #修改为no,默认为yes.如果不修改用key登陆是出现server refused our key(如果StrictModes为yes必需保证存放公钥的文件夹的拥有与登陆用户名是相同的.
“StrictModes”设置ssh在接收登录请求之前是否检查用户家目录和rhosts文件的权限和所有权。这通常是必要的，因为新手经常会把自己的目录和文件设成任何人都有写权限。)
（来源http://matt-u.iteye.com/blog/851158）

## 2. git log: 中文乱码

设置git gui的界面编码：

```
git config --global gui.encoding utf-8
```

设置 commit log 提交时使用 utf-8 编码，可避免服务器上乱码，同时与linux上的提交保持一致：

```
git config --global i18n.commitencoding utf-8
```

使得在 $ git log 时将 utf-8 编码转换成 gbk 编码，解决Msys bash中git log 乱码：

```
git config --global i18n.logoutputencoding gbk
```

使得 git log 可以正常显示中文（配合i18n.logoutputencoding = gbk)，在 /etc/profile 中添加：

```
export LESSCHARSET=utf-8
```

不过，此方法无法解决ping等Windows默认命令的输出字符集（中文乱码）。
