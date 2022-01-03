<!--
+++
title       = "VSCode配置"
description = "1. VSCode预定义变量; 2. C++项目调试环境"
date        = "2022-01-03"
tags        = []
categories  = ["1-os管理","15-desktop"]
series      = []
keywords    = []
weight      = 3
toc         = true
draft       = false
+++ -->

[TOC]

---

## 1. VSCode预定义变量

预定义变量 | 值 | 含义解释
------|---|-----
${workspaceFolder} | c:\jawide | 工作目录的绝对路径
${workspaceRoot} | C:\jawide | 工作目录的绝对路径
${workspaceRootFolderName} | jawide | 工作目录名
${file} | C:\jawide\main\demo.c | 文件的绝对路径
${relativeFile} | main\demo.c | 文件的相对路径
${fileBasenameNoExtension} | demo | 文件名（无扩展名）
${fileBasename} | demo.c | 文件名
${fileDirname} | C:\jawide\main | 所处文件夹的绝对路径
${fileExtname} | .c | 文件扩展名
${lineNumber} | 5 | 当前行号
${env:PATH} |  | 环境变量

## 2. C++项目调试环境

```json
{
    // 使用 IntelliSense 了解相关属性。
    // 悬停以查看现有属性的描述。
    // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "g++ - demo",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceRoot}/build/src/demo",  // ${fileDirname}/${fileBasenameNoExtension}
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "为 gdb 启用整齐打印",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "my_cmk_build",
            "miDebuggerPath": "/usr/bin/gdb"
        }
    ]
}
```

* program, 调试的二进制程序

    对于单文件调试，可以通过 `${fileDirname}/${fileBasenameNoExtension}` 来配置；但对于项目来说，可能需要手动配置执行路径。注意，Debug/Release可能因为cmake配置，生成在特定的目录。

* preLaunchTask, 调试前编译

    这里，调用了task.json配置文件中自定义的编译方式

```json
// task.json配置
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "label": "my_cmk_build",
            "type": "shell",
            "command": "cmk debug"
        }
    ]
}
```

这里可以完全自定义编译过程，如调用自定义的脚本 `cmk` 及参数。
