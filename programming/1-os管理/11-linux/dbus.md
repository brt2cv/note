<!--
+++
title       = "D-BUS基础介绍"
description = "1. What is D-Bus?; 2. Why is D-Bus?; 3. D-BUS Concepts（核心概念）; 4. Tools; 5. 协议浅析; 6. How to use（原理）"
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

> [homepage](https://dbus.freedesktop.org/doc/dbus-tutorial.html)

## 1. What is D-Bus?

> D-Bus is a system for interprocess communication (IPC). Architecturally, it has several layers.

Dbus是实质上一个<font color=#FF0000>适用于桌面应用</font>的进程间的通讯机制，即所谓的<font color=#FF0000>IPC机制——适合在同一台机器，不适合于Internet</font>的IPC机制。

+ libdbus: 运行库，或者称之为协议的实现。
+ message bus daemon executable: 后台服务进程
+ bindings: 客户端绑定，例如 `libdbus-glib` & `libdbus-qt` & `dbus-python`...

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200830183155480-2050891710.jpg) <!-- dbus/dbus-2.jpg -->

> <font color=#FF0000>libdbus only supports one-to-one connections</font>, just like a raw network socket. However, rather than sending byte streams over the connection, you send messages. Messages have a header identifying the kind of message, and a body containing a data payload. libdbus also abstracts the exact transport used (sockets vs. whatever else), and handles details such as authentication.
>
> The message bus daemon forms the hub of a wheel. Each spoke of the wheel is a one-to-one connection to an application using libdbus. An application sends a message to the bus daemon over its spoke, and the bus daemon forwards the message to other connected applications as appropriate. <font color=#FF0000>Think of the daemon as a router.</font>
>
> The bus daemon has multiple instances on a typical computer. The first instance is a machine-global singleton（<font color=#FF0000>SystemBus</font>）, that is, a system daemon similar to sendmail or Apache. This instance has heavy security restrictions on what messages it will accept, and is used for systemwide communication. The other instances are created one per user login session（<font color=#FF0000>SessionBus</font>）. These instances allow applications in the user's session to communicate with one another.
The systemwide and per-user daemons are separate. Normal within-session IPC does not involve the systemwide message bus process and vice versa.

