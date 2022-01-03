<!--
+++
title       = "【笔记】流畅的Python"
description = "1. 一摞Python风格的纸牌; 2. 不要使用可变类型作为参数的默认值"
date        = "2021-12-21"
tags        = []
categories  = ["3-syntax","33-python"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 一摞Python风格的纸牌

```py
import collections

Card = collections.namedtuple('Card', ['rank', 'suit'])

class FrenchDeck:
    ranks =[str(n) for n in range (2, 11)] + list('JQKA')
    suits =spades diamonds clubs hearts.split()

    def __init__(self):
        self._cards = [Card(rank, suit) for suit in self suits
                                        for rank in self ranks]

    def __len__(self):
        return len(self._cards)

    def __getitem__(self, position):
        return self._cards[position]
```

`collections.namedtuple` : 用以构建只有少数属性但是没有方法的对象，比如数据库条目。

```py
>>> beer_card = Card('7', 'diamonds')
>>> beer_card
Card(rank='7', suit='diamonds')
```

`__len__()` : 提供 len() 函数对该类的访问。

`__getitem__()` : 用于按照某一规则得到相关属性，例如 `random.choice()` 。

```py
>>> from random import choice
>>>choice(deck)
Card(rank='3', suit='hearts')
>>> choice(deck)
Card(rank='K', suit='spades')
>>>choice(deck)
Card(rank='2', suit="clubs")
```

现在已经可以体会到通过实现 `魔法方法` 来利用 Python数据模型的两个好处：

+ 作为你定义的类的用户，他们不必去记住标准操作的各式名称（“怎么得到元素的总数？是 `.size()` 还是 `.length()` 还是别的什么？”)

+ 可以更加方便地利用Python的标准库，比如 `random.choice()` 函数，从而不用重新发明轮子（通过 `__getitem__()` 获得）。

而且好戏还在后面。

因为 `__getitem__` 方法把 `[]` 操作交给了 `self._cards` 列表,所以我们的 deck 类自动支持切片(slicing)操作。下面列出了查看一摞牌最上面 3 张和只看牌面是 A 的牌的操作。其中第二种操作的具体方法是,先抽出索引是 12 的那张牌,然后每隔 13 张牌拿 1 张：

```py
>>> deck[:3]
[Card(rank='2', suit='spades'), Card(rank='3', suit='spades'),
Card(rank='4', suit='spades')]
>>> deck[12::13]
[Card(rank='A', suit='spades'), Card(rank='A', suit='diamonds'),
Card(rank='A', suit='clubs'), Card(rank='A', suit='hearts')]
```

另外,仅仅实现了 `__getitem__` 方法,这一摞牌就变成可迭代的了:

```py
>>> for card in deck:
...     print(card)
Card(rank='2', suit='spades')
Card(rank='3', suit='spades')
Card(rank='4', suit='spades')
...
```

反向迭代也没关系:

```py
>>> for card in reversed(deck): # doctest: +ELLIPSIS
...     print(card)
Card(rank='A', suit='hearts')
Card(rank='K', suit='hearts')
Card(rank='Q', suit='hearts')
...
```

## 2. 不要使用可变类型作为参数的默认值

可选参数可以有默认值，这是 Python 函数定义的一个很棒的特性，这样我们的 API 在进化的同时能保证向后兼容。然而，我们应该避免使用可变的对象作为参数的默认值。

下面在示例 8-12 中说明这个问题。我们以示例 8-8 中的 Bus 类为基础定义一个新类，HauntedBus，然后修改 __init__ 方法。这一次，passengers 的默认值不是 None，而是 []，这样就不用像之前那样使用 if 判断了。这个“聪明的举动”会让我们陷入麻烦。

```py
class HauntedBus:
    """备受幽灵乘客折磨的校车"""
    def __init__(self, passengers=[]):
        self.passengers = passengers

    def pick(self, name):
        self.passengers.append(name)

    def drop(self, name):
        self.passengers.remove(name)
```

HauntedBus 的诡异行为如示例 8-13 所示。

```py
>>> bus1 = HauntedBus(['Alice', 'Bill'])
>>> bus1.passengers
['Alice', 'Bill']
>>> bus1.pick('Charlie')
>>> bus1.drop('Alice')
>>> bus1.passengers ➊
['Bill', 'Charlie']
>>> bus2 = HauntedBus() ➋
>>> bus2.pick('Carrie')
>>> bus2.passengers
['Carrie']
>>> bus3 = HauntedBus() ➌
>>> bus3.passengers ➍
['Carrie']
>>> bus3.pick('Dave')
>>> bus2.passengers ➎
['Carrie', 'Dave']
>>> bus2.passengers is bus3.passengers ➏
True
>>> bus1.passengers ➐
['Bill', 'Charlie']
```

❶ 目前没什么问题，bus1 没有出现异常。

❷ 一开始，bus2 是空的，因此把默认的空列表赋值给 self.passengers。

❸ bus3 一开始也是空的，因此还是赋值默认的列表。

❹ 但是默认列表不为空！

❺ 登上 bus3 的 Dave 出现在 bus2 中。

❻ 问题是，bus2.passengers 和 bus3.passengers 指代同一个列表。

❼ 但 bus1.passengers 是不同的列表。

问题在于，没有指定初始乘客的 HauntedBus 实例会共享同一个乘客列表。

这种问题很难发现。如示例 8-13 所示，实例化 HauntedBus 时，如果传入乘客，会按预期运作。但是不为 HauntedBus 指定乘客的话，奇怪的事就发生了，这是因为self.passengers 变成了 passengers 参数默认值的别名。出现这个问题的根源是，默认值在定义函数时计算（通常在加载模块时），因此默认值变成了函数对象的属性。因此，如果默认值是可变对象，而且修改了它的值，那么后续的函数调用都会受到影响。

可变默认值导致的这个问题说明了为什么<font color=#FF0000>通常使用 None 作为接收可变值的参数的默认值。</font>在示例 8-8 中，__init__ 方法检查 passengers 参数的值是不是 None，如果是就把一个新的空列表赋值给 self.passengers。

