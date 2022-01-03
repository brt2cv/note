<!--
+++
title       = "Python闭包与装饰器"
description = "1. 内嵌函数; 2. 闭包（closure）; 3. 装饰器; 4. 内置的装饰器"
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

## 1. 内嵌函数

首先，明确 Python 的内嵌函数，也就是函数内定义新的函数：

```py
def outside():
    print("正在调用outside")
    def inside():
        print("正在调用inside")
    inside()

outside()
inside()  #error
```

## 2. 闭包（closure）

大白话说，闭包就是“有权访问另一个函数作用域变量的函数都是闭包”。

```py
def line_creater(a, b):
    def line(x):
        return a*x + b
    return line

model = line_creater(5, 10)
x = 23
y = model(x)  # 求解函数y值
```

### 2.1. 内嵌函数同名变量（局部变量）
如果你尝试直接修改外部作用域的<font color=#FF0000>局部变量</font>

```py
def foo():
    m = 0
    def foo1():
        m = 1  # 直接定义，则创建一个局部变量
        print(m)  # 输出：1

    print(m)  # 输出：0
    foo1()
    print(m)  # 输出：0

foo()  # 输出：0, 1, 0
```

是不行的……在foo1中，m是新创建的一个局部变量。

### 2.2. `nonlocal` 关键字

如果有你尝试在闭包内改写外部变量，会得到异常：

```py
def outer():
    name = "abcd"
    print("outer name id = ", id(name))

    def inner():
        print(">> 正常运行")
        print(name)  # Error【运行时时语法错误】
        print("inner name id = ", id(name))

        name = "ABCD"  # 因为这里定义了局部变量，所以上面的print()报错
        print(name)
        print("inner name id change to ", id(name))
    return inner

func_inner = outer()
func_inner()
```

`UnboundLocalError: local variable 'name' referenced before assignment`

说明Python并不允许改写（如果 x 存在）——追踪显示，正常的闭包，返回 inter() 包含有外层函数的属性项name。而如果上述代码中的inner执行进入inner时，并没有name的local变量。【不过我没想明白，Python动态记录function-symbol时，怎么会了解并区分函数内部情况的呢？！】——说明 `outer()` 执行时，python会导入全部的闭包函数体inner()来分析其的局部变量，而不仅仅是记录symbol。

解决方案：向闭包函数传递外部的局部变量，使用 `nonlocal name` 在inner() 中声明name对象。

### 2.3. `list.append(func)`  与 `for` 循环传递的 `param_i`

在list中append函数，并给函数传递（往往由for循环得到的）“不同的”参数：

```py
list_func = []
for i in range(3):
    def inner(x):
        print(x*i)  # 注意这里的i，不是局部变量！故函数定义里没有i的实际值！
    list_func.append(inner)

for func in list_func:
    func(10)
```

这个问题经常跟闭包联系在一起，但实际上与闭包无关~

问题出在：函数在append时，<font color=#FF0000>只是append了函数的symbol，而非函数定义</font>；函数直到调用时才获取i值，此时的i已经循环到了range的末位！

解决方案：在定义inner时：def inner(x, i=i) 将外部的i值赋给局部变量 i（此 i 非彼 i ）。这样就让 `i` 以局部变量的形式（会执行复制）并存储于函数体内。

或者使用 `functools.partial` 而不是lambda或def定义函数。

或者使用生成器代替list:

```py
def gen_func():
    for i in range(3):
        yield lambda x: print(i * x)

for func in gen_func():
    func(10)
```

### 2.4. 闭包的作用

闭包避免了使用全局变量，此外，闭包允许将函数与其所操作的某些数据（环境）关连起来。这一点与面向对象编程是非常类似的，在面对象编程中，对象允许我们将某些数据（对象的属性）与一个或者多个方法相关联。

一般来说，当对象中只有一个方法时，这时使用闭包是更好的选择。来看一个例子：

```py
def adder(x):
    def wrapper(y):
        return x + y
    return wrapper

adder5 = adder(5)
adder5(10)  # 输出 15
adder5(6)   # 输出 11
```

这比用类来实现更优雅！

1、实现封装（以JavaScripts为例 ，Python一般没必要用闭包实现封装）：

```js
var person = function(){
    //变量作用域为函数内部，外部无法访问，不会与外部变量发生重名冲突
    var name = "default";

    return {
      //管理私有变量
       getName : function(){
           return name;
       },
       setName : function(newName){
           name = newName;
       }
    }
}();
```

2、实现装饰器

### 2.5. 闭包的缺点

由于闭包会使得函数中的变量都被保存在内存中，<font color=#FF0000>内存消耗很大</font>，所以不能滥用闭包。

