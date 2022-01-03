<!--
+++
title       = "Tornado-REST - 快速创建你的网络APIs"
description = "1. PyRestful库; 2. 安装; 3. 使用: a demo for CRUD"
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

学习这篇文章之前，你需要：

+ 清楚RESTful风格的含义（了解即可，Demo会带你切身体验）
+ 明白Tornado是什么（对，不需要开发经验）

学习完本文后，你可以

+ 使用Tornado框架，快速构建REST-APIs
+ 实现一个CRUD（Create, Read, Update and Delete）操作流程

## 1. PyRestful库
> [github](https://github.com/rancavil/tornado-rest)

一个基于Tornado框架、用于实现RESTful风格的API接口的Python组件。实际上，它主要提供了

+ @get
+ @post
+ @put
+ @delete

四个装饰器，用于定义一个method()的REST类型。

这里是一个简单的Demo，告诉你它是什么（关注@get即可）。

```py
import tornado.ioloop
import pyrestful.rest

from pyrestful import mediatypes
from pyrestful.rest import get

class EchoService(pyrestful.rest.RestHandler):
     @get(_path="/echo/{name}", _produces=mediatypes.APPLICATION_JSON)
     def sayHello(self, name):
          return {"Hello":name}

if __name__ == '__main__':
     try:
          print("Start the echo service")
          app = pyrestful.rest.RestService([EchoService])
          app.listen(8080)
          tornado.ioloop.IOLoop.instance().start()
     except KeyboardInterrupt:
          print("\nStop the echo service")
```

## 2. 安装

两种安装方式

```sh
pip install pyrestful
```

或者

```sh
pip install -U git+https://github.com/rancavil/tornado-rest.git
```

## 3. 使用: a demo for CRUD

这里以官方的Demo作为演示。

目标：设计一个Http服务端，用于学生信息的记录。需要提供 `增、删、改、查` 四大功能。

预定义两个类:

+ `class Customer` : 学生对象
+ `CustomerDataBase` : 数据库接口

定义一个Http的Handler，继承自 `pyrestful.rest.RestHandler` :

```py
class CustomerResource(pyrestful.rest.RestHandler):
    def initialize(self, database):
        self.database = database
```

### 3.1. Creating a new Customer

> POST it is equivalent to INSERT.

使用post方法，传入一个新的学生信息。服务器接受到学生信息后存入数据库。

API接口的描述：

```
POST: http://myserver.domain.com:8080/customer

POST /customer HTTP/1.1
Host: myserver.domain.com

params:
* name_customer=Rodrigo
* address_customer=Santiago
```

服务端API代码

```py
@post(_path="/customer", _types=[str,str], _produces=mediatypes.APPLICATION_JSON)
def createCustomer(self, name_customer, address_customer):
    id_customer = self.database.insert(name_customer, address_customer)
    response = {"created_customer_id": id_customer}
    return response
```

测试：

+ 使用 `PostWoman` 测试API

    ![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200708202948709-147739159.jpg) <!-- tornado-rest/tornado-rest-0.jpg -->

+ 使用 `httplib` 发起请求

    ```py
    import http.client as httplib
    import urllib.parse as urllib

    params  = urllib.urlencode({'name_customer':name_customer,'address_customer':address_customer})
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    conn    = httplib.HTTPConnection("localhost:8080")

    conn.request('POST','/customer',params,headers)

    resp = conn.getresponse()
    data = resp.read()
    if resp.status == 200:
        json_data = json.loads(data.decode('utf-8'))
        print(json_data)
    else:
        print(data)
    ```

### 3.2. Read a Customer

> GET it is equivalent to SELECT (READ).

使用get方法，获取数据库中一个学生信息。

API接口的描述：

```
GET: http://myserver.domain.com:8080/customer/{id}

GET /customer/1 HTTP/1.1
```

服务端API代码

```py
@get(_path="/customer/{id_customer}", _types=[int], _produces=mediatypes.APPLICATION_JSON)
def getCustomer(self, id_customer):
    customer = self.database.find(id_customer)

    response = {
        'id_customer'     : customer.getId_Customer(),
        'name_customer'   : customer.getName_Customer(),
        'address_customer': customer.getAddress_Customer()
    }
    return response
```

### 3.3. Update a Customer

> PUT it is equivalent to UPDATE.

API接口的描述：

```
PUT: http://myserver.domain.com:8080/customer/{id}

PUT /customer/1 HTTP/1.1
Host: myserver.domain.com

params:
* name_customer=Rodrigo
* address_customer=Santiago
```

服务端API代码

```py
@put(_path="/customer/{id_customer}", _types=[int,str,str], _produces=mediatypes.APPLICATION_JSON)
def updateCustomer(self, id_customer, name_customer, address_customer):
    updated = self.database.update(id_customer,name_customer,address_customer)
    response = {
        "updated_customer_id": id_customer,
        "success":updated
    }
    return response
```

### 3.4. Delete a Customer

API接口的描述：

```
DELETE: http://myserver.domain.com:8080/customer/{id}

DELETE /customer/1 HTTP/1.1
```

服务端API代码

```py
@delete(_path="/customer/{id_customer}", _types=[int], _produces=mediatypes.APPLICATION_JSON)
def deleteCustomer(self,id_customer):
    deleted = self.database.delete(id_customer)
    response = {
        "delete_customer_id": id_customer,
        "success":deleted
    }
    return response
```
