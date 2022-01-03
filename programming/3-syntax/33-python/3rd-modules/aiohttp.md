<!--
+++
title       = "Python异步Request操作: aiohttp"
description = "1. Tutorial; 2. 其他库推荐; 3. 问题记录"
date        = "2021-12-21"
tags        = []
categories  = ["3-syntax","33-python","3rd-modules"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. Tutorial
> [homepage](https://hubertroy.gitbooks.io/aiohttp-chinese-documentation/content/aiohttp%E6%96%87%E6%A1%A3/ClientUsage.html)
>
> [cnblog: aiohttp的使用](https://www.cnblogs.com/ssyfj/p/9222342.html)

## 2. 其他库推荐

### 2.1. aiohttp-requests

这个库时对aiohttp库的网络请求模块的封装，用了这个库，在异步网络请求的时候，可以在写法上更简洁易懂。本质上还是aiohttp库的使用。推荐使用这个库来做网络请求。

### 2.2. aiofiles

aiofiles是一个用Python编写，用于处理asyncio应用程序中的本地磁盘文件。爬虫过程中用它来进行文件的异步操作。

### 2.3. grequests

grequests模块相当于是封装了gevent的requests模块。

## 3. 问题记录

### 3.1. Multipart.FormData 示例

下面示例展示上传图片至SM.MS。

```py
with open(abspath_file, 'rb') as fp:
    multipart_form_data = aiohttp.FormData(quote_fields=False)  # quote_fields: 将对中文进行转码
    multipart_form_data.add_field('smfile', fp,
                                  content_type="image/jpeg",
                                  filename=os.path.basename(relpath_file),
                                  content_transfer_encoding="base64")

    headers = {'Authorization': self.api_token} if self.api_token else None
    # headers = {"Content-Type": "multipart/form-data"}
    async with aiohttp.ClientSession() as session:
        async with session.post(self.endpoint,
                                data=multipart_form_data,
                                headers=headers) as resp:
            await resp.text()
            str_response = await resp.text()

            json_content = json.loads(str_response)
            if not json_content['success']:
                logger.error(json_content)
                raise UploadError()

            print(f"[+] 完成上传: {relpath_file}")
```

### 3.2. with open("xxx") 会被自动关闭

程序是这样的:

```py
with open("xxx", "rb") as fp:
    ...
    async with aiohttp.ClientSession() as session:
        async with session.post(self.endpoint, data=fp) as resp:
            await resp.text()
            ...

    file_hash = hashlib.md5()
    while chunk := fp.read(8192):  # 这里报错：ValueError: read of closed file
        file_hash.update(chunk)
    return file_hash.hexdigest()
```

报错：`ValueError: read of closed file`

找到一篇相似的[文章](https://stackoverflow.com/questions/53727385/asyncio-aiohttp-client-read-of-closed-file-error)，解释不保证准确：

> 问题是open(...)返回一个文件对象，并且您要将同一文件对象传递给要start()在顶层创建的所有协程。恰好先调度的协程实例将文件对象session.post()作为的一部分传输data，session.post()并将读取文件到最后并关闭文件对象。下一个start()协程将尝试从现在关闭的对象中读取，这将引发异常。
>
> 要解决此问题而不多次打开文件，您需要确保实际将数据作为字节对象读取：
>
> data = {'file': open('test_img.jpg', 'rb').read()}
>
> 这会将相同的字节对象传递给所有协程，它们应按预期工作。

### 3.3. filename中文错误

使用post方式，上传multipart到SM.MS时，图像存储没问题，但文件名从中文变成了诸如 `%E9%B2%8D%E9%B.jpg` 的样子……应该是编码问题。怎么避免呢？

```py
multipart_form_data = aiohttp.FormData(quote_fields=False)  # quote_fields: 将对中文进行转码
```

使用参数 `quote_fields` 将避免该问题。

### 3.4. aiohttp(yarl)对url部分字符自动urldecode
> [csdn](https://blog.csdn.net/qq_31720329/article/details/82024036?ops_request_misc=&request_id=&biz_id=102&utm_term=aiohttp%20%E4%B8%8D%E6%94%AF%E6%8C%81%E4%B8%AD%E6%96%87%E7%BC%96%E7%A0%81&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-1-82024036)
>
> [github](https://github.com/aio-libs/aiohttp/issues/1725)

最新碰到一个用 aiohttp 访问不出内容，但是用 requests 能访问的情况，url 是事先进行了 urlencode 的, 下面的 url 随便找了个站点代替，但是把重点的参数提了出来

```
%40 对应的是 `@`
%3a 对应的是 `:`
```

解决方案：

```py
str_url = "https://www.xxx.com?xxx%40yyy%3azzz"
proxy_url = "http://localhost:8080"

async with session.get(URL(str_url), proxy=proxy_url) as resp:
    print(await resp.text())

async with session.get(URL(str_url, encoded=True), proxy=proxy_url) as resp:
    print(await resp.text())
```

