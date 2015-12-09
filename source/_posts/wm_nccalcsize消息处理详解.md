title: WM_NCCALCSIZE消息处理详解
tags:
  - GUI
  - MFC
id: 74
categories:
  - GUI
date: 2015-04-05 11:06:51
---

【前言】
指定应用程序的标题高度和边框的宽度的方法有很多种。其中最普遍的方法有下面的两种：
第一种：创建没有标题栏应用程序，在客户区让出一部分空间用一幅图片画一个标题栏，让人“误认为”是标题栏。
第二种：处理应用程序接收到的WM_NCCALCSIZE消息，改变客户区在窗口中的位置，从而得到合适标题栏高度。
不能说哪一种方法好，哪一种方法不好，其实第一种做法简单易行，而且也能做得很漂亮，但不爽的一点是就是每一次画客户区的时候总是计算坐标的起始位置；第二种方法有点麻烦（其实也不麻烦），但有一点很好，客户区不用负责标题栏重绘工作，响应WM_PAINT消息时候不用计算位置。<!--more-->
【第二种】
要想得到最准确最全面的信息得去MS的老巢去找EN文版的（GOOGLE什么的最讨厌了），别怕一句一句看（俺的英语水平(360) &lt;&lt; CET-4(425)，我都能看懂，肯定没有人看不懂的了）。
wParam：
If wParam is TRUE, it specifies that the application should indicate which part of the client area contains valid information. The system copies the valid information to the specified area within the new client area.
If wParam is FALSE, the application does not need to indicate the valid part of the client area.
lParam：
If wParam is TRUE, lParam points to an NCCALCSIZE_PARAMS structure that contains information an application can use to calculate the new size and position of the client rectangle.
If wParam is FALSE, lParam points to a RECT structure. On entry, the structure contains the proposed window rectangle for the window. On exit, the structure should contain the screen coordinates of the corresponding window client area.
这是MSND上一段话：意思是如wParam为TRUE，需要在新矩形中指定可用的客户区；如果wParam为FALSE应用程序不用在新矩形中指定客户区。
我这样的理解的：当窗口创建时候的wParam为FALSE，其它情况为TRUE。
【TRUE情况】
假想：窗口一开始在A位置，突然移动到B位置。如图：

