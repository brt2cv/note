<!--
+++
title       = "从大厂DevOps工具链部署，看现代产品的生命周期管理"
description = "1. 认识DevOps; 2. DevOps 最佳实践; 3. Gitea; 4. Gradle; 5. Jenkins; 6. Ansible; 7. Nagios; 8. Raygun"
date        = "2022-01-03"
tags        = []
categories  = ["5-框架应用"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

___

## 1. 认识DevOps

DevOps 一词的来自于 Development 和 Operations 的组合，突出重视软件开发人员和运维人员的沟通合作，通过自动化流程来使得软件构建、测试、发布更加快捷、频繁和可靠。DevOps 其实包含了三个部分：开发、测试和运维。换句话 DevOps 希望做到的是软件产品交付过程中IT工具链的打通，使得各个团队减少时间损耗，更加高效地协同工作。

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200605135741465-1578675782.jpg) <!-- DevOps/DevOps1.jpg -->

DevOps目前并没有权威的定义，网易云团队认为，DevOps 强调的是高效组织团队之间如何通过自动化的工具协作和沟通来完成软件的生命周期管理，从而更快、更频繁地交付更稳定的软件。

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200605135741879-1937163483.jpg) <!-- DevOps/DevOps0.jpg -->

### 1.1. DevOps工具链
> [DevOps Bookmarks](http://www.devopsbookmarks.com/)
>
> [王教授: 搭建DevOps工具链](https://library.prof.wang/handbook/h/hdbk-MWnS99ThmLVDi7U5mVFrB9#toc21)

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200605135742169-122970758.jpg) <!-- DevOps/DevOps2.jpg -->

上文提到了工具链的打通，那么工具自然就需要做好准备。现将工具类型及对应的不完全列举整理如下：

* 代码管理（SCM）：GitHub、GitLab、**Gitea**、BitBucket、SubVersion
* 持续集成（CI）：Bamboo、Hudson、Jenkins
* 构建工具：Apache Ant、**Gradle**、maven、Selenium、PyUnit
* 自动部署：Capistrano、CodeDeploy
* 配置管理：**Ansible**、Chef、Puppet、SaltStack、ScriptRock GuardRail
* 容器：Docker、LXC、第三方厂商如AWS
* 编排：Kubernetes、Core、Apache Mesos、DC/OS
* 微服务平台：OpenShift、Cloud Foundry、Kubernetes、Mesosphere
* 服务开通：Puppet、Docker Swarm、Vagrant、Powershell、OpenStack Heat
* 服务注册与发现：**Zookeeper**、etcd、Consul
* 脚本语言：python、ruby、shell
* 日志管理：Logstash、CollectD、StatsD、ELK、Logentries
* 系统监控：Datadog、Graphite、Icinga、Nagios
* 性能监控：AppDynamics、New Relic、Splunk
* 压力测试：JMeter、Blaze Meter、loader.io
* 预警：PagerDuty、pingdom、厂商自带如AWS SNS
* HTTP加速器：Varnish
* 消息总线：ActiveMQ、SQS
* 应用服务器：Tomcat、JBoss
* Web服务器：Apache、Nginx、IIS
* 数据库：MySQL、Oracle、PostgreSQL + cassandra、mongoDB、redis
* 项目管理（PM）：Jira、Asana、Taiga、Trello、Basecamp、Pivotal Tracker

在工具的选择上，需要结合公司业务需求和技术团队情况而定。（注：更多关于工具的详细介绍可以参见此文：51 Best DevOps Tools for #DevOps Engineers）

### 1.2. CI 持续集成（Continuous Integration）

现代应用开发的目标是让多位开发人员同时处理同一应用的不同功能。但是，如果企业安排在一天内将所有分支源代码合并在一起（称为“合并日”），最终可能造成工作繁琐、耗时，而且需要手动完成。这是因为当一位独立工作的开发人员对应用进行更改时，有可能会与其他开发人员同时进行的更改发生冲突。如果每个开发人员都自定义自己的本地集成开发环境（IDE），而不是让团队就一个基于云的 IDE 达成一致，那么就会让问题更加雪上加霜。

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200605135742419-713039314.jpg) <!-- DevOps/DevOps3.jpg -->

