<!--
+++
title       = "Tornado - 入门"
description = "1. 概述; 2. URL路由映射; 3. 定义Handler的行为函数; 4. 获取请求参数; 5. 设置应答参数; 6. 异步与协程化; 7. Cookie机制; 8. 用户身份认证; 9. 防止跨站攻击; 10. 模板引擎; 11. 服务器回应的数据规范; 12. 部署; 13. WebSocket; 14. 进阶"
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

> [homepage](https://www.osgeo.cn/tornado/)
>
> [cnblog: 浅析tornado_web框架](https://www.cnblogs.com/aylin/p/5702994.html)

## 1. 概述

Tornado是一个可扩展的非阻塞Web服务器以及相关工具的总称。Tornado每秒可以处理数以千计的连接，所以对于实时Web服务来说，Tornado是一个理想的**Web框架**。

+ 完备的 Web 框架：
    * URL路由映射
    * Request上下文
    * 基于模板的页面渲染
+ 性能与 Twisted、Gevent 等底层框架相媲美
    + 异步 I/O 支持
    + 超时事件处理
+ 除了做Web服务，还可以用来做爬虫应用、物联网关、游戏服务器等后台应用
+ 自带组件（强大）
    * 高效的HTTP服务器：可直接用于生产环境！
    * 基于异步框架的HTTPClient
+ 支持WebSocket
+ 丰富的用户身份认证功能

因为 Tornado 的上述特点，Tornado常被用作大型站点的**接口服务框架**，而不像Django那样着眼于建立完整的大型网站。

```py
import tornado.web
import tornado.ioloop

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello")

if __name__ == "__main__":
    app = tornado.web.Application([
            (r"/", MainHandler)
        ])
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()
```

## 2. URL路由映射

1. 固定字串路径

    ```py
    Handlers = [
        ("/", MainHandler),
        ("/entry", EntryHandler),
        ("/entry/2019", Entry2019Handler)
    ]
    ```

2. 正在表达式定义路径

    ```py
    def make_app():
        return tornado.web.Application([
            ("/id/([^/]+)", MainHandler),
        ])
    ```

## 3. 定义Handler的行为函数

`RequestHandler` 是对一类问题处理的单元。

需要子类继承并定义具体行为的函数在RequestHandler中被称为接入点函数(Entry point)，上面的 `Hello World` 实例中的get()函数就是典型的接入点函数。

### 3.1. 默认的回调函数

+ initialize()

    ```py
    class ProfileHandler(RequestHandler):
        def initialize(self,database):
            self.database=database
    ```

+ prepare()

    用于调用请求处理（get、post等）方法之前的初始化处理，通常用来做资源初始化操作。

+ on_finish()

    用于请求处理结束后的一些清理工作，通常用来清理对象占用的内存或者关闭数据库连接等工作。

### 3.2. HTTP Action处理函数

+ RequestHandler.get(*args,**kwargs)
+ RequestHandler.post(*args,**kwargs)
+ RequestHandler.head(*args,**kwargs)
+ RequestHandler.delete(*args,**kwargs)
+ RequestHandler.patch(*args,**kwargs)
+ RequestHandler.put(*args,**kwargs)
+ RequestHandler.options(*args,**kwargs)

## 4. 获取请求参数

输入捕捉是指在RequestHandler中用于获取客户端输入的工具函数和属性。比如获取URL参数、Post提交参数等。

* get_argument(name)、get_arguments(name)

    RequestHandler.get_argument(name) 与 RequestHandler.get_arguments(name) 都是返回给定参数的值。get_argument 是获取单个值, 而 get_arguments 在参数存在多个值得情况下使用，返回多个值的列表。

    注意：使用这两个方法获取的事 URL 中查询的参数与 POST 提交的参数的参数合集。

* get_query_argument(name)、get_query_arguments(name)

    功能与上面两个方法类似，唯一区别是这两个方法仅仅从 URL 中查询参数。

* get_body_argument(name)、get_body_arguments(name)

    功能尚与上面四个方法类似，唯一区别是这两个方法仅仅从 POST 提交的参数中查询。

* get_cookie(name,default=None)

    根据 Cookie 名称获取 Cookie 的值

提示：实际开发中一般会使用 get_argument、get_arguments 这两个方法，因为他们会包含其他方法的查询结果。

### 4.1. RequestHandler.request

返回 tornado.httputil.HTTPServerRequest 对象实例的属性，通过该对象可以获取关于 HTTP 请求的一切信息，比如：

```
class DetailHandler(RequestHandler):
    def get(self):
        ip = self.request.remote_ip  # 获取客户端的IP地址
        host = self.request.host  # 获取请求的主机地址
        result = "ip地址为%s,host为%s"%(ip, host)
        return self.write(result)
```

常用的 httputil.HTTPServerRequest 对象属性如下表：

| 属性名 | 说明 |
| --- | --- |
| method | HTTP 请求方法，例如：GET、POST |
| uri | 客户端请求的 uri 的完整内容。 |
| path | uri 路径名，即不包含查询字符串 |
| query | uri 中的查询字符串 |
| version | 客户端发送请求时使用的 HTTP 版本，例如：HTTP/1.1 |
| headers | 以字典方式的形式返回 HTTP Headers |
| body | 以字符串的形式返回 HTTP 消息体 |
| remote_ip | 客户端的 IP 地址 |
| protocol | 请求协议，例如：HTTP、HTTPS |
| host | 请求消息的主机名 |
| arguments | 客户端提交的所有参数。 |
| files | 以字典形式返回客户端上传的文件，每个文件名对应一个 HTTPFile |
| cookies | 客户端提交的 Cookies 字典 |

## 5. 设置应答参数

* RequestHandler.set_status(status_code,reason=None)

    设置 HTTP Response 中的返回码，如果有描述性的语句，则可以赋值给 reason 参数。

* RequestHandler.set_header(name,value)

    以键值对的方式设置 HTTP Response 中的 HTTP 头参数，使用 set_header 配置的 Header 值将覆盖之前配置的 Header。

* RequestHandler.add_header(name,value)

    以键值对的方式设置 HTTP Response 中的 HTTP 头参数。与 set_header 不同的是 add_header 配置的 Header 值将不会覆盖之前配置的 Header。

* RequestHandler.write(chunk)

    将给定的块作为 HTTP Body 发送客户端。在一般情况下，用本函数输出字符串给客户端。
    如果给定的块是一个字典，则会将这个块以 JSON 格式发送给客户端，同时将 HTTP Header 中的 Content_Type 设置为 application/json.

* RequestHandler.finish(chunk=None)

    本方法通知 Tornado.Response 的生成工作已完成，chunk 参数是需要传递给客户端的 HTTP body。调用 finish() 后，Tornado 将向客户端发送 HTTP Response。
    本方法适用于对 RequestHandler 的异步请求处理，在同步或协程访问处理的函数中，无须调用 finish() 函数。

* RequestHandler.render(template_name,**kwargs)

    用给定的参数渲染模块，可以在本函数中传入模板文件名称和模板参数。

    ```
    import tornado.web
    class MainHandler(tornado.web.RequestHandler):
        def get(self):
            items=["Python","C++","Java"]
            #第一个参数是模板名称，后面是模板参数
            self.render("template.html",title="Tornado Template",items=items)
    ```

* RequestHandler.redirect(url,permanent=False,status=None)

    进行页面重定向。在 RequestHandler 处理过程中，可以随时调用 redirect() 函数进行页面重定向。

* RequestHandler.clear()

    清空所有在本次请求中之前写入的 Header 和 Body 内容。

* RequestHandler.set_cookie(name,value)

    按键值对设置 Response 中的 Cookie 的值。

* RequestHandler.clear_all_cookies(path="/",domain=None)

    清空本次请求中的所有 Cookie。

## 6. 异步与协程化

Tornado有两种方式可改变同步的处理流程：

+ 异步化（已过期，不再讨论）

    针对RequestHandler的处理函数使用 `@tornado.web.asynchronous` 修饰器，将默认的同步机制改为异步机制。该方法已经过期。

+ 协程化

    针对RequestHandler的处理函数使用 `@tornado.gen.coroutine` 修饰器，将默认的同步机制改为协程机制。

Tornado协程结合了同步处理和异步处理的有点，使得代码即清晰易懂，又能够适应海量客户端的高并发请求。

```py
class MainHandler(tornado.web.RequestHandler):
    @tornado.gen.coroutine
    def get(self):
        http = tornado.httpclient.AsyncHTTPClient()
        response = yield http.fetch("http://www.baidu.com")
        self.write(response.body)
```

协程化的关键技术点如下：

+ 用 `@tornado.gen.coroutine` 装饰MainHandler的get()、post()等处理函数。
+ 使用异步对象处理**耗时操作**，比如本例的AsyncHTTPClient。
+ 调用yield关键字获取异步对象的处理结果。

## 7. Cookie机制

Cookie是很多网站为了辨别用户的身份而存储在用户本地终端(Client Side)d的数据，在Tornado中使用RequestHandler.get_cookie()、RequestHandler.set_cookie()可以方便地对Cookie进行读写。

```py
session_id = 1
class MainHandler(tornado.web.RequestHandler):
    def get(self):
        global session_id
        if not self.get_cookie("session"):
            self.set_cookie("session",str(session_id))
            session_id += 1
            self.write("设置新的session")
        else:
            self.write("已经具有session")
```

因为Cookie总是被保存在客户端，所以如何保存其不被篡改是服务器端程序必须解决的问题。Tornado为Cookie提供了信息加密机制，使得客户端无法随意解析和修改Cookie的键值。

```py
class MainHandler(tornado.web.RequestHandler):
    def get(self):
        ...
        if not self.get_secure_cookie("session"):
            #set_secure_cookie代替set_cookie
            self.set_secure_cookie("session",str(session_id))
...

if __name__ == '__main__':
    app=tornado.web.Application([
        ("/",MainHandler)
    ],cookie_secret="JIA_MI_MI_YAO")
    app.listen("8888")
    tornado.ioloop.IOLoop.current().start()
```

对比上面的简单Cookie实例可以发现不同之处：

+ 在 `tornado.web.Application` 对象初始化时赋予 `cookie_secret` 参数，该参数值时一个字符串，用于保存本网站Cookie加密时的密钥。
+ 读取: 使用 `RequestHandler.get_secure_cookie` 代替原来的get_cookie()。
+ 写入: 用 `RequestHandler.set_secure_cookie` 替换原来的set_cookie()。

这样，就不需要担心Cookie伪造的问题了，但是cookie_secret参数值作为加密密钥，需要好好保护，不能泄露。

## 8. 用户身份认证

在RequestHandler类中有一个 `current_user` 属性用于保存当前请求的用户名。`RequestHandler.get_current_user` 的默认值是None，在get()、post()等处理函数中可以随时读取该属性以获取当前的用户名。`RequestHandler.current_user` 是一个只读属性，所以如果想要设置该属性值，需要重载 `RequestHandler.get_current_user()` 函数以设置该属性值。

使用 `current_user` 属性及 `get_current_user()` 方法来实现用户身份控制。

```py
import tornado.web
import tornado.ioloop
import uuid  # UUID 生成库

dict_sessions = {}  # 保存所有登录的Session

class BaseHandler(tornado.web.RequestHandler):  #公共基类
    #写入current_user的函数
    def get_current_user(self):
        session_id=self.get_secure_cookie("session_id")
        return dict_sessions.get(session_id)

class MainHandler(BaseHandler):
    @tornado.web.authenticated  #需要身份认证才能访问的处理器
    def get(self):
        name=tornado.escape.xhtml_escape(self.current_user)
        self.write("Hello,"+name)

class LoginHandler(BaseHandler):
    def get(self):   #登陆页面
        self.write('<html><>body'
                   '<form action="/login" method="post">'
                   'Name:<input type="text" name="name">'
                   '<input type="submit" value="Sign in">'
                   '</form></body></html>')
    def post(self):  #验证是否运行登陆
        if len(self.get_argument("name"))<3:
            self.redirect("/login")
        session_id=str(uuid.uuid1())
        dict_sessions[session_id]=self.get_argument("name")
        self.set_secure_cookie("session_id",session_id)
        self.redirect("/")

setting = {
    "cookie_secret":"SECRET_DONT_LEAK", #Cookie加密秘钥
    "login_url":"/login"  #定义登陆页面
}

application = tornado.web.Application([
    (r"/",MainHandler),        #URL映射定义
    (r"/login",LoginHandler)
],**setting)

if __name__ == '__main__':
    application.listen(8888)
    tornado.ioloop.IOLoop.current().start()     #挂起监听
```

注意：加入身份认证的所有页面处理器需要继承自BaseHandler类，而不是直接继承原来的tornado.web.RequestHandler类。

## 9. 防止跨站攻击

跨站请求伪造（Cross-site request forgery，CSRF 或XSRF）是一种对网站的恶意利用。通过CSRF，攻击者可以冒用用户的身份，在用户不知情的情况下执行恶意操作。

下图展示了 CSRF 的基本原理。其中 Site1 是存在 CSRF 漏洞的网站，而 SIte2 是存在攻击行为的恶意网站。

![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200709183508173-1334726594.jpg) <!-- tornado-start/tornado-start-0.jpg -->

上图内容解析如下：

1. 用户首先访问了存在 CSRF 漏洞网站 Site1，成功登陆并获取了 Cookie，此后，所有该用户对 Site1 的访问均会携带 Site1 的 Cookie，因此被 Site1 认为是有效操作。

1. 此时用户又访问了带有攻击行为的站点 Site2，而 Site2 的返回页面中带有一个访问 Site1 进行恶意操作的连接，但却伪装成了合法内容，比如下面的超链接看上去是一个抽奖信息，实际上却是想 Site1 站点提交提款请求

    ```html
    <a href='http:三百万元抽奖，免费拿' >
    ```

1. 用户一旦点击恶意链接，就在不知情的情况下向 Site1 站点发送了请求。因为之前用户在 Site1 进行过登陆且尚未退出，所以 Site1 在收到用户的请求和附带的 Cookie 时将被认为该请求是用户发送的正常请求。此时，恶意站点的目的也已经达到。

为了防范 CSRF 攻击，要求每个请求包括一个参数值作为令牌的匹配存储在 Cookie 中的对应值。

Tornado 应用可以通过一个 Cookie 头和一个隐藏的 HTML 表单元素向页面提供令牌。这样，当一个合法页面的表单被提交时，它将包括表单值和已存储的 Cookie。如果两者匹配，则 Tornado 应用认可请求有效。

开启 Tornado 的 CSRF 防范功能需要两个步骤。

1. 开启 `xsrf_cookies=True` 参数：

    ```py
    application=tornado.web.Application([
            (r'/',MainHandler),
        ],
        cookie_secret='DONT_LEAK_SECRET',
        xsrf_cookies=True,
    )
    ```

2. 在每个具有 HTML 表达的模板文件中，为所有表单添加 xsrf_form_html() 函数标签：

    ```html
    <form action="/login" method="post">
        {% module xsrf_form_html() %}  # 为表单添加隐藏元素以防止跨站请求
        <input type="text" name="message"/>
        <input type="submit" value="Post"/>
    </form>
    ```

    这里的 {% module xsrf_form_html() %}起到了为表单添加隐藏元素以防止跨站请求的作用。

Tornado的**安全Cookie**支持和**XSRF防范框架**减轻了应用开发者的很多负担，没有他们，开发者需要思考很多防范的细节措施，因此Tornado内建的安全功能也非常有用。

## 10. 模板引擎

Tornao中的模板语言和django中类似，模板引擎将模板文件载入内存，然后将数据嵌入其中，最终获取到一个完整的字符串，再将字符串返回给请求者。

Tornado的模板支持 **控制语句**和 **表达语句**，控制语句是使用 `{%` 和 `%}` 包起来的 例如 {% if len(items) > 2 %}。表达语句是使用 `{{` 和 `}}` 包起来的，例如 `{{ items[0] }}` 。

控制语句和对应的 Python 语句的格式基本完全相同。我们支持 if、for、while 和 try，这些语句逻辑结束的位置需要用 `{% end %}` 做标记。还通过 extends 和 block 语句实现了模板继承。

> Tornado-templating 与 Jinja2 的区别
>
> The main difference is: Tornado templating is part of the Tornado webserver. Jinja is a templating engine with a lot of features, which can be used by other WSGI web frameworks.
>
> Tornado's template system is not packaged separately (or documented very well), but you can use it without touching Tornado's http-serving components. So you could use tornado templates from any other framework or server if you want to.
>
> 只是没有从tornado中独立出来而已，但本质上与tornado-web松耦合，可以实现与Jinja2的互换。

*注：在使用模板前需要在setting中设置模板路径："template_path" : "views"*

```py
settings = {
    'template_path':'views',             #设置模板路径，设置完可以把HTML文件放置views文件夹中
    'static_path':'static',              # 设置静态模板路径，设置完可以把css，JS，Jquery等静态文件放置static文件夹中
    'static_url_prefix': '/sss/',        #导入时候需要加上/sss/，例如<script src="/sss/jquery-1.9.1.min.js"></script>
    'cookie_secret': "asdasd",           #cookie生成秘钥时候需提前生成随机字符串，需要在这里进行渲染
    'xsrf_cokkies':True,                 #允许CSRF使用
}
application = tornado.web.Application([
        (r'/index',IndexHandler)
    ], **settings)                       #需要在这里加载
```

## 11. 服务器回应的数据规范

### 11.1. 不要返回纯本文

API返回的数据格式，不应该是纯文本，而应该是一个 `JSON` 对象，因为这样才能返回标准的结构化数据。所以，服务器回应的HTTP头的Content-Type属性要设为 `application/json` 。

客户端请求时，也要明确告诉服务器，可以接受 JSON 格式，即请求的 HTTP 头的ACCEPT属性也要设成application/json。下面是一个例子。

```
GET /orders/2 HTTP/1.1
Accept: application/json
```

### 11.2. 发生错误时，不要返回 200 状态码

有一种不恰当的做法是，即使发生错误，也返回200状态码，把错误信息放在数据体里面，就像下面这样。

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "failure",
  "data": {
    "error": "Expected at least two items in list."
  }
}
```

上面代码中，解析数据体以后，才能得知操作失败。

这张做法实际上取消了状态码，这是完全不可取的。正确的做法是，状态码反映发生的错误，具体的错误信息放在数据体里面返回。下面是一个例子。

```
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": "Invalid payoad.",
  "detail": {
     "surname": "This field is required."
  }
}
```

### 11.3. 提供链接

API的使用者未必知道，URL是怎么设计的。一个解决方法就是，在回应中，给出相关链接，便于下一步操作。这样的话，用户只要记住一个URL，就可以发现其他的URL。这种方法叫做 `HATEOAS` 。

举例来说，GitHub的API都在 `api.github.com` 这个域名。访问它，就可以得到其他URL。

```
{
  ...
  "feeds_url": "https://api.github.com/feeds",
  "followers_url": "https://api.github.com/user/followers",
  "following_url": "https://api.github.com/user/following{/target}",
  "gists_url": "https://api.github.com/gists{/gist_id}",
  "hub_url": "https://api.github.com/hub",
  ...
}
```

上面的回应中，挑一个 URL 访问，又可以得到别的 URL。对于用户来说，不需要记住 URL 设计，只要从 api.github.com 一步步查找就可以了。

HATEOAS 的格式没有统一规定，上面例子中，GitHub 将它们与其他属性放在一起。更好的做法应该是，将相关链接与其他属性分开。

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "In progress",
   "links": {[
    { "rel":"cancel", "method": "delete", "href":"/api/status/12345" } ,
    { "rel":"edit", "method": "put", "href":"/api/status/12345" }
  ]}
}
```

