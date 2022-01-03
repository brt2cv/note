<!--
+++
title       = "C++包管理器"
description = "1. vcpkg; 2. conan"
date        = "2022-01-03"
tags        = []
categories  = ["3-syntax","35-cpp","tools"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. vcpkg

### 1.1. 安装

+ Windows:

    需要 visual studio IDE 2015+，没有的话就不用指望了。

+ Linux:

    ```sh
    git clone git@gitee.com:mirrors/vcpkg.git
    # git clone https://github.com/Microsoft/vcpkg.git

    cd vcpkg
    ./bootstrap-vcpkg.sh

    ./vcpkg integrate install  # 安装
    ./vcpkg integrate remove   # 移除安装

    sudo ln -s $pwd/vcpkg /usr/bin
    ```

### 1.2. vcpkg用法

```
vcpkg list //这个命令可以列出已经安装的三方库
vcpkg search //这个命令可以列出vcpkg支持哪些三方库
vcpkg help triplet //指定编译某种架构的程序库,如不指定可使用如下命令查看vcpkg总共支持多少种架构
vcpkg install ffmpeg[gpl]:x64-linux //指定安装某一架构的开源库，如Linux 64位
```

## 2. conan
> [homepage: doc](https://docs.conan.io/)

在这包管理的基础上，出现像 `conan/vcpkg/buckaroo` 这样比较优秀的现代化的包管理系统。本文将着重介绍conan的基本概念和主要使用方法。

基于python的conanfile.py的配置文件有及其强大的扩展性，可以很好解决c\c++项目中的二进制管理问题。

```sh
$ pip install conan
```
