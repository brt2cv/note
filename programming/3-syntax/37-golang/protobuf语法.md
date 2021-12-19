<!--
+++
title       = "【入门】Protobuf语法与编译"
description = "1. protobuf安装; 2. protoc编译指令; 3. 安装gRPC; 4. 安装go-micro"
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

## 1. protobuf安装

[https://github.com/protocolbuffers/protobuf/releases](https://github.com/protocolbuffers/protobuf/releases)

### 1.1. 安装protobuf库文件

protoc是编译器，protoc-gen-go只是一个编译器的Go语音插件。protobuf的其他功能比如marshal、unmarshal等功能还需要由protobuf库提供：

```sh
go get github.com/golang/protobuf/proto
```

### 1.2. 安装protoc-gen-go库

`protoc-gen-go` 是go版本的Protobuf编译器插件。

```sh
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct

# go get google.golang.org/protobuf/cmd/protoc-gen-go
go get github.com/golang/protobuf/protoc-gen-go
```

前两步骤可以合二为一：

```sh
go get github.com/micro/protobuf/{proto,protoc-gen-go}
```

### 1.3. 安装protoc-gen-micro库

```sh
go get github.com/micro/micro/v3/cmd/protoc-gen-micro
```

## 2. protoc编译指令

```sh
protoc --proto_path=. --go_out=plugins=grpc,paths=source_relative:. xxxx.proto
```

+ `--proto_path` 或者 `-I` 参数用以指定所编译源码（包括直接编译的和被导入的 proto 文件）的搜索路径
+ `--go_out` 参数之间用逗号隔开，最后用冒号来指定代码目录架构的生成位置 ，`--go_out=plugins=grpc` 参数来生成gRPC相关代码，如果不加 `plugins=grpc` ，就只生成message数据

    eg: `--go_out=plugins=grpc,paths=import:` 

    `paths` 参数，有两个选项:
    1. `import`: (默认)，代表按照生成的go代码的包的全路径去创建目录层级
    2. `source_relative`: 代表按照proto源文件的目录层级去创建go代码的目录层级，如果目录已存在则不用创建

protoc是通过插件机制实现对不同语言的支持。比如 `--xxx_out` 参数，那么protoc将首先查询是否有内置的xxx插件，如果没有内置的xxx插件那么将继续查询当前系统中是否存在 `protoc-gen-xxx` 命名的可执行程序。

例如，生成c++代码:

```sh
protoc -I . --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` --cpp_out=. *.proto
```

## 3. 安装gRPC

```sh
# go get google.golang.org/grpc
go get github.com/grpc/grpc-go
```

## 4. 安装go-micro

~~go get github.com/micro/go-micro~~

```sh
go get github.com/micro/micro/v3
```
