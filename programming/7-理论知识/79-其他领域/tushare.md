<!--
+++
title       = "量化投资 - tushare: 股票信息获取API"
description = "1. 初始化; 2. 获取股票列表"
date        = "2022-01-03"
tags        = []
categories  = ["7-理论知识","79-其他领域"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 初始化

```py
import tushare as ts

user_181xxxx8231_token = "732at0b77r28ftfebdsd32a6e21b3xxxxxxxxxx"
api = ts.pro_api(token=user_181xxxx8231_token)
```

## 2. 获取股票列表
> [homepage_doc](https://tushare.pro/document/2?doc_id=25)

描述：获取基础信息数据，包括股票代码、名称、上市日期、退市日期等

```py
df = api.stock_basic(exchange='',
                     list_status='L',
                     fields='ts_code,symbol,name,area,industry,list_date')
print(df.head())
```

数据样例

![](https://img2020.cnblogs.com/blog/2039866/202010/2039866-20201023203254335-719865513.jpg) <!-- tushare/tushare-0.jpg -->
