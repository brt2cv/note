<!--
+++
title       = "Vue入门"
description = "1. Vue 元素; 2. vue-cli脚手架（基于2.0）"
date        = "2022-01-03"
tags        = []
categories  = ["5-框架应用","51-web"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

> [官方: guide](https://cn.vuejs.org/v2/guide/)
> [官方: api](https://cn.vuejs.org/v2/api/)

[TOC]

## 1. Vue 元素
> [bilibili: 4个小时带你快速入门vue](https://www.bilibili.com/video/av76249419?p=25)

### 1.1. el: 挂载点

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184023751-717826279.jpg) <!-- Vue入门/2020-01-05-09-47-15.jpg -->

* vue实例的作用范围：el命中的元素及其内部的<font color=#FF0000>后代元素</font>
* 可以使用CSS选择器，但推荐使用ID选择器(#id)
* 可以使用的dom元素：双标签，但不包括 `<html>` 和 `<body>`。

### 1.2. data: 数据对象

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184024179-333848829.jpg) <!-- Vue入门/2020-01-05-09-55-08.jpg -->

也支持list与dict(对象)的数据格式：

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184024475-932670539.jpg) <!-- Vue入门/2020-01-05-09-57-29.jpg -->

### 1.3. v-text
用于设置标签的文本值。

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184024791-434665460.jpg) <!-- Vue入门/2020-01-05-09-59-25.jpg -->

* 属性 `v-text=xxx` 写法会替换全部内容，且会忽略标签value设置的字符：

    `<h2 v-text="message">内容如下</h2>` : 这里无法显示中文内容。

* 通过 **插值表达式** `{{ var }}` 形式可以替换指定内容。

    `<h2>差值表达式：{{ message }}</h2>` : 可以显示中文

* 支持表达式（例如字符串拼接）：

    `<h2 v-text="message + '!!' "></h2>`

### 1.4. v-html
用于显示特定的html结构内容（即，将内容作为html渲染，而非普通文字显示）。

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184025005-2116054493.jpg) <!-- Vue入门/2020-01-05-10-12-42.jpg -->

### 1.5. v-on
> [官网](https://cn.vuejs.org/v2/api/#v-on)

为元素绑定事件。

* 语法糖： `@` == ` v-on:`
* 绑定的方法定义在 `methods` 属性中
* 方法内部可以通过 `this` 关键字访问data数据元素

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184025274-121397171.jpg) <!-- Vue入门/2020-01-05-10-15-17.jpg -->

传递自定义参数：

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184025501-2121649312.jpg) <!-- Vue入门/2020-01-05-11-31-24.jpg -->

事件修饰符：

事件的后面跟上 `.修饰符` 可以对事件进行限制，例如： `keyup.enter` 表示按下Enter键才会触发事件。

* stop - 调用 event.stopPropagation()。
* prevent - 调用 event.preventDefault()。
* capture - 添加事件侦听器时使用 capture 模式。
* self - 只当事件是从侦听器绑定的元素本身触发时才触发回调。
* {keyCode | keyAlias} - 只当事件是从特定键触发时才触发回调。
* native - 监听组件根元素的原生事件。
* once - 只触发一次回调。
* left - (2.2.0) 只当点击鼠标左键时触发。
* right - (2.2.0) 只当点击鼠标右键时触发。
* middle - (2.2.0) 只当点击鼠标中键时触发。
* passive - (2.3.0) 以 { passive: true } 模式添加侦听器

### 1.6. v-show
根据表达式的bool，切换元素的显示与隐藏（控制display）。

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184025736-1025940696.jpg) <!-- Vue入门/2020-01-05-10-35-24.jpg -->

### 1.7. v-if
根据表达式的bool，切换元素的显示与隐藏（<font color=#FF0000>操纵dom元素</font>）。即表达式false时，元素会从dom中移除。

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184026121-1276485251.jpg) <!-- Vue入门/2020-01-05-10-40-54.jpg -->

### 1.8. v-bind
设置元素的属性。

语法糖： `:` == `v-bind:`

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184026416-267482696.jpg) <!-- Vue入门/2020-01-05-10-44-03.jpg -->

### 1.9. v-for
迭代list/dict对象：`v-for="{xxx, idx} in arr"`

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184026688-1396393681.jpg) <!-- Vue入门/2020-01-05-11-23-36.jpg -->

### 1.10. v-model
获取并设置 `表单元素` 的值（<font color=#FF0000>双向数据绑定</font>）。

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201109184026928-1957773102.jpg) <!-- Vue入门/2020-01-05-11-36-43.jpg -->

> [bilibili: 双向绑定原理](https://www.bilibili.com/video/av44699553?p=9)

### 1.11. computed
> [bilibili: vue计算属性](https://www.bilibili.com/video/av44699553?p=10)

## 2. vue-cli脚手架（基于2.0）
> [bilibili: SRC文件流程和根组件App](https://www.bilibili.com/video/av44699553?p=19)

### 2.1. App.vue 文件结构
* `<template>`: 模板html结构

    ```js
    <template>
    <div id="app">
        <img alt="Vue logo" src="./assets/logo.png">
        <HelloWorld msg="Welcome to Your Vue.js App"/>
    </div>
    </template>
    ```

* `<script>`: 行为逻辑

    ```js
    <script>
    import HelloWorld from './components/HelloWorld.vue'

    export default {
    name: 'app',
    components: {
        HelloWorld
    }
    }
    </script>
    ```

* `<style>`: 样式

    ```js
    <style>
    #app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
    }
    </style>
    ```

### 2.2. 组件嵌套
> [bilibili: 组件嵌套](https://www.bilibili.com/video/av44699553?p=20)