![](http://ww3.sinaimg.cn/large/4a3f01ffjw1equirax4apj20an070jrg.jpg "img")

这时候Windows将会给窗口发送一个WM_NCCALCSIZE消息，通知应用程序窗口的位置或者大小变了，应用程序应当指定新的非客户区和客户区的位置。消息具体内容的是：
message:WM_NCCALCSIZE
wParam: TRUE
lParam: 一个指向三个矩形的指针（NCCALCSIZE_PARAMS *）。下面是NCCALCSIZE_PARAMS结构：
<pre class="brush:cpp">typedef struct tagNCCALCSIZE_PARAMS {
  RECT       rgrc[3];
  PWINDOWPOS lppos;
} NCCALCSIZE_PARAMS, *LPNCCALCSIZE_PARAMS;</pre>
下面是MSDN的一段说明：
rgrc
RECT
An array of rectangles. The meaning of the array of rectangles changes during the processing of the WM_NCCALCSIZE message.
When the window procedure receives the WM_NCCALCSIZE message, the first rectangle contains the new coordinates of a window that has been moved or resized, that is, it is the proposed new window coordinates. The second contains the coordinates of the window before it was moved or resized. The third contains the coordinates of the window's client area before the window was moved or resized. If the window is a child window, the coordinates are relative to the client area of the parent window. If the window is a top-level window, the coordinates are relative to the screen origin.
When the window procedure returns, the first rectangle contains the coordinates of the new client rectangle resulting from the move or resize. The second rectangle contains the valid destination rectangle, and the third rectangle contains the valid source rectangle. The last two rectangles are used
简易翻译一下（凑合看）：
当窗口处理收到的WM_NCCALCSIZE消息是，第一个矩形包含了移动后或者改变大小后的新坐标（也就是B的坐标），它是建议的坐标。第二个矩形包含了移动或改变大小前的坐标（也就是A坐标），第三个矩形包含了客户区的移动前的坐标（也就是A坐标中的客户区坐标）。
处理这个消息返回之前（也就是WM_NCCALCSIZE处理完成后），第一个矩形应当包含新客户区的坐标（也就是B坐标中的客户区坐标），第二个矩形包含了可用的目标矩形（B坐标），第三个坐标包含了源矩形（A坐标）。后面的两个矩形也会被用到。简而言之：
我们在处理前的是：第一个矩形是B，第二个矩形是A，第三个矩形是AC，
我们在处理后的是：第一个矩形是BC，第二个矩形是B,第三个是矩形A。
于是我写下了下写的C处理代码：
<pre class="brush:cpp">int xFrame = 2; /*左右边框的厚度*/
int yFrame = 2; /*下边框的厚度*/
int nTHight = 40;           /*标题栏的高度*/
NCCALCSIZE_PARAMS  * p; /*TRUE是的指针*/
RECT         * rc; /*FALSE是的指针*/
RECT aRect;
RECT bRect;
RECT bcRect;

if(wParam == TRUE)
{
p = (NCCALCSIZE_PARAMS *)lParam; 

/*复制A B矩形位置*/
CopyRect(&amp;aRect,&amp;p-&gt;rgrc[1]); 
CopyRect(&amp;bRect,&amp;p-&gt;rgrc[0]);

/*指定BC的矩形的位置*/
bcRect.left   = bRect.left + xFrame;
bcRect.top    = bRect.top + nTHight;
bcRect.right  = bRect.right - xFrame;
bcRect.bottom = bRect.bottom - yFrame;

/*各个矩形归位成BC B A*/
CopyRect(&amp;p-&gt;rgrc[0],&amp;bcRect);
CopyRect(&amp;p-&gt;rgrc[1],&amp;bRect);
CopyRect(&amp;p-&gt;rgrc[2],&amp;aRect);
}</pre>
上面是处理了wParam为TRUE的情况，再回头来看FALSE的情况，就是初始化的时候，我们知道刚刚初始化的时候不是A-&gt;B而是从没有矩形到有矩形。
【FALSE情况】
这时候，lParam是指向一个矩形，这个矩形是窗口的现在位置X，我们要返回的是XC，也是就是返回X变成XC，下面给成C代码：
<pre class="brush:cpp">else
{
rc = (RECT *)lParam;

rc-&gt;left   = rc-&gt;left + xFrame;
rc-&gt;top    = rc-&gt;top + nTHight;
rc-&gt;right  = rc-&gt;right - xFrame;
rc-&gt;bottom = rc-&gt;bottom - yFrame;
}</pre>
&nbsp;

至此, WM_NCCALCSIZE讲解完毕。自定义高度的窗口式样（照着QQ风格画的）：

[nie@song.ah.cn](mailto:nie@song.ah.cn)
niesongsong
沈阳
敬上
<pre class="brush:cpp">整个函数写法：

case WM_NCCALCSIZE:
ProcNCCalcSize(hWnd,message,wParam,lParam);

int ProcNCCalcSize(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
int xFrame = 2; /*左右边框的厚度*/
int yFrame = 2; /*下边框的厚度*/
int nTHight = 40; /*标题栏的高度*/
NCCALCSIZE_PARAMS  * p;
RECT    * rc; 

RECT aRect;
RECT bRect;
RECT bcRect;

if(wParam == TRUE)
{
p = (NCCALCSIZE_PARAMS *)lParam; /*矩形是B A AC，目标是改成BC B A*/

CopyRect(&amp;aRect,&amp;p-&gt;rgrc[1]); 
CopyRect(&amp;bRect,&amp;p-&gt;rgrc[0]);

/*指定BC的矩形的位置*/
bcRect.left   = bRect.left + xFrame;
bcRect.top    = bRect.top + nTHight;
bcRect.right  = bRect.right - xFrame;
bcRect.bottom = bRect.bottom - yFrame;

/*各个矩形归位*/
CopyRect(&amp;p-&gt;rgrc[0],&amp;bcRect);
CopyRect(&amp;p-&gt;rgrc[1],&amp;bRect);
CopyRect(&amp;p-&gt;rgrc[2],&amp;aRect);
}
else
{
rc = (RECT *)lParam;

rc-&gt;left   = rc-&gt;left + xFrame;
rc-&gt;top    = rc-&gt;top + nTHight;
rc-&gt;right  = rc-&gt;right - xFrame;
rc-&gt;bottom = rc-&gt;bottom - yFrame;
}
return GetLastError();
}</pre>
&nbsp;

http://dqzx.neuq.edu.cn/bbs/forum.php?mod=viewthread&amp;tid=17

&nbsp;