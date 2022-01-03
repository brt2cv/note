<!--
+++
title       = "ImageMagick命令行工具"
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

ImageMagick 包括一组命令行工具来操作图片。你大部份习惯每次编辑图片都提供图形用户接口 (GUI) 编辑图像就像GIMP和PhotoShop一样。 然而，一个图形用户接口不总是方便的。 假如你想要从一个网页动态地处理一个图像，或者你在不同时间生成一样的或不同的图像，想要对许多图像或重复特定应用相同的操作。 对于操作的这些类型，处理公用程序命令行工具是一个好的选择。

在下面的段落中，可以找到命令行工具的简单短描述。点击程序名称可以得到关于这个程序的具体用法。 如果你想得到更多的关于ImageMagick，请仔细阅读以下命令行工具的使用方法：

+ convert

    转换图像格式和大小，模糊，裁剪，驱除污点，抖动，临近，图片上画图片，加入新图片，生成缩略图等。

+ identify

    描述一个或较多图像文件的格式和特性。

+ mogrify

    按规定尺寸制作一个图像，模糊，裁剪，抖动等。Mogrify改写最初的图像文件然后写到一个不同的图像文件。

+ composite

    根据一个图片或多个图片组合生成图片。

+ montage

    创建一些分开的要素图像。在含有要素图像任意的装饰图片，如边框、结构、图片名称等。

+ compare

    在算术上和视觉上评估不同的图片及其它的改造图片。

+ display

    如果你拥有一个 `X server` 的系统，它可以按次序的显示图片

+ animate

    利用 `X server` 显示动画图片

+ import

    在 `X server` 或任何可见的窗口上输出图片文件。 你可以捕获单一窗口，整个的荧屏或任何荧屏的矩形部分。

+ conjure

    解释执行 MSL (Magick Scripting Language) 写的脚本。
