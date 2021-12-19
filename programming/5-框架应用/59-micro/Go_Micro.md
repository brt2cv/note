<!--
+++
title       = "【入门】Go Micro项目开发"
description = "1. 创建Web服务; 2. 服务注册; 3. 服务发现; 4. 服务调用"
date        = "2021-12-19"
tags        = []
categories  = ["5-框架应用","59-micro"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> [csdn: Go-Micro微服务框架使用](https://blog.csdn.net/MrKorbin/article/details/110823501)

## 1. 创建Web服务

Golang本身提供了丰富的http包，并且Gin等Web框架实现一个Web服务，但是为了贴合Go-Micro框架的统一规范，所以需要通过使用Go-Micro的github.com/micro/go-micro/web包来创建一个Web服务。

### 1.1. net/http简单创建

直接通过web包创建一个服务，参数可选，也比较简单易懂，请自行Ctrl+左键查看源码。创建服务后可以直接像原生的http包一样使用。

```go
func main() {
    service := web.NewService(
        web.Name("cas"),
        web.Address(":8001"),
    )
    service.HandleFunc("/hello", func(writer http.ResponseWriter, request *http.Request) {
        // handler
    })
    service.Run()
}
```

### 1.2. 第三方Web框架

原生的http包在很多情况下处理并不是非常高效，只是提供了一些基础功能，所以Go-Micro提供集成第三方Web框架如：Gin。首先下载安装：

```sh
go get -u "github.com/gin-gonic/gin"
```

Go-Micro整合Gin示例：

```go
func main() {
    engine := gin.Default()
    engine.GET("/hello", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "msg": "hello,world",
        })
    })
    service := web.NewService(
        web.Name("cas"),
        web.Address(":8001"),
        web.Handler(engine),
    )
    service.Run()
}
```

### 1.3. 命令行调用

除了上述的方式直接指定Web服务的相关参数，我们也可以通过命令行参数启动Web服务，这样我们可以在命令行通过指定不同的服务名和端口，快速的多开同一个服务。虽然实际开发部署环境很少用这种方式，但在我们自己调试服务注册与发现时，会非常有用。
　
示例如下，只需要调用 `Init()` 方法即可：

```go
func main() {
    engine := gin.Default()
    engine.GET("/hello", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "msg": "hello,world",
        })
    })
    service := web.NewService(
        //web.Name("cas"),
        //web.Address(":80"),
        web.Handler(engine),
    )
    service.Init()
    service.Run()
}
```

启动命令：

```sh
go run main.go -server_name cas -server_address :8001
```

## 2. 服务注册

### 2.1. Consul

在安装好Consul并启动好服务后，下载Go-Micro提供的插件包go-plugins：

```sh
go get -u github.com/micro/go-plugins
```

该包包含了Consul和其他的众多插件(如：eureka等)，基本的使用方法是使用 `consul.NewRegistry()` 接口创建注册中心对象，然后将其集成到Go-Micro提供的Web服务配置中：

```go
package main

import (
    "github.com/gin-gonic/gin"
    "github.com/micro/go-micro/registry"
    "github.com/micro/go-micro/web"
    "github.com/micro/go-plugins/registry/consul"
    "net/http"
)

func main() {
    consulReg := consul.NewRegistry(registry.Addrs(":8500"))
    engine := gin.Default()
    engine.GET("/hello", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "msg": "hello,world",
        })
    })
    service := web.NewService(
        web.Name("cas"),
        web.Address(":8001"),
        web.Registry(consulReg),
        web.Handler(engine),
    )
    service.Init()
    service.Run()
}
```

## 3. 服务发现

通过Consul对象调用 `GetService("cas")` 方法拿到服务节点切片，参数为注册的服务名，所以在上文注册服务时指定的服务名很关键；

通过Go-Micro提供的selector包拿到具体的服务节点，该包提供2种常见的负载均衡算法，`RoundRobin(轮询)` 和 `Random(随机)` 。对应方法返回的是一个Next方法，Next方法调用后才返回具体的服务节点，可以自行查看源码；

```go
package main

import (
    "github.com/micro/go-micro/client/selector"
    "github.com/micro/go-micro/registry"
    "github.com/micro/go-plugins/registry/consul"
    "log"
)

func main() {
    consulReg := consul.NewRegistry(registry.Addrs(":8500"))
    service, err := consulReg.GetService("cas")
    if err != nil {
        log.Fatal("get service from consul err :",err)
    }
    node, err := selector.RoundRobin(service)()
    if err != nil {
        log.Fatal("get service node err :",err)
    }
    log.Printf("service node : %+v", node)
}
```

## 4. 服务调用

最基础的就是通过Golang官方提供的http包发起HTTP请求。直接在上文服务发现示例代码的基础上，在拿到服务节点信息后，发情API请求。

```go
url := fmt.Sprintf("http://%s/hello", node.Address)
reqBody := strings.NewReader("")
request, err := http.NewRequest(http.MethodGet, url, reqBody)
if err != nil {
    log.Fatalf("create request err : %+v",err)
}
response, err := http.DefaultClient.Do(request)
if err != nil {
    log.Fatalf("send request err : %+v",err)
}
defer response.Body.Close()
rspBody, err := ioutil.ReadAll(response.Body)
if err != nil {
    log.Fatalf("read  response body err : %+v",err)
}
log.Printf("rsp body : %+v", string(rspBody))
```

### 4.1. Go-Micro中的HTTP调用方式(推荐)

这种方式也是使用http包，但和上述Golang官方提供的不同，这种方式使用的是Go-Micro的插件包 `github.com/micro/go-plugins/client/http` 包，go-plugins包除了有http client的基本功能，还支持Selector参数，自动选取服务，并支持json、protobuf等数据格式。

上述的基础调用方式可以明显发现调用过程其实还是比较繁琐的，而这种方法流程上简化了很多，插件对一些步骤进行了封装和自动化处理，步骤主要为将注册中心放到Selector选择器中，然后基于选择器创建httpClient，通过该客户端来发起请求，调用服务。需要注意的是，插件默认认为服务调用都是通过POST请求的方式，所以指定的接口一定要为POST：

```go
package main

import (
    "context"
    "github.com/micro/go-micro/client"
    "github.com/micro/go-micro/client/selector"
    "github.com/micro/go-micro/registry"
    "github.com/micro/go-plugins/client/http"
    "github.com/micro/go-plugins/registry/consul"
    "log"
)

func main() {
    consulReg := consul.NewRegistry(registry.Addrs(":8500"))
    selector := selector.NewSelector(
        selector.Registry(consulReg),
        selector.SetStrategy(selector.RoundRobin),
    )
    httpClient := http.NewClient(
        // 选择器
        client.Selector(selector),
        // 响应格式默认格式protobuf，设置为json
        client.ContentType("application/json"),
        )
    req := map[string]string{}
    request := httpClient.NewRequest("cas", "/hello", req)
    rsp := map[string]interface{}{}
    err := httpClient.Call(context.Background(), request, &rsp)
    if err != nil {
        log.Fatalf("request err: %+v", err)
    }
    log.Printf("%+v",rsp)
}
```

其他需要注意的是服务调用这边只支持json形式传参，所以如Gin中请使用Bind()的方式获取请求参数：

```go
engine := gin.Default()
    engine.POST("/hello", func(c *gin.Context) {
        req := struct {
            Name string `json:"name"`
        }{}
        c.BindJSON(&req)
        c.JSON(http.StatusOK, gin.H{
            "msg": "hello,world",
            "name": req.Name,
        })
    })
```
