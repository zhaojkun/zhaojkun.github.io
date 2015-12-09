title: CCEventDispatcher源码阅读
id: 19
categories:
  - cocos2dx
date: 2015-02-07 13:17:52
tags:
---

`EventListenerVector`类中有三个参数，`vector&lt;EventListener*&gt; * _fixedListeners`,`vector&lt;EventListener*&gt; *_sceneGraphListeners`,`ssize_t _gt0Index`
`EventDispatcher`中保存有一下几个map
`unordered_map&lt;EventListener::ListenerID,EventListenerVector *&gt; _listenerMap` 用来将`ListenerID`和`EventListenerVector`进行绑定<!--more-->
`unordered_map&lt;EventListener::ListenerID,DirtyFlag&gt; _priorityDirtyFlagMap`用来保存`ListenerID`和`DirtyFlag`的对应关系

`unordered_map&lt;Node *,vector&lt;EventListener*&gt;*&gt; _nodeListenersMap` 用来存储`Node*`和`vector&lt;EventListener&gt; *`的对应关系

`unordered_map&lt;Node *,int&gt; _nodePriorityMap`用来存储`Node *`的优先级

`unordered_map&lt;float,vector&lt;Node*&gt; &gt; _globalZOrderNodeMap`用来保存`Node *`的`zorder`

`vector&lt;EventListener *&gt; _toAddedListeners`用来保存即将保存的`EventListener*`
`set&lt;Node*&gt; _dirtyNodes`用来保存`Node`的`dirty flag`

`addEventListener(EventListener* listener)` 函数的使用

添加事件，如果当前正处在派发状态，则将listener添加到_toAddedListeners中，否则调用forceAddEventListener添加事件。在`forceAddEventListener`中，首先获取`listener`的`LisenerId`，然后遍历_listenerMap查看时候有这个ID的EventListenerVector,如果有则将其pushback到vector中，如果没有，则新建一个vector然后将其进行添加。而在调用`EventListenerVector`的`push_back`的时候，是需要判断这个listener的Priority是否为0，如果为0，则说明这个listener是按照对应node的scenepriority来进行排序的，因此需要添加到_sceneGraphListeners中，否则添加到_fixedListener中
添加之后，需要设置其dirtyflag。调用setDirty,并在_priorityDirtyFlagMap中将这个listenerId添加到相应的Map中，如果已经存在则进行一个或操作。因此我认为dirtyflag说明的是对应listenerId的listener中是fixed或者sensebased的优先级的情况。

然后嗲用`associateNodeAndEventListener`将对应的Node和listener添加到_nodeListenersMap中

`vector&lt;EventListener*&gt; *_fixedListeners`
`vector&lt;EventListener* * _sceneGraphListeners`
`ssize_t _gt0Index`

`unordered_map&lt;EventListener::ListenerID,EventListenerVector*&gt; _listenerMap`
写：在`forceAddEventListener`中调用`insert`进行数据的添加。将`listenerId`和`EventListenerVector`进行绑定

`unordered_map&lt;EventLIstener::ListenerID,DirtyFlag&gt; _priorityDirtyFlagMap`
写：在`setDirty`函数中调用`insert`将数据写入，这个数据结构将`ListenerID`和`DirtyFlag`进行绑定

`unordered_map&lt;Node *,vector&lt;EventLisener*&gt; *&gt; _nodelistersMap`
写：调用`associateNodeAndEventListener`将`node`和一些列的`EventListener`进行绑定

`unordered_map&lt;NOde *,int&gt; _nodePriorityMap`

`unordered_map&lt;float,vector&lt;Node*&gt; &gt; _globalZOrderNodeMap`

`vector&lt;EventListener*&gt; _toAddedListeners`
写：在`addEventListener`函数中进行`push_back`，如果处于派发状态，则`listener`添加到`_toAddedListeners`中

`dispatchEvent`中进行实际的派发，而具体的实现，是在此函数的一个`lambda`函数`onEvent`进行调用的。
> 总的来说，用户调用`addEventListenerWithSceneGraphPriority`等相关函数将`Listener`添加到相应的Map中，而系统根据事件监听，当监听到相应事件之后嗲用相应的`dispatchEvent`将消息发送出去，并使得相应的回调函数进行执行