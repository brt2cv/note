<!--
+++
title       = "Bash语法"
description = "1. 函数; 2. 条件判断"
date        = "2021-12-21"
tags        = []
categories  = ["3-syntax","39-others"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

关于Bash-Script的语法，包括函数...

## 1. 函数

函数需要在使用之前定义；同时，函数支持以文件的形式进行模块化封装，其他文件的调用范式如下：

```sh
source base_func.sh
myFunc  # 模块函数调用
```

### 1.1. 无参函数

常见的Bash函数，有两种书写方式

```sh
function myfunc {
    echo "abc"
}
function myfunc2(){
    echo "ABC"
}
```

注意：函数名后需要有一个空格！

### 1.2. 函数返回值

#### 1.2.1. 方法1【弃用】

通过return关键字处理返回信息，主函数通过$?得到返回值：

```sh
function myfunc {
    read -p "Enter a value: " value
    # let value2=$value*2
    # echo "Double $value = $value2"
    return $[ $value * 2 ]
}
myfunc
echo "Get the function return-value: $?"  # 通过$?获取函数返回值
```

以下方式无法得到正确的返回值，请谨慎操作：

```sh
ret=`myfunc`  # 尝试获得myfunc函数的打印消息
echo "Fail to get the return-value, but None: [$ret]"
```

该方法是通过$?获取返回值，然而，return关键字只能返回number类型，且退出状态的取值范围是0到255，所以return方式的返回值严格受限。一般来说，return只是用于表示退出状态，而不作为返回值使用。

#### 1.2.2. 方法2【推荐】

通过echo返回字符串，并利用$(function)捕获函数返回值：

```sh
function help {
param=$1  # 外部传参
    # echo "Usage : link-bin Target_Path Bin_FileName"  # 不应该有多个echo
    ret="echo string as return【$param】"    # 通过echo标准输出返回值
    echo $ret
}
echo_get=$(help param_abc)    # 通过$()调用执行函数并接收返回
echo "Get the function echo_get: $echo_get"
```

该方法是捕获函数内所有的echo语句作为return-value，比之方法1，返回值为字符串格式，范围不再受限。但函数如果需要返回，则需要人为地限制函数体内echo语句的使用（以及其他stdout输出），否则会干扰函数的返回值正确性。

### 1.3. 含参函数

编写形式，如上示例。

需要注意变量在函数体内外的作用域变化：

```sh
param="Null"
function varfield {
    local param="abc"
    # param="123"  # 改写Outer-param的值
    echo "In the function: param=[$param]"
}
varfield
echo "Out of function: param=[$param]"
```

### 1.4. 关于数组做实参、数组作返回值

```sh
array=(5 4 3 2 1)
echo "The original array is: ${array[*]}"
function array_add {
local param_array=$*
    local array_new
    local index=0
    for value in ${param_array[*]}; do
        # echo "list[$index] = $value"
        param_array[$index]=$[ $value*2 ]  # 改写原数组
        let index+=1
        array_new+="$[ $value*2 ] "  # 利用字符串组装数组
    done
    # echo ${param_array[*]}
    echo $array_new  # 或者通过组装新的字符串来表示数组
}
array_ret=`array_add ${array[*]}`
echo "Get return array: ${array_ret[*]}"
index=0
for value in ${array_ret[*]}; do
    echo "list[$index]=$value"
    let index+=1
done
```

尽管bash-script提供了数组的专有形式，但使用上与带空格的字符串没有太大的差别。实际上，实参尚可以数组格式传入（当然也可以先整合为字符串），但返回值只能利用echo，返回字符串格式的“数组”了。

## 2. 条件判断

以 FILE 为判断依据：

![](https://img2020.cnblogs.com/blog/2039866/202102/2039866-20210206164851532-1421095724.jpg) <!-- Bash语法\0_1077750-20181218225638061-1479151188.jpg -->

以 STRING 为判断依据

![](https://img2020.cnblogs.com/blog/2039866/202102/2039866-20210206164851774-327470377.jpg) <!-- Bash语法\1_1077750-20181218225752584-880457214.jpg -->

以 INTERGER 为判断依据

![](https://img2020.cnblogs.com/blog/2039866/202102/2039866-20210206164852044-1576163163.jpg) <!-- Bash语法\2_1077750-20181218225912146-482338476.jpg -->

### 2.1. 对比 `[[ ]]` 与 `[ ]` 的使用差别

[[ ]] 是 [ ] 的一个增强版本，是一个关键字。但它仅适用于 bash、zsh 等脚本环境。[[ ]] 基本兼容了 [ ] 的全部功能，另外有一些优化和增强功能，具体如下：

![](https://img2020.cnblogs.com/blog/2039866/202102/2039866-20210206164852259-1676064331.jpg) <!-- Bash语法\3_1077750-20181218230014984-1646390719.jpg -->

另，`[[ ]]` 增加了对多条件判断的支持：

```sh
if [ expression1 ] && [ expression2 ]; then ...
if [[ expression1 && expression2 ]]; then...
```

### 2.2. 案例分析

当执行以下代码时，无法准确得到期望的判断内容：

```sh
function test_empty_string(){
    test -n $1 && echo 'not null' || echo 'null string'
}
test_empty_string ""  # return "not null"
```

总会得到 not null 的结果，无论调用函数时传入什么参数（包括空字符串）。

修改方法：将 test 语句改为： test -n "$1"，就差了一个双引号，导致test检测失败。

所以，如果需要进行条件判断，优先使用 [[ ]] 形式，而不是显式调用 test 关键字。
