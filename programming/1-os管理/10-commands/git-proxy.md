<!--
+++
title       = "Git设置Http代理，克隆github上的代码"
description = "1. 设置Http代理"
date        = "2022-01-11"
tags        = []
categories  = ["1-os管理","10-commands"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 设置Http代理

由于信息安全策略限制，访问公司外部资源需要通过IT统一提供的代理(proxy.huawei.com)，目前已知代理仅支持HTTP协议，无法直接代理SSH协议。

```sh
git config --global http.sslVerify false  # 不进行ssl检查（因为公司上外网是通过代理，ssl是代理发的，不是github发的，git不认）

# 配置代理
git config --global http.proxy http://域账号:密码@proxy.huawei.com:8080
git config --global https.proxy https://域账号:密码@proxy.huawei.com:8080

# git config --list  # 查看设置

git clone https://github.com/darxtrix/ptop.git
```

## 2. 解决git pull/push每次都需要输入密码问题

git bash进入你的项目目录，输入： `git config --global credential.helper store`

## 3. 添加了 `--depth` 参数，如何重新拉取全部历史

实际上git fetch 专门有个参数，用来将浅克隆转换为完整克隆：

```sh
git fetch --unshallow
```

## 4. 在vscode下，查看某次提交

```sh
>gitLen: search commit
```

显示后，vscode还会提示你，查看代码的对比区别。
