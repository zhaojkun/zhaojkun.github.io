title: 深入浅出MFC(李久进)学习笔记1
tags:
  - c++
  - GUI
  - MFC
id: 47
categories:
  - GUI
date: 2015-03-12 15:48:42
---

MFC框架定义了应用程序的轮廓，并提供了用户接口的标准实现方法，程序员所要做的就是通过预定义的接口把具体应用程序所特有的东西填入这个轮廓。
MFC提出了以文档视图为中心的编程模式，MFC类库封装了对它的支持。文档是用户操作的数据对象，视图是数据操作的窗口，用户通过它处理，查看数据。<!--more-->
CObject是MFC的根类，绝大多数MFC类是其派生的，包括CCmdTarget。CObject实现了一些重要的特性，包括动态类信息、动态创建、对象序列化、对程序调试的支持等等。CCmdTarget通过封装一些属性和方法，提供了消息处理的架构.MFC中任何可以处理消息的类都是从CCmdTarget派生的。
MFC建立了消息映射机制，以一种富有效率、便于使用的手段解决消息处理函数的动态约束问题。这样通过虚拟函数和消息映射，MFC类提供了丰富的编程接口。程序员继承基类的同事，把自己实现的虚拟函数和消息处理函数嵌入MFC的编程框架，MFC将在适当的时候，适当的地方来调用程序的代码
MFC封装了Win32 API，OLE API，ODBC API等底层函数的功能，并提供更好一层的接口，简化了Windows编程，同时MFC支持对底层API的直接调用。

所谓的windows Object(Windows对象)是Win32下用句柄表示的Windows操作系统对象；所谓的MFCOBject(MFC对象)是c++对象，是一个c++类的实例。MFC Object是有特定含义的，指封装Windows Object的c++ Object,并非指任意的c++ object

MFC下创建一个窗口对象分两步：首先创建MFC窗口对象，然后创建对应的windows窗口，在内存使用上，MFC窗口对象可以在栈或者堆上（使用new创建）中创建。
在Windows窗口的创建过程中，将发送一些消息，如：在创建了窗口的非客户区(Nonclient area)之后，发送消息WM_NCCREATE;在创建了窗口的客户区(client area)之后，发送消息WM_CREATE;窗口的窗口过程在窗口显示之前收到这两个消息。如果是子窗口，在发送了上述两个消息之后，还给父窗口发送WM_PARENATNOTIFY消息，其他类或风格的窗口可能发送更多的消息。

从CDC派生出四个功能更具体的设备描述表类。CClientDC代表窗口客户区的设备描述表，CPaintDC仅仅用于相应WMM_PAINT消息时绘制窗口，CMetaFileDC用于生成元文件，CWindowDC代表整个窗口区（包括非客户区）的设备描述表，其构造函数通过::GetWindowDC获取指定窗口的客户区的设备表HDC
GDI对象要选入Windows设备描述表之后才能使用；用毕，要恢复设备描述表的原GDI对象，并删除该GDI对象