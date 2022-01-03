<!--
+++
title       = "【API】OpenMV常用功能"
description = "1. 捕获图像; 2. 图像Image对象的操作; 3. 统计信息; 4. 绘图; 5. 图像预处理; 6. 特征匹配; 7. 外设: pyb"
date        = "2022-01-03"
tags        = ["api"]
categories  = ["5-框架应用","57-opencv"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 捕获图像
> [homepage](https://docs.singtown.com/micropython/zh/latest/openmvcam/library/omv.sensor.html#module-sensor)

sensor模块，用于设置感光元件的参数。

常用函数列表

```py
sensor.snapshot()
sensor.skip_frames([n, time])  # 跳过n张照片，等待感光元件变稳定

sensor.set_pixformat()  # 设置像素模式。
    + sensor.GRAYSCALE: 8-bits per pixel.
    + sensor.RGB565: 16-bits per pixel.
    + sensor.BAYER: 8-bits per pixel bayer pattern.

sensor.set_framesize()  # 设置图像的大小
    - sensor.QQVGA: 160x120
    - sensor.HQVGA: 240x160
    - sensor.QVGA: 320x240
    - sensor.VGA: 640x480

sensor.set_windowing(roi)
    + roi: (x, y, w, h)
    + 或者自动居中: (w,h)

sensor.set_auto_gain()  # 自动增益
sensor.set_auto_whitebal()  # 自动白平衡
sensor.set_auto_exposure(enable[\, exposure_us])  # 自动曝光

sensor.set_gainceiling(gainceiling)  # 设置相机图像增益上限。2, 4, 8, 16, 32, 64, 128
sensor.set_contrast(constrast)  # 设置相机图像对比度。-3至+3
sensor.set_brightness(brightness)  # 设置相机图像亮度。-3至+3
sensor.set_saturation(saturation)  # 设置相机图像饱和度。-3至+3
sensor.set_quality(quality)  # 设置相机图像JPEG压缩质量。0-100

sensor.set_hmirror(enable)  # 打开（True）或关闭（False）水平镜像模式。默认关闭
sensor.set_vflip(enable)  # 打开（True）或关闭（False）垂直翻转模式。默认关闭
```

## 2. 图像Image对象的操作

### 2.1. 保存

```py
image.save(path[, roi[, quality=50]])
```

将图像的副本保存到 path 中的文件系统。

支持bmp/pgm/ppm/jpg/jpeg格式的图像文件。注意：您无法将jpeg格式的压缩图像保存成未压缩的格式。

+ roi 是一个用以复制的矩形的感兴趣区域(x, y, w, h)。如果未指定，ROI即复制整个图像的图像矩形。但这不适用于JPEG图像。

+ quality 指在图像尚未被压缩时将图像保存为JPEG格式的JPEG压缩质量。

### 2.2. 属性操作

```py
image.width()  # 返回以像素计的图像的宽度。
image.height()  # 返回以像素计的图像的高度。
image.format()  # 返回 sensor.GRAYSCALE(2) 或 sensor.RGB565(3)
image.size()  # 返回以字节计的图像大小。
```

### 2.3. 其他操作

```py
image.clear([mask])
```

将图像中的所有像素设置为零（非常快）。

```py
image.copy([roi[, x_scale[, y_scale[, copy_to_fb=False]]]])
```

创建一个图像对象的副本。

### 2.4. 裁剪

```py
image.crop([roi[, x_scale[, y_scale[, copy_to_fb=False]]]])
```

类似 image.copy()，但它对image对象进行操作，而不是进行深度复制。

+ roi 是要从中复制的感兴趣区域矩形(x, y, w, h)。 如果没有指定，它等于复制整个图像的图像矩形。此参数不适用于JPEG图像。
+ x_scale 是一个浮点值，通过它可以在x方向上缩放图像。
+ y_scale 是一个浮点值，通过它可以在y方向上缩放图像。

### 2.5. 格式转换

```py
image.to_bitmap([copy=False[, rgb_channel=-1]])
# 位图图像就像只有两个像素值（0和1）的灰度图像一样。

image.to_grayscale([copy=False[, rgb_channel=-1]])
image.to_rgb565([copy=False[, rgb_channel=-1]])
image.to_rainbow([copy=False[, rgb_channel=-1[, color_palette=sensor.PALETTE_RAINBOW]]])
# 彩虹图像是彩色图像，对于图像中的每个8位掩模灰度照明值具有唯一的颜色值。例如，它为热图像提供热图颜色。
```

<font color=#FF0000>此方法会修改基础图像像素</font>，以字节为单位更改图像大小，因此只能在灰度图像或RGB565图像上进行。否则 copy 必须为True才能在堆上创建新的修改图像。

rgb_channel 如果设置为0/1/2，则分别从R/G/B通道创建一个灰度图像，而如果在RGB565图像上调用此方法，则从RGB565像素计算灰度值。

## 3. 统计信息
> [homepage](https://docs.singtown.com/micropython/zh/latest/openmvcam/library/omv.image.html?highlight=get_statistics#image.get_statistics)

```py
image.get_statistics([thresholds[, invert=False[, roi[, bins[, l_bins[, a_bins[, b_bins]]]]]]])
```

如果传递 thresholds 列表，则直方图信息将仅从阈值列表中的像素计算得出。

针对灰度图：

```py
statistics.mean()  # 返回灰度的平均数(0-255)
statistics.median()  # 返回灰度的中位数(0-255)
statistics.mode()  # 返回灰度的众数(0-255)
statistics.stdev()  # 返回灰度的标准差(0-255)
statistics.min()  # 返回灰度的最小值(0-255)
statistics.max()  # 返回灰度的最大值(0-255)
statistics.lq()  # 返回灰度的第一四分数(0-255)
statistics.uq()  # 返回灰度的第三四分数(0-255)
```

LAB三个通道的平均数，中位数，众数，标准差，最小值，最大值，第一四分数，第三四分数：

```py
l_mean(), l_median(), l_mode(), l_stdev(), l_min(), l_max(), l_lq(), l_uq()
a_mean(), a_median(), a_mode(), a_stdev(), a_min(), a_max(), a_lq(), a_uq()
b_mean(), b_median(), b_mode(), b_stdev(), b_min(), b_max(), b_lq(), b_uq()
```

示例

```py
import sensor, image, time

sensor.reset() # 初始化摄像头
sensor.set_pixformat(sensor.RGB565) # 格式为 RGB565.
sensor.set_framesize(sensor.QVGA)
sensor.skip_frames(10) # 跳过10帧，使新设置生效
sensor.set_auto_whitebal(False)  # Create a clock object to track the FPS.

ROI=(80,30,15,15)

while(True):
    img = sensor.snapshot()
    statistics=img.get_statistics(roi=ROI)
    # 色块内的色彩均值
    color_l=statistics.l_mode()
    color_a=statistics.a_mode()
    color_b=statistics.b_mode()
    print(color_l,color_a,color_b)
    img.draw_rectangle(ROI)
```

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200822210302941-252113461.jpg) <!-- openmv/openmv-0.jpg -->

终端输出：

```py
56 66 51
56 66 55
56 66 51
...
```

---

```py
image.get_regression(thresholds[, invert=False[, roi[, x_stride=2[, y_stride=1[, area_threshold=10[, pixels_threshold=10[, robust=False]]]]]]])
```

## 4. 绘图

```py
image.draw_line(x0, y0, x1, y1[, color[, thickness=1]])
image.draw_rectangle(x, y, w, h[, color[, thickness=1[, fill=False]]])
image.draw_circle(x, y, radius, color=White)
image.draw_cross(x, y, size=5, color=White)
image.draw_string(x, y, text, color=White)
```

在图像上绘制一个矩形。 您可以单独传递x，y，w，h或作为元组(x，y，w，h)传递。

color 是用于灰度或RGB565图像的RGB888元组。默认为白色。但是，您也可以传递灰度图像的基础像素值(0-255)或RGB565图像的字节反转RGB565值。

将 `fill=True` 时，可以填充矩形。

## 5. 图像预处理

### 5.1. 畸变校正

```py
image.lens_corr([strength=1.8[, zoom=1.0]])
```

进行镜头畸变校正，以去除镜头造成的图像鱼眼效果。

+ strength 是一个浮点数，该值确定了对图像进行去鱼眼效果的程度。在默认情况下，首先试用取值1.8，然后调整这一数值使图像显示最佳效果。
+ zoom 是在对图像进行缩放的数值。默认值为 1.0 。

返回图像对象，以便您可以使用 `.` 表示法调用另一个方法。

不支持压缩图像和bayer图像。

```py
img = sensor.snapshot().lens_corr(strength = 1.8, zoom = 1.0)
```

### 5.2. 阈值、二值化

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200822210304547-1607901274.jpg) <!-- openmv/openmv-8.jpg -->

```py
image.binary(thresholds[, invert=False[, zero=False[, mask=None[, to_bitmap=False[, copy=False]]]]])
```

thresholds 必须是元组列表。例如： `[(lo, hi), (lo, hi), ..., (lo, hi)]` ，其中，`(lo, hi)` 定义你想追踪的颜色范围，而外层的list，则是可以对多个范围进行组合。

+ 对于灰度图像，每个元组需要包含两个值 - 最小灰度值和最大灰度值。
+ 对于RGB565图像，每个元组需要有六个值(l_lo，l_hi，a_lo，a_hi，b_lo，b_hi) - 分别是LAB L，A和B通道的最小值和最大值。

### 5.3. 直方图

```py
while(True):
    clock.tick()
    img = sensor.snapshot()
    # Gets the grayscale histogram for the image into 8 bins.
    # Bins defaults to 256 and may be between 2 and 256.
    print(img.get_histogram(bins=8))
    print(clock.fps())
```

### 5.4. 图像滤波

#### 5.4.1. Adaptive_Histogram_Equalization, 自适应直方图均衡

此示例展示了如何使用自适应直方图均衡来改善图像中的对比度。自适应直方图均衡将图像分割成区域，然后均衡这些区域中的直方图，以改善图像对比度与全局直方图均衡化。

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200822210303411-963751944.jpg) <!-- openmv/openmv-4.jpg -->

