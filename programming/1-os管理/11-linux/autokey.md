<!--
+++
title       = "xmodmap系列工具，用于键盘设置"
description = "1. 概况; 2. 映射工具"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","11-linux"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 概况
> [简书: Ubuntu更换键位设置](https://www.jianshu.com/p/9411ee427cfd)

首先，先确定你是要临时更换键位还是永久更换，如果要临时更换，则可以使用Xmodmap，好处是可以随身携带编辑好的文件，在哪里都可调用。如果要永久改变键位设置，则可编辑

    /usr/share/X11/xkb/keycodes/evdev

来彻底改变键盘的定义行为，好处是比Xmodmap来的高效，不需要另外的读取时间。

### 1.1. 键盘映射的规则

首先简述键盘的读取原理。当你按下一个按钮，系统会首先读取这个按钮的keycode，比如大写锁的keycode是66。然后系统会去对照键盘的layout(布局，存储在/etc/default/keyboard里)去确定这个keycode对应是什么按键，比如66在配置文件里就是<CAPS>。确定你按的是什么按键之后，系统就会调用对应这个按键的函数(称之为keysym)来完成的功能了。

你可以用xev命令来查看按键的keycode和keysym。在弹出的小窗口里敲想看的按键就行了。

如果是永久交换，则在上文的evdev文件里修改按键的keycode和对应的键位关系即可。

如果是临时交换，则需要编辑一个Xmodmap文件，并在终端里执行：

    xmodmap 配置文件（例如~/.xmodmap）

来交换，不过这个交换只要重新登录就会被重置。

## 2. 映射工具

### 2.1. xev

通过它可以知道键盘上每一个按键的编码，即keycode， 这个键码与键盘硬件有关系，固定不变的。你想想啊，键盘上这么多按键，怎么让计算机去区分啊？就是通过这个keycode值，每当我们按下一个键时，内核中中断系统就会接收到一个keycode， 从而判断你按下了哪个键。具体操作系统怎么处理这个按键，那就需要keycode值到keysym的映射来决定了。

![](https://img2020.cnblogs.com/blog/2039866/202102/2039866-20210203183327599-1572302726.jpg) <!-- autokey/autokey-0.jpg -->

### 2.2. 键位布局

目标键位：CapsLock映射为Control_L，Control_L映射为Escape，Escape映射为CapsLock：

方法：修改 `/usr/share/X11/xkb/keycodes/evdev` ，使

```
<CAPS> = 9 　　　　<LCTL> = 66 　　　　<ESC> = 37
```

执行 `sudo dpkg-reconfigure xkb-data` 即生效。

注：只在X Window下生效。

### 2.3. xmodmap
> [博客园: linux系统下键盘按键的重新映射——xmodmap工具和xev工具](https://www.cnblogs.com/yinheyi/p/10146900.html)

用于修改按键keycode值到按键功能keysym的映射，规则如下：

什么是keysym呢？ 即key symbol，咱们可以把它理解了符号或功能，我按下这个键，我就想要得到一个符号对不对？例如我按下A键，就是想知道一个 a 或者 A吧，这个就是keysym. 再例如，我按下了control_L对应的键， 我就想得到control_L 符号或使用这个功能吧。

从keycode到keysym的映射不是一一对应的，一个keycode值可以对应多个keysym：例如 a键(keycode为 )就对应的 a， 与对应的 A 。具体是这么规定的，举个例子来说吧，例如A 键的映射如下：

```
keycode  38 = a A a A
```

它表示键盘上A键对应的keycode为38， 它被映射为的keysym为四个：a / A / a / A,  它们的含义分别为按以下组合时对应的：A键 / Shift + A键 / Mode_switch + A键 / Mode_switch + Shift + A 键。除了A键之外，其它的组合键称作修饰键 (modifier), 每一个 keycode值最多应该可以映射6个或8个的keysym吧，反正够咱们用了。前6个keysym的意义如下：

```sh
Key
Shift+Key
Mode_switch+Key
Mode_switch+Shift+Key
ISO_Level3_Shift+Key
ISO_Level3_Shift+Shift+Key
```

当我们定义我们自己的映射时，这6个或8个的keysym不需要全部都写满，你想用几个就写几个就可以了。假如我想用第一个和第三个keysym时，第二个keysym的值使用   NoSymbol   代替，它表示空。

如何映射呢？ 直接使用 `keycode 值 = keysym` 即可。例如下面是我自己设置的键盘映射: (使用 `!` 表示注释, 下面的内容位于 `~/.Xmodmap` 文件内）

```
! 把esc键更换为Caps_Lock
keycode 9 = Caps_Lock NoSymbol Caps_Lock

!把Caps_Lock键更换为Shift_L
keycode 66 = Shift_L NoSymbol Shift_L

!把Shift_L键更换为Control_L键
keycode 50 = Control_L NoSymbol Control_L

! 把Control_L键更换为Alt_L键
keycode 37 = Alt_L Meta_L Alt_L Meta_L

! 把Alt_L键更换为ESC键
keycode 64 = Escape NoSymbol Escape

! 把Enter键更换为Shift_R键
keycode 36 = Shift_R NoSymbol Shift_R

! 把Shift_R键更换为Return 键
keycode 62 = Return NoSymbol Return
```

接下来说说按键中的修饰符，即modifier.  例如我们常用的shift/ ctrl /alt/等都起着修饰的作用，它们可以和别的按键进行组合 ，产生不同的效果。

在我们系统中，一共存在着8个修饰符：分别为： shift/ lock/ control/ mod1/ mod2/ mod3 /mod4/ mod5. 我们可以把每一个keysym 设置为修饰符，例如我把 a 设置为修饰符的control修饰符的话，把以后按 a + c 就可以表示复制了。 每一个修饰符都可以对应多个keysym的， 下面是我的电脑的修饰符：

```
shift       Shift_R (0x24),  Shift_L (0x42)
lock        Caps_Lock (0x9)
control     Control_L (0x32),  Control_R (0x69)
mod1        Alt_L (0x25),  Alt_R (0x6c),  Alt_L (0xcc),  Meta_L (0xcd)
mod2        Num_Lock (0x4d)
mod3
mod4        Super_L (0x85),  Super_R (0x86),  Super_L (0xce),  Hyper_L (0xcf)
mod5        ISO_Level3_Shift (0x5c),  Mode_switch (0xcb)
```

如果设置呢？常用的命令包括：clear/ remove/ add 操作，举例来说：（下面的内容也是位于.Xmodmap文件中）

```
! 把绑定到control修饰符的Control_L移除：
remove control = Control_L

! 把绑定到control修饰符上的所有 keysym 都移除：
clear control

! 现在添加Control_R 都shift 修饰符：
add shift = Control_R
```

需要说明的是： 修饰符是与 keysym 对应的keycode值绑定的，当我们修改了与修饰符相关的按键之后，记得更新一下相关的修饰符，否则的话，修饰符还是绑定在的物理按键上，而还是绑定到你新映射的物理按键上。

### 2.4. xdotool
> [csdn: linux怎样安装xdotool,以及xdotool的使用](https;==blog.csdn.net=lxj434368832=article=details=69210830)

```sh
sudo apt-get install xdotool
```

xdotool是个脚本程序。因此，你有必要了解它的语法。不过敬请放心，相对于程序的功能而言，语法还是比较简单易学的。

模拟击键是很容易的。你可以从终端敲入下面的命令：

```sh
xdotool key [name of the key]
```

如果你想要连接两个键，可以在它们之间使用“+”操作符。它看起来像这样：

```sh
xdotool key alt+Tab
```

这两个组合键可以为你切换窗口。

### 2.5. 类似AHK的: autokey
> [github](https://github.com/autokey/autokey)
>
> [wiki](https://github.com/autokey/autokey/wiki)
>
> [使用入门教程（英文）](https://www.cloudsavvyit.com/7870/autokey-how-to-replace-characters-with-predefined-text-automatically-in-linux/)
>
> [scripts_api_examples](https://github.com/autokey/autokey/wiki/API-Examples)
>
> [api_list](https://github.com/autokey/autokey/blob/01151b76b311605f4941b442e613e1607a29c19e/lib/autokey/qtui/data/api.txt)

```sh
apt install autokey-gtk  ## 或者autokey-qt
```

#### 2.5.1. Phrases

用于键位映射，可以通过 `Phrases` 实现对固定内容的操作。

#### 2.5.2. Scripts

The API examples shown here are for AutoKey-GTK.

The examples show how to use the various API calls that AutoKey provides.

The example types are as follows:

+ Clipboard
+ Dialogs
+ Keyboard
+ Mouse
+ Store
+ System
+ Window

例如：

+ keyboard.send_key('z',repeat=3)

    send_key sends a single keystroke. <font color=#FF0000>You cannot use send_key on its own to send keys that are modified with Crtl, Shift, or Alt</font>。如果有必要，可以使用 `keyboard.press_key` 实现组合键：

    ```py
    keyboard.press_key('<ctrl>')
    keyboard.send_key('d', repeat=5)
    keyboard.release_key('<ctrl>')
    ```

+ keyboard.send_keys('Hello World!')

+ clipboard.get_selection()

+ Variable: global value

    ```py
    selText = clipboard.get_selection()
    store.set_global_value("MyClipboard", selText)

    clipboard_text = store.get_global_value("MyClipboard")
    keyboard.send_keys(clipboard_text)
    ```

#### 2.5.3. Dynamic Phrases, Using Macros as placeholders in Phrases
> [Dynamic Phrases, Using Macros as placeholders in Phrases](https://github.com/autokey/autokey/wiki/Dynamic-Phrases,-Using-Macros-as-placeholders-in-Phrases)
