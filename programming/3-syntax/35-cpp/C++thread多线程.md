<!--
+++
title       = "C++ std::thread 多线程"
description = "1. 创建线程; 2. 同步 & 互斥; 3. std::async()"
date        = "2022-01-03"
tags        = ["usual"]
categories  = ["3-syntax","35-cpp"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 创建线程
> [创建线程的三种不同方式](https://mp.weixin.qq.com/s/J5cYorPTFeOeizum9jqWTQ)

那么std::thread在构造函数中接受什么？我们可以在std::thread对象上附加一个回调，该回调将在新线程启动时执行。这些回调可以是：

+ 函数指针

    ```cpp
    void thread_function(){
        for (int i = 0; i < 10000; i++);
        std::cout << "thread function Executing" << std::endl;
    }

    // 创建线程
    std::thread threadObj(thread_function);
    ```

+ <font color=#FF0000>函数对象</font>

    ```cpp
    class DisplayThread{
    public:
        void operator()(){
            std::cout << "Display Thread Executing" << std::endl;
        }
    };

    int main()
    {
        std::thread tid((DisplayThread()));
        tid.join();
    }
    ```

+ 类成员方法（指针）

    ```cpp
    class Producer{
    public:
        Producer(){};
        ~Producer() = default;

        void create(){
            cout << "create product: " << this->_no << endl;
            ++_no;
        }

    private:
        int _no = 100;
    };

    int main(){
        thread tid(&Producer::create, Producer());
        tid.join();
    }
    ```

    示例2

    ```cpp
    #include <iostream>
    #include <vector>
    #include <thread>
    class Wallet
    {
        int mMoney;
    public:
        Wallet() :mMoney(0) {}
        int getMoney() {
            return mMoney;
        }
        void addMoney(int money)
        {
            for (int i = 0; i < money; ++i)
            {
                mMoney++;
            }
        }
    };

    int testMultithreadedWallet()
    {
        Wallet walletObject;
        std::vector<std::thread> threads;
        for (int i = 0; i < 5; ++i)
        {
            threads.push_back(std::thread(&Wallet::addMoney, &walletObject, 100000));
        }
        for (int i = 0; i < threads.size(); i++)
        {
            threads.at(i).join();
        }
        return walletObject.getMoney();
    }

    int main()
    {
        int val = 0;
        for (int k = 0; k < 10; k++)
        {
            if ((val = testMultithreadedWallet()) != 500000)
            {
                std::cout << "Error at count = " << k << " Money in Wallet = " << val << std::endl;
            }
        }
        return 0;
    }
    ```

+ Lambda函数

    ```cpp
    std::thread threadObj([] {
            for (int i = 0; i < 10; i++)
                std::cout << "Display Thread Executing" << std::endl;
        });
    ```

### 1.1. move & bind

通过std::thread创建的线程是不可以复制的，但是可以移动。

```cpp
std::thread t1(threadfunc);
std::thread t2(std::move(t1));
```

移动后t1就不代表任何线程了，t2对象代表着线程 `threadfunc()` 。

另外，还可以通过 `std::bind` 来创建线程函数。

```cpp
class A {
public:
    void threadfunc(){
        std::cout << "bind thread func" << std::endl;
    }
};
​
A a;
std::thread t1(std::bind(&A::threadfunc,&a));
t1.join();
```

创建一个类A，然后再main函数中将类A中的成员函数绑定到线程对象t1上。

### 1.2. 区分线程

```cpp
std::thread::get_id()
```

要获取当前线程使用的标识符,即

```cpp
std::this_thread::get_id()
```

### 1.3. 传参
> [](https://mp.weixin.qq.com/s/2R41neLEwdv27r46q-NytA)

+ 简单传参

    ```cpp
    void threadCallback(int x, std::string str);
    std::thread threadObj(threadCallback, n, str);
    ```

+ 如何不将参数传递给c++11中的线程

+ 如何在c++11中传递对std::thread的引用

    线程函数threadCallback中的x引用了在新线程的堆栈上复制的临时值。如何解决呢？使用 `std::ref()` 即可。 `std::ref` 用于包装按引用传递的值。

    ```cpp
    void threadCallback(int const & x)
    std::thread threadObj(threadCallback, std::ref(x));
    ```

+ <font color=#FF0000>将指向类成员函数的指针分配为线程函数</font>

    ```cpp
    class DummyClass {
    public:
        DummyClass()
        {}
        DummyClass(const DummyClass & obj)
        {}
        void sampleMemberFunction(int x)
        {
            std::cout<<"Inside sampleMemberFunction "<<x<<std::endl;
        }
    };

    DummyClass dummyObj;
    int x = 10;
    std::thread threadObj(&DummyClass::sampleMemberFunction,&dummyObj, x);
    ```

### 1.4. 从线程返回值

很多时候，我们遇到希望线程返回结果的情况。现在的问题是如何做到这一点？ 让我们举个例子假设在我们的应用程序中，我们创建了一个将压缩给定文件夹的线程，并且我们希望该线程返回新的zip文件名及其结果。现在，我们有两种方法：

1. 使用指针在线程之间共享数据

    将指针传递给新线程，此线程将设置其中的数据。在此之前，在主线程中使用条件变量继续等待。当新线程设置数据并向条件变量发送信号时，主线程将唤醒并从该指针获取数据。为了简单起见，我们使用了一个条件变量，一个互斥锁和一个指针(即3个项)来捕获返回的值。为那么问题将变得更加复杂。

    有没有一个简单的方法从线程返回值？答案是肯定的，继续往下看。

2. 使用std::future

    std::future是一个类模板，其对象存储将来的值。那么这future模板有什么用？实际上，一个std::future对象在内部存储了将来将分配的值，并且还提供了一种访问该值的机制，即使用get()成员函数。但是，如果有人尝试在get()函数可用之前访问future的此关联值，则get()函数将阻塞直到该值不可用。 std::promise也是一个类模板，其对象承诺将来会设置该值。每个std::promise对象都有一个关联的std::future对象，一旦std::promise对象设置了该值，它将给出该值。一个std::promise对象与其关联的std::future对象共享数据。让我们一步一步来看看，在Thread1中创建一个std::promise对象。

    截至目前，该promise对象没有任何关联值。但是它提供了一个保证，肯定有人会在其中设置值，一旦设置了值，您就可以通过关联的std::future对象获得该值。但是现在假设线程1创建了这个promise对象并将其传递给线程2对象。现在，线程1如何知道何时线程2将在此promise对象中设置值？ 答案是使用std::future对象。每个std::promise对象都有一个关联的std::future对象，其他对象可以通过该对象获取promise设置的值。 现在，线程1将把promiseObj传递给线程2。然后线程1将通过std::future的get函数获取线程2在std::promise中设置的值。

    ![](https://img2020.cnblogs.com/blog/2039866/202110/2039866-20211029071507428-452948537.jpg) <!-- C++thread多线程/C++thread多线程-0.jpg -->

```cpp
#include <iostream>
#include <thread>
#include <future>

void initiazer(std::promise<int> * promObj){
    std::cout<<"Inside Thread"<<std::endl;
    promObj->set_value(35);
}

int main(){
    std::promise<int> promiseObj;
    std::future<int> futureObj = promiseObj.get_future();
    std::thread th(initiazer, &promiseObj);
    std::cout<<futureObj.get()<<std::endl;
    th.join();
    return 0;
}
```

此外，如果您希望线程在不同的时间点返回多个值，则只需在线程中传递多个std::promise对象，然后从关联的多个std::future对象中获取多个返回值。

### 1.5. thread_local

C++11中提供了thread_local，`thread_local` 定义的变量在每个线程都保存一份副本，而且互不干扰，在线程退出的时候自动销毁。

```cpp
#include <iostream>
#include <thread>
#include <chrono>
​
thread_local int g_k = 0;
​
void func1(){
    while (true){
        ++g_k;
    }
}
​
void func2(){
    while (true){
        std::cout << "func2 thread ID is : " << std::this_thread::get_id() << std::endl;
        std::cout << "func2 g_k = " << g_k << std::endl;

        std::this_thread::sleep_for(std::chrono::milliseconds(1000));
    }
}
​
void main(){
    std::thread t1(func1);
    std::thread t2(func2);
​
    t1.join();
    t2.join();
}
```

在func1()对g_k循环加1操作，在func2()每个1000毫秒输出一次g_k的值：

```
func2 thread ID is : 15312
func2 g_k = 0
func2 thread ID is : 15312
func2 g_k = 0
func2 thread ID is : 15312
func2 g_k = 0
```

可以看出func2()中的g_k始终保持不变。

## 2. 同步 & 互斥

### 2.1. std::mutex

```cpp
#include<mutex>
class Wallet
{
    int mMoney;
    std::mutex mutex;
public:
    Wallet() :mMoney(0) {}
    int getMoney() { return mMoney; }
    void addMoney(int money)
    {
        mutex.lock();  // 加锁
        for (int i = 0; i < money; ++i)
        {
            mMoney++;
        }
        mutex.unlock();  // 解锁
    }
};
```

+ lock()

    调用线程将锁住该互斥量。

    线程调用该函数会发生下面 3 种情况：

    1. 如果该互斥量当前没有被锁住，则调用线程将该互斥量锁住，直到调用 unlock之前，该线程一直拥有该锁。
    2. 如果当前互斥量被其他线程锁住，则当前的调用线程被阻塞住。
    3. 如果当前互斥量被当前调用线程锁住，则会产生死锁(deadlock)。

+ try_lock()

    尝试锁住互斥量，如果互斥量被其他线程占有，则当前线程也不会被阻塞。

    线程调用该函数也会出现下面 3 种情况：

    1. 如果当前互斥量没有被其他线程占有，则该线程锁住互斥量，直到该线程调用 unlock 释放互斥量。
    2. <font color=#FF0000>如果当前互斥量被其他线程锁住，则当前调用线程返回 false，而并不会被阻塞掉。</font>
    3. 如果当前互斥量被当前调用线程锁住，则会产生死锁(deadlock)。

#### 2.1.1. std::lock_guard

但是，如果我们忘记在功能结束时解锁互斥锁，该怎么办？在这种情况下，一个线程将退出而不释放锁，而其他线程将保持等待状态。如果锁定互斥锁后发生某些异常，则可能发生这种情况。为了避免这种情况，我们应该使用 `std::lock_guard` 。

Lock_Guard是一个类模板，它实现了互斥锁的RAII。它将互斥体包装在其对象中，并将附加的互斥体锁定在其构造函数中。当调用它的析构函数时，它会释放互斥锁。

```cpp
void addMoney(int money){
    // 在构造函数中，它锁定互斥锁 In constructor it locks the mutex
    std::lock_guard<std::mutex> lockGuard(mutex);
    for (int i = 0; i < money; ++i){
        // 如果在此位置发生异常，则由于堆栈展开，将调用lockGuard的析构函数。
        mMoney++;
    }
    //一旦函数退出，则析构函数，将调用析构函数中的lockGuard对象，它解锁互斥锁。
}
```

<font color=#FF0000>值得注意的是，lock_guard 对象并不负责管理 Mutex 对象的生命周期</font>，lock_guard 对象只是简化了 Mutex 对象的上锁和解锁操作，方便线程对互斥量上锁，即在某个 lock_guard 对象的声明周期内，它所管理的锁对象会一直保持上锁状态；而 lock_guard 的生命周期结束之后，它所管理的锁对象会被解锁。

```cpp
#include <list>
#include <mutex>
#include <algorithm>

std::list<int> some_list; // 1
std::mutex some_mutex; // 2

void add_to_list(int new_value){
    std::lock_guard<std::mutex> guard(some_mutex); // 3
    some_list.push_back(new_value);
}

bool list_contains(int value_to_find){
    std::lock_guard<std::mutex> guard(some_mutex); // 4
    return std::find(some_list.begin(),some_list.end(),value_to_find) != some_list.end();
}
```

在大多数情况下，互斥量通常会与保护的数据放在同一个类中，而不是定义成全局变量。这是面向对象设计的准则：将其放在一个类中，就可让他们联系在一起，也可对类的功能进行封装，并进行数据保护。

#### 2.1.2. std::unique_lock

但是 lock_guard 最大的缺点也是简单，没有给程序员提供足够的灵活度，因此，C++11 标准中定义了另外一个与 Mutex RAII 相关类 unique_lock，该类与 lock_guard 类相似，也很方便线程对互斥量上锁，但它提供了更好的上锁和解锁控制。

```cpp
#include <iostream>       // std::cout
#include <thread>         // std::thread
#include <mutex>          // std::mutex, std::lock, std::unique_lock
// std::adopt_lock, std::defer_lock
std::mutex foo, bar;

void task_a() {
     std::lock(foo, bar);         // simultaneous lock (prevents deadlock)
     std::unique_lock<std::mutex> lck1(foo, std::adopt_lock);
     std::unique_lock<std::mutex> lck2(bar, std::adopt_lock);
     std::cout << "task a\n";
     // (unlocked automatically on destruction of lck1 and lck2)
}

void task_b() {
     // foo.lock(); bar.lock(); // replaced by:
     std::unique_lock<std::mutex> lck1, lck2;
     lck1 = std::unique_lock<std::mutex>(bar, std::defer_lock);
     lck2 = std::unique_lock<std::mutex>(foo, std::defer_lock);
     std::lock(lck1, lck2);       // simultaneous lock (prevents deadlock)
     std::cout << "task b\n";
     // (unlocked automatically on destruction of lck1 and lck2)
}

void main() {
     std::thread th1(task_a);
     std::thread th2(task_b);

     th1.join();
     th2.join();
}
```

#### 2.1.3. 4种互斥量：递归/超时

在C++11中提供了4种互斥量。

```cpp
std::mutex;                  //非递归的互斥量
std::timed_mutex;            //带超时的非递归互斥量
std::recursive_mutex;        //递归互斥量
std::recursive_timed_mutex;  //带超时的递归互斥量
```

### 2.2. 条件变量

将布尔全局变量设为默认值false。在线程2中将其值设置为true，线程1将继续在循环中检查其值，并且一旦变为true，线程1将继续处理数据。但是由于它是两个线程共享的全局变量，因此需要与互斥锁同步。让我们看看它的代码。

```cpp
#include<iostream>
#include<thread>
#include<mutex>

class Application{
    std::mutex m_mutex;
    bool m_bDataLoaded;
public:
    Application(){
        m_bDataLoaded = false;
    }

    void loadData(){
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        std::cout << "Loading Data from XML" << std::endl;
        std::lock_guard<std::mutex> guard(m_mutex);
        m_bDataLoaded = true;
    }

    void mainTask(){
        std::cout << "Do Some Handshaking" << std::endl;
        m_mutex.lock();
        // 检查数据是否被加载
        while (m_bDataLoaded != true){
            m_mutex.unlock();
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
            m_mutex.lock();
        }
        m_mutex.unlock();
        std::cout << "Do Processing On loaded Data" << std::endl;
    }
};

int main(){
    Application app;
    std::thread thread_1(&Application::mainTask, &app);
    std::thread thread_2(&Application::loadData, &app);
    thread_2.join();
    thread_1.join();
    return 0;
}
```

这种方式具有以下缺点： 线程将继续获取该锁并释放它只是为了检查该值，因此它将消耗CPU周期，并使线程1变慢，因为它需要获取相同的锁来更新bool标志。因此，我们需要一种更好的机制来实现这一目标，例如，如果某种程度上线程1可以通过等待某个事件被发出信号而阻塞，而另一个线程可以通过该信号发出该事件并使线程1继续运行，则该机制就可以实现。这样可以节省许多CPU周期并提供更好的性能。

我们可以使用条件变量来实现。条件变量是一种事件，用于在2个线程之间发信号。一个线程可以等待它发出信号，而另一个线程可以发出信号。

---

条件变量是一种事件，用于在两个或多个线程之间发出信号。一个或多个线程可以等待它发出信号，而另一个线程可以发出信号。

+ wait():

    该函数使当前线程阻塞，直到信号通知条件变量或发生虚假唤醒为止。它自动释放附加的互斥锁，阻塞当前线程，并将其添加到等待当前条件变量对象的线程列表中。

+ notify_one():

    如果有任何线程在同一条件变量对象上等待，则notify_one解除阻塞其中一个等待线程。

+ notify_all():

    如果有任何线程在相同的条件变量对象上等待，则notify_all解除所有等待线程的阻塞。

```cpp
#include <iostream>
#include <thread>
#include <functional>
#include <mutex>
#include <condition_variable>

using namespace std::placeholders;

class Application{
    std::mutex m_mutex;
    std::condition_variable m_condVar;
    bool m_bDataLoaded;
public:
    Application(){
        m_bDataLoaded = false;
    }

    void loadData(){
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        std::cout << "Loading Data from XML" << std::endl;
        std::lock_guard<std::mutex> guard(m_mutex);
        m_bDataLoaded = true;
        m_condVar.notify_one();  // 通知变量
    }

    bool isDataLoaded(){
        return m_bDataLoaded;
    }

    void mainTask(){
        std::cout << "Do Some Handshaking" << std::endl;
        std::unique_lock<std::mutex> mlock(m_mutex);
        // 开始等待条件变量收到信号，wait()将在内部释放锁并使线程阻塞，一旦条件变量得到信号，就恢复线程并再次获得锁。
        //  然后检查是否满足条件，如果条件满足，则继续，否则继续等待。
        m_condVar.wait(mlock, std::bind(&Application::isDataLoaded, this));
        std::cout << "Do Processing On loaded Data" << std::endl;
    }
};

int main(){
    Application app;
    std::thread thread_1(&Application::mainTask, &app);
    std::thread thread_2(&Application::loadData, &app);
    thread_2.join();
    thread_1.join();
    return 0;
}
```

### 2.3. 信号量


## 3. std::async()
> [async教程和示例](https://mp.weixin.qq.com/s/F4ABQXkdSYQTwxTwPU5dLA)
