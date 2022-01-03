<!--
+++
title       = "Lua基本语法"
description = "1. 注释; 2. 基本数据类型; 3. 变量; 4. 循环; 5. if; 6. function; 7. Lua 模块与包"
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

## 1. 注释

```lua
--[[ 函数返回两个值的...
最大值 --]]
```

## 2. 基本数据类型

```lua
a = true
type(a)  -- boolean
type(nil)  -- nil
```

### 2.1. string

```lua
html = [[
<html>
<head></head>
<body>
    <a href="http://www.runoob.com/">菜鸟教程</a>
</body>
</html>
]]
print(html)
```

字符串连接使用的是 `..` ，如：

```lua
> print("a" .. 'b')
ab
> print(157 .. 428)
157428
```

使用 # 来计算字符串的长度，放在字符串前面，如下实例：

```lua
> len = "www.runoob.com"
> print(#len)
14
> print(#"www.runoob.com")
14
```

#### 2.1.1. 字符串函数
> [菜鸟教程](https://www.runoob.com/lua/lua-strings.html)

* string.upper(argument)
* string.lower(argument)
* string.gsub(mainString,findString,replaceString,num)  # 替换

    ```lua
    > string.gsub("aaaa","a","z",3);
    zzza    3
    ```

* string.find (str, substr, [init, [end]])
* string.reverse(arg)
* string.format(...)
* string.char(arg...)  # 将整型数字转成字符并连接
* string.byte(arg[,int])  # 转换字符为整数值
* string.len(arg)
* string.rep(string, n)

    ```lua
    > string.rep("abcd",2)
    abcdabcd
    ```

* string.gmatch(str, pattern)
* string.match(str, pattern, init)

### 2.2. table

Lua 中的表（table）其实是一个"关联数组"（associative arrays），数组的索引可以是数字或者是字符串。或者说，是数组和字典的结合体。

```lua
-- table_test.lua 脚本文件
a = {}
a["key"] = "value"
key = 10
a[key] = 22
a[key] = a[key] + 11
for k, v in pairs(a) do
    print(k .. " : " .. v)
end
```

不同于其他语言的数组把 0 作为数组的初始索引，在 Lua 里表的默认初始索引一般以 1 开始。

```lua
-- table_test2.lua 脚本文件
local tbl = {"apple", "pear", "orange", "grape"}
for key, val in pairs(tbl) do
    print("Key", key)
end
```

### 2.3. function

```lua
function factorial1(n)
    if n == 0 then
        return 1
    else
        return n * factorial1(n - 1)
    end
end

print(factorial1(5))
factorial2 = factorial1
print(factorial2(5))
```

function 可以以匿名函数（anonymous function）的方式通过参数传递：

```lua
function testFun(tab,fun)
    for k, v in pairs(tab) do
        print(fun(k,v));
    end
end

tab = {key1="val1", key2="val2"}
testFun(tab,
    function(key,val)  -- 匿名函数
        return key.."="..val;
    end
)
```

#### 2.3.1. 索引

对 table 的索引使用方括号 []。Lua 也提供了 `.` 操作。

```lua
t[i]
t.i                 -- 当索引为字符串类型时的一种简化写法
gettable_event(t,i) -- 采用索引访问本质上是一个类似这样的函数调用
```
### 2.4. thread

在Lua里，最主要的线程是协同程序（coroutine）。它跟线程（thread）差不多，拥有自己独立的栈、局部变量和指令指针，可以跟其他协同程序共享全局变量和其他大部分东西。

线程跟协程的区别：线程可以同时多个运行，而协程任意时刻只能运行一个，并且处于运行状态的协程只有被挂起（suspend）时才会暂停。

### 2.5. userdata（自定义类型）

userdata 是一种用户自定义数据，用于表示一种由应用程序或 C/C++ 语言库所创建的类型，可以将任意 C/C++ 的任意数据类型的数据（通常是 struct 和 指针）存储到 Lua 变量中调用。

## 3. 变量

Lua 变量有三种类型：全局变量、局部变量、表中的域。

Lua 中的变量全是全局变量，那怕是语句块或是函数里，除非用 `local` 显式声明为局部变量。

局部变量的作用域为从声明位置开始到所在语句块结束。

变量的默认值均为 nil。

## 4. 循环

### 4.1. while

```lua
while(condition)
do
   statements
end
```

### 4.2. 数值for循环

```lua
for var=exp1,exp2,exp3 do
    statements
end
```

var 从 exp1 变化到 exp2，每次变化以 exp3 为步长递增 var，并执行一次 "执行体"。exp3 是可选的，如果不指定，默认为1。

### 4.3. 泛型for循环

```lua
--打印数组a的所有值
a = {"one", "two", "three"}
for i, v in ipairs(a) do
    print(i, v)
end
```

i是数组索引值，v是对应索引的数组元素值。`ipairs` 是Lua提供的一个迭代器函数，用来迭代数组。

### 4.4. repeat...until 循环

repeat
   statements
until( condition )

## 5. if

控制结构的条件表达式结果可以是任何值，Lua认为false和nil为假，true和非nil为真。

要注意的是Lua中 <font color=#FF0000>0 为 true</font>：

```lua
--[ 0 为 true ]
if(0)
then
    print("0 为 true")
end
```

if ... elseif ... else ...end

```lua
if( 布尔表达式 1)
then
   --[ 在布尔表达式 1 为 true 时执行该语句块 --]

elseif( 布尔表达式 2)
then
   --[ 在布尔表达式 2 为 true 时执行该语句块 --]

elseif( 布尔表达式 3)
then
   --[ 在布尔表达式 3 为 true 时执行该语句块 --]
else
   --[ 如果以上布尔表达式都不为 true 则执行该语句块 --]
end
```

## 6. function

```lua
optional_function_scope function function_name( argument1, argument2, argument3..., argumentN)
    function_body
    return result_params_comma_separated
end
```

Lua语言函数可以返回多个值，每个值以逗号隔开。

### 6.1. 可变参数

```lua
function add(...)
local s = 0
  for i, v in ipairs{...} do  --> {...} 表示一个由所有变长参数构成的数组
    s = s + v
  end
  return s
end

print(add(3,4,5,6,7))  --->25
```

有时候我们可能需要几个固定参数加上可变参数，固定参数必须放在变长参数之前：

```lua
function fwrite(fmt, ...)  ---> 固定的参数fmt
    return io.write(string.format(fmt, ...))
end

fwrite("runoob\n")       --->fmt = "runoob", 没有变长参数。
fwrite("%d%d\n", 1, 2)   --->fmt = "%d%d", 变长参数为 1 和 2
```

通常在遍历变长参数的时候只需要使用 `{…}` ，然而变长参数可能会包含一些 `nil` ，那么就可以用 `select` 函数来访问变长参数了：

* `select('#', …)` 返回可变参数的长度
* `select(n, …)` 用于返回 n 到 `select('#', …)` 的参数

调用select时，必须传入一个固定实参selector(选择开关)和一系列变长参数。如果selector为数字n,那么select返回它的第n个可变实参，否则只能为字符串"#",这样select会返回变长参数的总数。例子代码：

```lua
do
    function foo(...)
        for i = 1, select('#', ...) do  -->获取参数总数
            local arg = select(i, ...)  -->读取参数
            print("arg", arg)
        end
    end

    foo(1, 2, 3, 4);
end
```

输出结果为：

```
arg    1
arg    2
arg    3
arg    4
```

## 7. Lua 模块与包

模块类似于一个封装库，从 Lua 5.1 开始，Lua 加入了标准的模块管理机制，可以把一些公用的代码放在一个文件里，以 API 接口的形式在其他地方调用，有利于代码的重用和降低代码耦合度。

```lua
-- 文件名为 module.lua
-- 定义一个名为 module 的模块
module = {}

-- 定义一个常量
module.constant = "这是一个常量"

-- 定义一个函数
function module.func1()
    io.write("这是一个公有函数！\n")
end

local function func2()
    print("这是一个私有函数！")
end

function module.func3()
    func2()
end

return module
```

### 7.1. require 函数

```lua
require("<模块名>")
-- 或者
require "<模块名>"
```

```lua
require("module")

print(module.constant)
module.func3()
```

或者给加载的模块定义一个别名变量，方便调用：

```lua
local m = require("module")

print(m.constant)
m.func3()
```

### 7.2. C 包

Lua和C是很容易结合的，使用 C 为 Lua 写包。

与Lua中写包不同，C包在使用以前必须首先加载并连接，在大多数系统中最容易的实现方式是通过动态连接库机制。

Lua在一个叫 `loadlib` 的函数内提供了所有的动态连接的功能。这个函数有两个参数:库的绝对路径和初始化函数。所以典型的调用的例子如下：

```lua
local path = "/usr/local/lua/lib/libluasocket.so"
local f = loadlib(path, "luaopen_socket")
```

loadlib 函数加载指定的库并且连接到 Lua，然而它并不打开库（也就是说没有调用初始化函数），反之他返回初始化函数作为 Lua 的一个函数，这样我们就可以直接在Lua中调用他。

如果加载动态库或者查找初始化函数时出错，loadlib 将返回 nil 和错误信息。我们可以修改前面一段代码，使其检测错误然后调用初始化函数：

```lua
local path = "/usr/local/lua/lib/libluasocket.so"
-- 或者 path = "C:\\windows\\luasocket.dll"，这是 Window 平台下
local f = assert(loadlib(path, "luaopen_socket"))
f()  -- 真正打开库
```

一般情况下我们期望二进制的发布库包含一个与前面代码段相似的 stub 文件，安装二进制库的时候可以随便放在某个目录，只需要修改 stub 文件对应二进制库的实际路径即可。

将 stub 文件所在的目录加入到 LUA_PATH，这样设定后就可以使用 require 函数加载 C 库了。
