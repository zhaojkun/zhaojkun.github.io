title: Android 绘制2D图形
tags:
  - Android
id: 105
categories:
  - Android
date: 2015-05-21 23:46:49
---

Android中自定义控件可以通过从继承View来实现，通过覆盖View.onDraw方法，可以利用onDraw方法中的canvas参数获得Canvas对象，然后通过该对象的方法绘制各种基本的方法。通过View.invalidate方法刷新View，并调用onDraw方法重绘画布。

实现动画效果的步骤如下：<!--more-->

1.  <div>编写一个类，该类继承自View</div>
2.  <div>覆盖View.onDraw方法，并在该方法中根据当前的圆心绘制白色实心圆</div>
3.  <div>为了截获触摸事件，GameView类需要实现OnTouchListener接口</div>
4.  <div>通常动画效果要用多线程来处理，因此需要编写一个处理动画效果的线程类</div>
5.  <div>在AnimThread.run方法中实现动画效果，最常用的方法是在循环中不断改变圆心坐标，然后通过调用View.invalidate方法重绘画布，并且在改变圆心坐标后进行一定时间的延迟。</div>
在线程中不能直接访问UI控件，也不能调用任何影响UI控件变化的方法，所以View.invalidate必须在handler.handleMessage方法中完成。

相对View，Android还有一个SurfaceView，使用SurfaceView开发时，可以直接获得Canvas对象，而不像View，必须要在onDraw方法中才能获得Canvas;SurfaceView支持双缓冲技术，绘制图形的效率更好;SurfaceView可以在非UI线程中直接绘制图像，而View必须要使用handler对象发送消息，通知UI线程绘制图形。

在SurfaceView上绘制图形的步骤如下：

1.  <div>使用SurfaceHolder.lockCanvas方法获得Canvas对象</div>
2.  <div>如果需要清空屏幕，调用Canvas.drawColor方法</div>
3.  <div>调用Canvas对象的方法绘制相应的图形</div>
4.  <div>使用SurfaceHolder.unlockCanvasAndPost方法释放Canvas对象，并将缓冲区绘制的图形一次性绘制到画布上。</div>
Surface,SurfaceView和SurfaceHolder之间的关系：从设计模式的高度来看，Surface、SurfaceView和SurfaceHolder实质上就是广为人知的MVC，即Model-View-Controller。Model就是模型的意思，或者说是数据模型，或者更简单地说就是数据，也就是这里的Surface；View即视图，代表用户交互界面，也就是这里的SurfaceView；SurfaceHolder很明显可以理解为MVC中的Controller（控制器）。这样看起来三者之间的关系就清楚了很多。

SurfaceView可以在其他线程中进行图形绘制，实例代码可参考[http://blog.csdn.net/pathuang68/article/details/7351317](http://blog.csdn.net/pathuang68/article/details/7351317 "http://blog.csdn.net/pathuang68/article/details/7351317")

如果想在View中绘制其他View，可以在在XML文件中创建一个对应的View，并设置此View的Visible为False，然后通过一下代码可以获取此View的bitmap缓存数据，然后通过绘制bitmap的函数绘制其中的图像
<div>
<pre class="brush:java">View view = activity.getWindow().getDecorView(); 
view.setDrawingCacheEnabled(true);   
view.buildDrawingCache(); 
Bitmap bitmap= view.getDrawingCache();</pre>
&nbsp;

</div>