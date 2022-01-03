<!--
+++
title       = "Web服务实现方案对比: RPC、SOAP、gRPC、REST"
description = "1. RPC; 2. SOAP（不推荐）; 3. gRPC; 4. RESTful"
date        = "2022-01-03"
tags        = []
categories  = ["5-框架应用","51-web"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> [知乎: 浅谈 RPC 和 REST: SOAP, gRPC, REST](https://zhuanlan.zhihu.com/p/60352360)
>
> [三种主流的Web服务实现方案（REST+SOAP+XML-RPC）简述及比较](https://www.cnblogs.com/lanxuezaipiao/archive/2013/05/11/3072436.html)
>
> [StackOverflow: XML-RPC vs REST](https://stackoverflow.com/questions/11710507/xml-rpc-vs-rest)

目前知道的三种主流的Web服务实现方案为：

+ REST：表象化状态转变 (软件架构风格）
+ SOAP：简单对象访问协议
+ XML-RPC：远程过程调用协议

## 1. RPC

**XML-RPC**：一个远程过程调用（remote procedure call，RPC) 的分布式计算协议，通过XML将调用函数封装，并使用HTTP协议作为传送机制。后来在新的功能不断被引入下，这个标准慢慢演变成为今日的SOAP协定。XML-RPC协定是已登记的专利项目。XML-RPC透过向装置了这个协定的服务器发出HTTP请求。发出请求的用户端一般都是需要向远端系统要求呼叫的软件。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200908105010688-357271405.jpg) <!-- web架构/web架构-0.jpg -->

RPC的目的，是让用户在本地调用远程的方法。<font color=#FF0000>对用户来说这个调用是透明的，并不需要关心这个调用的方法是部署哪里。</font>

### 1.1. 通讯原理

**怎么实现远程调用像本地调用一样呢？**RPC 模式分为三层，RPCRuntime 负责最底层的网络传输，Stub 处理客户端和服务端约定好的语法、语义的封装和解封装，这些调用远程的细节都被这两层搞定了，用户和服务器这层就只要负责处理业务逻辑，调用本地 Stub 就可以调用远程。

1. 远程服务之间建立通讯协议
2. 寻址：服务器（如主机或IP地址）以及特定的端口，方法的名称名称是什么
3. 通过序列化和反序列化进行数据传递
4. 将传递过来的数据通过java反射原理定位接口方法和参数
5. 暴露服务：用map将寻址的信息暴露给远方服务（提供一个endpoint URI或者一个前端展示页面）
6. 多线程并发请求业务

### 1.2. 设计模式：ServerProxy

使用代理模式解决，生成一个代理对象，而这个代理对象的内部，就是通过httpClient来实现RPC远程过程调用的。以此方式来屏蔽对http的操作，而外观上看上去就像是本地功能调用类似。

### 1.3. 多种实现方案

RPC是一种模式，http也是RPC实现的一种方式。

论复杂度，dubbo/hessian用起来是超级简单的。

1. 调用简单，真正提供了类似于调用本地方法一样调用接口的功能 。
1. 参数返回值简单明了 参数和返回值都是直接定义在jar包里的，不需要二次解析。
1. 轻量，没有多余的信息。
1. 便于管理，基于dubbo的注册中心。

所以，常常有人抱怨，XML-RPC的效率太低，XML书写或转换都太复杂，性能不行。但实际上，单就性能而论，有JSON-RPC，它比XML-RPC轻。且RPC可以直接使用socket通讯而不是http，性能反而更优。

## 2. SOAP（不推荐）

1998 年 XML 1.0 发布，被 W3C (World Wide Web Consortium) 推荐为标准的描述语言。同年，SOAP 也完成了初版设计。SOAP (Simple Object Access Protocol) 简单对象访问协议，在 1998 年因为微软 XML-RPC 的原因，还没有公之于众，一直到 2003 年 6 月的 SOAP 1.2 版本发布，才被 W3C 推荐。

SOAP 是基于文本 XML 的 一种应用协议。随着当年 SOA (Service Oriented Architecture) 的走红，提倡将一个大的软件拆分成多个不同的小的服务，SOAP 在服务之间的远程调用大有用武之地。

### 2.1. 协议约定

SOAP 的协议约定用的是 WSDL (Web Service Description Language) ，这是一种 Web 服务描述语言，在服务的客户端和服务端开发者不用面对面交流，只要用的是 WSDL 定义的格式，客户端知道了 WSDL 文件，就知道怎么去封装请求，调用服务。

```xml
<wsdl:types>
 <xsd:schema targetNamespace="http://www.task.io/management">
  <xsd:complexType name="task">
   <xsd:element name="name" type="xsd:string"></xsd:element>
  <xsd:element name="type" type="xsd:string"></xsd:element>
   <xsd:element name="priority" type="xsd:int"></xsd:element>
  </xsd:complexType>
 </xsd:schema>
</wsdl:types>
```

这只是一个对象类型的定义，一套完整的 WSDL 还会有消息结构体的定义，然后将信息绑定到 SOAP 请求的 body 里，然后编写成 service，具体这里就不展开了。

WSDL 有可以自动生成 Stub 的工具，客户端可以直接通过自动生成的 Stub 去调用服务端。

### 2.2. 传输协议

SOAP 是用 HTTP 进行传输的，有个信封的概念，信息就像是一封信，有 Header 和 Body，SOAP 的请求和回复都放在信封里，进行传递。

```xml
POST /addTask HTTP/1.1
Host: www.task.io
Content-Type: application/soap+xml; charset=utf-8
Content-Length: nnn

<?xml version="1.0"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2001/12/soap-envelope"
soap:encodingStyle="http://www.w3.org/2001/12/soap-encoding">
    <soap:Header>
        <m:Trans xmlns:m="http://www.w3schools.com/transaction/"
          soap:mustUnderstand="1">1234
        </m:Trans>
    </soap:Header>
    <soap:Body xmlns:m="http://www.task.io/management">
        <m:addTask>
            <task>
                <name>Write a blog article</name>
                <type>Writing</type>
                <priority>1</priority>
            </task>
        </m:addTask>
    </soap:Body>
</soap:Envelope>
```
### 2.3. 服务发现

SOAP 的服务发现用的是 UDDI（Universal Description, Discovery, Integration) 统一描述发现集成，相当于一个注册中心，服务提供方将 WSDL 文件发布到注册中心，使用方可以到这个注册中心查找。

---

SOAP 在当时也是风靡一时，主要有这些优点：

1. 协议约定面向对象，更贴合业务逻辑的应用场景。
1. 服务定义清楚，在 WSDL 能清楚了解到所有服务。
1. 格式不用完全一致，比如上面那个请求里 name, type, priority 的顺序不用完全跟服务端的 WSDL 对应。版本更新上，客户端可以先增加新的项，服务端可以之后再更新。
1. 使用 WS Security 所为安全标准，安全性较高。
1. SOAP 是 **面向动作** 的，支持比较复杂的动作，比如 `ADD` ，`MINUS`

当然，现在新的软件开发，用到 SOAP 的越来越少了，可见 SOAP 也有很多不足：

1. 远程调用速度慢，效率低。

    因为以 XML 作为数据格式，除了主要传输的数据之外，有较多冗余用在定义格式上，占用带宽，并且对于 XML 的序列化和解析的速度也比较慢。

2. 协议约定 WSDL 比较复杂，要经过好几个环节才能搞定。

3. SOAP 多数用的是POST，通常是 POST 加上动作，比如 POST CreateTask, POST DeleteTask。而多数用 POST 的原因是 GET 请求最大长度限制较多，而 SOAP 需要把数据加上 SOAP 标准化的格式，请求数据比较大，超过 GET 的限制。

4. SOAP 的业务状态大多是维护在服务端的，比如说分页，服务端会记住用户在哪个页面上，在企业软件中，客户端和服务端比较平衡的情况下是没有问题的，但是在失衡情况下，比如说客户端请求大大超过服务端时，服务端维护所有状态的成本太高，影响并发量。

可以说，SOAP是基于 `XML-RPC` 进行的二次封装。所以，XML-RPC 的缺点全部被SOAP继承了（且无法修改），反而，本意的优势（简化服务端开发所做的封装），随着技术的更新，越来越被新的技术替代掉了。

## 3. gRPC

像 SOAP 这类基于文本类的 RPC 框架，速度上都是有先天不足的。为了有比较好的性能，还是得用二进制的方式进行远程调用。gRPC 是现在最流行的二进制 RPC 框架之一。2015 年由 Google 开源，在发布后迅速得到广泛关注。

### 3.1. 协议约定

gRPC 的协议是 Protocol Buffers，<font color=#FF0000>是一种压缩率极高的序列化协议，效率甩 XML，JSON 好几条街。</font>Google 在 2008 年开源了 Protocol Buffers，支持多种编程语言，所以 gRPC 支持客户端与服务端可以用不同语言实现。

### 3.2. 传输协议

在 JAVA 技术栈中，gRPC 的数据传输用的是 Netty Channel（<font color=#FF0000>注意不是http</font>）， <font color=#FF0000>Netty 是一个高效的基于异步 IO 的网络传输架构。</font>Netty Channel 中，每个 gRPC 请求封装成 HTTP 2.0 的 Stream。

基于 HTTP 2.0 是 gRPC 一个很大的优势，可以定义四种不同的服务方法：单向 RPC，客户端流式 RPC，服务端流式 RPC，双向流式 RPC。

### 3.3. 服务发现

<font color=#FF0000>gRPC 本身没有提供服务发现的机制，需要通过其他组件。</font>一个比较高性能的服务发现和负载均衡器是 Envoy，可以灵活配置转发规则，有兴趣的可以去了解下。

## 4. RESTful

<font color=#FF0000>gRPC 更多的是用在**微服务集群内部**，服务与服务之间的通信，服务与客户端之间的通信，REST 可以说是现在的主流。</font>

**REST**：表征状态转移（Representational State Transfer），采用Web服务使用标准的 HTTP 方法 (GET/PUT/POST/DELETE) 将所有 Web 系统的服务抽象为资源，REST从资源的角度来观察整个网络，分布在各处的资源由URI确定，而客户端的应用通过URI来获取资源的表征。

Http协议所抽象的get,post,put,delete就好比数据库中最基本的增删改查，而互联网上的各种资源就好比数据库中的记录（可能这么比喻不是很好），对于各种资源的操作最后总是能抽象成为这四种基本操作，在定义了定位资源的规则以后，对于资源的操作通过标准的Http协议就可以实现，开发者也会受益于这种轻量级的协议。

REST是一种软件架构风格而非协议也非规范，是一种针对网络应用的开发方式，可以降低开发的复杂性，提高系统的可伸缩性。

### 4.1. 常见的设计错误

#### 4.1.1. 最常见的一种设计错误，就是URI包含动词

因为"资源"表示一种实体，所以应该是名词，URI不应该有动词，动词应该放在HTTP协议中。

最常见的一种设计错误，就是URI包含动词。因为"资源"表示一种实体，所以应该是名词，URI不应该有动词，动词应该放在HTTP协议中。

举例来说，某个URI是/posts/show/1，其中show是动词，这个URI就设计错了，正确的写法应该是/posts/1，然后用GET方法表示show。

如果某些动作是HTTP动词表示不了的，你就应该把动作做成一种资源。比如网上汇款，从账户1向账户2汇款500元，错误的URI是：

```
POST /accounts/1/transfer/500/to/2
```

正确的写法是把动词transfer改成名词transaction，资源不能是动词，但是可以是一种服务：

```
POST /transaction HTTP/1.1
Host: 127.0.0.1
from=1&to=2&amount=500.00
```

#### 4.1.2. 另一个设计误区，就是在URI中加入版本号

```
http://www.example.com/app/1.0/foo
http://www.example.com/app/1.1/foo
http://www.example.com/app/2.0/foo
```

因为不同的版本，可以理解成同一种资源的不同表现形式，所以应该采用同一个URI。版本号可以在HTTP请求头信息的Accept字段中进行区分：

```
Accept: vnd.example-com.foo+json; version=1.0
Accept: vnd.example-com.foo+json; version=1.1
Accept: vnd.example-com.foo+json; version=2.0
```

#### 4.1.3. 避免多级 URL

常见的情况是，资源需要多级分类，因此很容易写出多级的 URL，比如获取某个作者的某一类文章。

```
GET /authors/12/categories/2
```

这种 URL 不利于扩展，语义也不明确，往往要想一会，才能明白含义。更好的做法是，除了第一级，其他级别都用查询字符串表达。

```
GET /authors/12?categories=2
```

下面是另一个例子，查询已发布的文章。你可能会设计成下面的 URL。

```
GET /articles/published
```

查询字符串的写法明显更好。

```
GET /articles?published=true
```

### 4.2. 传输协议

REST 是基于 HTTP 的文本类传输方式，与 SOAP 的 XML 相比，REST 用的是 Json，格式更加简单易懂。

### 4.3. 服务发现

RESTful API 的服务发现有很多组件，比如说 Eureka，可以作为服务注册中心，也能用来做负载均衡和容错。
