<!--
+++
title       = "【转载】QtCreator编码规范"
description = "1. 二进制兼容性和源代码兼容性; 2. 代码构造; 3. 格式化; 4. 模式与实践; 5. 类成员名称; 6. 文档"
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

> [qt creator源码全方面分析(2-1)](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-1.html)

## 1. 二进制兼容性和源代码兼容性

以下列表描述了<font color=#FF0000>发行版的版本编号方式</font>，并定义发行版之间的二进制兼容性和源代码兼容性：

  * Qt Creator 3.0.0是主要版本，Qt Creator 3.1.0是次要版本，Qt Creator 3.1.3是补丁版本。

  * 后向（向下）兼容性意味着，代码链接到库的旧版本仍然有效。

    指新的版本的软／硬件可以使用老版本的软／硬件产生的数据。

    Windows操作系统是向后兼容的，大部分针对Windows-7开发的软件依然可以很好的运行在Windows-10下。

    JRE的（提供StandLib）是向后兼容的，所以，新的JRE可以运行老旧的程序。

    C++更新Lib时，要争取能够保持接口的只增不改不删，兼容原有的接口而不致Lib版本绑定或冲突。

  * 前向（向上）兼容性，Forward Compatibility，意味着，可与旧库一起使用的代码，可链接到库的新版本。

    指老的版本的软／硬件可以使用新版本的软／硬件产生的数据。

    例如：CD光盘是向前兼容的，CD光盘既可以被老旧的CD光驱读取，也可以被新的DVD光驱读取。

    比特币区块链系统是向前兼容的，老版本的节点依然可以验证新版本产生的区块，这也是比特币区块链不会产生永久分叉的基础。

    所以，SDK接口设计，需要具有前瞻性，保证未来的可用性。

  * 源代码兼容性意味着代码无需修改即可编译。

注：“Forward”一词在这里有“未来”的意思，我认为翻译成<font color=#FF0000>“向未来”</font>更加形象一些，不知是哪位先人翻译成了“向前”，很多时候汉语中这个“向前”是指“从前”还是“之后”是有歧义的。

<font color=#FF0000>当前，我们不保证主要版本和次要版本之间的二进制或源代码兼容性。</font>

**但是，在同一次要版本中，我们尝试为补丁版本保留后向二进制兼容性和后向源代码兼容性**：

  * 软API冻结：从次要版本的Beta发布之后不久，我们就开始在该次要版本中保持后向源代码兼容性，包括其补丁版本。这意味着从那时起，使用Qt Creator API的代码将针对此次要版本的所有后续版本的API进行编译，包括其补丁版本。该规则偶尔可能会有例外，应该适当地加以传达。

  * 硬API冻结：从次要版本的候选版本开始，我们在该次要版本保持后向源代码兼容性，包括其补丁版本。我们还将开始保持后向二进制兼容性，但不会在插件的compatVersion设置中反映出来。因此，针对候选发行版编写的Qt Creator插件，实际上不会在最终版本或更高版本中加载，即使这些库的二进制兼容性在理论上是允许的。请参阅下面有关插件规格的部分。

  * 硬ABI冻结：从次要版本的最终发行开始，我们保持该版本及其所有补丁版本的后向源代码和二进制兼容性。