——不过，个人认为这也不是什么缺点（如果你利用闭包实现封装，跟class对比，class也同样需要空间存储变量）。

## 3. 装饰器

> [详解Python的装饰器](https://betacat.online/posts/2016-10-27/python-decorator/)
>
> [Python装饰器的另类用法](https://www.cnblogs.com/cicaday/p/python-decorator-more-usages.html)
>
> * [@call()装饰器](https://www.cnblogs.com/cicaday/p/python-decorator-more-usages.html#_caption_1)
> * [@list 装饰器](https://www.cnblogs.com/cicaday/p/python-decorator-more-usages.html#_caption_2)
>
> [装饰器里的那些坑](https://www.cnblogs.com/cicaday/p/python-decorator.html)

装饰器，虽然不同于GOF23设计模式的实现方式，但目的与结果相同——动态添加功能：

* GOF23的装饰模式，对class添加功能；
* Python @装饰器：<font color=#FF0000>对function添加功能，并保持原函数名不变</font>。

### 3.1. 装饰器的原型

* 本质上，是通过一个 `wrapper()` 函数，对原函数进行一层的包装。
* <font color=#FF0000>闭包</font>，只是针对function提供的一种非常合适的封装方法。

```py
def decorator(func):
    def wrapper():
        print "[DEBUG]: enter {}()".format(func.__name__)
        return func()
    return wrapper

def say_hello():
    print "hello!"

say_hello = decorator(say_hello)  # 添加功能并保持原函数名不变
```

@语法糖

```py
def decorator(func):
    def wrapper():
        print "[DEBUG]: enter {}()".format(func.__name__)
        return func()
    return wrapper

@decorator
def say_hello():
    print "hello!"
```

#### 3.1.1. 思考

关于添加的功能，是不是也可以放在 `decorator` 的函数体中？

```py
def decorator(func):
    print( "[DEBUG]: enter {}()".format(func.__name__))
    def wrapper():
        return func()
    return wrapper

@decorator
def say_hello():
    print("hello!...")

# 其实这个模式是错误的，try this：
say_hello()
say_hello()  # 第二次调用时，“忽略”了[DEBUG]打印
```

那么，这个跟标准的方式有何区别？（答案参考下文：装饰器的加载到执行的流程）

继续思考，为什么需要 `wrapper()` 闭包？去掉内嵌函数可以吗？

```py
def decorator(func):
    print( "[DEBUG]: enter {}()".format(func.__name__))
    return func  # 其实是装饰模式的变形： return lambda func: func

    # 或者，原始函数被完全忽略...
    return lambda: print("你甚至可以完全替换掉原始函数")

@decorator
def say_hello():
    print("hello!...")
```

答案：如果使用decorator(say_hello)没有问题，但如果使用装饰器就不能去掉 `wrapper()`（lambda的本质也是func_wrapper）。因为装饰器 `@decorator` 的设计模式必须要返回一个func_decorator。而且下次调用时，不会再重新走装饰过程，而是直接调用装饰器刚才返回的函数func_decorator。所以decorator::wrapper()函数体外的部分不会再被执行。

**装饰器的加载到执行的流程**：

<font color=#FF0000>模块加载 ->> 遇到@，执行timer函数，传入add函数 ->> 生成timer.<locals>.wrapper函数并命名为add，其实是覆盖了原同名函数 ->> 调用add(1, 2) ->> 去执行timer.<locals>.wrapper(1, 2) ->> wrapper内部持有原add函数引用(func)，调用func(1, 2) ->>继续执行完wrapper函数</font>

总结，装饰器的设计要点：

* 必须在 `def decorator()` 中定义一个闭包 `wrapper()` ，并 `return wrapper`
* 新增加的功能应该放在 `wrapper()` 内部，而不是在 `decorator()` 中

### 3.2. 多层的装饰器

```py
def w1(func):
    def inner():
        print("---正在装饰1----")
        func()
    return inner

def w2(func):
    def inner():
        print("---正在装饰2----")
        func()
    return inner

@w1
@w2
def f1():
    print("---f1---")

f1()

>>>---正在装饰1----
   ---正在装饰2----
   ---f1---
```

![](https://img2020.cnblogs.com/blog/2039866/202110/2039866-20211029071505029-263903195.jpg) <!-- closure_decorator/closure_decorator-0.jpg -->

从这张图里，也更容易看出<font color=#FF0000>装饰器模式</font>的本质。

### 3.3. 有参函数应用装饰器

```py
def decorator(func):
    def wrapper(*args, **kwargs):  # 传入任意参数
        print "[DEBUG]: enter {}()".format(func.__name__)
        print 'Prepare and say...',
        return func(*args, **kwargs)
    return wrapper  # 返回

@decorator
def say(something):
    print "hello {}!".format(something)
```

### 3.4. 含参的装饰器

```py
def logging(level):
    def wrapper(func):
        def inner_wrapper(*args, **kwargs):
            print "[{level}]: enter function {func}()".format(
                level=level,
                func=func.__name__)
            return func(*args, **kwargs)
        return inner_wrapper
    return wrapper

@logging(level='INFO')
def say(something):
    print "say {}!".format(something)

# 如果没有使用@语法，等同于
# say = logging(level='INFO')(say)

@logging(level='DEBUG')
def do(something):
    print "do {}...".format(something)

if __name__ == '__main__':
    say('hello')
    do("my work")
```

### 3.5. 适用于obj.method()的装饰器

如下示例代码，定义为方法的装饰器函数<font color=#FF0000>无需定义self变量</font>，而是直接传入装饰的对象（method）。而在调用 `obj.method()` 时，实际上会先进入装饰器函数。示例中的装饰器无需传入参数，而实际执行函数的args通过wrapper()的参数传入。

```py
class GitRepo:
    def __init__(self, repo_dir):
        self.repo_dir = repo_dir

    def switch_dir(func):
        """ 装饰器 """
        def wrapper(self, *args, **kwargs):
            def inner_wrapper():
                cwd = os.path.abspath(os.path.curdir)
                os.chdir(self.repo_dir)
                ret = func(self, *args, **kwargs)
                os.chdir(cwd)
                return ret
            return inner_wrapper()
        return wrapper

    @switch_dir
    def status(self, type_=None):
        list_lines = run_cmd("git status -s")
        if type_:
            list_files = self._filter_status(list_lines, type_)
            return list_files
        else:
            return list_lines
```

### 3.6. 基于类实现的装饰器

装饰器函数其实是这样一个接口约束，它必须接受一个callable对象作为参数，然后返回一个callable对象。在Python中一般callable对象都是函数，但也有例外。只要某个对象重载了__call__()方法，那么这个对象就是callable的。

回到装饰器上的概念上来，装饰器要求接受一个callable对象，并返回一个callable对象（不太严谨，详见后文）。那么用类来实现也是也可以的。我们可以让类的构造函数 __init__() 接受一个函数，然后重载 __call__() 并返回一个函数，也可以达到装饰器函数的效果。

```py
class logging(object):
    def __init__(self, func):
        self.func = func

    def __call__(self, *args, **kwargs):
        print("[DEBUG]: Function {func}()".format(func=self.func.__name__))
        return self.func(*args, **kwargs)

@logging
def say(something):
    print("say {}!".format(something))

say("abc")
```

#### 3.6.1. 带参数的类装饰器

```py
class logging:
    def __init__(self, level='DEBUG'):
        self.level = level

    def __call__(self, func):
        def wrapper(*args, **kwargs):
            print("[{level}]: enter function {func}()".format(
                    level=self.level,
                    func=func.__name__))
            func(*args, **kwargs)
        return wrapper

@logging(level='INFO')  # 如缺省，必须加括号：@logging()
def say(something):
    print("say {}!".format(something))

say("abc")
```

## 4. 内置的装饰器

### 4.1. `@property`

`@property` 广泛应用在类的定义中，可以让调用者写出简短的代码，同时保证对参数进行必要的检查，这样，程序运行时就减少了出错的可能性。

#### 4.1.1. 常规使用

属性有三个装饰器：setter, getter, deleter ，都是在property()的基础上做了一些封装，因为setter和deleter是property()的第二和第三个参数，不能直接套用@语法。getter装饰器和不带getter的属性装饰器效果是一样的，<font color=#0000FF>但如果定义了setter，则该属性则定义为只读</font>。经过@property装饰过的函数返回的不再是一个函数，而是一个property对象。

举例：

```py
s = Student()
s.score = 9999
```

这显然不合逻辑。为了限制score的范围，可以通过一个set_score()方法来设置成绩，再通过一个get_score()来获取成绩，这样，在set_score()方法里，就可以检查参数：

```py
class Student(object):

    def get_score(self):
        return self._score

    def set_score(self, value):
        if not isinstance(value, int):
            raise ValueError('score must be an integer!')
        if value < 0 or value > 100:
            raise ValueError('score must between 0 ~ 100!')
        self._score = value
```

但是，上面的调用方法又略显复杂，没有直接用属性这么直接简单。

有没有既能检查参数，又可以用类似属性这样简单的方式来访问类的变量呢？对于追求完美的Python程序员来说，这是必须要做到的！

还记得装饰器（decorator）可以给函数动态加上功能吗？对于类的方法，装饰器一样起作用。Python内置的 `@property` 装饰器就是负责把一个方法变成属性调用的：

```py
class Student(object):

    @property
    def score(self):
        return self._score

    @score.setter
    def score(self, value):
        if not isinstance(value, int):
            raise ValueError('score must be an integer!')
        if value < 0 or value > 100:
            raise ValueError('score must between 0 ~ 100!')
        self._score = value
```

`@property` 的实现比较复杂，我们先考察如何使用。把一个 `getter` 方法变成属性，只需要加上 `@property` 就可以了，此时，`@property` 本身又创建了另一个装饰器 `@score.setter` ，负责把一个 `setter` 方法变成属性赋值，于是，我们就拥有一个可控的属性操作：

```py
>>> s = Student()
>>> s.score = 60 # OK，实际转化为s.set_score(60)
>>> s.score # OK，实际转化为s.get_score()
60
>>> s.score = 9999
Traceback (most recent call last):
...
ValueError: score must between 0 ~ 100!
```

注意到这个神奇的@property，我们在对实例属性操作的时候，就知道该属性很可能不是直接暴露的，而是通过getter和setter方法来实现的。

#### 4.1.2. 设置只读

还可以定义只读属性，只定义getter方法，不定义setter方法就是一个只读属性：

```py
class Student(object):

    @property
    def birth(self):
        return self._birth

    @birth.setter
    def birth(self, value):
        self._birth = value

    @property
    def age(self):
        return 2014 - self._birth
```

上面的birth是可读写属性，而age就是一个只读属性，因为age可以根据birth和当前时间计算出来。

#### 4.1.3. `property()` 函数

```py
class Handler(Filterer):
    def __init__(self, level=NOTSET):
        Filterer.__init__(self)
        self._name = None
        pass

    def get_name(self):
        return self._name

    def set_name(self, name):
        _acquireLock()
        try:
            if self._name in _handlers:
                del _handlers[self._name]
            self._name = name
            if name:
                _handlers[name] = self
        finally:
            _releaseLock()

    name = property(get_name, set_name)  # 而不是：@name.setter
```

可以直接使用property()设定属性的输入、输出，而不是使用哪个蹩脚的 @name.setter

### 4.2. `@staticmethod` , ` @classmethod`

`@staticmethod` 返回的是一个 `staticmethod` 类对象，而 `@classmethod` 返回的是一个 `classmethod` 类对象。他们都是调用的是各自的__init__()构造函数。

```py
class classmethod(object):
    """
    classmethod(function) -> method
    """
    def __init__(self, function): # for @classmethod decorator
        pass
        # ...

class staticmethod(object):
    """
    staticmethod(function) -> method
    """
    def __init__(self, function): # for @staticmethod decorator
        pass
        # ...
```

装饰器的@语法就等同调用了这两个类的构造函数。

```py
class Foo(object):

    @staticmethod
    def bar():
        pass
    # 等同于 bar = staticmethod(bar)
```

至此，我们上文提到的装饰器接口定义可以更加明确一些，装饰器必须接受一个callable对象，其实它并不关心你返回什么，可以是另外一个callable对象（大部分情况），也可以是其他类对象，比如property。

### 4.3. functools.wraps
> [Python装饰器深度解析](https://zhuanlan.zhihu.com/p/45458873)

有些同学要问了，经过装饰器之后的函数还是原来的函数吗？原来的函数肯定还存在的，只不过真正调用的是装饰后生成的新函数。

那岂不是打破了“不能修改原函数”的规则？

是的，看下面的示例：

```py
print(add)
print(add.__name__)
print(add.__doc__)

输出：
<function auth.<locals>._auth.<locals>.wrapper at 0x10c871400>
wrapper
None
```

为了消除装饰器对原函数的影响，我们需要伪装成原函数，拥有原函数的属性，看起来就像是同一个人一样。

functools为我们提供了便捷的方式，只需这样：

```py
def auth(permission):
    def _auth(func):
        @functools.wraps(func) # 注意此处
        def wrapper(*args, **kwargs):
            print(f"验证权限[{permission}]...")
            func(*args, **kwargs)
            print("执行完毕...")
        return wrapper
    return _auth
```

`functools.wraps` 对我们的装饰器函数进行了装饰之后，add表面上看起来还是add。

`functools.wraps`内部通过partial和update_wrapper对函数进行再加工，将原始被装饰函数(add)的属性拷贝给装饰器函数(wrapper)。内部实现原理我们下文分解。
