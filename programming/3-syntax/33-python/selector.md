<!--
+++
title       = "Python多路复用: selector模块"
description = "1. IO多路复用; 2. selector模块的基本使用"
date        = "2021-12-21"
tags        = ["usual"]
categories  = ["3-syntax","33-python"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. IO多路复用

O多路复用技术是使用一个可以同时监视多个IO阻塞的中间人去监视这些不同的IO对象，这些被监视的任何一个或多个IO对象有消息返回，都将会触发这个中间人将这些有消息IO对象返回，以供获取他们的消息。

使用IO多路复用的优点在于，<font color=#FF0000>进程在单线程的情况下同样可以同时处理多个IO阻塞</font>。与传统的多线程/多进程模型比，I/O多路复用系统开销小，系统不需要创建新的进程或者线程，也不需要维护这些进程和线程的运行，降底了系统的维护工作量，节省了系统资源，

Python提供了selector模块来实现IO多路复用。同时，不同的操作系统上，这中间人的可选则的类型是不同的，目前常见的有，epoll, kqueue, devpoll, poll,select等；kqueue（BSD，mac支持），devpoll（solaris支持）和epoll的实现基本相同，epoll在Linux2.5+内核中实现，Windows系统只实现了select。

### 1.1. epoll,poll, select的比较

select和poll使用轮询的方式去检测监视的所有IO是否有数据返回，需要不断的遍历每一个IO对象，这是一种费时的操作，效率较低。poll优于select的一点是select限制了最大监视IO数为1024，这对于需要大量网络IO连接的服务器来显然是不够的；而poll对于这个个数没有限制。但是这同样面临问题，在使用轮询的方式监视这些IO时，IO数越大，意味着每一次轮询消耗的时间越多。效率也就越低，这是轮询无法解决的问题。

epoll就是为了解决这样的问题诞生的，首先他没有最大的监视的IO数的限制，并且没有使用轮询的方式去检测这些IO，而是采用了事件通知机制和回调来获取这些有消息返回的IO对象，只有“活跃”的IO才会主动的去调用callback函数。这个IO将会直接被处理而不需要轮询。

## 2. selector模块的基本使用

```py
import selectors
import socket

# 创建一个socketIO对象，监听后将可以接受请求消息了
sock = socket.socket()
sock.bind(("127.0.0.1", 80))
sock.listen()

slt = selectors.DefaultSelector()  # 使用系统默认selector，Windows为select，linux为epoll
# 将这个socketIO对象加入到，select中监视
slt.register(fileobj=sock, events=selectors.EVENT_READ, data=None)

# 循环处理消息
while True:
    # select方法：轮询这个selector，当有至少一个IO对象有消息返回时候，将会返回这个有消息的IO对象
    ready_events = slt.select(timeout=None)
    print(ready_events)     # 准备好的IO对象们
    break
```

`ready_events` 为一个列表（代表注册到这个select中的所有的有数据可接收IO对象），列表中的每一个元组为：

+ SelectorKey对象：
    * fileobj:注册的socket对象
    * fd:文件描述符
    * data:注册时我们传入的参数，可以是任意值，绑定到一个属性上，方便之后使用。
+ mask值
    * EVENT_READ ： 表示可读的； 它的值其实是1；
    * EVENT_WRITE： 表示可写的； 它的值其实是2；
    * 或者二者的组合

例如：

```py
[(SelectorKey(fileobj=<socket.socket fd=456, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('127.0.0.1', 80)>, fd=456, events=1, data=None),
    1)]
```

处理这个请求，只需要使用该socket对应方法即可，该socket用于接收请求的连接，使用accept方法就可以处理这个请求。

当接受请求之后，又将会产生新的客户端，我们将其放入selector中一并监视，当有消息来时，如果是连接请求，handle_request()函数处理，如果是客户端的消息，handle_client_msg()函数处理。

对于select中有两类socket，所以我们需要判断被激活后返回的socket是哪一种，再调用不同的函数做不同的请求。如果这个select中的socket种类有很多，将无法如此判断。解决办法就是将处理函数绑定到对应的selectkey对象中，可以使用data参数。

```py
def handle_request(sock:socket.socket, mask):    # 处理新连接
    conn, addr = sock.accept()
    conn.setblocking(False)  # 设定非阻塞
    slt.register(conn, selector.EVENT_READ, data=handle_client_msg)

def handle_client_msg(sock:socket.socket, mask)  # 处理消息
    data = sock.recv()
    print(data.decode())

sock = socket.socket()
sock.bind(("127.0.0.1", 80))
sock.listen()

slt = selectors.DefaultSelector()
slt.register(fileobj=sock, events=selectors.EVENT_READ, data=handle_request)

while True:
    ready_events = slt.select(timeout=None)
    for event, mask in ready_events:
        event.data(event.fileobj, mask)
        # 不同的socket有不同data函数，使用自己绑定的data函数调用，再将自己的socket作为参数。就可以处理不同类型的socket。
```

上面使用data很好的解决了上面问题，但是需要注意，绑定到data属性上函数（或者说可调用对象）最终会使用event.data(event.fileobj)的方式调用，这些函数接受的参数应该相同。

