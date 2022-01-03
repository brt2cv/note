<!--
+++
title       = "mail邮件操作"
description = "1. 概念; 2. python::smtplib"
date        = "2022-01-03"
tags        = []
categories  = ["3-syntax","33-python","3rd-modules"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

___

## 1. 概念

### 1.1. 常见的类型

+ Mail User Agent
    + 收发邮件用的，类似浏览器的作用。例如：mail,mailx,ssmtp,msmtp
+ Mail Transport Agent
    + 邮件服务器，类似apache, nginx的作用。例如：sendmail,postfix

### 1.2. 相关协议

+ SMTP: Simple Mail Transfer Protocol，即简单邮件传输协议，用来发送电子邮件；
+ POP3: Post Office Protocol-Version3，它是因特网电子邮件的第一个离线协议标准，POP3允许用户从服务器上把邮件存储到本地主机（即自己的计算机）上，同时删除保存在邮件服务器上的邮件。
+ IMAP: Internet Mail Access Protocol，不同于POP3，开启了IMAP后，您在电子邮件客户端收取的邮件仍然保留在服务器上，同时在客户端上的操作都会反馈到服务器上。

### 1.3. SMTP协议

SMTP认证，简单地说就是要求必须在提供了账户名和密码之后才可以登录 SMTP 服务器，这就使得那些垃圾邮件的散播者无可乘之机。

增加 SMTP 认证的目的是为了使用户避免受到垃圾邮件的侵扰。

> Looks like sSMTP is no longer maintained, MSMTP is the suggested replacement.

如果服务器选择"localhost"，那么你需要在本机跑一个MTA（例如sendmail）。否则也无法成功发送邮件。但如果仅仅为了发送一封邮件而开启本地服务，是不是太不值得了呢？！

所以建议还是通过smtp连接外部服务器吧，比如126邮箱……

## 2. python::smtplib

```py
import smtplib
from email.message import EmailMessage

class Mail:
    map_host2server = {
        "163.com"   : "smtp.163.com",
        "126.com"   : "smtp.126.com",
        # "qq.com"    : "smtp.qq.com",
    }

    def __init__(self, user, passwd):
        self.uid = user

        mail_host = self.uid.split("@")[1]
        try:
            mail_server = self.map_host2server[mail_host]
        except KeyError:
            raise MailServerNotSupported()

        # smtp_server = smtplib.SMTP_SSL(mail_server, 465)
        self.smtp = smtplib.SMTP(mail_server)  # 使用非SSL协议端口号25
        self.smtp.login(self.uid, passwd)

    def send(self, target, content, title=None):
        msg = EmailMessage()
        msg.set_content(content)

        if not title:
            title = content[:20]
            lines = title.split("\n")
            if len(lines) > 1:
                title = lines[0]
            else:
                title = title[:17] + "..."

        msg['Subject'] = title
        msg['From'] = self.uid
        msg['To'] = target

        # Send the message via our own SMTP server.
        try:
            self.smtp.send_message(msg)
        except smtplib.SMTPDataError as e:
            print("发送失败，可能遭到了接收服务器拒绝...具体信息如下：")
            print(e)
        else:
            print("邮件已发送！")
```
