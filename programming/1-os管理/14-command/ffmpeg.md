<!--
+++
title       = "FFmpeg常用命令：如何将mp4转gif/webp"
description = "1. 概述; 2. 安装; 3. 使用"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","14-command"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> [给新手的 20 多个 FFmpeg 命令示例](https://zhuanlan.zhihu.com/p/67878761)

## 1. 概述

FFmpeg本身是一个庞大的项目，包含许多组件和库文件，最常用的是它的命令行工具，其主要特征是输出过程快、输出品质高、输出文件小。“FF” 表示 “Fast Forward”，“mpeg” 表示 “Moving Pictures Experts Group”。本文介绍 FFmpeg 命令行如何处理视频，比桌面视频处理软件更简洁高效。

FFmpeg 提供如下四个命令行工具：

- ffmpeg 音视频编码器/解码器
- ffplay 媒体播放器
- ffprobe 显示媒体文件信息
- ffserver 多媒体流广播服务器，使用 HTTP 和 RTSP 协议。FFmpeg 4.1 版本已经删除 ffserver，新的替代者还未添加进来。

FFmpeg提供如下软件开发库：

* libavcodec 多媒体编解码器库
* libavdevice 设备库
* libavfilter 滤镜库
* libavformat 媒体格式库
* libavutil 实用工具库
* libpostproc 后处理库
* libswresample 音频重采样库
* libswscale 媒体缩放库

## 2. 安装

