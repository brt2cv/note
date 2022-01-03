<!--
+++
title       = "Git高级用法"
description = "1. 基本使用; 2. Git Flow; 3. .gitignore; 4. Git本地仓库和裸仓库; 5. Git钩子（用于自动）; 6. 第三方的钩子应用（持续集成工具）; 7. 高级应用; 8. 其他工具"
date        = "2022-01-03"
tags        = ["usual"]
categories  = ["1-os管理","14-command"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. 基本使用

关于Git的使用，[博客园: 一个小时学会Git](https://www.cnblogs.com/best/p/7474442.html)介绍的极其详细，且通俗易懂，所以相比于提供官网教程，个人觉得这篇博客更适合入门~

这里贴个图，区别下常用操作：

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135533148-1430865898.jpg) <!-- git高级用法/git高级用法9.jpg -->

*注：上面这张图，个人认为，工作区（working directory）应该是 untracked, unmodified, modified 三者的结合，而暂存区（index or stage）则仅由staged构成。而非上图的区域划分。*

### 1.1. git clone

```sh
git clone ssh://git@phab.i5cnc.com/diffusion/cat.git  ./cat_v2  # 可以更改本地保存的文件夹名
git clone -l -s -n ./ ../copy  # 克隆本地（-local）仓库，克隆后不检出（--no-checkout）
```

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135533510-261934598.jpg) <!-- git高级用法/git高级用法6.jpg -->

#### 1.1.1. 多种连接协议

Git非常强大，他可以支持多种协议来连接“服务端”，支持的协议包括ssh, http, https, file, git等。

假如你用ssh连接远程服务器： `git remote add origin ssh://username@ip/file/path` 。

例如在本地创建bare裸仓库，可以使用file协议连接： `git remote add origin file:////home/user/server_repo` 。

```sh
$ git clone http[s]://example.com/path/to/repo.git/
$ git clone ssh://example.com/path/to/repo.git/
$ git clone [user@]example.com:path/to/repo.git/  # ssh协议写法2
$ git clone git://example.com/path/to/repo.git/
$ git clone /opt/git/project.git
$ git clone file:///opt/git/project.git
$ git clone ftp[s]://example.com/path/to/repo.git/
$ git clone rsync://example.com/path/to/repo.git/
```

#### 1.1.2. 只检出最近的一个版本

`git clone --depth=1 http://xxxx.git`

#### 1.1.3. 只检出某个tag

`git clone --branch v1.6.5 --depth=1 https://xxxx.git`

注意，如果使用 `--branch tag_name` 的同时，添加了 `--depth=` 参数，则会发现，无法重新 checkout 到其他分支。即使应用了 `git fetch` 也无法拉取远程分支的数据，使用 `git branch -a` 发现仍然只有一个 detach 的分支项。

解决方法：

编辑 `.git/config` 文件，发现：

```
[remote "origin"]
        url = https://github.com/xxx/project.git
        fetch = +refs/tags/v4.0:refs/tags/v4.0
```

改成下面的形式，不要写死fetch的分支项：

```
[remote "origin"]
        url = https://github.com/xxx/project.git
        fetch = +refs/heads/*:refs/remotes/origin/*
```


### 1.2. git rebase

#### 1.2.1. 合并最近的 n 次提交纪录

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135533770-786862284.jpg) <!-- git高级用法/git高级用法0.jpg -->

```
git rebase -i HEAD~4
# 或者
git rebase -i [startpoint] [endpoint]  # 前开后闭
```

有几个命令需要注意一下：

+ p, pick = use commit
+ r, reword = use commit, but edit the commit message
+ e, edit = use commit, but stop for amending
+ s, squash = use commit, but meld into previous commit
+ f, fixup = like “squash”, but discard this commit’s log message
+ x, exec = run command (the rest of the line) using shell
+ d, drop = remove commit

于是，你可以

```
s cacc52da add: qrcode
s f072ef48 update: indexeddb hack
s 4e84901a feat: add indexedDB floder
p 8f33126c feat: add test2.js  # 最后一次的提交
```

#### 1.2.2. 分支合并

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135533994-696549262.jpg) <!-- git高级用法/git高级用法1.jpg -->

如果只是复制某一两个提交到其他分支，建议使用更简单的命令: `git cherry-pick` 。

```
git rebase [startpoint] [endpoint] --onto [branchName]  # 前开后闭
```

例如：

`git  rebase 90bc0045b^ 5de0da9f2 --onto master`

可以看到，C~E部分的提交内容已经复制到了G的后面了，大功告成？NO！

