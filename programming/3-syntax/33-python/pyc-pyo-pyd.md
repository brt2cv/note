<!--
+++
title       = "Python源码的编译与加密"
description = "1. pyc; 2. pyd"
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

> [cnblog: Python生成pyd文件](https://www.cnblogs.com/GavinSimons/p/8359284.html)

Python的脚本文件是开源的，量化策略的安全性没有保障。因此需要保护源码。那么要对Python代码进行混淆、加密保护。

+ 混淆代码，可以使用pyminifier。
+ 而加密处理，就比较麻烦。Python有py、pyc、pyw、pyo、pyd等文件格式。
    + 其中，pyc是二进制文件。但很容易被反编译。
    + pyw也不行，只是隐藏命令行界面而已，可以作为入口脚本。
    + pyo和pyc差不多，也容易被反编译。
    + 最后剩下pyd格式。

        pyd格式是D语言(C/C++综合进化版本)生成的二进制文件，实际也会是dll文件。该文件目前位置没找到可以被反编译的消息，只能被反汇编。Sublime text编辑器也是使用该格式。

## 1. pyc

### 1.1. 编译单独的pyc

对于py文件，可以执行下面命令来生成pyc文件,转化后的.pyc文件将在当前目录的__pycache__文件夹下.

```py
python -m compileall <dir>
```

另外一种方式是通过代码来生成pyc文件,同样转化后的.pyc文件将在当前目录的__pycache__文件夹下.

```py
import py_compile
py_compile.compile('/path/to/foo.py')
```

### 1.2. 批量编译pyc

```py
python -m compileall <dir>
```

针对一个目录下所有的py文件进行编译。python提供了一个模块叫 `compileall` ，具体请看下面代码：

```py
import compileall
compileall.compile_dir(r'/path')
```

## 2. pyd

pyd的本质是将python转换为 `*.c` 文件，然后编译为 `*.dll/*.so` 。

```sh
pip install Cython --install-option="--no-cython-compile"
```

或者自己下载安装：[https://pypi.python.org/pypi/Cython/](https://pypi.python.org/pypi/Cython/)

写一个测试用的py文件 `my_module.py` :

```py
def test():
    print("Hello World!")
```

创建 `setup.py` 文件

```py
from distutils.core import setup
from Cython.Build import cythonize

setup(name = 'Hello world', ext_modules = cythonize("my_module.py"))
```

编译

```sh
python setup.py build  # 生成.c文件
python setup.py install  # 生成pyd文件，根据运行过程提示，pyd被生成到了python根目录下Lib/site-packages中，可以直接使用
```

输出结果：

```sh
$ py setup.py install

running install
running build
running build_ext
running install_lib
copying build/lib.linux-x86_64-3.6/my_module.cpython-36m-x86_64-linux-gnu.so -> /home/brt/.enpy/test/lib64/python3.6/site-packages
running install_egg_info
Writing /home/brt/.enpy/test/lib64/python3.6/site-packages/Hello_world-0.0.0-py3.6.egg-info
```

在Linux系统下，生成了 `my_module.cpython-36m-x86_64-linux-gnu.so` ，并支持直接直接载入：

```py
import my_module
my_module.test()
```