```py
# clip_limit < 0: 为您提供正常的自适应直方图均衡，这可能会导致大量的对比噪音...

# clip_limit = 1: 什么都不做。为获得最佳效果，请略高于1，如下所示。
# 越高，越接近标准自适应直方图均衡，并产生巨大的对比度波动。

img = sensor.snapshot().histeq(adaptive=True, clip_limit=3)

print(clock.fps())
```

#### 5.4.2. Histogram_Equalization 直方图均衡

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200822210303649-1161799219.jpg) <!-- openmv/openmv-3.jpg -->

 直方图均衡化使图像中的对比度和亮度标准化。

```py
img = sensor.snapshot().histeq()
```

#### 5.4.3. median 中值滤波
> [homepage](https://docs.singtown.com/micropython/zh/latest/openmvcam/library/omv.image.html#median)

在图像上运行中值滤波。在保留边缘的条件下，中值滤波是用来平滑表面的最佳滤波，但是运行速度极慢。

+ Size 是内核的大小。取1 (3x3 内核)、2 (5x5 内核)或更高值。

+ percentile 控制内核中所使用值的百分位数。默认情况下，每个像素都使用相邻的第五十个百分位数（中心）替换。使用最小滤波时，您可将此值设置为0，使用下四分位数滤波时设置为0.25，使用上四分位数滤波时设置为0.75，使用最大滤波时设置为1。

+ 如果你想在滤波器的输出上自适应地设置阈值，你可以传递 threshold=True 参数来启动图像的自适应阈值处理，他根据环境像素的亮度（核函数周围的像素的亮度有关），将像素设置为1或者0。 负数 offset 值将更多像素设置为1，而正值仅将最强对比度设置为1。 设置 invert 以反转二进制图像的结果输出。

+ mask 是另一个用作绘图操作的像素级掩码的图像。掩码应该是一个只有黑色或白色像素的图像，并且应该与你正在绘制的 image 大小相同。 仅掩码中设置的像素被修改。

#### 5.4.4. midpoint 中点滤波

```py
image.midpoint(size[, bias=0.5, threshold=False, offset=0, invert=False, mask])
```

bias: 控制图像混合的最小/最大程度。0只适用于最小滤波，1仅用于最大滤波。您可以通过 bias 对图像进行最小/最大化过滤。

#### 5.4.5. gaussian 高斯滤波

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200822210303900-1817651601.jpg) <!-- openmv/openmv-5.jpg -->

