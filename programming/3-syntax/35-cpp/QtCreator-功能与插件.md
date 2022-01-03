<!--
+++
title       = "【转载】QtCreator的结构、功能和插件体系"
description = "1. 使用QtCreator; 2. IDE插件; 3. 编译工具链"
date        = "2022-01-03"
tags        = []
categories  = ["3-syntax","35-cpp"]
series      = []
keywords    = []
weight      = 5
toc         = true
draft       = false
+++ -->

[TOC]

---

> [cnblog: qt creator源码全方面分析](https://www.cnblogs.com/codeForFamily/category/1641809.html)
>
> [Qt官网](https://doc.qt.io/qtcreator/index.html)

## 1. 使用QtCreator

### 1.1. IDE添加UI组件

> [Common Extension Tasks](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-2.html)

本节总结了可用于将UI组件添加到Qt Creator的API函数。

### 1.2. IDE添加外部工具

> [External Tool Specification Files](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-3.html)

外部工具规范文件描述了可以从 **工具>外部** 菜单运行的工具。它指定工具的名称，要运行的可执行文件，可选参数以及如何处理工具的输出。

#### 1.2.1. 标准的外部工具

> [Using External Tools](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-3-1.html)

您可以直接从Qt Creator中使用外部工具。 Qt Linguist，QML预览工具和系统的默认文本编辑器已预先配置可用。 您可以更改其默认配置，并配置新工具。

要运行这些工具，请选择**工具>外部**，或使用定位器中的x过滤器。

+ Qt Linguist
+ QML Viewer
+ 外部文本编辑器

配置外部工具：

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826102003670-1729303717.jpg) <!-- QtCreator-功能与插件/QtCreator-源码解析-3.jpg -->

#### 1.2.2. 代码扫描和分析工具

> [Showing Task List Files in Issues Pane](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-3-2.html)

您可以使用代码扫描和分析工具来检查源代码。 这些工具报告问题供您修复。 Qt Creator使您可以将问题列表加载到问题窗格中，以便导航。

Qt Creator期望以简单的基于行的文件格式定义任务，文件格式容易使用脚本生成。 这些脚本可以转换其他工具的报告，也可以根据代码以任务列表格式创建问题列表。 一个脚本的示例，用于检查新代码行，并将它们与正则表达式进行匹配，以生成任务列表，请参阅Qt Creator存储库中的 `scripts\mytasks.pl` 。

### 1.3. 自定义向导工具

> [Creating Wizards in Code](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-5.html)

虽然Qt提供了向导组件，但如果其功能不足以满足您的情况，则可以用代码编写向导（基于 `IWizardFactory` 接口）。

### 1.4. UI文本的规范

> [User Interface Text Guidelines](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-6.html)

### 1.5. IDE自动补全

> [Completing Code](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-7.html)

代码片段指定了代码构造。您可以在代码片段编辑器中添加，修改和删除代码段。要打开编辑器，请选择 **工具>选项>文本编辑器>片段** 。

下图显示了内置的C++代码片段：

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826102004081-1312179040.jpg) <!-- QtCreator-功能与插件/QtCreator-源码解析-0.jpg -->

### 1.6. MIME类型定义

> [Editing MIME Types](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-8.html)

Qt Creator使用文件的MIME类型，来确定用于打开文件的模式和编辑器。例如，Qt Creator在C++编辑器中打开C++源代码和头文件，而在Qt Designer中打开Qt部件的基础UI文件（.ui）。对于某些MIME类型，您可以更改用于打开该类型文件的默认编辑器。

为了识别文件的MIME类型，Qt Creator使用模式匹配和内容匹配。首先，Qt Creator查看文件名，以检查其是否与某个MIME类型指定的模式匹配。如果找不到匹配项，它将检查文件的内容，查找该文件对应的魔术头（magic headers）。

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826102004316-762389922.jpg) <!-- QtCreator-功能与插件/QtCreator-源码解析-2.jpg -->

### 1.7. 语法高亮

> [Semantic Highlighting](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-9.html)

Qt Creator将C++，QML和JavaScript语言理解为代码，而不是纯文本。它读取源代码，对其进行分析，并根据对以下代码元素所做的语义检查，高亮该源代码。

要取消显示有关特定文件模式的消息，请选择工具>选项>文本编辑器>通用高亮器，并将模式添加到被忽略的文件模式字段中。

