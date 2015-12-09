title: cocos2dx_video
id: 15
categories:
  - cocos2dx
date: 2015-02-07 13:16:30
tags:
---

这篇文章主要总结在android上使用cocos2dx进行视频播放功能的使用。
一开始没有注意到cocos2dx的新版本已经集成这个功能，所以一直打算使用FFMpeg来进行相关的开发，经过同学提醒，使用cocos2dX自带的API，使得开发难度大大降低，只需要调用相关的API即可。<!--more-->

在Cocos2dx中，进行视频播放的类为`VideoPlayer`，需要包含`ui/UIVideoPlayer.h`，然后可以再程序中使用`using namespace cocos2d::experimental::ui;`将命名空间引入进来。下边代码就是在程序启动之后即可播放相应的视频
<div>bool HelloWorld::init()</div>
<div>{</div>
<div>//////////////////////////////</div>
<div>// 1\. super init first</div>
<div>if ( !Layer::init() )</div>
<div>{</div>
<div>return false;</div>
<div>}</div>
<div></div>
<div>_visibleRect = Director::getInstance()-&gt;getOpenGLView()-&gt;getVisibleRect();</div>
<div>MenuItemFont::setFontSize(16);</div>
<div></div>
<div>auto centerPos = Vec2(_visibleRect.origin.x + _visibleRect.size.width / 2, _visibleRect.origin.y + _visibleRect.size.height / 2);</div>
<div></div>
<div>_videoPlayer = VideoPlayer::create();</div>
<div>_videoPlayer-&gt;setPosition(centerPos);</div>
<div>_videoPlayer-&gt;setAnchorPoint(Vec2::ANCHOR_MIDDLE);</div>
<div>_videoPlayer-&gt;setContentSize(Size(_visibleRect.size.width * 0.8f, _visibleRect.size.height * 0.8f));</div>
<div>this-&gt;addChild(_videoPlayer);</div>
<div></div>
<div>_videoPlayer-&gt;setFileName("cocosvideo.mp4");</div>
<div>_videoPlayer-&gt;play();</div>
<div>return true;</div>
<div>}</div>
需要说明的是：
创建`VideoPlayer`，可以直接调用`VideoPlayer::create()`即可；然后通过`setPosition,setAnchorPoint`来设置位置,`setContentSize`来设置显示的大小；`setFileName`设置文件名字，或可调用`setURL`来设置网络地址进行视频播放;`play`函数即可进行播放。
视频的控制可通过一下几个函数:`play`,`pause`,`stop`,`pause`,`resume`
通过`setFullScreenEnabled`可使得视频进行全屏播放。
最后视频的播放状态可通过一个回调函数来解决。设置回调函数是通过`_videoPlayer-&gt;addEventListener(CC_CALLBACK_2(VideoPlayerTest::videoEventCallback, this));`，通过`EventType`来判断视频的状态。
<div>void VideoPlayerTest::videoEventCallback(Ref* sender, VideoPlayer::EventType eventType)</div>
<div>{</div>
<div>switch (eventType) {</div>
<div>case VideoPlayer::EventType::PLAYING:</div>
<div>_videoStateLabel-&gt;setString("PLAYING");</div>
<div>break;</div>
<div>case VideoPlayer::EventType::PAUSED:</div>
<div>_videoStateLabel-&gt;setString("PAUSED");</div>
<div>break;</div>
<div>case VideoPlayer::EventType::STOPPED:</div>
<div>_videoStateLabel-&gt;setString("STOPPED");</div>
<div>break;</div>
<div>case VideoPlayer::EventType::COMPLETED:</div>
<div>_videoStateLabel-&gt;setString("COMPLETED");</div>
<div>break;</div>
<div>default:</div>
<div>break;</div>
<div>}</div>
<div>}</div>
所有代码可参考`Cocos2dx`的`test`程序
最后注意的是在Android上运行需要修改相应的`Android.mk`文件，不然会有一些lib编译系统找不到，需要修改的文件位置是`{project}/proj.android/jni/Android.mk`，我目前采用的策略是将所有注释的语句全部取消掉，这样就可以编译通过了。

&nbsp;