通过平滑高斯核对图像进行卷积。

```py
image.gaussian(size[, unsharp=False[, mul[, add=0[, threshold=False[, offset=0[, invert=False[, mask=None]]]]]]])
```

+ unsharp: 如果设置为True，那么这种方法不会仅进行高斯滤波操作，而是执行<font color=#FF0000>非锐化掩模操作，从而提高边缘的图像清晰度。</font>

+ mul: 是用以与卷积像素结果相乘的数字。若不设置，则默认一个值，该值将防止卷积输出中的缩放。

+ size: 是内核的大小。取1 (3x3 内核)、2 (5x5 内核)或更高值。

+ mask: 是另一个用作绘图操作的像素级掩码的图像。掩码应该是一个只有黑色或白色像素的图像，并且应该与你正在绘制的 image 大小相同。 仅掩码中设置的像素被修改。

如果你想在滤波器的输出上自适应地设置阈值，你可以传递 `threshold=True` 参数来启动图像的自适应阈值处理，将会根据环境像素的亮度（核函数周围的像素的亮度有关），将像素设置为1或者0。负数 offset 值将更多像素设置为1，而正值仅将最强对比度设置为1。设置 invert 以反转二进制图像的结果输出。

#### 5.4.6. laplacian

```py
image.laplacian(size[, sharpen=False[, mul[, add=0[, threshold=False[, offset=0[, invert=False[, mask=None]]]]]]])
```

#### 5.4.7. 通用卷积函数

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200822210304109-2099965800.jpg) <!-- openmv/openmv-6.jpg -->

```py
image.morph(size, kernel[, mul[, add=0[, threshold=False[, offset=0[, invert=False[, mask=None]]]]]])
```

+ kernel: 用来卷积图像的内核，可为一个元组或一个取值[-128:127]的列表。
size 将内核的大小控制为 `((size*2)+1)x((size*2)+1)` 像素。

```py
kernel_size = 1 # 3x3==1, 5x5==2, 7x7==3, etc.

kernel = [-2, -1,  0, \
          -1,  1,  1, \
           0,  1,  2]

img = sensor.snapshot()
# Run the kernel on every pixel of the image.
img.morph(kernel_size, kernel)
```

#### 5.4.8. cartoon_filter 卡通化滤波

