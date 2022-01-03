<!--
+++
title       = "CFA_I级_财报分析 - 知识点总结"
description = "1. Introduction; 2. Financial Reporting mechanics; 3. Income Statement; 4. Balence Sheet"
date        = "2022-01-03"
tags        = ["笔记"]
categories  = ["8-business","85-财务知识"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. Introduction
> [Bilibili: CFA一级 财报分析](https://www.bilibili.com/video/BV1Hk4y1r79w)

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110306009-1538272196.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-0.jpg -->
### 1.1. FRS框架

1. 会计准则分为 `U.S.GAAP` 和 `IFRS` ，中国会计准则 `PRC.GAAP` 基本上就是IFRS。
2. 财报主要有：

    + B/S, Balance Sheet
    + I/S, Income Statement 或 P/L, Profit and loss
    + C/F, Cash Flow Statement

1. 记账方式
    + <font color=#FF0000>权责发生制</font>(Accrual Base): BS + IS
    + 现金收付制(Cash Base): CF
3. B/S反映的是一个公司<font color=#FF0000>某个时间点的</font>存量情况 `at a point of time` :

    + Asset, 资产
    + Liability, 负债
    + Equity, 所有者权益
        * Capital, 股本
        * 留存收益
        * 支付红利

    恒等式：`Asset = Liability + Equity`

5. I/S反映的是公司<font color=#FF0000>一段时间的</font>经营情况 `during a period of time` :

    + Revenue, 收入
    + COGS, 生产成本
    + Operating Profit, 经营利得
    + Expense, 费用（水电费+折旧等）
    + NI, Net Income, 净收入（利润）

1. C/F反映的是公司<font color=#FF0000>一段经营时间内的</font>现金流入和流出:

    + CFO, Operating Cash Flow, 经营性现金流
    + CFI, Investing Cash Flow, 投资性现金流
    + CFF, Financial Cash Flow, 融资性现金流

1. Double Entry Accounting, 复式记账

    + Dr, 借方
    + Cr, 贷方

    有借必有贷，借贷必相等

1. OCI, Other Income, 4+1

    非主营业务，例如房产的涨价。GAAP标准有4项内容，国际标准则增加了一项，故称为4+1.

### 1.2. 信息来源

1. <font color=#FF0000>Footnote</font>, 最能给出分析师数据的信息来源
    + accounting methods, 会计方法
    + assumptions, 会计估计
    + estimates, 会计假设
    + 客户信息，员工福利……
    + 不确定分析
    + 兼并和变卖
3. <font color=#FF0000>MD&A</font>, 管理层分析和讨论
2. Supplementary schedules, 附加信息
    + 分部报告
4. Summary & Interim report, 年报、季报
5. SEC年报
    + 8-K, 重大事项公告
        * 收购、兼并
        * 管理层人员变动
        * 企业管理结构
    + 10-K年报
    + 10-Q季报
6. 公司通告
7. Proxy Statement, 上市公司就重大事项提出股东表决

### 1.3. Auditing, 审计

董事会(board): 代表所有股东(shareholder)，management代理董事会的工作任务，审计负责监管management。

+ Unqualified (clean) opinion
+ Qualified opinion
+ Adverse opinion
+ Disclaimer of opinion

## 2. Financial Reporting mechanics

### 2.1. R22: Financial Statement elements

#### 2.1.1. Assets

1. cash & 现金等价物(equivalents)
1. 应收账款, trade receivable
1. Prepaid expenses, 预付款
1. Inventory: 存货
1. PPE, 固定长期资产
    * Propety, 土地（及附着物，如大楼）
    * plant, 厂房
    * equipment, 设备（注意，存在折旧）
1. Financial assets
1. Investment in affiliates, 对 `联营企业` 投资（>20% & <50%)
    + `<=20%` , 称为金融资产
    + `>=50%` , 则作为子公司，并入母公司报表
1. Deferred tax assets
1. 无形资产
    * 版权，商标，特许经营权……
    * goodwill, 商誉——可口可乐公司即便是火灾烧了个精光，也一定会有投资者愿意出资复建。

Contra accounts, 备抵账户（不计入资产）：比如说，坏账就是应收账款的备抵账户。

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110306391-606523783.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-2.jpg -->

##### 中国特色的土地资产项

<font color=#FF0000>土地是不能折旧的</font>，你拥有十亩地，若干年之后还是十亩地，但土地上的房子应该折旧，谁都知道房子是会衰落倒塌的。不过中国上市公司的情况有所不同，<font color=#FF0000>咱们的土地并不是真正的土地，而是土地使用权，这东西肯定要折旧，因为使用权到期就没了</font>，但现在我们没必要把事情搞复杂。

#### 2.1.2. Liabilities

+ Accounts payable, 赊销
+ Unearned revenue, 预收账款
+ 金融负债，如发行的票据
+ Long-term debt
+ Income taxes payable, 如公司债券
+ Deferred tax liabilities

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110306765-1184174950.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-1.jpg -->

#### 2.1.3. Owner's equity

+ Capitcal
+ Additional paid-in capital, 股本溢价
+ Retained earnings, 留存收益（不用与作为红利分配的）
+ OCI, other comprehensive income, 4+1

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110307049-316088951.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-5.jpg -->

#### 2.1.4. Revenue

+ Revenue, sales
+ Gains, PPE或无形资产所产生的利润
+ Investment income

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110307326-1594662444.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-3.jpg -->

#### 2.1.5. Expenses

+ COGS, cost of goods sold, 生产成本
    * 原材料
    * 人工
    * 生成费用（设备折旧，等等）
+ SG&A, Selling, general, and administrative expense
+ Tax expense
+ Interest expense
+ Losses

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110307537-115505188.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-4.jpg -->

Equity = 原始股东注资(contributed capital) + 往年留存收益(ending retained earnings)

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110307798-1093766224.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-6.jpg -->

BASE法则

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110307989-570129124.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-7.jpg -->

### 2.2. 4种常见模型

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110308244-1046065570.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-8.jpg -->

#### 2.2.1. Accrued expense, 赊购

+ A++
+ L++

另，分析下普通的采购行为，就是添置了资产，但减少了现金，达到平衡。赊购行为，只是把减少的cash部分，转移到了Liability中。

#### 2.2.2. Prepaid expense, 预付款

我们个人订全年的杂志/牛奶：

+ 预付款，cash-
+ 待收货，assets+

其实这个过程，与直接的采购行为，账面上没有任何区别。

#### 2.2.3. Unearned revenue/deferred revenue, 预收款

例如，杂志社预订全年，收了钱没做事。

+ A++
+ L++

正常的贸易，是 `(Cash++ & Inventory-) & E++` ，那么预收款仅仅是把 E的增加，在当前时刻由于尚未兑现，先放到L++中记录。

#### 2.2.4. \*Accrued revenue, 赊销

+ A++ : 应收账款
+ E++ : revenue增加，所以NI+，所以Equity+

~~个人认为，应收账款增加了，但换取的是存货的减少，Inventory--导致A--，最后平衡。这样似乎更合理，毕竟Equity的NI是通过计算算出来的。~~

那么问题来了，如果是一手交钱一手交货，也是A++ & A--吗？

BS是一张时间点的平衡表。在贸易前，存货Inventory的价值为 `x` ，而交易后，收到账款 `x+50` ，存货减少 `x` ，那么剩余的50就是利润，计入Equity。

那么推回来，赊销的方式，与普通贸易并无差别，只是 A++ 的不是cash，而是应收账款罢了。

---

### 2.3. Flow of information

会计信息流转

+ Journal entries, 日记张
+ General Ledger, 分类帐目，例如收入类、购买类，应收账款……
+ Trial balance, 试算平衡
+ Financial Statements, 报表

### 2.4. 会计准则

+ IASB, 国际会计准则, IFRS
+ FASB, US GAAP

报表原则

+ Accrual Bsis, 权责发生制
+ Helevance, 相关性
+ Faithful representation, 公允性
    * 完整性
    * 中立的
+ Comparability, 可比性
    * 纵向可比：过去的和现在的
+ Verifiability, 可验证性
+ Timeliness, 及时性（3月底）
+ Understandability, 例如安然事件，太多不可评估的金融衍生品
+ 可量化，如不能，需要在MD&A等信息中做说明

Measurement Base

+ \*Historical cost: 历史成本法

    5000万买的大楼，即使涨到了5个亿，帐目上也不会变。

+ Amortized cost: 金融资产和金融负债的计算方式
+ Current cost: 现在买大楼的公允价格
+ Realizable value: 现在卖大楼的公允价格
+ Present value: 针对存货，现在卖掉能等效的价格
+ \*Fair value: 非关联、无胁迫、信息透明

其他

+ No offsetting, 不能对冲，一笔帐归一笔帐

## 3. Income Statement

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110308481-1111645500.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-9.jpg -->

### 3.1. 来一波术语

对于术语，只是一种阶段性的计算过程的“临时变量”，但它也能代表或展现一部分性能参数。你能理解他代表的什么性能，其出现的场景在哪里就够了。

#### 3.1.1. Revenue

销售带来的**主营业务收入**。

Net revenue = revenue(销售费用) - adjustments(三包费用，退货换修等费用)

#### 3.1.2. Expense

+ COGS, 成本（料工费）
+ SGA, 经营费用
+ interest, 注意interest具有<font color=#FF0000>税盾</font>的作用

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110308720-1699009671.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-10.jpg -->

+ Dep.n, 折旧

    两种列式的不同……没太懂，似乎在说，折旧按照nature方式，直接作为单独条目，而作为功能列式则应该加入到其他功能项目中。

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110308918-1805919564.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-11.jpg -->

#### 3.1.3. Gains and losses

PPE 或 无形资产，所产生的利润

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110309253-310903599.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-12.jpg -->

NI = revenue - ordinary_expenses + other_income + gains_losses

#### 3.1.4. NCI, Non-controlling intrest

也可称为 `MI, minority intrest` ，非控股股东权益。

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110309474-1938531448.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-14.jpg -->

#### 3.1.5. Gross profit, 毛利

ratio, 毛利率 = gross_profit / net_revenue

#### 3.1.6. Operating profit

**EBIT**, Earnings Before Interest and Tax, 税前收益

`EBIT＝经营利润＋投资收益＋营业外收入－营业外支出＋以前年度损益调整`

**EBITD**, Earnings Before Interest, Tax and Depreciation, 扣除利息、税项及折旧前盈利

`EBITD=Revenue-Expenses(excluding taxes,interest and depreciation)`

**EBITDA**, Earnings Before Interest, Taxes, Depreciation and Amortization，即未计利息、税项、折旧及摊销前的利润。EBITDA被私人资本公司广泛使用，用以计算公司经营业绩。

最初私人资本公司运用EBITDA，而不考虑利息、税项、折旧及摊销，<font color=#FF0000>是因为他们要用自己认为更精确的数字来代替他们</font>：

+ 他们移除利息和税项，是因为他们要用自己的税率计算方法以及新的资本结构下的财务成本算法。
+ 摊销费用被排除在外，是因为它衡量的是前期获得的无形资产，而不是本期现金开支。
+ 折旧是对资本支出的非直接的回顾，也被排除在外，并被一个未来资本开支的估算值所代替。

如果上市公司<font color=#FF0000>将EBITDA等同于现金流，却是一个非常不可取、很容易将企业导入歧途的做法！</font>原因何在？

1. 它排除了利息和税项，但它们却是真实的现金开支项目，而并非总是可选的， 一个公司必须支付它的税款和贷款。
1. 它并没有将所有的非现金项目都排除在外。 只有折旧和摊销被排除掉了， EBITDA中没有调整地非现金项目还有备抵坏账、计提存货减值和股票期权成本。
1. 不同于现金流对营运资本的准确量度，EBITDA忽略了营运资本的变化情况。 例如，营运资本的额外投资就意味着消耗现金。
1. 最后，EBITDA的最大缺点反映在“E”上，即利润项上。如果一家上市公司保修成本、重构开支以及备抵坏账的准备金不足或超支，那么它的利润项都会发生变化倾斜。

在这样的情况下，企业就很容易被EBITDA导入歧途。 如果它过早地报告经营收入，或是将一些普通成本视作资本投入，那么EBITDA报告的利润结果也是值得可疑的。如果它通过资本来回交易的方式膨胀收入，这种情况下，EBITDA报告的利润结果就一点价值也没有了。

#### 3.1.7. 总结 & 其他细节

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110309730-663848054.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-13.jpg -->

### 3.2. 长期合同的确认方法

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110310024-1300124017.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-17.jpg -->

+ Percentage-of-Completion（aggressive）

    当且仅当，能够合理估算每年的完工比例，同时可以预估每一阶段的revenue和expense。

+ Completed Contract Method（conservative）

    如果不能可靠估计，则需要在最终合同完成后，一次性统计。

但实际上，这两种方式都可能造成<font color=#FF0000>报表操纵</font>，或提前增加利润，或延后确认利润。

将当期的cost作为revenue，使当期的 NI==0 ，然后在项目完结后再计算收益

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110310316-2016998812.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-15.jpg -->

### 3.3. Barter Transaction

#### 3.3.1. Round-trip transaction

例如：新浪与网易相互打广告。

+ GAAP: 如果历史上曾经以这类产品或服务收到过现金，则可以作为fair_value。
+ IFRS

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110310535-967492156.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-18.jpg -->

#### 3.3.2. Gross / Net Reporting of Revenue

主要针对代理商，因为赚取差价，所以销售收入和成本的定义略作调整。

### 3.4. EPS, 每股收益

Earnings per share, 代表着公司的盈利能力。

#### 3.4.1. P/E, 市盈率

公司股价 `Price = P/E * EPS` ，用于评估公司股价的合理性。

+ 1块钱的盈利需要多少价格购买
+ 几年能把初始投资成本收回

P/E 越高，公司的股价约值得投资；但同时，意味着收回初始投资的过程越漫长。

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110310854-445382779.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-19.jpg -->

+ Basic EPS
+ Diluted EPS
    * options, 股票期权
    * warrants, 权证
    * convertible debt, 可转债（债券->股票）
    * vonvertible preferred stock, 可转换优先股

##### BEPS计算公式

+ Time-apportion

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110311110-2040295470.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-20.jpg -->

+ New issues and stock dividend

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110311320-713626380.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-21.jpg -->

BEPS例题

1. 计算股票

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110311548-133323744.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-23.jpg -->

2. 时间加权

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110311748-1422311807.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-22.jpg -->

##### DEPS计算公式

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110311980-830571494.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-24.jpg -->

+ `债券->股权` 的转换过程，会节省了issues, 对Equity有增加
+ `Equity += interest * (1-tax)` 因为税盾作用，恢复时，interest那部分还要进行扣税才得到对权益的增值结果

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110312206-1556891206.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-25.jpg -->

**Example**

+ 可转换优先股

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110312410-1439503170.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-26.jpg -->

+ 可转债

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110312639-2047626319.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-27.jpg -->

+ 库存股

    ![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110312872-1348086184.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-28.jpg -->

### 3.5. Retained earning

### 3.6. Comprehensive income, 综合收入, TCI

TCI = NI + OCI

+ OCI
    * Foreign curency translation gains and losses. 汇兑损益

        这不是Foreign curency transaction——美元兑换人民币带来的损益，这个直接记录在报表中。

        而是例如：华为在美国的子公司，把报表合并进入华为集团时，带来的损益。

    * DB养老金计划（不同于DC）
    * Unrealized gains and losses...
    * 不动产重估，带来的重估增值
    * AFS, available-for-sale, 可供出售的金融资产

## 4. Balence Sheet

资产负债表，本质目的是为了解读一个公司（当然也可以推广到某个人）当前的经济状态。资产代表的是实力，负债和Equity表示 `起步+寻求的帮助+代价` 。但同时，资产负债表受限于统计方式，无法对商誉、员工个人能力等无形资产进行评估和展现，也是一项缺失。

Equity的变动主要来源于:

1. Capital: 股东注资、撤资、增资。
2. NI作为留存收益，添加到Equity中；
3. OCI

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110313141-1556384434.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-29.jpg -->

accounts receivable:

1. 资产备抵账户: PPE中资产折旧的部分
2. 应收账款的备抵账户（坏账）

Example

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110313367-667416851.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-30.jpg -->

大楼涨价，重估价增值（Equity::OCI）

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110313564-84512444.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-31.jpg -->

IP: Investment Property

无形资产, intangible assets
> [Bilibili](https://www.bilibili.com/video/BV1Hk4y1r79w?p=27)

+ 各类型**权**
+ 商誉
+ R&D: GAAP作为Expense费用，IFRS允许在一定条件下，作为资产增加项（Research & Development）

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110313764-1475352364.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-32.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110313981-13387212.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-33.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110314219-1248461665.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-34.jpg -->

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826110314417-1959618544.jpg) <!-- cfa1-Financial_Statement_Analysis/cfa1-Financial_Statement_Analysis-35.jpg -->

记住：PPE需要使用公允价值（Fair Value）