[官网下载](https://www.ffmpeg.org/download.html)

## 3. 使用

### 3.1. 查看文件信息

查看视频文件的元信息，比如编码格式和比特率，可以只使用-i参数。

```

$ ffmpeg -i input.mp4
```

上面命令会输出很多冗余信息，加上-hide_banner参数，可以只显示元信息。

```
$ ffmpeg -i input.mp4 -hide_banner
```

### 3.2. 转换编码格式

转换编码格式（transcoding）指的是， 将视频文件从一种编码转成另一种编码。比如转成 H.264 编码，一般使用编码器libx264，所以只需指定输出文件的视频编码器即可。

```
$ ffmpeg -i [input.file] -c:v libx264 output.mp4
```

下面是转成 H.265 编码的写法。

```
$ ffmpeg -i [input.file] -c:v libx265 output.mp4
```

### 3.3. 转换容器格式

转换容器格式（transmuxing）指的是，将视频文件从一种容器转到另一种容器。下面是 mp4 转 webm 的写法。

```
$ ffmpeg -i input.mp4 -c copy output.webm
```

上面例子中，只是转一下容器，内部的编码格式不变，所以使用-c copy指定直接拷贝，不经过转码，这样比较快。

### 3.4. 调整码率

调整码率（transrating）指的是，改变编码的比特率，一般用来将视频文件的体积变小。下面的例子指定码率最小为964K，最大为3856K，缓冲区大小为 2000K。

```
$ ffmpeg \
-i input.mp4 \
-minrate 964K -maxrate 3856K -bufsize 2000K \
output.mp4
```

### 3.5. 改变分辨率（transsizing）

下面是改变视频分辨率（transsizing）的例子，从 1080p 转为 480p 。

```
$ ffmpeg \
-i input.mp4 \
-vf scale=480:-1 \
output.mp4
```

### 3.6. 提取音频

有时，需要从视频里面提取音频（demuxing），可以像下面这样写。

```
$ ffmpeg \
-i input.mp4 \
-vn -c:a copy \
output.aac
```

上面例子中，-vn表示去掉视频，-c:a copy表示不改变音频编码，直接拷贝。

### 3.7. 添加音轨

添加音轨（muxing）指的是，将外部音频加入视频，比如添加背景音乐或旁白。

```
$ ffmpeg \
-i input.aac -i input.mp4 \
output.mp4
```

上面例子中，有音频和视频两个输入文件，FFmpeg 会将它们合成为一个文件。

### 3.8. 截图

下面的例子是从指定时间开始，连续对1秒钟的视频进行截图。

```
$ ffmpeg \
-y \
-i input.mp4 \
-ss 00:01:24 -t 00:00:01 \
output_%3d.jpg
```

如果只需要截一张图，可以指定只截取一帧。

```
$ ffmpeg \
-ss 01:23:45 \
-i input \
-vframes 1 -q:v 2 \
output.jpg
```

上面例子中，-vframes 1指定只截取一帧，-q:v 2表示输出的图片质量，一般是1到5之间（1 为质量最高）。

### 3.9. 裁剪

裁剪（cutting）指的是，截取原始视频里面的一个片段，输出为一个新视频。可以指定开始时间（start）和持续时间（duration），也可以指定结束时间（end）。

```
$ ffmpeg -ss [start] -i [input] -t [duration] -c copy [output]
$ ffmpeg -ss [start] -i [input] -to [end] -c copy [output]
```

下面是实际的例子。

```
$ ffmpeg -ss 00:01:50 -i [input] -t 10.5 -c copy [output]
$ ffmpeg -ss 2.5 -i [input] -to 10 -c copy [output]
```

上面例子中，-c copy表示不改变音频和视频的编码格式，直接拷贝，这样会快很多。

### 3.10. 为音频添加封面

有些视频网站只允许上传视频文件。如果要上传音频文件，必须为音频添加封面，将其转为视频，然后上传。

下面命令可以将音频文件，转为带封面的视频文件。

```
$ ffmpeg \
-loop 1 \
-i cover.jpg -i input.mp3 \
-c:v libx264 -c:a aac -b:a 192k -shortest \
output.mp4
```

上面命令中，有两个输入文件，一个是封面图片cover.jpg，另一个是音频文件input.mp3。-loop 1参数表示图片无限循环，-shortest参数表示音频文件结束，输出视频就结束。

### 3.11. 压缩视频文件

下面的命令将压缩并减少输出文件的大小。

```py
$ ffmpeg -i input.mp4 -vf scale=1280:-1 -c:v libx264 -preset veryslow -crf 24 output.mp4
```

请注意，如果你尝试减小视频文件的大小，你将损失视频质量。如果 24 太有侵略性，你可以降低 -crf 值到或更低值。

你也可以通过下面的选项来转换编码音频降低比特率，使其有立体声感，从而减小大小。

```py
-ac 2 -c:a aac -strict -2 -b:a 128k
```

### 3.12. 增加/减少视频播放速度

FFmpeg 允许你调整视频播放速度。

为增加视频播放速度，运行：

```py
$ ffmpeg -i input.mp4 -vf "setpts=0.5*PTS" output.mp4
```

该命令将双倍视频的速度。

为降低你的视频速度，你需要使用一个大于 1 的倍数。为减少播放速度，运行：

```py
$ ffmpeg -i input.mp4 -vf "setpts=4.0*PTS" output.mp4
```

### 3.13. 创建 gif/webp 动画

出于各种目的，我们在几乎所有的社交和专业网络上使用 GIF 图像。使用 FFmpeg，我们可以简单地和快速地创建动画的视频文件。下面的指南阐释了如何在类 Unix 系统中使用 FFmpeg 和 ImageMagick 创建一个动画的 GIF 文件。

以下命令行可以将名为 input.mp4 文件转化为帧率为20帧每秒，循环播放，默认渲染预设效果，分辨率为 800px宽 600px 高的无损的文件名为 output 的 .webp 文件：

```py
ffmpeg -i input.mp4 -vcodec libwebp -filter:v fps=fps=20 -lossless 1 -loop 0 -preset default -an -vsync 0 -s 800:600 output.webp
```

若希望转出的 output.webp 动画只播放一次，有损，压缩级别为3（0-6，默认为4，越高效果越好），质量为70（0-100，默认为75，越高效果越好），越舍渲染为图片，可使用以下命令：

```py
ffmpeg -i input.mp4 -vcodec libwebp -filter:v fps=fps=20 -lossless 0 -compression_level 3 -q:v 70 -loop 1 -preset picture -an -vsync 0 -s 800:600 output.webp
```

主要选项:

+ 设定帧率: `-r 15` ，通常Gif有15帧左右就比较流畅了
+ 将每秒帧率设为20: `-filter:v fps=fps=20`
+ 设为导出为无损质量: `-lossless 1`
+ 设为循环播放: `-loop 0`
+ 设为不循环播放: `-loop 1`
+ 设置分辨率: `-s 800:600`
+ 截取视频区间: `-ss 2 -t 5` ，从第2秒的地方开始，往后截取5秒钟

以上方法也适用于其他主流视频格式导出为 webp 或 gif 动画，更多转换选项。
