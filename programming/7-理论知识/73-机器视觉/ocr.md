<!--
+++
title       = "OCR字符识别理论+实践"
description = "1. 整体思路; 2. 关键技术; 3. 开源项目整理"
date        = "2022-01-03"
tags        = []
categories  = ["7-理论知识","73-机器视觉"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 整体思路
> [知乎: OCR文字识别用的是什么算法](https://www.zhihu.com/question/20191727)
>
> [最全OCR资料汇总，awesome-OCR（论文集）](https://zhuanlan.zhihu.com/p/84815144)

两个步骤：

1. 文字检测, Detection

    行定位算法，从传统的基于文本行的投影信息和二值连通域信息进行文本行检测，也有以MSER和SWT为代表的连通域分析方法进行文字检测，到目前基于深度学习技术的CTPN，pixellink，psenet等算法。

2. 文字识别, Classification

    字符识别算法有最早的k近邻算法，贝叶斯分类算法，svm分类算法，BP神经网络，卷积神经网络，到现在流行的crnn+ctc以及cnn+rnn+attention。

### 1.1. 文字检测, Detection

近两年比较热门的 `object detection model` 有 [faster-rcnn](https://link.zhihu.com/?target=https%3A//arxiv.org/pdf/1506.01497.pdf) 和 [yolo](http://pjreddie.com/media/files/papers/yolo.pdf)。yolo 比 faster-rcnn 的速度更快，但是在accuracy上有些损失。

1. 先检测和提取 **Text Region**
2. 接着利用 `radon hough变换` 等方法进行**文本校正**
3. 通过投影直方图分割出单行的文本的图片

### 1.2. 文字识别, Classification

#### 1.2.1. segmentation based method, 需要分割字符的方式

分割字符的方法也比较多，用的最多的是基于<font color=#FF0000>投影直方图极值点</font>作为候选分割点并使用 `分类器+beam search` 搜索最佳分割点（具体可以参考 tesseract 的 presentation）。

    该方法的不足在于要事先选定可预测的sequence的最大长度，较适用于门牌号码或者车牌号码（少量字符, 且每个字符之间可以看作是独立）。

* mutli-label classification: [csdn: 车牌识别中的不分割字符的端到端(End-to-End)识别](https://blog.csdn.net/relocy/article/details/52174198)

* 要是长度很长的话呢，就得用CTC模型了: `RNN/LSTM/GRU + CTC`

    该方法最早由Alex Graves在06年提出应用于语音识别。这个方法的好处在于可以产生任意长度的文字，并且模型的性质决定了它有能力学到文字于文字之间的联系（temporal relations/dependencies）。

    不足之处在于sequential natural决定了它的计算效率没有CNN高，并且还有潜在的gradients exploding/vanishing的问题。

* attention-mechanism

    attention可以分为 `hard attention` 和 `soft attention` 。

    [hard attention](https://arxiv.org/pdf/1412.7755.pdf)能够直接给出hard location，通常是bounding box的位置 （https://arxiv.org/pdf/1412.7755.pdf)，想法直观，缺点是不能直接暴力bp。

    [soft attention]((https://arxiv.org/abs/1603.03101)通常是 rnn/lstm/gru encoder-decoder model，可以暴力bp。

* 还有一种比较特别的 gradient-based attention(http://www.ics.uci.edu/~yyang8/research/feedback/feedback-iccv2015.pdf) 也挺有意思。

### 1.3. 最后进行后处理校正

## 2. 关键技术

### 2.1. 特征提取

在深度学习方法出现之前，基于传统的手工设计特征（Handcraft Features），包括**基于连通区域**，以及**基于HOG的检测描框**的方法是比较主流的；如通过最大稳定极值区域（MSER-Maximally Stable Extremal Regions）得到字符的候选，并将这些字符候选看作连通图（graph）的顶点，此时就可以将文本行的寻找过程视为聚类（clustering）的过程，因为来自相同文本行的文本通常具有相同的方向、颜色、字体以及形状。<font color=#FF0000>OPENCV3.3中实现了MSER的场景文字检测和识别的算法。</font>

在基于深度学习的办法中，目前看到的大多数解决办法还是Detection和Recognition分开来研究，并没有真正的看Detection+Recognition的端到端完成识别的成果。

Detection部分大多数也是基于proposal的，一般先借助 `Faster R-CNN` 或者 `SSD` 得到许多个proposal，然后训练分类器对proposal进行分类，最后再做细致处理得到精细的文本区域；这个过程中学者们也解决了文字的方向，大小等的问题。同时，也有基于图像分割来做的，但是看到的不是很多，具体可见参考文献。

如果已经检测到了稳定的文本区域，Recognition部分可以采用比较通用的做法；可以对字符进行分割后单独识别，也可以进行序列识别，容易想见的是，序列识别才是真正有意义的。如前面的答主所说CNN+RNN+CTC的办法是论文中常看到的；这个办法也常用在验证码的自动识别上面。

在Detection方面，乔宇老师团队的：Detecting Text in Natural Image with Connectionist Text Proposal Network, ECCV, 2016. 这篇文章在github上有多个实现(CPTN)；

在Recognition方面白翔老师的CRNN也有不错的表现。

有人在github上将CPTN和CRNN结合了起来，前者采用Caffe实现，后者采用PyTorch实现，但是这并不是真正意义上的端到端。如何实现自然场景图片到正确有意义的文本输出是还需一些努力的。

参考文献和链接：
1. [文字的检测与识别资源 - dllTimes](https://blog.csdn.net/u010183397/article/details/56497303)
2. [趣谈“捕文捉字”——场景文字检测 | VALSE2017之十](https://zhuanlan.zhihu.com/p/29549641)
3. [bgshih/crnn](https://github.com/bgshih/crnn)
4. [tianzhi0549/CTPN](https://github.com/tianzhi0549/CTPN)
5. [Scene Text Detection](https://docs.opencv.org/3.0-beta/modules/text/doc/erfilter.html)

## 3. 开源项目整理

### 3.1. Tesseract

Tesseract OCR 引擎于20世纪80年代出现，更新迭代至今，它已经包括内置的深度学习模型，变成了十分稳健的 OCR 工具。而 Tesseract 和 OpenCV 的 EAST 检测器是一个很棒的组合，感兴趣的读者可参考机器之心报道。

Tesseract 支持 Unicode（UTF-8）字符集，可以识别超过 100 种语言，还包含多种输出支持，比如纯文本、PDF、TSV 等。但是为了得到更好的 OCR 结果，还必须提升提供给 Tesseract 的图像的质量。

值得注意的是，在执行实际的 OCR 之前，Tesseract 会在内部执行多种不同的图像处理操作（使用 Leptonica 库）。通常情况下表现不错，但在一些特定的情况下的效果却不够好，导致准确度显著下降。在将图像传递给 Tesseract 之前，可以尝试以下图像处理技术，但具体使用哪些技术取决于使用者想要读取的图像：

+ 反转图像
+ 重新缩放
+ 二值化
+ 移除噪声
+ 旋转/调整倾斜角度
+ 移除边缘

所有这些操作都可以使用 OpenCV 或通过 Python 使用 numpy 实现。

<font color=#FF0000>Tesseract (v4) 最新版本支持基于深度学习的 OCR，准确率显著提高。底层的 OCR 引擎使用的是一种循环神经网络（RNN）——LSTM 网络。</font>

#### 3.1.1. TesserOCR
> [pypi](https://pypi.org/project/tesserocr/)
>
> [github](https://github.com/sirfz/tesserocr)

`pip install tesserocr`

不过上述命令安装时常出现错误。推荐以下方式安装：

+ Linux: `sudo apt install python3-tesserocr`

+ Linux如需最新版本，则需要使用pip命令：

    如果安装报错，是因为缺少依赖。pip包中并不包含tesseract的头文件，所以：

    ```
    sudo apt install libleptonica-dev
    sudo apt install libtesseract-dev
    ```

    另外需要安装依赖环境 `pip3 install cython` ；

    最后执行： `pip3 install tesserocr` 。

+ Windows:

    1. 下载 tesserocr 安装包，[地址](https://github.com/simonflueckiger/tesserocr-windows_build/releases)
    2. 使用 conda 安装最新版本

        ```
        conda install -c conda-forge tesserocr
        ```

+ 树霉派： 支持直接 `pip3 install tesserocr` 安装

#### 3.1.2. 结合OpenCV EAST
> [OpenCV OCR and text recognition with Tesseract](https://www.pyimagesearch.com/2018/09/17/opencv-ocr-and-text-recognition-with-tesseract)
>
> [使用EAST和Tesseract进行文本识别](https://zhuanlan.zhihu.com/p/64857243)

1. 使用 `OpenCV EAST` 文本检测器执行文本检测，该模型是一个高度准确的深度学习文本检测器，可用于检测自然场景图像中的文本。
2. 提取出每个文本 ROI，并将其输入 Tesseract，从而构建完整的 OCR 流程。

EAST 文本检测器生成两个变量：

+ scores：文本区域的概率
+ geometry：文本区域的边界框位置

### 3.2. 中文 OCR 项目

中文 OCR，像身份证识别、火车票识别都是常规操作，它也可以实现更炫酷的功能，例如翻译笔在书本上滑动一行，自动获取完整的图像，并识别与翻译中文。

目前比较常用的中文 OCR 开源项目是 chineseocr，它基于 YOLO V3 与 CRNN 实现中文自然场景文字检测及识别，目前该项目已经有 2.5K 的 Star 量。

而机器之心之前介绍过另一个开源的中文 OCR 项目，基于 chineseocr 做出改进，是一个超轻量级的中文字符识别项目。详情可参考：实测超轻量中文OCR开源项目，总模型仅17M

项目地址：https://github.com/ouyanghuiyu/chineseocr_lite

该项目表示，相比 chineseocr，chineseocr_lite 采用了轻量级的主干网络 PSENet，轻量级的 CRNN 模型和行文本方向分类网络 AngleNet。尽管要实现多种能力，但 chineseocr_lite 总体模型只有 17M。目前 chineseocr_lite 支持任意方向文字检测，在识别时会自动判断文本方向。如下图所示机器之心实测效果示例：

![](https://img2020.cnblogs.com/blog/2039866/202010/2039866-20201023203248466-1403353541.jpg) <!-- ocr/ocr-0.jpg -->
