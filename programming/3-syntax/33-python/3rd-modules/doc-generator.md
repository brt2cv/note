<!--
+++
title       = "文档API生成工具"
description = "1. Python; 2. C++; 3. Java; 4. Golang; 5. 其他"
date        = "2022-01-03"
tags        = []
categories  = ["3-syntax","33-python","3rd-modules"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

___

## 1. Python

### 1.1. pydoc（python自带，已废弃）

据说配色及其丑陋……

### 1.2. pdoc（注意，不是pydoc）

pdoc 是一个简单易用的命令行工具，可以生成 Python 的 API 文档。

### 1.3. Sphinx

Python有个自带的工具可以生成API项目文档——pydoc，但Python3官方文档却是由sphinx生成的。可见Sphinx已成为Python项目首选的文档工具，同时它对C/C++项目也有很好的支持。

Sphinx 运行前需要安装 `docutils & Jinja2 & requests` 库。如果需要源码支持高亮显示，则必须安装 Pygments 库.

```
# pip install requests jinja2 docutils
pip install sphinx
```

#### 1.3.1. 支持的注释格式

1. Python默认

    ```py
    def my_function(a, b):
        """ 函数功能说明
            xxxx
        """
        return a * b
    ```

2. [Google Style]((https://www.sphinx.org.cn/usage/extensions/example_google.html))

    ```py
    def function_with_types_in_docstring(param1, param2):
        """Example function with types documented in the docstring.

        `PEP 484`_ type annotations are supported. If attribute, parameter, and
        return types are annotated according to `PEP 484`_, they do not need to be
        included in the docstring:

        Args:
            param1 (int): The first parameter.
            param2 (str): The second parameter.

        Returns:
            bool: The return value. True for success, False otherwise.

        .. _PEP 484:
            https://www.python.org/dev/peps/pep-0484/

        """
    ```

    以及

    ```py
    def function_with_pep484_type_annotations(param1: int, param2: str) -> bool:
        """Example function with PEP 484 type annotations.

        Args:
            param1: The first parameter.
            param2: The second parameter.

        Returns:
            The return value. True for success, False otherwise.

        """
    ```

3. [NumPy Style](https://www.sphinx-doc.org/en/master/usage/extensions/example_numpy.html)

    ```py
    def function_with_types_in_docstring(param1, param2):
        """Example function with types documented in the docstring.

        `PEP 484`_ type annotations are supported. If attribute, parameter, and
        return types are annotated according to `PEP 484`_, they do not need to be
        included in the docstring:

        Parameters
        ----------
        param1 : int
            The first parameter.
        param2 : str
            The second parameter.

        Returns
        -------
        bool
            True if successful, False otherwise.

        .. _PEP 484:
            https://www.python.org/dev/peps/pep-0484/

        """
    ```

#### 1.3.2. 使用示例

项目目录结构示例：

```
+ project
    + doc
    + src
        + demo.py
        + file1.py
        + file2.py
```

doc目录使用来存放API(html)文档，src目录是用来存放项目的源码。

1. 创建doc模板


    ```sh
    cd doc/
    sphinx-quickstart [doc_dir="."]
    ```

    + 版本的格式: 1.1.0
    + 中文的格式: zh_CN

    会在doc目录下生成

    ```py
    + build/（空）
    + source/
        + conf.py
        + index.rst
    + make.bat
    + Makefile
    ```

2. 修改配置 `source/conf.py`

    1. 增加扩展

        ```py
        extensions = ['sphinx.ext.autodoc',
            'sphinx.ext.doctest',
            'sphinx.ext.intersphinx',
            'sphinx.ext.todo',
            'sphinx.ext.coverage',
            'sphinx.ext.mathjax'
        ]
        ```

    2. 添加 `sys.path`

        ```py
        import os
        import sys
        sys.path.insert(0, os.path.abspath('../../src')) #指向src目录
        ```

3. 自动将注释生成rst文档

    `sphinx-apidoc -o ./source  ../src`

4. 设置目录树（修改 `doc/source/modules.rst` 文档内容）

    ```
    Welcome to XXX's documentation!
    ===================================

    .. toctree::
       :maxdepth: 5  ### 修改了这里
       :caption: Contents:

       modules.rst  ### 注意前面是3个空格
    ```

5. 编译

    + `make clean` : 可选，删除doc/build下面的所有内容
    + `make html` : 生成html文件

## 2. C++

### 2.1. Doxygen

### 2.2. Sphinx for C++（对比Doxygen）
> [微软博客](https://devblogs.microsoft.com/cppblog/clear-functional-c-documentation-with-sphinx-breathe-doxygen-cmake/)

Doxygen已经存在了几十年，是一种稳定的，功能丰富的工具，用于生成文档。但是，这并非没有问题。用Doxygen生成的<font color=#FF0000>文档往往在视觉上比较嘈杂</font>，具有90年代初期的风格，并且<font color=#FF0000>难以清晰地表示基于模板的复杂API</font>。其标记也有局限性。尽管他们在2012年增加了对Markdown的支持，但<font color=#FF0000>Markdown并不是编写技术文档的最佳工具</font>，因为它为简化而牺牲了可扩展性，功能集大小和语义标记。

Sphinx改为使用 `reStructuredText` ，它具有Markdown缺少的那些重要概念作为核心理想。可以将自己的“角色”和“指令”添加到标记中，以进行特定于域的自定义。

与Doxygen相比，Sphinx生成的文档看上去也更现代，更精简，并且可以更轻松地交换不同的主题，自定义显示的信息量以及修改页面的布局。

1. 安装环境

    ```sh
    sudo apt install doxygen  # 安装Doxygen，用于从C++头文件提取API
    # pip install sphinx_rtd_theme  # 可选，安装主题
    pip install breathe  # 利用Doxygen从C++提取文档
    sudo apt install cmake
    ```

2. 创建编译文件：

    + CatCutifier/CMakeLists.txt

    ```sh
    cmake_minimum_required (VERSION 3.8)
    project ("CatCutifier")
    add_subdirectory ("CatCutifier")
    ```

    + CatCutifier/CatCutifier/CMakeLists.txt

    ```sh
    add_library (CatCutifier "CatCutifier.cpp" "CatCutifier.h")
    target_include_directories (CatCutifier PUBLIC .)
    ```

3. 头文件的格式（同Doxygen）

    ```cpp
    CatCutifier/CatCutifier/CatCutifier.h
    #pragma once

    /**
      A fluffy feline
    */
    struct cat {
        /**
        Make this cat look super cute
        */
        void make_cute();
    };
    ```

4. 配置Doxygen

    ```sh
    > mkdir docs
    > cd docs
    > doxygen.exe -g
    ```

    We can get something generated quickly by finding the INPUT variable in the generated Doxyfile and pointing it at our code: `INPUT = ../CatCutifier` 。

5. 执行编译和文档生成

    ```sh
    > doxygen.exe
    ```

## 3. Java

### 3.1. JavaDoc

## 4. Golang

## 5. 其他

### 5.1. Pandoc

Pandoc是一个文档转换工具，支持docx、markdown、html、pdf、txt等等文件格式的互相转化，常用于转换不同的标记语言格式。

`apt install pandoc`

#### 5.1.1. markdown转docx

```
pandoc demo-math.md -o demo-math.docx
```
