<!--
+++
title       = "【转载】机器视觉行业初印象（市场分析）"
description = "1. 什么是机器视觉; 2. 认识机器视觉; 3. 行业细分; 4. 应用案例; 5. 千亿蓝海大有可为"
date        = "2022-01-03"
tags        = []
categories  = ["8-business","83-行业分析"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200903160033615-705856550.jpg) <!-- 中国机器视觉产业全景图谱/中国机器视觉产业全景图谱-0.jpg -->

> [《打开“视”界之门,挖掘机器视觉蓝海》](http://pdf.dfcfw.com/pdf/H3_AP202006241387045794_1.PDF)

## 1. 什么是机器视觉

机器视觉通过模拟人类视觉系统，赋予机器“看”和“认知”的能力，是机器认识世界的基础。机器视觉利用成像系统代替视觉器官作为输入手段，利用视觉控制系统代替大脑皮层和大脑的剩余部分完成对视觉图像的处理和解释，让机器自动完成对外部世界的视觉信息的探测，做出相应判断并采取行动，实现更复杂的指挥决策和自主行动。作为人工智能最前沿的领域之一，视觉类技术是人工智能企业的布局重点，具有最大的技术分布。

### 1.1. 机器视觉是人工智能重要的前沿技术

人工智能基础构架，如下图：

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174952452-205394144.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-0.jpg -->

国内外人工智能企业应用技术分布：

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174952819-968601835.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-2.jpg -->

### 1.2. 机器视觉能做什么

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174953164-1356167290.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-1.jpg -->

+ 识别（填空题，描述看到的是什么）

    识别功能指甄别目标物体的物理特征，包括：

    + 外形
    + 颜色
    + 字符识别（OCR、OVR）
    + 条码

    其**准确度**和**识别速度**是衡量的重要指标

+ 检测（判断题）

    + 判断有无
    + 外观验伤
        - 外观是否存在缺陷
        - 产品装配是否完整

+ 定位

    获取目标物体的**坐标**和**角度**信息，自动判断物体位置

+ 测量

    把获取的图像像素信息标定成常用的度量衡单位，然后在图像中精确地计算出目标物体的几何尺寸，主要应用于高精度及复杂形态测量。

    + 2D测量
    + 3D测量

### 1.3. 机器视觉的优势（为什么用机器视觉，不仅仅是替代人工哦）

<font color=#FF0000>相对于人类视觉而言，机器视觉在量化程度、灰度分辨力、空间分辨力和观测速度等方面存在显著优势。</font>其利用相机、镜头、光源和光源控制系统采集目标物体数据，借助视觉控制系统、智能视觉软件和数据算法库进行图形分析和处理，软硬系统相辅相成，为下游自动化、智能化制造行业赋予视觉能力。随着深度学习、3D 视觉技术、高精度成像技术和机器视觉互联互通技术的发展，机器视觉性能优势进一步提升，应用领域也向多个维度延伸。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174953468-1827578641.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-4.jpg -->

| 性能指标 | 人类视觉 | 机器视觉 |
| -- | -- | -- |
| 适应能力 | 适应性强(复杂、变化的环境中可识别目标) | 适应性强(对环境要求不高,可添加防护装置) |
| 智能程度 | 高级智能(逻辑推理识别变化的目标,并总结规律) | 差(不能很好识别变化的目标) |
| 颜色分辨力 | 强(可以分辨出约 1000万 种不同的颜色) | 差(受硬件条件约束) |
| 量化程度 | 难以量化(极易受人的心理影响) | 可量化 |
| 灰度分辨力 | 差(一般只能分辨 64 个灰度级) | 强(一般可使用 256 个灰度级,采集系统具有 10bit、12bit、16bit 等灰度) |
| 空间分辨力 | 差(不能识别微小的目标) | 强(可识别小到微米大到天体的目标) |
| 观测速度 | 慢(0.1秒的视觉暂留无法看清快速运动的目标) | 快(可达到 10 微秒左右) |

## 2. 认识机器视觉

### 2.1. 定义

机器视觉（Machine Vision）是指通过光学装置和非接触传感器自动接收并处理真实物体的图像，分析后获取所需信息或用于控制机器运动的装置。通俗地说，机器视觉就是用机器代替人眼。机器视觉模拟眼睛进行图像采集，经过图像识别和处理提取信息，最终通过执行装置完成操作。

### 2.2. 视觉系统基本架构

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174953708-1933123130.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-3.jpg -->

按照信号的流动顺序，机器视觉系统主要包括：

+ 光学成像

    光学成像模块设计合理的光源和光路，通过镜头将物方空间信息投影到像方，从而获取目标物体的物理信息；

+ 图像传感器

    图像传感器模块负责信息的光电信号转换，目前主流的图像传感器分为 CCD 与 CMOS 两类；

+ 图像处理

    图像处理模块基于以 CPU 为中心的电路系统或信息处理芯片，搭配完整的图像处理方案和数据算法库，提取信息的关键参数；

+ IO & 显示

    IO 模块输出机器视觉系统的结果和数据；

    显示模块方便用户直观监测系统的运行过程，实现图像的可视化。

### 2.3. 发展历程

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174953956-53214893.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-5.jpg -->

机器视觉起源于上世纪 50 年代，Gilson 提出了“光流”这一概念，并基于相关统计模型发展了逐像素的计算模式，标志着 2D 影像统计模式的发展。

1960 年，美国学者 Roberts 提出了从 2D 图像中提取三维结构的观点，引发了MIT 人工智能实验室及其它机构对机器视觉的关注，并标志着三维机器视觉研究的开始。

70 年代中期，MIT 人工智能实验室正式开设“机器视觉”课程，研究人员开始大力进行“物体与视觉”相关课题的研究。1978 年，David Marr 开创了“自下而上”的通过计算机视觉捕捉物体形象的方法，该方法以 2D 的轮廓素描为起点，逐步完成 3D 形象的捕捉，这一方法的提出标志着机器视觉研究的重大突破。

80 年代开始，机器视觉掀起了全球性的研究热潮，方法理论迭代更新，OCR 和智能摄像头等均在这一阶段问世，并逐步引发了机器视觉相关技术更为广泛的传播与应用。

90 年代初，视觉公司成立，并开发出第一代图像处理产品。而后，**机器视觉相关技术被不断地投入到生产制造过程中，使得机器视觉领域迅速扩张，上百家企业开始大量销售机器视觉系统，完整的机器视觉产业逐渐形成。**在这一阶段，LED 灯、传感器及控制结构等的迅速发展，进一步加速了机器视觉行业的进步，并使得行业的生产成本逐步降低。

2000 年至今，更高速的 3D 视觉扫描系统和热影象系统等逐步问世，机器视觉的软硬件产品蔓延至生产制造的各个阶段，应用领域也不断扩大。当下，机器视觉作为人工智能的底层产业及电子、汽车等行业的上游行业，仍处于高速发展的阶段，具有良好的发展前景。

### 2.4. 国内市场爆发式增长

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174954176-229846579.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-6.jpg -->

国内机器视觉起步晚，主要经历了三个阶段（目前处于快速成长期）：

1. 1999-2003: 学着用

    这一阶段的中国企业主要通过代理业务对客户进行服务，在服务的过程中引导客户对机器视觉的理解和认知，借此开启了中国机器视觉的历史进程。同时，国内涌现出的跨专业机器视觉人才也逐步掌握了国外简单的机器视觉软硬件产品，并搭建起了机器视觉初级应用系统。在这一阶段，**诸如特种印刷行业、烟叶异物剔除行业等率先引入了机器视觉技术**，在解放劳动力的同时有效推动了国内机器视觉领域的发展。

2. 2004-2007: 集成与二次开发

    这一阶段本土机器视觉企业开始起步探索由更多自主核心技术承载的机器视觉软硬件器件的研发，多个应用领域取得了关键性的突破。国内厂商陆续推出的全系列模拟接口和 USB2.0 的相机和采集卡，以及 **PCB 检测设备、SMT 检测设备、LCD 前道检测设备**等，逐渐开始占据入门级市场。

3. 2008年以后: 自主研发

    在这一阶段众多机器视觉核心器件研发厂商不断涌现，一大批**真正的系统级工程师**被不断培养出来，推动了国内机器视觉行业的高速、高质量发展。

随着全球制造中心向我国转移，目前中国已是继美国、日本之后的第三大机器视觉领域应用市场。据中国视觉产业联盟，2018 年我国机器视觉行业销售额达到83 亿元，较 2013 年翻了 3 倍，年复合增长率达 33.54%。

### 2.5. 核心部件国产化进行时

机器视觉虽只几十年发展时间，但随着全球新一轮科技革命与产业变革浪潮的兴起，机器视觉行业顺势迎来快速发展。机器视觉的应用已经从最初的汽车制造领域，扩展至如今消费电子、制药、食品包装等多个领域实现广泛应用。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174954411-1424959316.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-7.jpg -->

据前瞻产业研究院，全球机器视觉市场规模从 2008 年的 25 亿美元增长至 2017年 70 亿美元，年复合增速为 12.3%。我国机器视觉市场从 2008 年进入快速发展阶段，至 2017 年市场规模达 65 亿元，2008-2017 年复合增速 32.7%，显著高于全球水平。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174954656-1782495549.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-8.jpg -->

国内机器视觉企业以产品代理商与系统集成商为主，在机器视觉产业链上游领域布局较少，在机器视觉核心零部件的研发能力上不及国外老牌公司雄厚，因此中高端市场主要由国际一线品牌主导。

**国际机器视觉市场的高端市场主要被美、德、日品牌占据。**美国康耐视（Cognex）、国家仪器（NI），德国巴斯勒（Basler）、伊斯拉视像（ISRA Vision），日本基恩士（Keyence）、欧姆龙（Omron）等都是在机器视觉领域拥有技术积累和良好客户口碑的国际巨头公司。其中**康耐视**和**基恩士**作为全球机器视觉行业的两大巨头，垄断了近 50% 的全球市场份额。

## 3. 行业细分

### 3.1. 工业相机

图像分析的前提是由镜头捕捉光信号并转变为有序的电信号。区别于民用相机，工业相机具有更高的图像稳定性、传输能力和抗干扰能力，是机器视觉系统的关键组件。目前市面上的工业相机产品主要有线阵相机、面阵相机、3D相机和智能相机等。智能相机将图像的采集、处理与通信功能集成于单一相机内，已成为工业相机发展的趋势。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174954866-2022212717.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-10.jpg -->

#### 3.1.1. 工业相机主要分类

+ 面阵相机

    以“面”为单位来进行图像采集，面阵相机的传感器拥有更多的感光像素，以矩阵排列。可以一次性获取完整的目标图像，**比线阵相机具有更快的检测速度**。大多数常见的检测相机都基于面阵扫描，包括测量面积、形状、尺寸、位置，甚至温度。

+ 线阵相机

    被测视野呈“线”状，它的传感器通常只有一行感光元素，以“线”扫描的方式连续拍照，再合成一张巨大的二维图像。在高频扫描和高分辨率的场合具有特定的优势，适用于检测超长目标物以及处于连续运动状态的产品。

+ 3D 相机

    3D 图像处理尤其适用于需要测量被分析物体的体积、形状或 3D 位置的应用情景。主流的 3D 相机根据测量原理的不同分为**飞行时间法、结构光法、双目立体视觉法**三种方案，在检测距离、精度、检测速度上各有优缺点，适用于不同的应用场景。

+ 智能相机

    **是软件和硬件高度结合的嵌入式系统**，不但能够完成普通工业相机的图像采集任务，还可以直接运行图像处理软件完成对图像的分析和处理，并完成与其它外部设备的直接互联和通信。具有集成度高、运行稳定可靠、维护方便简单、运行和构建成本低廉等优点。

#### 3.1.2. 图像传感器类型

CCD 图像传感器是一个由光电二极管和存储区构成的矩阵，每一个感光元件在将光线转化为电荷后，直接输出到下一个感光元件的存储单元，依此类推到最后一个感光元件形成统一的输出，再由放大器放大电信号以及专门的模数转换芯片将模拟信号转换为数字信号。而 CMOS 传感器中每一个感光元件都直接整合了放大器和模数转换逻辑（ADC），当感光二极管接受光照、产生模拟的电信号之后，电信号首先被该感光元件中的放大器放大，然后直接转换成对应的数字信号。

CMOS 传感器在应用于机器视觉初期，由于在处理快速变化的影像时，容易因电流变化过于频繁而产生过热现象，使得**噪声难以抑制**，因此仅应用在影像画质要求较低的中低端工业产品；而 CCD 由于图像质量更高、抗噪能力更强的优势多应用于高端场合。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174955066-906864232.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-9.jpg -->

随着 CMOS 传感器在消费电子设备上的大量应用推动了 CMOS 技术的发展，其性能已显著提高，而制造成本大幅下降。<font color=#FF0000>CMOS 传感器的分辨率和图像质量正在逼近 CCD 传感器，并且凭借高速度（帧速率）、高分辨率（像素数）、低功耗以及最新改良的噪声指数、量子效率及色彩观念等各方面优势</font>，CMOS 传感器建立了稳固的市场地位，在工业图像处理的众多领域正逐步取代 CCD 传感器。

以 Basler 的工业相机产品为例，在分辨率相近的情况下，CMOS 的帧速率比 CCD 显著更高，并且具有更高的量子效率、信噪比、动态范围以及更低的暗噪声。可见，CMOS 在某些性能指标上已达到或者优于 CCD 水准，具备替代 CCD 的能力。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174955303-94972619.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-11.jpg -->

#### 3.1.3. 市场动态

近些年工业相机行业在全球市场和中国市场均呈现快速增长趋势。全球工业相机行业规模由2011年 15.2 亿元增长至2018年的 40.3 亿元，年均复合增速为14.95%；中国工业相机行业规模2011年仅有 0.8 亿元，2018年达 7.3 亿元，实现了 37.14% 的复合增长率。中国工业相机市场正以远超全球市场的增速迅速扩张。

目前，全球工业相机行业由欧美品牌占据主要市场。据前瞻产业研究院，2018年北美品牌占据全球工业相机市场 62% 的份额，欧洲品牌占 15% ，国外知名企业如德国 Basler、加拿大 DALSA、美国康耐视等。从细分领域来看，工业智能相机市场相较于板卡式相机市场呈现更高的集中度。

我国对于工业相机的研究起步较晚，最初主要由大恒图像等几家老牌相机公司代理国外品牌。近些年我国也逐步发展出一批自主研发工业相机的国产品牌，如大恒图像、海康机器人、华睿科技和维视图像等。目前我国工业相机行业主要布局于中低端市场，可逐步实现进口替代；而在高分辨率、高速的高端工业相机领域仍以进口品牌为主。根据中国海关总署数据，2018 年我国工业相机进口数量为 8159 台，进口金额为 4483 万美元，同比增长 8.3%。

#### 3.1.4. 国内外工业相机参与厂商

+ Basler

    Basler是世界领先的工业相机和高质量数字相机的开发商和制造商，提供多种面阵相机和线阵相机产品线，包括具有 CMOS 和 CCD 芯片的工业相机，用于工厂自动化、医疗和生命科学、智能交通以及众多其他市场。

+ DALSA

    DALSA（加拿大）是世界上一流的高性能数字成像设备和半导体产品制造商，凭借其高端 CCD和 CMOS 芯片研发生产能力，可以为用户提供线阵、面阵、TDI 等各种类型的工业数字相机。

+ Baumer

    Baumer（瑞士）长期以来以生产高质量传感器著称，为国际工厂及过程自动化行业应用提供创新性的高质量传感器产品，具有精确性、可靠性、坚固性和紧凑设计等特性。

+ Cognex

    Cognex为制造自动化领域提供视觉系统、视觉软件、视觉传感器和表面检测系统，是全球领先的提供商，其生产的工业智能相机在全球市占率排名第一。

+ 大恒图像（北京）

    大恒图像成立于 1991 年，是中科院下属上市公司大恒科技的全资子公司。拥有超过二十年的图像采集硬件研发和生产经验，旗下的 CCD/CMOS 工业数字相机产品线覆盖多种接口及分辨率。

+ 海康机器人（浙江杭州）

    海康威视子公司，开辟机器视觉、行业无人机、移动机器人三大领域。机器视觉业务形成了涵盖全系列工业相机、智能相机、智能读码器、立体相机、视觉控制器、算法平台、镜头及相关配件的产品布局，产品广泛应用于3C、电子半导体、物流等工业自动化各领域。

+ 华睿科技（浙江绍兴）

    国内安防龙头大华股份旗下机器视觉子公司。工业相机产品线齐全，包括面阵工业相机、线阵工业相机、单板工业相机、智能工业相机、3D工业相机等，公司产品已广泛应用于SMT、物流、铁路、安检、3C、半导体、生物医疗等相关行业。

### 3.2. 镜头

镜头是机器视觉图像采集部分重要的成像部件，镜头的主要作用是将目标成像在图像传感器的光敏面上，分辨率、对比度、景深以及像差等指标对成像质量具有关键性影响。

工业镜头按焦距可分为**定焦镜头和变焦镜头**；根据光圈可分为固定光圈和可变光圈；根据视场大小可分为**摄远镜头、普通镜头和广角镜头**。此外，还有几种具有特殊用途的镜头，如**远心镜头、显微镜头、微距镜头、紫外镜头和红外镜头**等。

由于传统镜头存在视差现象（即镜头的放大倍数随物距的变化而变化），且通常有高于 1~2% 的畸变，远心镜头应用而生。它可以在一定物距范围内纠正视差的影响，并将畸变系数严格控制在 0.1% 以下。远心镜头由于其特有的平行光路设计一直为对镜头畸变要求很高的机器视觉应用场合所青睐，适应精密检测需求。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174955521-444460923.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-12.jpg -->

据 QYResearch，2019 年全球工业镜头市场总值达到 33 亿元，预计 2026 年将增至 58 亿元，年均复合增长率为 8.3%。海外品牌在镜头领域投入较早，经过多年的业务积累与技术升级，在全球范围内形成了德系徕卡、施耐德、卡尔蔡司和日系CBC、Kowa、尼康、富士等光学巨头。**由于光学镜头行业集成了精密机械设计、几何光学、薄膜光学、色度学、热力学等多学科技术，并且制作工序和工艺复杂，具有较高的技术门槛。**

我国由于起步较晚，2008 年之前国内光学镜头市场基本被日本、德国品牌所垄断。近些年，我国工业镜头行业国内厂商快速增长，主要从中低端市场切入，凭借高性价比优势对于外资品牌具有一定竞争力。在高端市场，我国仍以进口日本、德国等老牌厂商的产品为主，但也有一部分企业如东正光学、慕藤光等逐步走向高端。东正光学的远心镜头畸变小于 0.02% ，倍率齐全，微距镜头产品也能够将畸变控制在 0.1% 的超低量级下。

#### 3.2.1. 国内外镜头参与厂商

+ Navitar 美国

    Navitar 总部位于纽约州罗切斯特，是领先的优质光学系统制造商和供应商，为机器视觉和生物医学诊断行业提供全面的定制光学解决方案。

+ 施耐德 德国

    施耐德是有着近百年历史的德国老牌光学厂商，也一直是高品质工业用镜头、摄影镜头、滤镜、电影投影镜头和光学配件的国际市场领军者之一。在工业领域被广泛应用于科学研究、机器人、机器视觉、工业检测和邮件分选等。

+ 卡尔蔡司 德国

    卡尔蔡司是在光学及光电子学领域处于领先地位的一家全球性的国际化公司，卡尔蔡司镜头在业内一向享有良好的声誉，因其成像的超清晰能力而被称为“鹰之眼”。

+ CBC 日本

    CBC 株式会社成立于 1925 年，拥有 40 年以上 CCTV 产品经验，CCTV 镜头在日本国内、欧洲和亚洲地区都占据第一的市场份额，旗下 Computar 品牌的工业镜头被广泛应用于工业和安防领域。1996 年 CBC 上海分公司成立，Computar 镜头进入中国市场，如今已是中国工业镜头市场的主要供应商。

+ Kowa 日本

    Kowa 成立于 1894 年，是全球知名的镜头制造商，早在 1952 年便开始了光学产品的生产制作，所生产的 FA 镜头和 CCTV 镜头产品被广泛地应用于世界各地的项目，在日本、美国、欧洲都有极佳的口碑。

+ 东正光学 广东深圳

    东正光学专业从事工业镜头的研发和生产，拥有各类技术专利近百项，公司的工业机器视觉镜头（线扫描镜头、远心镜头、微距镜头等）已经使用在印刷检测、液晶屏检测、玻璃检测等诸多领域，客户涉及Facebook、Google、苹果等国际企业。

+ 慕藤光 江苏昆山

    慕藤光是一家为工业、军工科研、医疗仪器和机械设备提供光学产品的制造公司，产品包括工业相机镜头、科研镜头、医疗仪器和机械镜头等，主要市场覆盖**意、美、德、法、英、日、韩**等。

### 3.3. 光源

光源对于机器视觉中的图像采集部分具有重要影响，为后续图像识别与分析奠定必要的基础。合适的光源设备能够使被测物与背景尽量明显区分，获得高品质、高对比度的图像。在机器视觉领域的应用中，由于应用对象与检测要求的不同，尚无通用的机器视觉照明系统，需针对特定案例设计相应的照明方案，以达到最佳照明效果。

机器视觉系统使用的光源主要分为 LED 光源、卤素灯和高频荧光灯三种，其中最为常用的为 LED 光源。LED 光源即发光二极管光源，其发光原理和白炽灯、气体放电灯的原理都不同，LED 光源采用固体半导体芯片为发光材料，能量转换效率高，理论上可达白炽灯 10% 的能耗，相比荧光灯也可以达到 50% 的节能效果。此外，LED 光源具有形状自由度高、使用寿命长、响应速度快、单色性好、颜色多样、综合性价比高等特点，因此在机器视觉等工业领域具有更广泛的应用。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174955796-1161691043.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-14.jpg -->

机器视觉光源产品可按形状划分为多种类型，如环形光源、条形光源、平面光源、线光源、点光源、同轴光源等。不同的形状结构可提供不同的亮度、强度、照射角度、照射面积及颜色组合等，适用于不同的机器视觉应用场景。例如环形光源是由 LED 阵列成圆锥状以斜角照射在被测物体表面，通过漫反射方式照亮一小片区域，工作距离在 10-15MM 时，环形光源可以突出显示被测物体边缘和高度的变化，适合应用于 PCB 基板检测、IC元件检测、集成电路印字检查等情形。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174956016-1849879645.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-13.jpg -->

#### 3.3.1. 国内外光源参与厂商

国外机器视觉照明技术已较为成熟，国际上具有代表性的光源企业主要有日本CCS、Moritex和美国Ai。**国内光源市场国产化程度较高，竞争较为充分**，涌现出奥普特、沃德普、康视达、纬朗光电等一批机器视觉光源制造商，能够与国际品牌进行竞争。

+ CCS 日本

    CCS 成立于 1993 年，是日本 JASDAQ 上市公司，是国际领先的机器视觉 LED 光源制造厂商之一，在日本国内和海外均占有图像处理用 LED 光源的最大市场份额。拥有核心专利 800 多件，超过 1500 种的丰富产品阵容，能够为客户提供针对图像处理检测问题的“照明解决方案”。在国内设有上海和深圳代表处，并于 2017 年设立全资子公司“CCS CHINA Inc.”。

+ Moritex 日本

    Moritex 成立于 1973 年，是国际知名的光纤光源、LED 光源、光学镜头的供应商，其产品广泛应用于机器视觉和各类检测应用中。Moritex 将光学镜头领域与光学照明领域的开发经验紧密结合，为各种机器视觉应用提供先进的产品和技术。

+ Ai 美国

    Ai 公司是一家专业从事机器视觉光源研发生产的公司，自上世纪 90 年代就开始在机器视觉工业中开发可靠高效的 LED 光源，产品线齐全，质量可靠，在世界机器视觉领域积累了良好的声誉，主要合作伙伴包括 Cognex、Keyence、NI、Omron 等。

+ 奥普特 广东东莞

    奥普特在成立之初，以机器视觉核心部件中的光源产品为突破口，进入了当时主要为国际品牌所垄断的机器视觉市场。经过十几年的发展，拥有 38 大系列、近 1000 款标准化产品，并在全球多个国家实现销售。此外公司在**视觉系统、镜头、工业相机**等领域也有布局。

+ 康视达 广东东莞

    康视达是专业的机器视觉 LED 光源研发企业，目前已建成华南区最大的机器视觉光源研发检测中心。机器视觉光源作为公司的核心产品，已经形成 16 大标准系统上千种产品，光源的配套控制器也已形成模拟控制器、数字控制器、频闪控制器以及点光源恒流控制器等四大系列。

+ 纬朗光电 上海

    纬朗光电成立于 2007 年，是我国一家较早从事机器视觉 LED 光源研发、生产和销售的企业，获得二十几项专利，能为客户提供全套视觉光源与光源定制，同时代理国内外知名品牌工业相机及工业镜头等。

### 3.4. 图像处理软件

对所获得的视觉信号进行处理是机器视觉系统的关键所在，机器视觉软件类似“大脑”，通过图像处理算法完成对被测物的识别、定位、测量、检测等功能。机器视觉软件主要分为两类：一类是包含大量处理算法的工具库，用以开发特定应用，主要使用者为集成商与设备商；另一类是专门实现某些功能的应用软件，主要供最终用户使用。两者主要在开发的灵活性上存在差别。

目前，图像处理软件领域主要由美、德等国主导，主要厂商包括 Cognex、 Mvtec、Adept 等，软件的底层算法基本被以上厂商垄断。康耐视（Cognex）作为最具代表性的厂商之一，近 10 年业绩表现良好。康耐视营业收入由 19.25 亿元增长至 50.62 亿元，复合增速 10.15%；毛利率与净利率基本稳定，分别维持在 75%和 25%左右。

国内的机器视觉图像处理软件一般是在 OpenCV 等开源视觉算法库或者 Halcon、VisionPro 等第三方商业算法库的基础上进行二次开发。由于独立底层算法具有非常高的技术壁垒，国内目前仅有创科视觉、海康威视、奥普特、维视图像等少数企业完成底层算法研究并进行一定范围的应用。

#### 3.4.1. 国外主要机器视觉软件及厂商

+ Halcon-MVtec

    一套完善的标准的机器视觉算法包，拥有应用广泛的机器视觉集成开发环境。由一千多个各自独立的函数，以及底层的数据管理核心构成，应用范围几乎没有限制，涵盖医学，遥感探测，监控，到工业上的各类自动化检测。

+ VisionPro-Cognex

    主要用于设置和部署视觉应用，无论是使用相机还是图像采集卡。借助 VisionPro，用户可执行各种功能，包括几何对象定位和检测、识别、测量和对准，以及针对半导体和电子产品应用的专用功能。

+ HexSight-Adept

    包含一个完整的底层机器视觉函数库，提供稳定、可靠及准确定位和检测零件的机器视觉底层函数。其功能强大的定位器工具能精确地识别和定位物体，不论其是否旋转或大小比例发生变化。

以创科视觉为例，公司研发的 CKVisionBuilder 是目前机器视觉行业内最简单的视觉系统开发平台，涵盖了定位、测量、识别、读码、缺陷、颜色、3D、逻辑运算等所有图像处理功能。该系统具有极高的通用性，具体表现为：不要求用户具有编程基础，适用于各种人群；适用于 3C 电子、汽车制造等多种行业；对不同种类的工业相机、PLC 等均留有对接接口，具有较好的兼容性。

#### 3.4.2. 机器视觉图像处理软件典型功能

* 预处理功能
    + 图像增强（Image Enhancement）

        - 对比度增强

            ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174956220-16336143.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-16.jpg -->

        - 亮度均衡

            ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174956409-697961338.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-15.jpg -->

        - 图像平滑（Image Smoothing）

            消除不需要的特征点，排除背景的细微噪点或干扰。

        - 形态学运算（Morphology）

            ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174956583-1974159514.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-17.jpg -->

* 定位功能

    + 基于形状的轮廓定位
    + 基于边缘的图像定位
    + 基于灰度匹配定位

+ 几何检测功能

    * 尺寸测量
    * 周长检测
    * 圆形测量

+ 标定校准功能: 矫正因所拍图像视野过大或物距太高而产生的畸变
+ 检测识别功能

    * 条码检测
    * 二维码检测
    * OCR

+ 外观缺陷检测功能

    * 缺陷检测: 检测产品的瑕疵或者缺陷
    * 边界检测: 测出产品边界突出或凹陷的缺陷
    * 划痕检测: 测出产品表面是否有斑点或划痕

+ 3D 测量功能

    * 3D 高度测量
    * 3D 平面度测量

## 4. 应用案例

2019 年机器视觉下游应用领域统计：

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174956777-2146922297.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-18.jpg -->

### 4.1. 汽车制造行业应用

汽车制造质量原先主要依靠三坐标测量完成，效率低、时间长、数据量严重不足，且只能离线测量。机器视觉引入非接触测量技术，逐步发展成固定式在线测量站与机器人柔性在线测量站等在线测量系统，可严格监控车身尺寸波动，提供数据支持。

除传统三坐标测量、激光在线测量外，蓝光扫描测量、表面缺陷测量等视觉测量方法可进行更加精细地测量，对车身基本特征尺寸、车体装配效果、缺陷等提供高精度监控。多种监控测量手段互相结合，确保生产零件零缺陷、整车制造高质量。

#### 4.1.1. 基恩士的应用案例

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174956982-283206449.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-40.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174957258-326326503.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-39.jpg -->

#### 4.1.2. 康耐视在汽车制造领域的应用案例

1. 车身钢制框架: 检测螺母是否存在

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174957492-2134315413.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-22.jpg -->

2. 车身侧面板

    引导机器人点焊，以及引导第二个机器人进行光学点焊检查。将检查点焊的数量及位置是否准确。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174957684-1816129682.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-21.jpg -->

3. 轮胎检查

    检查生产线上的轮胎，高度可靠地测量任何变形。轮胎生产设施的速度为每天 28,000 个轮胎。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174957890-1345755990.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-23.jpg -->

4. 刹车片检查

    提供刹车片的零缺陷检测：测量刹车片的整体尺寸，检测混合材料、大小或装载位置错误的产品以及缺少生产工艺中某个步骤的产品，识别表面图案和标志，区分刹车片特征。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174958064-777915667.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-24.jpg -->

5. 轮圈螺栓检查

    检查两件式螺栓（包括螺母和不锈钢螺帽）或三件式螺栓（包括螺母、螺帽以及垫圈），这两种元件同时在一台多工位机器上处理，机器速度为每分种 31 个周期。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174958246-15582773.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-25.jpg -->

6. 轮胎和轮圈检查

    找到轮胎和轮圈上径向力变量（RFV）点，然后将两点之间的角度传输到机器的主控制系统。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174958422-1303273339.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-26.jpg -->

7. 自动凸缘螺母紧固

    引导机器人找到并旋紧凸缘螺母以将轮圈紧固在轮毂上。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174958615-1910138081.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-27.jpg -->

8. 冷却模块检查

    检查五个不同组装线上建造的冷却模块，每个组装线上建造的模块有50多种。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174958845-1785542131.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-28.jpg -->

9. 螺丝尺寸检查

    确保分拣在400ppm速度下生产的特种组件时100%的准确度。螺丝长度从40mm到60mm不等。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174959020-1510483405.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-29.jpg -->

10. 机器人引导

    现有的机械扶正器不能应付两种关键车型的新玻璃尺寸。新的视觉系统必须能够提供有关两种新车型的准确信息，并且必须能方便适应未来产品开发。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174959238-1205992899.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-30.jpg -->

11. 仪表板检测

    检查每个仪表板上车速表、转速表、燃料和温度表的指针对齐，每个嵌花都精确剪裁到位，车辆震动可能使嵌花移动，从而导致显示的速度和转速不正确。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174959439-437805222.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-31.jpg -->

12. 引擎部件检查

    检查连杆的厚度、长度和宽度、对称偏差、同心度和位移。

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174959676-460766374.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-32.jpg -->

13. 汽车车漆表面质量自动检测

    ![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914174959879-1466522302.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-20.jpg -->

#### 4.1.3. 汽车制造中视觉引导技术（无人工厂）

1. 轮胎自动化安装

    利用视觉引导技术完成轮胎的自动化安装，最大的难点就是精准确定轮胎孔位和轮盘螺栓的位置，视觉定位的偏差不能超过2mm，否则弹性套筒无法吸收偏差。

2. 加强剂涂布视觉引导

    汽车的前后挡风玻璃安装前，需要在安装玻璃的窗框周围涂布一圈车身加强剂，用以增强与玻璃的粘合效果，车身加强剂的涂布质量影响到玻璃粘合的效果，如果涂布的轨迹出现偏差或任何一个位置出现漏涂、少涂都会严重影响到最终的车辆品质。并且车身放置于吊具上在生产线上流动，由于吊具精度存在偏差，车身的位置并不恒定，如何使机器人对不同偏差的车身都能涂出同样完美的轨迹？这就需要利用视觉引导技术来纠正位置偏差。

3. 前后挡风玻璃自动安装

    前后挡风玻璃的安装由人工转向自动化安装，就必须将原来由人工判断玻璃安装的准确位置由机器人完成，玻璃的安装有着严格的位置要求，以某车型为例，前挡风玻璃与前挡立柱的左右间隙不能大于8.9mm，间隙差不能超过1.5mm，车顶段差不能超过2.5mm，若超过间隙，则可能出现漏水的品质隐患，属于品质不良，车辆即报废。因此使用机器人自动化安装玻璃则必须精准的控制玻璃安装的坐标。要想实现精准安装，则需要借助视觉引导技术。

4. 车门密封胶自动涂布

    汽车车门的装配有一道重要工序，就是装配防水胶纸，防水胶纸可以有效隔绝雨水、潮气和噪音，防水胶纸是由车门密封胶粘合在车门内饰上，而密封胶的涂布不仅对密封胶涂布的轨迹有要求，还对出胶量、胶型有要求。密封胶的涂布质量关系着汽车的品质，而人工涂胶常常难以控制涂出胶型统一、胶量均匀、轨迹固定的密封胶，因此采用机器人自动涂胶是一个更优的选择，但是如何使机器人在车门吊具存在偏差的情况下每次都可以涂出完美的胶型呢？同样也是需要使用视觉引导技术。

5. 继电器分拣

    总装车间电装线装配项目中有一项继电器安装的工程，需要将16个不同规格的继电器元件安装在继电器盒中，人工安装比较费时费力并且对于员工的健康有一定损伤，因此利用视觉引导技术检测继电器元件的规格，拣选不同安装位置的继电器元件，由机器人抓取继电器元件完成自动组装。

### 4.2. 消费电子行业的应用

AOI 光学检测是工业生产中执行测量、检测、识别和引导等任务的新兴科学技术，广泛应用于 PCB 缺陷检测过程。其采用光学照明与图像传感技术获取被测物体信息，通过数字图像处理增强目标特征，利用模式识别、机器学习、深度学习等算法提取特征信息，并进行分类与表征，最后反馈给执行控制机构，实现产品分类、分组分选、质量控制等生产目标。其基本原理是用各种光学成像技术与系统模拟人眼的视觉成像功能，用计算机处理系统代替人脑执行实时图像处理、特征识别与分类，用执行机构代替人手完成操作。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914175000116-1913417812.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-19.jpg -->

PCB 缺陷检测主要是焊点缺陷检测和元器件检测两大部分。传统的人工目视检测法易漏检、速度慢、时间长、成本高，已不能满足生产需要，机器视觉 PCB检测系统具有重要的现实意义。在电路板从印刷装置中移下，或在清洗剂中清洗后，以及返修完成返回生产线中，机器视觉提供的在线视觉技术可以在实施印刷操作后直接发现存在的缺陷情况，保证了操作者在加上 PCB 以前能够及时处理有关问题。另外，发现缺陷时可以有效防止有缺陷的电路板送达生产线后端，从而避免出现返修或废弃现象。操作者能够及时得到反馈，明确处于操作中的印刷工艺操作是否良好，达到预防缺陷产生的目的，对生产效率和良率的提升至关重要。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914175000343-154290441.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-33.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914175000541-144622044.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-34.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914175000752-715897604.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-42.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914175000966-1931892686.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-43.jpg -->

据中商产业研究院，消费电子及半导体领域的机器视觉市场规模 2018 年突破 20亿元，2019 年将达到接近 30 亿元水平。消费电子行业元器件尺寸小，质量标准高，适合用机器视觉系统检测，也促进机器视觉技术进步。同时，消费电子产品生命周期短，需求量大，拉动机器视觉市场需求。

### 4.3. 食品包装与制药行业应用

机器视觉在食品包装领域适用范围广泛，可用于检测瓶子的分类和液位测量、标签、盖子、盒子的检查，以及瓶的形状、尺寸、密封性和完整性。被检查的包装形状不限包装盒、包装箱、金属箱、管状、泡状、盘状、广口瓶、细口瓶、罐装和桶装等。食品包装是食品质量的重要保障，可以保护食品在流通过程中免受污染，提高品质，避免发生安全事故。同时，食品包装的观赏性也会给消费者良好的购物体验。因此，食品包装检测是控制不合格食品流入市场的关键环节，影响企业在行业中的竞争力。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914175001189-1933023538.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-44.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914175001415-1893319778.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-38.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914175001631-600228617.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-41.jpg -->

## 5. 千亿蓝海大有可为

随着机器视觉硬件方案的不断成熟和运算能力的提升，以及软件在各种应用解决方案、3D算法、深度学习能力的不断完善，机器视觉在电子产业（如 PCB、FPC、面板、半导体等领域）应用的广度和深度都在提高，并加快向食品饮料、医药等其他领域渗透，预计我国机器视觉市场规模将继续保持较高的增速。

GGII 数据显示，2019 年我国机器视觉市场规模 65.5 亿元（不包含计算机视觉市场），同比增长 21.8%。2014-2019 年复合增长率为 28.4%，并预测到 2023年中国机器视觉市场规模将达到 155.6 亿元。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914175001820-75078551.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-37.jpg -->

机器视觉核心部件和设备企业盈利能力优异，行业成长性和进口替代的庞大空间是国内机器视觉企业的历史性机遇。2019 年，机器视觉国际巨头基恩士和康耐视毛利率分别为 82.35%/73.85%，净利率分别为 38.52%/28.10%，而国内以光源为主打产品的奥普特毛利率/净利率分别为 73.59%/39.35%。

![](https://img2020.cnblogs.com/blog/2039866/202009/2039866-20200914175002029-1639335972.jpg) <!-- 机器视觉入门培训-PPT讲稿/机器视觉入门培训-PPT讲稿-36.jpg -->

在机器视觉设备领域，相关企业毛利率普遍在 40-50%的较高水平。随着核心零部件国产化进程的加快，将降低机器视觉应用成本，提升国内机器视觉设备企业的竞争优势，并推动机器视觉在智能装备领域的普及。
