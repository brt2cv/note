<!--
+++
title       = "blob斑点检测"
description = "1. 可选算法; 2. skimage 代码实现; 3. 基于 OpenCV"
date        = "2022-01-03"
tags        = ["python","opencv"]
categories  = ["7-理论知识","73-机器视觉"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

`blob` 或者叫斑点，就是在一幅图像上，暗背景上的亮区域，或者亮背景上的暗区域。由于斑点代表的是一个区域，相比单纯的角点，它的稳定性要好，抗噪声能力要强，所以它在图像配准上扮演了很重要的角色。

同时有时图像中的斑点也是我们关心的区域，比如在医学与生物领域，我们需要从一些X光照片或细胞显微照片中提取一些具有特殊意义的斑点的位置或数量。

比如天空的飞机、向日葵的花盘、X线断层图像中的两个斑点。

## 1. 可选算法

### 1.1. Laplacian of Gaussian (LoG)

这是速度最慢，可是最准确的一种算法。简单来说，就是对一幅图先进行一系列不同尺度的高斯滤波，然后对滤波后的图像做Laplacian运算。将全部的图像进行叠加。局部最大值就是所要检測的blob，这个算法对于大的blob检測会**非常慢**，还有就是该算法<font color=#FF0000>适合于检測暗背景下的亮blob</font>。

### 1.2. Difference of Gaussian (DoG)

这是LoG算法的一种高速近似，对图像进行高斯滤波之后，不做Laplacian运算，直接做减法。相减后的图做叠加。找到局部最大值，这个算法的缺陷与LoG相似。

如果需要利用 LoG 或 DoG 检測亮背景上的暗blob，能够将图像做<font color=#FF0000>反相</font>，这样亮背景就变成了暗背景，而暗blob就变成了亮blob，然后就能够用这两个算法了，检測完之后再反回来就好了。

### 1.3. Determinant of Hessian (DoH)

这是**最快**的一种算法，不须要做多尺度的高斯滤波，运算速度自然提升非常多，这个算法对暗背景上的亮blob或者亮背景上的暗blob都能检測。

缺点是<font color=#FF0000>**小尺寸**的blob检測不准确</font>。

## 2. skimage 代码实现
> [homepage](https://scikit-image.org/docs/dev/auto_examples/features_detection/plot_blob.html)

```py
from matplotlib import pyplot as plt
from skimage import data
from skimage.feature import blob_dog, blob_log, blob_doh
from math import sqrt
from skimage.color import rgb2gray

image = data.hubble_deep_field()[0:500, 0:500]
image_gray = rgb2gray(image)

plt.imshow(image)

blobs_log = blob_log(image_gray, max_sigma=30, num_sigma=10, threshold=.1)
# Compute radii in the 3rd column.
blobs_log[:, 2] = blobs_log[:, 2] * sqrt(2)

blobs_dog = blob_dog(image_gray, max_sigma=30, threshold=.1)
blobs_dog[:, 2] = blobs_dog[:, 2] * sqrt(2)

blobs_doh = blob_doh(image_gray, max_sigma=30, threshold=.01)

blobs_list = [blobs_log, blobs_dog, blobs_doh]
colors = ['yellow', 'lime', 'red']
titles = ['Laplacian of Gaussian', 'Difference of Gaussian',
          'Determinant of Hessian']
sequence = zip(blobs_list, colors, titles)


fig,axes = plt.subplots(1, 3, sharex=True, sharey=True, subplot_kw={'adjustable':'box-forced'})
axes = axes.ravel()
for blobs, color, title in sequence:
    ax = axes[0]
    axes = axes[1:]
    ax.set_title(title)
    ax.imshow(image, interpolation='nearest')
    for blob in blobs:
        y, x, r = blob
        c = plt.Circle((x, y), r, color=color, linewidth=2, fill=False)
        ax.add_patch(c)

plt.show()
```

效果图：

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200610110039262-754826197.jpg) <!-- 功能实例-blob斑点检测/功能实例-blob斑点检测0.jpg -->

## 3. 基于 OpenCV
> [homepage](https://www.learnopencv.com/blob-detection-using-opencv-python-c/)

SimpleBlobDetector，是非常简单的模块，算法使用如下参数控制，且执行之后的流程：

1. Thresholding, 阈值处理

    通过使用从minThreshold开始的阈值对源图像进行阈值处理，将源图像转换成多个二进制图像。这些阈值以thresholdStep大小依次递增直到maxThreshold，所以第一个阈值是minThreshold，第二个是minThreshold+thresholdStep，依此类推。

1. Grouping, 分组

    在每个二进制图像中，连接白色像素被分成一组，我们称为二进制斑点（binary blobs）

1. Merging, 合并

    计算二进制图像中二进制斑点的重心，并合并距离小于minDistBetweenBlobs的斑点

1. Center & Radius Calculation, 中心和半径计算

    计算并返回新合并的blobs的中心和半径。

```py
import cv2
import numpy as np
#读图片
im = cv2.imread('blod.jpg', cv2.IMREAD_GRAYSCALE)
#创建一个检测器并使用默认参数
detector = cv2.SimpleBlobDetector()
#检测斑点
keypoints = detector.detect(im)
#将检测到的斑点圈上红色的圆圈
#DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS保证圆的大小和斑点大小一样
im_with_keypoints = cv2.drawKeypoints(im, keypoints, np.array([]), (0,0,255),
                        cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
#显示检测到的点
cv2.imshow('keypoints', im_with_keypoints)
cv2.waitKey(0)
```

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200610110039647-408614795.jpg) <!-- 功能实例-blob斑点检测/功能实例-blob斑点检测1.jpg -->

### 3.1. 过滤斑点

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200610110039882-264563807.jpg) <!-- 功能实例-blob斑点检测/功能实例-blob斑点检测4.jpg -->

可以设置SimpleBlobDetector的参数来过滤我们想要的斑点类型：

1. 按颜色

    首先你需要设置filterByColor=1，设置blobColor=0选择颜色更暗的斑点，blobColor=255选择颜色更浅的斑点

    *注意：此功能已经损坏，我检查了代码，它似乎有一个逻辑错误。*

2. 按大小

    可以通过设置参数filterByArea=1以及minArea和maxArea的适当值来根据大小过滤斑点，例如，设置minArea=100将过滤掉所有小于100像素的斑点

3. 按形状：现在形状有三种不同的参数

    + Circularity, 圆度

        这只是测量斑点的圆形接近程度，例如正六边形具有比正方形更高的圆度，要按照圆度过滤，请设置 `filterByCircularity=1` 然后为 `minCircularity和maxCircularity` 设置适当的值。

        ![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200610110040085-916489289.jpg) <!-- 功能实例-blob斑点检测/功能实例-blob斑点检测3.jpg -->

    + Convexity, 凸度

        设置 `filterByConvexity=1` ，然后设置 `0<= minConvexity<=1` 和 `maxConvexity<=1` 。

        ![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200610110040276-1662197080.jpg) <!-- 功能实例-blob斑点检测/功能实例-blob斑点检测2.jpg -->

    + Ratio, 惯性比（长度）

        设定 `filterByInertia=1` ，并设置 `0 ≤ minInertiaRatio <= 1` 和 `maxInertiaRatio<=1` 。

        ![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200610110040470-130327958.jpg) <!-- 功能实例-blob斑点检测/功能实例-blob斑点检测6.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200610110040655-3657596.jpg) <!-- 功能实例-blob斑点检测/功能实例-blob斑点检测5.jpg -->
