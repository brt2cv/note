<!--
+++
title       = "Python音频处理"
description = "1. librosa"
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

## 1. librosa

`pip install librosa`

但是，在Xubuntu 20.04环境上 `import librosa` 报错：

```
ModuleNotFoundError: No module named 'numba.decorators'
```

解决：

使用最新的numba(0.50)导致错误，使用旧版本能解决问题：

```
pip uninstall numba
pip install 'numba<=0.48'
```

接下来，加载音频文件再次出错：`NoBackendError` 。

在ubuntu上，以下方式可以解决问题：

```sh
sudo apt-get install libav-tools
# 或者，最新版本的bantu：
sudo apt-get install ffmpeg
```
