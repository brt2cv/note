<!--
+++
title       = "C++语法"
description = "1. 编译器; 2. 语法; 3. 头文件.h与源文件.cpp; 4. class; 5. 其他"
date        = "2022-01-03"
tags        = []
categories  = ["3-syntax","35-cpp"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

> [知乎：C++知识点总结（长文）](https://zhuanlan.zhihu.com/p/92901691?utm_source=wechat_session)
>
> [脑图](https://naotu.baidu.com/file/49f1246fb0d81fb50145eceb32427895)
>
> [csdn:《Effective C++》笔记](https://blog.csdn.net/zb1593496558/article/details/80488367)

[TOC]

---

## 1. 编译器

### 1.1. g++编译器

`g++` 等于 `gcc -xc++ -lstdc++ -shared-libgcc`

如果使用g++链接对象文件，它将自动链接到STD C++库中

### 1.2. 编译cpp文件时的额外宏

```cpp
#define __GXX_WEAK__ 1
#define __cplusplus 1
#define __DEPRECATED 1
#define __GNUG__ 4
#define __EXCEPTIONS 1
#define __private_extern__ extern
```

## 2. 语法

### 2.1. namespace

例如：

```
namespace xxx
{

}// 没有分号

std::cout << "xxx";
using namespace std;
```

不建议使用`using namespace`，相当于把垃圾分类后，又导入同一个垃圾车，依然会冲突。

* 同名的namespace自动合并
* 无名名字空间

    无名名字空间中的成员使用 `::标识符` 进行访问

* 支持嵌套

    ```cpp
    n1::n2::num;
    ```

    ```cpp
    namespace n1
    {
        int num = 1;
        namespace n2
        {
            int num = 2;
            namespace n3
            {

            }
        }
    }
    ```

* 别名

    `namespace n123 = n1::n2::n3;`

### 2.2. inline

当函数被声明为内联函数之后, 编译器会将其<font color=#FF0000>内联展开</font>（类似宏展开）, 而不是按通常的函数调用机制进行调用.

内联是以代码膨胀（复制）为代价，<font color=#FF0000>仅仅省去了函数调用的开销</font>，从而提高函数的执行效率。只有当函数只有 10 行甚至更少时才将其定义为内联函数。

注意：inline的使用是有所限制的，inline只适合涵数体内代码简单的涵数使用，<font color=#FF0000>不建议包含复杂的结构控制语句，例如while、switch</font>，并且<font color=#FF0000>不能内联函数本身不能是直接递归函数</font>。

以下情况不宜使用内联：

1. 如果函数体内的代码比较长，使用内联将导致<font color=#FF0000>内存消耗代价</font>较高。
2. 如果函数体内出现循环，那么<font color=#FF0000>执行函数体内代码的时间要比函数调用的开销大</font>。

类的构造函数和析构函数容易让人误解成使用内联更有效。要当心构造函数和析构
函数可能会隐藏一些行为，如“偷偷地”执行了基类或成员对象的构造函数和析构函数。所以不要随便地将构造函数和析构函数的定义体放在类声明中。

inline函数仅仅是一个对编译器的建议，所以最后能否正常使用内联，看编译器的意思，编译器如果认为函数不复杂，能在调用点展开，就会真正内联，<font color=#FF0000>并不是说声明了内联编译时就接受内联</font>。声明内联函数<font color=#FF0000>只是建议而已</font>！

### 2.3. C++ 的结构

1. 不再需要 `typedef` ，在定义结构变量时，可以省略 `struct` 关键字
2. 成员可以是函数（成员函数），在成员函数中可以直接访问成员变量，不需要 `.` 或 `->` ，但是 C 的结构成员可以是函数指针
3. 有一些隐藏的成员函数（构造、析构、拷贝构造、赋值构造）
4. 可以继承，可以设置成员的访问权限（面向对象）

class和struct的区别？

* class的默认继承和访问权限是private，struct的默认继承和访问权限是public。
* class能做模板的参数，struct不行。

### 2.4. C++ 的联合

1. 不再需要 `typedef` ，在定义结构变量时，可以省略 `union` 关键字
2. 成员可以是函数（成员函数），在成员函数中可以直接访问成员变量，不需要 `.` 或 `->` ，但是 C 的结构成员可以是函数指针
3. 有一些隐藏的成员函数（构造、析构、拷贝构造、赋值构造）

### 2.5. C++ 的枚举

1. 与 C 语言基本一致。
2. 类型检查比 C 语言更严格

### 2.6. C++ 的布尔类型

1. C++ 具有真的布尔类型，bool 是 C++ 中的关键字，在 C 语言中使用布尔类型需要导入头文件 stdbool.h（在 C11 中 bool 应该是数据类型了）。
2. 在 C++ 中 true false 是关键字，而在 C 语言中不是。
3. 在 C++ 中 true false 是 1 字节，而 C 语言中是 4 字节。

### 2.7. C++ 的 void*

1. C 语言中 `void*` 可以与<font color=#FF0000>任意类型指针</font>自动转换。
2. C++ 中 `void*`

    不能给其他类型的指针直接赋值，必须强制类型转换，但其他类型的指针可以自动给 `void *` 赋值。

3. C++ 为什么这样修改 `void*` ？

    为了更安全，所以 C++ 类型检查更严格。

## 3. 头文件.h与源文件.cpp

<font color=#FF0000>const常量，inline函数，static函数都可以在头文件中定义。</font>

### 3.1. 函数

* 普通函数

    * 只能在cpp中定义；
    * 头文件中可以声明，不可以定义；
    * 其他文件中用到的时候要先声明一下（可以用extern关键字，也可以不用）；
    * 若写在命名空间外面，则为全局作用域。但函数的参数的default值只具有文件作用域，且在一个文件中同一个参数只能声明一次default值。

* static函数

    可以在任何文件定义，但在cpp中定义的静态函数对于其他文件不可见，而在头文件中定义的静态函数在包含该头文件的文件中可见（static函数具有文件作用域）。

* 内联函数

    <font color=#FF0000>最好只在头文件中定义。</font>因为同一原形（实现可能不同）的内联函数可以在不同的cpp中重复定义，但是编译器会把这些原形看作一个内联函数，因此运行时会出现不确定现象。放在头文件中可以避免这种情况。而且放在cpp中的内联方法对于其他文件是不可见的。

### 3.2. 类

类一般只在头文件中定义，在cpp中实现其成员方法的定义。

类中的成员包括：普通成员方法， static成员方法，普通成员变量，static成员变量，const成员变量，static const成员变量等。

* 普通成员方法

    - 类内部声明
    - 可以在“类内部/头文件中的类外部”定义<font color=#FF0000>（均看作 `inline` ）</font>
    - 也可以放在cpp中定义（非inline）

* static成员方法

    - 类内部声明
    - 可以在“类内部/cpp中”定义

    ps: 在类外部定义的时候要去掉static关键字，因为类里面的static表示该成员属于类，而文件中的static表示文件作用域，这是完全两回事。

* 普通成员变量

    - 类内部声明和定义
    - ~~只能在构造函数的初始化列表中初始化~~
    - C++98
        + 对于*静态类型并且是常量类型，同时是枚举或者是整型的变量*可以使用 `=` 在声明时初始化。
        + 对于不符合上述要求的*静态变量*可以在类外使用 `=` 进行初始化
        + 非静态类型可以在初始化列表进行初始化
            * 使用 `()` 对自定义类型进行初始化
            * 使用 `{}` 对元素集合统一初始化
    - C++11可以使用 `=` 或者 `{}` 就地初始化，类似于Java语言

        ```cpp
        struct init{
            int a = 1;
            double b{1.2};
        };
        ```

        需要注意的是=和{}可以和初始化列表一起使用，而且<font color=#FF0000>初始化列表总是后作用于=和{}</font>

    - 用户可以不进行初始化（编译器将默认构造）

### 3.3. 类外的变量

* const常量

    * 可以在头文件/cpp中定义，且<font color=#FF0000>定义时必须初始化</font>；
    对于编译时期可以直接用文字来替换使用到的该常量的情况（例如：const int/float等），最好在头文件中定义；
    * 但有些情况（如 `const int *ptr = new int[5]` ），最好在cpp中定义，因为动态空间只有运行时才能确定，编译器并不能用常量值直接代替ptr；且头文件在多处被引用后可能带来内存泄露、异常行为等。
    * <font color=#FF0000>const在C++中具有文件作用域。在C中不是。</font>

* 全局变量

    * 只能在cpp中定义；
    * 头文件和其他文件中可以声明（需要extern关键字），不可以定义；
    * 其他文件中用到的时候必须先声明extern一下。

* 静态全局变量

    * 可以在任何文件中定义，但是该变量只有文件作用域，即只在定义它的源文件中可见，其他源文件既不能声明也不能使用该变量（因为它对于其他文件不可见）。
    * 当然，如果是在头文件中定义的，则任何包含该头文件的文件都可以使用该静态全局变量。

## 4. class

### 4.1. 类成员的初始化

#### 4.1.1. C++98

类对象的构造顺序是这样的：

1. 分配内存，调用构造函数时，隐式/显示的初始化各数据成员
2. 执行构造函数：
    1. <font color=#FF0000>类里面的任何成员变量在定义时是不能初始化的</font>
    2. 一般的数据成员可以在构造函数中初始化
    3. <font color=#FF0000>const数据成员必须在构造函数的初始化列表中初始化</font>
    4. <font color=#FF0000>static要在类的定义外面初始化</font>
    5. <font color=#FF0000>数组成员是不能在初始化列表里初始化的</font>
    6. 不能给数组指定明显的初始化

C++里面是不能定义常量数组的！因为3和5的矛盾。

#### 4.1.2. C++11

```cpp
int j = 15;

class Bclass{
    int f = 100;
    float g = 200.0;
    const float h = 30.0;
    const int a=10;
    // const int array[20];  // 编译报错
    // int thesecondarray[20] = { 0 };  // 编译报错
    int &b=j;
    int &k = f;
    static int c;
    static const int d=30;
    static const float e;

public:
    Bclass() = default;
};

int Bclass::c = 20;
const float Bclass::e = 40.0;
```

基本类型都可以在类内初始化。

* const的int与float都能在类内初始化
* static只有 `static const int` 能在类内初始化，<font color=#FF0000>其他的static还是要在类外初始化</font>
* 引用可以在类内初始化
* <font color=#FF0000>数组（无论const）都不能在类内显示初始化</font>

### 4.2. 关于拷贝构造、赋值构造的建议

1. 缺省的拷贝构造、赋值构造函数不光会拷贝本类的数据，也会调用成员类对象和父类的拷贝构造和赋值构造，而不是单纯的按字节复制，因此尽量少用指针成员。
2. 在函数参数中，尽量使用类指针或引用来当参数（不要直接使用类对象），减少调用拷贝构造和赋值构造的机会，也可以降低数据传递的开销。
3. 如果由于特殊原因无法实现完整的拷贝构造、赋值构造，建议将它们私有化，防止误用。
4. 一旦为一个类实现了拷贝构造，那么也一定要实现赋值构造。

### 4.3. 虚继承
> [csdn: C++ 虚继承（虚基类表指针与虚基类表）](https://blog.csdn.net/qq_41885826/article/details/86566643)

虚继承是解决C++多重继承问题的一种手段，从不同途径继承来的同一基类，会在子类中存在多份拷贝。这将存在两个问题：其一，浪费存储空间；第二，存在二义性问题，通常可以将派生类对象的地址赋值给基类对象，实现的具体方式是，将基类指针指向继承类（继承类有基类的拷贝）中的基类对象的地址，但是多重继承可能存在一个基类的多份拷贝，这就出现了二义性。

虚基类构造函数的参数必须由最新派生出来的类负责初始化（即使不是直接继承）：

* 虚基类的构造函数先于非虚基类的构造函数执行
* 虚基类构造优先级高
* 非虚基类布局优先于虚基类

### 4.4. 虚函数

#### 4.4.1. 虚函数表

什么是虚函数表，在C++的类中，一旦成员函数中有虚函数，这个类中就会多一个虚函数表指针，这个指针指向一个虚函数表，表里面记录了这个类中所有的虚函数，当这个类被继承，它的子类中也会有一个虚函数表（不管子类中有没有虚函数），如果子类的成员函数中有函数签名与父类的虚函数一样，就会用子类中的函数替换它在虚函数表中的位置，这样就达到了覆盖的效果。

当通过类指针或引用调用函数时，会根据对象中实际的虚函数表记录来调用函数，这样就达到了多态的效果。

多态类中的虚函数表建立在编译阶段。

已验证：每个类的实例时共享虚函数表的（参考：《[C++单个类的所有对象是否共享虚函数表的验证](https://blog.csdn.net/a_big_pig/article/details/78018194?depth_1-utm_source=distribute.pc_relevant.none-task&utm_source=distribute.pc_relevant.none-task)》），这有点类似于类成员变量。

### 4.5. 其他关键字

#### 4.5.1. decltype

decltype与auto关键字一样，用于进行编译时类型推导，不过它与auto还是有一些区别的。decltype的类型推导并不是像auto一样是从变量声明的初始化表达式获得变量的类型，而是总是以一个普通表达式作为参数，返回该表达式的类型,而且decltype并不会对表达式进行求值。

```cpp
int i = 4;
decltype(i) a; //推导结果为int。a的类型为int。
```

与using/typedef合用，用于定义类型。

```cpp
using size_t = decltype(sizeof(0));//sizeof(a)的返回值为size_t类型
using ptrdiff_t = decltype((int*)0 - (int*)0);
using nullptr_t = decltype(nullptr);
```

并不推荐以下方式，因为 `auto` 关键字更合适：

```cpp
vector<int> vec;
typedef decltype(vec.begin()) vectype;
for (vectype i = vec.begin; i != vec.end(); i++) {
    //...
}
```

泛型编程中结合auto，用于追踪函数的返回值类型（这也是decltype最大的用途了）。

```cpp
template <typename _Tx, typename _Ty>
auto multiply(_Tx x, _Ty y)->decltype(_Tx*_Ty) {
    return x*y;
}
```

decltype推导四规则

1. 如果e是一个没有带括号的标记符表达式或者类成员访问表达式，那么的decltype(e)就是e所命名的实体的类型。此外，如果e是一个被重载的函数，则会导致编译错误。
1. 否则 ，假设e的类型是T，如果e是一个将亡值，那么decltype(e)为 `T&&`
1. 否则，假设e的类型是T，如果e是一个左值，那么decltype(e)为 `T&` 。
1. 否则，假设e的类型是T，则decltype(e)为 `T` 。

## 5. 其他

### 5.1. 宽字符与Unicode、UTF-8、多字节字符

宽字符是“中文”、“日文”等除ascii之外各种字符编码的统称。即用来表示需要多个字节来表示的数据类型。

`Unicode` 是宽字符编码的一种，已经被现代计算机指定为默认的编码方式。

所以，Windows系统中的宽字符，就是指的Unicode，虽然本质上Unicode只是宽字符的子集而已。

Unicode本质是字符集，在这个集合中的任意一个字符都可以用一个四字节来表示。

#### 5.1.1. UTF-8

UTF-8是编码规则，由于Unicode字符集的大部分常用字无需4字节表示（前2字节都是0），编码规则就是用不定长字节（可能2byte/3byte/4byte）表示一个变长的编码。

#### 5.1.2. 宽字符 与 多字节字符串

“你好”对应的 `Unicode` 分别为"U+4f60"和"U+597d”，对应的 `UTF-8` 编码分别为“0xe4 0xbd 0xa0”和“0xe5 0xa5 0xbd”。

多字节字符串在编译后的可执行文件以UTF-8编码保存：

```cpp
#include <stdio.h>
#include <string.h>

int main(void) {
    char s[] = "你好";
    size_t len = strlen(s);
    printf("len = %d\n", (int)len);  // 输出：len = 6
    printf("%s\n", s);
    return 0;
}
```

对编译后的可执行文件执行 `od` 命令，，可以发现"你好"以UFT-8编码保存，也就是“0xe4 0xbd 0xa0”和“0xe5 0xa5 0xbd”6个字节。

宽字符串在编译后可执行文件中以Unicode保存：

```cpp
#include <wchar.h>
#include <stdio.h>
#include <locale.h>

int main(void) {
    setlocale(LC_ALL, "zh_CN.UTF-8");  // 设置locale
    wchar_t s[] = L"你好";
    size_t len = wcslen(s);
    printf("len = %d\n", (int)len);  // 输出：len = 2
    printf("%ls\n", s);
    return 0;
}
```

对编译后的可执行文件执行 `od` 命令，发现宽字符串是按Unicode保存在可执行文件中的。

目前<font color=#FF0000>宽字符在内存中以Unicode进行保存</font>，但是<font color=#FF0000>要write到终端仍然需要以多字节编码输出</font>，这样终端驱动程序才能识别，所以printf在内部把宽字符串转换成多字节字符串，然后write出去。这个转换过程受locale影响，setlocale(LC_ALL, "zh_CN.UTF-8");设置当前进程的LC_ALL为zh_CN.UTF-8，所以printf将Unicode转成多字节的UTF-8编码，然后write到终端设备。如果将setlocale(LC_ALL, "zh_CN.UTF-8");改为setlocale(LC_ALL, en_US.iso88591):打印结果中将不会输出"你好"。

一般来说程序在内存计算时通常以宽字符编码，存盘或者网络发送则用多字节编码。

#### 5.1.3. 多字节字符串和宽字符串相互转换

c语言中提供了多字节字符串和宽字符串相互转换的函数。

```cpp
#include <stdlib.h>
size_t mbstowcs(wchar_t *dest, const char *src, size_t n);  // 将多字节字符串转换为宽字符串
size_t wcstombs(char *dest, const wchar_t *src, size_t n);  // 将宽字符串转换为多字节字符串
```

Demo如下：

```cpp
#include <locale.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <wchar.h>
#include <string.h>

wchar_t* str2wstr(const char const* s) {
    const size_t buffer_size = strlen(s) + 1;
    wchar_t* dst_wstr = (wchar_t *)malloc(buffer_size * sizeof (wchar_t));
    wmemset(dst_wstr, 0, buffer_size);
    mbstowcs(dst_wstr, s, buffer_size);
    return dst_wstr;
}

void printBytes(const unsigned char const* s, int len) {
    for (int i = 0; i < len; i++) {
        printf("0x%02x ", *(s + i));
    }
    printf("\n");
}

int main () {
    char s[10] = "你好";          //内存中对应0xe4 0xbd 0xa0 0xe5 0xa5 0xbd 0x00
    wchar_t ws[10] = L"你好";  //内存中对应0x60 0x4f 0x00 0x00 0x7d 0x59 0x00 0x00 0x00 0x00 0x00 0x00

    printf("Locale is: %s\n", setlocale(LC_ALL, "zh_CN.UTF-8")); //Locale is: zh_CN.UTF-8
    printBytes(s, 7);       //0xe4 0xbd 0xa0 0xe5 0xa5 0xbd 0x00
    printBytes((char *)ws, 12);  //0x60 0x4f 0x00 0x00 0x7d 0x59 0x00 0x00 0x00 0x00 0x00 0x00

    printBytes((char *)str2wstr(s), 12); //0x60 0x4f 0x00 0x00 0x7d 0x59 0x00 0x00 0x00 0x00 0x00 0x00

    return(0);
}
```

编译后，执行结果如下：

```sh
Locale is: zh_CN.UTF-8
0xe4 0xbd 0xa0 0xe5 0xa5 0xbd 0x00
0x60 0x4f 0x00 0x00 0x7d 0x59 0x00 0x00 0x00 0x00 0x00 0x00
0x60 0x4f 0x00 0x00 0x7d 0x59 0x00 0x00 0x00 0x00 0x00 0x00
```

第二行输出也印证了我们之前说的多字节字符串在内存中以UTF-8存储，"0xe4 0xbd 0xa0 0xe5 0xa5 0xbd"正是"你好"的UTF-8编码。

第三行输出印证了之前说的宽字符串在内存中以Unicode存储，"0x60 0x4f 0x00 0x00 0x7d 0x59 0x00 0x00"正好是宽字符串L"你好"对应的Unicode。

 `setlocale(LC_ALL, "zh_CN.UTF-8")` 设置locale，程序将以UTF-8解码宽字符串。调用 `mbstowcs()` 后，可以看到“你好”的 `UTF-8` 编码 "0xe4 0xbd 0xa0 0xe5 0xa5 0xbd 0x00"确实被转换成了“你好”对应的 `Unicode` : "0x60 0x4f 0x00 0x00 0x7d 0x59 0x00 0x00 0x00 0x00 0x00 0x00"。

如果将 `setlocale(LC_ALL, "zh_CN.UTF-8")` 换成 `setlocale(LC_ALL, "en_US.iso88591 ");` 那么最后一行的输出也就会不一样。

### 5.2. 宏定义

#### 5.2.1. #ifndef: 避免重复包含头文件
```cpp
#ifndef MONGOOSE_HEADER_INCLUDED
#define MONGOOSE_HEADER_INCLUDED

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/*.................................
 * do something here
 *.................................
 */

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* MONGOOSE_HEADER_INCLUDED */
```

### 5.3. extern "C"
> [博客园：C++项目中的extern "C" {}](https://www.cnblogs.com/outs/p/9388802.html)

按照C语言的方式声明函数。

典型的，一个C++程序包含其它语言编写的部分代码。类似的，C++编写的代码片段可能被使用在其它语言编写的代码中。不同语言编写的代码互相调用是困难的，甚至是同一种编写的代码但不同的编译器编译的代码。例如，不同语言和同种语言的不同实现可能会在注册变量保持参数和参数在栈上的布局，这个方面不一样。

为了使它们遵守统一规则，可以使用extern指定一个编译和连接规约。例如，声明C和C++标准库函数strcyp()，并指定它应该根据C的编译和连接规约来链接：

```cpp
extern "C" char* strcpy(char*,const char*);
```

注意它与下面的声明的不同之处：

```c
extern char* strcpy(char*,const char*);
```

下面的这个声明仅表示在连接的时候调用strcpy()。

注意：extern "C"指令中的C，表示的一种编译和连接规约，而不是一种语言。C表示符合C语言的编译和连接规约的任何语言，如Fortran、assembler等。

extern "C"指令仅指定编译和连接规约，但不影响语义。例如在函数声明中，指定了extern "C"，仍然要遵守C++的类型检测、参数转换规则。

#### 5.3.1. C中调用C++的代码

cppHeader.h

```cpp
#ifndef CPP_HEADER
#define CPP_HEADER

extern "C" void print(int i);

#endif CPP_HEADER
```

cppHeader.cpp

```cpp
#include "cppHeader.h"

#include <iostream>
using namespace std;

void print(int i)
{
    cout<<"cppHeader "<<i<<endl;
}
```

在C的代码文件c.c中调用print函数：

```cpp
// extern void print(int i);  // 声明调用函数
#include "cppHeader.h"

int main(int argc,char** argv)
{
    print(3);
    return 0;
}
```

注意在C的代码文件中直接#include "cppHeader.h"头文件，编译出错。