![](https://dbus.freedesktop.org/doc/diagram.svg)

以下内容取自 [linuxjournal.com](https://www.linuxjournal.com/article/7744)，概括了D-Bus的功能：

> D-BUS 的直接目标，就是代替（或者说是统一）GNOME中的 `CORBA` 与 KDE中的 `DCOP` 。具体包括以下层面的功能：
>
> 1. 作为IPC，利用 `UNIX domain sockets` 传输数据
> 2. 作为系统组件，传递信号 & 触发事件，例如蓝牙Daemon可以把蓝牙耳机的按钮广播给Player等多个软件。
> 3. D-BUS implements a remote object system, letting one application request services and invoke methods from a different object—think CORBA without the complications.

为此，D-BUS首先实现了一整套数据通讯协议。

> First, the basic unit of IPC in D-BUS <font color=#FF0000>is a message, not a byte stream</font>. In this manner, D-BUS breaks up IPC into discrete messages, complete <font color=#FF0000>with headers (metadata) and a payload (the data)</font>. The message format is binary, typed, fully aligned and simple. It is an inherent part of the wire protocol. This approach contrasts with other IPC mechanisms where the lingua franca is a random stream of bytes, not a discrete message.

## 2. Why is D-Bus?

Dbus提供了一个**低时延、低消耗**的IPC通讯，因为它采用了二进制的数据交换协议，不需要转换成文本化的数据进行交换。

典型的桌面都会有多个应用程序在运行，而且，它们经常需要彼此进行通信。DCOP 是一个用于 KDE 的 解决方案，但是它依赖于 Qt，所以不能用于其他桌面环境之中。类似的，Bonobo 是一个用于 GNOME 的 解决方案，但是非常笨重，因为它是基于 CORBA 的。它还依赖于 GObject，所以也不能用于 GNOME 之外。 D-BUS 的目标是将 DCOP 和 Bonobo 替换为简单的 IPC，并集成这两种桌面环境。由于尽可能地减少了 D-BUS 所需的依赖，所以其他可能会使用 D-BUS 的应用程序不用担心引入过多依赖。

> There are many, many technologies in the world that have "Inter-process communication" or "networking" in their stated purpose: [CORBA](http://www.omg.org/), [DCE](http://www.opengroup.org/dce/), [DCOM](http://www.microsoft.com/com/), [DCOP](http://developer.kde.org/documentation/library/kdeqt/dcop.html), [XML-RPC](http://www.xmlrpc.com/), [SOAP](http://www.w3.org/TR/SOAP/), [MBUS](http://www.mbus.org/), [Internet Communications Engine (ICE)](http://www.zeroc.com/ice.html), and probably hundreds more. Each of these is tailored for particular kinds of application. D-Bus is designed for two specific cases:
>
> 1. Communication between desktop applications in the same desktop session; to allow integration of the desktop session as a whole, and address issues of process lifecycle (when do desktop components start and stop running).
>
> 2. Communication between the desktop session and the operating system, where the operating system would typically include the kernel and any system daemons or processes.

D-Bus may happen to be useful for purposes other than the one it was designed for. Its general properties that distinguish it from other forms of IPC are:
Binary protocol designed to be used <font color=#FF0000>asynchronously</font> (similar in spirit to the X Window System protocol).

1. Stateful, reliable connections held open over time.
1. The message bus is a <font color=#FF0000>daemon</font>, not a "swarm" or distributed architecture.
1. Many implementation and deployment issues are specified rather than left ambiguous/configurable/pluggable.
1. Semantics are similar to the existing DCOP system, allowing KDE to adopt it more easily.
1. Security features to support the systemwide mode of the message bus.

### 2.1. 思考

1. 对于Message bus，作为守护进程，能否称之为MOM中间件？不能，但为什么？众所周知，DBus源于CORBA，这个问题可以引申为：ORB与RPC或是MOM之间的本质区别是什么？毕竟这几类产品从外观上（作用上）看都太相似了。

    答：注意，<font color=#FF0000>daemon并不包括消息队列</font>——它只是实现了消息的转发——这是Message Dispatcher做的事儿，但这个过程中并没有对消息排队、存储。它只是在收到消息的第一时间保证消息被作为广播，或是路由到正确的进程上去。

2. 类似router运行的daemon，在底层上是否就是一个broker？

    答：从其结构图上就能看出，daemon包含了一个Message Dispatcher，这个就是实现消息转发的**router**。

3. 如果Dbus的机制没有过多的依赖，且低延时、高效率，为何仅作为desktop的IPC？——<font color=#FF0000>它的底层用的是UNIX Domain Socket</font>，那换成TCP/UDP不就可以联通Internet了？

    答：实际上DBus底层的通讯实现的方式由多种，<font color=#FF0000>包括了UDS或是TCP/UDP</font>，但它没有将通讯拓展到Internet，这只能说明网络间的通讯还存在着某个层面的复杂度——当然这个问题有待深究。

4. SystemBus是否可以在终端中使用？如果是，SessionBus的区分仅仅是为了隔离不同Session传递的消息吗？

    答：是的，Debian系统默认会运行 `dbus-daemon --system` ，即使系统没有安装桌面环境——说明SystemBus与桌面是没有关系的，它只是完成通用的系统层面的消息传递。所以，用户完全可以在终端下创建和调用SystemBus对象并进行操作。

## 3. D-BUS Concepts（核心概念）

消息由消息头和消息体组成。消息头由消息的固有字段信息组成。消息体由一串字符串值组成。消息体的每个字符串值的意义由消息头中的描述指定，消息头的长度必须是8的倍数，相应的，消息体由8的倍数处开始。

Objects are addressed using path names, such as `/org/cups/printers/queue` . Processes on the message bus are associated with objects and implemented interfaces on that object.

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152016624-1242060507.png) <!-- dbus/keepng_1_1077750-20180909122929209-1441910663.png -->

### 3.1. Messages, 消息

在 D-BUS 中有四种类型的消息：

方法调用（method calls）：触发对象的一个方法
方法返回（method returns）：返回触发后的结果
信号（signals）：通知，可以看作事件消息
错误（errors）：返回触发的错误信息

### 3.2. Service Name, 服务名称

当通过总线进行通信时，应用程序会获得“服务名称”：应用程序可以选择以什么样的方式被同一个总线上的其他应用程序所知道。

服务名称由D-Bus的守护进程代理，被用来将消息从一个app发送到另一个app。“服务名称”的类似概念是IP地址和hostname主机名。

另一方面，如果总线没有在使用，则“服务名称”也不会被使用。这等同于“点对点”网络：由于对侧是已知的，就没有必要使用IP地址或者主机名了。

“服务名称”的格式与主机名类似。例如D-Bus服务由http://freedesktop.org定义，可以在总线上根据“org.freedesktop.DBus”这个“服务名称”来找到D-Bus服务。

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152016990-1492855136.jpg) <!-- dbus/dbus-0.jpg -->

一个应用连接到bus daemon会分配一个名字给这个连接。这个唯一标识的名字以冒号 `:` 开头（例如“:34-907”）。但是这种名字总是临时分配，无法确定的，也难以记忆，因此应用可以要求有另外一个名字well-known name 来对应这个唯一标识，就像我们使用域名来对应IP地址一样。例如可以使用 `com.mycompany` 来映射 `:34-907` 。

### 3.3. Object path, 对象路径

app通过导出对象来向其他app提供特定服务。这些对象是分层组织的，就像从QObject派生的类具有父子关系一样。但有一点不同，就是存在“根对象”概念，即所有的对象都有最终的父对象。

如果我们还是和Web服务对比，对象路径等同于URL地址部分：/pub/something。必须以斜线开始！

### 3.4. Interface, 接口

接口概念类似于C++的抽象类，声明了“契约”。也就是说它们建立了方法、信号、属性的名字。Qt的插件系统也使用了类似的机制：C++的基类通过Q_DECLARE_INTERFACE()来识别唯一的标识符。事实上，D-Bus接口名称的命名方式类似于Qt插件系统提供的方式：通常由定义该接口的实体的域名构建的标识符。

---

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152017385-539027955.jpg) <!-- dbus/2_1077750-20181015122450945-1038817085.jpg -->