CI的目的在于，开发人员不断的将琐碎的代码片段提交到master上，系统会自动进行自动化测试（单元测试、集成测试和兼容性验证），并将问题反馈给开发者及时修正，从而降低对其他合作开发者的影响，而不是到“合并日”把每个人的问题混淆到一起集中处理。

通过了单元测试，代码才会最终合并进入主干分支。

> 似乎有点儿绕来绕去的还有专业名词，云里雾里的感jio，简单的描述即开发者提交代码到git或svn上，自动触发源码的构建（Build）、集成（Integration）及各种测试（Test）。这里的SCM即Software Configuration Management的简写，一直以来我以为SCM指的是Source Code/Control Management，其实也差不多啦，就是源码、版本控制工具，例如：svn、git都是SCM的一种（蔬菜是SCM，胡萝卜是git、白萝卜是svn来理解啦，是那么个意思就好）；这里的Build和Integration不同的编程语言里可以理解成各自不同的动作，传统的C/C++项目乃至java项目均有Build过程，大致理解是那个意思即可，就是从源码构造成二进制程序或源码与二进制文件之间的中间形式文件的过程，PHP项目是不需要Build过程的，不过可以借用Build这种概念做一些准备性的“构建”动作。

### 1.3. CD（持续交付 & 持续部署）

对于一个成熟的CI/CD管道（Pipeline）来说，最后的阶段是持续部署。作为持续交付——自动将生产就绪型构建版本发布到代码存储库——的延伸，持续部署可以自动将应用发布到生产环境。

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200605135742647-976590531.jpg) <!-- DevOps/DevOps4.jpg -->

持续部署意味着所有的变更都会被自动部署到生产环境中。持续交付意味着所有的变更都可以被部署到生产环境中，但是出于业务考虑，可以选择不部署。如果要实施持续部署，必须先实施持续交付。

<font color=#FF0000>持续交付并不是指软件每一个改动都要尽快部署到产品环境中，它指的是任何的代码修改都可以在任何时候实施部署。</font>

<font color=#FF0000>持续交付表示的是一种能力，而持续部署表示的则一种方式。</font>持续部署是持续交付的最高阶段。

### 1.4. Agile Development

另外一个概念，也就是所谓的敏捷开发，而且这个称呼似乎在国内被滥用了。敏捷开发着重于一种开发的思路，拥抱变化和快速迭代。如何实现敏捷开发，<font color=#FF0000>目前似乎尚没有完善的工具链，更多的是一种概念性</font>，调侃的说就是“既想马尔跑得快，又想马儿不吃草”。

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200605135742856-653768679.jpg) <!-- DevOps/DevOps5.jpg -->

上图揭示了敏捷开发的一些内涵和目标，似乎有点儿一本真经的胡说八道的意思。


## 2. DevOps 最佳实践

自 2009 年提出 DevOps 的概念起，很多公司都开始实施 DevOps，国外比较著名的有 Amazon 、Google、Facebook 等，国内著名的有百度、华为、阿里等。Amazon 是 DevOps 最佳实践的最有说服力的代表之一。

