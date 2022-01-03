<!--
+++
title       = "Python数制转换"
description = "1. 数制的表示法; 2. 复数属性和方法"
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

\ | 2进制 | 8进制 | 10进制 | 16进制
--|-----|-----|------|-----
2进制 - | bin(int(n,8)) | bin(int(n,10)) | bin(int(n,16))
8进制 oct(int(n,2)) | - | oct(int(n,10)) | oct(int(n,16))
10进制 | int(n,2) | int(n,8) | - | int(n,16)
16进制 | hex(int(n,2)) | hex(int(n,8)) | hex(int(n,10)) | -

## 1. 数制的表示法

* 0b: 表示2进制
* 0o: 表示8进制
* 0x: 表示16进制

### 1.1. 实例

### 1.2. 如何去除hex()、oct()函数转换出来的前缀字符（0x,b,0）

其他类型转换为2进制

```py
n = input()
print("{:b}".format(int(n,2)))
# 先将8进制的数转换为10进制，
# 然后在format的槽中添加一个b，等价于实现了bin函数的功能
# 但是此结果是不带有0b前缀的
```

其他类型转换为8进制

```py
print("{:o}".format(int(n,8)))
```

其他类型转换为16进制

```py
print("{:x}".format(int(n,16)))
```

## 2. 复数属性和方法

复数是由一个实数和一个虚数组合构成，表示为： `x+yj` 。其本质为一对有序浮点数 `(x,y)` ，其中 x 是实数部分，y 是虚数部分。

Python 语言中有关复数的概念：

1. 虚数不能单独存在，它们总是和一个值为 0.0 的实数部分一起构成一个复数
2. 复数由实数部分和虚数部分构成
3. 表示虚数的语法：real+imagej
4. 实数部分和虚数部分都是浮点数
5. 虚数部分必须有后缀j或J

```py
aa = 123-12j
print aa.real  # output 实数部分 123.0
print aa.imag  # output虚数部分 -12.0
```

复数的属性

* real(复数的实部)
* imag(复数的虚部)
* conjugate()（返回复数的共轭复数）

