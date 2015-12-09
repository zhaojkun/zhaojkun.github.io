title: OpenCV中鼠标回调函数的设置
id: 10
categories:
  - opencv
date: 2014-07-07 22:26:34
tags:
---

OpenCV中设置鼠标回调函数一般使用void setMouseCallback(const string&amp; winname, MouseCallback onMouse, void* userdata=0 )这个函数来设置。而MouseCallback的类型为void (*p)( int event, int x, int y, int, void* )。<!--more-->

所以在c++中设置这个回调函数的话，要么将响应函数写成一个全局的函数，要么写在一个类里边作为static类型的成员函数，只有这样才可以放到setMouseCallback中进行设置，这个过程一般会弄的程序的结构很不清晰，各种c语言的风格混在在程序中，很是不爽。

今天发现c++11中的lambda可以设置匿名函数，于是想通过匿名函数的方式对setMouseCallback进行赋值岂不快哉。
<script type="text/javascript" src="https://gist.github.com/jkun/99e4012c2cdfacd13b4f.js"></script>
在OpenCVFrameWork的show函数中，定义了一个callback1的匿名回调函数，同时设置了内部类CallbackData用于外部类和回调函数中进行数据的传递。

这样的程序结构比较干净，有利于将来大程序的构建。