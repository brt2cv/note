<!--
+++
title       = "TorchVision: PyTorch的图像处理库+工具集"
description = "1. torchvision.datasets; 2. torchvision.io; 3. torchvision.models; 4. torchvision.transforms"
date        = "2021-12-21"
tags        = []
categories  = ["5-框架应用","55-pytorch"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> [官网入门教程 & API](https://pytorch.org/docs/stable/torchvision/index.html)

这个包中有四个大类：

+ torchvision.datasets
+ torchvision.models
+ torchvision.transforms
+ torchvision.utils

## 1. torchvision.datasets

+ CelebA
+ CIFAR
+ Cityscapes
+ COCO
+ DatasetFolder
+ EMNIST
+ FakeData
+ Fashion-MNIST
+ Flickr
+ HMDB51
+ ImageFolder
+ ImageNet
+ Kinetics-400
+ KMNIST
+ LSUN
+ MNIST
+ Omniglot
+ PhotoTour
+ Places365
+ QMNIST
+ SBD
+ SBU
+ STL10
+ SVHN
+ UCF101
+ USPS
+ VOC

```py
torch.utils.data.DataLoader(coco_cap, batch_size=args.batchSize, shuffle=True, num_workers=args.nThreads)
```

## 2. torchvision.io

+ Video
+ Fine-grained video API
+ Image

## 3. torchvision.models

+ Classification
    + AlexNet
    + VGG
    + ResNet
    + SqueezeNet
    + DenseNet
    + Inception v3
    + GoogLeNet
    + ShuffleNet v2
    + MobileNet v2
    + ResNeXt
    + Wide ResNet
    + MNASNet
+ Semantic Segmentation
    * FCN ResNet50
    * ResNet101
    * DeepLabV3 ResNet50
    * ResNet101
+ Object Detection, Instance Segmentation and Person Keypoint Detection
+ Faster R-CNN ResNet-50 FPN
+ Mask R-CNN ResNet-50 FPN
+ Video classification

载入模型示例

```py
import torchvision.models as models

resnet18 = models.resnet18()
alexnet = models.alexnet()
vgg16 = models.vgg16()
squeezenet = models.squeezenet1_0()
densenet = models.densenet161()
inception = models.inception_v3()
googlenet = models.googlenet()
shufflenet = models.shufflenet_v2_x1_0()
mobilenet = models.mobilenet_v2()
resnext50_32x4d = models.resnext50_32x4d()
wide_resnet50_2 = models.wide_resnet50_2()
mnasnet = models.mnasnet1_0()
```

你也可以选择使用 `pretrained=True` 参数来加载预训练参数。

以下罗列了常见的几种模型的 `Top-1/5 error` ：ImageNet 1-crop error rates (224x224)

| Network |Top-1 error |Top-5 error |
| -- | -- | -- |
| AlexNet | 43.45 | 20.91 |
| VGG-16 | 28.41 | 9.62 |
| VGG-19 | 27.62 | 9.12 |
| VGG-16 with batch normalization | 26.63 | 8.50 |
| VGG-19 with batch normalization | 25.76 | 8.15 |
| ResNet-18 | 30.24 | 10.92 |
| ResNet-34 | 26.70 | 8.58 |
| ResNet-50 | 23.85 | 7.13 |
| ResNet-101 | 22.63 | 6.44 |
| ResNet-152 | 21.69 | 5.94 |
| Densenet-161 | 22.35 | 6.20 |
| MobileNet V2 | 28.12 | 9.71 |
| ResNeXt-50-32x4d | 22.38 | 6.30 |
| ResNeXt-101-32x8d | 20.69 | 5.47 |
| Wide ResNet-50-2 | 21.49 | 5.91 |
| Wide ResNet-101-2 | 21.16 | 5.72 |

## 4. torchvision.transforms

+ Scriptable transforms
+ Compositions of transforms
+ Transforms on PIL Image and torch.*Tensor
+ Transforms on PIL Image only
+ Transforms on torch.*Tensor only
+ Conversion Transforms
+ Generic Transforms
+ Functional Transforms

### 4.1. 针对 PIL.Image 的图像处理

+ Scale(size, interpolation=Image.BILINEAR)
+ CenterCrop(size) - center-crops the image to the given size
+ RandomCrop(size, padding=0)
+ RandomHorizontalFlip()
+ RandomSizedCrop(size, interpolation=Image.BILINEAR)
+ Pad(padding, fill=0)

### 4.2. 针对张量 torch.*Tensor 的操作

+ Normalize(mean, std)

### 4.3. 数据格式转换操作

+ ToTensor()

### 4.4. 其他操作

例如：

```py
transforms.Lambda(lambda x: x.add(10))  # 将每个像素值加10
```
