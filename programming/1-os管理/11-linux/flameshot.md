<!--
+++
title       = "【转载】Linux中功能强大的截图工具: Flameshot"
description = ""
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

![Linux中功能强大的截图工具 - Flameshot](https://pic2.zhimg.com/v2-f33154012574ea6c369a703c0a7596d0_1440w.jpg?source=172ae18b)

> [知乎: Linux中功能强大的截图工具 - Flameshot](https://zhuanlan.zhihu.com/p/88325211)

[Flameshot](https://link.zhihu.com/?target=https%3A//linux265.com/soft/3848.html) 是一款功能强大但易于使用的屏幕截图软件，中文名称**火焰截图**。Flameshot 简单易用并有一个 CLI 版本，所以你也可以从命令行来进行截图。Flameshot 是一个Linux发行版中完全免费且开源的截图工具。

通常[Linux发行版](https://link.zhihu.com/?target=https%3A//linux265.com/distro/)中会默认自带一个截图工具，但功能有限，往往只能单纯的截图截屏，无法完成对截图的编辑、涂画、标记文本等功能。`Flameshot` 强大之处在于它不仅能截图，更能对截图进行充分的编辑、涂画、标记、具备的功能更强于QQ截图。

![](https://pic4.zhimg.com/v2-6ed89944a7ea10ceb26437db8c157b97_b.jpg)

从截图中我们可以看到，每个按钮都是一个功能，完全满足你在Linux系统中截图需求。

**Flameshot 自带一系列非常好的功能，例如：**

  * 可以进行手写
  * 可以划直线
  * 可以画长方形或者圆形框
  * 可以进行长方形区域选择
  * 可以画箭头
  * 可以对要点进行标注
  * 可以添加文本
  * 可以对图片或者文字进行模糊处理
  * 可以展示图片的尺寸大小
  * 在编辑图片是可以进行撤销和重做操作
  * 可以将选择的东西复制到剪贴板
  * 可以保存选区
  * 可以离开截屏
  * 可以选择另一个 app 来打开图片
  * 可以上传图片到 imgur 网站
  * 可以将图片固定到桌面上

看一下操作的的GIF动画效果：

![](https://pic4.zhimg.com/v2-7cc62075c1adef80478ce4a5b304a767_b.gif)

###  如何安装Flameshot

**[ArchLinux](https://link.zhihu.com/?target=https%3A//linux265.com/distro/64.html)**

Flameshot 可以从 Arch LInux 的 [community] 仓库中获取。确保你已经启用了 community 仓库，然后就可以像下面展示的那样使用 pacman 来安装 Flameshot

    sudo pacman -S flameshot

**[Fedora](https://link.zhihu.com/?target=https%3A//linux265.com/distro/15.html)**
    sudo dnf install flameshot

在 **[Debian](https://link.zhihu.com/?target=https%3A//linux265.com/distro/10.html) 10+** 和 **[Ubuntu](https://link.zhihu.com/?target=https%3A//linux265.com/distro/45.html) 18.04+** 中，可以使用 APT 包管理器来安装它：

    sudo apt install flameshot

**[openSUSE](https://link.zhihu.com/?target=https%3A//linux265.com/distro/62.html)**

    sudo zypper install flameshot

在其他的 Linux 发行版中，可以从源代码编译并安装它。编译过程中需要 **Qt version 5.3** 以及 **GCC 4.9.2** 或者它们的更高版本。

其他的 Linux 发行版中具体安装方法可以参考[官方网站](https://link.zhihu.com/?target=https%3A//github.com/lupoDharkael/flameshot)。

###  如何使用

Flameshot安装完成后，可以从菜单或者应用启动器中启动 Flameshot。它通常可以在 “Applications -> Graphics” 下找到。

打开了它，你就可以在系统面板中看到 Flameshot 的托盘图标。

> 假如你使用 Gnome 桌面环境，为了能够看到系统托盘图标，你需要安装 [TopIcons](https://link.zhihu.com/?target=https%3A//extensions.gnome.org/extension/1031/topicons/) 扩展。

在 Flameshot 托盘图标上右击，你便会看到几个菜单项，例如打开配置窗口、信息窗口以及退出该应用。

![](https://pic2.zhimg.com/v2-33cd5596327ef5654132957e94db2e89_b.jpg)

要进行截图，只需要点击托盘图标就可以了。接着你将看到如何使用 Flameshot 的帮助窗口。选择一个截图区域，然后敲回车键便可以截屏了，点击右键便可以看到颜色拾取器，再敲空格键便可以查看屏幕侧边的面板。你可以使用鼠标的滚轮来增加或者减少指针的宽度。

![](https://pic1.zhimg.com/v2-37f8aabae537308b95a290ad914d5244_b.jpg)

###  Flameshot 快捷键

Frameshot 支持快捷键。在 Flameshot 的托盘图标上右击并点击 “信息” 窗口便可以看到在 GUI 模式下所有可用的快捷键。下面是在 GUI 模式下可用的快捷键清单。

![](https://pic2.zhimg.com/v2-deb57182343e52f36ad64696dfaa9dd1_b.jpg)

边按住 `Shift` 键并拖动选择区域的其中一个控制点将会对它相反方向的控制点做类似的拖放操作。

###  Flameshot 命令行选项

[Flameshot](https://link.zhihu.com/?target=https%3A//linux265.com/soft/3848.html) 支持一系列的命令行选项来延时截图和保存图片到自定义的路径。

要使用 Flameshot GUI 模式，运行：

    flameshot gui

要使用 GUI 模式截屏并将你选取的区域保存到一个自定义的路径，运行：

    flameshot gui -p ~/myStuff/captures

要延时 2 秒后打开 GUI 模式可以使用：

    flameshot gui -d 2000

要延时 2 秒并将截图保存到一个自定义的路径（无 GUI）可以使用：

    flameshot full -p ~/myStuff/captures -d 2000

要截图全屏并保存到自定义的路径和粘贴板中使用：

    flameshot full -c -p ~/myStuff/captures

要在截屏中包含鼠标并将图片保存为 PNG 格式可以使用：

    flameshot screen -r

要对屏幕 1 进行截屏并将截屏复制到粘贴板中可以运行：

    flameshot screen -n 1 -c

###  写在最后

[Flameshot](https://link.zhihu.com/?target=https%3A//linux265.com/soft/3848.html) 几乎拥有截屏的所有功能：添加注释、编辑图片、模糊处理或者对要点做高亮等等功能。可以尝试一下它，相信你不会失望的。