当前HEAD处于<font color=#FF0000>游离状态</font>，实际上，此时所有分支的状态应该是这样：

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135534208-449938232.jpg) <!-- git高级用法/git高级用法2.jpg -->

我们需要做的就是将master所指向的提交id设置为当前HEAD所指向的提交id就可以了，即：

```
git checkout master
git reset --hard 0c72e64
```

#### 1.2.3. rebase 与 merge 的区别

merge

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135534464-2072273209.jpg) <!-- git高级用法/git高级用法3.jpg -->

rebase

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135534695-499724316.jpg) <!-- git高级用法/git高级用法4.jpg -->

当'mywork'分支更新之后，它会指向这些新创建的提交(commit),而那些老的提交会被丢弃。 如果运行<font color=#FF0000>垃圾收集命令(pruning garbage collection)</font>, 这些被丢弃的提交就会删除。

rebase 和 merge的另一个区别是rebase 的冲突是一个一个解决，如果有十个冲突，先解决第一个，然后用命令

```
git add -u
git rebase --continue
```

继续后才会出现第二个冲突，直到所有冲突解决完，而merge 是所有的冲突都会显示出来。
另外如果rebase过程中，你想中途退出，恢复rebase前的代码则可以用命令

```
git rebase --abort
```

总结，rebase的工作流如下：

```
git rebase
while (存在冲突) {
    git status
    找到当前冲突文件，编辑解决冲突
    git add -u
    git rebase --continue
    if( git rebase --abort )
        break;  // 回到rebase之前
}
```

#### 1.2.4. git pull --rebase 替代 git pull

如果自己在本地 commit 了代码，然后执行 `git pull` ，这时候极有可能出现这样的合并记录：

`Merge branch 'feature' of ssh://domain/some-system into feature`

但其实大部分情况下这里是不会有冲突的。所以拉取远程代码时，使用 `git pull --rebase` 就<font color=#FF0000>可以保持提交历史记录的整洁</font>。

> 原理：把本地当前分支的未推送 commit 临时保存为补丁 (patch)（这些补丁放到 `.git/rebase` 目录中），然后将远程分支的代码拉取到本地，最后把保存的这些补丁再应用到本地当前分支上。

若要把 rebase 当做 `git pull` 的预设值，可以修改 `~/.gitconfig` 让所有 tracked branches 自动使用该设定：

```
[branch]
  autosetuprebase = always
```

### 1.3. 子模块

#### 1.3.1. git submodule
> [简书: Git submodule 子模块的管理和使用](https://www.jianshu.com/p/9000cd49822c)

```sh
git submodule add git@ssh:xxx.git pod-library  # 添加子模块
subproject commit <commit-ID>  # 在子模块中独立更新
git add .gitmodules sub_module  # 在父项目中执行单独的commit来引入submodule的更新
```

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135534925-1930768454.jpg) <!-- git高级用法/git高级用法13.jpg -->

```sh
git submodule foreach git pull  # 等同于 cd sub_dir; git pull
git clone git@xxx.git --recursive
# 等同于（如果已经下载了父项目，独立下载子模块）
git clone git@xxx.git;
cd sub_dir;
git submodule init # 初始化本地配置文件：.git/config中记录submodulede的路径信息
git submodule update [--recursive]
```

Git删除Submodule

```sh
git rm --cached sub_dir;
rm -rf sub_dir;
rm -rf .git/modules/sub_dir;
# 删除 .gitmodules 中对应条目
# 更改git的配置文件config:
vim .git/config
[submodule "sub_dir"]
  url = git@github.com:xxx.git
删除submodule相关的内容,然后提交到远程服务器
```

