<!--
+++
title       = "【转载】QtCreator架构解析"
description = "1. Qt框架的基本元素; 2. Qt插件"
date        = "2022-01-03"
tags        = []
categories  = ["3-syntax","35-cpp"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> [cnblog: qt creator源码全方面分析(4)](https://www.cnblogs.com/codeForFamily/category/1641809.html)

## 1. Qt框架的基本元素

+ QtCore

  * [The Meta-Object System](https://doc.qt.io/qt-5/metaobjects.html)
  * [The Property System](https://doc.qt.io/qt-5/properties.html)
  * [Object Model](https://doc.qt.io/qt-5/object.html)
  * [Object Trees & Ownership](https://doc.qt.io/qt-5/objecttrees.html)
  * [Signals & Slots](https://doc.qt.io/qt-5/signalsandslots.html)

+ [Qrc: 资源文件](https://doc.qt.io/qt-5/resources.html)
+ 其他关键框架

  + [The Animation Framework](https://doc.qt.io/qt-5/animation-overview.html)
  + [JSON Support in Qt](https://doc.qt.io/qt-5/json.html)
  + [The State Machine Framework](https://doc.qt.io/qt-5/statemachine-api.html)
  + [How to Create Qt Plugins](https://doc.qt.io/qt-5/plugins-howto.html)
  + [The Event System](https://doc.qt.io/qt-5/eventsandfilters.html)

+ [QObject](https://doc.qt.io/qt-5/qobject.html): 对象基础类
+ [QWidget](https://doc.qt.io/qt-5/search-results.html?q=qwidget): 部件基础类

### 1.1. Qt宏

+ Q_EMIT，Q_SIGNALS和Q_SLOTS

    避免与第三方的emit，signal和slots冲突

+ Q_ENUM和Q_ENUM_NS

    向元对象系统注册enum

+ Q_FLAG和Q_FLAG_NS，配合Q_DECLARE_FLAGS

    声明enum，并向元对象系统注册enum，用于flag的OR操作联合

+ Q_INTERFACES

    一般实现插件用，告诉Qt实现了哪些接口。

+ Q_INVOKABLE

    向元对象系统注册method，后续可被元对象调用

+ Q_NAMESPACE

    向命名空间添加QMetaObject

+ Q_OBJECT

    元对象的前提

+ Q_PROPERTY

    向元对象注册属性

### 1.2. d指针和q指针

> [d指针和q指针](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-4-1.html)

这是一个绝妙的技巧，能够在不破坏二进制兼容性的情况下将新的私有数据成员添加到类中。此外，它还能保持头文件的干净，并隐藏具体的实现，加速编译。

### 1.3. global头文件

插件的本质就是动态链接库，对于库，需要导出符号，供用户导入使用。在qt creator的源码中，存在固定的导入导出模式。

对于每个库和插件，都有一个 `xx_global.h` 头文件，其中xx为库或插件名。示例如下

```cpp
#pragma once

#include <qglobal.h>

#if defined(XX_LIBRARY)
#  define XX_EXPORT Q_DECL_EXPORT
#else
#  define XX_EXPORT Q_DECL_IMPORT
#endif
```

这就很明显了，XX_LIBRARY作为开关，来决定导入导出。

对于具体的实现，我们可以

```cpp
class XX_EXPORT xx { ... }
```

在类的声明中添加 `XX_EXPORT` 。

在qt creator源码中，在项目文件中添加了定义

```
DEFINES += XX_LIBRARY
```

这导致 `XX_EXPORT` 被替换为 `Q_DECL_EXPORT` 进行导出。

对于库或插件的使用者，直接包含xx.h即可，由于没有定义XX_LIBRARY，这里XX_EXPORT被替换为Q_DECL_IMPORT进行导入。

### 1.4. 内外命名空间

QtCreator源码中，每一个子项目都有内外两层命名空间，一个是外部的，一个是内部的。

示例如下

```cpp
namespace ExtensionSystem {

namespace Internal {
    class IPluginPrivate;
    class PluginSpecPrivate;
}

class EXTENSIONSYSTEM_EXPORT IPlugin : public QObject
{
    ...
};

} // namespace ExtensionSystem
```

+ ExtensionSystem是外部的，其中的类等内容会被EXTENSIONSYSTEM_EXPORT导出，用户使用时可见。
+ ExtensionSystem::Internal是内部的，定义的都是内部私有类(参考公有私有类)，不进行导出。譬如前置声明中的IPluginPrivate。

### 1.5. 统计接口实现

我们知道，插件架构必不可少的是定义接口类，即抽象基类，描述用户需要自定义实现的内容。此外，一般还有一个管理器类，对接口类的所有实现类进行管理，并调用其中的接口进行。

源码中有两种方式来获取所有实现类。

```cpp
// 接口类声明 xx.h
class ISimple
{
    ISimple();
    ~ISimple();
    virtual void algo1() = 0;
};

// 管理类声明 xxmanager.h
class SimpleManager
{
    static void registerSimple(const ISimple *obj);
}

// xxmanager.cpp实现文件中

// 统计接口的所有实现
static QList<ISimple *> g_simples;

// 方式1
ISimple::ISimple()
{
    g_simples.append(this);
}

ISimple::~ISimple()
{
    g_simples.removeOne(this);
}

// 方式2
void SimpleManager::registerSimple(const ISimple *obj)
{
    g_simples.append(obj);
}
```

一般，我们会把所有实现的列表g_simples，放在管理类中用于管理。

+ 方式1中接口类构造函数中添加了统计功能。
+ 方式2中管理类中添加了注册函数，用于统计。

一般我们在IPlugin的 `initialize()` 函数中创建对象，那么在调用完所有插件的 `initialize()` 函数后，我们可以认为已经完成了统计，就可以在 `extensionsInitialized()` 中使用g_simples了。

### 1.6. QLatinString

Qt中处理字符串最常用的肯定是QString，但是在qt creator源码中出现了大量的[QLatin1String](https://doc.qt.io/qt-5/qstring.html#QStringLiteral)。下面我们来介绍下区别。

这是一个宏，在编译时从字符串文字str中为QString生成数据。 在这种情况下，可以免费创建QString，并且将生成的字符串数据存储在已编译目标文件的只读段中。

如果您的代码如下所示：

```cpp
  // hasAttribute takes a QString argument
  if (node.hasAttribute("http-contents-length")) //...
```

然后这将创建一个临时QString作为hasAttribute函数参数进行传递。 这可能会非常昂贵，因为它涉及内存分配以及将数据复制/转换为QString的内部编码。

通过使用QStringLiteral可以避免此成本：

```cpp
if (node.hasAttribute(QStringLiteral(u"http-contents-length"))) //...
```

在这种情况下，QString的内部数据将在编译时生成。在运行时不会发生任何转换或分配。

使用QStringLiteral而不是用双引号引起来的纯C++字符串文字，可以显着加快根据编译时已知的数据创建QString实例的速度。

注意：当将字符串传递给具有重载QLatin1String参数的函数时，QLatin1String仍比QStringLiteral更有效，并且此重载避免了转换为QString。例如，`QString::operator ==()` 可以直接与 `QLatin1String` 进行比较：

```cpp
if (attribute.name() == QLatin1String("http-contents-length")) //...
```

注意：某些编译器编码包含US-ASCII字符集以外字符的字符串会有bug。在这种情况下，<font color=#FF0000>请确保在字符串前加上u</font>。否则是可选的。

说白了，<font color=#FF0000>QStringLiteral在编译期就创建了数据，避免了内存分配</font>，加速了QString的创建。

## 2. Qt插件

1. [How to Create Qt Plugins](https://doc.qt.io/qt-5/plugins-howto.html)
2. [<QtPlugin> - Defining Plugins](https://doc.qt.io/archives/qt-5.10/qtplugin.html)
3. [Echo Plugin Example](https://doc.qt.io/qt-5/qtwidgets-tools-echoplugin-example.html)
4. [QPluginLoader](https://doc.qt.io/qt-5/qpluginloader.html)
5. [QLibrary](https://doc.qt.io/qt-5/qlibrary.html)
6. moc(源码见qtbase/src/tools/moc目录)
