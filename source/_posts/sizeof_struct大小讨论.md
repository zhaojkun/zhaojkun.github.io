title: 'sizeof(struct )大小讨论  '
tags:
  - c++
  - 面试总结
id: 64
categories:
  - c++
date: 2015-03-23 19:42:30
---

struct 结构大小和顺序、<span style="font-family: 'Times New Roman';">#progma pack参数有关系</span>

针对字节对齐，环境使用的<span style="font-family: 'Times New Roman';">gcc version 3.2.2</span>编译器（<span style="font-family: 'Times New Roman';">32</span>位<span style="font-family: 'Times New Roman';">x86</span>平台）为例。

char 长度为1个字节，short 长度为2个字节，int 长度为4个字节。

<span style="font-family: 'Times New Roman';">struct 子项在内存中的按顺序排列，在没有</span><span style="font-family: 'Times New Roman';">#progma pack(n)参数的情况，</span><span style="font-family: 'Times New Roman';">各个子项的对齐系数为自己长度。</span>

<span style="font-family: 'Times New Roman';">在有<span style="font-family: 'Times New Roman';">#progma pack(n)参数的情况，各子项的对齐系数为min（自己长度，n）；<!--more--></span></span>

<span style="font-family: 'Times New Roman';">struct 整体的对其系数为子项对齐系数最大值</span>

<span style="font-family: 'Times New Roman';">看下面的例题：</span>

<span style="font-family: 'Times New Roman';">struct A{</span>

<span style="font-family: 'Times New Roman';">char a;  //字长1对其系数1</span>

<span style="font-family: 'Times New Roman';">char b;  //字长1对其系数1</span>

<span style="font-family: 'Times New Roman';">char c;  //字长1对其系数1</span>

<span style="font-family: 'Times New Roman';">}</span>；//整体对其系数为1

<span style="font-family: 'Times New Roman';"> sizeof(struct A)值是<span style="text-decoration: underline;">       </span></span>

<span style="font-family: 'Times New Roman';">看下图</span>

<span style="font-family: 'Times New Roman';">[![sizeof(struct )大小讨论 - feyeye - 学习记录](http://ww3.sinaimg.cn/large/4a3f01ffjw1eqfwg6wz0pj20a305uq39.jpg)](http://ww3.sinaimg.cn/large/4a3f01ffjw1eqfwg6wz0pj20a305uq39.jpg)</span>

&nbsp;

<span style="font-family: 'Times New Roman';">绿色为被填充的内存，黄色为空</span>

<span style="font-family: 'Times New Roman';">因此sizeof(struct A)=3;</span>

struct B {

int a;           //对其系数4

char b;       //对其系数1

short c;     //对其系数2

};//整体对其系数4

sizeof(strcut B)值是<span style="text-decoration: underline;">      </span>

&nbsp;

<span style="font-family: 'Times New Roman';">如图</span>

<span style="font-family: 'Times New Roman';">[![sizeof(struct )大小讨论 - feyeye - 学习记录](http://ww4.sinaimg.cn/mw1024/4a3f01ffjw1eqfwg7midvj20a405u0t1.jpg)](http://ww4.sinaimg.cn/mw1024/4a3f01ffjw1eqfwg7midvj20a405u0t1.jpg)</span>

<span style="font-family: 'Times New Roman';">short c对其系数2必须和偶地址对其，int a同理也与能4的倍数地址对其。</span>

<span style="font-family: 'Times New Roman';">粉色内存被结构占用</span>

<span style="font-family: 'Times New Roman';">因此</span>

<span style="font-family: 'Times New Roman';">sizeof(strcut B)=8</span>

struct C {

char b;   //对其系数1

int a;      //对其系数4

short c;  //对其系数2

};//整体对其系数4

&nbsp;

sizeof(struct C)的值是<span style="text-decoration: underline;">     </span>

如图

[![sizeof(struct )大小讨论 - feyeye - 学习记录](http://ww4.sinaimg.cn/mw1024/4a3f01ffjw1eqfwg89a8jj20a405uaae.jpg)](http://ww4.sinaimg.cn/mw1024/4a3f01ffjw1eqfwg89a8jj20a405uaae.jpg)

int a 从4的倍数地址开始，所以开始地址是4，因为结构整体对其系数为4，因此short c后的两个内存被占用，使大小为4的倍数。

sizeof(struct C)=12

&nbsp;

#progma pack (2)

struct D {

char b;    //对其系数min（长度=1，n=2）=1

int a;       //对其系数min（长度=4，n=2）=2

short c;   //对其系数min（长度=2，n=2）=2

};//整体对其系数2

sizeof(struct D)值是<span style="text-decoration: underline;">     </span>

如图

[![sizeof(struct )大小讨论 - feyeye - 学习记录](http://ww3.sinaimg.cn/mw1024/4a3f01ffjw1eqfwg8vse3j20a405r74l.jpg)](http://ww3.sinaimg.cn/mw1024/4a3f01ffjw1eqfwg8vse3j20a405r74l.jpg)

&nbsp;

#progma pack (2)  对int a的放置产生影响，

#progma pack (n)  只能取1、2、4

因此 sizeof(struct D)=8

&nbsp;

**<span style="font-size: 1.17em;">struct位域 大小 不考虑边界对齐</span>**

struct A
{
char t:4;
char k:4;
unsigned short i:8;
unsigned long m;
};

VC编译器下，不考虑边界对齐，大小为7，tk他俩占第一个字节，i占第二个字节，m从四字节开始占四个字节，问题是m为什么不从第三字节开始：是因为第二三字节的short被划分为2个字节类型的位模式了，m改为unsigned short m:8;就可以从第三字节开始了。

**可以把位模式看做有类型的位模式：8位的、16位的，32位的，按位数分类型，相同类型的可以连续存放，不同类型的另开辟空间。**

看几个例子

struct ABC
{
char t:4;//8为类型的位模式
int    k:4;//32为类型的位模式，t和k不能连续存放，
unsigned short i:8;
unsigned short m:8;
};

&nbsp;

sizeof(union)为一结构里边size最大的为union的size