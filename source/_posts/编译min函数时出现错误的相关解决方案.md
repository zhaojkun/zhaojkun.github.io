title: 编译min函数是出现错误的相关解决方案
id: 21
categories:
  - c++
date: 2015-02-07 13:21:31
tags:
---

在vs下编程有时会遇到如下错误
error C2589: ‘(‘ : illegal token on right side of ‘::’
error C2059: syntax error : ‘::’
定位到出错行，是std::min函数的使用错误。
<!--more-->
如下是一个典型代码示例
<pre class="brush:cpp">#include&lt;algorithm&gt;
#include&lt;iostream&gt;
#include&lt;Windows.h&gt;
using namespace std;
int main(){
int k=std::min(3,2);
cout&lt;&lt;k&lt;&lt;endl;
return 0;
}</pre>
&nbsp;
<div>这里出错的主要原因是在`windows.h`中有一个宏为：`#define min(a,b) (((a) &lt; (b)) ? (a) : (b))` 所以在宏展开过程中就会将上述函数进行展开而此时已经不是`std`中具体的那个`min`函数了。</div>
<div>如下是几种解决方案：
使用`#undef min`</div>
<div>
<pre class="brush:cpp">#include&lt;algorithm&gt;
#include&lt;iostream&gt;
#include&lt;Windows.h&gt;
using namespace std;
int main(){
#undef min
int k=std::min(3,2);
cout&lt;&lt;k&lt;&lt;endl;
return 0;
}</pre>
&nbsp;

</div>
<div>
<div>使用括号</div>
<div>
<pre class="brush:cpp">#include&lt;algorithm&gt;
#include&lt;iostream&gt;
#include&lt;Windows.h&gt;
using namespace std;
int main(){
int k=(std::min)(3,2);
cout&lt;&lt;k&lt;&lt;endl;
return 0;
}</pre>
&nbsp;

</div>
<div>
<div>使用`#define NOMINMAX`</div>
<div>
<pre class="brush:cpp">#include&lt;algorithm&gt;
#include&lt;iostream&gt;
#define NOMINMAX
#include&lt;Windows.h&gt;
using namespace std;
int main(){
int k=std::min(3,2);
cout&lt;&lt;k&lt;&lt;endl;
return 0;
}</pre>
&nbsp;

</div>
<div>
<div>自我感觉是用第二种方法最好，因为这样既不影响原有min宏的使用，也能很好的解决问题。第一种方法简单粗暴，可能会对min原有宏的使用产生不良的影响，而第三种方法也比较简单，但如果是使用第三方库，需要在每一个的`windows.h`包含之前都要加上`#define NOMINMAX`具体实现起来有点儿困难。</div>
</div>
</div>
</div>