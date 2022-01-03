<!--
+++
title       = "JavaScripts语法速查"
description = "1. 结构; 2. 语法; 3. 面向对象; 4. JQuery"
date        = "2022-01-03"
tags        = []
categories  = ["5-框架应用","51-web"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 结构

### 1.1. 定义

1. 在html中

    ```html
    <head>
      <script>
        alert('Hello, world');
      </script>
    </head>
    ```

2. 独立文件，然后在html中import

    ```html
    <head>
      <script src="/static/js/abc.js"></script>
    </head>
    ```

有些时候你会看到 `<script>` 标签还设置了一个type属性：`<script type="text/javascript">...</script>`。但这是没有必要的，因为默认的type就是JavaScript，所以不必显式地把type指定为JavaScript。

### 1.2. 调用

### 1.3. strict模式

如果一个变量没有通过var申明就被使用，那么该变量就自动被申明为全局变量：

```js
i = 10; // i现在是全局变量
```

strict模式将限制这样的定义方式。

```js
'use strict';
```

## 2. 语法

### 2.1. 字符串

```js
var s = 'Hello, world!';

s.length;  // 13
s.toUpperCase();
s.toLowerCase();
s.indexOf('world');  // 没有找到指定的子串，返回-1
s.substring(0, 5);  // 从索引0开始到5（不包括5），返回'hello'
```

需要特别注意的是，<font color=#FF0000>字符串是不可变的</font>，如果对字符串的某个索引赋值，<font color=#FF0000>不会有任何错误，但是，也没有任何效果</font>。

#### 2.1.1. 多行字符串

由于多行字符串用\n写起来比较费事，所以最新的ES6标准新增了一种多行字符串的表示方法，用反引号 * ... * 表示：

```js
var str = `这是一个
多行
字符串`;
```

#### 2.1.2. 模板字符串

```js
var name = '小明';
var age = 20;
var message = `你好, ${name}, 你今年${age}岁了!`;
```

### 2.2. 数组

```js
var arr = [1, 2, 3.14, 'Hello', null, true];
arr.length; // 6
arr.indexOf('Hello');
arr.slice(0, 3); // 从索引0开始，到索引3结束，但不包括索引3
var aCopy = arr.slice(); // 复制数组

arr.push('A', 'B'); // 返回Array新的长度: 4
arr.pop(); // pop()返回'B'; 空数组继续pop不会报错，而是返回undefined
arr.unshift('A', 'B'); // 头部insert，返回Array新的长度: 4
arr.shift(); // 'A'

arr.sort();
arr.reverse();

var arr = ['Microsoft', 'Apple', 'Yahoo', 'AOL', 'Excite', 'Oracle'];
// 从索引2开始删除3个元素,然后再添加两个元素:
arr.splice(2, 3, 'Google', 'Facebook'); // 返回删除的元素 ['Yahoo', 'AOL', 'Excite']

var added = arr.concat([1, 2, 3]);
// concat()方法可以接收任意个元素和Array
arr.concat(1, 2, [3, 4]); // ['A', 'B', 'C', 1, 2, 3, 4]

var arr = ['A', 'B', 'C', 1, 2, 3];
arr.join('-'); // 'A-B-C-1-2-3'
```

### 2.3. 对象

```js
var xiaohong = {
    name: '小红',
    'middle-school': 'No.1 Middle School'
};
```

xiaohong的属性名middle-school不是一个有效的变量，就需要用''括起来。访问这个属性也无法使用.操作符，必须用['xxx']来访问：

```js
xiaohong['middle-school']; // 'No.1 Middle School'
xiaohong['name']; // '小红'
xiaohong.name; // '小红'
```

如果我们要检测xiaoming是否拥有某一属性，可以用in操作符：

```js
var xiaoming = {
    name: '小明',
    birth: 1990,
    school: 'No.1 Middle School',
    height: 1.70,
    weight: 65,
    score: null
};
'name' in xiaoming; // true
'grade' in xiaoming; // false
```

要判断一个属性是否是xiaoming自身拥有的，而不是继承得到的，可以用hasOwnProperty()方法：

```js
var xiaoming = {
    name: '小明'
};
xiaoming.hasOwnProperty('name'); // true
xiaoming.hasOwnProperty('toString'); // false
```

### 2.4. Map/Set

```js
var m = new Map([['Michael', 95], ['Bob', 75], ['Tracy', 85]]);
m.get('Michael'); // 95

m.set('Adam', 67); // 添加新的key-value
m.set('Bob', 59);
m.has('Adam'); // 是否存在key 'Adam': true
m.get('Adam'); // 67
m.delete('Adam'); // 删除key 'Adam'
m.get('Adam'); // undefined
```

```js
var s2 = new Set([1, 2, 3]); // 含1, 2, 3
s.add(4);
s.delete(3);
```

### 2.5. for遍历

## 3. 面向对象


## 4. JQuery

加载模块：

```js
var $ = require('jquery');
// 或者
require('jquery');
```

+ 第一种的话，jquery 也是一个标准的 CMD 模块，如果存在 jquery 的多个版本时，彼此可以共存。
+ 第二种的话，jquery 是一个，如果一个页面中存在多个 jquery 版本时，全局变量 jQuery / $ 会彼此覆盖。

### 4.1. jQuery对象

jQuery对象和DOM对象之间可以互相转化：

```js
var div = $('#abc'); // jQuery对象
var divDom = div.get(0); // 假设存在div，获取第1个DOM元素
var another = $(divDom); // 重新把DOM包装为jQuery对象
```

### 4.2. 选择器

```js
// 查找<div id="abc">:
var div = $('#abc');


// 按tag查找: 查找<p>xxxx</p>:
var ps = $('p'); // 返回所有<p>节点
ps.length; // 数一数页面有多少个<p>节点

// 按class查找
var a = $('.red'); // 所有节点包含`class="red"`都将返回

// 查找同时包含red和green的节点
var a = $('.red.green'); // 注意没有空格
// 符合条件的节点: <div class="blue green red">...</div>

// 按属性查找: 找出<??? name="email">
var email = $('[name=email]');

// 组合查找
var emailInput = $('input[name=email]');
var tr = $('tr.red'); // 找出<tr class="red ...">...</tr>

// 多项选择器
$('p,div'); // 把<p>和<div>都选出来
$('p.red,p.green'); // 把<p class="red">和<p class="green">都选出来
```

层级选择器 `$('ancestor descendant')`

```js
$('ul.lang li.lang-javascript'); // [<li class="lang-javascript">JavaScript</li>]
$('div.testing li.lang-javascript'); // [<li class="lang-javascript">JavaScript</li>]
```

子选择器 `$('parent>child')` 类似层级选择器，但是限定了层级关系必须是父子关系

过滤器 `:` 一般不单独使用，它通常附加在选择器上，帮助我们更精确地定位元素。

```js
$('ul.lang li'); // 选出JavaScript、Python和Lua 3个节点

$('ul.lang li:first-child'); // 仅选出JavaScript
$('ul.lang li:last-child'); // 仅选出Lua
$('ul.lang li:nth-child(2)'); // 选出第N个元素，N从1开始
$('ul.lang li:nth-child(even)'); // 选出序号为偶数的元素
$('ul.lang li:nth-child(odd)'); // 选出序号为奇数的元素
```

### 4.3. 表单相关

针对表单元素，jQuery还有一组特殊的选择器：

+ `:input` ：可以选择 `<input>` ，`<textarea>` ，`<select>` 和 `<button>`；
+ `:file` ：可以选择 `<input type="file">` ，和 `input[type=file]` 一样；
+ `:checkbox` ：可以选择复选框，和 `input[type=checkbox]` 一样；
+ `:radio` ：可以选择单选框，和 `input[type=radio]` 一样；
+ `:focus` ：可以选择当前输入焦点的元素，例如把光标放到一个 `<input>` 上，用 `$('input:focus')` 就可以选出；
+ `:checked` ：选择当前勾上的单选框和复选框，用这个选择器可以立刻获得用户选择的项目，如 `$('input[type=radio]:checked')` ；
+ `:enabled` ：可以选择可以正常输入的 `<input>` 、`<select>` 等，也就是没有灰掉的输入；
+ `:disabled` ：和 `:enabled` 正好相反，选择那些不能输入的。

### 4.4. 事件

因为JavaScript在浏览器中以单线程模式运行，页面加载后，一旦页面上所有的JavaScript代码被执行完后，<font color=#FF0000>就只能依赖触发事件来执行JavaScript代码</font>。

浏览器在接收到用户的鼠标或键盘输入后，会自动在对应的DOM节点上触发相应的事件。如果该节点已经绑定了对应的JavaScript处理函数，该函数就会自动调用。

由于不同的浏览器绑定事件的代码都不太一样，所以用jQuery来写代码，就屏蔽了不同浏览器的差异，我们总是编写相同的代码。

+ 鼠标事件

    * click: 鼠标单击时触发；
    * dblclick：鼠标双击时触发；
    * mouseenter：鼠标进入时触发；
    * mouseleave：鼠标移出时触发；
    * mousemove：鼠标在DOM内部移动时触发；
    * hover：鼠标进入和退出时触发两个函数，相当于mouseenter加上mouseleave。

+ 键盘事件

    键盘事件仅作用在当前焦点的DOM上，通常是 `<input>` 和 `<textarea>` 。

    * keydown：键盘按下时触发；
    * keyup：键盘松开时触发；
    * keypress：按一次键后触发。

+ 其他事件

    * focus：当DOM获得焦点时触发；
    * blur：当DOM失去焦点时触发；
    * change：当 `<input>` 、`<select>` 或 `<textarea>` 的内容改变时触发；
    * submit：当 `<form>` 提交时触发；
    * ready：当页面被载入并且DOM树完成初始化后触发。仅作用于document对象。

#### 4.4.1. 事件参数

有些事件，如mousemove和keypress，我们需要获取鼠标位置和按键的值，否则监听这些事件就没什么意义了。所有事件都会传入Event对象作为参数，可以从Event对象上获取到更多的信息：

```js
$(function () {
    $('#testMouseMoveDiv').mousemove(function (e) {
        $('#testMouseMoveSpan').text('pageX = ' + e.pageX + ', pageY = ' + e.pageY);
    });
});
```

#### 4.4.2. 取消绑定

```js
function hello() {
    alert('hello!');
}

a.click(hello); // 绑定事件

// 10秒钟后解除绑定:
setTimeout(function () {
    a.off('click', hello);
}, 10000);
```

#### 4.4.3. 事件触发条件

一个需要注意的问题是，事件的触发总是由用户操作引发的。例如，我们监控文本框的内容改动：

```js
var input = $('#test-input');
input.change(function () {
    console.log('changed...');
});
```

当用户在文本框中输入时，就会触发change事件。但是，如果用JavaScript代码去改动文本框的值，将不会触发change事件：

```js
var input = $('#test-input');
input.val('change it!'); // 无法触发change事件
```

有些时候，我们希望用代码触发change事件，可以直接调用无参数的change()方法来触发该事件：

```js
var input = $('#test-input');
input.val('change it!');
input.change(); // 触发change事件
```

input.change()相当于input.trigger('change')，它是trigger()方法的简写。

为什么我们希望手动触发一个事件呢？如果不这么做，很多时候，我们就得写两份一模一样的代码。

