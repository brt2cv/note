<!--
+++
title       = "【转载】QtCreator二进制兼容"
description = "1. 定义; 2. ABI注意事项; 3. 可做与不可做; 4. 库程序员的技巧; 5. 故障排除"
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

> [qt creator源码全方面分析(2-1)](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-1-1.html)

## 1. 定义

库是**二进制兼容**的，如果动态链接到该库的旧版本的程序，无需重新编译，就可以与该库的新版本一起运行。

库是**源代码兼容**的，如果对于库的新版本，程序需要重新编译才能运行，但不需要任何进一步的修改。

二进制兼容性解决了很多麻烦。它使为特定平台分发软件变得更加容易。如果不能确保发行版之间的二进制兼容性，人们将不得不提供静态链接的二进制文件。静态二进制文件很糟糕，因为它们

  * 浪费资源（尤其是内存）
  * 程序不能从库的bug修复或功能扩展中受益

在KDE项目中，对于核心库（kdelibs，kdepimlibs）的主要发行版的生命周期，我们提供二进制兼容性。

## 2. ABI注意事项

本文适用于KDE构建用的编译器使用的大多数C++ ABI。它主要基于Itanium C++ ABI草案，GCC C++编译器从3.4版本开始使用。有关Microsoft Visual C++名称改编方案的信息主要来自于[关于调用约定的文章](!http://www.agner.org/optimize/calling_conventions.pdf)（这是迄今为止有关MSVC ABI和名称改编的最完整信息）。

此处指定的某些约束可能不适用于给定的编译器。此处的目标是列出最严格的一组条件，用于编写跨平台C++代码，这意味着会被多种不同的编译器编译。

发现新的二进制不兼容问题时，此页面会同步更新。

## 3. 可做与不可做

你可以...

  * 添加新的非虚拟功能，包括信号和槽以及构造函数。
  * 在类中添加一个新的枚举。
  * 将新的枚举值追加到现有枚举。

    * 例题：如果这导致编译器为枚举选择了更大的基础类型，则这更改是二进制不兼容的。不幸的是，编译器有一些选择基础类型的余地，因此从API设计的角度来看，建议添加一个**Max....**枚举值，并显式设置一个较大的值(**=255**, **=1<<15**, 等)，以创建一个保证可以适合所选基础类型的枚举值的范围。

  * 重新实现在类层次结构中原始基类定义的虚函数（该虚函数定义在第一个非虚基类，或该类的第一个非虚基类中，依此类推），如果程序链接到先前版本的库，且该库调用了基类中的实现而不是派生类中的实现，是安全的。这很棘手，可能很危险。三思而后行。或者，请参阅下面的解决方法。

    * 例外：如果重新实现的函数具有[协变返回类型](!http://en.wikipedia.org/wiki/Covariant_return_type)，则如果派生更多的类型始终与派生较小的类型具有相同的指针地址，则它仅是二进制兼容性的变动。如有疑问，请勿使用协变返回类型来进行覆写。

  * 更改内联函数或使内联函数变为非内联，如果程序链接到先前版本的库，且该库调用了旧的实现，是安全的。这很棘手，可能很危险。三思而后行。
  * 移除私有非虚函数，如果它们没有被任何内联函数调用过（并且从未使用过）。
  * 移除私有静态成员变量，如果它们没有被任何内联函数调用过（并且从未使用过）。
  * 添加新的**静态**数据成员变量。
  * 更改方法的默认参数。但是，它需要重新编译才能使用实际的新的默认参数值。
  * 添加新类。
  * 导出以前未导出的类。
  * 在类中添加或删除友元声明。
  * 重命名保留的成员类型。
  * 扩展保留的位字段，前提是这不会导致位字段超出其基础类型的边界(8 bits for char & bool, 16 bits for short, 32 bits for int, etc.)
  * 将Q_OBJECT宏添加到类中，如果该类已经从QObject继承。
  * 添加Q_PROPERTY，Q_ENUMS或Q_FLAGS宏，因为它仅修改由moc生成的元对象，而不修改类本身。

你不可以...

  * 对于现有类：
    * [取消导出或删除](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Unexport_or_remove_a_class)已导出的类。
    * 以任何方式更改[类层次结构](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Change_the_class_hierarchy)（添加，删除或重新排序基类）。
    * [移除](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Remove_class_finality)`final`ity。
  * 对于模板类：
    * 以任何方式[更改模板参数](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Change_the_template_arguments_of_a_template_class)（添加，删除或重新排序）。
  * 对于任意类型的现有函数：
    * 取消导出。
    * 移除。
      * 移除已声明函数的实现。符号来自函数的实现，因此实际上就是函数。
    * 变为内联（这包括将成员函数的主体移至类定义，即使没有inline关键字也是如此）
    * 添加一个新的重载函数（BC，而不是SC：使＆func变得模棱两可），将重载函数添加到已经被重载的函数中是可以的（对＆func的任何使用都已经需要强制转换）。
    * 更改其签名。这包括：
      * 更改参数列表中参数的任意类型，包括更改现有参数的const/volatile限定符（代替，添加新方法）
      * 更改函数的const/volatile限定符
      * 更改某些函数或数据成员变量的[访问权限](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Change_the_access_rights)，例如从`私有`到`公有`。对于某些编译器，此信息可能是签名的一部分。如果需要使私有函数变为受保护的甚至是共有的，则必须添加一个新函数，来调用此私有函数。
      * 更改成员函数的[CV限定符](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Change_the_CV-qualifiers_of_a_member_function)：应用于函数本身的const和/或volatile。
      * 使用其他参数扩展函数，即使此参数具有默认参数。请参阅以下有关如何避免此问题的建议。
      * 以任何方式更改[返回类型](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Change_the_return_type)
      * 例外：用extern "C"声明的非成员函数可以更改参数类型（请小心）。
  * 对于虚成员函数：
    * 向没有任何虚函数或虚基类的类中[添加虚函数](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Add_a_virtual_member_function_to_a_class_without_any)。
    * 向非叶节点的类[添加新的虚函数](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Add_new_virtuals_to_a_non-leaf_class)，因为这会破坏子类。请注意，设计为用于应用程序子类化的类始终是非叶类。请参阅下面的一些解决方法，或在邮件列表中询问。
    * 以任何理由添加新的虚函数，甚至在叶节点类中，如果该类旨在Windows上保持二进制兼容性。这样做可能会[重排现有的虚函数](!http://lists.kde.org/?l=kde-core-devel&m=139744177410091&w=2)并破坏二进制兼容性。
    * 在类声明中[更改虚函数的顺序](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Change_the_order_of_the_declaration_of_virtual_functions)。
    * [覆写已存在的虚函数，如果该函数不在原始基类中](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Override_a_virtual_that_doesn.27t_come_from_a_primary_base)（第一个非虚基类，或原始基类的原始基类，一路往上）。
    * [覆写已存在的虚函数](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Override_a_virtual_with_a_covariant_return_with_different_top_address)，如果重载函数具有[协变量返回类型](!http://en.wikipedia.org/wiki/Covariant_return_type)，而其高派生类型的指针地址与低派生的指针地址不同（通常发生在，在低派生和高派生之间，有多重继承或虚继承）。
    * 移除虚函数，即使它是基类虚函数的重新实现。
  * 对于静态非私有成员或非静态非成员公有数据：
\- 移除或取消导出
\- 更改其[类型](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Change_the_type_of_global_data)
\- 更改其[CV限定符](!https://community.kde.org/Policies/Binary_Compatibility_Examples#Change_the_CV-qualifiers_of_global_data)

  * 对于非静态成员变量：
\- 添加新的数据成员到现有的类中。
\- 更改类中非静态数据成员的顺序。
\- 更改成员的类型（变量名符号除外）
\- 从已有的类中删除已有的非静态数据成员。

如果需要添加扩展/修改现有函数的参数列表，则需要添加新函数，而不是新参数。在这种情况下，您可能想添加简短说明，在库的更高版本中，这两个函数应通过默认参数进行合并：

    void functionname( int a );
    void functionname( int a, int b ); //BCI: merge with int b = 0

你应该...

为了类在将来可扩展，您应该遵循以下规则：

  * 添加d指针。见下文。
  * 添加非内联虚析构函数，即使主体为空。
  * 在QObject派生的类中重新实现event，即使新函数的主体只是调用基类的实现。这是专门为避免，因添加已重新实现的虚函数而引起的问题，如下所述。
  * 使所有构造函数非内联。
  * 编写拷贝构造函数和赋值运算符的非内联实现，除非类无法进行值拷贝（例如，从QObject继承的类是不能的）

## 4. 库程序员的技巧

编写库时最大的问题是，不能安全地添加数据成员，因为这会改变每个class类，struct结构，或者对象类型数组的大小和布局。

### 4.1. 位标志

位标志是一种例外。如果对枚举或布尔使用位标志，则至少在下一个字节减去1bit之前是安全的。具有下面成员的类

    uint m1 : 1;
    uint m2 : 3;
    uint m3 : 1;
    uint m1 : 1;
    uint m2 : 3;
    uint m3 : 1;
    uint m4 : 2; // new member

不会破坏二进制兼容性。请四舍五入到最多7位（如果已经大于8，则为15位）。使用最后一位可能会在某些编译器上引起问题。

### 4.2. 使用d指针

位标记和预定义的保留变量很好，但远远不够。这就是d指针技术发挥作用的地方。"d指针"的名称源于Trolltech's Arnt Gulbrandsen，他首先将该技术引入到Qt，使其成为最早的C++ GUI库之一，用于在更大的发行版之间保持二进制兼容性。看到它的每个人都迅速将该技术用作KDE库的通用编程模式。这是一个绝妙的技巧，能够在不破坏二进制兼容性的情况下将新的私有数据成员添加到类中。

**备注**：d指针模式在计算机科学历史上已经以不同的名称被多次描述过，例如pimpl，handle/body或cheshire cat。Google可以帮助您找到其中任何一种的在线论文，只需将C++添加到搜索词中即可。

在类Foo的定义中，定义一个前向声明

    class FooPrivate;

和私有成员中的d指针：

    private:
        FooPrivate* d;

FooPrivate类本身完全定义在类实现文件（通常为*.cpp）中，例如：

    class FooPrivate {
    public:
        FooPrivate()
            : m1(0), m2(0)
        {}
        int m1;
        int m2;
        QString s;
    };

您现在要做的就是，在构造函数或初始化函数中使用以下方法创建私有数据：

    d = new FooPrivate;

并在析构函数中将其删除

    delete d;

在大多数情况下，您将需要使d指针为const，以捕获意外修改或拷贝它的情况，这时将失去对私有对象的所有权，并造成内存泄漏：

    private:
        FooPrivate* const d;

这使您可以修改d指向的对象，但不能在初始化后修改d的值。

但是，您可能不希望所有成员变量都存在于私有数据对象中。对于经常使用的成员，将它们直接放入类中会更快，因为内联函数无法访问d指针数据。还要注意，尽管在d指针本身中已声明为公有，但d指针所涵盖的所有数据都是私有的。对于公有或受保护的访问，请同时提供set和get函数。例如

    QString Foo::string() const
    {
        return d->s;
    }
    void Foo::setString( const QString& s )
    {
        d->s = s;
    }

也可以将d指针的私有类声明为嵌套的私有类。如果使用此技术，请记住，嵌套的私有类将继承包含的导出类的公有符号可见性。这将导致私有类的函数在动态库的符号表中被命名。您可以在嵌套私有类的实现中使用`Q_DECL_HIDDEN`来手动重新隐藏符号。从技术上讲，这是ABI变动，但不会影响KDE开发人员支持的公共ABI，因此私有符号错误可能重新隐藏，而不会发出进一步的警告。

## 5. 故障排除

### 5.1. 在没有d指针的情况下将新数据成员添加到类中

如果您没有自由的位标志，保留的变量并且也没有d指针，但是您必须添加一个新的私有成员变量，那么仍然存在一些可能性。如果您的类继承自QObject，则可以例如将其他数据放在一个特殊的子对象中，并通过遍历子对象列表来查找它们。您可以使用QObject::children()访问子列表。但是，更简便，通常更快的方法是使用哈希表存储对象与额外数据之间的映射。为此，Qt提供了一个基于指针的字典，称为[QHash](!http://qt-project.org/doc/qt-4.8/QHash.html)（或Qt3中的[Templat::Qt3](!https://community.kde.org/index.php?title=Template:Qt3&action=edit&redlink=1)）。

在Foo类的实现中的基本技巧是：

  * 创建一个私有数据类FooPrivate。
  * 创建一个静态QHash<Foo *, FooPrivate *>。
  * 请注意，有些编译器/链接器（不幸的是，几乎所有的）都无法在动态库中创建静态对象。他们只是忘了调用构造函数。因此，您应该使用`Q_GLOBAL_STATIC`宏来创建和访问该对象：

    // BCI: Add a real d-pointer
    typedef QHash<Foo *, FooPrivate *> FooPrivateHash;
    Q_GLOBAL_STATIC(FooPrivateHash, d_func)
    static FooPrivate *d(const Foo *foo)
    {
        FooPrivate *ret = d_func()->value(foo);
        if ( ! ret ) {
            ret = new FooPrivate;
            d_func()->insert(foo, ret);
        }
        return ret;
    }
    static void delete_d(const Foo *foo)
    {
        FooPrivate *ret = d_func()->value(foo);
        delete ret;
        d_func()->remove(foo);
    }

  * 现在，您可以像以前的代码一样简单地在类中使用d指针，只需调用d(this)即可。例如：

    d(this)->m1 = 5;

  * 在析构函数中添加一行：

    delete_d(this);

  * 不要忘记添加一个BCI注释，以便可以在库的下一版本中删除该hack。
  * 不要忘记在下一个类中添加d指针。

### 5.2. 添加已重新实现的虚函数

正如已经说明的，你可以安全的重新实现定义在其中一个基类中的虚函数，如果程序链接到先前版本的库，且该库调用了基类中的实现而不是派生类中的实现，是安全的。这是因为如果编译器可以确定要调用哪个虚函数，则有时会直接调用该虚函数。例如，如果您有

    void C::foo()
    {
        B::foo();
    }

那么B::foo()直接被调用。如果类B继承自实现了foo()函数的类A，而B本身未重新实现，则 C::foo() 实际上将调用A::foo()。如果该库的较新版本添加了B::foo()，则C::foo() 仅在重新编译后才调用B::foo() 。

另一个更常见的示例是：

    B b;  // B derives from A
    b.foo();

那么对foo()的调用将不会使用虚拟表。这意味着如果库中以前不存在B::foo()，但现在存在了，则使用较早版本库进行编译的代码仍将调用A::foo()。

如果不能保证无需重新编译就能继续工作，请将函数功能从A::foo()移至新的受保护函数A::foo2()，并使用以下代码：

    void A::foo()
    {
        if( B* b = dynamic_cast< B* >( this ))
            b->B::foo(); // B:: is important
        else
            foo2();
    }
    void B::foo()
    {
        // added functionality
        A::foo2(); // call base function with real functionality
    }

类型B（或继承）的对象对A::foo()的所有调用将导致调用B::foo()。唯一无法正常工作的情况是对A::foo()的调用，该调用显式指定了A::foo()，但B::foo()则调用了A::foo2()，其他地方别这样做。

### 5.3. 使用新类

一种相对简单的“扩展”类的方法是编写一个替换类，该替换类还将包括新功能（可能从旧类继承代码以重复利用）。当然，这需要使用该库来适应和重新编译应用程序，因此这种方法不可能用来修复或扩展类的功能，该类是应用程序编译用的旧版本库中的类。但是，特别是对于小型的和/或性能至关重要的类，编写它们可能会更简单，而不必确保它们将来会易于扩展；如果以后需要，可编写一个新的替代类，以提供新的功能或更好的性能。

### 5.4. 向叶节点类添加新的虚函数

这种技术是使用新类的一种情况，这对向类中添加新的虚函数有帮助，该类必须保持二进制兼容性，而该类的继承类没必要继续保持二进制兼容性（即所有的继承类都在应用程序中）。在这种情况下，可以添加一个继承自原始类的新类，并将其添加进来。当然，使用新功能的应用程序必须进行修改以使用新类。

    class A {
    public:
        virtual void foo();
    };
    class B : public A { // newly added class
    public:
        virtual void bar(); // newly added virtual function
    };
    void A::foo()
    {
        // here it's needed to call a new virtual function
        if( B* this2 = dynamic_cast< B* >( this ))
            this2->bar();
    }

当还有其他的继承类也必须保持二进制兼容性时，则无法使用此技术，因为它们不得不从新类继承。

### 5.5. 使用信号代替虚功能

Qt的信号和槽设计由Q_OBJECT宏创建的特殊的虚函数调用，它存在于从QObject继承的每个类中。因此，添加新的信号和槽不会影响二进制兼容性，并且可以使用信号/槽机制来模拟虚函数。

    class A : public QObject {
    Q_OBJECT
    public:
        A();
        virtual void foo();
    signals:
        void bar( int* ); // added new "virtual" function
    protected slots:
        // implementation of the virtual function in A
        void barslot( int* );
    };
    A::A()
    {
        connect(this, SIGNAL( bar(int*)), this, SLOT( barslot(int*)));
    }
    void A::foo()
    {
        int ret;
        emit bar( &ret );
    }
    void A::barslot( int* ret )
    {
        *ret = 10;
    }

函数bar()的作用类似于虚函数，barslot()实现了函数的实际功能。由于信号的返回值为void，因此必须使用参数来返回数据。由于只有一个槽函数连接从槽中返回数据的信号，因此这种方式可以正常工作。注意，要使Qt4起作用，连接类型必须为Qt::DirectConnection。

如果继承类要重新实现bar()的功能，则它必须提供自己的槽函数：

    class B : public A {
    Q_OBJECT
    public:
        B();
    protected slots: // necessary to specify as a slot again
        void barslot( int* ); // reimplemented functionality of bar()
    };
    B::B()
    {
        disconnect(this, SIGNAL(bar(int*)), this, SLOT(barslot(int*)));
        connect(this, SIGNAL(bar(int*)), this, SLOT(barslot(int*)));
    }
    void B::barslot( int* ret )
    {
        *ret = 20;
    }

现在，B::barslot()将像重新实现虚函数A::bar()一样。请注意，有必要再次将barlot()指定为B中的槽，并且在构造函数中，有必要先断开连接，然后再次连接，这将断开A::barslot()并连接B::barslot() 。

注意：可以通过实现虚槽函数来实现相同目的。
