<!--
+++
title       = "pudb: python的调试工具"
description = "1. 快捷键; 2. 启动方式; 3. 具体功能介绍哦"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","14-command"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200930214638328-853472737.jpg) <!-- pudb/pudb-1.jpg -->

## 1. 快捷键
> [cnblog: Python的调试器pudb简易教程](https://www.cnblogs.com/journeyonmyway/p/5892560.html)

界面下按?就能出来快捷键列表。

最常用的快捷键，应该是如下几个：

+ 移动光标
    + H - move to current line # 移动到当前行(栈底)
    + u - move up one stack frame # 移动到栈的上一行
    + d - move down one stack frame # 移动到栈的下一行
    + `j/k` - up/down
    + `Ctrl-u/d` - page up/down
    + `h/l` - scroll left/right
    + `g/G` - start/end
    + L - go to line # 跳到指定行
+ 运行
    * n - step over ("next") # 运行到下一行
    * s - step into # 运行进函数
    * c - continue # 继续运行
    * t - run to cursor # 运行到光标处
    * `r/f` - finish current function # 结束当前函数
+ 界面切换
    * C - focus code # 聚焦在代码窗口
    * o - show console/output screen # 显示命令行屏幕(回车返回pudb)
    * V - focus variables # 聚焦在变量窗口
    * S - focus stack # 聚焦在栈窗口
    * B - focus breakpoint list # 聚焦在断点列表窗口
    + `t/r/s/c` - show type/repr/str/custom for this variable # 切换type/repr/str/custom
    + `/` - search
    + `,/.` - search next/previous # 查找下一个/上一个
    * `?/H` - show this help screen # 显示帮助窗口
    * `Ctrl+n/p` - browse command line history # 浏览命令行历史
+ b - toggle breakpoint # 打断点/取消断点
+ m - open module # 打开python模块

## 2. 启动方式

pdb有2种用法：

1. 非侵入式方法（不用额外修改源代码，在命令行下直接运行就能调试）

    ```
    python3 -m pdb filename.py
    ```

2. 侵入式方法（需要在被调试的代码中添加一行代码然后再正常运行代码）

    ```
    import pdb; pdb.set_trace()
    ```

## 3. 具体功能介绍哦
> [简书: 10分钟教程掌握Python调试器pdb](https://www.jianshu.com/p/01e76c5208f7)

### 3.1. 查看源代码

```py
l
```

查看当前位置前后11行源代码（多次会翻页）

```py
ll
```

查看当前函数或框架的所有源代码

### 3.2. 添加断点

```py
b
b lineno
b filename:lineno
b functionname
```

1. 不带参数表示查看断点设置
2. 带参则在指定位置设置一个断点

### 3.3. 添加临时断点

```py
tbreak
tbreak lineno
tbreak filename:lineno
tbreak functionname
```

执行一次后时自动删除（这就是它被称为临时断点的原因）

### 3.4. 清除断点

```py
cl
cl filename:lineno
cl bpnumber [bpnumber ...]
```

1. 不带参数用于清除所有断点，会提示确认（包括临时断点）
2. 带参数则清除指定文件行或当前文件指定序号的断点

### 3.5. 打印变量值

```py
p expression
```

### 3.6. 非逐行调试命令

```py
unt lineno
```

持续执行直到运行到指定行（或遇到断点）

```py
j lineno
```

直接跳转到指定行（注意，被跳过的代码不执行）

### 3.7. 查看函数参数


```py
a
```

在函数中时打印函数的参数和参数的值

### 3.8. 打印变量类型

```py
whatis expression
```

打印表达式的类型，常用来打印变量值

### 3.9. 启动交互式解释器

```py
interact
```

启动一个python的交互式解释器，使用当前代码的全局命名空间（使用ctrl+d返回pdb）

### 3.10. 打印堆栈信息

```py
w
```

打印堆栈信息，最新的帧在最底部。箭头表示当前帧。
