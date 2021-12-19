<!--
+++
title       = ""
description = "1. go get 变了"
date        = "2021-12-19"
tags        = []
categories  = ["3-syntax","37-golang"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. go get 变了

一直以来，`go get` 用于下载并安装 Go 包、命令等，而 `go install` 在 module 时代几乎很少使用，在 GOPATH 年代，`go install` 用来编译安装本地项目。

自 1.16 起，官方说，不应该 `go get` 下载安装命令（即可执行程序），不过只是这么说，却依然可以使用。

但 Go1.17 开始，如果使用 go get 安装命令，会警告：

```sh
go get: installing executables with 'go get' in module mode is deprecated.
        Use 'go install pkg@version' instead.
        For more information, see https://golang.org/doc/go-get-install-deprecation
        or run 'go help get' or 'go help install'.
```

也就是说，`go get` 只用来下载普通的包，安装可执行程序，应该使用 `go install` 。

```sh
$ go install github.com/github/hub
```

这会将 hub 命令安装到 `$GOBIN` 下。