漫游图像并使用flood-fills算法填充图像中的所有像素区域。这通过使图像的所有区域中的颜色变平来有效地<font color=#FF0000>从图像中去除纹理</font>。为了获得最佳效果，图像应具有大对比度，以使区域不会太容易相互渗透。

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200822210304314-1623946464.jpg) <!-- openmv/openmv-7.jpg -->

```py
image.cartoon(size[, seed_threshold=0.05[, floating_threshold=0.05[, mask=None]]])
```

+ seed_threshold: 控制填充区域中的像素与原始起始像素的差异
+ floating_threshold: 控制填充区域中的像素与任何相邻像素的差异

#### 5.4.9. 双边滤波

```py
image.bilateral(size[, color_sigma=0.1[, space_sigma=1[, threshold=False[, offset=0[, invert=False[, mask=None]]]]]])
```

+ color_sigma: 控制彩色明智像素之间必须有**多近的距离才能模糊**。增加此值可增加颜色模糊
+ space_sigma: 控制空间像素彼此之间必须有**多近才能模糊**。增加此值可增加像素模糊

如果你想在滤波器的输出上自适应地设置阈值，你可以传递 `threshold=True` 参数来启动图像的自适应阈值处理，他根据环境像素的亮度（核函数周围的像素的亮度有关），将像素设置为1或者0。负数 offset 值将更多像素设置为1，而正值仅将最强对比度设置为1。设置 invert 以反转二进制图像的结果输出。

请注意，如果将color_sigma/space_sigma设置为聚合，双边过滤器可能会引入图像缺陷。如果你看到缺陷，增加sigma值直到缺陷消失

#### 5.4.10. 位运算

```py
image.b_and(image[, mask=None]) -> image
image.b_nand(image[, mask=None]) -> image
image.b_or(image[, mask=None]) -> image
image.b_nor(image[, mask=None]) -> image
image.b_xor(image[, mask=None]) -> image
image.b_xnor(image[, mask=None]) -> image
```

#### 5.4.11. difference

Replace the image with the "abs(NEW-OLD)" frame difference.

```py
img.difference("temp/bg.bmp")
```

### 5.5. 特效功能

#### 5.5.1. logpolar 笛卡尔转极坐标系

```py
image.logpolar([reverse=False])
```

图像从笛卡尔坐标到对数极坐标重新投影。

+ 设置 reverse = True 可以在相反的方向重新投影。

对数极坐标重新投影将图像的旋转转换为x平移和缩放到y平移。

#### 5.5.2. 畸变矫正

```py
image.lens_corr([strength=1.8[, zoom=1.0]])
```

进行镜头畸变校正，以去除镜头造成的图像鱼眼效果。

strength 是一个浮点数，该值确定了对图像进行去鱼眼效果的程度。在默认情况下，首先试用取值1.8，然后调整这一数值使图像显示最佳效果。

zoom 是在对图像进行缩放的数值。默认值为 1.0 。

#### 5.5.3. 透视坐标系矫正

```py
img.rotation_corr([x_rotation=0.0[, y_rotation=0.0[, z_rotation=0.0[, x_translation=0.0[, y_translation=0.0[, zoom=1.0]]]]]])
通过执行帧缓冲区的3D旋转来纠正图像中的透视问题。
```

+ x_rotation 是围绕x轴在帧缓冲器中旋转图像的度数（这使图像上下旋转）。
+ y_rotation 是帧缓冲区中围绕y轴旋转图像的度数（即左右旋转图像）。
+ z_rotation 是围绕z轴在帧缓冲器中旋转图像的度数（即，使图像旋转到适当位置）。
+ x_translation 是旋转后将图像移动到左侧或右侧的单位数。因为这个变换是应用在三维空间的，单位不是像素…
+ y_translation 是旋转后将图像上移或下移的单位数。因为这个变换是应用在三维空间的，单位不是像素…
+ zoom 是通过图像缩放的量。默认情况下1.0。

#### 5.5.4. 取反（仅适用于二值图像）

```py
image.invert()
```

将二进制图像0（黑色）变为1（白色），1（白色）变为0（黑色），非常快速地翻转二进制图像中的所有像素值。

#### 5.5.5. 移除阴影

```py
image.remove_shadows([image]) -> image
```

从该图像中移除阴影。

如果当前图像没有“无阴影”版本出现，则此方法将尝试从图像中去除阴影，但没有真实无阴影的图像依据。 这种算法适用于去除平坦均匀背景中的阴影。 请注意，此方法需要多秒才能运行，并且仅适用于实时移除阴影，动态生成无阴影版本的图像。 该算法的未来版本将适用于更多的环境，但同样缓慢。

如果当前图像有“无阴影”版本出现，则此方法将使用“真实源”背景无阴影图像去除图像中的所有阴影以滤除阴影。 非阴影像素不会被过滤掉，因此您可以向场景中添加以前不存在的新对象，并且这些对象中的任何非阴影像素都将显示出来。

#### 5.5.6. 删除照明效果

```py
image.chrominvar() -> image
```

