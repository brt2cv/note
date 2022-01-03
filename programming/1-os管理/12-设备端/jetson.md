<!--
+++
title       = "Jetson安装与设置"
description = "1. 系统配置; 2. 安装 jtop; 3. 配置CUDA; 4. 安装pytorch; 5. 安装海康相机; 6. 安装OpenCV（With CUDA）; 7. 部署PaddlePaddle模型（如PaddleOCR、PP-YOLO）"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","12-设备端"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 系统配置

### 1.1. 供电模式的切换

#### 1.1.1. MaxN模式

jetson nano 开发板在预设的10W(MAXN)模式下需要用5v4A的DC供电。
用5v2A的DC或者micro-usb供电建议使用5W模式。
供电不足会导致掉电关机。

Jetson Nano采用高效电源管理集成电路（PMIC），稳压器和电源树设计可优化电源效率。 它支持两种电源模式，例如5W和MaxN（10W）。 每种模式允许多种配置，具有各种CPU频率和在线核心数。
您可以通过以预限定值限制内存，CPU和GPU频率以及内核数量，将模块限制为预定义配置。
下表显示了NVIDIA预定义的电源模式以及模块资源使用的相关上限。

![](https://img2020.cnblogs.com/blog/2039866/202102/2039866-20210219182500453-1151620233.jpg) <!-- jetson/jetson-4.jpg -->

默认的模式是：MaxN（10W）(对应ID 0).

切换模式：

```sh
sudo /usr/sbin/nvpmodel -m <x>
```

其中对应的是 mode ID, 比如 0 或 1。

设置电源模式后，模块将保持该模式，直到您进行更改。该模式在电源循环和SC7之间持续存在。

#### 1.1.2. 定义自定义模式

要定义自己的自定义模式，请将模式定义添加到文件 `etc/nvpmodel/nvpmodel_t210_jetson-nano.conf` 中，以下是模式1的示例：

```
# MAXN is the NONE power model to release all constraints
< POWER_MODEL ID=0 NAME=MAXN >
CPU_ONLINE CORE_0 1
CPU_ONLINE CORE_1 1
CPU_ONLINE CORE_2 1
CPU_ONLINE CORE_3 1
CPU_A57 MIN_FREQ  0
CPU_A57 MAX_FREQ -1
GPU_POWER_CONTROL_ENABLE GPU_PWR_CNTL_EN on
GPU MIN_FREQ  0
GPU MAX_FREQ -1
GPU_POWER_CONTROL_DISABLE GPU_PWR_CNTL_DIS auto
EMC MAX_FREQ 0

< POWER_MODEL ID=1 NAME=5W >
CPU_ONLINE CORE_0 1
CPU_ONLINE CORE_1 1
CPU_ONLINE CORE_2 0
CPU_ONLINE CORE_3 0
CPU_A57 MIN_FREQ  0
CPU_A57 MAX_FREQ 918000
GPU_POWER_CONTROL_ENABLE GPU_PWR_CNTL_EN on
GPU MIN_FREQ 0
GPU MAX_FREQ 640000000
GPU_POWER_CONTROL_DISABLE GPU_PWR_CNTL_DIS auto
EMC MAX_FREQ 1600000000

# mandatory section to configure the default mode
< PM_CONFIG DEFAULT=0 >
```

CPU的频率单位是千赫兹（KHz）。 GPU和EMMC的单位是赫兹（Hz）。 您必须在ID字段中为每个自定义模式分配唯一ID。

测试您的自定义模式以确定：

+ 要使用的活动核心数
+ 为GPU，EMC和每个CPU群集设置的频率

您设置的频率受模式0中定义的MaxN限制的约束。

### 1.2. jetson_clocks脚本

默认情况下，DVFS已启用，CPU/GPU/EMC时钟将根据负载而变化。
/usr/bin/jetson_clocks：是禁用DVFS并将CPU/GPU/EMC时钟设置为最大值的脚本。

## 2. 安装 jtop

先安装依赖：

```sh
sudo apt-get install git cmake
sudo apt-get install python3-dev
sudo apt-get install libhdf5-serial-dev hdf5-tools
sudo apt-get install libatlas-base-dev gfortran
```

然后通过pip安装：

```sh
pip3 install --upgrade pip
pip3 install jetson-stats
```

运行 `jtop` 启动即可。

![](https://img-blog.csdnimg.cn/20200518141009671.gif)

## 3. 配置CUDA

jetson nano 2GB 默认已经安装了 `CUDA10.2` ，但是直接运行 `nvcc -V` 是不会成功的，需要你把CUDA的路径写入环境变量中。

```sh
export CUBA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export PATH=/usr/local/cuda/bin:$PATH
```

![](https://img2020.cnblogs.com/blog/2039866/202012/2039866-20201225163050935-1352745444.jpg) <!-- jetson/jetson-2.jpg -->

> 显卡（GPU），显卡驱动，和cuda之间是怎样的关系？
>
> 硬件，底层接口，应用程序接口！
>
> 还有一个叫做cuDNN，是针对深度卷积神经网络的加速库

查看CUDA版本：

1. 方法1: 查看文件

    ```sh
    cat /usr/local/cuda/version.txt
    ```

1. 方法2: `nvcc --version`

### 3.1. cuDNN
> [homepage](https://developer.nvidia.com/zh-cn/cudnn)

查看cuDNN版本

```sh
cat /usr/local/cuda/include/cudnn.h | grep CUDNN_MAJOR -A 2
```

但无法查询到jetson的cuDNN。实际上官方镜像已经包含了cuDNN。集成在apt软件包中，所以目录并不在 `/usr/local` 下面，而是 `/usr/include/aarch64-linux-gnu/cudnn_version_v8.h` 。

## 4. 安装pytorch
> [PyTorch for Jetson - version 1.7.0 now available](https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-7-0-now-available/72048)

pytorch:

```sh
wget https://nvidia.box.com/shared/static/wa34qwrwtk9njtyarwt5nvo6imenfy26.whl -O torch-1.7.0-cp36-cp36m-linux_aarch64.whl
sudo apt-get install python3-pip libopenblas-base libopenmpi-dev
pip3 install Cython
pip3 install numpy torch-1.7.0-cp36-cp36m-linux_aarch64.whl
```

torchvision:

```sh
$ sudo apt-get install libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev
$ git clone --branch <version> https://github.com/pytorch/vision torchvision  # see below for version of torchvision to download
$ cd torchvision
$ export BUILD_VERSION=0.x.0  # where 0.x.0 is the torchvision version
$ sudo python3 setup.py install  # use python if installing for Python 2.7
$ cd ../  # attempting to load torchvision from build dir will result in import error
$ pip install 'pillow<7' # always needed for Python 2.7, not needed torchvision v0.5.0+ with Python 3.6
```

例如： `git clone --branch v0.8.1 git@gitee.com:brt2/torchvision.git`

pytorch 与 torchvision 之间的对应关系:

```
PyTorch v1.0 - torchvision v0.2.2
PyTorch v1.1 - torchvision v0.3.0
PyTorch v1.2 - torchvision v0.4.0
PyTorch v1.3 - torchvision v0.4.2
PyTorch v1.4 - torchvision v0.5.0
PyTorch v1.5 - torchvision v0.6.0
PyTorch v1.6 - torchvision v0.7.0
PyTorch v1.7 - torchvision v0.8.1
```

## 5. 安装海康相机

下载>进入[海康威视工业摄像头官网](https://www.hikrobotics.com/machinevision/service/download)，找到Linux系统ARM架构的安装包下载。

![](https://img2020.cnblogs.com/blog/2039866/202012/2039866-20201225163051222-126731737.jpg) <!-- jetson/jetson-0.jpg -->

但这个是针对ubuntu16.04的版本。运行时报错：

![](https://img2020.cnblogs.com/blog/2039866/202012/2039866-20201225163051714-1252553514.jpg) <!-- jetson/jetson-1.jpg -->

执行 `ldd ./MVS` 发现少

```
libicui18n.so.55
libicuuc.so.55
```

两个动态库。通过 `sudo find / -iname "libicu*"` 查找发现系统的 `libicui18n.so   libicuuc.so` 是60版本，这和需要的55版本都“隔代”了。

请在这里下载 [包文件](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/pool/main/i/icu/icu-devtools_52.1-3ubuntu0.8_arm64.deb)

```sh
wget https://mirrors.tuna.tsinghua.edu.cn/ubuntu- ports/pool/main/i/icu/libicu55_55.1-7_arm64.deb
dpkg -i libicu55_55.1-7_arm64.deb
```

然后运行即可正常启动MVS。

![](https://img2020.cnblogs.com/blog/2039866/202012/2039866-20201225163051892-1788822946.jpg) <!-- jetson/jetson-3.jpg -->

## 6. 安装OpenCV（With CUDA）
> [cnblog: 源码编译OpenCV](https://www.cnblogs.com/brt2/p/14437560.html)

## 7. 部署PaddlePaddle模型（如PaddleOCR、PP-YOLO）
> [csdn: 在Jetson nano上编译paddle（带TensorRT）并跑通Paddle-Inference-Demo](https://blog.csdn.net/qq_44498043/article/details/107300374)
>
> [如何在Jetson nano上同时编译TensorRT与Paddle Lite框架](https://cloud.tencent.com/developer/article/1673620)
>
> [csdn: Jetson Xavier NX部署PaddleOCR](https://blog.csdn.net/qq_39712148/article/details/109248249)
>
> [知乎: PaddleOCR识别模型转Pytorch全流程记录](https://zhuanlan.zhihu.com/p/335753926)

PaddlePaddle对硬件的支持还是很缓慢的，所以目前没有发现对Jetson的支持。但从v2.0开始，[Paddle2ONNX最新升级：飞桨模型全面支持ONNX协议啦！](https://www.paddlepaddle.org.cn/support/news?action=detail&id=2361)。所以，例如PaddleOCR等项目可以通过转换成ONNX的模型实现运行。

ONNX协议是由微软开发维护，支持范围很广，并且，ONNXRunTime支持GPU的运算。

更值得庆幸的是，从2020年底，[ONNXRunTime_v1.6.0](https://elinux.org/Jetson_Zoo#ONNX_Runtime)开始支持Jetson。

```sh
# Download pip wheel from location mentioned above
$ wget https://nvidia.box.com/shared/static/49fzcqa1g4oblwxr3ikmuvhuaprqyxb7.whl -O onnxruntime_gpu-1.6.0-cp36-cp36m-linux_aarch64.whl

# Install pip wheel
$ pip3 install onnxruntime_gpu-1.6.0-cp36-cp36m-linux_aarch64.whl
```
