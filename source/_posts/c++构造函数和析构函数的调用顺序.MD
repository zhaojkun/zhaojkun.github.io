title: C++构造函数和析构函数的调用顺序
tags:
  - c++
  - 读书笔记
  - 面试总结
id: 53
categories:
  - c++
date: 2015-03-22 11:06:37
---

构造函数的调用顺序是从底往上的：<!--more-->

First,the constructor invokes its base class constructors,Then it invokes the member constructors and Finally ,it executes it own body.

析构函数的调用顺序刚好是相反的
A destructor "tears down" an object in the reverse order:
First,the destructor executes its own body,Then it invokes its member destructors and Finally ,it invokes its base class destructors.

特别指出：虚基类是在其他任何类之前调用构造函数的，而在其他类之后调用析构函数的。
这样的调用顺序