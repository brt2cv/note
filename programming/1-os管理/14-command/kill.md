<!--
+++
title       = "kill及其衍生程序"
description = "1. 使用应用自带的arg选项，例如stop; 2. pkill"
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

本文以关闭 `jupyter notebook` 为例，讲述常见的几种 kill 方法。

## 1. 使用应用自带的arg选项，例如stop

The IPython Notebook has become the Jupyter Notebook. A recent version has added a `jupyter notebook stop` shell command which will shut down a server running on that system. You can pass the port number at the command line if it's not the default port 8888.

You can also use `nbmanager`, a desktop application which can show running servers and shut them down.

Finally, we are working on adding:

* A config option to automatically shut down the server if you don't use it for a specified time.
* A button in the user interface to shut the server down. (We know it's a bit crazy that it has taken this long. Changing UI is controversial.)

## 2. pkill

### 2.1. use kill with pgrep

```sh
echo 'alias quitjupyter="kill $(pgrep jupyter)"' >> ~/.bashrc
```

### 2.2. or directly, pkill

`pkill jupyter`

### 2.3. killall

### 2.4. 通过端口查询PID

1. 我们可以使用 `lsof -n -i4TCP:8888` 来查询进程号：

    jupyter notebook list
    ... shows the running notebooks and their port-numbers
    ... (for instance: 8080)

    ```
    lsof -n -i4TCP:[port-number] # shows PID.
    kill -9 [PID] # kill the process.
    ```

2. 或者，直接使用 `fuser` 指令：

    * 查询： `fuser -v -k -i -n tcp 31888`
    * 终结进程： `fuesr -k 31888/tcp`
