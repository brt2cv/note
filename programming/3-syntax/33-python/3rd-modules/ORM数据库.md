<!--
+++
title       = "Python+ORM 方案一览"
description = "1. 什么是ORM; 2. Python中常用的ORM"
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

## 1. 什么是ORM
> [简书: Python轻量级ORM-Peewee笔记](https://www.jianshu.com/p/16d1c330810c)

摘取一段对ORM的认识过程：

> 对于我，对ORM的经历了反反复复的爱恨交织过程。最早对其神奇之处的十分感叹；而后又鄙视其生成sql方式；如今，适时适当的在项目中使用ORM。
>
> 归根结底，对ORM态度的转变，源于对其认识的不足。最早接触ORM源自Django自带的ORM，用起来很爽。当时对sql并不熟悉，ORM了却了心头一大痛点。后来使用flask，没有自带的ORM，接触了sqlalchemy，也是一个很优秀的ORM。当时，我对于ORM的认识还是很浅薄，大概就认为ORM一个是数据库对象的map，其次就是能够生成sql查询。

使用程序人生的一篇文章软件随想录：代码与数据对ORM工程上的总结如下：

> 我们用 `ORM` ，或者 `LINQ` ，而尽量减少 `SQL` 的使用，是因为我们通过把SQL这种嵌在代码里的字符串数据，转化成了代码，也就意味着我们<font color=#FF0000>拥有了编译时或者运行时的检查，乃至编辑时的检查</font> —— 各种 linter 很难检测出字符串中的SQL语法或者语义错误，但可以在你撰写 ORM代码时便提示你其中蕴含的语法/语义错误。这是非常伟大的一个进步 —— 对于软件工程来说，越早发现错误，消弭错误所花费的时间就越短。

诚然，ORM是数据层中的更高的抽象，在工程上，抽象程度越高，对于扩展和维护将会更有利。当然，ORM常被人诟病的一大理由就是程式生成的SQL没有原生的高效。的确，对于复杂的SQL语句，使用ORM的组合可能比原生的sql更不可读或者不可维护。此时，我们就需要在项目中继续使用 `raw sql` 的形式。

## 2. Python中常用的ORM

### 2.1. SQLObject

SQLObject是一种流行的对象关系管理器，用于为数据库提供对象接口，其中表为类，行为实例，列为属性。

SQLObject包含一个基于Python对象的查询语言，使SQL更抽象，并为应用程序提供了大量的数据库独立性。

优点：

+ 采用了易懂的ActiveRecord 模式
+ 一个相对较小的代码库

缺点：

+ 方法和类的命名遵循了Java 的小驼峰风格
+ 不支持数据库session隔离工作单元

### 2.2. Storm
> [download](https://launchpad.net/storm/+download)
>
> [document - 中文](https://python-storm-tutorial.readthedocs.io/zh_CN/latest/)

Storm 是一个介于 单个或多个数据库与Python之间 映射对象的 Python ORM 。为了支持动态存储和取回对象信息，它允许开发者构建跨数据表的复杂查询。Stom中 table class 不需要是框架特定基类 的子类 。每个table class是 的sqlobject.SQLObject 的子类。

优点：

+ 清爽轻量的API，短学习曲线和长期可维护性
+ 不需要特殊的类构造函数，也没有必要的基类

缺点：

+ 迫使程序员手工写表格创建的DDL语句，而不是从模型类自动派生
+ Storm的贡献者必须把他们的贡献的版权给Canonical公司

### 2.3. Django's ORM

因为Django的ORM 是紧嵌到web框架的，所以就算可以也不推荐，在一个独立的非Django的Python项目中使用它的ORM。

Django，一个最流行的Python web框架， 有它独有的 ORM。 相比 SQLAlchemy， Django 的 ORM 更吻合于直接操作SQL对象，操作暴露了简单直接映射数据表和Python类的SQL对象 。

优点：

+ 易用，学习曲线短
+ 和Django紧密集合，用Django时使用约定俗成的方法去操作数据库

缺点：

+ 不好处理复杂的查询，强制开发者回到原生SQL
+ 紧密和Django集成，使得在Django环境外很难使用

### 2.4. peewee

优点：

+ Django式的API，使其易用
+ 轻量实现，很容易和任意web框架集成

缺点：

+ 不支持自动化 schema 迁移
+ 多对多查询写起来不直观

### 2.5. SQLAlchemy

SQLAlchemy 采用了数据映射模式，其工作单元 主要使得 有必要限制所有的数据库操作代码到一个特定的数据库session，在该session中控制每个对象的生命周期 。

优点：

+ 企业级 API，使得代码有健壮性和适应性
+ 灵活的设计，使得能轻松写复杂查询

缺点：

+ 工作单元概念不常见
+ 重量级 API，导致长学习曲线
