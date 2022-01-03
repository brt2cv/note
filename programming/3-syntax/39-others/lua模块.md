<!--
+++
title       = "Lua常用模块"
description = "1. IO"
date        = "2022-01-03"
tags        = []
categories  = ["3-syntax","39-others"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->


[TOC]

---

## 1. IO

```lua
-- 以只读方式打开文件
file = io.open("test.lua", "r")

-- 设置默认输入文件为 test.lua
io.input(file)

-- 输出文件第一行
print(io.read())

-- 关闭打开的文件
io.close(file)

-- 以附加的方式打开只写文件
file = io.open("test.lua", "a")

-- 设置默认输出文件为 test.lua
io.output(file)

-- 在文件最后一行添加 Lua 注释
io.write("--  test.lua 文件末尾注释")

-- 关闭打开的文件
io.close(file)
```

其他的 io 方法有：

* io.tmpfile():返回一个临时文件句柄，该文件以更新模式打开，程序结束时自动删除
* io.type(file): 检测obj是否一个可用的文件句柄
* io.flush(): 向文件写入缓冲中的所有数据
* io.lines(optional file name): 返回一个迭代函数,每次调用将获得文件中的一行内容,当到文件尾时，将返回nil,但不关闭文件

### 1.1. 完全模式

通常我们需要在同一时间处理多个文件。我们需要使用 file:function_name 来代替 io.function_name 方法。以下实例演示了如何同时处理同一个文件。

```lua
-- 以只读方式打开文件
file = io.open("test.lua", "r")

-- 输出文件第一行
print(file:read())

-- 关闭打开的文件
file:close()

-- 以附加的方式打开只写文件
file = io.open("test.lua", "a")

-- 在文件最后一行添加 Lua 注释
file:write("--test")

-- 关闭打开的文件
file:close()
```