*   flickr

    最全面最经典的是 flickr 的 [10+ deploys per day](https://www.slideshare.net/jallspaw/10-deploys-per-day-dev-and-ops-cooperation-at-flickr)，简直是 DevOps 教科书般的存在。

*   百度

    百度技术团队是如何利用 DevOps: [解密百度持续交付方法与实践](https://dbaplus.cn/news-21-471-1.html)

*   Netflix

    解密 Netflix 技术团队在整个 DevOps 过程中使用的部署工具和服务: [How We Build Code at Netflix](https://techblog.netflix.com/2016/03/how-we-build-code-at-netflix.html)

*   Etsy

    2009 年，Etsy 建立自己的工具来更好更快地部署发布: [Etsy 如何应用 DevOps](https://www.networkworld.com/article/2886672/software/how-etsy-makes-devops-work.html)

*   LinkedIn

    2009 年，LinkedIn 团队就开始使用自动化部署工具，用于管理在 1000 + 节点环境下发布上千个应用 / 服务的复杂性。这是 LinkedIn 自己造的轮子: [Deployment and Monitoring Automation with glu](https://devops.com/2014/04/02/deployment-and-monitoring-automation-glu/)

*   Airbnb

    Airbnb 作为第三方平台公司，需要迅速发布多个小型部署。关于 Airbnb 的数据和基础设施，可以参考这个: [slides](https://www.slideshare.net/InfoQ/data-infrastructure-at-airbnb)

*   Starbucks

    星巴克的 DevOps 计划: [Starbucks Announces #DevOpsTogether](https://medium.com/%40cloud_opinion/starbucks-announces-devopstogether-2933aad59d74)

*   Ancestry.com

    [http://Ancestry.com](https://Ancestry.com) 是 DevOps 运动的早期采用者，是 Continuous Delivery 和 DevOps 运动的先锋。想了解更多关于他们的过程、迁移和 DevOps 文化，不妨查看一下他们的系列文章 [DevOps – Tech Roots](https://blogs.ancestry.com/techroots/category/devops/)

## 3. Gitea
> [Gitea中文文档](https://docs.gitea.io/zh-cn/)

功能特性

+ 支持活动时间线
+ 支持 <font color=#FF0000>SSH 以及 HTTP/HTTPS</font> 协议
+ 支持 SMTP、LDAP 和反向代理的用户认证
+ 支持反向代理子路径
+ 支持用户、组织和仓库管理系统
+ 支持添加和删除仓库协作者
+ 支持仓库和组织级别 Web 钩子（包括 Slack 集成）
+ 支持仓库 <font color=#FF0000>Git 钩子</font>和部署密钥
+ 支持<font color=#FF0000>仓库工单（Issue）、合并请求（Pull Request）以及 Wiki</font>
+ 支持迁移和镜像仓库以及它的 Wiki
+ 支持在<font color=#FF0000>线编辑仓库文件和 Wiki</font>
+ 支持自定义源的 Gravatar 和 Federated Avatar
+ 支持<font color=#FF0000>邮件服务</font>
+ 支持后台管理面板
+ 支持 MySQL、PostgreSQL、SQLite3, MSSQL 和 TiDB（实验性支持） 数据库
+ 支持多语言本地化（21 种语言）

### 3.1. Gitea的部署和使用（Docker）

```sh
docker pull gitea/gitea:latest

# 如果要将git和其它数据持久化，你需要创建一个目录来作为数据存储的地方
sudo mkdir -p /var/lib/gitea

# 然后就可以运行 docker 容器了，这很简单。 当然你需要定义端口数数据目录
docker run -d --name=gitea -p 10022:22 -p 10080:3000 -v /var/lib/gitea:/data gitea/gitea:latest
```

然后 容器已经运行成功，在浏览器中访问 http://hostname:10080 就可以看到界面了。你可以尝试在上面创建项目，clone操作 `git clone ssh://git@hostname:10022/username/repo.git`

注意：目前端口改为非3000时，需要修改配置文件 LOCAL_ROOT_URL = http://localhost:3000/。

#### 3.1.1. 配置SSH
> [homepage](https://docs.gitea.io/en-us/install-with-docker/)

由于docker运行的gitea，其ssh服务是运行在容器中的，所以有必要在主机里配置SSH的转发，操作如下。

1. 创建git用户，其UID & GID要与容器的git账户一致

    主机创建用户：

    ```sh
    groupadd -g 899 git
    useradd -d /home/git -u 899 -g 899 git

    mkdir /home/git  # uid<1000不会自动创建主目录
    chown git /home/git

    chown git /home/docker/gitea/
    ```

    容器增加环境变量environment（容器自动修改git用户的UID & GID）:

    * USER_UID=899
    * USER_GID=899

2. 主机创建ssh转发脚本

    ```sh
    sudo mkdir -p /app/gitea/
    sudo touch /app/gitea/gitea
    sudo chmod +x /app/gitea/gitea
    sudo vi /app/gitea/gitea
    ```

    内容如下：

    ```sh
    #!/bin/sh
    ssh -p 10022 -o StrictHostKeyChecking=no git@127.0.0.1 "SSH_ORIGINAL_COMMAND=\"$SSH_ORIGINAL_COMMAND\" $0 $@"
    ```

3. git用户需要生成一个SSH密钥

    ```sh
    sudo -u git ssh-keygen -t rsa -b 4096 -C "Gitea Host Key"
    ```

3. 将容器 `.ssh/authorized_keys` 文件符号链接到您的git用户 `.ssh/authorized_keys`

    ```sh
    ln -s /home/docker/gitea/git/.ssh/authorized_keys /home/git/.ssh/authorized_keys
    ```

4. 将git用户SSH密钥回显到authenticated_keys文件中，以便主机可以通过SSH与容器进行对话

    ```sh
    echo "no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty $(cat /home/git/.ssh/id_rsa.pub)" >> /home/docker/gitea/git/.ssh/authorized_keys
    ```

请注意：SSH容器传递仅在容器中使用opensshd时才有效，并且 `AuthorizedKeysCommand` 与 `SSH_CREATE_AUTHORIZED_KEYS_FILE=false` 禁用授权文件密钥生成的设置结合使用时将不起作用 。

### 3.2. 常见配置项
> [homepage](https://docs.gitea.io/zh-cn/config-cheat-sheet/)

如果你也用的是docker，那么直接修改 `/data/gitea/gitea/conf/app.ini` 即可。

#### 3.2.1. attachment: 附件

```
[attachment]
PATH = /data/gitea/attachments
MAX_SIZE = 2048
ALLOWED_TYPES = */*
```

+ ENABLED: 是否允许用户上传附件。
+ PATH: 附件存储路径
+ ALLOWED_TYPES: 允许上传的附件类型。比如：image/jpeg|image/png，用 `*/*` 表示允许任何类型。
+ MAX_SIZE: 附件最大限制，单位 MB，比如： 4
+ MAX_FILES: 一次最多上传的附件数量，比如： 5

#### 3.2.2. server

```sh
[server]
APP_DATA_PATH    = /data/gitea
DOMAIN           = 192.168.0.192
SSH_DOMAIN       = 192.168.0.192
HTTP_PORT        = 3000
ROOT_URL         = http://192.168.0.192:3000/
DISABLE_SSH      = false
SSH_PORT         = 22
SSH_LISTEN_PORT  = 22
```

+ PROTOCOL = http

    默认使用'http'，也支持'https','unix','fcgi'

+ START_SSH_SERVER = false

    是否使用内部的SSH服务

### 3.3. 更改 Gitea 外观

Gitea 目前由两种内置主题，分别为默认 `gitea` 主题和深色主题 `arc-green` ，您可以通过修改 `app.ini ui` 部分的 `DEFAULT_THEME` 的值来变更至一个可用的外观。

### 3.4. 备份与恢复

Gitea 已经实现了 dump 命令可以用来备份所有需要的文件到一个zip压缩文件。该压缩文件可以被用来进行数据恢复。

```sh
su git  # 转到git用户的权限
gitea dump
```

一般会显示类似如下的输出：

```
2016/12/27 22:32:09 Creating tmp work dir: /tmp/gitea-dump-417443001
2016/12/27 22:32:09 Dumping local repositories.../home/git/gitea-repositories
2016/12/27 22:32:22 Dumping database...
2016/12/27 22:32:22 Packing dump files...
2016/12/27 22:32:34 Removing tmp work dir: /tmp/gitea-dump-417443001
2016/12/27 22:32:34 Finish dumping in file gitea-dump-1482906742.zip
```

最后生成的 gitea-dump-1482906742.zip 文件将会包含如下内容：

+ custom - 所有保存在 custom/ 目录下的配置和自定义的文件。
data - 数据目录下的所有内容不包含使用文件session的文件。该目录包含 attachments, avatars, lfs, indexers, 如果使用sqlite 还会包含 sqlite 数据库文件。
+ gitea-db.sql - 数据库dump出来的 SQL。
+ gitea-repo.zip - Git仓库压缩文件。
+ log/ - Logs文件，如果用作迁移不是必须的。

中间备份文件将会在临时目录进行创建，如果您要重新指定临时目录，可以用 --tempdir 参数，或者用 TMPDIR 环境变量。

### 3.5. Code Review



### 3.6. Email 通知

#### 3.6.1. Sendmail 配置

注意：该方式适用于本机安装了sendmail服务程序的Linux系统。如果Gitea使用Docker搭建，Docker内不含sendmail_service，所以不支持该方式发送邮件。

```
[mailer]
ENABLED       = true
FROM          = gitea@mydomain.com
MAILER_TYPE   = sendmail
SENDMAIL_PATH = /usr/sbin/sendmail
```

#### 3.6.2. SMTP version

示例：

```
[mailer]
ENABLED        = true
HOST           = smtp.gmail.com:465
FROM           = example@gmail.com
USER           = example@gmail.com
PASSWD         = ***
MAILER_TYPE    = smtp
IS_TLS_ENABLED = true
HELO_HOSTNAME  = example.com
```

重新启动Gitea，使配置更改生效。

要发送测试电子邮件以验证设置，请转至 `Gitea > Site Administration > Configuration > SMTP Mailer Configuration` 。

有关选项的完整列表，请参阅 [配置备忘单](https://docs.gitea.io/zh-cn/config-cheat-sheet/)

### 3.7. Gitea API 使用指南
> [homepage](https://try.gitea.io/api/swagger)

### 3.8. CI/CD solutions
> [homepage](https://docs.gitea.io/zh-cn/ci-cd/)

+ Drone with Gitea documentation
+ Jenkins with Gitea plugin
+ Agola
+ Buildkite with Gitea connector
+ AppVeyor with built-in Gitea support
+ Buildbot with Gitea plugin

### 3.9. 打包：生成bin程序包
> [嵌入式数据提取工具](https://docs.gitea.io/zh-cn/cmd-embedded/)

Gitea的可执行文件包含运行所需的所有资源：模板，图像，样式表和翻译。通过在custom目录内的匹配路径中放置替换项，可以覆盖它们中的任何一个（请参阅[定制Gitea](https://docs.gitea.io/zh-cn/customizing-gitea/)）。

要获取准备好编辑的嵌入式资源的副本，embedded可以从OS Shell界面使用CLI 的命令。

注意：嵌入式数据提取工具包含在Gitea 1.12及更高版本中。

#### 3.9.1. 列出资源

例: 列出所有嵌入文件openid及其路径：

```sh
$ gitea embedded list '**openid**'
public/img/auth/openid_connect.svg
public/img/openid-16x16.png
templates/user/auth/finalize_openid.tmpl
templates/user/auth/signin_openid.tmpl
templates/user/auth/signup_openid_connect.tmpl
templates/user/auth/signup_openid_navbar.tmpl
templates/user/auth/signup_openid_register.tmpl
templates/user/settings/security_openid.tmpl
```

#### 3.9.2. 提取资源

`gitea [--config {file}] embedded extract [--destination {dir}|--custom] [--overwrite|--rename] [--include-vendored] {patterns...}`

如果配置文件不在默认位置，该 `--config` 选项会告诉gitea `app.ini` 位置。此选项仅与 `--custom` 标志一起使用。

## 4. Gradle

Maven和Ant使用XML配置，Gradle则引入了一种基于Groovy的DSL来描述build。在2016年，Gradle团队还发布了一种基于Kotlin的DSL，因此用户现在也可以用Kotlin来编写build的脚本。这意味着Gradle的学习需要一定的时间，如果你以前用过Groovy，Kotlin或其他JVM语言的话，那么会有助于Gradle的快速掌握。除此之外，Gradle使用Maven的repository格式，因此如果使用过Maven的话对Gradle的依赖管理也会比较熟悉。还可以将Ant build导入进Gradle。

Gradle最好的设计是增量build，因此可以节省大量的编译时间。根据Gradle的性能报告，它比Maven快100倍。这样的性能优势一部分来源于这种增量设计，另外也得益于Gradle的build缓存和daemon。build缓存重用task的输出，而Gradle的Daemon将build的信息储存在内存里，可以在多个build间共享。

总的来说，Gradle让快速交付成为可能，也让配置更加灵活。

## 5. Jenkins

使用Jenkins很容易，它在Windows，Mac OS X和Linux上开箱即用。很容易就可以使用Docker安装它。用户可以通过浏览器搭建并且配置Jenkins服务器。如果你是第一次使用它，可以选择安装最常用的插件。当然也可以创建自定义配置。

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200605135743082-1507063262.jpg) <!-- DevOps/DevOps6.jpg -->

使用Jenkins，用户可以尽快迭代并部署新代码。它还帮助用户度量流水线里每一步是否成功。我听到有人抱怨Jenkins很“丑陋”且并不直观的UI。但是，我仍旧可以很容易地找到需要的所有东西。

## 6. Ansible

Ansible是一个配置管理工具，和Puppet，Chef类似。用户可以用它配置自己的基础架构并且自动化部署。和其他类似的DevOps工具相比，它的主要卖点是简洁易用。Ansible遵循和Puppet一样的基础架构即代码（IAC）的理念。但是，<font color=#FF0000>它使用超级简单的YAML语法</font>。使用Ansible，用户可以在YAML里定义任务，而Puppet则有自己的声明式语言。

无代理的架构是另一个经常被提及的Ansible的特性。因为后台没有运行daemon或者代理，Ansible是安全并且轻量级的配置管理自动化的解决方案。和Puppet类似，Ansible也有一些模块。

## 7. Nagios

Nagios是最流行的免费并开源的DevOps监控工具。它可以监控基础架构从而帮助用户发现并解决问题。使用Nagios，用户可以记录事件，运行中断以及故障。用户还可以通过Nagios的图表和报告监控趋势。这样，可以预测运行中断和错误，并且发现安全攻击。

Nagios提供了四中开源监控解决方案：

+ Nagios Core: 命令行工具，提供了所有基本功能
+ Nagios XI: Web-GUI
+ Nagios Log Server: 让用户可以搜索日志数据，并且配置可能攻击的报警
+ Nagios Fusion: 可以同时监控多个网络

## 8. Raygun

Raygun是领先的错误监控以及崩溃报告的平台。应用程序性能监控（APM）是其最近的项目。Raygun的DevOps工具帮助用户分析性能问题，并且定位到代码的某一行，某个function或者API调用。APM工具和Raygun的错误管理工作流可以协同工作。比如，它自动定位最高优先级的问题，并创建issue。

Raygun APM能够帮助最大化其他DevOps的价值，因为你总是能收到问题通知。因为它自动将错误链接到源码里，Raygun给整个团队提供统一的真理来源来定位错误和性能问题，将开发和运维紧密联系在一起。
