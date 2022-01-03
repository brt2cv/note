<!--
+++
title       = "源码编译OpenCV"
description = "1. 源码编译; 2. OpenCV-Python; 3. 编译cv代码"
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

## 1. 源码编译
> [官网: Install OpenCV-Python in Ubuntu](https://docs.opencv.org/master/d2/de6/tutorial_py_setup_in_ubuntu.html)

1. 下载源码

    下载opencv与opencv-contrib的源码包，注意版本对应

    ```sh
    opencv:https://github.com/opencv/opencv/releases
    opencv-contrib:https://github.com/opencv/opencv_contrib/releases
    ```

1. 安装依赖

    ```sh
    # to support gtk2:
    sudo apt-get install libgtk2.0-dev
    # to support gtk3:
    sudo apt-get install libgtk-3-dev
    ```

    可选依赖

    ```sh
    sudo apt-get install libpng-dev libjpeg-dev libtiff-dev libwebp-dev
    sudo apt-get install libopenexr-dev
    ```

1. 编译安装

    ```sh
    mkdir build && cd build && cmake ..  # 编译选项
    make -j4
    sudo make install
    ```

1. 验证

    ```sh
    pkg-config --modversion opencv4
    ```

### 1.1. Jetson编译最新版本
> [Install OpenCV 4.4.0 on Jetson Nano](https://qengineering.eu/install-opencv-4.4-on-jetson-nano.html)
>
> [csdn: Jetson带CUDA编译的opencv4.5安装教程与踩坑指南，cmake配置很重要！](https://blog.csdn.net/weixin_39298885/article/details/110851373)

由于Jetson自带的是4.1.1的老版本OpenCV（基于Ubuntu18.04），且apt包未提供CUDA支持。所以需要自己编译OpenCV，这里是基于4.5.1版本。

```sh
mv opencv_contrib opencv
cd opencv && madir build && cd build
```

cmake编译选项说明：

```sh
cmake -DCMAKE_BUILD_TYPE=RELEASE \    #表示编译发布版本
    -DCMAKE_INSTALL_PREFIX=/usr/local \    #指定安装路径
    -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
    -DCUDA_ARCH_BIN='7.2' \    #指定GPU算力，在NVIDIA官网查询，也可在jtop中查询
    -DWITH_CUDA=ON \    #使用CUDA
    -DWITH_V4L=ON \
    -DWITH_QT=ON \    #使用QT支持
    -DWITH_OPENGL=ON \
    -DENABLE_FAST_MATH=1 \
    -DCUDA_FAST_MATH=1 \
    -DWITH_CUBLAS=1 \
    -DOPENCV_GENERATE_PKGCONFIG=1 \    #用于生成opencv4.pc文件，支持pkg-config功能，没有这一项的话需要自己手动生成
    -DCUDA_GENERATION=Pascal \
    -DWITH_GTK_2_X=ON ..    #解决Gtk-ERROR的关键
```

关于 `CUDA_GENERATION` ，对于常见的几个嵌入式设备的CUDA架构如下:

+ Jetson Nano: Maxwell
+ Jetson TX2: Pascal
+ Xavier NX: Volta
+ AGX Xavier: Volta

> [github_issue](https://github.com/opencv/opencv_contrib/issues/2780)
>
> cmake配置中 `-D ENABLE_FAST_MATH=1` 会导致莫名的错误，建议去掉；
>
> `-D CUDA_GENERATION=Pascal` 对于 `-D CUDA_ARCH_BIN='7.2'` 来说是多余的，建议去掉；
>
> `make -j6` 多核编译会出现莫名的错误，建议单核编译 `make VERBOSE=1` 。

以下参数是针对jetson的优化

```sh
$ cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
        -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
        -D WITH_CUDA=ON \
        -D CUDA_ARCH_BIN=5.3 \
        -D CUDA_ARCH_PTX="" \
        -D WITH_CUDNN=ON \
        -D WITH_CUBLAS=ON \
        -D ENABLE_FAST_MATH=OFF \
        -D CUDA_FAST_MATH=ON \
        -D OPENCV_DNN_CUDA=ON \
        -D ENABLE_NEON=ON \
        -D WITH_QT=OFF \
        -D WITH_OPENMP=ON \
        -D WITH_OPENGL=ON \
        -D BUILD_TIFF=ON \
        -D WITH_FFMPEG=ON \
        -D WITH_GSTREAMER=ON \
        # -D WITH_TBB=ON \
        # -D BUILD_TBB=ON \
        -D BUILD_TESTS=OFF \
        -D WITH_EIGEN=ON \
        -D WITH_V4L=ON \
        -D WITH_LIBV4L=ON \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D BUILD_EXAMPLES=ON \
        -D INSTALL_C_EXAMPLES=ON \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
        -D BUILD_NEW_PYTHON_SUPPORT=ON \
        -D BUILD_opencv_python3=TRUE \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D WITH_GTK_2_X=ON ..
```

编译时，注意添加 `-j4` 可以有效提升编译速度。

```sh
sudo make install -j4
```

额，经过测试，多核编译确实可以提速编译，但最后会莫名的卡死在100%的状态下，`ps` 的状态标识为 `D` 。此时重新编译，<font color=#FF0000>去除多核编译选项，即可完成编译</font>。

![](https://img2020.cnblogs.com/blog/2039866/202102/2039866-20210226174420879-492919001.jpg) <!-- opencv/opencv-0.jpg -->

### 1.2. 编译报错

#### 1.2.1. xfeatures2d缺少boostdesc_lbgm.i等文件

cmake会自动下载配置文件，但由于网络问题，导致数据下载失败。

```
.cache
└───xfeatures2d
    ├───boostdesc
    │       0ae0675534aa318d9668f2a179c2a052-boostdesc_lbgm.i
    │       0ea90e7a8f3f7876d450e4149c97c74f-boostdesc_bgm.i
    │       202e1b3e9fec871b04da31f7f016679f-boostdesc_binboost_064.i
    │       232c966b13651bd0e46a1497b0852191-boostdesc_bgm_bi.i
    │       324426a24fa56ad9c5b8e3e0b3e5303e-boostdesc_bgm_hd.i
    │       98ea99d399965c03d555cef3ea502a0b-boostdesc_binboost_128.i
    │       e6dcfa9f647779eb1ce446a8d759b6ea-boostdesc_binboost_256.i
    └───vgg
            151805e03568c9f490a5e3a872777b75-vgg_generated_120.i
            7126a5d9a8884ebca5aea5d63d677225-vgg_generated_64.i
            7cd47228edec52b6d82f46511af325c5-vgg_generated_80.i
            e8d0dcd54d1bcfdc29203d011a797179-vgg_generated_48.i
```

可以从以下地址: [github: opencv_contrib_files](https://github.com/opencv/opencv_contrib/files/4520852/patch__.zip) 下载，并解压到 `build/.cache/xfeatures2d/` 代替原有的boostdesc和vgg两个文件夹。

#### 1.2.2. face_landmark_model.dat等文件缺失
> [csdn: 一次性解决opencv源码安装文件下载问题：ippicv_2017u3_lnx, face_landmark_model.dat, tiny-dnn](https://blog.csdn.net/qq_39936818/article/details/104951448)

1.  face_landmark_model.dat

    下载地址：[github: opencv_3rdparty-face_landmark_model.dat](https://github.com/opencv/opencv_3rdparty/tree/contrib_face_alignment_20170818/face_landmark_model.dat)

    gitee备份: [gitee: opencv_3rdparty-face_landmark_model.dat](https://gitee.com/higger/opencv_3rdparty/blob/contrib_face_alignment_20170818/face_landmark_model.dat)

    配置： `opencv_contrib/modules/face/CMakeLists.txt` ，第19行，把网址改成下载路径 `"file://${path_dir}"` （注意，不用指定文件，dir即可）。

1. ippicv_2017u3_lnx_intel64_general_20170822.tgz

    下载地址：[github: opencv_3rdparty-ippcv](https://github.com/opencv/opencv_3rdparty/tree/ippicv/master_20191018/ippicv)

    另提供gitee的备份: [gitee: opencv_3rdparty-ippcv]()

    配置：打开 `opencv/3rdparty/ippicv/ippicv.cmake` ，第47行 `"https://raw.githubusercontent.com/opencv/opencv_3rdparty/${IPPICV_COMMIT}/ippicv/"` ，改成：`"file://${path}"`

2. tiny-dnn-1.0.0a3.tar.gz

    下载地址：[github: opencv_3rdparty-tinydnn](https://github.com/tiny-dnn/tiny-dnn/releases)

    gitee备份: [gitee: opencv_3rdparty-tinydnn]()

    配置：`${opencv_contrib_folder}/modules/dnn_modern/CMakeLists.txt` ，第23行，修改方法和前面一样

### 1.3. 编译opencv-python

安装依赖：

```sh
sudo apt-get install python3-dev python3-numpy
```

You should see these lines in your CMake output (they mean that Python is properly found):

```
--   Python 2:
--     Interpreter:                 /usr/bin/python2.7 (ver 2.7.6)
--     Libraries:                   /usr/lib/x86_64-linux-gnu/libpython2.7.so (ver 2.7.6)
--     numpy:                       /usr/lib/python2.7/dist-packages/numpy/core/include (ver 1.8.2)
--     packages path:               lib/python2.7/dist-packages
--
--   Python 3:
--     Interpreter:                 /usr/bin/python3.4 (ver 3.4.3)
--     Libraries:                   /usr/lib/x86_64-linux-gnu/libpython3.4m.so (ver 3.4.3)
--     numpy:                       /usr/lib/python3/dist-packages/numpy/core/include (ver 1.8.2)
--     packages path:               lib/python3.4/dist-packages

--   Python (for build):            /usr/bin/python2.7
```

能够正常找到python环境，但默认选择了 `python2.7` 匹配？解决方法如下：

`PYTHON_DEFAULT_EXECUTABLE=$(which python3)` 决定了生成 `cv2.so` 对应的python版本。如果你需要自定义numpy和site_package（例如venv环境下的依赖包），可以使用以下选项

```
-D INSTALL_PYTHON_EXAMPLES=ON \
-D PYTHON_EXECUTABLE=/home/user/anaconda3/bin/python3.7m \
-D PYTHON_INCLUDE_DIR=/home/user/anaconda3/include/python3.7m \
-D PYTHON_LIBRARY=/home/user/anaconda3/lib/libpython3.7m.so \
-D PYTHON_PACKAGES_PATH=/home/user/anaconda3/lib/python3.7/site-packes
-D PYTHON_NUMPY_INCLUDE_DIR=/home/user/anaconda3/lib/site-packages/numpy/core/include \
-D PYTHON3_PACKAGES_PATH=/home/user/anaconda3/lib/python3.7/site-packages
```

注意：如果编译时使用了编译选项 `-D BUILD_opencv_world=NO` 那么完成后在 `build/lib` 文件夹下也找不到cv2.so的。

测试

```sh
python3 -c "import cv2; print(cv2.__version__)"
```

## 2. OpenCV-Python

### 2.1. 使用CUDA加速dnn
> [csdn: opencv-python dnn模块使用CUDA加速](https://blog.csdn.net/qq_43019451/article/details/105894552)
>
> [How to use OpenCV’s “dnn” module with NVIDIA GPUs, CUDA, and cuDNN](https://www.pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/)

```py
net = cv2.dnn.readNetFromDarknet(configPath, weightsPath)
net.setPreferableBackend(cv2.dnn.DNN_BACKEND_CUDA)
net.setPreferableTarget(cv2.dnn.DNN_TARGET_CUDA)
```

## 3. 编译cv代码

```sh
g++ main.cpp `pkg-config opencv4 --cflags --libs`
```
