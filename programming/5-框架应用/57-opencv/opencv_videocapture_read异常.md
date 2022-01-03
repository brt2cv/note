<!--
+++
title       = "OpenCV调用usb摄像头出现“select timeout”解决方法"
description = "1. 现象; 2. 设备的索引号错误; 3. 供电不足; 4. USB设备超时; 5. 图像流格式（正解）"
date        = "2022-01-03"
tags        = []
categories  = ["5-框架应用","57-opencv"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 现象

树莓派4b/Lenovo_Ubuntu20.04，使用opencv调用usb摄像头报错。执行 `ret, frame = cap.read()` 时终端输出 `select timeout` 或者 `VIDIOC_DQBUF: Resource temporarily unavailable` ，导致无法从摄像头获取图像，frame为空。

## 2. 设备的索引号错误

问题：创建VideoCapture对象时，设备的索引号和正在使用的摄像头不对应。

解决方法：修改 `cap=cv2.VideoCapture(0)` 的参数，把0更换成所用摄像头对应的索引号。如果不知道设备的索引号，可以通过插拔usb摄像头设备，并输入命令：

```
$ ls /dev/video*
```

通过对比输出来查看接入设备的索引号。

## 3. 供电不足

问题：树莓派usb口供电无法满足usb摄像头的供电需求。如果使用其他程序（如fswebcam）可以调用摄像头，则可以排除这个问题。

解决方法：使用带额外供电的hub

## 4. USB设备超时

问题：单纯的是usb设备调用比较慢，导致超时无法获取图像。

解决方法：V4L2的select()函数的最后一个参数是timeout，timeout是用来设置超时时间的，设置了timeout以后，如果select在没有文件描述符监视可用的情况下，会等待这个timeout，超过这时间select就会返回错误。因此可以通过尝试修改timeout的值来解决超时问题。

## 5. 图像流格式（正解）

问题：树莓派的CPU/GPU处理能力有限，或者是主流的usb摄像头驱动uvc有一些限制，最终造成图像数据无法很好处理。

解决方法：由于opencv使用uvc在树莓派中读取usb摄像机流，而cv2.VideoCapture可能默认为未压缩的流，例如YUYV，因此我们需要将流格式更改为MJPG之类的内容，具体取决于摄像机是否支持该格式。可以通过：

```py
cap.set(cv2.CAP_PROP_FOURCC,cv2.VideoWriter_fourcc('M','J','P','G'))
```

完成流的转换。你可以通过在终端输入

```
$ v4l2-ctl -d /dev/video0 --list-formats
```

查询你的摄像头支持哪一种流。

示例代码：

```py
import cv2
#first camera src
cap = cv2.VideoCapture(0)
# set the format into MJPG in the FourCC format
cap.set(cv2.CAP_PROP_FOURCC,cv2.VideoWriter_fourcc('M','J','P','G'))
```