Big Conceptual Picture : **Address -> [Bus Name] -> Path -> Interface -> Method**

bus name是可选的，除非是希望把消息送到特定的应用中才需要。interface也是可选的，有一些历史原因，DCOP不需要指定接口，因为DCOP在同一个对象中禁止同名的方法。

> D-BUS is fully typed and type-safe. Both a message's header and payload are fully typed. Valid types include byte, Boolean, 32-bit integer, 32-bit unsigned integer, 64-bit integer, 64-bit unsigned integer, double-precision floating point and string. A special array type allows for the grouping of types. A DICT type allows for dictionary-style key/value pairs.
>
> D-BUS is secure. It implements a simple protocol based on SASL profiles for authenticating one-to-one connections. On a bus-wide level, the reading of and the writing to messages from a specific interface are controlled by a security system. An administrator can control access to any interface on the bus. The D-BUS daemon was written from the ground up with security in mind.

注：以上是一些精简的概念说明，但非常到位。如果想得到更详细的说明，参考官网：<https://www.freedesktop.org/wiki/IntroductionToDBus/>

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152017713-1572237715.jpg) <!-- dbus/3_1077750-20181015141412609-354470513.jpg -->

对比前后两张d-feet截图，可以看到 address 可以共用（一个 UNIX Domain Socket 连接中传递了多个Bus Object的信息），Bus Name 可以重复，Unique Name 则不能重复。因此对象是由（BusName + ObjectPath）唯一确定的。注意：通信双方是Object，不是application。

在一个Object中，可以包括多个Interface——可以理解为对功能的分组（或者说是Namespace），是多个方法和信号的集合。

