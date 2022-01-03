<!--
+++
title       = "Python文档管理与格式化工具"
description = "1. 代码格式化"
date        = "2021-12-21"
tags        = []
categories  = ["3-syntax","33-python","3rd-modules"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 代码格式化

### 1.1. autopep8

```
pip install autopep8
```

简单使用：

`autopep8 -aa <filename>`

+ `-aa` 表示代码侵入性级别。这里解释一下侵入性aggressive。

    - 当不使用 `--aggressive` 选项时，`autopep8` 只会对空格进行格式化 ，不会修改你的其他语法。

    - 当使用1个--aggressive时，表示侵入性级别1，会修改一些不推荐的语法。比如 `x == None` 会被修改为 `x is None` 。但这有一定的风险，可能会改变原来程序的语义，比如例子中，x如果改写了 `__eq__` 方法，就会有问题。

    - 当使用2个--aggressive时，侵入性级别增加1，`if x == True:` 之类的代码会被改为 `if x:` 。

    个人建议，在自己的编辑器中使用flake8(也使用了pycodestyle)等插件进行提示即可，不要依赖于autopep8来修改源码。

+ `--max-line-length=n` 可以设置每行代码的最长字符限制，默认是79。

    社区中很多人反映79个字符的长度限制应该放宽，毕竟这是历史原因导致的。

+ `--in-place` (缩写-i)

    不再输入格式化后的代码，而是将格式化直接应用到源文件上，改写源文件。

### 1.2. YAPF

个人推荐使用 `yapf` 来取代 `autopep8` 。

不同于autopep8、pep8ify之类的Python代码格式化程序: 它们的目的是消除Python代码中不符合PEP-8规范的错误。符合规范的代码不会被修改。然而，符合PEP-8规范的代码，不一定是好看的代码。

yapf使用clang-format算法来实现代码的重新排版，即便代码本来就符合规范。

`pip install yapf`

安装后，你可以试着使用 `yapf <filename>` 来格式化前面例子中的丑陋代码。

### 1.3. docformatter

[github](https://github.com/myint/docformatter)

`pip install --upgrade docformatter`

简单使用： `docformatter --in-place example.py`
