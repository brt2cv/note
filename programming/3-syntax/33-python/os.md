<!--
+++
title       = "Python常用模块"
description = "1. Exception类; 2. 内置函数; 3. File; 4. platform; 5. shutil; 6. os; 7. os.path; 8. pathlib; 9. time; 10. datetime; 11. random; 12. glob; 13. pickle; 14. json; 15. yaml; 16. Excel.xls格式; 17. math; 18. functools; 19. itertools; 20. traceback; 21. operator; 22. base64; 23. contextlib: with语句的实现; 24. pkgutil"
date        = "2021-12-21"
tags        = ["usual"]
categories  = ["3-syntax","33-python"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. Exception类
> [官网](https://docs.python.org/3/library/exceptions.html)

```
BaseException
+-- SystemExit
+-- KeyboardInterrupt
+-- GeneratorExit
+-- Exception
      +-- StopIteration
      +-- StopAsyncIteration
      +-- ArithmeticError
      |    +-- FloatingPointError
      |    +-- OverflowError
      |    +-- ZeroDivisionError
      +-- AssertionError
      +-- AttributeError
      +-- BufferError
      +-- EOFError
      +-- ImportError
      |    +-- ModuleNotFoundError
      +-- LookupError
      |    +-- IndexError
      |    +-- KeyError
      +-- MemoryError
      +-- NameError
      |    +-- UnboundLocalError
      +-- OSError
      |    +-- BlockingIOError
      |    +-- ChildProcessError
      |    +-- ConnectionError
      |    |    +-- BrokenPipeError
      |    |    +-- ConnectionAbortedError
      |    |    +-- ConnectionRefusedError
      |    |    +-- ConnectionResetError
      |    +-- FileExistsError
      |    +-- FileNotFoundError
      |    +-- InterruptedError
      |    +-- IsADirectoryError
      |    +-- NotADirectoryError
      |    +-- PermissionError
      |    +-- ProcessLookupError
      |    +-- TimeoutError
      +-- ReferenceError
      +-- RuntimeError
      |    +-- NotImplementedError
      |    +-- RecursionError
      +-- SyntaxError
      |    +-- IndentationError
      |         +-- TabError
      +-- SystemError
      +-- TypeError
      +-- ValueError
      |    +-- UnicodeError
      |         +-- UnicodeDecodeError
      |         +-- UnicodeEncodeError
      |         +-- UnicodeTranslateError
      +-- Warning
           +-- DeprecationWarning
           +-- PendingDeprecationWarning
           +-- RuntimeWarning
           +-- SyntaxWarning
           +-- UserWarning
           +-- FutureWarning
           +-- ImportWarning
           +-- UnicodeWarning
           +-- BytesWarning
           +-- ResourceWarning
```

常用错误类型:

+ <font color=#FF0000>NotImplementedError</font>
+ RuntimeWarning
+ ConnectionError

## 2. 内置函数

* <font color=#FF0000>eval()</font>
* reversed()
* filter()
* yield
* enumerate()
* memoryview()
* locals()
* isinstance() / issubclass()
* property()
* ord() / hex()
* setattr()
* slice()
* coerce()
* intern()
* apply()
* vars()
* unichr()
* type()
* globals()

### 2.1. sorted()

`sorted(iterable[, key[, reverse]])`

参数：

* cmp为函数，指定排序时进行比较的函数（Python3.x已取消）

    ```py
    >>> L=[('b',2),('a',1),('c',3),('d',4)]
    >>> sorted(L, cmp=lambda x,y: cmp(x[1],y[1]))  # 利用cmp函数
    ```

    <font color=#FF0000>key和reverse比一个等价的cmp函数处理速度要快。</font>这是因为对于每个列表元素，cmp都会被调用多次，而key和reverse只被调用一次。

    ```py
    def numeric_compare(x, y):
        return x - y
    sorted([5, 2, 4, 1, 3], cmp=numeric_compare)  # [1, 2, 3, 4, 5]
    ```

    在Python3中，如需自定义排序规则：

    ```py
    from functools import cmp_to_key

    x = [(5,"z"), (2,"k"), (4,"c"), (3,"a"), (3,"z"), (1,"d"), (5,"a")]
    def cmp_(x, y):
        if x[0] == y[0]:
            return ord(y[1]) - ord(x[1])
        else:
            return x[0] - y[0]

    x_ = sorted(x, key=cmp_to_key(cmp_))
    ```

    不过，这个方式也可以通过Python3的形式表达：

    ```py
    x_ = sorted(x, key=lambda x: (x[0], -ord(x[1])))
    ```

* key为函数，指定取待排序元素的哪一项进行排序

    ```py
    students = [('john', 'A', 15), ('jane', 'B', 12), ('dave', 'B', 10)]
    sorted(students, key=lambda item: item[2])
    ```

键函数不需要直接依赖于被排序的对象。键函数还可以访问外部资源。例如，如果学生成绩存储在字典中，则可以使用它们对单独的学生姓名列表进行排序：

```py
students = ['dave', 'john', 'jane']
newgrades = {'john': 'F', 'jane':'A', 'dave': 'C'}
sorted(students, key=newgrades.__getitem__)  # ['jane', 'dave', 'john']
```

在两个对象之间进行比较时，保证排序例程使用 __lt__() 。 因此，通过定义 __lt__() 方法，可以很容易地为类添加标准排序顺序:

```py
>>> Student.__lt__ = lambda self, other: self.age < other.age
>>> sorted(student_objects)  # [('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]
```

#### 2.1.1. from operator import itemgetter

operator模块提供的 `itemgetter` 函数用于获取对象的哪些维的数据，参数为一些序号（即需要获取的数据在对象中的序号）。注意， `operator.itemgetter` 函数获取的不是值，而是定义了一个函数，通过该函数作用到对象上才能获取值。

```py
a = [1,2,3]
>>> b=operator.itemgetter(1)  # 定义函数b，获取对象的第1个域的值
>>> b(a)
2
>>> b=operator.itemgetter(1,0)  # 定义函数b，获取对象的第1个域和第0个的值
>>> b(a)
(2, 1)
```

itemgetter() 函数也<font color=#FF0000>支持多个keys排序</font>

```py
>>> rows_by_lfname = sorted(rows, key=itemgetter('lname','fname'))
>>> print(rows_by_lfname)
[{'fname': 'David', 'uid': 1002, 'lname': 'Beazley'},
 {'fname': 'John', 'uid': 1001, 'lname': 'Cleese'},
 {'fname': 'Big', 'uid': 1004, 'lname': 'Jones'},
 {'fname': 'Brian', 'uid': 1003, 'lname': 'Jones'}]
```

实际上，在排序时，也可以使用lambda表达式，与itemgetter()效果相同。但是，使用itemgetter()方式会运行的稍微快点。因此，如果你对性能要求比较高的话就使用itemgetter()方式。

```py
rows_by_fname = sorted(rows, key=lambda r: r['fname'])
rows_by_lfname = sorted(rows, key=lambda r: (r['lname'],r['fname']))
```

最后，不要忘了这节中展示的技术也同样适用于 `min()` 和 `max()` 等函数。比如：

```py
>>> min(rows, key=itemgetter('uid'))
{'fname': 'John', 'lname': 'Cleese', 'uid': 1001}
>>> max(rows, key=itemgetter('uid'))
{'fname': 'Big', 'lname': 'Jones', 'uid': 1004}
```

#### 2.1.2. from operator import attrgetter

想排序类型相同的对象，但是他们不支持原生的比较操作。

```py
class user():
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def __repr__(self):
        '''定义该对象需要输出时的字符串格式'''
        return self.name + ":" + str(self.age)

users = [
    user("Mike", 28),
    user("Lily", 25),
    user("Tom", 27),
    user("Ben", 23)
]

list_by_name = sorted(users, key=attrgetter("name", "age"))
# 等价于: sorted(users, key=lambda user: (user.name, user.age))
```

#### 2.1.3. 字典排序

```py
test = defaultdict(list)
test = {"key1":[1,2,3,4], "key2:"[3,4,5,6]}
items = sorted(test.items(), key=lambda x:x[1][3], reverse=True)

# test.items() 返回时一个列表 ("key1",[1,2,3,4])
x[1] 则是[1,2,3,4]
x[1][3] 的话就是4了
```

## 3. File

核心函数 `open(path[, mode[, encoding]])`

### 3.1. 读写模式

+ r
+ w
+ a: 相当于先seek()至末位，然后 `w` 方式写入

同时读写：

+ "r+"

    * 在文件不存在时报错，而不是新建（不同于 `w+` ）
    * seek在0位，可读（不同于 `a+` ，seek在末位）

    * 一个很有趣的现象是：如果文件直接执行write操作（或者执行了seek操作，总之就是写之前没有进行读操作），那么，写入是<font color=#FF0000>覆盖</font>进行的。这是正常情况。

        ```py
        with open("1.txt", "w") as fp:
            fp.write("This is a \ntest...")

        fd = open("1.txt",'r+')
        fd.seek(5)  # 变更插入点
        # print("直接读取:", fd.read(4))  # 这里不进行读，则下面的write是覆盖写
        print("curr_pos:", fd.tell())

        fd.write('12345')  # This 12345\ntest...

        fd.seek(0)
        print("二次读取:", fd.read(4))  # This
        fd.close()
        ```

    * 但特殊的是，如果在执行了读取操作之后，<font color=#FF0000>fp.write()在文末追加</font>，即使当前seek位置不在文末。当然，<font color=#FF0000>如果重新指定了seek值，那么恢复到正常情况。</font>

        ```py
        fd = open("1.txt",'r+')
        # fd.seek(0)
        print("直接读取:", fd.read(4))  # this
        print("curr_pos:", fd.tell())  # 4

        # fd.seek(x)  # 如果显式没有定位，则此时write以追加的方式写入！
        fd.write('12345')  # this is a test...12345

        fd.seek(0)
        print("二次读取:", fd.read(4))  # this
        fd.close()
        ```

        起初以为是bug，后来想想，应该是python为了避免read了一部分以后，忘记seek就执行write()造成损失，所以自动优化了下。如果有需要，请显式定位seek。

+ "w+"

    <font color=#FF0000>打开文件时就会擦除全部内容</font>

    ```py
    with open("1.txt", "w") as fp:
        fp.write("This is a \ntest...")

    fd = open("1.txt",'w+')
    fd.seek(0)  # 没有卵用...
    print("直接读取:", fd.read(4))
    print("curr_pos:", fd.tell())

    fd.write('12345')  # 12345

    fd.seek(0)  # 设置到起始位置进行读取
    print("二次读取:", fd.read(4))  # 1234
    fd.close()
    ```

+ "a+"

    * 支持读取，但注意open()后seek默认在文末，直接读取是没有数据的。
    * <font color=#FF0000>write()永远是在追加</font>，即使设置了seek值（不同于 `r+` 与 `w+` 都是覆盖方式）

    ```py
    fd = open("1.txt",'a+')
    fd.seek(5)  # 不变更插入点
    print("直接读取:", fd.read(4))  # 执行读，则下面的write是追加
    print("curr_pos:", fd.tell())  # 9

    fd.seek(4)  # 这里没有卵用！！！并不影响write的追加写方式
    print("curr_pos:", fd.tell())  # 4
    fd.write('12345')  # this is a test...12345

    fd.seek(0)
    print("二次读取:", fd.read(4))  # This
    fd.close()
    ```

+ "x"

    写模式，新建一个文件，<font color=#FF0000>如果该文件已存在则会报错。</font>

### 3.2. 读取数据

+ read(): 一次性读取最方便；但如果不能确定文件大小，反复调用read(size)比较保险
+ readline(): 每次读取一行内容
+ readlines(): 一次读取所有内容并按行返回list
+ `for i in fp` : 类似于 `for i in fp.readlines()`

### 3.3. truncate() 等常用函数

+ `seek(offset,where)`

    where=0从起始位置移动，1从当前位置移动，2从结束位置移动。当有换行时，会被换行截断。seek（）无返回值，故值为None。

+ `tell()`

    文件的当前位置,即tell是获得文件指针位置，受seek、readline、read、readlines影响，不受truncate影响。

+ `truncate(n)`

    从文件的首行首字符开始截断，截断文件为n个字符；无n表示从当前位置起截断；<font color=#FF0000>截断之后n后面的所有字符被删除。</font>其中win下的换行代表2个字符大小。

+ `readline(n)`

    读入若干行，n表示读入的最长字节数。其中读取的开始位置为tell()+1。当n为空时，默认完整读取当前行的内容。

+ `writelines(sequence)`

    向文件写入一个序列字符串列表，<font color=#FF0000>注意该函数不自动追加换行符</font>，所以如果需要换行则要自己加入每行的换行符。

## 4. platform
> [官网](https://docs.python.org/3/library/platform.html)

platform模块给我们提供了很多方法去获取操作系统的信息。

* platform.platform()  # 获取操作系统名称及版本号，'Linux-3.13.0-46-generic-i686-with-Deepin-2014.2-trusty'
* platform.version()  # 获取操作系统版本号，'# 76-Ubuntu SMP Thu Feb 26 * 18:52:49 UTC 2015'
* platform.architecture()  # 获取操作系统的位数，('32bit', 'ELF')

    ```py
    is_64bits = sys.maxsize > 2**32
    ```

* platform.machine()  # 计算机类型，'i686'
* platform.node()  # 计算机的网络名称，'XF654'
* platform.processor()  # 计算机处理器信息，'i686'
* platform.uname()  # 包含上面所有的信息汇总

还可以获得计算机中python的一些信息。

* platform.python_build()
* platform.python_compiler()
* platform.python_branch()
* platform.python_implementation()
* platform.python_revision()
* platform.python_version()
* platform.python_version_tuple()

## 5. shutil
> [homepage](https://docs.python.org/3/library/shutil.html)

* shutil.copy(src, dst, *, follow_symlinks=True)
* shutil.copy2(src, dst, *, follow_symlinks=True)  # also attempts to preserve file metadata
* shutil.copytree()
* shutil.rmtree('xxx')
* shutil.move()
* shutil.remove()
* cols, lines = shutil.get_terminal_size()
* shutil.chown(path)
* shutil.which("python")
* shutil.ignore_patterns(*patterns)

    ```py
    from shutil import copytree, ignore_patterns
    copytree(source, destination, ignore=ignore_patterns('*.pyc', 'tmp*'))
    ```

## 6. os
> [homepage](https://docs.python.org/3/library/os.html)

* <font color=#FF0000>os.environ</font>  # list of str
* os.environ['PATH']
* os.getenv(key, default=None)

    On Unix, keys and values are decoded with sys.getfilesystemencoding() and 'surrogateescape' error handler. Use os.getenvb() if you would like to use a different encoding.

* <font color=#FF0000>os.chdir(path)</font>
* os.getcwd()
* os.getlogin()
* os.getuid()
* os.getpid()
* <font color=#FF0000>os.getcwd()</font>
* <font color=#FF0000>os.chdir('subdir')</font>
* os.scandir(path='.')  # 返回os.DirEntry对象

    ```py
    with os.scandir(path) as it:
        for entry in it:
            if not entry.name.startswith('.') and entry.is_file():
                print(entry.name)
    ```

* os.DirEntry
  - name
  - path
  - inode()
  - is_dir()
  - is_file()
  - is_symlink()
  - stat()

* <font color=#FF0000>os.listdir(path='.')

    depressed, use **os.scandir()** after 3.5</font>

* os.stat('fileA.txt')
* os.mkdir(path, mode=0o777)
* os.makedirs(name='xxxx/yyyy', mode=0o777, exist_ok=False)
* os.rmdir("xxx/")
* os.removedirs("xxx/yyy")  # <font color=#FF0000>注意，当目录非空时，触发异常</font>
* <font color=#FF0000>os.system("rm -rf xxx/yyy")</font>
* os.chmod(path, mode)
* os.chown(path, uid, gid)
* os.mkfifo(path, mode=0o666)

### 6.1. 关于一些近似函数的比较

创建文件夹

+ os.mkdir(path): 只能在现有的文件夹下，创建一级目录
+ os.makedirs("xx/yy/zzz"): 类似 `mkdir -p` 选项，可以创建多级目录

删除文件

+ os.remove(path): 如果path为目录，raise `IsADirectoryError()`
+ os.rmdir(dir): 如果dir不存在或<font color=#FF0000>非空</font>，raise `FileNotFoundError`
+ os.removedirs('foo/bar/baz'): 先删除baz，之后若bar/为空，则删除bar，以此类推，至删除foo/
+ shutil.rmtree(path, ignore_errors=False): 无视dir非空，只管删除

### 6.2. 遍历文件 - glob

+ glob

    ```py
    glob.glob('*.txt') -> ["path_1", "path_2", ...]
    glob.glob('*.??')
    ```

+ os.listdir(path)
+ os.scandir(path)
+ os.walk

    ```py
    import os
    for root, dirs, files in os.walk(top, topdown=False):
        # top参数可以是相对路径，它决定了迭代中root的绝对-相对状态
        # root: 代表当前迭代时的路径位置，如："./loop/curr_dir"
        # dirs: list，当前root路径下的所有子文件夹，如["subdir", "subdir2"]
        # files: list，当前root路径下的文件，如["file.txt", "file2.txt"]
        for name in files:
            os.remove(os.path.join(root, name))
        for name in dirs:
            os.rmdir(os.path.join(root, name))
    ```

## 7. os.path
> [官网: os](https://docs.python.org/3/library/os.path.html)

`import os.path as osp`

* osp.curdir  # 常量: "."
* osp.exists(path)
* <font color=#FF0000>osp.getmtime(path)</font>
* osp.getctime(path)
* <font color=#FF0000>osp.getsize(path)</font>
* osp.isfile(path)
* osp.isdir(path)
* <font color=#FF0000>osp.join(path, *paths)</font>
* osp.samefile(path1, path2)
* osp.sameopenfile(fp1, fp2)
* <font color=#FF0000>osp.split(path)</font>
* osp.splitext(path)
* <font color=#FF0000>osp.basename(path)</font>  # 返回文件名: test.txt
* <font color=#FF0000>osp.dirname(path)</font>
* osp.abspath(path)
* osp.realpath(path)  # <font color=#FF0000>区别于abspath: 如文件为链接，返回实际文件路径</font>
* osp.relpath(path)
* <font color=#FF0000>osp.expanduser(path)</font>  # osp.expanduser("~/dir") -> /home/user/dir
* os.path.expandvars(path)  # -> shell变量扩展，如"$var"

## 8. pathlib

```py
from pathlib import Path
data_folder = Path("source_data/text_files/")
file_to_open = data_folder / "raw_data.txt"  # 斜杠 / 操作符
f = open(file_to_open)
print(f.read())
```

类实例属性和实例方法名 | 功能描述
------------|-----
<font color=#FF0000>PurePath.parts</font> | 返回路径字符串中所包含的各部分: <font color=#FF0000>('/', 'usr', 'bin', 'python3')</font>
PurePath.drive | 返回路径字符串中的驱动器盘符
<font color=#FF0000>PurePath.root</font> | 返回路径字符串中的根路径
PurePath.anchor | 返回路径字符串中的盘符和根路径
PurePath.parents | 返回当前路径的全部父路径
PurPath.parent | 返回当前路径的上一级路径，相当于 parents[0] 的返回值
<font color=#FF0000>PurePath.name</font> | 返回当前路径中的文件名: "raw_data.txt"
PurePath.suffixes | 返回当前路径中的文件所有后缀名
<font color=#FF0000>PurePath.suffix</font> | 返回当前路径中的文件后缀名。相当于 suffixes 属性返回的列表的最后一个元素: "txt"
<font color=#FF0000>PurePath.stem</font> | 返回当前路径中的主文件名: "raw_data"
<font color=#FF0000>PurePath.as_posix()</font> | <font color=#FF0000>将当前路径转换成 UNIX 风格的路径</font>
PurePath.as_uri() | 将当前路径转换成 URL。只有绝对路径才能转换，否则将会引发 ValueError
PurePath.is_absolute() | 判断当前路径是否为绝对路径
PurePath.joinpath(*other) | 将多个路径连接在一起，作用类似于前面介绍的<font color=#FF0000>斜杠（/）连接符</font>
PurePath.match(pattern) | 判断当前路径是否匹配指定通配符
PurePath.relative_to(*other) | 获取当前路径中去除基准路径之后的结果
PurePath.with_name(name) | 将当前路径中的文件名替换成新文件名。如果当前路径中没有文件名，则会引发 ValueError
PurePath.with_suffix(suffix) | 将当前路径中的文件后缀名替换成新的后缀名。如果当前路径中没有后缀名，则会添加新的后缀名

* Path.exists()
* Path.is_dir()
* Path.is_file()
* Path.is_symlink()
* Path.expanduser()  替换~为$HOME路径
* Path.mkdir(mode=0o777, parents=False, exist_ok=False)
* Path.chmod()
* Path.rename(target)
* Path.glob(pattern)  解析相对于此路径的通配符 pattern，产生所有匹配的文件

    ```py
    >>> sorted(Path('.').glob('*.py'))
    [PosixPath('pathlib.py'), PosixPath('setup.py'), PosixPath('test_pathlib.py')]
    >>> sorted(Path('.').glob('*/*.py'))
    [PosixPath('docs/conf.py')]
    ```

    "**" 模式表示 “此目录以及所有子目录，递归”。换句话说，它启用<font color=#FF0000>递归通配</font>

    ```py
    >>> sorted(Path('.').glob('**/*.py'))
    [PosixPath('build/lib/pathlib.py'),
     PosixPath('docs/conf.py'),
     PosixPath('pathlib.py'),
     PosixPath('setup.py'),
     PosixPath('test_pathlib.py')]
    ```

* Path.open(mode='r', buffering=-1, encoding=None, errors=None, newline=None)

    ```py
    >>> p = Path('setup.py')
    >>> with p.open() as f:
    ...     f.readline()
    ...
    '#!/usr/bin/env python3\n'
    ```

* Path.read_bytes()
* Path.write_text(data, encoding=None, errors=None)
* Path.read_text(encoding=None, errors=None)

    ```py
    >>> p = Path('my_text_file')
    >>> p.write_text('Text file contents')
    18
    >>> p.read_text()
    'Text file contents'
    ```

### 8.1. 对应的 os 模块的工具

os 和 os.path | pathlib
-------------|--------
os.path.abspath() | Path.resolve()
os.chmod() | Path.chmod()
os.mkdir() | Path.mkdir()
os.rename() | Path.rename()
os.replace() | Path.replace()
os.rmdir() | Path.rmdir()
os.remove(), os.unlink() | Path.unlink()
os.getcwd() | Path.cwd()
os.path.exists() | Path.exists()
os.path.expanduser() | Path.expanduser() 和 Path.home()
os.path.isdir() | Path.is_dir()
os.path.isfile() | Path.is_file()
os.path.islink() | Path.is_symlink()
os.stat() | Path.stat(), Path.owner(), Path.group()
os.path.isabs() | PurePath.is_absolute()
os.path.join() | PurePath.joinpath()
os.path.basename() | PurePath.name
os.path.dirname() | PurePath.parent
os.path.samefile() | Path.samefile()
os.path.splitext() | PurePath.suffix

## 9. time

```py
time.strftime('%Y-%m-%d', time.localtime())
# '2017-12-04'
```

## 10. datetime
> [官网: datetime](https://docs.python.org/3/library/datetime.html)

### 10.1. 获取当前时间

```sh
>>> from datetime import datetime
>>> now = datetime.now()
>>> print(now)
2015-05-18 16:28:07.198690
>>> print(type(now))
<class 'datetime.datetime'>
```

### 10.2. 获取指定日期和时间

```sh
>>> from datetime import datetime
>>> dt = datetime(2015, 4, 19, 12, 20) # 用指定日期时间创建datetime
>>> print(dt)
2015-04-19 12:20:00
```

两个datetime对象还可以进行比较。比如使用上面的t和t_next：

```py
print(t > t_next)
```

对日期和时间进行加减实际上就是把datetime往后或往前计算，得到新的datetime。加减可以直接用+和-运算符，不过需要导入timedelta这个类：

```sh
>>> from datetime import datetime, timedelta
>>> now = datetime.now()
>>> now
datetime.datetime(2015, 5, 18, 16, 57, 3, 540997)
>>> now + timedelta(hours=10)
datetime.datetime(2015, 5, 19, 2, 57, 3, 540997)
>>> now - timedelta(days=1)
datetime.datetime(2015, 5, 17, 16, 57, 3, 540997)
>>> now + timedelta(days=2, hours=12)
datetime.datetime(2015, 5, 21, 4, 57, 3, 540997)
```

### 10.3. datetime对象与字符串转换

```sh
>>> from datetime import datetime
>>> date_info = datetime.strptime('2015-6-1 18:19:59', '%Y-%m-%d %H:%M:%S')
>>> print(date_info)
2015-06-01 18:19:59
```

我们通过format来告知Python我们的str字符串中包含的日期的格式。在format中，%Y表示年所出现的位置, %m表示月份所出现的位置。

反过来，我们也可以调用datetime对象的strftime()方法，来将datetime对象转换为特定格式的字符串。比如上面所定义的t_next：

```sh
>>> from datetime import datetime
>>> now = datetime.now()
>>> print(now.strftime('%a, %b %d %H:%M'))
Mon, May 05 16:28
```

### 10.4. 本地时间转换为UTC时间

本地时间是指系统设定时区的时间，例如北京时间是UTC+8:00时区的时间，而UTC时间指UTC+0:00时区的时间。

一个datetime类型有一个时区属性tzinfo，但是默认为None，所以无法区分这个datetime到底是哪个时区，除非强行给datetime设置一个时区：

```sh
>>> from datetime import datetime, timedelta, timezone
>>> tz_utc_8 = timezone(timedelta(hours=8)) # 创建时区UTC+8:00
>>> now = datetime.now()
>>> now
datetime.datetime(2015, 5, 18, 17, 2, 10, 871012)
>>> dt = now.replace(tzinfo=tz_utc_8) # 强制设置为UTC+8:00
>>> dt
datetime.datetime(2015, 5, 18, 17, 2, 10, 871012, tzinfo=datetime.timezone(datetime.timedelta(0, 28800)))
```

如果系统时区恰好是UTC+8:00，那么上述代码就是正确的，否则，不能强制设置为UTC+8:00时区。

### 10.5. 时区转换

我们可以先通过utcnow()拿到当前的UTC时间，再转换为任意时区的时间：

```
# 拿到UTC时间，并强制设置时区为UTC+0:00:
>>> utc_dt = datetime.utcnow().replace(tzinfo=timezone.utc)
>>> print(utc_dt)
2015-05-18 09:05:12.377316+00:00
# astimezone()将转换时区为北京时间:
>>> bj_dt = utc_dt.astimezone(timezone(timedelta(hours=8)))
>>> print(bj_dt)
2015-05-18 17:05:12.377316+08:00
# astimezone()将转换时区为东京时间:
>>> tokyo_dt = utc_dt.astimezone(timezone(timedelta(hours=9)))
>>> print(tokyo_dt)
2015-05-18 18:05:12.377316+09:00
# astimezone()将bj_dt转换时区为东京时间:
>>> tokyo_dt2 = bj_dt.astimezone(timezone(timedelta(hours=9)))
>>> print(tokyo_dt2)
2015-05-18 18:05:12.377316+09:00
```

时区转换的关键在于，拿到一个datetime时，要获知其正确的时区，然后强制设置时区，作为基准时间。

利用带时区的datetime，通过astimezone()方法，可以转换到任意时区。

注：不是必须从UTC+0:00时区转换到其他时区，任何带时区的datetime都可以正确转换，例如上述bj_dt到tokyo_dt的转换。

## 11. random
> [官网](https://docs.python.org/zh-cn/3.7/library/random.html)

* random.random(): 随机浮点数, 0 <= n < 1.0
* random.uniform(a,b): 随机符点数, a <= n <= b
* random.randint(a, b): a <= n <= b
* random.randrange([start], stop[, step])

    从指定范围内，按指定基数递增的集合中获取一个随机数。

    random.randrange(10, 30, 2)，结果相当于从[10, 12, 14, 16, ... 26, 28]序列中获取一个随机数。

    random.randrange(10, 30, 2)在结果上与 `random.choice(range(10, 30, 2)` 等效。

* random.choice(sequence)
* random.shuffle(x[, random])

    用于将一个列表中的元素打乱,即将列表内的元素随机排列。

    ```py
    items = list("ABCDE")
    random.shuffle(items)  # 无返回
    print(items)
    ```

* random.sample(sequence, k)

    从指定序列中随机获取指定长度的片断并随机排列。

    注意：sample函数不会修改原有序列。

    ```py
    random.sample(range(10), 5)
    ```

## 12. glob
> [homepage](https://docs.python.org/3/library/glob.html)

类似 `os.listdir` 或 `os.scandir` 函数，但支持通配符（例如，能够选择特定的后缀名）。

```py
import glob
glob.glob(r'.\*.py') -> list_files
```

注意，glob支持使用 `**/` 表示递归遍历当前目录及其子目录，但需要配合 `recursive=True` 实现。

```py
glob(r'**/*.py', recursive=True)
glob(r'*/*.py', recursive=True)  # 表示：只查找某*目录下的 *.py 文件，而不包括当前目录
glob(r"**.py")  # 没有加 recursive 的 **，与 * 无异
```

## 13. pickle
> [homepage](https://docs.python.org/zh-cn/3/library/pickle.html)

用于序列化的两个模块

+ json：用于字符串和Python数据类型间进行转换
+ pickle: 用于python特有的类型和python的数据类型间进行转换

pickle可以存储什么类型的数据呢？

+ 所有python支持的原生类型：布尔值，整数，浮点数，复数，字符串，字节，None。
+ 由任何原生类型组成的列表，元组，字典和集合。
+ 函数，类，类的实例

```py
# dump功能
# dump 将数据通过特殊的形式转换为只有python语言认识的字符串，并写入文件
with open('D:/tmp.pk', 'w') as f:
    pickle.dump(data, f)

with open('D:/tmp.pk', 'r') as f:
    data = pickle.load(f)
```

## 14. json
> [homepage](https://docs.python.org/3/library/json.html)

+ json.dumps(data): 对数据进行编码
+ json.loads(str_data): 对数据进行解码

相应的文件操作为

+ json.dump(obj, fp, ...)
+ json.load(fp, ...)

```py
# 读取数据
with open('data.json', 'r') as fp:
    data = json.load(fp)

# 写入 JSON 数据
with open('data2.json', 'w') as fp:
    json.dump(data, fp,
              ensure_ascii=False,  # 输出中文
              indent=2)  # 用于自动换行（缩进2空格）
```

## 15. yaml

安装

```py
pip install pyyaml
```

Loader:

+ BaseLoader
+ SafeLoader
+ FullLOader
+ UnsafeLoader

你也可以使用以下 `shortcut methods` :

+ yaml.safe_load()
+ yaml.full_load()
+ yaml.unsafe_1oad()

```py
import yaml

# 读取数据
with open('data.yml', 'r') as fp:
    data = yaml.load(fp, Loader=yaml.loader.SafeLoader)

# 写入 yaml 数据
with open('data2.yml', 'w') as fp:
    yaml.dump(data, fp,
              allow_unicode=True,  # 输出中文
              indent=2)  # 用于自动换行（缩进2空格）
```

注意：yaml模块不同于json、pickle，没有提供 `loads()` 方法。但可以通过 `load()` 实现对字符串的读取。

## 16. Excel.xls格式
> [cnblog: python读、写、修改、追写excel文件](https://www.cnblogs.com/zhuminghui/p/9196773.html)

Python 操作 Excel 的4个工具包如下：

+ xlrd: 对 .xls 进行读相关操作
+ xlwt: 对 .xls 进行写相关操作
+ xlutils: 对 .xls 读写操作的整合
+ openpyxl: 对 .xlsx 进行读写操作

注意：

+ 前三个库都只能操作 .xls，不能操作 .xlsx
+ 最后一个只能操作 .xlsx，不能操作 .xls

### 16.1. 读取Excel表格

```py
import xlrd

data = xlrd.open_workbook('excelFile.xls') # 打开Excel文件读取数据

# 获取sheet
the_sheet = data.sheets()[0]              # 通过索引顺序获取（0是第一个sheet）
the_sheet = data.sheet_by_index(0)        # 通过索引顺序获取，同上
the_sheet = data.sheet_by_name(u'Sheet1') # 通过名称获取

# 获取数据，返回值为list
data_list.row_values(1) # 第二行数据（支持负索引取值）
data_list.col_values(1) # 第二列数据

# 获得行数和列数。
rows = the_sheet.nrows # 行数
cols = the_sheet.ncols # 列数
# 输出每一行数据
for i in range(rows):
    print(the_sheet.row_values(i))

# 获得指定单元格数据的三种方式
data = the_sheet.cell(0,0).value # 第一行第一列的值
data = the_sheet.row(0)[0].value # 第一行第一列
data = the_sheet.col(0)[0].value # 第一列第一行

data = the_sheet.cell(0,0).xf_index # 第一行第一列的背景色
data = the_sheet.row(0)[0].xf_index # 第一行第一列的背景色
data = the_sheet.col(0)[0].xf_index # 第一列第一行的背景色
```

### 16.2. 创建新的Excel表格

```py
import xlwt

wbk = xlwt.Workbook(encoding="utf-8") # 创建 xls 文件,可被复写
datasheet = wbk.add_sheet("sheet1") # 创建一个名为sheet1的sheet

# 设置单元格的样式，如字体、背景颜色等等
style = xlwt.easyxf('pattern: pattern solid, fore_colour red')

# 语法：write(n, m, "aaa", [style])===>第n行，第m列，内容, [样式](样式可以不指定，不指定即为默认样式)
datasheet.write(0, 0, "十年之前", style)
datasheet.write(0, 1, "我不认识你")
datasheet.write(1, 2, "你不属于我")
datasheet.write(2, 3, "我们还是一样")

# 合并单元格
worksheet.write_merge(3, 4, 0, 3, '赔在一个陌生人左右')
# 四个参数a,b,c,d：合并第 a 行到第 b 行，第 c 列到第 d 列

wbk.save("ttt.xls") # 保存
```

### 16.3. 修改Excel表格

```py
row=0 # 修改第一行
col=0 # 修改第一列

# ctype: 0-->empty,1-->string,2-->number,3-->date,4-->boolean,5-->error
cell_type=1 # 修改类型
value='你说你不懂我为何在这时牵手' # 修改内容
cell_A1=the_sheet.cell(0,0).value # 获取第一行第一列的值

format=0
the_sheet.put_cell(row, col, cell_type, value, format) # 修改操作
cell_A1=the_sheet.cell(0,0).value # 再看一下，值已被改
```

### 16.4. xlutils 追写 Excel

<font color=#FF0000>xlwt只能创建一个全新的Excel文件</font>，然后对这个文件进行写入内容以及保存。

但是大多数情况下需求会是读入一个Excel文件，然后进行修改或追加，这个时候，就决定用你了——xlutils.

```py
from xlrd import open_workbook
from xlutils.copy import copy

# 用 xlrd 提供的方法读取一个excel文件
rexcel = open_workbook("ttt.xls",formatting_info=True) # 保留原有样式
# 用 xlrd 提供的方法获得现在已有的行数
rows = rexcel.sheets()[0].nrows
# 用 xlutils 提供的copy方法将 xlrd 的对象转化为 xlwt 的对象
excel = copy(rexcel)
# 用 xlwt 对象的方法获得要操作的 sheet
table = excel.get_sheet(0)
values = ["1", "2", "3"]
row = rows
for value in values:
    table.write(row, 0, value) # xlwt对象的写方法，参数分别是行、列、值
    table.write(row, 1, "haha")
    table.write(row, 2, "lala")
    row += 1
excel.save("ttt.xls") # xlwt 对象的保存方法，这时便覆盖掉了原来的 Excel
```

### 16.5. 读写xlsx格式
> [cnblog: python操作Excel模块openpyxl](https://www.cnblogs.com/zeke-python-road/p/8986318.html)

`openpyxl` 模块是一个读写 Excel 2010 文档的 Python 库，不支持更早格式的 Excel，openpyxl 模块支持同时读取和修改Excel文档。

openpyxl 模块默认可读可写，若只需要读或者写的功能，可以在 open 时指定 write_only 或 read_only 为 True。

注：openpyxl 只能操作 .xlsx，若需要插入图片需要安装 pillow 库

```py
import openpyxl

# 打开已有的 .xlsx
data = openpyxl.load_workbook('xxx.xlsx') # 可读可写
data = openpyxl.load_workbook('xxx.xlsx', read_only=True) # 只读
data = openpyxl.load_workbook('xxx.xlsx', write_only=True) # 只写

# 创建一个新的 .xlsx
wb = openpyxl.Workbook()
# ...
wb.save('xxxxxxx.xlsx') # 保存
```

## 17. math
> [homepage](https://docs.python.org/3/library/math.html)

| 函数名 | 意义 |
| -- | -- |
| math.e | 自然常数 e |
| math.pi | 圆周率 pi |
| math.degrees(x) | 弧度转度 |
| math.radians(x) | 度转弧度 |
| math.exp(x) | 返回 e 的 x 次方 |
| math.expm1(x) | 返回 e 的 x 次方减 1 |
| math.log(x[, base]) | 返回 x 的以 base 为底的对数，base 默认为 e |
| math.log10(x) | 返回 x 的以 10 为底的对数 |
| math.log1p(x) | 返回 1+x 的自然对数（以 e 为底） |
| math.pow(x, y) | 返回 x 的 y 次方 |
| math.sqrt(x) | 返回 x 的平方根 |
| math.ceil(x) | 返回不小于 x 的整数 |
| math.floor(x) | 返回不大于 x 的整数 |
| math.trunc(x) | 返回 x 的整数部分 |
| math.modf(x) | 返回 x 的小数和整数 |
| math.fabs(x) | 返回 x 的绝对值 |
| math.fmod(x, y) | 返回 x%y（取余） |
| math.fsum([x, y, ...]) | 返回无损精度的和 |
| math.factorial(x) | 返回 x 的阶乘 |
| math.isinf(x) | 若 x 为无穷大，返回 True；否则，返回 False |
| math.isnan(x) | 若 x 不是数字，返回 True；否则，返回 False |
| math.hypot(x, y) | 返回以 x 和 y 为直角边的斜边长 |
| math.copysign(x, y) | 若 y<0，返回 - 1 乘以 x 的绝对值；否则，返回 x 的绝对值 |
| math.frexp(x) | 返回 m 和 i，满足 m 乘以 2 的 i 次方 |
| math.ldexp(m, i) | 返回 m 乘以 2 的 i 次方 |
| math.sin(x) | 返回 x（弧度）的三角正弦值 |
| math.asin(x) | 返回 x 的反三角正弦值 |
| math.cos(x) | 返回 x（弧度）的三角余弦值 |
| math.acos(x) | 返回 x 的反三角余弦值 |
| math.tan(x) | 返回 x（弧度）的三角正切值 |
| math.atan(x) | 返回 x 的反三角正切值 |
| math.atan2(x, y) | 返回 x/y 的反三角正切值 |
| math.sinh(x) | 返回 x 的双曲正弦函数 |
| math.asinh(x) | 返回 x 的反双曲正弦函数 |
| math.cosh(x) | 返回 x 的双曲余弦函数 |
| math.acosh(x) | 返回 x 的反双曲余弦函数 |
| math.tanh(x) | 返回 x 的双曲正切函数 |
| math.atanh(x) | 返回 x 的反双曲正切函数 |
| math.erf(x) | 返回 x 的误差函数 |
| math.erfc(x) | 返回 x 的余误差函数 |
| math.gamma(x) | 返回 x 的伽玛函数 |
| math.lgamma(x) | 返回 x 的绝对值的自然对数的伽玛函数 |

## 18. functools
> [官网](https://docs.python.org/3/library/functools.html)

### 18.1. partial

functools.partial(func, /, *args, **keywords)

## 19. itertools
> [官网](https://docs.python.org/3/library/itertools.html)

可以实现诸如 `A(4,2), C(5,3)` 此类的运算。这里列举几个常用功能。

Iterator | Arguments | Results
---------|-----------|--------
product() | p, q, … [repeat=1] | cartesian product, equivalent to a nested for-loop
permutations() | p[, r] | r-length tuples, all possible orderings, no repeated elements
combinations() | p, r | r-length tuples, in sorted order, no repeated elements
combinations_with_replacement() | p, r | r-length tuples, in sorted order, with repeated elements

Examples | Results
---------|--------
product('ABCD', repeat=2) | AA AB AC AD BA BB BC BD CA CB CC CD DA DB DC DD
permutations('ABCD', 2) | AB AC AD BA BC BD CA CB CD DA DB DC
combinations('ABCD', 2) | AB AC AD BC BD CD
combinations_with_replacement('ABCD', 2) | AA AB AC AD BB BC BD CC CD DD

## 20. traceback
> [homepage](https://docs.python.org/3/library/traceback.html)

`print_exc` 是简化版的 `print_exception` , 由于exception type, value和traceback object都可以通过sys.exc_info()获取，因此print_exc()就自动执行exc_info()来帮助获取这三个参数了，也因此<font color=#FF0000>这个函数是我们的程序中最常用的</font>，因为它足够简单。

```py
try:
    ...
except Exception as e:
    traceback.print_exc(limit=1, file=sys.stdout)
```

`format_exc` 也是最常用的函数，它跟 `print_exc` 用法相同，只是不直接打印而是返回了字符串。

```py
try:
    ...
except Exception as e:
    logger.error(traceback.format_exc(limit=1, file=sys.stdout))
```

### 20.1. 获取线程中的异常信息

通常情况下我们无法将多线程中的异常带回主线程，所以也就无法打印线程中的异常，而通过上边学到这些知识，我们可以对线程做如下修改，从而实现捕获线程异常的目的。

```py
import threading
import traceback

def my_func():
    raise BaseException("thread exception")

class ExceptionThread(threading.Thread):

    def __init__(self, group=None, target=None, name=None, args=(), kwargs=None, verbose=None):
        """
        Redirect exceptions of thread to an exception handler.
        """
        threading.Thread.__init__(self, group, target, name, args, kwargs, verbose)
        if kwargs is None:
            kwargs = {}
        self._target = target
        self._args = args
        self._kwargs = kwargs
        self._exc = None

    def run(self):
        try:
            if self._target:
                self._target()
        except BaseException as e:
            import sys
            self._exc = sys.exc_info()
        finally:
            #Avoid a refcycle if the thread is running a function with
            #an argument that has a member that points to the thread.
            del self._target, self._args, self._kwargs

    def join(self):
        threading.Thread.join(self)
        if self._exc:
            msg = "Thread '%s' threw an exception: %s" % (self.getName(), self._exc[1])
            new_exc = Exception(msg)
            raise new_exc.__class__, new_exc, self._exc[2]


t = ExceptionThread(target=my_func, name='my_thread')
t.start()
try:
    t.join()
except:
    traceback.print_exc()
```

这样我们就得到了线程中的异常信息。

## 21. operator
> [官网](https://docs.python.org/3/library/operator.html)

* operator.__lt__(a, b)
* operator.__le__(a, b)
* operator.__eq__(a, b)
* operator.__ne__(a, b)
* operator.__ge__(a, b)
* operator.__gt__(a, b)

Operation | Syntax | Function
----------|--------|---------
Addition | a + b | add(a, b)
Concatenation | seq1 + seq2 | concat(seq1, seq2)
Containment Test | obj in seq | contains(seq, obj)
Division | a / b | truediv(a, b)
Division | a // b | floordiv(a, b)
Bitwise And | a & b | and_(a, b)
Bitwise Exclusive Or | a ^ b | xor(a, b)
Bitwise Inversion | ~ a | invert(a)
Bitwise Or | a | b | or_(a, b)
Exponentiation | a ** b | pow(a, b)
Identity | a is b | is_(a, b)
Identity | a is not b | is_not(a, b)
Indexed Assignment | obj[k] = v | setitem(obj, k, v)
Indexed Deletion | del obj[k] | delitem(obj, k)
Indexing | obj[k] | getitem(obj, k)
Left Shift | a << b | lshift(a, b)
Modulo | a % b | mod(a, b)
Multiplication | a * b | mul(a, b)
Matrix Multiplication | a @ b | matmul(a, b)
Negation (Arithmetic) | - a | neg(a)
Negation (Logical) | not a | not_(a)
Positive | + a | pos(a)
Right Shift | a >> b | rshift(a, b)
Slice Assignment | seq[i:j] = values | setitem(seq, slice(i, j), values)
Slice Deletion | del seq[i:j] | delitem(seq, slice(i, j))
Slicing | seq[i:j] | getitem(seq, slice(i, j))
String Formatting | s % obj | mod(s, obj)
Subtraction | a - b | sub(a, b)
Truth Test | obj | truth(obj)
Ordering | a < b | lt(a, b)
Ordering | a <= b | le(a, b)
Equality | a == b | eq(a, b)
Difference | a != b | ne(a, b)
Ordering | a >= b | ge(a, b)
Ordering | a > b | gt(a, b)

## 22. base64

Base64是一种通过查表的编码方法，不能用于加密，即使使用自定义的编码表也不行。Base64适用于小段内容的编码，比如<font color=#FF0000>数字证书签名、Cookie</font>的内容等。

Python内置的base64可以直接进行base64的编解码：

```sh
>>> import base64
>>> base64.b64encode(b'binary\x00string')
b'YmluYXJ5AHN0cmluZw=='
>>> base64.b64decode(b'YmluYXJ5AHN0cmluZw==')
b'binary\x00string'
```

由于标准的Base64编码后可能出现字符+和/，在URL中就不能直接作为参数，所以又有一种"url safe"的base64编码，其实就是把字符+和/分别变成-和_：

```sh
>>> base64.b64encode(b'i\xb7\x1d\xfb\xef\xff')
b'abcd++//'
>>> base64.urlsafe_b64encode(b'i\xb7\x1d\xfb\xef\xff')
b'abcd--__'
>>> base64.urlsafe_b64decode('abcd--__')
b'i\xb7\x1d\xfb\xef\xff'
```

还可以自己定义64个字符的排列顺序，这样就可以自定义Base64编码，不过，通常情况下完全没有必要。

由于=字符也可能出现在Base64编码中，但=用在URL、Cookie里面会造成歧义，所以，很多Base64编码后会把=去掉：

```sh
# 标准Base64:
'abcd' -> 'YWJjZA=='
# 自动去掉=:
'abcd' -> 'YWJjZA'
```

去掉=后怎么解码呢？因为Base64是把3个字节变为4个字节，所以，Base64编码的长度永远是4的倍数，因此，需要加上=把Base64字符串的长度变为4的倍数，就可以正常解码了。

## 23. contextlib: with语句的实现
> [homepage](https://docs.python.org/3/library/contextlib.html)

contextlib 模块包含用于处理上下文管理器和 with 语句的实用程序。

## 24. pkgutil

### 24.1. 扩展PythonPath
> [pkgutil — 扩展包工具](https://learnku.com/docs/pymotw/pkgutil-package-utilities/3493)

```py
__path__ = pkgutil.extend_path(__path__, __name__)
```

效果等同于：

+ `site.addsitedir()`
+ `sys.path.append()`

### 24.2. 读取包中的数据文件
> [知乎: 在Python中读取包中的数据文件的三种方式](https://zhuanlan.zhihu.com/p/67073788)

由于工作目录与包目录不同，无法直接通过相对路径读取包内的数据文件（如data.json）。那么，有三种方法解决以上问题：

+ 直接使用绝对路径（不推荐）
+ 通过__file__获取read.py文件的绝对路径，然后通过相对路径获取数据文件
+ 通过pkgutil获取：

    ```py
    data_bytes = pkgutil.get_data(__package__, 'data.txt')
    data_str = data_bytes.decode()
    ```

pkgutil是Python自带的用于包管理相关操作的库

使用pkgutil还有一个好处，就是只要知道包名就可以找到对应包下面的数据文件，数据文件并不一定要在当前包里面。

```py
data_bytes = pkgutil.get_data("another_pkg", 'data2.txt')
data_str = data_bytes.decode()
```

### 24.3. 获取包里面的所有模块列表

python推荐使用 `pkgutil.iter_modules(path=None, prefix='')`

效果等同于：

```py
def get_modules(package="."):
    """
    获取包名下所有非__init__的模块名
    """
    modules = []
    files = os.listdir(package)

    for file in files:
        if not file.startswith("__"):
            name, ext = os.path.splitext(file)
            modules.append("." + name)

    return modules
```

### 24.4. pkgutil.walk_packages()
> [csdn: Python加载插件的方法 - pkgutil.walk_packages()的应用](https://blog.csdn.net/qq_43280079/article/details/104314227)

在我们要管理自己的软件时，经常要加入功能，靠写死的代码来实现添加功能，显然是不现实的，所以经常要预留一些接口，然后通过这些接口，来编写插件，从而把我们需要的功能添加到我们的程序里面。而怎么才能把我们的插件加载进我们的程序里面呢？不多说了，直接上代码。

```py
import pkgutil

_plugins_before_listen = []  #插件列表
nameSet = set()

for finder,name,ispck in pkgutil.walk_packages(["./packge"]):  #要主要这个文件目录参数是一个列表
    loader = finder.find_module(name)  #返回一个loader对象或者None。
    mod = loader.load_module(name)  #返回一个module对象或者raise an exception
    nameSet.add(mod.SLUG)  #用SLUG来标识每个功能模块
    _plugins_before_listen.append(mod)  #把模块加入列表中，方便使用


print(nameSet)  #打印识别出来的标识
print(_plugins_before_listen)  #打印出插件列表
print(_plugins_before_listen[1])  #看一下
_plugins[1].start()  #用一下
```