## 4. Tools

  * 要查看Dbus总线上的服务和对象可以借助 `d-feet` 和 `qdbusviewer`
  * 要发送信号可以使用 `dbus-send`
  * 要查看Dbus上的消息流可以使用 `dbus-monitor`
  * 环境变量 `DBUS_SESSION_BUS_ADDRESS` 的值即为dbus-daemon的总线地址

## 5. 协议浅析

### 5.1. 数据类型

[**Signature Strings**](https://pythonhosted.org/txdbus/dbus_overview.html#_signature_strings)

D-Bus uses a string-based type encoding mechanism called Signatures to describe the number and types of arguments requried by methods and signals. Signatures are used for interface declaration/documentation, data marshalling, and validity checking. Their string encoding uses a simple, though expressive, format and a basic understanding of it is required for effective D-Bus use. The table below lists the fundamental types and their encoding characters.

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152017981-46563578.png) <!-- dbus/keepng_4_1077750-20181025133859890-297867916.png -->

**Container Types**No spacing is allowed within signature strings. When defining signatures for multi-argument methods and signatures, the types of each argument are concatenated into a single string. For example, the signature for a method that accepts two integers followed by a string would be "iis".

There are four container types: Structs, Arrays, Variants, and Dictionaries.

**Structs**

Structures are enclosed by parentheses and may contain any valid D-Bus signature. For example, (ii) defines a structure containing two integers and ((ii)s) defines a structure containing a structure of two integers followed by a string. Empty structures are not permitted.

**Arrays**

Arrays define a list consisting of members with a fixed type. The array charater a must be immediately followed by the type of data in the array. This must be a single, complete type.

Examples

  * ai - Array of 32-bit integers
  * a(ii) - Array of structures
  * aai - Array of array of integers

**Variants**

Variants may contain a value of any type. The marshalled value of the variant includes the D-Bus signature defining the type of data it contains.

**Dictionaries**

Dictionaries work in a manner similar to that of structures but are restricted to arrays of key = value pairs. The key must be a basic, non-container type and the value may be any single, complete type. Dictionaries are defined in terms of arrays using {} to surround the key and value types. Examples:

  * a{ss} - string ⇒ string
  * a{is} - 32-bit signed integer ⇒ string
  * a{s(ii)} - string ⇒ structure containing two integers
  * a{sa{ss}} - string ⇒ dictionary of string to string

### 5.2. 消息路由

Messages are routed to client connections by destination address and match rules. Destination address routing is used when a message’s destination parameter contains a unique or well-known bus name. This is typically the case with method call and return messages which inherently require 1-to-1 communication. Signals, on the other hand, are broadcast messages with no specific destination. For these, client applications must register match rules in order to receive the signals they are interested in.

Although signal registration is the most common use for message matching rules, DBus message matching rules can be used to request delivery of any messages transmitted over the bus; including the method call and return messages between arbitrary bus clients. The messages delivered via match rules are always copies so it is not possible to use this mechanism to redirect messages away from their intended targets.

Message match rules are set via the org.freedesktop.DBus.AddMatch method and are formatted as a series of comma-separated, key=value paris contained within a single string. Excluded keys indicate wildcard matches that match every message. If all components of the match rule match a message, it will be delivered to the requesting application. The following table provides a terse description of the keys and values that may be specified in match rules. For full details, please refer to the DBus specification.

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152018231-386329929.png) <!-- dbus/keepng_5_1077750-20181025134407028-1542874149.png -->

### 5.3. [标准功能接口](https://pythonhosted.org/txdbus/dbus_overview.html#_standard_interfaces)

For example:

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200829152018440-1575032468.jpg) <!-- dbus/dbus-1.jpg -->

## 6. How to use（原理）

