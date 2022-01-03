<!--
+++
title       = "Meshlab使用教程"
description = "1. NAVIGATION IN MeshLAB; 2. EDITING POINT CLOUDS; 3. ALIGNING POINT CLOUDS; 4. MESH CREATION AND EDITING"
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

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200441194-1164094484.jpg) <!-- meshlab/meshlab-0.jpg -->

> [Tutorial PDF: 基本使用](http://www.heritagedoc.pt/doc/Meshlab_Tutorial_iitd.pdf)
>
> [Tutorial PDF2: 概念和高级功能](http://www.banterle.com/francesco/courses/2017/be_3drec/slides/Meshlab.pdf)
>
> [csdn: Meshlab基本的edit工具学习](https://blog.csdn.net/qq_15262755/article/details/80352867)
>
> [gitee: 点云入门手册Tutorial_No.2_点云软件](https://gitee.com/tophats/point-cloud-tutorial/blob/main/Chapter2/Chapter2_zh/%E7%AC%AC%E4%BA%8C%E7%AB%A0%20%E7%82%B9%E4%BA%91%E8%BD%AF%E4%BB%B6.md#2-2-meshlab)
>
> [优酷: Mister P.'s MeshLab Tutorials](http://i.youku.com/i/UMTM5Mzk5MTA2OA==/videos?spm=a2hzp.8244740.0.0)
>
> [YouTube: Mister P.'s MeshLab Tutorials](https://www.youtube.com/user/MrPMeshLabTutorials)

## 1. NAVIGATION IN MeshLAB

+ Left mouse button + drag: rotate around trackball center
+ Mouse wheel: move forward or backward
+ Center mouse button + drag: pan
+ Shift + mouse wheel: change camera field of view5.
+ Double click on specific point: places that point at the trackball center
+ Control + mouse wheel: moves near clipping plan
+ Control + Shift + mouse wheel: moves far clipping plan
+ Alt + Enter: enter full screen mode
+ Control + Shift + left mouse button + drag: changes light direction （this only takes effect if there are normals）

## 2. EDITING POINT CLOUDS

### 2.1. Selecting and deleting points

操作：

+ Edit -> Select Vertices
+ Filter -> Selection -> Delete Selected Vertices

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200441554-1252394016.jpg) <!-- meshlab/meshlab-2.jpg -->

+ ctrl: 用于连续选择
+ shift: 从选中区域排除
+ ctrl+del: 用于移除选择到的顶点

### 2.2. 拓扑和几何信息的读取

Mesh 文件的拓扑信息对于点云的三角化非常重要，因为三角化（第四章会介绍）需要点云之间的拓扑信息才能形成空间结构。

Mesh 文件的几何信息对于我们了解该文件的几何结构来说非常重要。

操作：

+ Filter -> Quality Measure and Computations -> Compute Topological Measures
+ Filter -> Quality Measure and Computations -> Compute Geometric Measures

具体拓扑信息如下：

```
V: 1257 E: 4095 F: 2730
Unreferenced Vertices 0
Boundary Edges 0
Mesh is composed by 1 connected component(s)
Mesh is two-manifold
Mesh has 0 holes
Genus is 55
Applied filter Compute Topological Measures in 58 msec
```

全部几何信息列举如下：

```
Mesh Bounding Box Size 0.210970 0.144833 0.092823
Mesh Bounding Box Diag 0.272215
Mesh Bounding Box min -0.110993 0.052525 -0.050413
Mesh Bounding Box max 0.099977 0.197358 0.042410
Mesh Surface Area is 0.076983
Mesh Total Len of 4095 Edges is 37.782368 Avg Len 0.009226
Mesh Total Len of 4095 Edges is 37.782368 Avg Len 0.009226 (including faux edges))
Thin shell (faces) barycenter: -0.010309 0.108503 -0.008092
Vertices barycenter -0.010662 0.109044 -0.006433
Mesh Volume is 0.000478
Center of Mass is -0.011976 0.103019 -0.009221
Inertia Tensor is :
| 0.000001 0.000000 0.000000 |
| 0.000000 0.000001 0.000000 |
| 0.000000 0.000000 0.000002 |
Principal axes are :
| 0.979431 -0.201732 -0.004342 |
| 0.198852 0.968651 -0.148907 |
| -0.034245 -0.144981 -0.988842 |
axis momenta are :
| 0.000001 0.000001 0.000002 |
Applied filter Compute Geometric Measures in 84 msec
```

### 2.3. Scaling， Moving and Rotation

操作：

+ Filter -> Normals, Curvatures and Orientation -> Transform: Scale, Normalize
+ Filter -> Normals, Curvatures and Orientation -> Transform: Translate, Center, set Origin
+ Filter -> Normals, Curvatures and Orientation -> Transform: Rotate

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200442442-1483555484.jpg) <!-- meshlab/meshlab-6.jpg -->

注意，缩放选项中 "Freeze matrix" 项，勾选则为正常缩放，而如果未勾选，则是将坐标系一同缩放，虽然图像显示被拉伸了，但每个点的坐标实际上没有变化。

### 2.4. Computing normals for point sets

法线是点云每个点的重要信息，如果没有法线信息，就无法计算 mesh。计算 mesh 这个过程也可以理解为点云重建，即将点云从点（low-level）变成了高级一些的 mesh 网状结构（higher-level）；当然我们还可以将 mesh 继续变得更高级，比如用一个面去拟合一片 mesh —— 这里我们不深入讨论这个问题。总之，需要先计算 normal 才能得到 mesh。

操作：

+ Filters -> Normals, Curvatures and Orientation -> Compute normals for point sets

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200441761-578344051.jpg) <!-- meshlab/meshlab-4.jpg -->

+ Neighbour num 表示计算法线时每个点的邻域包括点的个数，根据邻域才可以计算法线。

*注意：可以使用灯光调整对模型的观察。*

如需在模型中保存Normals数据，要记得勾选：

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200441993-79077599.jpg) <!-- meshlab/meshlab-5.jpg -->

### 2.5. Clean up the mesh

+ Filters → Cleaning and Repairing → Remove Isolated (wrt Diameter)

    Adjust the max diameter percentage until artifacts are removed.

    Clean any undesired artifacts smaller than the desired final mesh.

+ Filters → Remeshing, Simplification and Reconstruction → Simplification: Quadric Edge Collapse Decimation

    Reduce the vertex count of the mesh for reduced file size.

    Adjust the  Percentage reduction  parameter to simplify the mesh. Because this is a percentage, it’s helpful to begin with a larger value to be preserved (e.g. 0.8) and work down from there. The current vertex count can be viewed in the bottom right (purple window).

    Click  Apply  to simplify the mesh accordingly.

### 2.6. Down-sampling point clouds

操作：

+ Filter -> Sampling -> Poisson-disk Sampling

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200442236-328577003.jpg) <!-- meshlab/meshlab-1.jpg -->

重新采样后，生成新的cloud_points，但不再包含拓扑信息和法线。

### 2.7. mesh化点云

操作：

+ Filter -> Remeshing, Simplification and Reconstruction -> Surface Reconstruction: Ball Pivoting

## 3. ALIGNING POINT CLOUDS

关于3D图像的拼接，可以使用 *Align* 工具进行拼接。首先在项目中导入多个模型（各自有自己的坐标系，所以图像很可能会有重叠）。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200442670-1838491254.jpg) <!-- meshlab/meshlab-7.jpg -->