#### 1.3.2. git subtree（推荐）
> [用 Git Subtree 在多个Git项目间双向同步子项目，附简明使用手册](https://segmentfault.com/a/1190000003969060)

个人简单整理了下这部分功能，建议直接在项目中创建一个子模块的管理脚本，将subtree的管理通过固定的封装函数调用。

```sh
function sub_module_pull () {
dir_module=$1
url_repo=$2
branch=$3

    if [ -d $dir_module ]; then
        git subtree pull --prefix=$dir_module $url_repo $branch --squash
    else
        read -p "是否载入子模块 [y/N]" continue
        if [ ${continue}_ == "y_" ]; then
            git subtree add --prefix=$dir_module $url_repo $branch --squash
        fi
    fi
}

function sub_module_push () {
dir_module=$1
url_repo=$2
branch=$3

    git subtree push --prefix=$dir_module $url_repo $branch
}
```

使用function执行更新

```sh
m_utils="git@gitee.com:brt2/utils.git"
m_mvlib="git@gitee.com:brt2/mvlib.git"

sub_module_pull src/utils/ $m_utils dev
sub_module_pull src/utils/ $m_mvlib dev
```

### 1.4. 冷门但很有用的命令

#### 1.4.1. git clean

`git clean` 命令用来从你的工作目录中删除所有没有**tracked**过的文件。

git clean经常和 `git reset --hard` 一起结合使用。reset只影响被track过的文件, 所以需要clean来删除没有track过的文件。结合使用这两个命令能让你的工作目录完全回到一个指定的 `<commit>` 的状态

`git clean -n`

是一次clean的演习，告诉你哪些文件会被删除。记住他不会真正的删除文件, 只是一个提醒。

`git clean -f [path]`

删除当前目录下所有没有track过的文件。他<font color=#FF0000>不会删除.gitignore文件里面指定的文件夹和文件</font>, 不管这些文件有没有被track过。

`git clean -df`

删除当前目录下没有被track过的文件和文件夹

`git clean -xf`

删除当前目录下所有没有track过的文件。不管他是否是.gitignore文件里面指定的文件夹和文件

#### 1.4.2. git rm

当我们需要删除暂存区或分支上的文件, 同时工作区也不需要这个文件了, 可以使用

`git rm file_path`

当我们需要删除暂存区或分支上的文件, 但本地又需要使用, 只是不希望这个文件被版本控制, 可以使用：

`git rm --cached file_path`

#### 1.4.3. git revert

```sh
git revert <commit-id>
git revert -m <1/2>  # 用于merge的commit，指定恢复到哪一个分支的状态
```

#### 1.4.4. git tag

默认情况下，`git push` 并不会把tag标签传送到远端服务器上，只有通过显式命令才能分享标签到远端仓库。

##### push单个tag

`git push origin [tagname]`

例如：

```sh
git push origin v1.0  #将本地v1.0的tag推送到远端服务器
```
##### push所有tag

`git push [origin] --tags`

例如：

```sh
git push --tags
# 或
git push origin --tags
```

以上命令经检验通过，如果不起作用，请在Git控制台上<font color=#FF0000>确认你的账号是否有权限推送Tag</font>。

#### 1.4.5. git stash

```sh
git stash [save "message"]
git stash list
git stash apply [stash@{n}] [--index]
git stash drop [stash@{n}]
git stash pop
git stash show [-p]
git stash clear
```

##### 取消储藏(Un-applying a Stash)

在某些情况下,你可能想应用储藏的修改,在进行了一些其他的修改后,又要取消之前所应用储藏的修改。Git没有提供类似于 stash unapply 的命令,但是可以通过取消该储藏的补丁达到同样的效果：

`git stash show -p stash@{0} | git apply -R`

同样的,如果你沒有指定具体的某个储藏,Gt会选择最近的储戴

`git stash show -p | git apply -R`

你可能会想要新建一个別名,在你的Git里增加一个 stagh-unapply 命令,这样更有效率。例如

```sh
git config --global alias.stash-unapply '!git stash show -p | git apply -R'
git stash apply
...
git stash-unapply
```

##### 从储藏中创建分支

如果你储了一些工作,笤时不去理会,然后继续在你储藏工作的分支上工作,你在重新应用工作时可能会亚到一些问题。如果尝试应用的変更是针对一个你那之后修改过的文件,你会到一个并冲突并且必须去化解它。如果你想用更方便的方法来重新检验你他的变更,你可以运行 `git stash brarch` ,这会创建一个新的分支,检出你储工作时的所处的提交,重新应用你的工作,如果成功,将会丢弃储取。

```sh
$ git stash branch testchanges
Switched to a new branch "testchanges"
# On branch teetchangea
# Changea to be comitted:
# ...
Dropped refs/atash@{0} (f0dfc4d5de332dlcee34a634182e168c4efc3359)
```

这是一个很棒的捷径来恢复储的工作，然后在新的分支上继续当时的工作。

#### 1.4.6. git show-branch

用于对比log提交信息在多个分支下的状态。

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135535180-904158363.jpg) <!-- git高级用法/git高级用法12.jpg -->

#### 1.4.7. Windows系统环境 git 增加文件执行权限

`git ls-files --stage`

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135535411-1717492452.jpg) <!-- git高级用法/git高级用法8.jpg -->

```sh
git update-index --chmod=+x foo.sh
# or
git add --chmod=+x -- afile
```

