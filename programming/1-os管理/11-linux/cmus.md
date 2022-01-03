<!--
+++
title       = "Linux终端音乐播放器: cmus"
description = "Linux终端音乐播放器cmus攻略: 操作歌单"
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

cmus是一款开源的终端音乐播放器。它小巧快速，而又功能强大。cmus支持Ogg/Vorbis、MP3、FLAC、Musepack、WavPack、WMA、WAV、AAC、MP4等格式，包含Gapless播放及ReplayGain支持，Vi风格的按键绑定，播放列表过滤，可定制配色方案，UTF-8支持等等。

![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200707080920058-93507962.jpg) <!-- cmus/cmus-0.jpg -->

+ 主页: [homepage](https://cmus.github.io)
+ github：[github](https://github.com/cmus/cmus)
+ 官方文档: [doc](https://github.com/cmus/cmus/blob/master/Doc/cmus.txt)

## 1. 安装

`apt install cmus`

## 2. 操作说明
> [Howtoing运维教程](https://www.howtoing.com/install-cmus-music-player-in-linux)

终端执行 `cmus` 启动。

播放控制：

+ x 播放或重播音乐
+ c 暂停
+ b 播放下一首音乐
+ z 播放前一首音乐
+ `shift + D` 删除
+ u 更新缓存
+ q 退出程序

循环模式：

+ s 随机播放
+ f 顺序播放
+ r 循环播放
+ `Ctrl + R` 切换单曲循环

音量调节

+ `-` 减小
+ `=` 增大

播放列表管理（不推荐使用，建议直接操作playlist）

+ 导入本地音乐: `:a /path/to/your/music/folder`
+ 清空列表 `:clear [-l] [-p] [-q]`
+ 保存播放列表 `:save /path/to/playlist`
+ 加载播放列表 `:load /path/to/playlist`

方向键

+ H 快退(5s)
+ J 上
+ K 下
+ L 快进(5s)

### 2.1. \*PlayList歌单

+ 新建歌单 `:pl-create <name>`
+ 导出歌单 `:pl-export <filename>`
+ 导入歌单 `:pl-import [filename]`

![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200707080920571-246098602.jpg) <!-- cmus/cmus-7.jpg -->

关于歌单，这里多说几句。其实大家听本地歌曲，没必要使用 `:add /path/xxx` 导入到播放列表。直接使用 `5` 界面，将想听的歌曲从目录中添加到playlist即可。具体操作如下：

1. 创建或切换到目标歌单：

    + 按 `3` 进入playlist模式
    + `:pl-create <name>`
    + 在这个界面中，执行上下键选择目标歌单
    + 按 `空格` 将其定义为当前操作对象

2. 按 `5` 进入文件浏览模式
3. 选择目标音频文件或整个文件夹，按 `y` 将其添加到目标歌单

### 2.2. 其他

+ <font color=#FF0000>, 快退60s</font>
+ . 快进60s
+ `:cd dir` 切换目录
+ `:pwd` 类似的shell标准命令
+ <font color=#FF0000>`:set resume=true` 在启动时恢复播放</font>
+ <font color=#FF0000>`:set mouse=true` 启用鼠标</font>
+ `:set mpris=true` 启用MPRIS（D-Bus支持）
+ `:set show_hidden=true` 浏览界面显示隐藏文件
+ <font color=#FF0000>`:set start_view=playlist` 修改启动默认视图</font>，可选项: [tree, sorted, playlist, queue, browser, filters, settings]，默认为tree（视图1）

## 3. 视图切换

1. Library view, 默认打开的界面，按照歌手或专辑名排列

    ![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200707080920966-902681387.jpg) <!-- cmus/cmus-2.jpg -->

2. Sorted library view, 所有的歌曲的列表

    ![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200707080921275-861379163.jpg) <!-- cmus/cmus-1.jpg -->

3. Playlist view, 类似于歌单，可以按需组织歌曲

    + y: 将当前选中歌曲添加到播放列表
    + P/p: 更改曲目顺序
    + D: 移除

4. Play Queue view, 播放队列（**播放优先级最高**）

    + e: 将当前选中歌曲添加到队列（下一首播放）

    ![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200707080921509-572883268.jpg) <!-- cmus/cmus-6.jpg -->

5. Browser, 可以浏览文件，添加歌曲之类的

    ![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200707080921699-2062523112.jpg) <!-- cmus/cmus-3.jpg -->

6. Filters view, 显示用户定义的过滤设置

    ![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200707080921931-545048098.jpg) <!-- cmus/cmus-4.jpg -->

7. Settings view, 显示所有的快捷键设置

    ![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200707080922193-1833632719.jpg) <!-- cmus/cmus-5.jpg -->

## 4. 使响应Media/play按键
> [github issue](https://github.com/cmus/cmus/issues/948)

看作者的说明：

> Cmus is recognized a media player by linux, so u just need to call it through a media controller program to get it to do things. so for example `playerctl -p cmus play-pause` will toggle play/pause for cmus.

实测：

```sh
sudo apt install playerctl
playerctl -l  # 如果存在cmus,则继续执行
playerctl -p cmus play-pause
```

结论：apt仓库中的cmus，并没有编译MPRIS选项。

所以需要重新编译一个cmus程序。

### 4.1. 编译安装

```sh
sudo apt install libsystemd-dev
    libroar-dev
    libasound2-dev  # for alsa
    libsamplerate0-dev
    libjack-dev
    libopusfile-dev
```

最全的依赖安装

```sh
$ sudo apt-get install libncurses5-dev libncurses5w-dev libpulse-dev libmodplugs-dev libcddb2-dev libsystemd-dev libavformat-dev libflac-dev libao-dev libcdio-dev libcdio-cdda-dev libvorbis-dev libopusfile-dev libroar-dev libdiscid-dev libsamplerate0-dev libmpcdec-dev libmad0-dev libmp4v2-dev libasound2-dev libjack-dev libcue-dev
```

编译安装

```sh
./configure  CONFIG_MPRIS=y  prefix=$HOME/bin/cmus/
make
make install
```

此时运行 `$HOME/bin/cmus/bin/cmus` ，发现已经支持多媒体键的 `播放/暂停` 功能啦。

笔者在多次编译后，偶然遇到这样一个错误：

```
could not initialize required output plugin
```

原因未知。在cmus界面中执行 `:set output_plugin=pulse` 即恢复正常了。
