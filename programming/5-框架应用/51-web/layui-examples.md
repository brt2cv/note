<!--
+++
title       = "LayUI示例代码"
description = "1. 文件上传"
date        = "2022-01-03"
tags        = []
categories  = ["5-框架应用","51-web"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 文件上传
> [doc](https://www.layui.com/doc/modules/upload.html)

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>upload模块快速使用</title>
  <link rel="stylesheet" href="/static/build/layui.css" media="all">
</head>
<body>

<button type="button" class="layui-btn" id="test1">
  <i class="layui-icon">&#xe67c;</i>上传图片
</button>

<script src="/static/build/layui.js"></script>
<script>
layui.use('upload', function(){
  var upload = layui.upload;

  //执行实例
  var uploadInst = upload.render({
    elem: '#test1' //绑定元素
    ,url: '/upload/' //上传接口
    ,done: function(res){
      //上传完毕回调
    }
    ,error: function(){
      //请求异常回调
    }
  });
});
</script>
</body>
</html>
```
