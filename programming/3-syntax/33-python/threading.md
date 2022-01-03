<!--
+++
title       = "Python多线程 - threading"
description = "1. GIL; 2. API; 3. 创建子线程; 4. 线程同步; 5. `Timer` 定时器; 6. 线程安全; 7. 线程池：ThreadPoolExecutor"
date        = "2021-12-21"
tags        = []
categories  = ["3-syntax","33-python"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

[TOC]

---

> [官网](https://docs.python.org/3/library/threading.html)

## 1. GIL

首先需要明确的一点是<font color=#FF0000>GIL并不是Python的特性</font>，它是在实现Python解析器(CPython)时所引入的一个概念。就好比C++是一套语言（语法）标准，但是可以用不同的编译器来编译成可执行代码。有名的编译器例如GCC，INTEL C++，Visual C++等。

为了利用多核，Python开始支持多线程。<font color=#FF0000>而解决多线程之间数据完整性和状态同步的最简单方法自然就是加锁。</font>于是有了GIL这把超级大锁，而当越来越多的代码库开发者接受了这种设定后，他们开始大量依赖这种特性（即<font color=#FF0000>默认python内部对象是 thread-safe 的，无需在实现时考虑额外的内存锁和同步操作</font>）。

慢慢的这种实现方式被发现是蛋疼且低效的。但当大家试图去拆分和去除GIL的时候，发现大量库代码开发者已经重度依赖GIL而非常难以去除了。

所以简单的说GIL的存在更多的是历史原因。如果推到重来，多线程的问题依然还是要面对，但是至少会比目前GIL这种方式会更优雅。

GIL无疑就是一把全局排他锁。毫无疑问全局锁的存在会对多线程的效率有不小影响。甚至就几乎等于Python是个单线程的程序。

那么读者就会说了，全局锁只要释放的勤快效率也不会差啊。只要在进行耗时的IO操作的时候，能释放GIL，这样也还是可以提升运行效率的嘛。或者说再差也不会比单线程的效率差吧。理论上是这样，而实际上呢？Python比你想的更糟。

> 下面我们就对比下Python在多线程和单线程下得效率对比。测试方法很简单，一个循环1亿次的计数器函数。一个通过单线程执行两次，一个多线程执行。最后比较执行总时间。
>
> 可以看到python在多线程的情况下居然比单线程整整慢了45%。按照之前的分析，即使是有GIL全局锁的存在，串行化的多线程也应该和单线程有一样的效率才对。那么怎么会有这么糟糕的结果呢—— GIL设计的缺陷！

[省略实验过程……](http://toutiao.io/r/6abiw)

简单的总结下就是：Python的多线程在多核CPU上，只对于IO密集型计算产生正面效果；<font color=#FF0000>而当有至少有一个CPU密集型线程存在</font>，那么多线程效率会由于GIL而大幅下降。

* 用multiprocess替代Thread

    multiprocess库的出现很大程度上是为了弥补thread库因为GIL而低效的缺陷。它完整的复制了一套thread所提供的接口方便迁移。

    当然multiprocess也不是万能良药。它的引入会增加程序实现时线程间数据通讯和同步的困难。就拿计数器来举例子，如果我们要多个线程累加同一个变量，对于thread来说，申明一个global变量，用thread.Lock的context包裹住三行就搞定了。而multiprocess由于进程之间无法看到对方的数据，只能通过在主线程申明一个Queue，put再get或者用share memory的方法。这个额外的实现成本使得本来就非常痛苦的多线程程序编码，变得更加痛苦了。

* 用其他解析器

    之前也提到了既然GIL只是CPython的产物，那么其他解析器是不是更好呢？没错，像JPython和IronPython这样的解析器由于实现语言的特性，他们不需要GIL的帮助。然而由于用了Java/C#用于解析器实现，他们也失去了利用社区众多C语言模块有用特性的机会。所以这些解析器也因此一直都比较小众。毕竟功能和性能大家在初期都会选择前者，`Done is better than perfect` 。

## 2. API

* Thread(target, name, daemon=True)
* currentThread()
* setDaemon(True)    # 用于指定为后台进程

    将线程声明为守护线程，必须在start() 方法调用之前设置；

    后台线程无法等待（与join()操作相反），不过，这些线程会在主线程终止时自动销毁（如果不设置为后台进程，则主线程结束后，子线程仍继续运行）。

* isDaemon()
* is_alive()
* get/setName()
* join()

    join所完成的工作就是线程同步，即主线程任务结束之前，进入阻塞状态，一直等待其他的子线程执行结束之后，主线程再终止。

有没有方法，介于 `setDaemon()` 与 `join()` 的中间状态？即，主线程退出，子线程继续运行？额，恐怕没有，毕竟一个进程里面的主线程没有说可以切换的。倒是多进程，可以忽略父进程，子进程将作为 `孤儿进程` ，直接挂靠到init进程下。

## 3. 创建子线程

通过 function 创建子线程任务：

```py
from threading import Thread

def threadfun(x,y):  # 线程任务函数
    for i in range(x,y):  print(i)

thread_array = []
for _ in range(2):
    tid = Thread(target=threadfun, args=(1,6))
    tid.start()
    thread_array.append(tid)

for tid in thread_array:
    tid.join()
```

继承 Thread 实现子线程类：

```py
class mythread(threading.Thread):
    def run(self):  # 重载线程类方法，用于执行线程
        pass

if __name__ == '__main__':
    ta = mythread()
    ta.name = 'thread-ta'  # 线程名
    tb = mythread()
    tb.start()
    ...
    tb.join()
```

## 4. 线程同步

在使用多线程的应用下，如何保证线程安全，以及线程之间的同步，或者访问共享变量等问题是十分棘手的问题，也是使用多线程下面临的问题，如果处理不好，会带来较严重的后果，使用python多线程中提供Lock 、Rlock 、Semaphore 、Event 、Condition 用来保证线程之间的同步，后者保证访问共享变量的互斥问题。

* Lock & RLock：互斥锁，用来保证多线程访问共享变量的问题
* Semaphore对象：Lock互斥锁的加强版，可以被多个线程同时拥有，而Lock只能被某一个线程拥有。
* Event对象：它是线程间通信的方式，相当于信号，一个线程可以给另外一个线程发送信号后让其执行操作。
* Condition对象：其可以在某些事件触发或者达到特定的条件后才处理数据

### 4.1. 有了GIL，是否还需要同步？

#### 4.1.1. 死锁

死锁是开发人员在python中编写并发/多线程应用程序时最担心的问题。了解死锁的最佳方法是使用经典的计算机科学示例问题，称为 `哲学家就餐` 问题。

![](https://img2020.cnblogs.com/blog/2039866/202005/2039866-20200526203024466-24260049.jpg) <!-- D:\Home\workspace\note\programming\3-syntax\33-python\threading/threading0.jpg -->

哲学家要么在思考，要么在吃饭。而且，一个哲学家必须在他吃意大利面之前把两个叉子放在他旁边（即左右叉子，或者你可以理解为，他们需要两把叉子才能吃饭...别嫌脏）。当所有五位哲学家同时拿起他们的右叉时，就会出现死锁问题。由于每个哲学家都有一个叉子，他们都会等待其他人放下叉子。结果，他们都不能吃意大利面。

#### 4.1.2. 竞争条件

竞争条件是当系统同时执行两个或多个操作时发生的程序的不需要状态。例如，考虑这个简单的for循环：

```py
import threading
g = 0

def add():
    global g
    for _ in range(100000):
        g += 1

# 创建多个子线程
list_tid = []
for _ in range(5):
    tid = threading.Thread(target=add)
    list_tid.append(tid)

# 同时启动子线程
for tid in list_tid:
    tid.start()

# 回收子线程
for tid in list_tid:
    tid.join()

print(f"————最终累加应为【{100000*5}】，实际为【{g}】")  # 随机值，如416180
```

产生这种结果的原因是因为python的解释器会把一个简单的+1操作分成多步:

* 获取num的值
* 将num的值+1
* 将运算完成的值赋给num

又因为这是多线程的, 所以cpu在处理两个线程的时候, 是采用雨露均沾的方式, 可能在线程一刚刚将num值+1还没来得及将新值赋给num时, 就开始处理线程二了, 因此当线程二执行完全部的num+=1的操作后, 可能又会开始对线程一的未完成的操作, 而此时的操作停留在了完成运算未赋值的那一步, 因此在完成对num的赋值后, 就会覆盖掉之前线程二对num的+1操作。

#### 4.1.3. GIL去哪儿了

GIL可不盯着每个线程运行完一个函数才切换线程……当第一个线程刚获得num值，GIL就切换走了。额，过了许久切换回来时，数据已经脏了。

从底层点说，Python的线程在GIL的控制之下，线程之间，对整个python解释器，对python提供的C API的访问都是互斥的，这可以看作是Python**内核级的互斥机制**。但是<font color=#FF0000>这种互斥是我们不能控制的，我们还需要另外一种可控的互斥机制</font>———用户级互斥。内核级通过互斥保护了内核的共享资源，同样，用户级互斥保护了用户程序中的共享资源。

GIL的作用是：对于一个解释器，只能有一个thread在执行bytecode。所以每时每刻只有一条bytecode在被执行一个thread。GIL保证了 `bytecode` 这层面上是 `thread safe` 的。

但是如果你有个操作比如 `x += 1` ，这个操作需要多个bytecodes操作，在执行这个操作的多条bytecodes期间的时候可能中途就换thread了，这样就出现了 `data races` 的情况了。

### 4.2. Lock（互斥锁）

可以认为Lock有一个锁定池，当线程请求锁定时，将线程至于池中，直到获得锁定后出池。池中的线程处于状态图中的同步阻塞状态。

构造方法： `mylock = Threading.Lock()`

实例方法：

* `acquire([timeout])` : 使线程进入同步阻塞状态，尝试获得锁定。
* `release()` : 释放锁。使用前线程必须已获得锁定，否则将抛出异常。

```py
def add():
    global g
    for _ in range(100000):
        lock.acquire()
        g += 1
        lock.release()
```

或者，更简单的：

```py
with lock:
    g += 1
```

总结：

对于Lock对象而言，如果一个线程连续两次release，使得线程死锁。所以Lock不常用，一般采用Rlock进行线程锁的设定。

#### 4.2.1. 避免死锁

```py
class myThread(threading.Thread):
    def doA(self):
        lockA.acquire()
        print(self.name,"gotlockA", time.ctime())
        time.sleep(3)
        lockB.acquire()
        print(self.name,"gotlockB", time.ctime())
        lockB.release()
        lockA.release()

    def doB(self):
        lockB.acquire()
        print(self.name,"gotlockB",time.ctime())
        time.sleep(2)
        lockA.acquire()
        print(self.name,"gotlockA",time.ctime())
        lockA.release()
        lockB.release()

    def run(self):
        self.doA()
        self.doB()
```

解决方案：使用RLock代替互斥锁。

### 4.3. RLock（可重入锁）

为了支持在<font color=#FF0000>同一线程</font>中多次请求同一资源，python提供了“可重入锁”：threading.RLock。RLock内部维护着一个Lock和一个counter变量，counter记录了acquire的次数，从而使得资源可以被多次acquire。直到一个线程所有的acquire都被release，其他的线程才能获得资源。

* acquire([timeout])
* release()

### 4.4. Condition（条件变量）

`lock_con = threading.Condition([Lock/Rlock])`

Condition被称为条件变量，除了提供与Lock类似的 `acquire()` 和 `release()` 方法外，还提供了 `wait(timeout=None)` 和 `notify(n=1)` 方法。

Condition的处理流程如下：

1. 首先acquire一个条件变量，然后判断一些条件。
1. 如果条件不满足则wait；
1. 如果条件满足，进行一些处理改变条件后，通过notify方法通知其他线程，其他处于wait状态的线程接到通知后会重新判断条件。
1. 不断的重复这一过程，从而解决复杂的同步问题。

可以认为Condition对象维护了一个锁（Lock/RLock）和一个waiting池。线程通过acquire获得Condition对象，当调用wait方法时，线程会释放Condition内部的锁并进入blocked状态，同时在waiting池中记录这个线程。当调用notify方法时，Condition对象会从waiting池中挑选一个线程，通知其调用acquire方法尝试取到锁。

Condition对象的构造函数可以接受一个Lock/RLock对象作为参数，如果没有指定，则Condition对象会在内部自行创建一个RLock。

除了notify方法外，Condition对象还提供了 `notify_all()` 方法，可以通知waiting池中的所有线程尝试acquire内部锁。由于上述机制，处于waiting状态的线程只能通过notify方法唤醒，所以notifyAll的作用在于防止有的线程永远处于沉默状态。

```py
import threading
import time

count = 500
con = threading.Condition()

class Producer(threading.Thread):
    # 生产者函数
    def run(self):
        global count
        while True:
            if con.acquire():
                # 当count小于等于1000的时候进行生产
                if count > 1000:
                    con.wait()
                else:
                    count = count+100
                    print(f'{self.name} produce 100, count={count}')
                    # 完成生成后唤醒waiting状态的线程，
                    # 从waiting池中挑选一个线程，通知其调用acquire方法尝试取到锁
                    con.notify()

                con.release()
                time.sleep(1)

class Consumer(threading.Thread):
    # 消费者函数
    def run(self):
        global count
        while True:
            # 当count大于等于100的时候进行消费
            if con.acquire():
                if count < 100:
                    con.wait()
                else:
                    count -= 5
                    print(f'{self.name} consume 5, count={count}')
                    con.notify()
                    # 完成生成后唤醒waiting状态的线程，
                    # 从waiting池中挑选一个线程，通知其调用acquire方法尝试取到锁
                con.release()
                time.sleep(1)

if __name__ == '__main__':
    for i in range(2):
        p = Producer()
        p.start()

    for i in range(5):
        c = Consumer()
        c.start()
```

Condition有点像一群人抢话筒，只能一个一个来，但到下一轮争抢时，大家（线程池）又都激动起来……一旦有人挣到了，大家又都恢复了blocked状态。

总结：Condition与Lock很类似，只是增加了wait()等同步的显式方法。<font color=#FF0000>Condition常应用于“生产者-消费者”模型</font>，假如线程1需要数据，那么线程1就阻塞等待，这时线程2就去制造数据，线程2制造好数据后，通知线程1可以去取数据了，然后线程1去获取数据。

### 4.5. Event（同步条件）

Event和Condition差不多意思，只是少了锁功能，因为<font color=#FF0000>Event设计于不访问共享资源的条件环境</font>。

`event=threading.Event()`

Event可以使一个线程等待其他线程的通知。其内置了一个标志，初始值为False。线程通过 `wait()` 方法进入等待状态，直到另一个线程调用 `set()` 方法将内置标志设置为True时，Event通知所有等待状态的线程恢复运行；调用 `clear()` 时重置为False。还可以通过 `isSet()` 方法查询Event对象内置状态的当前值。

Event其实就是一个简化版的 Condition。Event没有锁，无法使线程进入同步阻塞状态。

* isSet()
* set()

    将标志设为True，并通知所有处于等待阻塞状态的线程恢复运行状态。

* clear(): 将标志设为False
* wait([timeout])

    如果标志为True将立即返回，否则阻塞线程至等待阻塞状态，等待其他线程调用set()。

    当设置了timeout时，那么如果wait()

```py
import threading
from time import sleep

def test(n, event):
    print(f'Thread_{n} is ready')
    event.wait()
    while event.isSet():
        print('Thread %s is running' % n)
        sleep(1)
    print(">> 线程结束")


if __name__ == '__main__':
    event = threading.Event()

    list_tid = []
    for i in range(0, 2):
        tid = threading.Thread(target=test, args=(i, event))
        list_tid.append(tid)

    for tid in list_tid:
        tid.start()

    sleep(2)
    print('----- event is set -----')
    event.set()

    sleep(3)
    print('----- event is clear -----')
    event.clear()

    for tid in list_tid:
        tid.join()
    print(">> 退出主线程")
```

Event有点像是短跑比赛中的发令枪，每个运动员代表一个线程，而发令枪则代表控制线程。当其设定set()操作时，相当于响枪。那么每个运动员（需要轮询检测Event信号）检测到isSet()后，即可进入逻辑控制。

总结：Event实际上就是一个多线程可以共享的boolean数据。

### 4.6. 信号量(Semaphore)

<font color=#FF0000>信号量用来控制线程并发数量</font>，BoundedSemaphore或Semaphore管理一个内置的计数 器，每当调用acquire()时-1，调用release()时+1。

计数器不能小于0，当计数器为 0时，acquire()将阻塞线程至同步锁定状态，直到其他线程调用 `release()` (类似于停车位的概念)。

BoundedSemaphore与Semaphore的唯一区别在于前者将在调用release()时检查计数 器的值是否超过了计数器的初始值，如果超过了将抛出一个异常。

例如，创建多个线程，但限制同一时间最多运行5个线程：

```py
semaphore = threading.Semaphore(5)

def foo():
    semaphore.acquire()
    time.sleep(2)
    print("当前时间：",time.ctime()) # 打印当前系统时间
    semaphore.release()


if __name__ == "__main__":
    thread_list = []
    for i in range(8):
        t = threading.Thread(target=foo,args=())
        thread_list.append(t)
        t.start()

    for t in thread_list:
        t.join()
```

### 4.7. Barriers
> [官网](https://docs.python.org/3/library/threading.html#barrier-objects)

与信号量相反，信号量限制线程的数量；而Barriers则需要至少x个数量才能激活。

* wait(timeout=None)
* reset()  重置障碍，返回默认的空状态，即当前阻塞的线程重新来过。
* 属性: partier, 通过障碍所需的线程数
* 属性: n_waiting, 当前在屏障中等待的线程数
* 属性: broken, 如果屏障处于断开状态，则返回True

```py
def open_the_door():
    print('人数够了， 开门!')

barrier = threading.Barrier(3, open_the_door)


class Customer(threading.Thread):
    count = 0

    def __init__(self, name):
        super().__init__()
        self.name = name
        print(f'【{self.name}】在等着开门...')
        self.count += 1

    def run(self):
        barrier.wait(2)
        print(f'【{self.name}】进门了。')


if __name__ == '__main__':
    for name in range(8):
        p = Customer(f"man_{name}")
        p.start()
        time.sleep(0.5)
```

### 4.8. Using locks, conditions, and semaphores in the `with` statement

```py
with some_lock:
    # do something...
```

is equivalent to:

```py
some_lock.acquire()
try:
    # do something...
finally:
    some_lock.release()
```

## 5. `Timer` 定时器
> [官网](https://docs.python.org/3/library/time.html)

```py
time.clock()  # 计时
time.sleep(0.5)

from time import Timer  # 计时器

timer = threading.Timer(5, func)
timer.start()
```

Python中的threading.timer是基于线程实现的，每次定时事件产生时，回调完响应函数后线程就结束。而<font color=#FF0000>Python中的线程是不能restart的，所以这种循环定时功能必须要在每次定时响应完成后再重新启动另一个定时事件</font>。

## 6. 线程安全

不要用多个线程同时访问一个list数据。

```py
li=[1,2,3,4,5]

def pri():
    while li:
        a=li[-1]
        print(a)
        time.sleep(1)
        try:
            li.remove(a)
        except Exception as e:
            print(">>", e)

for _ in range(2):
    sleep(0.1)
    tid = threading.Thread(target=pri)
    tid.start()
```

只有 `queue()` 底层封装了锁（blocking queue），故而线程安全。

```py
import threading,queue
from time import sleep
from random import randint

class Production(threading.Thread):
    def run(self):
        while True:
            r=randint(0,100)
            q.put(r)
            print("生产出来%s号包子"%r)
            sleep(1)

class Process(threading.Thread):
    def run(self):
        while True:
            re=q.get()
            print("吃掉%s号包子"%re)

if __name__=="__main__":
    q=queue.Queue(10)
    threads=[Production(),Production(),Production(),Proces()]
    for tid in threads:
        tid.start()
```

## 7. 线程池：ThreadPoolExecutor

从Python3.2开始，标准库为我们提供了 `concurrent.futures` 模块，它提供了 `ThreadPoolExecutor` 和 `ProcessPoolExecutor` 两个类，实现了对threading和multiprocessing的进一步抽象（这里主要关注线程池），不仅可以帮我们自动调度线程，还可以做到：

* 主线程可以获取某一个线程（或者任务的）的状态，以及返回值
* 当一个线程完成的时候，主线程能够立即知道
* 让多线程和多进程的编码接口一致

```py
from concurrent.futures import ThreadPoolExecutor
import time

# 参数times用来模拟网络请求的时间
def get_html(times):
    time.sleep(times)
    print("get page {}s finished".format(times))
    return times

executor = ThreadPoolExecutor(max_workers=2)

# 通过submit函数提交执行的函数到线程池中，submit函数立即返回，不阻塞
task1 = executor.submit(get_html, (3))
task2 = executor.submit(get_html, (2))

# done方法用于判定某个任务是否完成
print(task1.done())

# cancel方法用于取消某个任务,该任务没有放入线程池中才能取消成功
print(task2.cancel())

time.sleep(4)
print(task1.done())

# result方法可以获取task的执行结果
print(task1.result())  # 输出：3
```

### 7.1. 常规功能

* `task = submit(callback, args: tuple)` : 提交线程需要执行的任务（函数名和参数）到线程池中。注意submit()不是阻塞的，而是立即返回。
* 任务句柄能够使用 `task.done()` 方法判断该任务是否结束。
* `task.cancel()` 方法可以取消提交的任务，但如果任务已经在线程池中运行了，就取消不了。
* `task.result()` 方法可以获取任务的返回值。

### 7.2. 其他方法

#### 7.2.1. as_completed()

```py
from concurrent.futures import ThreadPoolExecutor, as_completed

# 参数times用来模拟网络请求的时间
def get_html(times):
    time.sleep(times)
    print("get page {}s finished".format(times))
    return times

executor = ThreadPoolExecutor(max_workers=2)
urls = [3, 2, 4]  # 并不是真的url
all_task = [executor.submit(get_html, (url)) for url in urls]

for future in as_completed(all_task):
    data = future.result()
    print("in main: get page {}s success".format(data))
```

as_completed()方法是一个生成器，在没有任务完成的时候，会阻塞，在有某个任务完成的时候，会 `yield` 这个任务，就能执行for循环下面的语句，然后继续阻塞住，循环到所有的任务结束。从结果也可以看出，<font color=#FF0000>先完成的任务会先通知主线程</font>。

#### 7.2.2. executor.map()

```py
# 参数times用来模拟网络请求的时间
def get_html(times):
    time.sleep(times)
    print("get page {}s finished".format(times))
    return times

executor = ThreadPoolExecutor(max_workers=2)
urls = [3, 2, 4] # 并不是真的url

for data in executor.map(get_html, urls):
    print("in main: get page {}s success".format(data))
```

使用map方法，无需提前使用submit方法，map方法与python标准库中的map含义相同，都是将序列中的每个元素都执行同一个函数。上面的代码就是对urls的每个元素都执行get_html函数，并分配各线程池。可以看到执行结果与上面的as_completed方法的结果不同，<font color=#FF0000>输出顺序和urls列表的顺序相同</font>，就算2s的任务先执行完成，也会先打印出3s的任务先完成，再打印2s的任务完成。

#### 7.2.3. wait()

wait()可以让主线程阻塞，直到满足设定的要求。

* ALL_COMPLETED
* FIRST_COMPLETED

```py
from concurrent.futures import ThreadPoolExecutor, wait, ALL_COMPLETED, FIRST_COMPLETED
import time

# 参数times用来模拟网络请求的时间
def get_html(times):
    time.sleep(times)
    print("get page {}s finished".format(times))
    return times

executor = ThreadPoolExecutor(max_workers=2)
urls = [3, 2, 4] # 并不是真的url
all_task = [executor.submit(get_html, (url)) for url in urls]
wait(all_task, return_when=ALL_COMPLETED)
print("main")
```

执行结果

```
get page 2s finished
get page 3s finished
get page 4s finished
main
```

### 7.3. 源码分析
> [简书](https://www.jianshu.com/p/b9b3d66aa0be)

cocurrent.future模块中的future的意思是未来对象，可以把它理解为一个在未来完成的操作，这是异步编程的基础 。在线程池submit()之后，返回的就是这个future对象，返回的时候任务并没有完成，但会在将来完成。也可以称之为task的返回容器，这个里面会存储task的结果和状态。那ThreadPoolExecutor内部是如何操作这个对象的呢？

下面简单介绍ThreadPoolExecutor的部分代码（[详情见简书](https://www.jianshu.com/p/b9b3d66aa0be)）：

1. init()
2. submit()
3. adjust_thread_count()
4. _WorkItem对象
5. _worker()


总结：

* future的设计理念很棒，在线程池/进程池和携程中都存在future对象，是异步编程的核心。
* ThreadPoolExecutor 让线程的使用更加方便，减小了线程创建/销毁的资源损耗，无需考虑线程间的复杂同步，方便主线程与子线程的交互。
* 线程池的抽象程度很高，多线程和多进程的编码接口一致。