## 12. 部署

之前着重讲解Tornado的编程知识点，所有之前的例子都使用最简单的IOLoop启动方式运行。本节学习如何优化Tornado的运行方式，以达到快捷、易用及资源利用优化的目的。

### 12.1. WebServer的debug运行模式

+ py文件的更新后，自动重启Sevser程序；
+ 错误追溯，显示到浏览器中；
+ 禁用模板缓存

    在运营环境中模板缓存能提高效率，但在调试期间占用了更多的系统资源，所以将其禁用有利于开发者进行调试。

```py
def make_app():
    return tornado.web.Application([
            #此处写入映射
        ],
        debug=True  #调试模式
    )
```

### 12.2. 支持 `Ctrl+C` 退出

```py
try:
    tornado.ioloop.IOLoop.current().start()
except KeyboardInterrupt:
    tornado.ioloop.IOLoop.current().stop()
    # 此处执行资源回收工作
    print("Program exit!")
```

### 12.3. 部署静态文件

#### 12.3.1. 配置对URL路径

```py
def make_app():
    return tornado.web.Application([
            #此处写入映射
        ],
        static_path=os.path.join(os.path.dirname(__file__),'static'),
        static_url_prefix="/_static/"  # 挂载点，默认为"/static/"
    )
```

#### 12.3.2. StaticFileHandler