将项目保存为 MLP 或 ALN 格式。项目文件可以看到，记录着每个模型的坐标系。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200442882-189451392.jpg) <!-- meshlab/meshlab-8.jpg -->

选择基准对象，然后选择 `GLUE HERE MESH` 按钮。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200443133-954732003.jpg) <!-- meshlab/meshlab-9.jpg -->

选择另一个模型，然后点选 `POINT BASED GLUEING` 。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200443349-716768530.jpg) <!-- meshlab/meshlab-11.jpg -->

通过双击两个模型的同一位置，人工手动标定（对齐）两个坐标系。

> Points are picked by double clicking with the left mouse button. They can be all selected in one point cloud and then all selected in the other point cloud （by the same order）， or we can select one point at each time on both point clouds. To remove a point do `CTRL + double click`  with left mouse button. After the points are picked， click OK. You can change the view point whilst selecting the points.

最后设置 `ICP` (Iterative Closest Point). Pay attention to the `Defaults ICP Parameters`, They are set in absolute units.

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200443560-434761025.jpg) <!-- meshlab/meshlab-10.jpg -->

注意：如果我们的两块点云大小相同，那么就要勾选 `Rigid matching` 选型。如果我们不勾选，那最终的变换矩阵中将会有一个缩放因子。

+ 采样点数目（Sample Number）：this is the number of samples it pulls from each mesh to compare to the other meshes. You do not want to make this number too big. A small sample typically works quiet well. 1,000 to 5,000 is usually plenty.

+ Minimal starting distance：this ignores any samples that are outside of this range. Typically for a manually aligned object you want this to be large enough to encompass your 'point picking' error. A value of 5 or 10 (in millimeters) is usually a good start. Once the initial alignements are complete, drop it down to 1mm to 'fine tune'

+ Target distance（相当于均方误差mse）：an average alignment error value that the software will try to obtain from the process

+ 最大迭代次数（Max iteration number）：the maximum number of iterations that the software will perform

+ Rigid matching：如果我们的两块点云标尺比例相同，需要勾选（默认），否则最终的变换矩阵中将会有一个缩放因子。

最后单击 "Process" 执行合并操作：

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200443806-1279804647.jpg) <!-- meshlab/meshlab-13.jpg -->

可以发现，坐标系姿态已经改变。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200444035-1846632218.jpg) <!-- meshlab/meshlab-14.jpg -->

## 4. MESH CREATION AND EDITING

### 4.1. Merging point clouds

打开 Layer dialog 选择导入模型在选择 `Flatten visible layers` . 在弹出的dialog中根据你的需要选择，此处为点云选择Keep unreferenced points，然后apply。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200444232-1091810904.jpg) <!-- meshlab/meshlab-16.jpg -->

### 4.2. Mesh creation

操作：

+ Filter -> Remashing, Simplification and Reconstruction -> Surface Reconstruction: Poisson

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200444451-587465800.jpg) <!-- meshlab/meshlab-3.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200444732-1106516952.jpg) <!-- meshlab/meshlab-15.jpg -->

### 4.3. Transferring color from point cloud to mesh

操作：

+ Filter -> Sampling -> Vertex Attribute Transfer

注意，需要勾选 `Transfer color` 。

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210113200444959-1732130929.jpg) <!-- meshlab/meshlab-17.jpg -->

### 4.4. Mesh editing

在生成mesh时，会产生一些多余的三角面片。去除这些多余面片的一个有效的方法，就是

操作：

+ Filter -> Selections -> Selsect Faces with edges longer than...

![](https://img2020.cnblogs.com/blog/2039866/202101/2039866-20210115181657041-1518027279.jpg) <!-- meshlab/meshlab-12.jpg -->
