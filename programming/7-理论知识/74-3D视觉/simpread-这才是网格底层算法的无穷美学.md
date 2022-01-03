<!--
+++
title       = "Mesh网格划分一览"
description = "1. 部分论文成果图; 2. 软件工具推荐"
date        = "2022-01-03"
tags        = []
categories  = ["7-理论知识","74-3D视觉"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [mp.weixin.qq.com](https://mp.weixin.qq.com/s/UlMvZCnshTBHzPOD3uIBYw)

网格划分技术作为有限元仿真中的核心一环，历来是工程师们头疼且费时较多的一个环节，目前主流商用软件都提供通用的网格划分功能。

作为软件用户群体，我们很少去探究网格划分背后的算法问题，而且也无需去做过多的探索，不过今天小编将截取部分论文研究成果，为大家展示从底层计算机图形学方面提供的算法实践成果，这些成果涵盖了三角形、四边形、四面体、六面体，或是粒子群等离散形式，同时为大家推荐几个网格专用处理工具，感兴趣的可以作进一步的深入了解和研究。

在此特别膜拜一下国内在计算机图形方面的大牛团队，浙大鲍虎军、山大陈宝权、MSRA 团队以及国外亚琛工业大学 Prof. Dr. Leif Kobbelt 团队，相关图片均来自上述团队论文成果。

所以从层级上讲，网格划分是有限元开展的基础工作，而这些底层图形学算法又是网格划分的基础，也就是基础中的基础，咱们是用户层，人家是软件开发层，还是人家更厉害，不得不服。

## 1. 部分论文成果图

下面是一些看起来极度舒适的离散图片，对于强迫症患者而言更是有一种心灵上的解脱，一起观赏一下（由于作者水平和专业所限，尚无法为大家一一解读论文，感兴趣的可以自行检索，图文附引用）。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145902051-1488370826.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_0_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145902582-94200573.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_1_640.png -->

[1] Frame Field Generation through Metric Customization__. Tengfei Jiang, Xianzhong Fang, Jin Huang, Hujun Bao, Yiying Tong, Mathieu Desbrun ACM Transaction>

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145902975-1708077272.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_2_640.png -->

[2] Perceptually Guided Rendering of Texture Point-based Models__. Lijun Qu, Xiaoru Yuan, Minh X. Nguyen, Gary Meyer and Baoquan Chen In Proceeding of the 3rd IEEE/Eurographics Symposium>

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145903288-931180746.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_3_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145903508-681431739.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_4_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145903796-1122359100.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_5_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145904117-2040462702.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_6_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145904447-208794342.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_7_640.png -->

[3] All-Hex Meshing using Closed-Form Induced Polycube__. Xianzhong Fang, Weiwei Xu, Hujun Bao, Jin Huang，ACM Transactions>, 35(4), 2016.

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145904700-2083288331.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_8_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145904945-1089457300.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_9_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145905219-127655271.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_10_640.png -->

[4] Integrating Mesh and Meshfree Methods for Physics-Based Fracture and Debris Cloud Simulation__. Nan Zhang, Xiangmin Zhou, Desong Sha, Xiaoru Yuan, Kumar K. Tamma, and Baoquan Chen. In Proceeding of the 3rd IEEE/Eurographics Symposium>

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145905477-1828572293.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_11_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145905707-1259021205.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_12_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145905928-231608068.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_13_640.png -->

[5] A Convolutional Decoder for Point Clouds using Adaptive Instance Normalization__. Isaak Lim, Moritz Ibing, Leif Kobbelt.Eurographics Symposium>


![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145906137-1728726763.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_14_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145906447-1689440110.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_15_640.png -->

[6] All-Hex Meshing using Singularity-Restricted Field__. Yufei Li,Yang Liu,Weiwei Xu,Wenping Wang,Baining Guo. ACM Transactions>

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145906709-1252706173.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_16_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145906954-707835127.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_17_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145907215-706185047.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_18_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145907624-408388873.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_19_640.png -->

[7] Structured Volume Decomposition via Generalized Sweeping__.__Gao X__,_ _Martin T__,_ _Deng S__,_ _Cohen E__,_ _Deng Z__,_ _Chen G__.__IEEE Trans Vis Comput Graph._ _2016 Jul;22(7):1899-911. doi: 10.1109/TVCG.2015.2473835. Epub 2015 Aug 27.

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145907896-1337862932.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_20_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145908272-442404813.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_21_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145908571-31640825.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_22_640.png -->

[8] Surface Smoothing and Quality Improvement of Quadrilateral/Hexahedral Meshes with Geometric Flow__._ _Zhang Y__,_ _Bajaj C__,_ _Xu G__. Computational Visualization Center, Institute for Computational Engineering and Sciences, The University of Texas at Austin, USA. jessica@ices.utexas.edu.

## 2. 软件工具推荐

最后，推荐几个轻型的专用网格处理软件（非 HyperMesh、ANSA），如果自己研究底层程序编写或者自定义一些模型求解过程，可以作为网格生成工具使用。

### 2.1. MsehLab

MeshLab 是一个开源的处理三角形网格的 C++ 处理框架，提供了三角网格的数据结构和算法，诸如曲面重建、编辑、修复、光顺、编辑等算法。MeshLab 并没有集成太多独特的算法，但是作为一个三维网格数据的显示工具和框架已被学术界广泛使用，并作为科研的必备程序库之一。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145909052-1914006027.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_24_640.png -->

### 2.2. Libigl

Libigl 是由瑞士 Ethz 大学的 Olga Sorkine 研究小组开发的 C++ 网格处理库，使用说明文档比较齐全，很容易上手使用。它具有较好的构造稀疏离散微分算子和有限元稀疏方程组等功能。有很多研究人员对其有贡献，包括：Alec Jacobson, Daniele Panozzo, Christian Schüller, Olga Diamanti, Qingnan Zhou, Nico Pietroni, Stefan Bruggerr , Kenshi Takayama, Wenzel Jakob, Nikolas De Giorgis, Luigi Rocca, Leonardo Sacht, Olga Sorkine-Hornung。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145909440-1106883489.gif) <!-- simpread-这才是网格底层算法的无穷美学\25_640.gif -->

### 2.3. Trimmesh

Trimesh 是由美国 Princeton 大学的 Thomas Funkhouser 研究小组开发的 C++ 网格处理库。非常容易上手，使用不难，适合初学者。但是其中的相关算法实现比较少。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145909881-499059966.jpg) <!-- simpread-这才是网格底层算法的无穷美学\26_640.jpeg -->

### 2.4. OpenMesh/OpenFlipper

OpenMesh 是由德国 RWTH Aachen 大学的 Leif Kobbelt 研究小组开发的 C++ 网格处理库。OpenFlipper 是基于 OpenMesh 基础上架构的网格处理框架，使用非常广泛。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145910059-525349983.jpg) <!-- simpread-这才是网格底层算法的无穷美学\27_640.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145910333-710513313.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_28_640.png -->

