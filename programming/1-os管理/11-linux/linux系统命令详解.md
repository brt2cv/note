<!--
+++
title       = "Linux系统命令（不定时更新）"
description = "1. 简单指令; 2. su; 3. who; 4. chmod; 5. env; 6. sshpass; 7. netstat/ss; 8. systemctl; 9. locate/mlocate; 10. top/htop; 11. lftp; 12. kill/killall; 13. supervisor（守护进程）; 14. Catfish; 15. grep & ack; 16. mount & /etc/fstab, 挂载磁盘; 17. 自启动管理（取消ubuntu开机升级提示）; 18. /etc/network, 网络配置; 19. ps; 20. uptime; 21. df/du; 22. wc; 23. which/where/whereis; 24. bind; 25. sed"
date        = "2022-01-03"
tags        = ["usual"]
categories  = ["1-os管理","11-linux"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 简单指令

+ uptime: 打印当前时间
+ xclip: 使用剪切板

    ```sh
    # 复制pwd或uptime内容到剪切板
    pwd | xclip  # -i选项可选，结果一样
    xclip -o  # /home/xxx
    ```

+ `find ./ | grep __init__.py` : 通过文件名查找文件

## 2. su

编辑bash时，遇到过此类问题：

```sh
#!/bin/bash
sudo echo 'abc' > /etc/test
```

尽管使用了sudo权限，但脚本执行时仍然会报无权限写入/etc/目录。原因在于sudo的权限只提供给了command_1： `sudo echo abc` ，而真正需要使用的是 command_2： ` > /etc/test` 。故需要做如下调整：

```sh
su [-root] -c "echo 'abc' > /etc/test"
```

su 用于让用户在登录期间变成另外一个用户。后边不带 username 使用时，su 默认会变成超级用户。可选的选项 `-` （对，就单独一个 `-` ，完整写法是 `-l` 或 `--login` ），可以用于提供一个类似于用户直接登录的环境，用户可能期望是这样的。

### 2.1. su命令中passwd的自动输入

su本身会去调passwd这个程序，而passwd会检测“必须从终端上得倒输入”，所以任何重定向都是不起作用的，但是……有一个东东有用，就是expect，它通过伪终端和 spawn 出来的程序通信，而伪终端是 passwd 会认的（不然网络登陆就不行了），简单的脚本如下：

```sh
#!/usr/bin/expect -f

spawn su -l
expect "Password:*"
sleep 1
send "your password\r"
expect "root]#"
interact
exit
```

当然这种方式的主要用途不是提供给别人用哈，不然密码的随意暴露也太危险了，所以它是一种当前使用非常广泛、用于批处理自动化测试的脚本语言。类似于上面脚本，你在自己机器上当然也可以为了省事而这样做。

expect同样支持scp的密码自动填入：

```sh
#!/usr/bin/expect

set password 123
spawn scp ./south_db.sql root@135.252.234.118:~
expect -nocase "password: "
send "$password\r"
expect eof
```

可惜su并不支持“无密码公钥认证”，否则可以采用类似scp的公钥认证方式，从而避免<font color=#FF0000> expect 明文记录密码</font>。

## 3. who

查看当前谁在使用该主机：`whoami`

查找自己所在的终端信息：`who am i` (等同于 `who` )

## 4. chmod

常用选项

```sh
u   用户
g   组
o   其它
a   所有用户(默认)
```

实例：

```sh
$ chmod u+x file  # 给file的属主增加执行权限
$ chmod 751 file  # 给file的属主分配读、写、执行(7)的权限，给file的所在组分配读、执行(5)的权限，给其他用户分配执行(1)的权限
$ chmod u=rwx,g=rx,o=x file  # 上例的另一种形式
$ chmod =r file  # 为所有用户分配读权限
$ chmod 444 file  # 同上例
$ chmod a-wx,a+r file  # 同上例
$ chmod -R u+r directory  # 递归地给directory目录下所有文件和子目录的属主分配读的权限
$ chmod 4755  # 设置用ID，给属主分配读、写和执行权限，给组和其他用户分配读、执行的权限
```

### 4.1. 文件权限说明

+ r: read读取  4
+ w: write写入  2       
+ x: execute执行  1

文件：

+ r: 查看文件内容
+ w: 编辑文件内容
+ x: shell/python脚本

目录：

+ r: 查看目录下的文件
+ w: 修改目录下的文件
+ x: 切换目录




## 5. env

查看各类环境变量用什么命令?

查看具体某个，如home: `env $HOME`

## 6. sshpass

远程连接某台主机: `sshpass -p your_password  ssh [-p nPort] root@192.168.11.11`

从密码文件读取文件内容作为密码去远程连接主机: `sshpass -f xxx.txt  ssh root@192.168.11.11`

向scp程序传送默认密码: `sshpass -p 'passwd'  scp root@host_ip:/home/test/t ./tmp/`

## 7. netstat/ss

安装

```sh
apt install net-tools
```

<font color=#FF0000>`netstat` 命令已被弃用</font>，而 `ss` 命令代替了显示更详细的网络统计信息。

`netstat/ss -tnlp`

+ `-t` 启用TCP端口列表
+ `-u` 启用UDP端口列表
+ `-l` 仅输出监听套接字
+ `-n` 显示端口号
+ `-p` 显示进程/程序名称

### 7.1. 实时观察TCP和UDP开放端口

要实时监视TCP和UDP端口，可以使用所示的watch实用程序运行netstat或ss工具。

`watch ss -tulpn`

![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200707080914879-43204434.jpg) <!-- linux系统命令详解/linux系统命令详解-0.jpg -->

## 8. systemctl

systemctl提供了一组子命令来管理单个的 unit，其命令格式为：

```
systemctl [command] [unit]
```

command 主要有：

+ start：立刻启动后面接的 unit。
+ stop：立刻关闭后面接的 unit。
+ restart：立刻关闭后启动后面接的 unit，亦即执行 stop 再 start 的意思。
+ reload：不关闭 unit 的情况下，重新载入配置文件，让设置生效。
+ enable：设置下次开机时，后面接的 unit 会被启动。
+ disable：设置下次开机时，后面接的 unit 不会被启动。
+ status：目前后面接的这个 unit 的状态，会列出有没有正在执行、开机时是否启动等信息。
+ is-active：目前有没有正在运行中。
+ is-enable：开机时有没有默认要启用这个 unit。
+ kill ：不要被 kill 这个名字吓着了，它其实是向运行 unit 的进程发送信号。
+ show：列出 unit 的配置。
+ mask：注销 unit，注销后你就无法启动这个 unit 了。
+ unmask：取消对 unit 的注销。

## 9. locate/mlocate

## 10. top/htop

## 11. lftp

## 12. kill/killall

## 13. supervisor（守护进程）
> [supervisor守护Tornado网站](https://segmentfault.com/a/1190000016678840)

Supervisord是用Python实现的一款非常实用的进程管理工具。

使用nuhup可以后台运行一个进程，但是一旦网站出现错误，进程关闭，网站将会停止运行。这时候就需要supervisor来帮我们守护进程，自动重启网站。

```sh
sudo apt-get install supervisor
```

修改配置 `/etc/supervisord.conf` 只需要将最后一行改为下面的形式就可以了：

```
[include]
files=/etc/supervisor/conf.d/.conf
```

在 `/etc/supervisor/conf.d/` 下创建文件：`tornado.conf`

---

启动supervisor

1. 明确指定配置文件 `supervisord -c /etc/supervisord.conf`
2. 使用 `user` 用户启动supervisord: `supervisord -u user`

---

supervisorctl

### 13.1. nginx配合supervisor实现多进程

### 13.2. nginx代理多进程

## 14. Catfish

Catfish，是一款命令行工具，支持搜索文档、图像、音乐、视频等文件类型，十分好用。

在使用 Catfish 搜索文件时，你可以选择 find、locate、slocate 等搜索方法；可设定不同的搜索条件，如精确匹配、搜索隐藏文件、全文搜索、限制搜索结果数量等。此外，也可选择要执行搜索的目录，并对搜索结果执行相应操作。

Catfish 已被大多数流行的 Linux 发行版所收录，因此，你只需通过所用发行版的包管理工具即可安装。如果你对 Catfish 的源代码感兴趣，那么也可从作者的网站获取。

## 15. grep & ack
> [cnblog: Linux文本三剑客超详细教程-grep、sed、awk](htmltps://www.cnblogs.com/along21/p/10366886.html)

grep是传统的文本搜索工具。

1. grep最简单的用法，匹配一个词：`grep word <filename>`
2. 能够从多个文件里匹配：`grep word <filename1> <filenam2> <filename3>`
3. 能够使用正則表達式匹配：`grep -E pattern f1 f2 f3...`

常用options:

* `-i` : 忽略大小写
* `-E` : 使用扩展正则表达式
* `-d` : 查找的是目录而非文件
* `-e` : 实现多个选项间的逻辑or关系
* `-n` : 显示匹配的行号
* `-v` : 显示不被pattern 匹配到的行，相当于[^] 反向匹配
* `-w` : 匹配 整个单词
* `-r` : 此参数的效果和指定 `-d recurse` 参数相同
* `--include='*.py'`
* `--exclude={xxx, yyy}`
* `--exclude={env,__pycache__}`

但grep常常因为匹配二进制等问题而显得效率低下，且书写的参数也并不简练。所以就有了ack则是一个现代化的过滤器。ack的5大卖点：

- 速度非常快,因为它只搜索有意义的东西。
- 更友好的搜索，<font color=#FF0000>忽略那些不是你源码的东西</font>。
- 为源代码搜索而设计，用更少的击键完成任务。

---

这里推荐ack工具，常用选项包括：

+ `--ignore-dir={dir_1,dir2}`
+ `--type=python` / `--python` / `--java`

### 15.1. Searching

简单的文本搜索，默认是**递归**的。

```sh
ack-grep hello
ack-grep -i hello
ack-grep -v hello
ack-grep -w hello
ack-grep -Q 'hello*'
```

### 15.2. Search File

对搜索结果进行处理，比如只显示一个文件的一个匹配项，或者xxx

```sh
ack-grep --line=1       # 输出所有文件第二行
ack-grep -l 'hello'     # 包含的文件名
ack-grep -L 'print'     # 非包含文件名
```

### 15.3. File presentation

输出的结果是以什么方式展示呢，这个部分有几个参数可以练习下

```sh
ack-grep hello --pager='less -R'    # 以less形式展示
ack-grep hello --noheading      # 不在头上显示文件
ack-grep hello --nocolor        # 不对匹配字符着色
```

### 15.4. File finding

没错，它可以查找文件，以省去你要不断的结合find和grep的麻烦，虽然在linux的思想是一个工具做好一件事。

```sh
ack-grep -f hello.py     # 查找全匹配文件
ack-grep -g hello.py$    # 查找正则匹配文件
ack-grep -g hello  --sort-files     # 查找然后排序
```

### 15.5. File Inclusion/Exclusion

文件过滤，个人觉得这是一个很不错的功能。如果你曾经在搜索项目源码是不小心命中日志中的某个关键字的话，你会觉得这个有用。

```sh
ack-grep --python hello       # 查找所有python文件
ack-grep -G hello.py$ hello   # 查找匹配正则的文件
```

## 16. mount & /etc/fstab, 挂载磁盘

1. 把 `mount` 命令写入 `/etc/rc.d/rc.local` 里面

    `mount -t nfs dl1:/home/users /home/users`

2. `/etc/fstab` 管理

    `vi /etc/fstab` 或 `sudo blkid`

    ```sh
    /dev/sda5 /media/brt/xxx ntfs defaults 0 0
    ```

3. 挂载windows下的共享目录，挂载后目录权限为755，普通用户没有权限写入。

    可以通过file_mode 和dir_mode 来设置权限，覆盖默认的755权限。

    ```py
    mount -t cifs -o username=ftp,password=3dmedcom,rw,dir_mode=0777,file_mode=0777 //10.10.172.91/GENEbackup  /GENEbackup  # 这样看到的文件目录权限都为777
    mount -t cifs -o username=ftp,password=3dmedcom //10.10.172.91/GENEbackup  /GENEbackup  # 经测试，可以读写。这样看到的文件目录权限都为755
    ```

4. 电脑双系统，Linux挂载Windows的盘符时，默认给予777的权限。这会导致git目录下的文件状态变更。解决方案如下：

    + 使用 `-o rw,umask=133,dmask=022` 选项执行挂载，用于限制文件与目录的权限
    + 使用 `-o uid=1000,gid=1000` 选项，指定挂载目录的用户和用户组（默认为root）

    例如 `/etc/fstab` 的配置：

    ```
    /dev/sda5  /media/brt/Programs  ntfs  rw,umask=133,dmask=022,uid=1000,gid=1000  0  0
    ```

卸载目录：

```py
umount /media/brt/Programs
```

### 16.1. 取消ubuntu开机硬盘自检

`/etc/fstab` 文件中的每一行配置的最后一个配置项，即用来指定如何使用 fsck 来检查硬盘：

0，则不检查；挂载点为 `/` 的（即根分区），必须在这里填写1，其它的都不能填写1。如果有分区填写大于1的话，则在检查完根分区后，接着按填写的数字从小到大依次检查下去。同数字的同时检查。比如第一和第二个分区填写 2，第三和第四个分区填写3，则系统在检查完根分区后，接着同时检查第一和第二个分区，然后再同时检查第三和第四个分区。 当编辑了 `/etc/fstab` 后，为了避免可能的错误，通常回使用 `mount -a` 命令来测试。

## 17. 自启动管理（取消ubuntu开机升级提示）

运行 `开始-设置-会话和启动` ，取消“更新提示”。

添加Guake的自启动： `Guake Terminal` ，命令：`guake` 。

## 18. /etc/network, 网络配置

### 18.1. 改变网络跃点

情景：使用有线网卡连接公司内网，使用Wifi链接手机热点访问外网。但默认有线网卡的优先级高于wifi，而有线网卡无法通外网。

```
$ route

内核 IP 路由表
目标            网关       子网掩码        标志  跃点   引用  使用 接口
default        _gateway   0.0.0.0        UG  100    0    0   enp9s0
default        _gateway   0.0.0.0        UG  600    0    0   wlp3s0
link-local     0.0.0.0    255.255.0.0    U   600    0    0   wlp3s0
192.168.0.0    0.0.0.0    255.255.255.0  U   100    0    0   enp9s0
192.168.43.0   0.0.0.0    255.255.255.0  U   600    0    0   wlp3s0
```

1. 使用 ifmetric 设置（但只是临时生效，重启后恢复）：

    `ifmetric wlp3s0 90`

    [github: ifmetric](https://github.com/mshuler/ifmetric)

2. 使用 nmcli 设置（永久生效）

    ```sh
    nmcli connection modify <connection-name> ipv4.route-metric 1
    ```

    and then re-activate the connection:

    ```sh
    nmcli connection up <connection-name>
    ```

    You can find the value for <connection-name> in the output of nmcli connection，例如 `m16s`.

    注意：这个配置是针对connection的，而非针对网卡的操作！

    > This solution is attached to a connection, not an interface.

3. 编辑 `/etc/network/interfaces`（未成功）

    Here is a simple example of `/etc/network/interfaces` :

    ```
    auto lo eth0
    iface lo inet loopback

    allow-hotplug eth0
    iface eth0 inet dhcp
        metric 700
    ```

    Restart networking using `service networking restart` for the changes to take place.

4. `netplan` is the default wrapper for network management.

    Configuring Netplan is done through a YAML file, by default /etc/netplan/01-netcfg.yaml (more details [here](https://netplan.io/reference/#general-structure)).

    Routing metric is defined by the "metric" option, which expects a positive integer (100 is the default value generally). Here's the example from the reference page:

    ```
    network:
      version: 2
      renderer: networkd
      ethernets:
        eno1:
          addresses:
          + 10.0.0.10/24
          + 11.0.0.11/24
          nameservers:
            addresses:
              + 8.8.8.8
              + 8.8.4.4
          routes:
          + to: 0.0.0.0/0
            via: 10.0.0.1
            metric: 100
          + to: 0.0.0.0/0
            via: 11.0.0.1
            metric: 100
    ```

    Note that in a roaming environment (multiple connections, going on and off), you might want to set the optional (boolean) parameter to true (default is false):

    ```
    network:
      version: 2
      ethernets:
        enred:
          dhcp4: yes
          dhcp4-overrides:
            route-metric: 100
        engreen:
          dhcp4: yes
          dhcp4-overrides:
            route-metric: 200
          # this is plugged into a test network that is often
          # down - don't wait for it to come up during boot.
          optional: true
    ```

5. `route` 命令手动修改路由

    `ip route replace default via 192.168.1.1 metric 1`

## 19. ps

安装：

```sh
apt install procps
```

使用

```sh
ps -efL  # L：查询线程
ps -ef (system v 输出) 
ps -aux bsd 格式输出
```

Linux 中进程有哪几种状态？在 ps 显示出来的信息中，分别用什么符号表示的？


1. 不可中断状态

  进程处于睡眠状态，但是此刻进程是不可中断的。不可中断， 指进程不响应异步信号。

2. 暂停状态/跟踪状态

  向进程发送一个 SIGSTOP 信号，它就会因响应该信号 而进入 TASK_STOPPED 状态;当进程正在被跟踪时，它处于 TASK_TRACED 这个特殊的状态。

  “正在被跟踪”指的是进程暂停下来，等待跟踪它的进程对它进行操作。

3. 就绪状态：在 run_queue 队列里的状态
4. 运行状态：在 run_queue 队列里的状态
5. 可中断睡眠状态：处于这个状态的进程因为等待某某事件的发生（比如等待 socket 连接、等待信号量），而被挂起
6. zombie 状态（僵尸）

  父进程没有通过 wait 系列的系统调用会顺便将子进程的尸体（task_struct）也释放掉

7. 退出状态

  D: 不可中断 Uninterruptible（usually IO）
  R: 正在运行，或在队列中的进程
  S: 处于休眠状态
  T: 停止或被追踪
  Z: 僵尸进程
  W: 进入内存交换（从内核 2.6 开始无效）
  X: 死掉的进程

### 19.1. 怎么查看系统支持的所有信号？

```sh
kill -l
```

### 19.2. pstree

以树状方式显示系统中所有的进程。

### 19.3. job

哪个命令专门用来查看后台任务? 

```sh
job -l
```

把后台任务调到前台执行 fg
把停下的后台任务在后台执行起来 bg

### 19.4. free

查看当前系统的内存使用情况

## 20. uptime

显示系统运行了多长时间

## 21. df/du

df: 显示每个<文件>所在的文件系统的信息，默认是显示所有文件系统。

```sh
df -hl
```

各个列的含义

```
文件系统 容量 已用 可用 已用% 挂载点
```

du: 显示目录或文件的大小

文件系统分配其中的一些磁盘块用来记录它自身的一些数据，如 i 节点，磁盘分布图，间接块，超级块等。这些数据对大多数用户级的程序来说是不可见的，通常称为 Meta Data。

du 命令是用户级的程序，它不考虑 `Meta Data` ，而 df 命令则查看文件系统的磁盘分配图并考虑 `Meta Data` 。

df 命令获得真正的文件系统数据，而 du 命令只查看文件系统的部分情况。

## 22. wc

用什么命令对一个文件的内容进行统计？(行号、单词数、字节数)

```sh
wc 命令 - c 统计字节数 - l 统计行数 - w 统计字数
```

## 23. which/where/whereis

通过什么命令查找执行命令?

+ which: 只能查可执行文件
+ where: 用于Windows系统的文件查找
+ whereis: 只能查二进制文件、说明文档，源文件等

## 24. bind

当你需要给命令绑定一个宏或者按键的时候，应该怎么做呢？

可以使用bind命令，bind可以很方便地在shell中实现宏或按键的绑定。

在进行按键绑定的时候，我们需要先获取到绑定按键对应的字符序列。比如获取F12的字符序列获取方法如下：先按下Ctrl+V,然后按下F12 .我们就可以得到F12的字符序列 ^[[24~。

接着使用bind进行绑定。

```sh
bind ‘”\e[24~":"date"'
```

注意：相同的按键在不同的终端或终端模拟器下可能会产生不同的字符序列。

另，也可以使用 `showkey -a` 命令查看按键对应的字符序列。

## 25. sed

去除 pip freeze 中的产生的版本号：

```sh
sed -i 's/==.*//g' requirements.txt
```
