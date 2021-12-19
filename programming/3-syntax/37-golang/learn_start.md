<!--
+++
title       = "Golang语法"
description = "1. 10min语法速学; 2. 常用命令; 3. Go Modules & goproxy.cn; 4. 进阶; 5. 标准库; 6. 第三方库"
date        = "2021-12-19"
tags        = []
categories  = ["3-syntax","37-golang"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

本文内容选自：[github: Go学习之路（入门教程集合）](https://github.com/talkgo/read)

## 1. 10min语法速学

+ [Go简明教程](https://geektutu.com/post/quick-golang.html)
+ [对比学习：Golang VS Python3](https://juejin.im/post/5cd945d6e51d453d022cb65f)
+ [Go各版本的语法更新与Go2.0展望](https://geektutu.com/post/quick-go2.html)
+ [直接看点示例代码吧，学习+实践](https://gobyexample-cn.github.io/)

不想粘贴教程，但初学真的记不住，来回查找还不如先集中在一起。熟练了再删掉……

### 1.1. 错误机制

error 往往是能预知的错误，但是也可能出现一些不可预知的错误，例如数组越界，这种错误可能会导致程序非正常退出，在 Go 语言中称之为 panic。

在 Python、Java 等语言中有 try...catch 机制，在 try 中捕获各种类型的异常，在 catch 中定义异常处理的行为。Go 语言也提供了类似的机制 defer 和 recover。

```go
func get(index int) (ret int) {
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("Some error happened!", r)
            ret = -1
        }
    }()
    arr := [3]int{2, 3, 4}
    return arr[index]
}

func main() {
    fmt.Println(get(5))
    fmt.Println("finished")
}
```

在 get 函数中，使用 defer 定义了异常处理的函数，在协程退出前，会执行完 defer 挂载的任务。因此如果触发了panic，控制权就交给了defer。

```
$ go run .
Some error happened! runtime error: index out of range [5] with length 3
-1
finished
```

在 defer 的处理逻辑中，使用 recover 使程序恢复正常，并且将返回值设置为 -1，在这里也可以不处理返回值，如果不处理返回值，返回值将被置为默认值 0。

---

panic 的一种常见用法是：当函数返回我们不知道如何处理（或不想处理）的错误值时，中止操作。 如果创建新文件时遇到意外错误该如何处理？这里有一个很好的 panic 示例。

```go
func main() {

    panic("a problem")

    _, err := os.Create("/tmp/file")
    if err != nil {
        panic(err)
    }
}
```

---

Defer 用于确保程序在执行完成后，会调用某个函数，一般是执行清理工作。

```go
func main() {
    f := createFile("/tmp/defer.txt")
    defer closeFile(f)
    writeFile(f)
}
```

在 createFile 后立即得到一个文件对象， 我们使用 defer 通过 closeFile 来关闭这个文件。 这会在封闭函数（main）结束时执行，即 writeFile 完成以后。

#### 1.1.1. 总结

实际上，Golang如此的处理，继承自Google对C++的编程规范——不允许使用 Exception 机制。

Exception有如下特性:

+ 相比errcode, 具有明确的语义
+ try...catch... 可以实现代码跨层级跳转
+ 通过Exception类继承，可以使用基类捕获不明确的错误类型

而Golang，由于不允许跳转，所以未实现try模式。panic则是作为第三个目的而实现的。

## 2. 常用命令

+ go run xxx.go
+ go build xxx.go
+ go get
+ go install
+ gofmt
+ gRPC

## 3. Go Modules & goproxy.cn

### 3.1. goproxy.cn

从 Go 1.11 版本开始，Go 提供了 Go Modules 的机制，推荐设置以下环境变量，第三方包的下载将通过国内镜像，避免出现官方网址被屏蔽的问题。

```sh
$ go env -w GOPROXY=https://goproxy.cn,direct
```

或在 `~/.profile` 中设置环境变量

```sh
export GOPROXY=https://goproxy.cn
```

### 3.2. "module" != "package"

有一点需要纠正，就是“模块”和“包”，也就是 “module” 和 “package” 这两个术语并不是等价的，是 “集合” 跟 “元素” 的关系，“模块” 包含 “包”，“包” 属于 “模块”，一个 “模块” 是零个、一个或多个 “包” 的集合。


## 4. 进阶
> [大道至简—GO语言最佳实践](https://mp.weixin.qq.com/s/hE7ecSywWY8SxoQV0OwBQg)

+ GO语言关键特性
    * 并发与协程
    * 基于消息传递的通信方式
    * 丰富实用的内置数据类型
    * 函数多返回值
    * Defer延迟处理机制
    * 反射(reflect)
    * 高性能HTTP Server
    * 工程管理
    * 编程规范
+ API框架的实现
+ 公共组件能力
    * 通用列表组件
    * 通用表单组件
    * 协程池
    * 数据校验

## 5. 标准库

+ [官方文档](https://golang.org/pkg/)
+ [中文解析](https://www.jianshu.com/p/33fc2a3bed9a)
    * time
    * sync
    * fmt
    * strconv
    * errors
    * container
    * path
    * net/http
    * net/http/httptest
    * database/sql
    * encoding/json
    * ioutil.ReadFile
    * os.Open
        - fp.Read
    * io.ReadAtLeast
    * bufio
        * NewReader
        - ReadLine
    * bytes
    * reflect
    * context
    * flag - 命令行参数解析

### 5.1. builtin

```go
func append(slice []Type, elems ...Type) []Type
func cap(v Type) int
func close(c chan<- Type)
func complex(r, i FloatType) ComplexType
func copy(dst, src []Type) int
func delete(m map[Type]Type1, key Type)
func imag(c ComplexType) FloatType
func len(v Type) int
func make(t Type, size ...IntegerType) Type
func new(Type) *Type
func panic(v interface{})
func print(args ...Type)
func println(args ...Type)
func real(c ComplexType) FloatType
func recover() interface{}
```
### 5.2. time

```go
Now()
String(): 转换为string
```

### 5.3. bytes
> [homepage](https://golang.org/pkg/bytes/)

```go
func Compare(a, b []byte) int
func Contains(b, subslice []byte) bool
func ContainsAny(b []byte, chars string) bool
func ContainsRune(b []byte, r rune) bool
func Count(s, sep []byte) int
func Equal(a, b []byte) bool
func EqualFold(s, t []byte) bool
func Fields(s []byte) [][]byte
func FieldsFunc(s []byte, f func(rune) bool) [][]byte
func HasPrefix(s, prefix []byte) bool
func HasSuffix(s, suffix []byte) bool
func Index(s, sep []byte) int
func IndexAny(s []byte, chars string) int
func IndexByte(b []byte, c byte) int
func IndexFunc(s []byte, f func(r rune) bool) int
func IndexRune(s []byte, r rune) int
func Join(s [][]byte, sep []byte) []byte
func LastIndex(s, sep []byte) int
func LastIndexAny(s []byte, chars string) int
func LastIndexByte(s []byte, c byte) int
func LastIndexFunc(s []byte, f func(r rune) bool) int
func Map(mapping func(r rune) rune, s []byte) []byte
func Repeat(b []byte, count int) []byte
func Replace(s, old, new []byte, n int) []byte
func ReplaceAll(s, old, new []byte) []byte
func Runes(s []byte) []rune
func Split(s, sep []byte) [][]byte
func SplitAfter(s, sep []byte) [][]byte
func SplitAfterN(s, sep []byte, n int) [][]byte
func SplitN(s, sep []byte, n int) [][]byte
func Title(s []byte) []byte
func ToLower(s []byte) []byte
func ToLowerSpecial(c unicode.SpecialCase, s []byte) []byte
func ToTitle(s []byte) []byte
func ToTitleSpecial(c unicode.SpecialCase, s []byte) []byte
func ToUpper(s []byte) []byte
func ToUpperSpecial(c unicode.SpecialCase, s []byte) []byte
func ToValidUTF8(s, replacement []byte) []byte
func Trim(s []byte, cutset string) []byte
func TrimFunc(s []byte, f func(r rune) bool) []byte
func TrimLeft(s []byte, cutset string) []byte
func TrimLeftFunc(s []byte, f func(r rune) bool) []byte
func TrimPrefix(s, prefix []byte) []byte
func TrimRight(s []byte, cutset string) []byte
func TrimRightFunc(s []byte, f func(r rune) bool) []byte
func TrimSpace(s []byte) []byte
func TrimSuffix(s, suffix []byte) []byte
type Buffer
    func NewBuffer(buf []byte) *Buffer
    func NewBufferString(s string) *Buffer
    func (b *Buffer) Bytes() []byte
    func (b *Buffer) Cap() int
    func (b *Buffer) Grow(n int)
    func (b *Buffer) Len() int
    func (b *Buffer) Next(n int) []byte
    func (b *Buffer) Read(p []byte) (n int, err error)
    func (b *Buffer) ReadByte() (byte, error)
    func (b *Buffer) ReadBytes(delim byte) (line []byte, err error)
    func (b *Buffer) ReadFrom(r io.Reader) (n int64, err error)
    func (b *Buffer) ReadRune() (r rune, size int, err error)
    func (b *Buffer) ReadString(delim byte) (line string, err error)
    func (b *Buffer) Reset()
    func (b *Buffer) String() string
    func (b *Buffer) Truncate(n int)
    func (b *Buffer) UnreadByte() error
    func (b *Buffer) UnreadRune() error
    func (b *Buffer) Write(p []byte) (n int, err error)
    func (b *Buffer) WriteByte(c byte) error
    func (b *Buffer) WriteRune(r rune) (n int, err error)
    func (b *Buffer) WriteString(s string) (n int, err error)
    func (b *Buffer) WriteTo(w io.Writer) (n int64, err error)
type Reader
    func NewReader(b []byte) *Reader
    func (r *Reader) Len() int
    func (r *Reader) Read(b []byte) (n int, err error)
    func (r *Reader) ReadAt(b []byte, off int64) (n int, err error)
    func (r *Reader) ReadByte() (byte, error)
    func (r *Reader) ReadRune() (ch rune, size int, err error)
    func (r *Reader) Reset(b []byte)
    func (r *Reader) Seek(offset int64, whence int) (int64, error)
    func (r *Reader) Size() int64
    func (r *Reader) UnreadByte() error
    func (r *Reader) UnreadRune() error
    func (r *Reader) WriteTo(w io.Writer) (n int64, err error)
```

### 5.4. strings
> [homepage](https://golang.org/pkg/strings/)

```go
func Compare(a, b string) int
func Join(elems []string, sep string) string
func Count(s, substr string) int

func Contains(s, substr string) bool
// func ContainsAny(s, chars string) bool
// func ContainsRune(s string, r rune) bool
// func EqualFold(s, t string) bool
func Fields(s string) []string
func FieldsFunc(s string, f func(rune) bool) []string

func HasPrefix(s, prefix string) bool
func HasSuffix(s, suffix string) bool

func Index(s, substr string) int
// func IndexAny(s, chars string) int
func IndexByte(s string, c byte) int
// func IndexFunc(s string, f func(rune) bool) int
// func IndexRune(s string, r rune) int

func LastIndex(s, substr string) int
// func LastIndexAny(s, chars string) int
func LastIndexByte(s string, c byte) int
// func LastIndexFunc(s string, f func(rune) bool) int
// func Map(mapping func(rune) rune, s string) string

func Repeat(s string, count int) string
// func Replace(s, old, new string, n int) string
func ReplaceAll(s, old, new string) string

func Split(s, sep string) []string
func SplitAfter(s, sep string) []string
// func SplitAfterN(s, sep string, n int) []string
// func SplitN(s, sep string, n int) []string

func Title(s string) string
func ToTitle(s string) string
// func ToTitleSpecial(c unicode.SpecialCase, s string) string
func ToUpper(s string) string
func ToLower(s string) string
// func ToUpperSpecial(c unicode.SpecialCase, s string) string
// func ToLowerSpecial(c unicode.SpecialCase, s string) string
// func ToValidUTF8(s, replacement string) string

func Trim(s string, cutset string) string
// func TrimFunc(s string, f func(rune) bool) string
func TrimSpace(s string) string

func TrimLeft(s string, cutset string) string
func TrimRight(s string, cutset string) string
// func TrimLeftFunc(s string, f func(rune) bool) string
// func TrimRightFunc(s string, f func(rune) bool) string
func TrimPrefix(s, prefix string) string
func TrimSuffix(s, suffix string) string
```
### 5.5. fmt
> [homepage](https://golang.org/pkg/fmt/)

```go
func Sprintf(format string, a ...interface{}) string
func Errorf(format string, a ...interface{}) error
```

### 5.6. errors

### 5.7. path

```go
func Base(path string) string
func Clean(path string) string
func Dir(path string) string
func Ext(path string) string
func IsAbs(path string) bool
func Join(elem ...string) string
func Match(pattern, name string) (matched bool, err error)
func Split(path string) (dir, file string)
```

#### 5.7.1. path/filepath

```go
func IsAbs(path string) bool
func Abs(path string) (string, error)
func Rel(basepath, targpath string) (string, error)

func Base(path string) string
func Clean(path string) string
func Split(path string) (dir, file string)
func SplitList(path string) []string

func Dir(path string) string
func Ext(path string) string
// func FromSlash(path string) string
// func ToSlash(path string) string

func HasPrefix(p, prefix string) bool
func Join(elem ...string) string
// func VolumeName(path string) string
// func EvalSymlinks(path string) (string, error)

func Match(pattern, name string) (matched bool, err error)
func Glob(pattern string) (matches []string, err error)
func Walk(root string, walkFn WalkFunc) error
```

### 5.8. os
> [homepage](https://golang.org/pkg/os/)

exec包执行外部命令，它将os.StartProcess进行包装使得它更容易映射到stdin和stdout，并且利用pipe连接i/o．

```go
func Chdir(dir string) error
func Environ() []string
func Getenv(key string) string

func Getwd() (dir string, err error)
func Hostname() (name string, err error)
func IsExist(err error) bool
func IsNotExist(err error) bool

func Mkdir(name string, perm FileMode) error
func MkdirAll(path string, perm FileMode) error

func Remove(name string) error
func RemoveAll(path string) error
func Rename(oldpath, newpath string) error
func SameFile(fi1, fi2 FileInfo) bool

func Open(name string) (*File, error)

type Process
    func FindProcess(pid int) (*Process, error)
    func StartProcess(name string, argv []string, attr *ProcAttr) (*Process, error)
    func (p *Process) Kill() error
    func (p *Process) Release() error
    func (p *Process) Signal(sig Signal) error
    func (p *Process) Wait() (*ProcessState, error)
type ProcessState
    func (p *ProcessState) ExitCode() int
    func (p *ProcessState) Exited() bool
    func (p *ProcessState) Pid() int
    func (p *ProcessState) String() string
    func (p *ProcessState) Success() bool
    func (p *ProcessState) Sys() interface{}
    func (p *ProcessState) SysUsage() interface{}
    func (p *ProcessState) SystemTime() time.Duration
    func (p *ProcessState) UserTime() time.Duration
```

#### 5.8.1. os/exec
> [homepage](https://golang.org/pkg/os/exec/)

```go
func LookPath(file string) (string, error)
type Cmd
    func Command(name string, arg ...string) *Cmd
    func CommandContext(ctx context.Context, name string, arg ...string) *Cmd
    func (c *Cmd) CombinedOutput() ([]byte, error)
    func (c *Cmd) Output() ([]byte, error)
    func (c *Cmd) Run() error
    func (c *Cmd) Start() error
    func (c *Cmd) StderrPipe() (io.ReadCloser, error)
    func (c *Cmd) StdinPipe() (io.WriteCloser, error)
    func (c *Cmd) StdoutPipe() (io.ReadCloser, error)
    func (c *Cmd) String() string
    func (c *Cmd) Wait() error
```

### 5.9. io

#### 5.9.1. interface: io.Reader/Writer
> [csdn: golang中的io.Reader/Writer](https://blog.csdn.net/u013007900/article/details/89126811)
>
> [简书: Go编程技巧-io.Reader/Writer](https://www.jianshu.com/p/758c4e2b4ab8)

![](https://img2020.cnblogs.com/blog/2039866/202007/2039866-20200721215540281-1605799289.jpg) <!-- learn_start/learn_start-0.jpg -->

围绕io.Reader/Writer，有几个常用的实现：

+ net.Conn, os.Stdin, os.File: 网络、标准输入输出、文件的流读取
+ strings.Reader: 把字符串抽象成Reader
+ bytes.Reader: 把[]byte抽象成Reader
+ bytes.Buffer: 把[]byte抽象成Reader和Writer
+ bufio.Reader/Writer: 抽象成带缓冲的流读取（比如按行读写）

#### 5.9.2. io/ioutil
> [homepage](https://golang.org/pkg/io/ioutil/)

```go
func NopCloser(r io.Reader) io.ReadCloser
func ReadAll(r io.Reader) ([]byte, error)
func ReadDir(dirname string) ([]os.FileInfo, error)
func ReadFile(filename string) ([]byte, error)
func TempDir(dir, pattern string) (name string, err error)
func TempFile(dir, pattern string) (f *os.File, err error)
func WriteFile(filename string, data []byte, perm os.FileMode) error
```

### 5.10. bufio
> [homepage](https://golang.org/pkg/bufio/)

```go
func NewReader(rd io.Reader) *Reader

```

### 5.11. net

#### 5.11.1. net/http

```go
func Get(url string) (resp *Response, err error)
func Head(url string) (resp *Response, err error)
func Post(url, contentType string, body io.Reader) (resp *Response, err error)
func PostForm(url string, data url.Values) (resp *Response, err error)
```

## 6. 第三方库

+ [Awesome Go](https://awesome-go.com/)
+ [AwesomeGo_中文版](https://github.com/yinggaozhen/awesome-go-cn/blob/master/README.md)
+ [GoCV](https://github.com/hybridgroup/gocv)
    * [Examples](https://github.com/hybridgroup/gocv/tree/master/cmd)
+ [Gophernotes](https://github.com/gopherdata/gophernotes)
+ [go-chi](https://github.com/go-chi/chi)
+ [gorilla/mux](https://github.com/gorilla/mux)
