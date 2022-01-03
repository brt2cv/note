<!--
+++
title       = "dbus-python的API及示例"
description = "1. [Data types](https://dbus.freedesktop.org/doc/dbus-python/tutorial.html#id10); 2. Connecting to the Bus; 3. Making method calls （同步调用）; 4. Making asynchronous calls（异步调用）; 5. Receiving signals; 6. Exporting objects; 7. 思考"
date        = "2021-12-21"
tags        = []
categories  = ["3-syntax","33-python","3rd-modules"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> [Tutorial](https://dbus.freedesktop.org/doc/dbus-python/tutorial.html)
>
> [API](https://dbus.freedesktop.org/doc/dbus-python/dbus.html)

## 1. [Data types](https://dbus.freedesktop.org/doc/dbus-python/tutorial.html#id10)

Unlike Python, D-Bus is statically typed - each method has a certain signature representing the types of its arguments, and will not accept arguments of other types.

具体内容详见[官网教程](https://dbus.freedesktop.org/doc/dbus-python/tutorial.html#id10)，此处不再赘述。

## 2. Connecting to the Bus

    import dbus
    session_bus = dbus.SessionBus()
    system_bus = dbus.SystemBus()

## 3. Making method calls （同步调用）

  1. The bus name.
This identifies which application you want to communicate with.

  2. The object path.
To identify which one you want to interact with, you use an object path.

### 3.1. Proxy objects

To interact with a remote object, you use a proxy object.

```py
proxy = bus.get_object('org.freedesktop.NetworkManager',
                       '/org/freedesktop/NetworkManager/Devices/0')
```

### 3.2. Interfaces and methods

D-Bus uses interfaces to provide a namespacing mechanism for methods. An interface is a group of related methods and signals (more on signals later), identified by a name which is a series of dot-separated components starting with a reversed domain name.

```py
# 这里proxy作为代理对象使用，直接调用具体方法：Introspect(null)
props = proxy.Introspect(dbus_interface='org.freedesktop.DBus.Introspectable')
# props is a tuple of properties, the first of which is the object path
```

As a short cut, if you’re going to be calling many methods with the same interface, you can construct a dbus.Interface object and call methods on that, without needing to specify the interface again:

```py
# 通过Interface对象间接调用
eth0_dev_iface = dbus.Interface(proxy, dbus_interface='org.freedesktop.DBus.Introspectable')
props2 = eth0_dev_iface.Introspect()  # props2 is the same as before
```

你可以直接 `print(props)` 打印获得的反馈。但如果通过 `type()` 查询props，你会得到 `<class 'dbus.String'>` ，而不是标准的 `python::str` 。请参考文章开头的 Data Types 章节的陈述。

## 4. Making asynchronous calls（异步调用）

### 4.1. Setting up an event loop

To make asynchronous calls, you first need an event loop or “main loop”.

```py
from dbus.mainloop.glib import DBusGMainLoop
DBusGMainLoop(set_as_default=True)  # You must do this before connecting to the bus.

# 或者直接将DBus的 mainloop 附加在 pygi 主循环中
from gi.repository import GLib

loop = GLib.MainLoop()
loop.run()

# 或者将主循环的调用通过参数传入每个connection
import dbus
from dbus.mainloop.glib import DBusGMainLoop

dbus_loop = DBusGMainLoop()
bus = dbus.SessionBus(mainloop=dbus_loop)
```

PyQt v4.2 and later includes support for integrating dbus-python with the Qt event loop. <font color=#FF0000>To connect D-Bus to this main loop, call `dbus.mainloop.qt.DBusQtMainLoop` instead of `dbus.mainloop.glib.DBusGMainLoop` </font>. Otherwise the Qt loop is used in exactly the same way as the GLib loop.

### 4.2. Asynchronous method calls

To make a call asynchronous, pass two callables as keyword arguments reply_handler and error_handler to the proxy method. The proxy method will immediately return None. At some later time, when the event loop is running, one of these will happen:

  * the reply_handler will be called with the method's return values as arguments; or
  * the error_handler will be called with one argument, an instance of DBusException representing a remote exception.

    ```py
    # To make an async call, use the reply_handler and error_handler kwargs
    remote_object.HelloWorld("Hello from example-async-client.py!",
                            dbus_interface='com.example.SampleInterface',
                            reply_handler=handle_hello_reply,
                            error_handler=handle_hello_error)

    # Interface objects also support async calls
    iface = dbus.Interface(remote_object, 'com.example.SampleInterface')

    iface.RaiseException(reply_handler=handle_raise_reply,
                         error_handler=handle_raise_error)
    ```

实现 reply_handler 和 error_handler 方法：

```py
def handle_hello_reply(**r_args**):
    print str(r_args)

def handle_hello_error(**err_args**):
    print "HelloWorld raised an exception! That's not meant to happen..."
    print "\t", str(err_args)

    if True:  # ...
        loop.quit()
```

## 5. Receiving signals

To receive signals, the Bus needs to be connected to an event loop. Signals will only be received while the event loop is running.

### 5.1. Signal matching

To respond to signals, you can use the **add_signal_receiver**(self, **handler_function**, **signal_name**=None, **dbus_interface**=None, **bus_name**=None, **path**=None, **keywords) method on Bus objects. This arranges for a callback to be called when a matching signal is received, and has the following arguments:

  * a callable (the handler_function) which will be called by the event loop when the signal is received
  * the signal name, signal_name
  * the D-Bus interface, dbus_interface
  * a sender bus name (well-known or unique), bus_name
  * a sender object path, path

`add_signal_receiver()` returns a SignalMatch object. Its only useful public API at the moment is a `remove()` method with no arguments, which removes the signal match from the connection.

```py
def catchall_signal_handler(*args, **kwargs):
    print ("Caught signal (in catchall handler) "
           + kwargs['dbus_interface'] + "." + kwargs['member'])
    for arg in args:
        print "        " + str(arg)

def catchall_hello_signals_handler(hello_string):
    print "Received a hello signal and it says " + hello_string

def catchall_testservice_interface_handler(hello_string, dbus_message):
    print "com.example.TestService interface says " + hello_string + " when it sent signal " + dbus_message.get_member()

# catch the signal
bus = dbus.SessionBus()

bus.add_signal_receiver(catchall_signal_handler, interface_keyword='dbus_interface', member_keyword='member')
bus.add_signal_receiver(catchall_hello_signals_handler, dbus_interface="com.example.TestService", signal_name="HelloSignal")
bus.add_signal_receiver(catchall_testservice_interface_handler, dbus_interface="com.example.TestService", message_keyword='dbus_message')
```

### 5.2. Receiving signals from a proxy object

[Proxy objects](https://dbus.freedesktop.org/#proxy-objects) have a special method **connect_to_signal**(self, **signal_name**: str, **handler_function**, **dbus_interface**=None, **keywords) which arranges for a callback to be called when a signal is received from the corresponding remote object. The parameters are:

  * the name of the signal
  * a callable (the handler function) which will be called by the event loop when the signal is received
  * the handler function
  * the keyword argument dbus_interface qualifies the name with its interface

You **shouldn't** use proxy objects just to listen to signals, since they might activate the relevant service when created, but if you already have a proxy object in order to call methods, it's often convenient to use it to add signal matches too. （注：一个代理服务在创建时会激活相关的service，产生没必要的开销，所以应该谨慎使用Proxy）

### 5.3. Getting more information from a signal

You can also arrange for more information to be passed to the handler function. If you pass the keyword arguments **sender_keyword**, **destination_keyword**, **interface_keyword**, **member_keyword** or **path_keyword** to the `connect_to_signal()` method, the appropriate part of the signal message will be passed to the handler function as a keyword argument: for instance if you use：

```py
def handler(sender=None):
    print "got signal from %r" % sender

iface.connect_to_signal("Hello", handler, sender_keyword='sender')
```

and a signal Hello with no arguments is received from "com.example.Foo", the `handler()` function will be called with `sender='com.example.Foo'` .

### 5.4. String argument matching

The handler will only be called if that argument （arg**N**） of the `signal (numbered from zero)`  is a D-Bus string (in particular, not an object-path or a signature) with that value.


```py
def hello_signal_handler(hello_string):
    print ("Received signal (by connecting using remote object) and it says: " + hello_string)

proxy = bus.get_object("com.example.TestService","/com/example/TestService/object")
proxy.connect_to_signal("HelloSignal", hello_signal_handler, dbus_interface="com.example.TestService", arg0="Hello")  # String argument matching
```

## 6. Exporting objects

Objects made available to other applications over D-Bus are said to be exported. All subclasses of dbus.service.Object are automatically exported.

To export objects, the Bus needs to be connected to an event loop. Exported methods will only be called, and queued signals will only be sent, while the event loop is running.

### 6.1. Inheriting from dbus.service.Object

Object expects either a BusName or a Bus object, and an object-path, to be passed to its constructor: arrange for this information to be available. For example:

```py
class Example(dbus.service.Object):
    def __init__(self, object_path):
        dbus.service.Object.__init__(self, dbus.SessionBus(), path)
```

This object will automatically support introspection, but won’t do anything particularly interesting. To fix that, you’ll need to export some methods and signals too.

### 6.2. Exporting methods with dbus.service.method

To export a method, use the decorator dbus.service.method. For example:

```py
class Example(dbus.service.Object):
    def __init__(self, object_path):
        dbus.service.Object.__init__(self, dbus.SessionBus(), path)

    @dbus.service.method(dbus_interface='com.example.Sample',
                         in_signature='v', out_signature='s')
    def StringifyVariant(self, variant):
        return str(variant)
```

The in_signature and out_signature are D-Bus signature strings as described in Data Types.

#### 6.2.1. **Finding out the caller’s bus name**

The method decorator accepts a sender_keyword keyword argument. If you set that to a string, the unique bus name of the sender will be passed to the decorated method as a keyword argument of that name：

```py
class Example(dbus.service.Object):
    def __init__(self, object_path):
        dbus.service.Object.__init__(self, dbus.SessionBus(), path)

    @dbus.service.method(dbus_interface='com.example.Sample',
                         in_signature='', out_signature='s',
                         sender_keyword='sender')
    def SayHello(self, sender=None):
        return 'Hello, %s!' % sender
        # -> something like 'Hello, :1.1!'
```

**Asynchronous method implementations**

```py
class SomeObject(dbus.service.Object):

    @dbus.service.method("com.example.SampleInterface",
                         in_signature='s', out_signature='as')
    def HelloWorld(self, hello_message):
        print (str(hello_message))
        return ["Hello", " from example-service.py", "with unique name",
                session_bus.get_unique_name()]
```

### 6.3. Emitting signals with dbus.service.signal

To export a signal, use the decorator `dbus.service.signal`; to emit that signal, call the decorated method. The decorated method can also contain code which will be run when called, as usual. For example:

```py
class Example(dbus.service.Object):
    def __init__(self, object_path):
        dbus.service.Object.__init__(self, dbus.SessionBus(), path)

    @dbus.service.signal(dbus_interface='com.example.Sample',
                         signature='us')
    def NumberOfBottlesChanged(self, number, contents):
        print "%d bottles of %s on the wall" % (number, contents)

e = Example('/bottle-counter')
e.NumberOfBottlesChanged(100, 'beer')
# -> emits com.example.Sample.NumberOfBottlesChanged(100, 'beer')
#    and prints "100 bottles of beer on the wall"
```

The signal will be queued for sending when the decorated method returns - you can prevent the signal from being sent by raising an exception from the decorated method (for instance, if the parameters are inappropriate). The signal will only actually be sent when the event loop next runs.

* * *

## 7. 思考

1. 通过Proxy调用服务难道不是一个标准模式吗？为什么官方教程在 **Receiving signals from a proxy object **一节并不推荐“仅仅为了监听信号而创建代理”？多余的开销是什么？

    答：官方解释：当创建一个对象代理时，如果代理对象中存在服务方法，那么该方法在代理创建时也将被一并激活。那么就只剩下 `bus.add_signal_receiver()` 方法可以使用了——这恰恰说明，该方法的实现并没有创建一个代理，而仅仅是在监听bus的服务而已~