<font color=#FF0000>为了保持向后兼容性：</font>

  * 请勿添加或删除任何公有API（例如，全局函数，公有/受保护/私有成员函数）。

  * 不要重新实现功能（甚至是内联函数，受保护的或私有的函数）。

  * 检查[二进制兼容性替代方法](https://wiki.qt.io/Binary_Compatibility_Workarounds)，以获取保留二进制兼容性的方法。

有关二进制兼容性的更多信息，请参见[C++二进制兼容性问题](https://community.kde.org/Policies/Binary_Compatibility_Issues_With_C%2B%2B)。

从插件规范的角度来看，这意味着

  * 补丁版本中的Qt Creator插件将把次要版本作为compatVersion值。 例如，3.1.2版本的插件具有compatVersion ="3.1.0"。

  * 次要版本的预发行（包括候选发行）中，把它们自己作为compatVersion值，这意味着针对最终发行版编译的插件将不会在预发行版中加载。

  * Qt Creator插件开发人员可以决定他们的插件是否需要某个补丁版本（或者更高版本），或者通过在声明对其他插件的依赖性时设置相应的version值，他们可以使用此次要版本的所有补丁版本。Qt项目提供的Qt Creator插件的默认设置是要求最新的补丁版本。

例如，Qt Creator 3.1 beta（内部版本号3.0.82）中的Find插件将具有

```html
<plugin name="Find" version="3.0.82" compatVersion="3.0.82">
  <dependencyList>
    <dependency name="Core" version="3.0.82"/>
    ....
```

Qt Creator 3.1.0 final中的Find插件将具有

```html
<plugin name="Find" version="3.1.0" compatVersion="3.1.0">
  <dependencyList>
    <dependency name="Core" version="3.1.0"/>
    ....
```

Qt Creator 3.1.1补丁版本中的Find插件将具有版本3.1.1，将向后二进制兼容Find插件版本3.1.0（compatVersion
="3.1.0"），并且将依赖向后二进制兼容的Core插件版本3.1.1：

```html
<plugin name="Find" version="3.1.1" compatVersion="3.1.0">
  <dependencyList>
    <dependency name="Core" version="3.1.1"/>
    ....
```

## 2. 代码构造

遵循代码构造准则，以使代码更快，更清晰。 此外，该准则还允许您利用C++中的强类型检查。

  * 在可能的情况下，建议前缀递增，而不是后缀递增。前缀递增可能更快。只要考虑一下前/后递增的明显实现即可。 此规则也适用于递减：

    ```cpp
    ++T;
    --U;

    -NOT-

    T++;
    U--;
    ```

  * 尝试尽量减少对同一代码的重复计算。 特别是循环的时候：

    ```cpp
    Container::iterator end = large.end();
    for (Container::iterator it = large.begin(); it != end; ++it) {
        ...;
    }

    -NOT-

    for (Container::iterator it = large.begin();
        it != large.end(); ++it) {
            ...;
    }
    ```

  * 您可以在非时间紧缺的代码中，对Qt容器使用Qt foreach循环。这是降低多行冗余，并给循环变量起适当名称的一种好方法：

    ```cpp
    foreach (QWidget *widget, container)
        doSomething(widget);

    -NOT-

    Container::iterator end = container.end();
    for (Container::iterator it = container.begin(); it != end; ++it)
        doSomething(*it);
    ```

  * 如果可能，将循环变量设为const。 这可以防止不必要的共享数据分离：

    ```cpp
    foreach (const QString &name, someListOfNames)
        doSomething(name);

    - NOT -

    foreach (QString name, someListOfNames)
        doSomething(name);
    ```

## 3. 格式化

### 3.1. 利用标识符

在标识符中使用[驼峰大小写](http://en.wikipedia.org/wiki/CamelCase)。

充分利用标识符中的第一个字符，如下所示：

  * 类名以大写字母开头。
  * 函数名称以小写字母开头。
  * 变量名以小写字母开头。
  * 枚举名称和值以大写字母开头。无作用域限制的Enum值包含枚举类型的部分名称。

### 3.2. 空格

  * 使用四个空格来进行缩进，<font color=#FF0000>不要使用制表符Tab</font>。
  * 使用空白行将合适的代码组合在一起。
  * 始终仅使用一个空白行。

#### 3.2.1. 指针和引用

对于指针或引用，请始终在星号（*）或与号（＆）之前使用单个空格，但不要在其后使用。

尽可能避免使用C语言类型转换：

      char *blockOfMemory = (char *)malloc(data.size());
      char *blockOfMemory = reinterpret_cast<char *>(malloc(data.size()));
      -NOT-
      char* blockOfMemory = (char* ) malloc(data.size());

当然，在这个特殊的例子中，可能使用new更合适。

#### 3.2.2. Operator名称和括号

operator名称和括号之间请勿使用空格。

等式标记（==）是operator名称的一部分，因此，空格使声明看起来像一个表达式：

      operator==(type)
      -NOT-
      operator == (type)

#### 3.2.3. 函数名称和括号

不要在函数名称和括号之间使用空格：

      void mangle()
      -NOT-
      void mangle ()

#### 3.2.4. 关键词

请始终在关键字和大括号之间使用一个空格：

      if (foo) {
      }
      -NOT-
      if(foo){
      }

#### 3.2.5. 注释

通常，在“//”之后放置一个空格。要对齐多行注释中的文本，可以插入多个空格。

### 3.3. 大括号

作为基本规则，将左大括号与语句开头放在同一行：

      if (codec) {
      }
      -NOT-
      if (codec)
      {
      }

例外：函数实现和类声明的左括号始终在行首处：

      static void foo(int g)
      {
          qDebug("foo: %i", g);
      }
      class Moo
      {
      };

当条件语句的主体包含多行时，以及单行语句有些复杂时，请使用大括号。 否则，请省略它们：

      if (address.isEmpty())
          return false;
      for (int i = 0; i < 10; ++i)
          qDebug("%i", i);
      -NOT-
      if (address.isEmpty()) {
          return false;
      }
      for (int i = 0; i < 10; ++i) {
          qDebug("%i", i);
      }

例外1：如果括号中的语句包含多行或进行了换行，也请使用大括号：

      if (address.isEmpty()
              || !isValid()
              || !codec) {
          return false;
      }

注意：这可以重写为：

      if (address.isEmpty())
          return false;
      if (!isValid())
          return false;
      if (!codec)
          return false;

例外2：在if-then-else块中，如果if-code或else-code覆盖多行，也请使用大括号：

      if (address.isEmpty()) {
          --it;
      } else {
          qDebug("%s", qPrintable(address));
          ++it;
      }
      -NOT-
      if (address.isEmpty())
          --it;
      else {
          qDebug("%s", qPrintable(address));
          ++it;
      }
      if (a) {
          if (b)
              ...
          else
              ...
      }
      -NOT-
      if (a)
          if (b)
              ...
          else
              ...

当条件语句的主体为空时，请使用大括号：

      while (a) {}
      -NOT-
      while (a);

### 3.4. 圆括号

使用括号将表达式分组：

```cpp
if ((a && b) || c)
-NOT-
if (a && b || c)
```

```cpp
(a + b) & c
-NOT-
a + b & c
```

### 3.5. 换行符

  * 行少于100个字符。
  * 如有必要，请插入换行符。
  * 逗号放在行的结尾。
  * 操作符放在新行的开头。

```cpp
if (longExpression
    || otherLongExpression
    || otherOtherLongExpression) {
}
-NOT-
if (longExpression ||
    otherLongExpression ||
    otherOtherLongExpression) {
}
```

### 3.6. 声明

  * 对类的访问部分使用以下顺序：公有，受保护，私有。 公有部分对类的每个用户都很有趣。 私有部分仅对该类的实现者有用。
  * 在类的声明文件中，避免声明全局对象。 如果所有对象都使用相同的变量，请使用静态成员。
  * 使用 `class` 而不是 `struct` 。一些编译器会在符号名称中混入差异，并在struct声明后跟class声明时发出警告。 为了避免持续更改来消除警告，我们将 `class` 声明作为首选方式。

#### 3.6.1. 声明变量

  * 避免使用类类型的全局变量，<font color=#FF0000>来排除初始化顺序的问题。</font>如果无法避免，请考虑使用 `Q_GLOBAL_STATIC` 。

  * 声明全局字符串文本

    ```cpp
    const char aString[] = "Hello";
    ```

  * 尽可能避免使用短名称（例如a，rbarr，nughdeget）。仅将单字符变量名称用于计数器和临时变量，其用途是显而易见。

  * 每个变量声明在单独的行中：

    ```cpp
    QString a = "Joe";
    QString b = "Foo";
    -NOT-
    QString a = "Joe", b = "Foo";
    ```

    注意：`QString a = "Joe"` 首先创建了由字符串文字构造的临时副本，然后调用拷贝构造函数。 因此，它可能比通过 `QString a("Joe")` 直接构造更昂贵。但是，编译器可以删除副本（即使这样做有副作用），现代编译器通常会这样做。考虑到这些相等的代价，QtCreator代码还是倾向于使用'='习惯用法，因为它符合传统的C样式初始化，它不会被误认为是函数声明，并且它减少了更多初始化中的嵌套括号的级别。

  * 避免缩写：

    ```cpp
    int height;
    int width;
    char *nameOfThis;
    char *nameOfThat;

    -NOT-

    int a, b;
    char *c, *d;
    ```

  * 当变量被需要时，才进行声明。声明时完成初始化，这一点尤其重要。

### 3.7. 命名空间

  * 将左大括号与namespace关键字放在同一行。

  * 不要缩进内部的声明或定义。

  * 可选，但如果名称空间跨越多行，则建议使用：在右大括号后添加注释，重复该名称空间。

    ```cpp
    namespace MyPlugin {
    void someFunction() { ... }
        }  // namespace MyPlugin
    ```

  * 作为例外，如果名称空间中只有一个类声明，则可以都放在一行上：

    ```cpp
    namespace MyPlugin { class MyClass; }
    ```

  * 不要在头文件中使用using指令。

  * 定义类和函数时不要依赖using指令，而应在适当的命名声明区域中对其进行定义。

  * 访问全局函数时，请勿依赖using指令。

  * 在其他情况下，建议您使用using指令，因为它们可帮助您避免混乱的代码。 最好将所有的using指令放在文件顶部附近，#include之后。

    ```cpp
    [in foo.cpp]
    ...
    #include "foos.h"
    ...
    #include <utils/filename.h>
    ...
    using namespace Utils;
    namespace Foo {
    namespace Internal {
    void SomeThing::bar()
    {
        FileName f;              // or Utils::FileName f
        ...
    }
    ...
    } // namespace Internal      // or only // Internal
    } // namespace Foo           // or only // Foo

    -NOT-

    [in foo.h]
    ...
    using namespace Utils;       // Wrong: no using-directives in headers
    class SomeThing
    {
        ...
    };

    -NOT-

    [in foo.cpp]
    ...
    using namespace Utils;
    #include "bar.h"             // Wrong: #include after using-directive

    -NOT-

    [in foo.cpp]
    ...
    using namepace Foo;
    void SomeThing::bar()        // Wrong if Something is in namespace Foo
    {
        ...
    }
    ```

## 4. 模式与实践

### 4.1. 命名空间

阅读[Qt In Namespace](https://wiki.qt.io/Qt_In_Namespace)，并记住所有Qt
Creator都是名称空间感知的代码。

Qt Creator中的命名空间策略如下：

  * 供其他库或插件使用的，被导出的库或插件中的类/符号，位于库/插件指定的命名空间中，例如MyPlugin。
  * 未被导出的库或插件的类/符号，位于库/插件的附加的内部名称空间中，例如MyPlugin::Internal。

### 4.2. 传递文件名

Qt Creator API需要使用可移植格式的文件名，即<font color=#FF0000>在Windows上也要使用斜杠 `/` 而不是反斜杠 `\` </font>。传递用户输入的文件名给API，请先使用 `QDir::fromNativeSeparators` 对其进行转换。要向用户显示文件名，请使用 `QDir::toNativeSeparators` 将其转换回本地格式。对于这些任务，请考虑使用 `Utils::FileName::fromUserInput(QString)` 和 `Utils::FileName::toUserOutput()` 。

比较文件名时请使用 `Utils::FileName` ，因为它是大小写敏感的。还要确保文件夹使用的路径，是没有使用相对路径的（`QDir::cleanPath() `）。

### 4.3. 插件扩展点

插件扩展点是一个插件提供的接口，供其他人实现。然后，插件将检索接口的所有实现，并使用这些实现。也就是说，它们扩展了插件的功能。通常，接口的实现会在插件初始化期间放入全局对象池中，在插件初始化结束时，插件即可从对象池中检索到它们。

例如，Find插件为其他插件提供了FindFilter接口。在FindFilter界面中，可以添加其他搜索范围，并会显示在**高级搜索**对话框中。

Find插件从全局对象池中检索所有FindFilter实现，并将其显示在对话框中。该插件将实际搜索请求转发到正确的FindFilter实现，然后执行搜索。

### 4.4. 使用全局对象池

通过 `ExtensionSystem::PluginManager::addObject()` ，您可以将对象添加到全局对象池，并通过 `ExtensionSystem::PluginManager::getObjects()` ，再次获取特定类型的对象。这应该主要用于插件扩展点的实现。

注意：请勿将单例放入对象池中，也不要从中检索它。请改用单例模式。

### 4.5. C++特征

  * 最好是 `#pragma once` ，而不是文件保护符。

  * 除非您知道自己要做什么，否则不要使用异常。

  * 除非您知道要做什么，否则不要使用RTTI（运行时类型信息；即typeinfo结构，dynamic_cast或typeid运算符，包括抛出异常）。

  * 除非您知道自己要做什么，否则不要使用虚拟继承。

  * 明智地使用模板，不要只因为你会模板。

        提示：使用编译期自动测试，可查看C++功能是否被测试场中的所有编译器支持。

  * 所有代码都是ASCII（仅仅7bit字符，如果不确定，请运行man ascii）

    * 理由：我们内部的语言环境太多，UTF-8和Latin1系统的组合不健康。通常，数值大于127的字符，在您最喜欢的编辑器中进行单机保存的不知情情况下，就可能已被破坏。

    * 对于字符串：使用 `\nnn`（其中nnn是对你字符串所在的任何语言环境中的八进制表示）或 `\xnn`（其中nn是十六进制）。例如：`QString s = QString::fromUtf8("\213\005")`

    * 对于文档中的变音符号或其他非ASCII字符，请使用qdoc `\unicode`命令或使用相关的宏。例如：`\uuml` 表示 `ü` 。

  * 尽可能使用静态关键字代替匿名命名空间。局部化到编译单元的名称，使用static可具有内部链接性。对于在匿名命名空间中声明的名称，不幸的是C++标准要求外部链接性(ISO/IEC 14882, 7.1.1/6, 或在gcc邮件列表上查看有关此内容的各种讨论)。

#### 4.5.1. 空指针

为空指针常量使用平凡零（0）始终是正确的，并且键入最少。

      void *p = 0;
      -NOT-
      void *p = NULL;
      -NOT-
      void *p = '\0';
      -NOT-
      void *p = 42 - 7 * 6;

注意：作为例外，导入的第三方代码以及与本机API接口的代码(src/support/os_*)可以使用NULL。

### 4.6. C++11 和 C++14功能

代码应与Microsoft Visual Studio 2013，g++ 4.7和Clang 3.1一起编译。

#### 4.6.1. Lambdas

使用lambda时，请注意以下几点：

  * 您不必显式指定返回类型。 如果您没有使用前面提到的编译器，请注意这是C++ 14功能，您可能需要在编译器中启用C++ 14支持。

    ```cpp
    []() {
        Foo *foo = activeFoo();
        return foo ? foo->displayName() : QString();
    };
    ```

    如果您在类函数实现中使用了lambda，并调用了所在类的静态函数，则必须明确捕获`this`。 否则，它将无法使用g++ 4.7及更早版本进行编译。

      ```cpp
      void Foo::something()
      {
          ...
          [this]() { Foo::someStaticFunction(); }
          ...
      }
      -NOT-
      void Foo::something()
      {
          ...
          []() { Foo::someStaticFunction(); }
          ...
      }
      ```

根据以下规则格式化lambda：

  * 把捕获列表，参数列表，返回类型和左括号放在第一行，在接下来的几行中缩进主体，在新的一行上关闭右括号。

      ```cpp
      []() -> bool {
          something();
          return isSomethingElse();
      }
      -NOT-
      []() -> bool { something();
      somethingElse(); }
      ```

  * 将函数调用的右圆括号和分号与lambda的右大括号放在同一行。

      ```cpp
      foo([]() {
          something();
      });
      ```

  * 如果在'if'语句中使用lambda，请在新行上启动lambda，以避免在lambda的左大括号和'if'语句的左大括号之间造成混淆。

      ```cpp
      if (anyOf(fooList,
              [](Foo foo) {
                  return foo.isGreat();
              }) {
          return;
      }
      -NOT-
      if (anyOf(fooList, [](Foo foo) {
                  return foo.isGreat();
              }) {
          return;
      }
      ```

  * 可选，如果合适，将lambda完整地放在同一行。

      ```cpp
      foo([] { return true; });
      if (foo([] { return true; })) {
          ...
      }
      ```

#### 4.6.2. auto关键字

可选，在以下情况下，可以使用auto关键字。 如有疑问，例如，如果使用auto会使代码的可读性降低，请不要使用auto。
请记住，代码的读取次数比编写的次数要多。

  * 避免在同一条语句中重复某个类型。

      ```cpp
      auto something = new MyCustomType;
      auto keyEvent = static_cast<QKeyEvent *>(event);
      auto myList = QStringList({ "FooThing",  "BarThing" });
      ```

  * 分配迭代器类型时

    `auto it = myList.const_iterator();`

#### 4.6.3. 域化枚举

不需要将非域化枚举隐式转换为int，或附加域有用时，使用域化枚举。

#### 4.6.4. 委托构造函数

如果多个构造函数使用基本上相同的代码，请使用委托构造函数。

#### 4.6.5. 初始化列表

使用初始化列表来初始化容器，例如：

      const QVector<int> values = {1, 2, 3, 4, 5};

#### 4.6.6. 用大括号初始化

如果对大括号使用初始化，请遵循与圆括号相同的规则。 例如：

```cpp
class Values // the following code is quite useful for test fixtures
{
    float floatValue = 4; // prefer that for simple types
    QVector<int> values = {1, 2, 3, 4, integerValue}; // prefer that syntax for initializer lists
    SomeValues someValues{"One", 2, 3.4}; // not an initializer_list
    SomeValues &someValuesReference = someValues;
    ComplexType complexType{values, otherValues} // constructor call
}
object.setEntry({"SectionA", value, doubleValue}); // calls a constructor
object.setEntry({}); // calls default constructor
```

但是请注意不要过度使用它，以免混淆您的代码。

#### 4.6.7. 非静态数据成员初始化

使用非静态数据成员初始化进行平凡(trivial)的初始化，但在公共导出类中除外。

#### 4.6.8. 默认函数和删除函数

考虑使用 `=default` 和 `=delete` 来控制特殊函数。

#### 4.6.9. 覆写

覆写虚函数时，建议使用override关键字。不要在已覆写函数上使用virtual。

确保一个类对所有被覆盖的函数始终使用override，以区分没有被覆盖的。

#### 4.6.10. Nullptr

所有编译器都支持nullptr，但在使用方面尚未达成共识。如有疑问，请询问模块的维护者是否更喜欢使用nullptr。

#### 4.6.11. 基于范围的for循环

您可以使用基于范围的for循环，但要注意虚假分离问题。
如果for循环仅读取容器，且容器是const的还是不共享的，不明显，请使用std::cref()来确保不会不必要地分离容器。

### 4.7. 使用QObject

  * 请记住，将Q_OBJECT宏添加到依赖于元对象系统的QObject子类中。 与元对象系统相关的功能包括信号和槽的定义，qobject_cast <>的使用等。 另请参阅Casting。
  * 优先使用Qt5样式的connect()调用，而不是Qt4样式的。
  * 使用Qt4样式的connect()调用时，请在connect语句中标准化信号和槽的参数，以使更加快速安全地查找信号和槽。 您可以使用$QTDIR/util/normalize来标准化现有代码。 有关更多信息，请参见QMetaObject::normalizedSignature。

### 4.8. 文件头

如果创建一个新文件，则文件顶部应包含头注释，保持与Qt Creator其他源文件中的一样。

### 4.9. 包含头文件

  * 使用以下格式来包含Qt标头：#include 。 不要包括可能在Qt4和Qt5之间进行了更改的模块。

  * 排列顺序应从特定到通用，以确保头文件是齐全的。 例如：

    * `#include "myclass.h"`
    * `#include "otherclassinplugin.h"`
    * `#include <otherplugin/someclass.h>`
    * `#include <QtClass>`
    * `#include <stdthing>`
    * `#include <system.h>`

  * 将其他插件的头文件括在方括号（<>）而不是引号（""）中，以便更轻松地发现源代码中的外部依赖项。

  * 在同样性质头文件的长块之间添加空行，并尝试按字母顺序在块内排列头文件。

### 4.10. Casting

  * 避免使用C强制转换，最好使用C++强制转换（static_cast，const_cast，reinterpret_cast）reinterpret_cast和C类型强制转换都是危险的，但是至少reinterpret_cast不会删除const修饰符。
  * 除非您知道要做什么，否则不要使用dynamic_cast，对QObject使用qobject_cast或重构设计，例如引入type()函数（请参阅QListWidgetItem）。

### 4.11. 常量的定义

优先选择域化枚举来定义const常量，而不是 `static const int` 变量或 `define` 宏定义。枚举值将在编译时由编译器替换，从而使代码更快。`define` 宏定义不是命名空间安全的。

### 4.12. 编译器和平台特定的问题

  * 使用问号运算符时要格外小心。 如果返回的类型不相同，则某些编译器会生成的代码会在运行时崩溃（您甚至不会收到编译器警告）：

      ```cpp
      QString s;
      // crash at runtime - QString vs. const char *
      return condition ? s : "nothing";
      ```

  * 对齐时要格外小心。

    每当指针转换时，目标所需对齐字节数增加，在某些体系结构上，生成的代码可能会在运行时崩溃。例如，如果将 `const char *` 强制转换为 `const int *` ，它将在整数两字节对齐或四个字节对齐的机器上崩溃。

    使用union来强制编译器正确对齐变量。 在下面的示例中，可以确保AlignHelper的所有实例int边界对齐：

      ```cpp
      union AlignHelper
      {
          char c;
          int i;
      };
      ```

  * 对于头文件中的静态声明，请坚持使用整数类型，整数类型数组及其结构。 例如，static float i[SIZE_CONSTANT]; 在大多数情况下，不会在每个插件中进行优化和拷贝，最好避免使用。

  * 任何具有构造函数或需要运行代码进行初始化的对象，都不能作为库代码的全局对象，因为该构造函数或代码何时运行未定义（首次使用时，库加载时，main()之前或根本不进行）。

    即使为共享库定义了初始化程序的执行时间，移动该代码到插件中或库是静态编译时，你会遇到麻烦：

    ```cpp
    // global scope
    -NOT-
    // Default constructor needs to be run to initialize x:
    static const QString x;
    -NOT-
    // Constructor that takes a const char * has to be run:
    static const QString y = "Hello";
    -NOT-
    QString z;
    -NOT-
    // Call time of foo() undefined, might not be called at all:
    static const int i = foo();
    ```

    你应该这样做：

    ```cpp
    // global scope
    // No constructor must be run, x set at compile time:
    static const char x[] = "someText";
    // y will be set at compile time:
    static int y = 7;
    // Will be initialized statically, no code being run.
    static MyStruct s = {1, 2, 3};
    // Pointers to objects are OK, no code needed to be run to
    // initialize ptr:
    static QString *ptr = 0;
    // Use Q_GLOBAL_STATIC to create static global objects instead:
    Q_GLOBAL_STATIC(QString, s)
    void foo()
    {
        s()->append("moo");
    }
    ```

    注意：函数范围内的静态对象没有问题。构造函数将在第一次函数进入时运行。但是，该代码不是可重入的。

  * `char` 是有符号的还是无符号的，取决于体系结构。 如果您明确需要有符号或无符号的char，请使用有符号 `char` 或 `uchar` 。 例如，以下代码将在PowerPC上中断：

      ```cpp
      // Condition is always true on platforms where the
      // default is unsigned:
      if (c >= 0) {
          ...
      }
      ```

  * 避免使用64位枚举值。 嵌入式AAPCS（ARM体系结构的过程调用标准）的ABI将所有枚举值都硬编码为32位整数。

  * 不要混合使用const和非const迭代器。 这将在被破坏的编译器上悄无声息地崩溃。

      ```cpp
      for (Container::const_iterator it = c.constBegin(); it != c.constEnd(); ++it)
      -NOT-
      for (Container::const_iterator it = c.begin(); it != c.end(); ++it)
      ```

  * 不要在导出的类中内联虚析构函数。这会导致依赖插件中的vtable表重复，这也可能破坏RTTI。参见[QTBUG-45582](https://bugreports.qt.io/browse/QTBUG-45582).

### 4.13. 从模板或工具类继承

从模板或工具类继承有以下潜在陷阱：

  * 析构函数不是虚函数，这可能导致内存泄漏。

  * 这些符号不会导出（并且大部分是内联的），这可能导致符号冲突。

例如，库A具有类 `Q_EXPORT X: public QList {};` ，库B具有类 `Q_EXPORT Y: public QList
{};` 。突然，QList符号从两个库中导出，这产生了冲突。

### 4.14. 继承与聚合

* 如果存在明确的is-a关系，请使用继承。
* 使用聚合来重复使用正交构建基础类。
* 如果可以选择，则优先选择聚合而不是继承。

### 4.15. 公共头文件的约定

我们的公共头文件必须在某些用户的严格设置下仍然有效。 所有已安装的头文件都必须遵循以下规则：

  * 没有C类型强制转换（-Wold-style-cast）。请使用static_cast，const_cast或reinterpret_cast，对于基本类型，使用构造函数形式：int(a)代替(int)a。 有关更多信息，请参见Casting。

  * 没有浮点数比较（-Wfloat-equal）。使用`qFuzzyCompare`来比较值与差值。使用`qIsNull`来检查浮点数是否为二进制0，而不是将其与0.0进行比较，或者，最好将此类代码移至实现文件中。

  * 不要在子类中隐藏虚函数（{-Woverloaded-virtual}）。如果基类A具有虚函数 `int val()` ，子类B具有相同名称的重载 `int val(int x)` ，则类A的val函数将被隐藏。使用`using`关键字使其再次可见，并为被破坏的编译器添加以下解决方法（虽然看起来丑陋笨拙）：

      ```cpp
      class B: public A
      {
      #ifdef Q_NO_USING_KEYWORD
        inline int val() { return A::val(); }
      #else
        using A::val;
      #endif
      };
      ```

  * 不要同名局部变量遮蔽其他外部变量（-Wshadow）。

  * 如果可能的话，避免 `this->x = x;` 。

  * 变量与在类中声明的函数不要同名。

  * 为了提高代码的可读性，始终先检查预处理变量是否已定义，后获取变量值（-Wundef）。

      ```cpp
      #if defined(Foo) && Foo == 0
      -NOT-
      #if Foo == 0
      -NOT-
      #if Foo - 0 == 0
      ```

  * 使用 `#defined` 运算符检查预处理变量时，请始终把变量放在括号中。

      ```cpp
      #if defined(Foo)
      -NOT-
      #if defined Foo
      ```

## 5. 类成员名称

我们使用"m_"前缀约定，但公有结构化成员除外（通常在*Private类中，并且真正的公有结构化成员很少见）。`d` 和 `q` 指针不受"m_"规则的限制。

`d`指针("Pimpls")被命名为“d”，而不是"m_d"。`Foo`类中`d`指针的类型为`FooPrivate
*`，其中FooPrivate所在命名空间与Foo相同，或者，如果Foo被导出，则在相应的{Internal}命名空间。

如果需要（例如，当私有对象需要发出对应类的信号时），FooPrivate可以成为Foo的友元。

如果私有类需要反向引用其对应的类，则将指针命名为`q`，其类型为`Foo *`。（与Qt中的约定相同："q"看起来像倒置的"d"。）

更多关于D指针的内容请参考[Qt Creator 源码学习 07：D 指针](https://www.devbean.net/2016/11/qt-creator-source-study-07/)

不要使用智能指针来守卫`d`指针，因为它会增加编译和链接时间开销，并创建带有更多符号的臃肿对象代码，这会减慢调试器的启动速度：

```cpp
############### bar.h
#include <QScopedPointer>
//#include <memory>
struct BarPrivate;
struct Bar
{
    Bar();
    ~Bar();
    int value() const;
    QScopedPointer<BarPrivate> d;
    //std::unique_ptr<BarPrivate> d;
};
############### bar.cpp
#include "bar.h"
struct BarPrivate { BarPrivate() : i(23) {} int i; };
Bar::Bar() : d(new BarPrivate) {}
Bar::~Bar() {}
int Bar::value() const { return d->i; }
############### baruser.cpp
#include "bar.h"
int barUser() { Bar b; return b.value(); }
############### baz.h
struct BazPrivate;
struct Baz
{
    Baz();
    ~Baz();
    int value() const;
    BazPrivate *d;
};
############### baz.cpp
#include "baz.h"
struct BazPrivate { BazPrivate() : i(23) {} int i; };
Baz::Baz() : d(new BazPrivate) {}
Baz::~Baz() { delete d; }
int Baz::value() const { return d->i; }
############### bazuser.cpp
#include "baz.h"
int bazUser() { Baz b; return b.value(); }
############### main.cpp
int barUser();
int bazUser();
int main() { return barUser() + bazUser(); }
```

结果：

      Object file size:
       14428 bar.o
        4744 baz.o
        8508 baruser.o
        2952 bazuser.o
      Symbols in bar.o:
          00000000 W _ZN3Foo10BarPrivateC1Ev
          00000036 T _ZN3Foo3BarC1Ev
          00000000 T _ZN3Foo3BarC2Ev
          00000080 T _ZN3Foo3BarD1Ev
          0000006c T _ZN3Foo3BarD2Ev
          00000000 W _ZN14QScopedPointerIN3Foo10BarPrivateENS_21QScopedPointerDeleterIS2_EEEC1EPS2_
          00000000 W _ZN14QScopedPointerIN3Foo10BarPrivateENS_21QScopedPointerDeleterIS2_EEED1Ev
          00000000 W _ZN21QScopedPointerDeleterIN3Foo10BarPrivateEE7cleanupEPS2_
          00000000 W _ZN7qt_noopEv
                   U _ZN9qt_assertEPKcS1_i
          00000094 T _ZNK3Foo3Bar5valueEv
          00000000 W _ZNK14QScopedPointerIN3Foo10BarPrivateENS_21QScopedPointerDeleterIS2_EEEptEv
                   U _ZdlPv
                   U _Znwj
                   U __gxx_personality_v0
      Symbols in baz.o:
          00000000 W _ZN3Foo10BazPrivateC1Ev
          0000002c T _ZN3Foo3BazC1Ev
          00000000 T _ZN3Foo3BazC2Ev
          0000006e T _ZN3Foo3BazD1Ev
          00000058 T _ZN3Foo3BazD2Ev
          00000084 T _ZNK3Foo3Baz5valueEv
                   U _ZdlPv
                   U _Znwj
                   U __gxx_personality_v0

## 6. 文档

文档是从源文件和头文件生成的。您编写文档是为了其他开发人员，而不是自己。在头文件中，编写接口文档。也就是说，函数是做什么的，而不是怎么实现的。

在.cpp文件中，如果函数实现不明显，则可以编写相关的文档。
