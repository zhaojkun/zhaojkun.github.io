title: CString与string的相互转换
tags:
  - c++
  - win32
id: 24
categories:
  - c++
date: 2015-02-10 16:55:50
---

在MFC编程过程中经常遇到CString这个类，在MFC的环境中使用这个类基本上没有问题。但是如果嵌入opencv时，如使用imread函数，则会出现问题，MFC使用的是多字节模式，则调用CString str;imread(str.GetBuffer(0)，就可以。但如果使用Unicode模式，则会复杂一些，这个时候CString 内部的编码方式为Unicode。经过搜索看到两个函数可以解决此问题MultiByteToWideChar和WideCharToMultiByte。<!--more-->

MultiByteToWideChar函数将多字节数组转换为宽字节数组，WideCharToMultiByte则相反。

以下代码实现的是两种字节之间的转换。
<pre class="brush:cpp">#include "stdafx.h"
#include "stdio.h"
#include "windows.h"

int _tmain(int argc, _TCHAR* argv[])
{
TCHAR strWideChar[] = _T("zerosoul"); //Unicode宽字节编码字符串strWideChar
//获得转换后的字符串长度n_len
int n_len = WideCharToMultiByte(CP_ACP,NULL,strWideChar,-1,NULL,0,NULL,NULL);
char* strMultiByte = new char[n_len]; //ANSI多字节编码字符串strMultiByte
WideCharToMultiByte(CP_ACP,NULL,strWideChar,-1,strMultiByte,n_len,NULL,NULL); //开始转换

printf("strMultiByte : %s\n",strMultiByte);
return 0;
}</pre>
<pre class="brush:cpp">#include "stdafx.h"
#include "stdio.h"
#include "windows.h"

int _tmain(int argc, _TCHAR* argv[])
{
char strMultiByte[] = "zerosoul"; //ANSI多字节编码字符串strMultiByte
//获得转换后的字符串长度n_len
int n_len = MultiByteToWideChar(CP_ACP,NULL,strMultiByte,-1,NULL,0);
TCHAR* strWideChar = new TCHAR[n_len]; //Unicode宽字节编码字符串strWideChar
MultiByteToWideChar(CP_ACP,NULL,strMultiByte,-1,strWideChar,n_len); //开始转换

_tprintf(_T("strWideChar : %s\n"),strWideChar);
return 0;
}</pre>
&nbsp;

参考链接：

http://kenazprogramming.blogspot.sg/2013/07/multibytetowidecharwidechartomultibytea.html

http://zerosoul.iteye.com/blog/900584