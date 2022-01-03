<!--
+++
title       = "Windows环境的Workflow神器：AutoHotkey"
description = "1. 基本使用 & 交换按键; 2. 简单实用的实例; 3. CapsLock+ 开源程序; 4. 折腾 AutoHotKey 总结; 5. Windows系统键位映射工具：Scancode Map"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","13-windows"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

[AutoHotkey](https://autohotkey.com/) 是一个 windows 下的开源、免费、自动化软件工具。它由最初旨在提供键盘快捷键的脚本语言驱动 (称为：热键)，随着时间的推移演变成一个完整的脚本语言。但你不须要把它想得太深，你只须要知道它能够简化你的重复性工做，一键自动化启动或运行程序等等；以此提升咱们的工做效率，改善生活品质；经过按键映射，鼠标模拟，定义宏等。

## 1. 基本使用 & 交换按键

安装完成后默认会在系统盘的 “本地文档” 下建立一个 "AutoHotkey.ahk" 脚本，双击之后咱们会看到任务栏右下角有个图标，就表示它在运行了。咱们在里面写入相应的映射代码而后右击选择 "reload this script" 执行它就能够开始使用 AutoHotkey 里面设置好的功能了。

+ 运行：通过加载脚本的方式运行
+ 编译：生成exe文件，可用于特定功能的自启动

使用帮助：

+ [官方：快速入门](https://wyagd001.github.io/zh-cn/docs/Tutorial.htm)
+ [按键的定义](https://www.autohotkey.com/docs/KeyList.htm)
+ [函数的定义](https://www.autohotkey.com/docs/Functions.htm)
+ [简单交换按键](https://www.autohotkey.com/docs/misc/Remap.htm)

```
; 这里是注释: 以下两行内容交换了a与b的键位
a::b
b::a
```

## 2. 简单实用的实例

这里简单说明下脚本中经常使用符号表明的含义：

`#` : 号表明 _Win_ 键
`!` : 号表明 _Alt_ 键
`^` : 号表明 _Ctrl_ 键
`+` : 号表明 _shift_ 键
`::` : 号 (两个英文冒号) 起分隔做用
`run` : 脚本运行命令
`;` : 号表明 注释后面一行内容

run 它的后面是要运行的程序完整路径（好比个人 Sublime 的完整路径是：D:\\Program Files (x86)\\Sublime Text 3\\sublime\_text.exe）或网址。为何第一行代码只是写着 “notepad”，没有写上完整路径？由于“notepad” 是“运行”对话框中的命令之一。

若是你想按下 “Ctrl + Alt + Shift + Win + Q”（这个快捷键真拉风啊。(￣▽￣)）来启动 QQ 的话，能够这样写：

```
^!+#q::run QQ 所在完整路径地址。
```

AutoHotKey 的强大，有相似 Mac 下的 Alfred2 之风，能够自我定制 (固然啦，后者仍是强大太多)。因此能够说，她强大与否，在于使用者的你爱或者不爱`折腾`。

### 2.1. 极速打开网页

```
;Notes: #==win !==Alt 2015-05-20  ^==Ctr  +==shift

;=========================================================================
#j::Run www.jeffjade.com
#b::Run https://www.baidu.com/
#c::Run https://www.google.com/
#y::Run http://www.cnblogs.com/jadeboy/
#0::Run https://tinypng.com/
#v::Run https://www.v2ex.com/
;-------------------------------------------------------------------------
```

这是特经常使用的功能；如上脚本，Win+J 便可打开本身我的博客，Win+0 则打开熊猫网址去压缩图片... ...。无论 pc 焦点何在，使用本身配置的快捷键，便可达到所想，方便而快捷，大慰我心。网上冲浪，天然选取了 Chrome，配之以 Vimium 插件 [Vimium~ 让您的 Chrome 起飞](http://www.jeffjade.com/2015/10/19/2015-10-18-chrome-vimium/)，分分钟甩掉鼠标；生命聊聊不过百年，如此短暂，在鼠标常常性滑过去来作一些能够更高便捷的事儿，所没必要要消耗的一秒半秒，我没那么慷慨 (即便我会花费更多时间去发发呆)。

### 2.2. 便捷呼出程序

```
!n::run notepad
!c::run, D:\\SoftwareKit\\\_jade\_new\_soft\\cmd\_markdown\_win64\\Cmd Markdown.exe
!r:: run, D:\\SoftwareKit\\\_jade\_new\_soft\\cmder\_mini\\Cmder.exe
!q::run, D:\\Program Files (x86)\\Tencent\\QQIntl\\QQUninst.exe
!space::run, D:\\Program Files (x86)\\Sublime Text 3\\sublime\_text.exe
;==========================================================================
```

以上为 Alt 外加一些键来打开本地应用程序。即使彻底能够本身配置热键，可是一旦多了，不经常使用的话记起来也略显麻烦。因此选择 Alt 键组合来打开本地应用程序。Win 键来呼出网页。在有了 Launchy 这类软件以后，也就不怎么过为本地程序配置快捷键了。

以前一段时间认为，珍爱生命，就当远离 Windows。在给其配了 SSD 硬盘，在不断折腾应用一些软件，在不断了解 & 熟悉 Windows 以后，这一想法倒也缓和了很多。Windows 下的 AutoHotKey + Listary + Launchy 组合，倒也有了点 Mac 下 `Alfred2` 免费功能部分。这一点在 [Windows 下效率必备软件](http://www.jeffjade.com/2015/10/19/2015-10-18-Efficacious-win-software/)中有过记载。

### 2.3. 一键拷贝文件路径

```
^+c::
; null=
send ^c
sleep,200
clipboard=%clipboard% ;%null%
tooltip,%clipboard%
sleep,500
tooltip,
return
```

只须要 Ctrl+shift+c 便可拷贝文件路径。

### 2.4. 改掉大写键为 Enter

```
;replace CapsLock to LeftEnter; CapsLock = Alt CapsLock
$CapsLock::Enter

LAlt & Capslock::SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"

!u::Send ^c !{tab} ^v
```

看网上朋友说 CapsLock(大写切换按键) 没怎么大用处；想来也是，我的每次须要输入大写字符，也是配合 Shift 来实现。那么此按键意义何在？那就改为 Enter 键好了。有时候右手须要操纵鼠标时候，左手小拇指按此键来实现换行，蛮好；既然大写切换不怎么经常使用，那么用 Alt+CapsLock 来组合实现也无不妥；以上脚本即为此意。

### 2.5. 缩写快速打出经常使用语

```
::/mail::gmail@gmail.com
::/jeff::http://www.jeffjade.com/
::/con::console.log();
::/js::javascript:;
::/fk::轩先生这会子确定在忙，请骚后。thx。祝君：每天开心，日日欣悦。
```

AutoHotKey 一个很强大之处，在任何能正常显示 unicode 字符的程序中（好比浏览器的地址栏、MS Word Rtx）；如以上代码，键入 `/jeff` 后，再加空格、或 tab、或回车，就能够触发缩写；根据输入不一样方式（空格，tab，回车）输出的内容后也相应附加了 \[空格 / tab / 回车，用起来非常舒爽\]; 固然了这里 `/jeff` 也能够配置其余如 `:jeff`，按照我的喜爱了。

### 2.6. 颜色神偷

```
^#c::
MouseGetPos, mouseX, mouseY
; 得到鼠标所在坐标，把鼠标的 X 坐标赋值给变量 mouseX ，同理 mouseY
PixelGetColor, color, %mouseX%, %mouseY%, RGB
; 调用 PixelGetColor 函数，得到鼠标所在坐标的 RGB 值，并赋值给 color
StringRight color,color,6
; 截取color（第二个color）右边的6个字符，由于得到的值是这样的：#RRGGBB
; 通常咱们只须要 RRGGBB 部分。把截取到的值再赋给color（第一个color）
clipboard = %color%
; 把 color 的值发送到剪贴板
return
```

这个功能，搞 Web 端仍是能够备着的。很好用，按下配置好快捷键，便可取得鼠标所在光标处颜色色值到剪切版中－爽啊。(我的用`Win+C`呼出了 Chrome，`Alt+C`调出做业部落客户端\_\_Cmd Markdown\_\_, 因此这里就用了`Ctrl+Win+c`来取色，也还算方便)

### 2.7. 神速激活 / 打开 / 隐藏程序

```
#c::
IfWinNotExist ahk\_class Chrome\_WidgetWin\_1
{
    Run "C:\\Users\\Administrator\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe"
    WinActivate
}
Else IfWinNotActive ahk\_class Chrome\_WidgetWin\_1
{
    WinActivate
}
Else
{
    WinMinimize
}
Return
```

以上这段脚本能够作到，Chrome 的各类状态切换：Win+C,Chrome 没打开状态时候 --> 打开；打开没激活状态时候 --> 激活；打开处在激活状态时候 ---> 隐藏。

## 3. CapsLock+ 开源程序
> [github](https://github.com/wo52616111/capslock-plus)
>
> [国内gitee的Fork仓库](https://gitee.com/brt2/capslock-plus)

这个工具固然牛逼，但更牛的是，开源了很多已经二次开发的ahk脚本函数，这里挑几个常用的：

```
keyFunc_moveLeft(i:=1){
    SendInput, {left %i%}
    return
}

keyFunc_moveRight(i:=1){
    SendInput, {right %i%}
    Return
}

keyFunc_moveUp(i:=1){
    global
    if(WinActive("ahk_id" . GuiHwnd))
    {
        ControlFocus, , ahk_id %LV_show_Hwnd%
        SendInput, {Up %i%}
        ControlFocus, , ahk_id %editHwnd%
    }
    else
        SendInput,{up %i%}
    Return
}

keyFunc_moveDown(i:=1){
    global
    if(WinActive("ahk_id" . GuiHwnd))
    {
        ControlFocus, , ahk_id %LV_show_Hwnd%
        SendInput, {Down %i%}
        ControlFocus, , ahk_id %editHwnd%
    }
    else
        SendInput,{down %i%}
    Return
}

keyFunc_end(){
    SendInput,{End}
    Return
}

keyFunc_home(){
    SendInput,{Home}
    Return
}

keyFunc_moveWordLeft(i:=1){
    SendInput,^{Left %i%}
    Return
}

keyFunc_moveWordRight(i:=1){
    SendInput,^{Right %i%}
    Return
}

keyFunc_selectUp(i:=1){
    SendInput, +{Up %i%}
    return
}

keyFunc_selectDown(i:=1){
    SendInput, +{Down %i%}
    return
}

keyFunc_selectLeft(i:=1){
    SendInput, +{Left %i%}
    return
}

keyFunc_selectRight(i:=1){
    SendInput, +{Right %i%}
    return
}

keyFunc_selectHome(){
    SendInput, +{Home}
    return
}

keyFunc_selectEnd(){
    SendInput, +{End}
    return
}
```

通过简单的调用，你可以把仓库中 lib 目录下的各种功能函数定义给各种组合键，支持 ctrl、alt、CapsLock、Win（Super）作为Modifier。

## 4. 折腾 AutoHotKey 总结

折腾是奔着实用才去作的，因此笔者也只是看下能够经常使用功能而已。其实 AutoHotKey 远不止如此；[AutoHotkey 学习指南](https://autohotkey.com/boards/viewtopic.php?t=1099)这里可见一斑。网络上也能够搜出 AutoHotKey 懒人包，里面有二十余脚本，如：_“计时器”_，_“禁止 Win 键”_，_“秒杀窗口，左键加右键”_ 云云；须要的话下载便可使用；知乎有一专栏 [AutoHotkey 之美](http://zhuanlan.zhihu.com/autohotkey)，粗略扫了下，算是一能够扩充见识之门；[AutoHotKey 实用脚本分享](http://nicejade.github.io/2016/03/12/share-autohotkey-script.html)一文介绍了一些经常使用脚本实例，有兴趣更多了解 AutoHotKey 的朋友们，可参看下。

> 文章来源：http://www.jeffjade.com
>
> 原文连接：http://www.jeffjade.com/2016/03/11/2016-03-11-autohotkey

## 5. Windows系统键位映射工具：Scancode Map
> [知乎: 键盘键位修改及管理（Windows篇）_提供python脚本和键盘扫描码对照表](https://zhuanlan.zhihu.com/p/29581818)
>
> [Windows键值对照表](https://wenku.baidu.com/view/5e7ca907a6c30c2259019e62.html)

“Scancode Map”是注册表中 `[HKEY_LOCAL_MacHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]` 中的一个二进制键值(默认没有，需新建)，并且有固定的格式。

Scancode Map 代码的一般格式是：

```
hex:00,00,00,00,00,00,00,00,|02|,00,00,00,|映射之后的扫描码（XX XX）,原扫描码(XX
XX),|00,00,00,00
```

其含义为：前8个00(DWord两个0)是版本号和头部字节，接下来的“02”表示映射数，其最小为值为“02”，表示只映射一组（这里的数值是映射数目加上末尾用作结尾的“00,00,00,00”，因此总是比实际的映射数目大一），若要映射多组，只需增加相应的值即可，如映射2组其值应为“03”,3组为“04”。后边代码每4个是一组：前两个是映射后键位的扫描码，后两个是键位原扫描码。如果要交换两个键，则一个有两组映射，四个值的排列形式是：键A，键B，键B，键A——它表示：键A成为键B，键B成为键A。最后以“00,00,00,00” 结尾。了解了“Scancode Map”之后，我们就可以来利用添加功能键了。比如WIN键扫描码为：“E0 5B”，Esc为“00 01”，左边的Ctrl为“00 1D”，更详细的扫描码请见键盘扫描码。

重启电脑生效。

举例：比如说我们想把F9，F10键修改成为音量调整键，通过查表，可以得知：F9、F10扫描码分别为(00,43)、(00,44)，Volume Up、Volume Down的扫描码分别为(E0,30)、(E0,2E)，这样只要将Scancode设置为如下就可以了：

```
"Scancode Map"=hex:00,00,00,00,00,00,00,00,03,00,00,00,30,E0,43,00,2E,E0,44,00,00,00,00,00
```