如果除了http://mysite.com/static目录还有其他存放静态文件的URL，则可以用RequestHandler的子类StaticFileHandler进行配置，比如：

```py
def make_app():
    return tornado.web.Application([
            #此处写入映射

            #这里配置了3个StaticFileHandler
            (r'/css/(.*)',tornado.web.StaticFileHandler,{'path':'assets/css'}),
            (r'/images/png/(.*)',tornado.web.StaticFileHandler,{'path':'assets/image'}),
            (r'/js/(.*)',tornado.web.StaticFileHandler,{'path':'assets/js','default_filename':'templates/index.html'}),
        ],
        static_path=os.path.join(os.path.dirname(__file__),'static')
    )
```

本例中除了static_path，还用StaticFileHandler配置了另外3个静态文件目录。

+ 所有对 `http://mysite.com/css/*` 的访问被映射到相对路径assets/css中。
+ 对 `http://mysite.com/images/png/*` 的访问被映射到assets/images目录中。
+ 对 `http://mysite.com/js/*` 的访问被映射到assets/js目录中；该条StaticFileHandler的参数中还被配置了 `default_filename` 参数，即当用户访问了 `http://mysite.com/js` 目录本身时，将返回 `templates/index.html` 文件。

#### 12.3.3. 优化静态文件访问（缓存以减少重复传送）

优化静态文件访问的目的在于减少静态文件的重复传送，提高网络及服务器的利用效率，通过在模板文件中用static_url方法修饰静态文件链接可以达到这个目的：

```html
<html>
    <body>
        <div><img src="{{static_url('images/logo.png')}}"/><div>
    </body>
</html>
```

本例中的静态图像链接将被设置为类似 `/static/images/logo.png?v=5ad4e` 的形式，其中的 `v=5ad4e` 是logo.png文件内容的哈希值，当Tornado静态文件处理器发现该参数时，将通知浏览器该文件可以无限期缓存，因此避免了之后访问该文件时的反复传输。

## 13. WebSocket
> [Tornado 第三章：HTML5 WebSocket概念及应用](https://segmentfault.com/a/1190000016673153)

## 14. 进阶

### 14.1. 线程安全注意事项

一般来说，方法 RequestHandler 在 Tornado 的其他地方是**不安全**的。尤其是方法，如 write() ， finish() 和 flush() 只能从主线程调用。如果使用多个线程，则必须使用 IOLoop.add_callback 在完成请求之前将控制权转移回主线程，或者将其他线程的使用限制为 IOLoop.run_in_executor 并确保在执行器中运行的回调不会引用Tornado对象。
