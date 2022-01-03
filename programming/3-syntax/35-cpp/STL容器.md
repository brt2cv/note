<!--
+++
title       = "STL容器操作"
description = "1. 通用算法; 2. 数组; 3. Vector; 4. List; 5. Tuple; 6. Pair; 7. Sets / Multiset; 8. Map / Multimap; 9. 无序容器; 10. Queue / PriorityQueue; 11. Stack; 12. Bitsets; 13. std::array"
date        = "2022-01-03"
tags        = ["usual"]
categories  = ["3-syntax","35-cpp"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

[TOC]

---

> [官网](http://www.cplusplus.com/reference/vector/vector/?kw=vector)

## 1. 通用算法



```cpp
#include <functional>

greater<int>()

```


```cpp
#include <algorithm>

sort(vec.begin(), vec.end(), greater<int>());
find(vec.begin(), vec,end(), const val);
count(first, last, val);
remove(first, last, val);
```

list.sort()

## 2. 数组

int a[] = {1, 2, 3, 4, 5, 5};

## 3. Vector

构造函数

```cpp
* vector<datatype> a;  //empty vector
* vector<datatype> b (no of elements, value of each element); //fixed number of elements with default value
* vector<datatype> c (starting iterator/pointer,ending iterator/pointer); //inserting elements from other data structures
* vector<datatype> d (name of vector to be copied);
* vector<vector<datatype> > matrix(no of rows,vector<datatype>(no of coloumn,default value))  //Declaring a 2D array
```

> vector<int> array{1,2,3,4};
>
> 注意： `vector<datatype> v[10];` , following declaration isn't a vector with 10 elements but an array of size ten having vector elements.

methods:

* at(index)  # 等同于 "[]" operator
* clear()
* push_back(item)
* pop_back()
* front()
* back()
* empty()
* size()
* resize(n)

## 4. List

methods:

* front()
* back()
* begin()
* end()
* rbegin()
* rend()
* empty()
* size()
* resize()
* max_size()
---
* push_back()
* push_front()
* insert()  # 任意位置插入
* pop_back()
* pop_front()
* clear()
* erase()  # 删除一个元素或一个区域的元素(两个重载)
* remove()  # 删除链表中匹配值的元素(匹配元素全部删除)
* remove_if()  # 删除条件满足的元素(遍历一次链表)，参数为自定义的回调函数
---
* reverse()
* sort()
* merge()
* splice()
* swap()
* unique()

### 4.1. deque

`emplace_back()` 和 `push_back()` 的区别：

+ 相同点：两者都是向容器内添加数据
+ 不同点：当数据为类的对象时，emplace_back相对push_back可以避免额外的移动和复制操作。

### 4.2. std::forward_list

std::forward_list 是一个列表容器，使用方法和 std::list 基本类似，因此我们就不花费篇幅进行介绍了。

需要知道的是，和 std::list 的双向链表的实现不同，std::forward_list 使用单向链表进行实现， 提供了 O(1) 复杂度的元素插入，不支持快速随机访问（这也是链表的特点）， 也是标准库容器中唯一一个不提供 size() 方法的容器。<font color=#FF0000>当不需要双向迭代时，具有比 std::list 更高的空间利用率。</font>

## 5. Tuple

构造函数

```cpp
* tuple <char, int, float> gk;
* tuple <int,char,float> tup1(20,'g',17.5);
* tuple <char, int, float> gk2 = make_tuple('a', 10, 15.5);

int len_tuple = tuple_size<decltype(gk)>::value;
tie(i_val,ch_val,f_val) = tup1;
```

method:

* get()  # get<0>(gk)
* make_tuple()
* tuple_size
* swap()
* tie()
* tuple_cat()

std::get 除了使用常量获取元组对象外，C++14 增加了使用类型来获取元组中的对象：

```cpp
std::tuple<std::string, double, double, int> t("123", 4.5, 6.7, 8);
std::cout << std::get<std::string>(t) << std::endl;
std::cout << std::get<double>(t) << std::endl; // 非法, 引发编译期错误
std::cout << std::get<3>(t) << std::endl;
```

### 5.1. 运行期索引

如果你仔细思考一下可能就会发现上面代码的问题，`std::get<>` 依赖一个编译期的常量，所以下面的方式是不合法的：

```cpp
int index = 1;
std::get<index>(t);
```

那么要怎么处理？答案是，使用 `std::variant<>`（<font color=#FF0000>C++ 17 引入</font>），提供给 variant<> 的类型模板参数 可以让一个 variant<> 从而容纳提供的几种类型的变量（在其他语言，例如 Python/JavaScript 等，表现为动态类型）：

```cpp
#include <variant>
template <size_t n, typename... T>
constexpr std::variant<T...> _tuple_index(const std::tuple<T...>& tpl, size_t i) {
    if constexpr (n >= sizeof...(T))
        throw std::out_of_range("越界.");
    if (i == n)
        return std::variant<T...>{ std::in_place_index<n>, std::get<n>(tpl) };
    return _tuple_index<(n < sizeof...(T)-1 ? n+1 : 0)>(tpl, i);
}
template <typename... T>
constexpr std::variant<T...> tuple_index(const std::tuple<T...>& tpl, size_t i) {
    return _tuple_index<0>(tpl, i);
}
template <typename T0, typename ... Ts>
std::ostream & operator<< (std::ostream & s, std::variant<T0, Ts...> const & v) {
    std::visit([&](auto && x){ s << x;}, v);
    return s;
}
```

这样我们就能：

```cpp
int i = 1;
std::cout << tuple_index(t, i) << std::endl;
```

### 5.2. 元组合并

还有一个常见的需求就是合并两个元组，这可以通过 std::tuple_cat 来实现：

auto new_tuple = std::tuple_cat(get_student(1), std::move(t));

### 5.3. 元祖遍历

我们刚才介绍了如何在运行期通过非常数索引一个 tuple 那么遍历就变得简单了， 首先我们需要知道一个元组的长度，可以：

```cpp
template <typename T>
auto tuple_len(T &tpl) {
    return std::tuple_size<T>::value;
}
```

这样就能够对元组进行迭代了：

```cpp
// 迭代
for(int i = 0; i != tuple_len(new_tuple); ++i)
    // 运行期索引
    std::cout << tuple_index(i, new_tuple) << std::endl;
```

## 6. Pair

构造方法：

```cpp
* pair <data_type1, data_type2> Pair_name (value1, value2);
* pair <data_type1, data_type2> g1;  //default
* pair <data_type1, data_type2> g2(1, 'a');  //initialized,  different data type
* pair <data_type1, data_type2> g3(1, 10);  //initialized,  same data type
* pair <data_type1, data_type2> g4(g3);  //copy of g3
```

> `Pair<string, int> xxx = make_pair(key, value);`

methods:

* operators(=, ==, !=, >=, <=)
* swap()

## 7. Sets / Multiset

二者的区别：

Set集合中一个值只能出现一次，而Multiset中一个值可以出现多次。

```cpp
int a[] = {1, 2, 3, 4, 5, 5};
set<int> s2 (a, a + 6);  // s2 = {1, 2, 3, 4, 5}
set<int> s4 (s3.begin(), s3.end());
```

method:

* insert()
* erase()

---

* begin()
* end()
* clear()
* count()
* empty()
* find()
* size()
* contains (C++20) 检查容器是否含有带特定键的元素

### 7.1. std::unordered_set / std::unordered_multiset

## 8. Map / Multimap
> [homepage](http://www.cplusplus.com/reference/map/map/?kw=map)

```cpp
std::map<int, string> dict = {
    {0, "ahts"},
    {1, "1234"}
};
```

method:

```cpp
map<char, int> map_b(map_a.begin(), map_a.end());
map_a.insert(pair<char, int>('a', 502));
map_a['a'] = 10;
cout << map_a['b'];
cout << map_a.at('b');
map_a.find('b');
map_a.erase('b');
```

#### 8. hash_map

虽然hash_map和map都是STL的一部分，但是目前的C++标准（C++11）中只有map而没有hash_map，可以说STL只是部分包含于目前的C++标准中。主流的GNU C++和MSVC++出于编译器扩展的目的实现了hash_map。

hash_map是一种将对象的值data和键key关联起来的哈希关联容器（Hashed Associative Container），而map是一种将对象的值data和键key关联起来的排序关联容器（Sorted Associative Container）。所谓哈希关联容器是使用hash table实现的关联容器，它不同于一般的排序关联容器：哈希关联容器的元素没有特定的顺序，大部分操作的最差时间复杂度为O(n)，平均时间复杂度为常数，所以在不要求排序而只要求存取的应用中，哈希关联容器的效率要远远高于排序关联容器。

map的底层是用红黑树实现的，操作的时间复杂度是O(log(n))级别；hash_map的底层是用hash table实现的，操作的时间复杂度是常数级别。

在元素数量达到一定数量级时如果要求效率优先，则采用hash_map。但是注意：虽然hash_map 操作速度比map的速度快，但是hash函数以及解决冲突都需要额外的执行时间，且hash_map构造速度慢于map。其次，hash_map由于基于hash table，显然是空间换时间，因此hash_map对内存的消耗高于map。所以选择时需要权衡三个因素：速度，数据量，内存。

### 8.1. std::unordered_map / std::unordered_multimap

## 9. 无序容器

我们已经熟知了传统 C++ 中的有序容器 `std::map` / `std::set` ，这些元素内部通过 **红黑树** 进行实现， 插入和搜索的平均复杂度均为 `O(log(size))` 。在插入元素时候，会根据 `<` 操作符比较元素大小并判断元素是否相同， 并选择合适的位置插入到容器中。当对这个容器中的元素进行遍历时，输出结果会按照 `<` 操作符的顺序来逐个遍历。

而无序容器中的元素是不进行排序的，内部通过*哈希表*实现，插入和搜索元素的平均复杂度为 `O(constant)` ， 在不关心容器内部元素顺序时，<font color=#FF0000>能够获得显著的性能提升</font>。

C++11 引入了两组无序容器： `std::unordered_map` / `std::unordered_multimap` 和 `std::unordered_set` / `std::unordered_multiset` 。

它们的用法和原有的 std::map/std::multimap/std::set/set::multiset 基本类似， 由于这些容器我们已经很熟悉了，便不再举例了。

## 10. Queue / PriorityQueue

methods:

* push()
* pop()
* front()
* empty()
* size()
* emplace()
* swap()

> A priority queue is a container that provides constant time extraction of the largest element.
>
> In a priority queue, an element with high priority is served before an element with low priority.
>
> All insertion / deletion operations takes place in Logarithmic time.

queue：底层为deque/list，封闭头部，不使用vector作为底层的原因是vector扩容耗时。

## 11. Stack

methods:

* push()
* pop()
* top()  # Returns a reference to the top most element of the stack
* empty()
* size()

底层为deque/list，封闭头部，不使用vector作为底层的原因是vector扩容耗时。

## 12. Bitsets
> https://github.com/kjsce-codecell/standard-library-in-x/blob/master/cpp/containers/bitsets.md

## 13. std::array

看到这个容器的时候肯定会出现这样的问题：

* 为什么要引入 std::array 而不是直接使用 std::vector

    与 std::vector 不同，std::array 对象的大小是<font color=#FF0000>固定的</font>，如果容器大小是固定的，那么可以优先考虑使用 std::array 容器。

    另外由于 std::vector 是自动扩容的，当存入大量的数据后，并且对容器进行了删除操作， 容器并不会自动归还被删除元素相应的内存，这时候就需要手动运行 shrink_to_fit() 释放这部分内存。

* 已经有了传统数组，为什么要用 std::array

    使用 std::array 能够让代码变得更加“现代化”，而且封装了一些操作函数，比如获取数组大小以及检查是否非空，同时还能够友好的使用标准库中的容器算法，比如 std::sort。

### 13.1. std::array 的使用

```cpp
std::array<int, 4> arr = {1, 2, 3, 4};

arr.empty(); // 检查容器是否为空
arr.size();  // 返回容纳的元素数

// 迭代器支持
for (auto &i : arr)
{
    // ...
}

// 用 lambda 表达式排序
std::sort(arr.begin(), arr.end(), [](int a, int b) {
    return b < a;
});

// 数组大小参数必须是常量表达式
constexpr int len = 4;
std::array<int, len> arr = {1, 2, 3, 4};

// 非法,不同于 C 风格数组，std::array 不会自动退化成 T*
// int *arr_p = arr;
```

### 13.2. 兼容 C 风格的接口

```cpp
void foo(int *p, int len) {
    return;
}

std::array<int, 4> arr = {1,2,3,4};

// C 风格接口传参
// foo(arr, arr.size()); // 非法, 无法隐式转换
foo(&arr[0], arr.size());
foo(arr.data(), arr.size());

// 使用 `std::sort`
std::sort(arr.begin(), arr.end());
```