## 2. Git Flow
> [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/)
>
> [掘金翻译: A successful Git branching model](https://juejin.im/entry/570cca4271cfe4006735d3bd)

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135535734-448664315.jpg) <!-- git高级用法/git高级用法5.jpg -->

### 2.1. 主分支

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135536017-1810395389.jpg) <!-- git高级用法/git高级用法10.jpg -->

该开发模型的核心基本和现有的模型是一样的。中心代码库永远维持着两个主要的分支：

+ master
+ develop

每次改动被合并到 master 的时候，这就是一个真正的新的**发布产品**。我们建议对此进行严格的控制，因此理论上我们可以为每次 `master` 分支的提交都挂一个钩子脚本，向生产环境自动化构建并发布我们的软件。

### 2.2. 支持型分支

+ feature: 开发新的特性
    * 从dev分支迁出，最终合并回dev分支
    * 推荐使用 `git merge --no-ff` 选项
+ release: 用于发布新版本的准备工作
    * 从dev分支迁出，合并回dev和master
    * 命名规范： `release-xxx`
    * 停止开发新的feature特性，进入bug修复阶段
+ hotfix: 用于快速响应bug的修复工作
    * 从master迁出，合并回dev和master
    * 命名规范： `hotfix-xxx`

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135536290-474672861.jpg) <!-- git高级用法/git高级用法11.jpg -->

