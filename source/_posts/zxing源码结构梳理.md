title: Zxing的源码结构梳理
tags:
  - Android
  - 摄像头
id: 103
categories:
  - Android
date: 2015-05-21 23:45:26
---

本文主要对Zxing的源码结构进行梳理

Zxing的主Activity是CaptureActivity,在其onResume函数中从界面获取SurfaceView，并使用此Surfaceview来对摄像头进行初始化（InitCamera函数）<!--more-->

InitCamera函数首先是调用CameraManager类中的openDriver启动摄像头，并创建CaptureActivityHandler对系统中的相关消息进行处理，并且此handler为CaptureActivity中getHandler的函数值。

在CaptureActivityHandler的构造函数中主要做了一下几件事：

1.  <div>创建了一个DecodeThread线程，用于对图像信息的解码,调用底层的JNI程序，将图像中的二维码进行解码，并解码成功或者失败都将消息传递给CaptureActivityHandler.</div>
2.  <div>启动摄像头</div>
3.  <div>调用restartPreviewAndDecode，在此函数中设置摄像头的AutoFocus和Preview两个回调，</div>
4.  <div>绘制viewfinder,这是一个自定义的View，叠加在摄像头的SurfaceView上边，用于绘制直线或者点等。</div>
AutoFocusCallBack 摄像头调用此回调，在回调函数中将消息传递给CaptureActivityHandler,并重新启动AutoFocus

PreViewCallback 获取图像数据后，将消息传递给decodeThreadHandler（另一个线程中）

decodeThread(解码线程)，其中有一个handler来处理具体的消息和数据，如果消息是R,id,decode，则调用decode对图像进行解码；如果是R.id.quit则线程退出

decode函数调用JNI里边的函数来进行具体的数据处理，并通过主activity的handler传回结果，如果成功，则返回识别结果；如果不成功，则重新设置预览，对下一张图片进行解析和处理。