### 2.5. TetGen

TetGen（A Quality Tetrahedral Mesh Generator and a 3D Delaunay Triangulator），是最有名的空间四面体网格生成库，由华人学者 Hang Si 博士所开发。该算法库获得 了 2012 年 SGP 会议的最佳开源软件奖。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145910593-721639782.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_29_640.png -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145910933-369503046.png) <!-- simpread-这才是网格底层算法的无穷美学\keepng_30_640.png -->

### 2.6. CGAL 

CGAL（Computational Geometry Algorithms Library），是一套开源的 C++ 算法库，提供了计算几何相关的数据结构和算法，诸如三角剖分（2D约束三角剖分及二维和三维 Delaunay 三角剖分），Voronoi 图（二维和三维的点，2D 加权 Voronoi 图，分割 Voronoi 图等），多边形，多面体（布尔运算），网格生成（二维 Delaunay 网格生成和三维表面和体积网格生成等），几何处理（表面网格简化，细分和参数化等），凸壳算法，搜索结构（近邻搜索，kd 树等），插值，形状分析，拟合等。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145911258-1896658277.jpg) <!-- simpread-这才是网格底层算法的无穷美学\31_640.jpeg -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145911526-169425393.jpg) <!-- simpread-这才是网格底层算法的无穷美学\32_640.jpeg -->

### 2.7. VEGA FEM

Vega is a computationally efficient and stable C/C++ physics library for three-dimensional deformable object simulation. It is designed to model large deformations, including geometric and material nonlinearities, and can also efficiently simulate linear systems. Vega contains about 145,000 lines of code, and is open-source and free. It is released under the 3-clause BSD license, which means that it can be used freely both in academic research and in commercial applications.

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145911742-1573256554.jpg) <!-- simpread-这才是网格底层算法的无穷美学\33_640.jpeg -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210108145912042-1502427437.jpg) <!-- simpread-这才是网格底层算法的无穷美学\34_640.jpeg -->

以上，是关于有限元程序开发以及使用过程中可能涉及的底层离散算法。这些算法充满艺术美学，让人眼前一亮，有门槛又非常脑洞有趣，希望对大家产生一些帮助，拓展一些技术边界。