从图像中删除照明效果，仅留下颜色渐变。比 image.illuminvar() 更快但受阴影影响。

```py
image.illuminvar()
```

从图像中删除照明效果，仅留下颜色渐变。比 image.chrominvar() 慢但不受阴影影响。

#### 5.5.7. 比对差异

```py
image.get_similarity(image) -> Similarity
```

返回一个“相似度”对象，描述两幅图像使用SSIM算法来比较两幅图像之间的8x8像素色块的相似度。

image 可以是图像对象，未压缩图像文件的路径(bmp/pgm/ppm)，也可以是标量值。

## 6. 特征匹配

### 6.1. AprilTag: 3D定位
> [homepage](https://april.eecs.umich.edu/software/apriltag.html)
>
> [知乎: Apriltag定位和识别](https://zhuanlan.zhihu.com/p/91318636)

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200822210304892-688631212.jpg) <!-- openmv/openmv-1.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200822210305263-48007205.jpg) <!-- openmv/openmv-2.jpg -->

Apriltag定位算法的主要步骤如下：

1. 自适应阈值分割
2. 查找轮廓，使用Union-find查找连通域
3. 对轮廓进行直线拟合，查找候选的凸四边形
4. 对四边形进行解码，识别Tag
5. 坐标变换，转换到世界坐标系