![](https://img2020.cnblogs.com/blog/2039866/202008/2039866-20200826102004521-735456258.jpg) <!-- QtCreator-功能与插件/QtCreator-源码解析-1.jpg -->

### 1.8. 编译QtCreator

> [Getting and Building Qt Creator](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-10-1.html)

## 2. IDE插件

### 2.1. 创建插件

> [Creating Your First Plugin](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-10-2.html)

您需要确保，你使用的用来创建插件的Qt Creator的版本要相同。受限于[二进制和源代码兼容性规则](https://www.cnblogs.com/brt2/p/13559729.html)，Qt Creator插件向导创建了一个插件，该插件只能在创建时使用的Qt Creator版本中运行。

### 2.2. 文件结构

插件向导会创建一组插件需要或应该具备的基础文件。我们将在以下各节中详细介绍其中的一些内容，这是一个简短的概述：

+ Example.json.in

    插件元数据模板。QMake根据此文件创建Example.json，该文件作为元数据编译到插件中。Qt Creator读取元数据以了解有关插件的信息。

+ example.pro

    项目文件，QMake使用该文件生成Makefile，然后用于插件构建。

+ example_global.h

    包含宏定义，此插件将符号导出给其他插件时，非常有用。

+ exampleconstants.h

    头文件，定义了插件代码使用的常量。

+ exampleplugin.h/.cpp

    C++头文件和源文件，定义将由Qt Creator插件管理器实例化并运行的插件类。

### 2.3. qmake编译插件

qmake项目文件`example.pro`定义了如何编译插件。除了告诉qmake需要编译哪些文件之外（或由`moc或uic`处理），Qt Creator插件还需要进行特定设置。让我们详细了解一下项目向导为您生成的内容。

      DEFINES += EXAMPLE_LIBRARY

.pro文件的第一部分允许编译器传递Example_LIBRARY定义给已编译的代码，该定义已在example_global.h头文件中使用，但目前尚无真正意义。您无需更改.pro文件的该部分。

      SOURCES += exampleplugin.cpp
      HEADERS += exampleplugin.h \
              example_global.h \
              exampleconstants.h

此部分告诉qmake需要进行编译或其他处理的项目文件。您可以使用你要添加到项目中的任何文件，来扩展该部分。

      ## set the QTC_SOURCE environment variable to override the setting here
      QTCREATOR_SOURCES = $$(QTC_SOURCE)
      isEmpty(QTCREATOR_SOURCES):QTCREATOR_SOURCES=/Users/example/qtcreator-src
      ## set the QTC_BUILD environment variable to override the setting here
      IDE_BUILD_TREE = $$(QTC_BUILD)
      isEmpty(IDE_BUILD_TREE):IDE_BUILD_TREE=/Users/example/qtcreator-build

要编译和部署您的插件，该项目需要访问Qt Creator源代码，然后进行构建。此部分包含寻找有关源代码位置信息的逻辑，并在QTC_SOURCE和QTC_BUILD环境变量中进行构建。如果它们未定义，它将使用您在项目向导中设置的默认值。

因此，如果其他人在他们的计算机上打开您的插件项目，他们不需要编辑.pro文件，而是应该为插件的构建环境设置正确的QTC_SOURCE和QTC_BUILD环境变量。

您可能不需要更改此部分，除非可以更改默认值

      ## uncomment to build plugin into user config directory
      ## <localappdata>/plugins/<ideversion>
      ##    where <localappdata> is e.g.
      ##    "%LOCALAPPDATA%\QtProject\qtcreator" on Windows Vista and later
      ##    "$XDG_DATA_HOME/data/QtProject/qtcreator" or "~/.local/share/data/QtProject/qtcreator" on Linux
      ##    "~/Library/Application Support/QtProject/Qt Creator" on Mac
      # USE_USER_DESTDIR = yes

Qt Creator插件既可以安装到Qt Creator安装路径中的插件子目录（需要写访问权限），也可以安装到用户特定的插件目录。.pro文件中的USE_USER_DESTDIR开关定义了用于构建插件的方法（该方法与后面用于将插件分发给其他用户的方法无关）。

      ###### If the plugin can be depended upon by other plugins, this code needs to be outsourced to
      ###### <dirname>_dependencies.pri, where <dirname> is the name of the directory containing the
      ###### plugin's sources.
      QTC_PLUGIN_NAME = Example
      QTC_LIB_DEPENDS += \
          # nothing here at this time
      QTC_PLUGIN_DEPENDS += \
          coreplugin
      QTC_PLUGIN_RECOMMENDS += \
          # optional plugin dependencies. nothing here at this time
      ###### End _dependencies.pri contents ######

此部分定义插件的名称和依赖项。QTC_PLUGIN_NAME变量定义了插件的名称，以及为其创建的动态库的名称。QTC_LIB_DEPENDS变量是您的插件所依赖的Qt Creator实用工具库的列表。典型的值是`aggregation，extensionsystem和utils`。QTC_PLUGIN_DEPENDS变量定义您的插件所依赖的Qt Creator插件。几乎所有Qt Creator插件都依赖coreplugin。QTC_PLUGIN_RECOMMENDS变量定义了您的插件可以选择性依赖的Qt Creator插件。有关更多信息，请参见[Optional Dependencies](plugin-meta-data.html#optional-dependencies)。

      include($$QTCREATOR_SOURCES/src/qtcreatorplugin.pri)

包含的`qtcreatorplugin.pri`文件，通过使用上面提供的信息，确保您构建适合在Qt Creator中使用的插件。

有关qmake和一般编写.pro文件的更多信息，请参见qmake手册。

### 2.4. 插件元数据模板

.json文件是一个JSON文件，包含插件管理器查找您的插件的信息，以及在加载插件库文件之前解析依赖项所需的信息。在这里，我们将仅作简短介绍。有关更多信息，请参见[Plugin Meta Data](https://doc-snapshots.qt.io/qtcreator-extending/plugin-meta-data.html)。

向导实际上并不直接创建.json文件，而是创建一个.json.in文件。qmake使用它来生成实际的插件.json元数据文件，用其实际值替换QTCREATOR_VERSION之类的变量。因此，您需要对.json.in文件中的所有反斜杠和引号进行转义（即，您需要写入\和\"，用来在生成的插件JSON元数据中得到反斜杠和引号）。

        \"Name\" : \"Example\",
        \"Version\" : \"0.0.1\",
        \"CompatVersion\" : \"0.0.1\",

元数据中的第一项由项目向导中定义的插件的名称生成，第二项是插件版本，第三项是当前版本能二进制兼容的此插件的版本。

        \"Vendor\" : \"My Company\",
        \"Copyright\" : \"(C) My Company\",
        \"License\" : \"BSD\",
        \"Category\" : \"Examples\",
        \"Description\" : \"Minimal plugin example.\",
        \"Url\" : \"http://www.mycompany.com\",

之后，您将找到在项目向导中提供的有关插件的信息。

        $$dependencyList

`$$dependencyList` 变量会被插件.pro文件中的 `QTC_PLUGIN_DEPENDS` 和 `QTC_PLUGIN_RECOMMENDS` 中的依赖项信息自动替换。

### 2.5. 插件类

文件 `exampleplugin.h` 和 `exampleplugin.cpp` 定义了您的小插件的实现。我们将在这里介绍一些重点，并为各个部分提供更详细的信息的链接。

#### 2.5.1. 头文件

头文件exampleplugin.h定义了插件类的接口。

      namespace Example {
      namespace Internal {

该插件定义在Example::Internal名称空间，该名称空间符合Qt Creator源代码中 [namespacing](https://doc-snapshots.qt.io/qtcreator-extending/coding-style.html#coding-rules-namespacing) 的编码规则。

      class ExamplePlugin : public ExtensionSystem::IPlugin
      {
          Q_OBJECT
          Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QtCreatorPlugin" FILE "Example.json")

所有Qt Creator插件都必须从ExtensionSystem::IPlugin派生，并且是QObjects派生类。`Q_PLUGIN_METADATA` 宏对于创建有效的Qt插件是必需的。宏中给定的 `IID` 必须是 `org.qt-project.Qt.QtCreatorPlugin`，用于标识插件为Qt Creator插件，并且 `FILE` 必须指向该插件的元数据文件，描述见[Plugin Meta Data](https://doc-snapshots.qt.io/qtcreator-extending/plugin-meta-data.html)。

          bool initialize(const QStringList &arguments, QString *errorString);
          void extensionsInitialized();
          ShutdownFlag aboutToShutdown();

基类定义了在插件生命周期中调用的基本函数，在此处需要新插件实现。[Plugin Life Cycle](https://doc-snapshots.qt.io/qtcreator-extending/plugin-lifecycle.html)详细描述了这些函数及其作用。

      private:
          void triggerAction();

该插件有一个附加的自定义槽，用于弹出对话框，在用户选择该插件添加的菜单项时。

#### 2.5.2. 源文件

源文件包含插件的实际实现，注册了一个新菜单和子菜单项，并在触发子菜单项时，打开一个消息框。

来自插件代码本身，Core插件和Qt的所有必需的头文件都包含在文件的开头。菜单和子菜单项在插件的initialize初始化函数中完成设置的，该函数在插件构造函数完成之后的最先被调用。在该函数中，插件可以确保其依赖的插件的基本设置已完成，例如，Core插件的ActionManager实例已被创建。

有关插件接口实现的更多信息，请参见[ExtensionSystem::IPlugin](https://doc-snapshots.qt.io/qtcreator-extending/extensionsystem.html#IPlugin-var) API文档和[Plugin Life Cycle](https://doc-snapshots.qt.io/qtcreator-extending/plugin-lifecycle.html)。

          QAction *action = new QAction(tr("Example Action"), this);
          Core::Command *cmd = Core::ActionManager::registerAction(action, Constants::ACTION_ID,
                                                  Core::Context(Core::Constants::C_GLOBAL));
          cmd->setDefaultKeySequence(QKeySequence(tr("Ctrl+Alt+Meta+A")));
          connect(action, &QAction::triggered, this, &ExamplePlugin::triggerAction);

这部分代码创建一个新的QAction，将其注册为动作管理器中的新Command，并将其连接到插件的槽。动作管理器提供了一个中心位置，用户可以在该位置分配和更改键盘快捷键，并进行管理，例如菜单项应在不同情况下指向不同的插件，以及其他一些情况。

          Core::ActionContainer *menu = Core::ActionManager::createMenu(Constants::MENU_ID);
          menu->menu()->setTitle(tr("Example"));
          menu->addAction(cmd);
          Core::ActionManager::actionContainer(Core::Constants::M_TOOLS)->addMenu(menu);

在这里，将创建一个新菜单，并添加已创建的命令，然后将菜单添加到菜单栏中的工具菜单中。

      void ExamplePlugin::triggerAction()
      {
          QMessageBox::information(Core::ICore::mainWindow(),
                                   tr("Action Triggered"),
                                   tr("This is an action from Example."));
      }

这部分定义了触发子菜单项时调用的代码。它使用Qt API打开一个消息框，该消息框显示内容丰富的文本和确定按钮。

### 2.6. 插件元数据

> [Plugin Meta Data](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-10-3.html)

插件的元数据文件是一个JSON文件，包含加载插件库所需的所有信息，决定要加载哪些插件，以及加载顺序（取决于依赖关系）。此外，它包含插件的作者，插件的用途，以及在何处可以找到有关插件的更多信息。编译插件时，该文件必须位于include搜索路径中，并且必须具有.json扩展名。JSON文件将作为元数据编译到插件中，然后在加载插件时由Qt Creator读取。

### 2.7. 插件生命周期

> [Plugin Life Cycle](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-10-4.html)

### 2.8. 插件管理器

> [The Plugin Manager, the Object Pool, and Registered Objects](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-2-10-5.html)

通常，插件不需要直接访问插件管理器。交互主要间接的通过[ExtensionSystem::IPlugin](https://doc-snapshots.qt.io/qtcreator-extending/extensionsystem.html#IPlugin-var)接口。在某些情况下，则必须使用插件管理器API。插件需要访问插件管理器的对象池，以扩展Qt Creator的某些方面，例如将页面添加到选项对话框。他们还可以利用对象池为其他插件提供扩展点。

#### 2.8.1. 插件管理器

插件管理器处理所有细节，包括查找插件，读取它们的描述文件，解决插件依赖性，以正确的顺序加载和初始化所有插件，以及传递命令行参数给插件。

另外，插件管理器管理对象池，可以根据不同的条件在其中注册和检索对象。

插件与插件管理器的大多数交互应通过[ExtensionSystem::IPlugin](https://doc-snapshots.qt.io/qtcreator-extending/extensionsystem.html#IPlugin-var)接口完成，但是下表总结了一些对插件有用的函数和信号。有关完整列表，请参见[ExtensionSystem::PluginManager](https://doc-snapshots.qt.io/qtcreator-extending/extensionsystem.html#PluginManager-var)参考文档。

+ instance()

    返回插件管理器单例，例如，用于连接信号。

+ addObject()

    在对象池中注册对象。也可以通过ExtensionSystem::IPlugin::addObject()。

+ removeObject()

    从对象池中移除对象。也可以通过ExtensionSystem::IPlugin::removeObject()。

+ allObjects()

    返回对象池中注册的所有对象的未过滤列表。

+ getObject()

    返回注册在对象池中的类型为T的对象。这在向[Aggregation](https://doc-snapshots.qt.io/qtcreator-extending/aggregation.html)致敬。

+ getObjectByName(const QString &name)

    返回在对象池中注册的具有给定对象名称的对象。

信号：

+ objectAdded(QObject *object)

    在对象被注册到对象池之后发送。

+ aboutToRemoveObject(QObject *object)

    在对象从对象池中移除之前发送。

+ initializationDone()

    在插件运行，且所有延迟的初始化完成时发送。

#### 2.8.2. 对象池和已注册对象

插件可以将对象注册到由插件管理器管理的公共池中。池中的对象必须派生自[QObject](http://doc.qt.io/qt-5/qobject.html)，无需其他先决条件。

所有指定类型的对象，可以通过getObject()函数从对象池中检索。函数感知[Aggregation::Aggregate](https://doc-snapshots.qt.io/qtcreator-extending/aggregation.html#Aggregate-var)，并使用[Aggregation::query](https://doc-snapshots.qt.io/qtcreator-extending/aggregation.html#query)()函数，而不是qobject_cast来判断匹配对象。

可以通过allObjects()函数，检索在对象池中注册的所有对象的未过滤列表。

也可以使用getObjectByName()，检索具有特定对象名称的对象(参见[QObject::objectName](http://doc.qt.io/qt-5/qobject.html#objectName-prop)())。

每当对象池的状态更改时，插件管理器都会发出相应的`objectAdded()` 或 `aboutToRemoveObject()`信号。

对象池的一个常见用例是，一个插件（或应用程序）为其他插件提供了扩展点，扩展点为类，在其他插件中实现，并添加到对象池中，然后供提供扩展点的插件检索。也可以使用对象池来提供对对象的访问，而无需实际链接到提供的插件库。

## 3. 编译工具链

### 3.1. qtcreator.pro

> [qtcreator.pro](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-3-1.html)

+ \$$运算符
+ [qbs配置](https://www.qt.io/cn/blog/2012/02/21/introducing-qbs)
+ DISTFILES
+ files(pattern[, recursive=false])
+ contains(variablename, value)
+ Scopes（作用域）
+ INSTALLS
+ QTC_PREFIX
+ TARGET
+ QMAKE_EXTRA_TARGETS
+ Adding Custom Targets
+ 指定额外构建目标

### 3.2. qtcreator.pri

> [qtcreator.pri](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-3-2.html)

+ 定义版本信息
+ CONFIG（例如，启用C++14）
+ 自定义函数
+ 设置源目录和构建目录
+ 设置IDE和INSTALLS相关路径
+ 设置字符串宏
+ INCLUDE_PATH
+ 设值库链接路径和编译选项
+ 解决插件和库依赖

### 3.3. qtcreatordata.pri

> [qtcreatordata.pri](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-3-3.html)

这个pri的功能，把这些数据/配置文件等复制到构建目录中。

### 3.4. src.pro

> [src.pro](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-3-4.html)

+ 加载qtcreator.pri
+ 指定TEMPLATE
+ 指定SUBDIRS

这里我们可以知道：子项目的编译顺序，依次为libs库，app可执行程序，plugins插件库，tools工具集，share非代码共享文件集。

### 3.5. qtcreatorlibrary.pri

> [qtcreatorlibrary.pri](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-3-5.html)

### 3.6. qtcreatorplugin.pri

> [qtcreatorplugin.pri](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-3-6.html)

### 3.7. qtcreatortool.pri

> [qtcreatortool.pri](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-3-7.html)

### 3.8. 总结：项目文件工作流程

> [项目文件工作流程](https://www.cnblogs.com/codeForFamily/p/qt-creator-ide-source-learn-3-8.html)

我们可以看到，所有的*.pro文件中，除了最底层的子项目。都采用TEMPLATE和SUBDIRS这种模式，来进行多个子项目包含和分层，以及指定编译顺序。

再总结一下输出目录的架构，这也是在qtcreator.pri中指定的：

+ 二进制文件路径IDE_BIN_PATH：构建目录/bin
+ 可执行程序路径IDE_APP_PATH：构建目录/bin
+ 库可执行目录IDE_LIBEXEC_PATH：构建目录/bin
+ 数据目录IDE_DATA_PATH：构建目录/share/qtcreator
+ 文档目录IDE_DOC_PATH：构建目录/share/doc/qtcreator。
+ 库目录IDE_LIBRARY_PATH：构建目录/lib/qtcreator
+ 插件目录IDE_PLUGIN_PATH：构建目录/lib/qtcreator/plugins

现在我们可知，程序需要的东西至少为：

+ 核心bin目录中，包含了程序启动所需要的东西，为可执行程序，库以及工具。
+ lib/qtcreator/plugins，为插件目录，程序启动后需要进行解析和加载。
+ /share/qtcreator，为数据目录，各种配置文件，模板等，为程序的附属。
