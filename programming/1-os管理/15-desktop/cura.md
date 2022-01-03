<!--
+++
title       = "解析3D打印切片软件：Cura"
description = "1. 项目编译"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","15-desktop"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 项目编译
> [github](https://github.com/Ultimaker/Cura)
> [github_wiki: Running Cura from Source](https://github.com/Ultimaker/Cura/wiki/Running-Cura-from-Source)

### 1.1. 项目依赖

+ Python and PyQt5(QML)
+ Uranium

    Uranium is a Python framework for building 3D-related applications. It's not 3D-printing specific, but contains many useful classes for managing settings, 3D-scenes, and more.

+ CuraEngine(C++)

    CuraEngine is the slicing engine used by Cura. It forms the "back-end" of Cura, and unlike the rest of Cura is written in C++.

+ Arcus

    The Arcus library is used to communicate between Cura and CuraEngine. It is what is responsible for sending your models to the slicer and returning the G-Code to the user interface.

+ Savitar, pynest2d, Charon

    Savitar, pynest2d and libCharon are Python packages developed in-house for Cura. They are only necessary for the Python environment, and used by Cura to speed things up in C or just to separate the development process and have a cleaner API.

Sub-Dependencies

+ numpy
+ scipy
+ protobuf
+ pyserial
+ Sip: an application to generate Python bindings more easily.
+ Shapely: 使用GEOS库（C++），用于创建新的几何图形与许多坐标。
+ libnest2d: the library for which this library offers CPython bindings, and its dependencies:
    * Clipper(C++): a polygon clipping library.
    * Boost(C++), headers only