### 6.2. 寻找色块
> [homepage](https://book.openmv.cc/image/blob.html)

```py
image.find_blobs(thresholds, roi=Auto, x_stride=2, y_stride=1, invert=False, area_threshold=10, pixels_threshold=10, merge=False, margin=0, threshold_cb=None, merge_cb=None)
```

+ thresholds: `list of tuples`
    * 灰度值：[(lo, hi), (lo, hi), ..., (lo, hi)]
    * 颜色值：[(l_lo，l_hi，a_lo，a_hi，b_lo，b_hi), ...]
+ invert: 反转阈值
+ x_stride: 是查找某色块时需要跳过的x像素的数量。找到色块后，**直线填充算法**将精确像素。若已知色块较大，可增加 x_stride 来提高查找色块的速度。
+ area_threshold: 色块的边界框区域
+ pixel_threshold: 色块像素数量
+ merge:

    + True，则合并所有没有被过滤掉的色块，这些色块的边界矩形互相交错重叠。

    margin 可在相交测试中用来增大或减小色块边界矩形的大小。例如：边缘为1、相互间边界矩形为1的色块将被合并。

    合并色块使颜色代码追踪得以实现。每个色块对象有一个代码值 code ，该值为一个位向量。 例如：若您在 image.find_blobs 中输入两个颜色阈值，则第一个阈值代码为1，第二个代码为2（第三个代码为4，第四个代码为8，以此类推）。 合并色块对所有的code使用逻辑或运算，以便您知道产生它们的颜色。这使得您可以追踪两个颜色，若您用两种颜色得到一个色块对象，则可能是一种颜色代码。

    若用户使用严格的颜色范围，无法完全追踪目标对象的所有像素，您可能需要合并色块。

    最后，若您想要合并色块，但不想两种不同阈值颜色的色块被合并，只需分别两次调用 image.find_blobs ，不同阈值色块就不会被合并。

+ threshold_cb: callback(blob) -> 返回True以保留色块或返回False以过滤色块。
+ merge_cb: callback(blob_1, blob_2) -> 返回True以合并色块，或返回False以防止色块合并。

示例1: 自适应灰度色块

```py
print("Learning thresholds...")
threshold = [128, 128] # Middle grayscale values.
for i in range(60):
    img = sensor.snapshot()
    hist = img.get_histogram(roi=r)
    lo = hist.get_percentile(0.01) # Get the CDF of the histogram at the 1% range (ADJUST AS NECESSARY)!
    hi = hist.get_percentile(0.99) # Get the CDF of the histogram at the 99% range (ADJUST AS NECESSARY)!
    # Average in percentile values.
    threshold[0] = (threshold[0] + lo.value()) // 2
    threshold[1] = (threshold[1] + hi.value()) // 2
    for blob in img.find_blobs([threshold], pixels_threshold=100, area_threshold=100, merge=True, margin=10):
        img.draw_rectangle(blob.rect())
        img.draw_cross(blob.cx(), blob.cy())
        img.draw_rectangle(r)

print("Thresholds learned...")
print("Tracking colors...")

while(True):
    clock.tick()
    img = sensor.snapshot()
    for blob in img.find_blobs([threshold], pixels_threshold=100, area_threshold=100, merge=True, margin=10):
        img.draw_rectangle(blob.rect())
        img.draw_cross(blob.cx(), blob.cy())
    print(clock.fps())
```

示例2: 查找彩色块

```py
thresholds = [(30, 100, 15, 127, 15, 127), # generic_red_thresholds
              (30, 100, -64, -8, -32, 32), # generic_green_thresholds
              (0, 30, 0, 64, -128, 0)] # generic_blue_thresholds

while(True):
    clock.tick()
    img = sensor.snapshot()
    for blob in img.find_blobs([thresholds[threshold_index]], pixels_threshold=200, area_threshold=200, merge=True):
        # These values depend on the blob not being circular - otherwise they will be shaky.
        if blob.elongation() > 0.5:
            img.draw_edges(blob.min_corners(), color=(255,0,0))
            img.draw_line(blob.major_axis_line(), color=(0,255,0))
            img.draw_line(blob.minor_axis_line(), color=(0,0,255))
        # These values are stable all the time.
        img.draw_rectangle(blob.rect())
        img.draw_cross(blob.cx(), blob.cy())
        # Note - the blob rotation is unique to 0-180 only.
        img.draw_keypoints([(blob.cx(), blob.cy(), int(math.degrees(blob.rotation())))], size=20)
    print(clock.fps())
```

#### 6.2.1. blob色块对象
> [homepage](https://docs.singtown.com/micropython/zh/latest/openmvcam/library/omv.image.html#blob)

```py
blob.rect() 返回这个色块的外框——矩形元组(x, y, w, h)，可以直接在image.draw_rectangle中使用。

blob.x()
blob.y()
blob.w()
blob.h()
blob.pixels()
blob.cx()
blob.cy()
blob.rotation()

blob.code()  # 返回一个16bit数字，每一个bit会对应每一个阈值。举个例子：
"""
blobs = img.find_blobs([red, blue, yellow], merge=True)

如果这个色块是红色，那么它的code就是0001，如果是蓝色，那么它的code就是0010。注意：一个blob可能是合并的，如果是红色和蓝色的blob，那么这个blob就是0011。这个功能可以用于查找颜色代码。也可以通过blob[8]来获取。
"""

blob.count()
"""
如果merge=True，那么就会有多个blob被合并到一个blob，这个函数返回的就是这个的数量。
如果merge=False，那么返回值总是1。
"""

blob.area()  # 返回色块的外框的面积。应该等于(w * h)

blob.density()
"""
返回色块的密度。这等于色块的像素数除以外框的区域。如果密度较低，那么说明目标锁定的不是很好。
比如，识别一个红色的圆，返回的blob.pixels()是目标圆的像素点数，blob.area()是圆的外接正方形的面积。
"""
```

### 6.3. 形状特征
> [homepage_demo](https://book.openmv.cc/example/09-Feature-Detection/find-circles.html)

```py
image.find_lines([roi[, x_stride=2[, y_stride=1[, threshold=1000[, theta_margin=25[, rho_margin=25]]]]]])
image.find_line_segments([roi[, merge_distance=0[, max_theta_difference=15]]])

image.find_rects([roi=Auto, threshold=10000])
image.find_circles([roi[, x_stride=2[, y_stride=1[, threshold=2000[, x_margin=10[, y_margin=10[, r_margin=10[, r_min=2[, r_max[, r_step=2]]]]]]]]]])
image.find_edges(edge_type[, threshold])
image.find_hog([roi[, size=8]])

image.find_lbp(roi)
image.find_features(cascade[, threshold=0.5[, scale=1.5[, roi]]])
image.find_keypoints([roi[, threshold=20[, normalized=False[, scale_factor=1.5[, max_keypoints=100[, corner_detector=image.CORNER_AGAST]]]]]])
```

#### 6.3.1. Line

```py
x1()
y1()
x2()
y2()
lenght()
magnitude()  # return: 霍夫变换后的直线的模
theta()  # 返回霍夫变换后的直线的角度（0-179度）
rho()  # 返回霍夫变换后的直线p值
```

#### 6.3.2. 矩形对象

```py
rect.corners()  # return: 由矩形对象的四个角组成的四个元组(x,y)的列表
rect.rect()  # return: 矩形元组(x, y, w, h)
x()
y()
w()
h()
rect.magnitude()  # return: 矩形的模(magnitude)
```

#### 6.3.3. 圆形对象

```py
x()
y()
r()
magnitude()
```

示例：

```py
for c in img.find_circles(threshold=3500,
                          x_margin=10,
                          y_margin=10,
                          r_margin=10,
                          r_min=2,
                          r_max=100,
                          r_step=2):
        img.draw_circle(c.x(), c.y(), c.r(), color=(255, 0, 0))
        print(c)
```

### 6.4. 读码

```py
image.find_barcodes([roi])
image.find_qrcodes([roi])
image.find_apriltags([roi[, families=image.TAG36H11[, fx[, fy[, cx[, cy]]]]]])
image.find_datamatrices([roi[, effort=200]])
```

### 6.5. 模版匹配

尝试使用归一化互相关(NCC)算法在图像中找到第一个模板匹配的位置。返回匹配位置的边界框元组(x, y, w, h)，否则返回None。

注意：<font color=#FF0000>仅支持灰度图像</font>。

```py
image.find_template(template, threshold[, roi[, step=2[, search=image.SEARCH_EX]]])
```

+ threshold 是浮点数（0.0-1.0），其中较小的值在提高检测速率同时增加误报率。相反，较高的值会降低检测速率，同时降低误报率。

+ step 是查找模板时需要跳过的像素数量。跳过像素可大大提高算法运行的速度。该方法只适用于SERACH_EX模式下的算法。

+ search 可为 `image.SEARCH_DS` or `image.SEARCH_EX` . image.SEARCH_DS 搜索模板所用算法较 image.SEARCH_EX 更快，但若模板位于图像边缘周围，可能无法成功搜索。 image.SEARCH_EX 可对图像进行较为详尽的搜索，但其运行速度远低于 image.SEARCH_DS 。

```py
for t in templates_files:
    template = image.Image(t)
    #对每个模板遍历进行模板匹配
    r = img.find_template(template, 0.70, step=4, search=SEARCH_EX) #, roi=(10, 0, 60, 60))
#find_template(template, threshold, [roi, step, search]),threshold中
#的0.7是相似度阈值,roi是进行匹配的区域（左上顶点为（10，0），长80宽60的矩形），
#注意roi的大小要比模板图片大，比frambuffer小。
#把匹配到的图像标记出来
    if r:
        img.draw_rectangle(r)
        print(t) #打印模板名字
```

<font color=#FF0000>NCC算法，只能匹配与模板图片大小和角度基本一致的图案。局限性相对来说比较大，视野中的目标图案稍微比模板图片大一些或者小一些就可能匹配不成功。</font>

### 6.6. 特征点检测

多角度多大小匹配可以尝试保存多个模板，采用多模板匹配。

特征点检测（find_keypoint）: 如果是刚开始运行程序，例程提取最开始的图像作为目标物体特征，kpts1保存目标物体的特征。<font color=#FF0000>默认会匹配目标特征的多种比例大小和角度</font>，而不仅仅是保存目标特征时的大小角度，比模版匹配灵活，也不需要像多模板匹配一样保存多个模板图像。

特征点检测，也可以提前保存目标特征，之前是不推荐这么做的，<font color=#FF0000>因为环境光线等原因的干扰，可能导致每次运行程序光线不同特征不同</font>，匹配度会降低。但是最新版本的固件中，增加了对曝光度、白平衡、自动增益值的调节，可以人为的定义曝光值和白平衡值，相对来说会减弱光线的干扰。也可以尝试提前保存目标特征。

```py
image.find_keypoints([roi[, threshold=20[, normalized=False[, scale_factor=1.5[, max_keypoints=100[, corner_detector=image.CORNER_AGAST]]]]]])
```

+ corner_detector 是从图像中提取键点所使用的角点检测器算法。 可为 `image.CORNER_FAST` 或 `image.CORNER_AGAST` 。FAST角点检测器运行速度更快，但其准确度较低。

+ threshold 是控制提取的数量的数字（取值0-255）。对于默认的AGAST角点检测器，该值应在20左右。 对于FAST角点检测器，该值约为60-80。阈值越低，您提取的角点越多。

+ normalized 是布尔值。若为True，在多分辨率下关闭提取键点。 若您不关心处理扩展问题，且希望算法运行更快，就将之设置为True。

+ scale_factor 是一个必须大于1.0的浮点数。较高的比例因子运行更快，但其图像匹配相应较差。理想值介于1.35-1.5之间。

```py
kpts2 = img.find_keypoints(max_keypoints=150, threshold=10, normalized=True)
#如果检测到特征物体
cdif (kpts2):
    match = image.match_descriptor(kpts1, kpts2, threshold=85)

    #match.count()是kpt1和kpt2的匹配的近似特征点数目。
    if (match.count()>10):  # 如果大于10，证明两个特征相似，匹配成功
        img.draw_rectangle(match.rect())
        img.draw_cross(match.cx(), match.cy(), size=10)

    #match.theta()是匹配到的特征物体相对目标物体的旋转角度。
    print(kpts2, "matched:%d dt:%d"%(match.count(), match.theta()))
```

## 7. 外设: pyb

作为一个单片机，控制IO口，IIC，SPI，CAN，PWM，定时器当然都是可以的。
而且，使用python语言，可以非常简单的调用它们，而不用考虑寄存器。

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201102170421678-1124637196.jpg) <!-- openmv/openmv-11.jpg -->

因为MicroPython可以在很多平台上运行。最开始在pyb模块，pyboard，是基于STM32的，但是后来又加入了esp8266和esp32，以及nrf系列，他们的架构和STM32不同。所以官方统一制定了machine模块，所以通用性更高一些。最终pyb会被淘汰，但是目前pyb比machine功能要多。

常用外设

### 7.1. LED

```py
from pyb import LED

led = LED(1) # 红led
led.toggle()
led.on()#亮
led.off()#灭
```

### 7.2. IO引脚

```py
from pyb import Pin

p_out = Pin('P7', Pin.OUT_PP)#设置p_out为输出引脚
p_out.high()#设置p_out引脚为高
p_out.low()#设置p_out引脚为低

p_in = Pin('P7', Pin.IN, Pin.PULL_UP)#设置p_in为输入引脚，并开启上拉电阻
value = p_in.value() # get value, 0 or 1#读入p_in引脚的值
```

### 7.3. Servo（舵机）

```py
from pyb import Servo

s1 = Servo(1) # servo on position 1 (P7)
s1.angle(45) # move to 45 degrees
s1.angle(-60, 1500) # move to -60 degrees in 1500ms
s1.speed(50) # for continuous rotation servos
```

### 7.4. 定时器

```py
from pyb import Timer

tim = Timer(4, freq=1000)
tim.counter() # get counter value
tim.freq(0.5) # 0.5 Hz
tim.callback(lambda t: pyb.LED(1).toggle())
```

### 7.5. PWM

```py
from pyb import Pin, Timer

p = Pin('P7') # P7 has TIM4, CH1
tim = Timer(4, freq=1000)
ch = tim.channel(1, Timer.PWM, pin=p)
ch.pulse_width_percent(50)
```

### 7.6. ADC

```py
from pyb import Pin, ADC

adc = ADC('P6')
adc.read() # read value, 0-4095
```

### 7.7. UART

UART（Universal Asynchronous Receive Transmitter）：也就是我们经常所说的串口，基本都用于调试。

主机和从机至少要接三根线，RX、TX和GND。TX用于发送数据，RX用于接受数据。注意A和B通信A.TX要接B.RX，A.RX要接B.TX。

```py
from pyb import UART

uart = UART(3, 9600)
uart.write('hello')
uart.read(5) # read up to 5 bytes
```

### 7.8. SPI

SPI（Serial Peripheral Interface, 同步外设接口）是由摩托罗拉公司开发的全双工同步串行总线，该总线大量用在与EEPROM、ADC、FRAM和显示驱动器之类的慢速外设器件通信。

SPI是一种串行同步通讯协议，由一个主设备和一个或多个从设备组成，主设备启动一个与从设备的同步通讯，从而完成数据的交换。SPI 接口由SDI（串行数据输入），SDO（串行数据输出），SCK（串行移位时钟），CS（从使能信号）四种信号构成，CS 决定了唯一的与主设备通信的从设备，片选信号低电平有效。如没有CS 信号，则只能存在一个从设备，主设备通过产生移位时钟来发起通讯。通讯时，数据由SDO 输出，SDI 输入，数据在时钟的上升或下降沿由SDO 输出，在紧接着的下降或上升沿由SDI 读入，这样经过8/16 次时钟的改变，完成8/16 位数据的传输。

<font color=#FF0000>I2C总线传输速度在100kbps-4Mbps。spi总线传输速度更快，可以达到30MHZ以上。</font>

```py
from pyb import SPI

spi = SPI(2, SPI.MASTER, baudrate=200000, polarity=1, phase=0)
spi.send('hello')
spi.recv(5) # receive 5 bytes on the bus
spi.send_recv('hello') # send a receive 5 bytes
```

### 7.9. IIC

也长写成“I2C”(INTER IC BUS)。

SPI和UART可以实现全双工，但I2C不行。

> I2C线更少，我觉得比UART、SPI更为强大，但是技术上也更加麻烦些，因为I2C需要有双向IO的支持，而且使用上拉电阻，我觉得抗干扰能力较弱，一般用于同一板卡上芯片之间的通信，较少用于远距离通信。SPI实现要简单一些，UART需要固定的波特率，就是说两位数据的间隔要相等，而SPI则无所谓，因为它是有时钟的协议。

```py
from machine import I2C, Pin
i2c = I2C(sda=Pin('P5'),scl=Pin('P4'))

i2c.scan()
i2c.writeto(0x42, b'123')  # write 3 bytes to slave with 7-bit address 42
i2c.readfrom(0x42, 4)   # read 4 bytes from slave with 7-bit address 42

i2c.readfrom_mem(0x42, 8, 3)  # read 3 bytes from memory of slave 42, starting at memory-address 8 in the slave
i2c.writeto_mem(0x42, 2, b'\x10') # write 1 byte to memory of slave 42, starting at address 2 in the slave
```

### 7.10. CAN

CAN总线使用的双绞线（屏蔽/非屏蔽双绞线）：

![](https://img2020.cnblogs.com/blog/2039866/202011/2039866-20201102170422173-831099232.jpg) <!-- openmv/openmv-10.jpg -->

```py
from pyb import CAN

can = CAN(2, CAN.NORMAL)
# 设置不同的波特率（默认为125Kbps）
# 注意：以下参数仅适用于H7。
#
# can.init(CAN.NORMAL, prescaler=32, sjw=1, bs1=8, bs2=3) # 125Kbps
# can.init(CAN.NORMAL, prescaler=16, sjw=1, bs1=8, bs2=3) # 250Kbps
# can.init(CAN.NORMAL, prescaler=8,  sjw=1, bs1=8, bs2=3) # 500Kbps
# can.init(CAN.NORMAL, prescaler=4,  sjw=1, bs1=8, bs2=3) # 1000Kbps

can.restart()

while (True):
    # Send message with id 1
    can.send('Hello', 1)
```
