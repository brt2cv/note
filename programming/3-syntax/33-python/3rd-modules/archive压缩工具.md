<!--
+++
title       = "Python压缩工具"
description = "1. unzip; 2. unrar; 3. p7zip; 4. patool; 5. pyunpack"
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

---

```py
$ sudo apt-get install unzip unrar p7zip-full
$ python3 -m pip install patool
$ python3 -m pip install pyunpack
```

## 1. unzip

## 2. unrar

## 3. p7zip

## 4. patool

## 5. pyunpack
> [](https://github.com/ponty/pyunpack)

```sh
$ python3 -m pyunpack.cli --help
usage: cli.py [-h] [-b BACKEND] [-a] [--debug] filename directory

positional arguments:
  filename              path to archive file
  directory             directory to extract to

optional arguments:
  -h, --help            show this help message and exit
  -b BACKEND, --backend BACKEND
                        auto, patool or zipfile
  -a, --auto-create-dir
                        auto create directory
  --debug               set logging level to DEBUG
```

Usage

```sh
$ echo hello > hello.txt
$ zip hello.zip hello.txt
$ rm hello.txt
$ python3
>>> from pyunpack import Archive
>>> Archive('hello.zip').extractall('.')
>>> open('hello.txt').read()
'hello\n'
```
