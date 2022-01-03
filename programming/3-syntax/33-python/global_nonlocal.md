<!--
+++
title       = "Python语法: global变量的调用、改写与nonlocal关键字"
description = "1. `import aaa; aaa.T = new_value` 方式改写全局变量; 2. `from aaa import T` 载入全局变量; 3. 命名空间; 4. `nonlocal` 关键字"
date        = "2021-12-21"
tags        = []
categories  = ["3-syntax","33-python"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. `import aaa; aaa.T = new_value` 方式改写全局变量

aaa：

```py
T = 20

def test():
    print("模块aaa的函数：print T = {}; id(T)= {}".format(T, id(T)))
```

bbb：

```py
import aaa

print("aaa模块中的全局变量 T = {}; id(T)= {}".format(aaa.T, id(aaa.T)))

aaa.T = 5
print("bbb中改写全局变量 T = {}; id(T)= {}".format(aaa.T, id(aaa.T)))

aaa.test()
```

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200617141852550-993470967.png) <!-- global_nonlocal/keepng_global_nonlocal0.png -->

可见，在bbb中改写 aaa.T 时，变换了T对象的实体。

## 2. `from aaa import T` 载入全局变量

如果bbb中调用T的方式改一下呢：

```py
import aaa
from aaa import T

print("aaa模块中的全局变量 T = {}; id(T)= {}".format(T, id(T)))

T = 5
print("bbb中改写全局变量 T = {}; id(T)= {}".format(T, id(T)))

aaa.test()
```

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200617141852784-749642774.png) <!-- global_nonlocal/keepng_global_nonlocal1.png -->

则并不会重写T对象！

## 3. 命名空间

注意：不同的import方式，会导致module中的内容的命名空间不同~

* `from module_A import X` 会将该模块的函数/变量<font color=#FF0000>导入到当前模块的命名空间</font>中，无须用module_A.X访问了。
* `import module_A` modules_A本身被导入，但<font color=#FF0000>保存它原有的命名空间</font>，故得用module_A.X方式访问其函数或变量。

## 4. `nonlocal` 关键字

向闭包函数传递外部的局部变量，使用 `nonlocal name` 在inner() 中声明name对象。

global关键字修饰变量后标识该变量是全局变量，对该变量进行修改就是修改全局变量，而nonlocal关键字修饰变量后标识该变量是上一级函数中的局部变量，如果上一级函数中不存在该局部变量，nonlocal位置会发生错误（最上层的函数使用nonlocal修饰变量必定会报错）。

global关键字可以用在任何地方，包括最上层函数中和嵌套函数中，即使之前未定义该变量，global修饰后也可以直接使用，而<font color=#FF0000>nonlocal关键字只能用于嵌套函数中</font>，并且外层函数中定义了相应的局部变量，否则会发生错误。

```py
def TLV_header(self, body_size):
    TLV_format = "!"

    def setTLV(tag: str, int_type: str, value: int):
        nonlocal TLV_format

        unit_format = "Bc" + len_type
        TLV_format += unit_format
```