> [homepage](https://dbus.freedesktop.org/doc/dbus-tutorial.html)

### 6.1. Message

D-Bus works by sending messages between processes. If you're using a sufficiently high-level binding, you may never work with messages directly.There are 4 message types:

  * Method call messages ask to invoke a method on an object.
  * Method return messages return the results of invoking a method.
  * Error messages return an exception caused by invoking a method.
  * Signal messages are notifications that a given signal has been emitted (that an event has occurred). You could also think of these as "event" messages.

A method call maps very simply to messages: you send a method call message, and receive either a method return message or an error message in reply.Each message has a header, including fields, and a body, including arguments. You can think of the header as the routing information for the message, and the body as the payload. Header fields might include the sender bus name, destination bus name, method or signal name, and so forth. One of the header fields is a type signature describing the values found in the body. For example, the letter "i" means "32-bit integer" so the signature "ii" means the payload has two 32-bit integers.

### 6.2. Calling a Method

A method call in DBus consists of two messages; a method call message sent from process A to process B, and a matching method reply message sent from process B to process A. Both the call and the reply messages are routed through the bus daemon. The caller includes a different serial number in each call message, and the reply message includes this number to allow the caller to match replies to calls.

The call message will contain any arguments to the method. The reply message may indicate an error, or may contain data returned by the method.

A method invocation in DBus happens as follows:

  1. The language binding may provide a proxy, such that invoking a method on an in-process object invokes a method on a remote object in another process. If so, the application calls a method on the proxy, and the proxy constructs a method call message to send to the remote process.
  2. For more low-level APIs, the application may construct a method call message itself, without using a proxy.
  3. In either case, the method call message contains: a bus name belonging to the remote process; the name of the method; the arguments to the method; an object path inside the remote process; and optionally the name of the interface that specifies the method.
  4. The method call message is sent to the bus daemon.
  5. The bus daemon looks at the destination bus name. If a process owns that name, the bus daemon forwards the method call to that process. Otherwise, the bus daemon creates an error message and sends it back as the reply to the method call message.
  6. The receiving process unpacks the method call message. In a simple low-level API situation, it may immediately run the method and send a method reply message to the bus daemon. When using a high-level binding API, the binding might examine the object path, interface, and method name, and convert the method call message into an invocation of a method on a native object (GObject, java.lang.Object, QObject, etc.), then convert the return value from the native method into a method reply message.
  7. The bus daemon receives the method reply message and sends it to the process that made the method call.
  8. The process that made the method call looks at the method reply and makes use of any return values included in the reply. The reply may also indicate that an error occurred. When using a binding, the method reply message may be converted into the return value of of a proxy method, or into an exception.

The bus daemon never reorders messages. That is, if you send two method call messages to the same recipient, they will be received in the order they were sent. The recipient is not required to reply to the calls in order, however; for example, it may process each method call in a separate thread, and return reply messages in an undefined order depending on when the threads complete. Method calls have a unique serial number used by the method caller to match reply messages to call messages.

### 6.3. Emitting a Signal

A signal in DBus consists of a single message, sent by one process to any number of other processes. That is, a signal is a unidirectional broadcast. The signal may contain arguments (a data payload), but because it is a broadcast, it never has a "return value." Contrast this with a method call (see [the section called “Calling a Method - Behind the Scenes”](https://dbus.freedesktop.org/doc/dbus-tutorial.html#callprocedure)) where the method call message has a matching method reply message.

The emitter (aka sender) of a signal has no knowledge of the signal recipients. Recipients register with the bus daemon to receive signals based on "match rules" - these rules would typically include the sender and the signal name. The bus daemon sends each signal only to recipients who have expressed interest in that signal.

A signal in DBus happens as follows:

  1. A signal message is created and sent to the bus daemon. When using the low-level API this may be done manually, with certain bindings it may be done for you by the binding when a native object emits a native signal or event.
  2. The signal message contains the name of the interface that specifies the signal; the name of the signal; the bus name of the process sending the signal; and any arguments
  3. Any process on the message bus can register "match rules" indicating which signals it is interested in. The bus has a list of registered match rules.
  4. The bus daemon examines the signal and determines which processes are interested in it. It sends the signal message to these processes.
  5. Each process receiving the signal decides what to do with it; if using a binding, the binding may choose to emit a native signal on a proxy object. If using the low-level API, the process may just look at the signal sender and name and decide what to do based on that.
