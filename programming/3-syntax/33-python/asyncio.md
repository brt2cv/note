<!--
+++
title       = "Python协程"
description = "1. 简介; 2. 操作; 3. Debug 模式; 4. 并发性和多线程"
date        = "2021-12-21"
tags        = []
categories  = ["3-syntax","33-python"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

由于Golang的goroutine太过简单易用，我再次尝试了一遍Python的asyncio。

关于golang协程与python的对比：[知乎: python的协程与golang的协程有什么区别吗？总感觉不太一样……](https://www.zhihu.com/question/325835984/answer/693761824)

[TOC]

---

## 1. 简介

协程，英文叫作 Coroutine，又称微线程、纤程，协程是一种用户态的轻量级线程。

协程拥有自己的寄存器上下文和栈。协程调度切换时，将寄存器上下文和栈保存到其他地方，在切回来的时候，恢复先前保存的寄存器上下文和栈。因此协程能保留上一次调用时的状态，即所有局部状态的一个特定组合，每次过程重入时，就相当于进入上一次调用的状态。

协程本质上是个<font color=#FF0000>单进程</font>，协程相对于多进程来说，<font color=#FF0000>无需线程上下文切换的开销，无需原子操作锁定及同步的开销</font>，编程模型也非常简单。

我们可以使用协程来实现异步操作，比如在网络爬虫场景下，我们发出一个请求之后，需要等待一定的时间才能得到响应，但其实在这个等待过程中，程序可以干许多其他的事情，等到响应得到之后才切换回来继续处理，这样可以充分利用 CPU 和其他资源，这就是协程的优势。

### 1.1. 协程相对于多线程的优点

多线程编程是比较困难的，因为调度程序任何时候都能中断线程， 必须记住保留锁，去保护程序中重要部分， 防止多线程在执行的过程中断。

而协程默认会做好全方位保护， 以防止中断。我们必须显示产出才能让程序的余下部分运行。对协程来说， 无需保留锁， 而在多个线程之间同步操作， 协程自身就会同步， 因为在任意时刻， 只有一个协程运行。总结下大概下面几点：

+ 无需系统内核的上下文切换，减小开销；
+ 无需原子操作锁定及同步的开销，不用担心资源共享的问题；
+ 单线程即可实现高并发，单核 CPU 即便支持上万的协程都不是问题，所以很适合用于高并发处理，尤其是在应用在网络爬虫中。

## 2. 操作
> [homepage](https://docs.python.org/zh-cn/3/library/asyncio-task.html)
>
> [Python协程还不理解？请收下这份超详细的异步编程教程](https://www.pythonf.cn/read/115187)

相比于Golang中的goroutine，Python的协程还需要理解下面几个概念。

+ event_loop：事件循环，相当于一个无限循环，我们可以把一些函数注册到这个事件循环上，当满足条件发生的时候，就会调用对应的处理方法。
+ coroutine：中文翻译叫协程，在 Python 中常指代为协程对象类型，我们可以将协程对象注册到事件循环中，它会被事件循环调用。我们可以使用 `async` 关键字来定义一个方法，这个方法在调用时不会立即被执行，而是返回一个协程对象。
+ task：任务，它是对协程对象的进一步封装，包含了任务的各个状态。
+ future：代表将来执行或没有执行的任务的结果，实际上和 task 没有本质区别。

另外我们还需要了解 `async/await` 关键字，它是从 `Python 3.5` 才出现的，专门用于定义协程。其中，<font color=#FF0000>`async` 定义一个协程，`await` ## 用来挂起阻塞方法的执行。</font>

### 2.1. 定义异步函数

+ 使用 `async def function(params)`
+ 使用 `await` 定义IO操作（Python通过该关键字在耗时的IO运算上切换协程，并自动监听）

```py
async def say_after(delay, what):
    await asyncio.sleep(delay)
    print(what)

async def main():
    print(f"started at {time.strftime('%X')}")

    await say_after(1, 'hello')
    await say_after(2, 'world')

    print(f"finished at {time.strftime('%X')}")
```

### 2.2. 任务 & 事件循环
> [homepage](https://docs.python.org/zh-cn/3/library/asyncio-eventloop.html#event-loop)

使用高层级的 `asyncio.create_task()`（Python3.7） 函数来创建 Task 对象，也可用低层级的 `loop.create_task()` 或 `ensure_future()`（Python3.7之前）函数。不建议手动实例化 Task 对象。

运行异步任务：

+ `asyncio.run(main())`
+ `asyncio.gather(*aws)`
+ 创建事件循环
    * `loop = asyncio.get_event_loop()`
    * `task = loop.create_task(coroutine)`
    * `loop.run_until_complete(future)`
    * `loop.run_forever()`   运行事件循环直到 stop() 被调用。
    * `loop.stop()`

```py
async def coro():
    ...

async def main():
    # In Python 3.7+
    task = asyncio.create_task(coro())
    ...

    # This works in all Python versions but is less readable
    task = asyncio.ensure_future(coro())

    await task  # 简单等待（挂起当前协程并切换IO）直到完成，程序继续
    ...

asyncio.run(main())
```

#### 2.2.1. RuntimeError: This event loop is already running

注意：

`asyncio.run(main())` 会自动运行事件循环，所以，`asyncio.run()` 不要与 `run_until_complete` 共用，否则会报如上错误。

#### 2.2.2. asyncio.gather

```py
import asyncio

async def factorial(name, number):
    f = 1
    for i in range(2, number + 1):
        print(f"Task {name}: Compute factorial({i})...")
        await asyncio.sleep(1)
        f *= i
    print(f"Task {name}: factorial({number}) = {f}")

async def main():
    # Schedule three calls *concurrently*:
    await asyncio.gather(
        factorial("A", 2),
        factorial("B", 3),
        factorial("C", 4),
    )

asyncio.run(main())

# Expected output:
#
#     Task A: Compute factorial(2)...
#     Task B: Compute factorial(2)...
#     Task C: Compute factorial(2)...
#     Task A: factorial(2) = 2
#     Task B: Compute factorial(3)...
#     Task C: Compute factorial(3)...
#     Task B: factorial(3) = 6
#     Task C: Compute factorial(4)...
#     Task C: factorial(4) = 24
```

### 2.3. Task回调

`add_done_callback(callback, *, context=None)`

将 callback 方法传递给了封装好的 task 对象，这样当 task 执行完毕之后就可以调用 callback 方法了，同时 task 对象还会作为参数传递给 callback 方法，调用 task 对象的 result 方法就可以获取返回结果了。

大多数情况并不需要用回调方法，直接在 task 运行完毕之后也可以直接调用 result 方法获取结果。

```py
import async

async def request:
    ...
    return status

coroutine = request()
task= async, ensure_ future(coroutine)  # 分配务
print('Task:', task)  # 当任务状态

loop = asyncio.get_event_loop()
loop.run_until_complete(task)
print('Task:', task)
print('Task Result:', task.result())
```

### 2.4. 运行 asyncio 程序

```py
async def main():
    await asyncio.sleep(1)
    print('hello')

asyncio.run(main())
```

### 2.5. 简单等待

`coroutine asyncio.wait(aws, *, loop=None, timeout=None, return_when=ALL_COMPLETED)`

并发运行 aws 指定的 可等待对象 并阻塞线程直到满足 return_when 指定的条件。返回 Task/Future 集合: `(done, pending)` 。

注意：【Python3.8】直接向 wait() 传入协程对象的方式已弃用。

最新推荐用法：

```py
async def foo():
    return 42

task = asyncio.create_task(foo())
done, pending = await asyncio.wait({task})

if task in done:
    # Everything will work as expected now.
```

## 3. Debug 模式
> [homepage](https://docs.python.org/zh-cn/3/library/asyncio-dev.html#debug-mode)

默认情况下，asyncio以生产模式运行。为了简化开发，asyncio还有一种*debug 模式* 。

有几种方法可以启用异步调试模式:

+ 将 PYTHONASYNCIODEBUG 环境变量设置为 1 。
+ 使用 -X dev Python 命令行选项。
+ 将 debug=True 传递给 asyncio.run() 。
+ 调用 loop.set_debug() 。

除了启用调试模式外，还要考虑:

+ 将 asyncio logger 的日志级别设置为 `logging.DEBUG` ，例如，下面的代码片段可以在应用程序启动时运行:

    ```py
    logging.basicConfig(level=logging.DEBUG)
    ```

+ 配置 `warnings` 模块以显示 ResourceWarning 警告。一种方法是使用 `-W default` 命令行选项。

启用调试模式时:

+ asyncio 检查 未被等待的协程 并记录他们；这将消除“被遗忘的等待”问题。
+ 许多非线程安全的异步 APIs (例如 `loop.call_soon()` 和 `loop.call_at()` 方法)，如果从错误的线程调用，则会引发异常。
+ 如果执行I/O操作花费的时间太长，则记录I/O选择器的执行时间。
+ 执行时间超过100毫秒的回调将会载入日志。 属性 `loop.slow_callback_duration` 可用于设置以秒为单位的最小执行持续时间，这被视为“缓慢”。

## 4. 并发性和多线程

事件循环在线程中运行(通常是主线程)，并在其线程中执行所有回调和任务。当一个任务在事件循环中运行时，没有其他任务可以在同一个线程中运行。当一个任务执行一个 `await` 表达式时，正在运行的任务被挂起，事件循环执行下一个任务。

要调度来自另一 OS 线程的 callback，应该使用 `loop.call_soon_threadsafe()` 方法。 例如:

```py
loop.call_soon_threadsafe(callback, *args)
```

几乎所有异步对象都不是线程安全的，这通常不是问题，除非在任务或回调函数之外有代码可以使用它们。如果需要这样的代码来调用低级异步API，应该使用 `loop.call_soon_threadsafe()` 方法，例如:

```py
loop.call_soon_threadsafe(fut.cancel)
```

要从不同的OS线程调度一个协程对象，应该使用 run_coroutine_threadsafe() 函数。它返回一个 concurrent.futures.Future 。查询结果:

```py
async def coro_func():
     return await asyncio.sleep(1, 42)

# Later in another OS thread:

future = asyncio.run_coroutine_threadsafe(coro_func(), loop)
# Wait for the result:
result = future.result()
```

为了能够处理信号和执行子进程，事件循环必须运行于主线程中。

方法 `loop.run_in_executor()` 可以和 `concurrent.futures.ThreadPoolExecutor` 一起使用，用于在一个不同的操作系统线程中执行阻塞代码，并避免阻塞运行事件循环的那个操作系统线程。