## 3. .gitignore
> [博客园: Git忽略提交规则 - .gitignore配置运维总结](https://www.cnblogs.com/kevingrace/p/5690241.html)

有三种方法可以实现忽略Git中不想提交的文件：
1. 在Git项目中定义 .gitignore 文件

    对于经常使用Git的朋友来说，`.gitignore` 配置一定不会陌生。这种方式通过在项目的某个文件夹下定义 `.gitignore` 文件，在该文件中定义相应的忽略规则，来管理当前文件夹下的文件的Git提交行为。

    `.gitignore` 文件是可以提交到公有仓库中，这就为该项目下的所有开发者都共享一套定义好的忽略规则。在 `.gitingore` 文件中，遵循相应的语法，在每一行指定一个忽略规则。如：

    ```
    *.log
    *.temp
    /vendor
    ```

2. 在Git项目的设置中指定排除文件

    这种方式只是临时指定该项目的行为，需要编辑当前项目下的 `.git/info/exclude` 文件，然后将需要忽略提交的文件写入其中。需要注意的是，这种方式指定的忽略文件的根目录是项目根目录。

3. 定义Git全局的 .gitignore 文件

    除了可以在项目中定义 `.gitignore` 文件外，还可以设置全局的 `.gitignore` 文件来管理所有Git项目的行为。这种方式在不同的项目开发者之间是不共享的，是属于项目之上Git应用级别的行为。这种方式也需要创建相应的 `.gitignore` 文件，可以放在任意位置。然后在使用以下命令配置Git：

    `git config --global core.excludesfile ~/.gitignore`

### 3.1. Git忽略文件的原则

-  忽略操作系统自动生成的文件，比如缩略图等；
-  忽略编译生成的中间文件、可执行文件等，也就是如果一个文件是通过另一个文件自动生成的，那自动生成的文件就没必要放进版本库，比如Java编译产生的.class文件；
-  忽略你自己的带有敏感信息的配置文件，比如存放口令的配置文件。

### 3.2. .gitignore忽略规则的优先级

在 .gitingore 文件中，每一行指定一个忽略规则，Git检查忽略规则的时候有多个来源，它的优先级如下（由高到低）：

1. 从命令行中读取可用的忽略规则
2. 当前目录定义的规则
3. 父级目录定义的规则，依次递推
4. $GIT_DIR/info/exclude 文件中定义的规则
5. core.excludesfile中定义的全局规则

### 3.3. .gitignore忽略规则的匹配语法

注意：<font color=#FF0000>git对于.ignore配置文件是按行从上到下进行规则匹配的，意味着如果前面的规则匹配的范围更大，则后面的规则将不会生效。</font>

* `#`: 表示注释（可以使用反斜杠进行转义）
* `?`: 通配单个字符，即匹配一个任意字符
* `*`: 表示匹配0个或多个任意字符
    * 使用两个星号"**" 表示匹配任意中间目录

        比如 `a/**/z` 可以匹配 `a/zO`, `a/b/z` 或 `a/b/c/z` 等

* `空格`: 不匹配任意文件，可作为分隔符（可以使用反斜杠进行转义）
* `/`: 定义目录
    * "/"开头的模式匹配<font color=#FF0000>当前目录</font>
    * "/"结束的模式<font color=#FF0000>只匹配即文件夹</font>
    * 如果一个模式不包含"/"，则它匹配相对于当前 .gitignore 文件路径下的任意文件
* `[]`: 包含单个字符的匹配列表，即匹配任何一个列在方括号中的字符。

    比如[abc]表示要么匹配一个a，要么匹配一个b，要么匹配一个c。

    如果在方括号中使用"-"分隔两个字符，表示所有在这两个字符范围内的都可以匹配。比如[0-9]表示匹配所有0到9的数字，[a-z]表示匹配任意的小写字母。

* `!`: 表示不忽略匹配到的文件或目录（可以使用反斜杠进行转义）

    需要特别注意的是：如果文件的父目录已经被前面的规则排除掉了，那么对这个文件用"!"规则是不起作用的。也就是说"!"开头的模式表示否定，该文件将会再次被包含，如果排除了该文件的父级目录，则使用"!"也不会再次被包含。

* 可以使用标准的glob模式匹配。所谓的glob模式是指shell所使用的简化了的正则表达式。

```
#               表示此为注释,将被Git忽略
*.a             表示忽略所有 .a 结尾的文件
!lib.a          表示但lib.a除外
/TODO           表示仅仅忽略项目根目录下的 TODO 文件，不包括 subdir/TODO
build/          表示忽略 build/目录下的所有文件，过滤整个build文件夹；
doc/*.txt       表示会忽略doc/notes.txt但不包括 doc/server/arch.txt

bin/:           表示忽略当前路径下的bin文件夹，该文件夹下的所有内容都会被忽略，不忽略 bin 文件
/bin:           表示忽略根目录下的bin文件
/*.c:           表示忽略cat.c，不忽略 build/cat.c
debug/*.obj:    表示忽略debug/io.obj，不忽略 debug/common/io.obj和tools/debug/io.obj
**/foo:         表示忽略/foo,a/foo,a/b/foo等
a/**/b:         表示忽略a/b, a/x/b,a/x/y/b等
!/bin/run.sh    表示不忽略bin目录下的run.sh文件
*.log:          表示忽略所有 .log 文件
config.php:     表示忽略当前路径的 config.php 文件

/mtk/           表示过滤整个文件夹
*.zip           表示过滤所有.zip文件
/mtk/do.c       表示过滤某个具体文件

被过滤掉的文件就不会出现在git仓库中（gitlab或github）了，当然本地库中还有，只是push的时候不会上传。

需要注意的是，gitignore还可以指定要将哪些文件添加到版本管理中，如下：
!*.zip
!/mtk/one.txt

唯一的区别就是规则开头多了一个感叹号，Git会将满足这类规则的文件添加到版本管理中。为什么要有两种规则呢？
想象一个场景：假如我们只需要管理/mtk/目录中的one.txt文件，这个目录中的其他文件都不需要管理，那么.gitignore规则应写为：
/mtk/*
!/mtk/one.txt

假设我们只有过滤规则，而没有添加规则，那么我们就需要把/mtk/目录下除了one.txt以外的所有文件都写出来！
注意上面的/mtk/*不能写为/mtk/，否则父目录被前面的规则排除掉了，one.txt文件虽然加了!过滤规则，也不会生效！

-------------------------------------------------

还有一些规则如下：

fd1/*
说明：忽略目录 fd1 下的全部内容；注意，不管是根目录下的 /fd1/ 目录，还是某个子目录 /child/fd1/ 目录，都会被忽略；

/fd1/*
说明：忽略根目录下的 /fd1/ 目录的全部内容；

/*
!.gitignore
!/fw/
/fw/*
!/fw/bin/
!/fw/sf/
说明：忽略全部内容，但是不忽略 .gitignore 文件、根目录下的 /fw/bin/ 和 /fw/sf/ 目录；注意要先对bin/的父目录使用!规则，使其不被排除。
```

如果你不慎在创建.gitignore文件之前就push了项目，那么即使你在.gitignore文件中写入新的过滤规则，<font color=#FF0000>这些规则也不会起作用，Git仍然会对所有文件进行版本管理</font>。简单来说出现这种问题的原因就是Git已经开始管理这些文件了，所以你无法再通过过滤规则过滤它们。所以大家一定要养成在项目开始就创建.gitignore文件的习惯，否则一单push，处理起来会非常麻烦。

[更多内容和示例，参考博客园](https://www.cnblogs.com/kevingrace/p/5690241.html)

### 3.4. 只包含指定的文件扩展名

注意以下规则的顺序：

```py
# 首先忽略所有的文件
*
# 但是不忽略目录
!*/
# 忽略一些指定的目录名
ut/
# 不忽略下面指定的文件类型
!*.md
```

## 4. Git本地仓库和裸仓库

先说结论： 裸仓库一般情况下是作为<font color=#FF0000>远端的中心仓库</font>而存在的。

由此可以体现出，git是一个包含客户端和服务端的双端系统，`git init` 负责创建client目录，而 `git init --bare` 则负责server端目录。

### 4.1. 创建裸仓库

`git init --bare <repo>`

使用 --bare 参数的含义：使用 --bare 参数初始化的仓库，我们一般称之为裸仓库， 因为这样创建的仓库并不包含 <font color=#FF0000>工作区</font> ，也就是说，我们并不能在这个目录下执行我们一般使用的Git命令。

![](https://img2020.cnblogs.com/blog/2039866/202006/2039866-20200604135536580-620759992.jpg) <!-- git高级用法/git高级用法7.jpg -->

#### 4.1.1. mirror仓库

`--mirror` : 建一个源repo的镜像，暗含了 --bare。相比于 `--bare` ，`--mirror` 不仅将源的本地分支映射到目标本地分支，也会映射其所有的refs（包括远程追踪分支、notes等）并建立一个引用说明配置（refs configuration）使得所有的refs都会通过目的repo中的 git remote update 重写。

### 4.2. 文件差异

普通的仓库，版本管理的内容存放在 `.git` 文件夹下，负责提交信息的管理和缓存；

而裸仓库相当于是把 .git 文件夹直接放在了裸仓库的根目录，即，不存在工作区（负责展示HEAD节点的文件状态），而是只记录commit提交状态信息。

## 5. Git钩子（用于自动）
> [homepage](https://git-scm.com/book/zh/v2/自定义-Git-Git-钩子#_git_hooks)

钩子，就是你完成每一步Git给你的“回调”。

钩子的全部放在.git/hooks下面，在新建一个项目仓库的时候，Git已经在这个文件夹下给我们生成了很多个.sample后缀的钩子，这些钩子只要把.sample去掉就可以运行了，我们可以在这些sample上面修改完成我们自己的钩子

### 5.1. 客户端钩子

客户端钩子很好理解，你commit之后想做其他事，比如说编译一下程序啥的，这里我就不多讲，主要由下面几个钩子组成

+ pre-commit 提交之前
+ post-commit 提交之后
+ pre-rebase 变基之前
+ post-rewrite 替换提交记录之后
+ pre-push 推送之前

客户端钩子存在一个管理上的问题：

由于 `.git` 里面的文件，无法提交到git项目上去，所以最好在git目录最外层新建一个同名的hooks文件夹，把写好的脚本放里面。

重新clone该项目时，在根目录执行一下 `cp hooks/* .git/hooks/` 把脚本复制到.git里去。

#### 5.1.1. 对提交代码进行语法检查

利用 pylint 对上传文件进行检查与打分。

> [掘金: git代码格式化上传(python版)](https://juejin.im/post/5e929595f265da47c646ffe4)

可以直接使用 `git-pylint-commit-hook` 模块进行管理：

+ github: https://github.com/sebdah/git-pylint-commit-hook
+ doc: https://git-pylint-commit-hook.readthedocs.io/en/latest/

#### 5.1.2. 对提交代码进行格式化

推荐使用 yapf 格式化代码，当然你也可以选择 autopep8 或 docformatter 。

### 5.2. 服务端钩子

服务端钩子就是你push之后的事情服务器要运行的脚步，有用推的步骤只有一个，所以钩子只有四个

+ pre-receive 接受之前
+ update 更新之前
+ post-update 更新之后
+ post-receive 接受之后

服务器接收到客户端请求时，pre-receive先进行调用，如果返回值为非0就会拒绝推送，所以我们写钩子的时候一定要记住最后要返回0才能正常接收更新，update主要处理多分支推送，有的时候你一次更新，推三四个分支到服务器，pre-receive只会调用一次，update会对每个的分支调用一次，后面两个都很容易理解

## 6. 第三方的钩子应用（持续集成工具）

什么是持续集成（Continuous integration, CI）——频繁地（一天多次）将代码集成到主干。

它的好处主要有两个：

+ 快速发现错误: 可以快速发现错误，定位错误也比较容易
+ 防止分支大幅偏离主干: 如果不是经常集成，主干又在不断更新，会导致以后集成的难度变大，甚至难以集成。

流程：

1. 提交代码: git commit
2. 代码评审（Code Review）
2. 自动化测试（至少是单元测试）
3. 代码合并进master分支
4. build: 将源码转换为可以运行的实际代码

    比如安装依赖，配置各种资源（样式表、JS脚本、图片）等等。

5. 第二轮测试（集成测试、人工测试）
6. 项目打包/部署
7. 回滚

常用的构建工具包括:

+ Jenkins
+ Travis
+ Codeship
+ Strider

### 6.1. Code Review

这一套流程实践下来的问题是：

每次Push代码之后需要开发者手动创建Merge Request（当然可以通过脚本进行自动化，但需要额外配置），然后进行代码Review，不是很方便。

团队内使用标准的Git Flow，大量开发工作在Feature分支进行。Gitlab无法对每个新建的Feature分支自动添加权限控制，也就无法强制对Feature分支进行Code Review。

在Gitlab无法满足团队需求的情况下，继续寻找替代方案。目前比较流行的Code Review平台，主要是Google出品的Gerrit和Facebook出品的Phabricator，二者都已开源。

Phabricator对比Gerrit有如下优势：

+ 界面美观（在工具使用非常频繁的情况下，美观度也是非常重要的）
+ 功能齐全（Phabricator除了代码托管和Code Review之外，还集成了任务、Wiki、日程等）
+ 提供两种不同的Review方式，团队可以灵活切换
+ 能够集成各种自动化插件

当然，Phabricator相对Gitlab也有缺点：

+ 代码托管方面不如Gitlab专业（也不弱，但不够专业）
+ 部署和使用成本较高（环境配置复杂，命令行较多，对于非开发人员使用成本较高）

#### 6.1.1. Code Review 工具
> [知乎: Code Review 都是怎么做的？](https://www.zhihu.com/question/41089988/answer/544543949)
>
> [知乎: 16 个好用的 Code Review 工具](https://zhuanlan.zhihu.com/p/103592147)
>
> [segmentfault: 基于GitLab的Code Review教程](https://segmentfault.com/a/1190000016155779)

+ Crucible：Atlassian 内部代码审查工具；
+ Gerrit：Google 开源的 git 代码审查工具；
+ GitHub：程序员应该很熟悉了，上面的 "Pull Request" 在代码审查这里很好用；
+ LGTM：可用于 GitHub 和 Bitbucket 的 PR 代码安全漏洞和代码质量审查辅助工具；
+ Phabricator：Facebook 开源的 git/mercurial/svn 代码审查工具；
+ PullRequest：GitHub pull requests 代码审查辅助工具；
+ Pull Reminders：GitHub 上有 PR 需要你审核，该插件自动通过 Slack 提醒你；
+ Reviewable：基于 GitHub pull requests 的代码审查辅助工具；
+ Sider：GitHub 自动代码审查辅助工具；
+ Upsource：JetBrain 内部部署的 git/mercurial/perforce/svn 代码审查工具。

### 6.2. Jenkins
> [掘金: 让自动化工作流解放你的双手](https://juejin.im/post/5d3fb5046fb9a06b0935f47d)

### 6.3. GitLab-CI

### 6.4. Gitlab Webhooks

## 7. 高级应用
> [Git 核弹级选项 filter-branch](https://git-scm.com/book/zh/v2/Git-工具-重写历史#核武器级选项)

### 7.1. 从仓库中拆分子目录为独立项目
> [Git仓库拆拆拆](https://segmentfault.com/a/1190000002548731)

比如你有一个叫做 big-project 的仓库，目录如下：

big-project
 ├── codes-a
 ├── codes-b
 └── codes-eiyo

如何把 codes-eiyo 拆出来做为一个独立仓库？又如何把 codes-eiyo 清理掉，只保留剩下的代码在仓库中？

```sh
function split_to_independence(){
sub_dir=$1
test -z $2 && tmp_branch="tmp_"${sub_dir} || tmp_branch=$2
test -z $3 && path_new=${tmp_branch} || path_new=$3
path_old=$(pwd)

    # 将 sub_dir 目录下的所有提交整理为新的分支
    git subtree split -P ${sub_dir} -b ${tmp_branch}

    # 初始化新仓库
    if [ -d ${path_new} ]; then
        echo "There has been a same-name dir. Make sure it's empty?"
    else
        mkdir ${path_new}
        git init ${path_new}
    fi

    # 拉取原仓库的 tmp_branch 分支到 path_new 的 master 分支
    cd ${path_new}
    git pull ${path_old} ${tmp_branch}

    # 清理原项目中的临时分支
    cd ${path_old}
    git branch -D ${tmp_branch}
}
```

### 7.2. 从仓库中清理子目录 commit 痕迹

情景同上，只是变为：从当前commit列表中清除关于 sub-dir 的所有记录。

```sh
function clean_up_subdir(){
sub_dir=$1
current_branch=$(git symbolic-ref --short HEAD)  # $(git branch | grep '*' | awk '{print $2}')
# there are some interesting ways:
# git symbolic-ref --short HEAD
# git describe --contains --all HEAD
test -z $2 && target_branch=${current_branch} || target_branch=$2

    # 重写提交记录，且不保留空提交
    git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch ${sub_dir}" --prune-empty ${target_branch}

    # 前步操作会清理 sub_dir 中所有已提交文件，但会忽略垃圾文件及文件夹
    # rm -rf ${sub_dir}
}
```

### 7.3. 从每一个提交移除一个文件

+ 例如，有人粗心地通过 git add . 提交了一个巨大的二进制文件，你想要从所有地方删除它。
+ 可能偶然地提交了一个包括一个密码的文件，然而你想要开源项目。

```sh
# 从每一个快照中移除了一个叫作 passwords.txt 的文件，无论它是否存在
$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD

# 移除所有偶然提交的编辑器备份文件
$ git filter-branch --tree-filter 'rm -f *~' HEAD

# 最后将可以看到 Git 重写树与提交然后移动分支指针。
```

### 7.4. 使一个子目录做为新的根目录

例如，从另SVN中导入项目，并且存在几个没意义的子目录（trunk、tags 等等）。如果想要让 trunk 子目录作为每一个提交的新的项目根目录：

`git filter-branch --subdirectory-filter trunk HEAD`

现在新项目根目录是 trunk 子目录了。 Git 会自动移除所有不影响子目录的提交。

### 7.5. 全局修改邮箱地址

+ 在你开始工作时忘记运行 git config 来设置你的名字与邮箱地址
+ 或者你想要开源一个项目并且修改所有你的工作邮箱地址为你的个人邮箱地址。

```sh
$ git filter-branch --commit-filter '
        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
        then
                GIT_AUTHOR_NAME="Scott Chacon";
                GIT_AUTHOR_EMAIL="schacon@example.com";
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' HEAD
```

这会遍历并重写每一个提交来包含你的新邮箱地址。

注意：因为提交包含了它们父提交的 SHA-1 校验和，这个命令会修改你的历史中的每一个提交的 SHA-1 校验和，而不仅仅只是那些匹配邮箱地址的提交。

## 8. 其他工具

### 8.1. git-fat
> [github](https://github.com/jedbrown/git-fat)
>
> [gitee](https://gitee.com/mirrors/git-fat)

1. 安装： git-fat是一个shell脚本，只要下载该脚本，放到你的path变量中就安装好了

2. 创建或使用已有的git仓库：`cd dir_repo && git init`

2. 使用：创建一个.gitattributes文件，来描述哪些文件是一个二进制文件：

    ```sh
    $ cd path-to-your-repository
    $ cat >> .gitattributes
    *.png filter=fat -crlf
    *.jpg filter=fat -crlf
    *.gz  filter=fat -crlf
    ^D
    ```

3. 运行 `git fat init` 激活上面的文件后缀

    此时，在 .git/config 中添加了以下信息

    ```
    [filter "fat"]
            clean = git-fat filter-clean
            smudge = git-fat filter-smudge
    ```

    从此你可以像一般文件一样来 `git add` , `git commit` ，命令执行前会自动调用 `git-fat` 脚本执行回调函数。将自动以一个 75Byte 的文件符代替文件记录在git中。

4. 如果需要将那些.png,.gz,.jpg文件保存于repo之外的地方，例如保存于一个共享服务器上，你可以创建一个.gitfat文件，该文件中写入以下内容：

    ```
    [rsync]
    remote = your.remote-host.org:/share/fat-store
    sshuser = yourusername
    options = -avzW
    ```

git-fat 使用中的问题：

1. 每次clone仓库之后，`.git/config` 文件中不会更新 `[filter "fat"]` 内容。需要重新执行 `git fat init` 。

2. clone到的仓库，如zip/png等大文件被替换，当再次拷贝这些大文件替换后，git需要更新文件描述符……这意味着两个仓库无法完成同步。
