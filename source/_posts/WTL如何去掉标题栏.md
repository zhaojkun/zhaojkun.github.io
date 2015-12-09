title: WTL如何去掉标题栏
tags:
  - GUI
  - win32
  - WTL
id: 37
categories:
  - GUI
date: 2015-03-01 20:59:28
---

将windows的标题栏去掉，然后客户区进行自绘方式

<!--more-->
<pre class="brush:cpp">dlgMain.SetWindowLongW(GWL_STYLE,0);</pre>
<pre class="brush:cpp">BEGIN_MSG_MAP(CMainDlg)
		MESSAGE_HANDLER(WM_INITDIALOG, OnInitDialog)
		MESSAGE_HANDLER(WM_DESTROY, OnDestroy)
		MESSAGE_HANDLER(WM_NCHITTEST,OnHistTest)
		COMMAND_ID_HANDLER(ID_APP_ABOUT, OnAppAbout)
		COMMAND_ID_HANDLER(IDOK, OnOK)
		COMMAND_ID_HANDLER(IDCANCEL, OnCancel)
	END_MSG_MAP()</pre>
&nbsp;
<pre class="brush:cpp">LRESULT CMainDlg::OnHistTest(UINT /*uMsg*/, WPARAM /*wParam*/, LPARAM lParam, BOOL&amp; /*bHandled*/)
{
	//CloseDialog(wID);
	int border=5;
	POINT pt; 
	pt.x=GET_X_LPARAM(lParam);
	pt.y=GET_Y_LPARAM(lParam); ;
	ScreenToClient(&amp;pt);
	RECT rcClient; 
	GetClientRect(&amp;rcClient);
	if (pt.x&lt;rcClient.left+border&amp;&amp;pt.y&lt;rcClient.top+border){
			return HTTOPLEFT;
	 }
	 else if (pt.x&gt;rcClient.right-border &amp;&amp; pt.y&lt;rcClient.top+border){
			return HTTOPRIGHT;
	 }
	 else if (pt.x&lt;rcClient.left+border &amp;&amp; pt.y&gt;rcClient.bottom-border){
			return HTBOTTOMLEFT;
	 }
	 else if (pt.x&gt;rcClient.right-border &amp;&amp; pt.y&gt;rcClient.bottom-border){
			return HTBOTTOMRIGHT;
	 }
	 else if (pt.x&lt;rcClient.left+border){
			return HTLEFT;
	 }
	 else if (pt.x&gt;rcClient.right-border){
			return HTRIGHT;
	 }
	 else if (pt.y&lt;rcClient.top+border)
	 {
			return HTTOP;
	 }
	 if (pt.y&gt;rcClient.bottom-border){
			return HTBOTTOM;
	 }
	 else if(pt.y&lt;rcClient.top+3*border){
		 return HTCAPTION;
	 }
	 else
		 return HTCLIENT;
}</pre>
&nbsp;