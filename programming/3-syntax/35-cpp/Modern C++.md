<!--
+++
title       = "Modern C++"
description = "1. auto 关键字; 2. 智能指针（smart pointers）; 3. std::string & std::string_view; 4. 标准库增加的函数; 5. for 循环的新句式; 6. constexpr 表达式：替换老式的宏定义; 7. 类成员的内部初始化; 8. 统一风格的初始化; 9. Lambda expressions; 10. Exceptions 异常; 11. std::atomic 原子类型对象"
date        = "2022-01-03"
tags        = ["usual"]
categories  = ["3-syntax","35-cpp"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

> [microsoft: Modern C++](https://docs.microsoft.com/zh-cn/cpp/cpp/welcome-back-to-cpp-modern-cpp)
>
> [现代C++教程：快速上手C++11/14/17/20](https://changkun.de/modern-cpp/zh-cn/00-preface/)

[TOC]

---

## 1. auto 关键字

## 2. 智能指针（smart pointers）

To support easy adoption of RAII principles, the C++ Standard Library provides three smart pointer types:

* std::unique_ptr
* std::shared_ptr
* std::weak_ptr

## 3. std::string & std::string_view

## 4. 标准库增加的函数

Here are some important examples:

* `for_each` , the default traversal algorithm (along with range-based for loops).
* `transform` , for not-in-place modification of container elements
* `find_if` , the default search algorithm.
* `sort` , lower_bound, and the other default sorting and searching algorithms.

```cpp
auto comp = [](const widget& w1, const widget& w2)
     { return w1.weight() < w2.weight(); }
sort( v.begin(), v.end(), comp );
auto i = lower_bound( v.begin(), v.end(), comp );
```

```cpp
int value {5};
auto iter1 = std::find_if(std::begin(numbers), std::end(numbers),[value](int n) { return n > value; });
if(iter1 != std::end(numbers))
    std::cout << *iter1 << " was found greater than " << value << ".\n";
```

如op的一个实现 即将[first1, last1]范围内的每个元素加5，然后依次存储到result中。

```cpp
int op_increase(int i) {return (i + 5)};
```

调用std::transform的方式如下：

```cpp
std::transform(first1, last1, result, op_increase);
```

## 5. for 循环的新句式

```cpp
#include <iostream>
#include <vector>

int main(){
    std::vector<int> v {1,2,3};

    // C-style
    for(int i = 0; i < v.size(); ++i){
        std::cout << v[i];
    }

    // Modern C++:
    for(auto x : v)  std::cout << x;
    for(auto& x : v)  ++x;  // 使用引用，方便我们修改容器中的数据
}
```

## 6. constexpr 表达式：替换老式的宏定义

```cpp
#define SIZE 10  // C-style
constexpr int size = 10;  // modern C++
```

## 7. 类成员的内部初始化

C++11的基本思想是，允许非静态（non-static）数据成员在其声明处（在其所属类内部）进行初始化。这样，在运行时，需要初始值时构造函数可以使用这个初始值（<font color=#FF0000>解决了C++0x之前非常蹩脚的一个初始化形式，尤其对 `const char*` 和 C类型数组</font>）。

```cpp
class A {
public:
    int a = 7;
};
```

## 8. 统一风格的初始化

在现代C ++中，可以对任何类型使用括号初始化。当初始化数组，向量或其他容器时，这种形式的初始化特别方便。在以下示例中，v2使用的三个实例初始化S。v3用三个实例初始化，而这三个实例S本身都用花括号初始化。编译器根据的声明类型推断每个元素的类型v3。

```cpp
#include <vector>

struct S{
    std::string name;
    float num;
    S(std::string s, float f) : name(s), num(f) {}
};

int main(){
    // C-style initialization
    std::vector<S> v;
    S s1("Norah", 2.7);
    S s2("Frank", 3.5);
    S s3("Jeri", 85.9);

    v.push_back(s1);
    v.push_back(s2);
    v.push_back(s3);

    // Modern C++:
    std::vector<S> v2 {s1, s2, s3};

    // or...
    std::vector<S> v3{ {"Norah", 2.7}, {"Frank", 3.5}, {"Jeri", 85.9} };
}
```

### 8.1. C++17: Aggregate（聚合初始化）

在c++中初始化对象的一种方法是聚合初始化，它允许使用花括号从多个值初始化：

```cpp
struct Data
{
    std::string name;
    double value;
};

Data x{"test1", 6.778};
```

在c++ 17中聚合可以有基类，所以对于从其他类/结构派生的结构，允许初始化列表：

```cpp
struct MoreData : Data
{
    bool done;
};

MoreData y{{"test1", 6.778}, false};
```
## 9. Lambda expressions
> [microsoft: C++异常和错误处理的最佳实践](https://docs.microsoft.com/zh-cn/cpp/cpp/errors-and-exception-handling-modern-cpp?view=vs-2019)

```cpp
std::vector<int> v {1,2,3,4,5};
int x = 2;
int y = 4;
auto result = find_if(begin(v), end(v), [=](int i) { return i > x && i < y; });
```

c++ 17还引入了一个新的类型 `std::is_aggregate` 来测试一个类型是否是一个聚合:

```cpp
template<typename T>
struct D : std::string, std::complex<T>
{
    std::string data;
};

D<float> s{{"hello"}, {4.5,6.7}, "world"};  // OK since C++17
std::cout << std::is_aggregate<decltype(s)>::value;  // outputs: 1 (true)
```

## 10. Exceptions 异常

```cpp
#include <stdexcept>
#include <limits>
#include <iostream>

using namespace std;

void MyFunc(int c){
    if (c > numeric_limits<char> ::max())
        throw invalid_argument("MyFunc argument too large.");
    //...
}

int main(){
    try{
        MyFunc(256); //cause an exception to throw
    }catch (invalid_argument& e){
        cerr << e.what() << endl;
        return -1;
    }
    //...
    return 0;
}
```

### 10.1. 基本指导原则

强大的错误处理对于任何编程语言都很有挑战性。 尽管异常提供了多个支持良好错误处理的功能，但它们无法为你完成所有工作。 若要实现异常机制的优点，请在设计代码时记住异常。

* 使用断言来检查绝不应发生的错误。 使用异常来检查可能出现的错误，例如，公共函数参数的输入验证中的错误。 有关详细信息，请参阅 "异常与断言" 一节。
* 当处理错误的代码可能与通过一个或多个干预函数调用检测到错误的代码分离时，请使用异常。 当处理错误的代码与检测到错误的代码紧密耦合时，考虑是否使用错误代码而不是在性能关键循环中。
* 对于可能引发或传播异常的每个函数，请提供以下三种异常保证之一：强保障、基本保证或 nothrow（noexcept）保障。 有关详细信息，请参阅如何：设计异常安全性。
* 按值引发异常，按引用来捕获异常。 不要捕获无法处理的内容。
* 不要使用异常规范，后者在 C++ 11 中弃用。有关详细信息，请参阅标题为异常规范和 `noexcept` 的部分。
* 应用时使用标准库异常类型。从异常类层次结构派生自定义异常类型。
* 不允许对析构函数或内存释放函数进行转义。

## 11. std::atomic 原子类型对象

Use the C++ Standard Library `std::atomic` struct and related types for inter-thread communication mechanisms.
