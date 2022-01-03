<!--
+++
title       = "Python多进程 - subprocess & multiprocess"
description = "1. subprocess; 2. multiprocess"
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

两个模块的对比：

+ multiprocess: 是同一个代码中通过多进程调用其他的模块（也是自己写的）
+ subprocess: 直接调用外部的二进制程序，而非代码模块

## 1. subprocess
> [homepage](https://docs.python.org/3/library/subprocess.html)

该模块主要用于`调用子程序`。

### 1.1. run(), 阻塞调用

```py
subprocess.call("mv abc", shell=True) # depressed after python3.5
subprocess.run(args, *, stdin=None, input=None, stdout=None, stderr=None, shell=False, timeout=None, check=False) -> subprocess.CompletedProcess
```

`run/call()` 函数均为<font color=#FF0000>主进程阻塞</font>执行子进程，直到子进程调用完成返回；

#### 1.1.1. shell选项

如果 `shell=True` ，则将通过shell执行指定的命令。如果你希望方便地访问其他shell功能，如<font color=#FF0000>shell管道、文件名通配符、环境变量扩展和扩展</font>，例如 `~` 到用户的主目录，这会很有用。

```py
# subprocess.run("ls | grep xxx".split(" "))
# 以上语句，无法获取到想要的结果，因为subprocess本身并不执行 `|` 管道符
subprocess.run("ls | grep xxx".split(" "), shell=True)
```

#### 1.1.2. 获取输出

```py
proc = subprocess.run(['uname', '-r'], stdout=su.PIPE)
print(proc.returncode)
print(proc.stdout)
```

#### 1.1.3. check选项

当设置 `check=True` 时，如果returncode返回非0，则抛出异常 `CalledProcessError` 。

> If check is True and the exit code was non-zero, it raises a `CalledProcessError` . The `CalledProcessError` object will have the **return code** in the returncode attribute, and <font color=#FF0000>output & stderr attributes if those streams were captured</font>.

### 1.2. call(), 旧版本函数

如果你不得不在Python3.5之前的版本运行，那么你可以选用以下几种方式，来替代 `subprocess.run()` 的调用。

```py
subprocess.call(args, *, stdin=None, stdout=None, stderr=None, shell=False, cwd=None, timeout=None, **other_popen_kwargs)
```

如果希望在 `call()` 处理过程中使用 `check=True` ，则直接使用 `check_call()` 函数，它等效于 `run(..., check=True)` 。

> <font color=#FF0000>Note Do not use `stdout=PIPE`  or `stderr=PIPE`  with ## this function.</font> The child process will block if it generates enough output to a pipe to fill up the OS pipe buffer as the pipes are not being read from.

那么如何获取到 `stdout` 呢？

```py
subprocess.check_output(args, *, stdin=None, stderr=None, shell=False, cwd=None, encoding=None, errors=None, universal_newlines=None, timeout=None, text=None, **other_popen_kwargs)
```

This is equivalent to: `run(..., check=True, stdout=PIPE).stdout`

也可以捕获到stderr，使用 `stderr=subprocess.STDOUT` :

```py
>>> subprocess.check_output(
...     "ls non_existent_file; exit 0",
...     stderr=subprocess.STDOUT,
...     shell=True)
'ls: non_existent_file: No such file or directory\n'
```

### 1.3. Popen, 非阻塞
> [homepage](https://docs.python.org/3/library/subprocess.html#popen-constructor)

简单使用示例：

```py
import subprocess as sub

>>> ls = sub.Popen(['ls'], stdout=sub.PIPE)
>>> for f in ls.stdout: print(f)
...
b'fileA.txt\n'
b'fileB.txt\n'
b'ls.txt\n'

>>> ex = sub.Popen(['ex', 'test.txt'], stdin=sub.PIPE)
>>> ex.stdin.write(b'i\nthis is a test\n.\n')
19
>>> ex.std.write(b'wq\n')
3
```

注意： `shell=True` 选项会开启Windows控制台执行命令，这会引发一个问题——Windows中的控制台命令是后台执行的！所以当python调用 `Popen.terminate()` 时，只是关闭了控制台，控制台命令却仍在后台执行（直至结束）。所以，如需关闭时同时关闭命令，请不要使用 `Popen(str_cmd, shell=True)`，用 `Popen(str_cmd.split(' ')` 代替。

```py
p.poll()  # 检查进程是否终止，如果终止返回returncode，否则返回None
p.wait(timeout)  # 等待子进程终止(阻塞父进程)
p.communicate(input,timeout)  # 和子进程交互，发送和读取数据(阻塞父进程)
p.send_signal(singnal)  # 发送信号到子进程
p.terminate()  # 停止子进程,也就是发送SIGTERM信号到子进程
p.kill()  # 杀死子进程。发送SIGKILL信号到子进程
```

创建Popen对象后，<font color=#FF0000>主程序不会自动等待子进程完成</font>。

以上三个成员函数都可以用于等待子进程返回：while循环配合Popen.poll()、Popen.wait()、Popen.communicate()。<font color=#FF0000>由于后面二者都会阻塞父进程，所以无法实时获取子进程输出</font>，而是等待子进程结束后一并输出所有打印信息。另外，Popen.wait()、Popen.communicate()分别将输出存放于**管道**和**内存**，前者容易超出默认大小而导致死锁，因此不推荐使用。

注意：`p.communicate(stdin="xxx")` 该函数会终止子程序（因为其是阻塞的，当父程序解除阻塞时，意味着子程序已经结束了）。所以，如果你的子程序是 `while...` 或者 `for line in sys.stdin` 时，你会发现<font color=#FF0000>子程序意外的结束了</font>，而不是在循环中等待。

#### 1.3.1. 管理子进程（通信）

Popen类具有三个与输入输出相关的属性：`Popen.stdin` , `Popen.stdout` 和 `Popen.stderr` ，分别对应子进程的标准输入/输出/错误。它们的值可以是<font color=#FF0000>PIPE、文件描述符(正整数)、文件对象或None</font>：

+ PIPE表示创建一个连接子进程的新管道，默认值None, 表示不做重定向。
+ 子进程的文件句柄可以从父进程中继承得到。
+ 仅 `stderr` 可以设置为 `STDOUT` ，表示将子进程的标准错误重定向到标准输出。

```py
child1 = subprocess.Popen(["ls","-l"], stdout=subprocess.PIPE)
child2 = subprocess.Popen(["wc"], stdin=child1.stdout, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
out = child2.communicate()
```

其中，subprocess.PIPE为文本流提供一个缓存区，child1的stdout将文本输出到缓存区；<font color=#FF0000>随后child2的stdin从该PIPE读取文本</font>，child2的输出文本也被存放在PIPE中，而标准错误信息则重定向到标准输出；最后，communicate()方法从PIPE中读取child2子进程的标准输出和标准错误。

注意：`subprocess.stdxxx` 操作bytes字节，而 `sys.stdin` 则是string。

##### sys.stdin

Python的sys模块定义了标准输入/输出/错误：

```py
sys.stdin  # 标准输入
sys.stdout # 标准输出
sys.stderr # 标准错误信息
```

以上三个对象类似于文件流，因此可以使用readline()和write()方法进行读写操作。也可以使用print()，等效于sys.stdout.write()。

需要注意的是，除了直接向控制台打印输出外，标准输出/错误的打印存在缓存，为了实时输出打印信息，需要执行

```py
sys.stdout.flush()
sys.stderr.flush()
```

读取 `sys.stdin` 的方式：

```py
for line in sys.stdin:
    print(type(line))  # string
    ...
```

##### 示例

前面提到，如果子程序只是调用一次，并获取其输出状态，可以使用 `p.communicate(stdin, timeout)` 结合 `p.returncode` 实现。

但如果你的程序想实现类似 TCP-C/S 式的持续通信服务，这里提供一个Demo:

父程序：

```py
proc = subprocess.Popen(command,
                        stdin=subprocess.PIPE,
                        stdout=subprocess.PIPE)
                        # stderr=subprocess.STDOUT)

# try:
while proc.poll() is None:  # 持续输入
    str_input = input("Please Input a path: ")
    if str_input == "quit":
        break

    bytes_path = f"/home/brt/{str_input}.jpg\n".encode()  # 注意这里需要\n换行符
    proc.stdin.write(bytes_path)  # 需要使用bytes
    proc.stdin.flush()
    # proc.communicate(stdin=str_input, timout=5)

    bytes_state = proc.stdout.readline()  # bytes
    if bytes_state == b"ok\n":
        print("Well Done.")

# except subprocess.TimeoutExpired:
#     print("子程序Timout未响应...")
#     break

# if proc.poll() is None:  # communicate()超时时，子程序可能未退出
#     proc.kill()
```

子程序：

```py
for path_save in sys.stdin:  # 持续读取
    path_save = path_save.strip()  # 删除多余的换行符
    img = grabclipboard_byQt(cb)
    # sys.stderr.write(">>>", img)
    if img:
        save_clipboard_image(img, path_save)
        str_pipe = "ok"
    else:
        str_pipe = ""

    # 以下内容用于写入stdout管道，向父程序反馈
    # sys.stdout.write(str_pipe + "\n")  # 必须添加换行符
    print(str_pipe)
    sys.stdout.flush()  # 及时清空缓存
```

## 2. multiprocess
> [homepage](https://docs.python.org/3/library/multiprocessing.html)

### 2.1. 创建子进程

#### 2.1.1. 直接使用Process模块创建进程

```py
Process([group [, target [, name [, args [, kwargs]]]]])
```

+ group: 参数未使用，值始终为None
+ target: 表示调用对象，即子进程要执行的任务
+ name: 子进程的名称
+ args: 调用对象的位置参数元组，args=(1,2,'egon',)
+ kwargs: 调用对象的字典,kwargs={'name':'egon','age':18}

举例说明:

```py
from multiprocessing import Process

def func():
    print("子进程正在运行")
    time.sleep(1)
    print("子进程ID>>>", os.getpid())
    print("子进程的父进程ID>>>", os.getppid())

if __name__ == '__main__':
    p = Process(target=func,)
    p.start()

    print("父进程ID>>>", os.getpid())
    print("父进程的父进程ID>>>", os.getppid())

    p.join()
    print("主进程执行完毕!")
```

#### 2.1.2. 继承的形式创建进程

```py
from multiprocessing import Process

class MyProcess(Process):
    def __init__(self, name):
        super().__init__()
        self.name = name

    def run(self):
        print("子进程的名字是>>>", self.name)
        time.sleep(2)
        print("子进程结束")

if __name__ == '__main__':
    p = MyProcess(123, name="子进程01")
    p.start()
    print("p.name:", p.name, "\np.pid:", p.pid)
    print("p.is_alive:", p.is_alive())

    p.terminate()  # 给操作系统发送一个关闭进程p1的信号,让操作系统去关闭它
    p.join()
    print("主进程结束")
```

#### 2.1.3. Process模块方法介绍

+ p.start(): 启动进程，并调用该子进程中的p.run()
+ p.run(): 进程启动时运行的方法，正是它去调用target指定的函数
+ p.terminate(): 强制终止进程p，不会进行任何清理操作，如果p创建了子进程，该子进程就成了僵尸进程，使用该方法需要特别小心这种情况。<font color=#FF0000>如果p还保存了一个锁那么也将不会被释放，进而导致死锁</font>
+ p.is_alive(): 如果p仍然运行，返回True
+ p.join([timeout]): 主线程等待p终止（强调：是主线程处于等的状态，而p是处于运行的状态）

### 2.2. 进程管理

#### 2.2.1. 僵尸进程（有害）

任何一个子进程(init除外)在exit()之后，并非马上就消失掉，而是留下一个称为僵尸进程(Zombie)的数据结构，等待父进程处理。这是每个子进程在结束时都要经过的阶段。如果子进程在exit()之后，父进程没有来得及处理，这时用ps命令就能看到子进程的状态是“Z”。如果父进程能及时 处理，可能用ps命令就来不及看到子进程的僵尸状态，但这并不等于子进程不经过僵尸状态。 如果父进程在子进程结束之前退出，则子进程将由init接管。init将会以父进程的身份对僵尸状态的子进程进行处理。

#### 2.2.2. 孤儿进程（无害）

孤儿进程：一个父进程退出，而它的一个或多个子进程还在运行，那么那些子进程将成为孤儿进程。孤儿进程将被init进程(进程号为1)所收养，并由init进程对它们完成状态收集工作。孤儿进程是没有父进程的进程，孤儿进程这个重任就落到了init进程身上，init进程就好像是一个民政局，专门负责处理孤儿进程的善后工作。每当出现一个孤儿进程的时候，内核就把孤儿进程的父进程设置为init，而init进程会循环地wait()它的已经退出的子进程。这样，当一个孤儿进程凄凉地结束了其生命周期的时候，init进程就会代表党和政府出面处理它的一切善后工作。因此孤儿进程并不会有什么危害。

#### 2.2.3. 守护进程

使用平常的方法时,<font color=#FF0000>子进程是不会随着主进程的结束而结束,只有当主进程和子进程全部执行完毕后,程序才会结束.</font>但是,如果我们的需求是: 主进程执行结束,由该主进程创建的子进程必须跟着结束. 这时,我们就需要用到守护进程了.

主进程创建守护进程:

1. 守护进程会在主进程代码执行结束后就终止
2. 守护进程内无法再开启子进程,否则抛出异常: AssertionError: daemonic processes are not allowed to have children

需要注意的是: 进程之间是相互独立的,主进程代码运行结束,守护进程随机终止.

```py
class Myprocess(Process):
    def __init__(self,person):
        super().__init__()
        self.person = person
    def run(self):
        print("这个人的ID号是:%s" % os.getpid())
        print("这个人的名字是:%s" % self.name)
        time.sleep(3)

if __name__ == '__main__':
    p = Myprocess('李华')
    p.daemon=True #一定要在p.start()前设置,设置p为守护进程,禁止p创建子进程,并且父进程代码执行结束,p即终止运行
    p.start()
    # time.sleep(1) # 在sleep时linux下查看进程id对应的进程ps -ef|grep id
    print('主进程执行完毕!')
```

### 2.3. 进程同步
> [cnblog: Python multiprocess模块(中)](https://www.cnblogs.com/haitaoli/p/9842957.html)

### 2.4. 进程池
> [cnblog: Python multiprocess模块(下)](https://www.cnblogs.com/haitaoli/p/9849031.html)

### 2.5. 管道：进程间通讯

管道（不推荐使用）是进程间通信(IPC)的方式，但它可能导致数据不安全的情况出现。

```py
#创建管道的类:
Pipe([duplex]): 在进程之间创建一条管道, 并返回元组(conn1, conn2), 其中conn1, conn2表示管道两端的连接对象. 强调一点: 必须在产生Process对象之前产生管道.

#参数介绍:
dumplex: 默认管道是全双工的, 如果将duplex设置成False, conn1只能用于接收, conn2只能用于发送.

#主要方法:
conn1.recv(): 接收conn2.send(obj)发送的对象. 如果没有消息可接收, recv()方法会一直阻塞. 如果连接的另外一端已经关闭, 那么recv()方法会抛出EOFError.
conn1.send(obj):通过连接发送对象。obj是与序列化兼容的任意对象
#其他方法:
conn1.close(): 关闭连接. 如果conn1被垃圾回收, 将自动调用此方法
conn1.fileno(): 返回连接使用的整数文件描述符
conn1.poll([timeout]): 如果连接上的数据可用, 返回True. timeout指定等待的最长时限. 如果省略此参数, 方法将立即返回结果. 如果将timeout设置成None, 操作将无限期地等待数据到达.

conn1.recv_bytes([maxlength]): 接收c.send_bytes()方法发送的一条完整的字节消息. maxlength指定要接收的最大字节数. 如果进入的消息, 超过了这个最大值, 将引发IOError异常, 并且在连接上无法进行进一步读取. 如果连接的另外一端已经关闭, 再也不存在任何数据, 将引发EOFError异常.
conn.send_bytes(buffer[,offset[,size]]): 通过连接发送字节数据缓冲区, buffer是支持缓冲区接口的任意对象, offset是缓冲区中的字节偏移量, 而size是要发送的字节数. 数据结果以单条消息的形式发出, 然后调用c.recv_bytes()函数进行接收

conn1.recv_bytes_into(buffer[,offset]): 接收一条完整的字节消息, 并把它保存在buffer对象中, 该对象支持可写入的缓冲区接口(即bytearray对象或类似的对象). offset指定缓冲区中放置消息处的字节位移. 返回值是收到的字节数. 如果消息长度大于可用的缓冲区空间, 将引发BufferTooShort异常.
```

示例：子进程给主进程发送消息：

```py
from multiprocessing import Process, Pipe   # 引入Pipe模块

def func(conn):
    conn.send("HelloWorld!")    # 子进程发送了消息
    conn.close()                # 子进程关闭通道的一端

if __name__ == '__main__':
    parent_conn, child_conn = Pipe()    # 建立管道,拿到管道的两端,双工通信方式,两端都可以收发消息
    p = Process(target=func, args=(child_conn,))    # 将管道的一端给子进程
    p.start()   # 开启子进程
    print("主进程接收>>>", parent_conn.recv())   # 主进程接收了消息
    p.join()
    print("主进程执行结束!")
```

主进程给子进程发送消息：

```py
from multiprocessing import Process, Pipe   # 引入Pipe模块

def func(conn):
    msg = conn.recv()  # (5)子进程通过管道的另一端接收信息
    print("The massage from parent_process is>>>", msg)

if __name__ == '__main__':
    parent_conn, child_conn = Pipe()   # (1)创建管道,拿到管道的两端
    p = Process(target=func, args=(child_conn,))    # (2)创建子进程func, 把child_conn给func
    p.start()   # (3)启动子进程
    parent_conn.send("Hello,child_process!")    # (4)主进程通过parent_conn给子进程发送信息
```

主进程和子进程互相收发消息：

```py
from multiprocessing import Process, Pipe

def func(parent_conn, child_conn):
    msg = parent_conn.recv()    # (5)子进程使用parent_conn接收主进程的消息
    print("子进程使用parent_conn接收>>>", msg)  # (6)打印接收到的消息
    child_conn.send("子进程使用child_conn给主进程发送了一条消息")  # (7)子进程发送消息
    print("子进程执行完毕")

if __name__ == '__main__':
    parent_conn, child_conn = Pipe()    # (1)创建管道,拿到管道两端
    child_conn.send("主进程使用child_conn给子进程发送了一条消息")
    p = Process(target=func, args=(parent_conn, child_conn))
    p.start()
    p.join()
    msg = parent_conn.recv()
    print("主进程使用parent_conn接收>>>", msg)
    print("主进程执行完毕!")
```

应该特别注意管道端点的正确管理问题. 如果生产者或消费者中都没有使用管道的某个端点, 就应将它关闭,否则就会抛出异常. 例如: 当生产者关闭了管道的输出端时, 消费者也要同时关闭管道的输入端. 如果忘记执行这些步骤, 程序可能在消费者中的recv()操作上挂起(就是阻塞). 管道是由操作系统进行引用计数的, 在所有进程中关闭管道的相同一端就会生成EOFError异常. 因此, 在生产者中关闭管道不会有任何效果, 除非消费者也关闭了相同的管道端点.

管道可以用于双工通信, 通常利用在客户端/服务端中使用的请求/响应模型, 或者远程过程调用, 就可以使用管道编写与进程交互的程序。

### 2.6. Manager模块：进程间数据共享
> [homepage](https://docs.python.org/3/library/multiprocessing.html#managers)

展望未来, 基于消息传递的并发编程是大势所趋. 即便是使用线程, 推荐做法也是将程序设计为大量独立的线程集合, 通过消息队列交换数据. 这样极大地减少了对使用锁定和其他同步手段的需求, 还可以扩展到分布式系统中.

进程间应该尽量避免通信, 即便需要通信, 也应该选择进程安全的工具来避免加锁带来的问题, 应该尽量避免使用本节所讲的共享数据的方式, 以后我们会尝试使用数据库来解决进程之间的数据共享问题.

进程之间数据共享的模块之一Manager模块:

进程间数据是独立的, 可以借助于队列或管道实现通信, 二者都是基于消息传递的. 虽然进程间数据独立, 但可以通过Manager实现数据共享.

```py
from multiprocessing import Process, Manager

def func(m_dic):
    m_dic["name"] = "王力宏"   # 修改manager字典

if __name__ == '__main__':
    m = Manager()   # 创建Manager对象
    m_dic = m.dict({"name": "王乃卉"}) # 创建manager字典
    print("主进程>>>", m_dic)
    p = Process(target=func, args=(m_dic,)) # 创建子进程
    p.start()
    p.join()
    print("主进程>>>", m_dic)

# 执行结果:
# 主进程>>> {'name': '王乃卉'}
# 主进程>>> {'name': '王力宏'}
```

多进程共同去处理共享数据的时候，就和我们多进程同时去操作一个文件中的数据是一样的，不加锁就会出现错误的结果，进程不安全的，所以也需要加锁。

不加锁对共享数据进行修改，是不安全的：

```py
from multiprocessing import Process, Manager

def func(m_dic):
    m_dic["count"] -= 1

if __name__ == '__main__':
    m = Manager()
    m_dic = m.dict({"count": 100})
    p_list = []
    # 开启20个进程来对共享数据进行修改
    for i in range(20):
        p = Process(target=func, args=(m_dic, ))
        p.start()
        p_list.append(p)
    [p.join() for p in p_list]
    print("主进程>>>", m_dic)
```

执行结果:偶尔会出现 “主进程>>> {'count': 81}” 的情况, 这是因为共享数据不变, 但是当多个子进程同时访问共享数据并对其进行修改时, 由于修改的过程是要重写对共享数据进行赋值的, 在这个赋值的过程中, 可能一个子进程还没来得及赋值成功, 就有另外的一个子进程拿到原先的值, 这样一来, 就会出现多个子进程修改同一个共享数据。于是就出现了上面代码结果偶尔会少减了一次的现象. 综上所述,共享数据是不够安全的, 而"加锁"是一个很好的解决办法.

```py
from multiprocessing import Process, Manager, Lock

def func(m_dic, m_lock):
    with m_lock:
        m_dic["count"] -= 1
    # 等同于:
    # m_lock.acquire()
    # m_dic["count"] -= 1
    # m_lock.release()

if __name__ == '__main__':
    m = Manager()
    m_lock = Lock()
    m_dic = m.dict({"count": 100})
    p_list = []
    # 开启20个进程来对共享数据进行修改
    for i in range(20):
        p = Process(target=func, args=(m_dic, m_lock))
        p.start()
        p_list.append(p)
    [p.join() for p in p_list]
    print("主进程", m_dic)
```

加锁后, 多次尝试运行程序, 执行结果稳定可靠. 不难看出, 加锁后 共享数据是安全的.

### 2.7. multiprocessing.Queue
> [homepage](https://docs.python.org/3/library/multiprocessing.html#queue)
