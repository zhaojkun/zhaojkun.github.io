title: WTL学习笔记
tags:
  - c++
  - GUI
  - WTL
id: 33
categories:
  - GUI
date: 2015-02-28 21:30:40
---

第二节WTL GUI 基类，讲解了几个常用的类CFrameWindowImpl用与生成普通的单视图程序框架。CUpDateUI用于更新菜单，工具条等，CMessageLoop用于消息循环处理。

<!--more-->

第三节WTL介绍了工具栏和状态栏的使用。其主要代码在CFrameWindowImpl中实现，同时还介绍了CMultiPaneStatusBarCtrl多窗格状态栏的使用。

第四节介绍WTL对话框的使用，使用的主要基类是CDialogImpl。创建一个对话框需要做三件事：（1）创建一个对话框资源；（2）从CDialogImpl类派生出一个新类；（3）添加一个公有成员变量IDD，将它设置为对话框的资源ID。

如果想在Dialog类中对控件进行操作，有如下几种方法：（1）连接一个CWindow对象，这种方法是最直接的方法，可以通过Get其句柄hwnd，然后调用attach方法将其进行绑定。（2）使用包含器窗口CContainedWindow类或者CContainedWindowT类进行控制。使用这个类可以将控件的响应消息映射到Dialog类中，这样可以避免过多的子类话控件，并响应适当的消息进行对控件的自定义设计。（3）子类化设计，通过子类化对控件进行更加详细的自定义设计。（4）对话框数据交换（DDX），可以使用很简单的方法将变量和控件关联起来。

DDX是用来进行数据交换的，WTL中可以使用以下几个宏DDX_TEXT,DDX_INT,DDX_UINT,DDX_FLOAT,DDX_CHECK,DDX_RADIO,DDX_CONTROL

控件以WM_COMMAND或WM_NOTIFY消息的方式向父窗口发送通知事件，父窗口响应并做相应处理。WTL中使用几个宏来进行相应的消息映射，同时使用REFLECT_NOTIFICATIONS可以将此类消息进行发射，将消息发射个发出消息的控件。