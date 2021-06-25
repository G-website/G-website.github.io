<!--#include file="conn.asp"-->
<!--#include file="../inc/md5.asp"-->
<%
dim action
action=request.querystring("action")
select case action
	case"exit"
		exitlogin()
	case"login"
		checklogin()
	case else
		main()
end select
set yxbbs=nothing

sub main()%>
<body>
<form method="post" action="?action=login">
<div class="ta" style="width:450px;margin-top:50px; margin-left: auto;margin-right: auto;">
<div class="th jz">≡ 后台管理登陆 ≡</div>
<div class="td" style="height:100px;width:442px;"><br />
<div style="margin-left:90px;height:34px">用户名称：<input name="adminname" type="text" size="22"></div>
<div style="margin-left:90px;height:34px">后台密码：<input name="password" type="password" size="22"></div>
<div style="margin-left:90px;height:34px">输入数字：<input name="passcode" type="text" size="6"> <img align="absmiddle" src="../inc/code.asp" ></div>
</div>
<div style="clear: both;"></div> <div class="tf jz"><input type="submit" class="button" value="登 陆"></div>
</div>
</form>
</body>
</html>
<%end sub
sub checklogin()
	dim adminname,adminpassword,passcode
	if yxbbs.getcookiesinfo("adminlogin",0)=>3 then
	Call showtable("登陆失败","<li>您已经连续三次输入错误,所以暂时不能在登陆后台管理了!</li><li><a href=../>返回首页</a></li>")
	response.end
	end if

	adminname=yxbbs.fun.getstr("adminname")
	adminpassword=yxbbs.fun.getstr("password")
	passcode=yxbbs.fun.getstr("passcode")
	if not yxbbs.fun.checkname(adminname) or passcode="" then
		call showtable("登陆失败","<li>您输入的用户名或随机验证码错误!</li><li>错误操作 "&yxbbs.updatecookiesinfo("adminlogin",1)&" 次</li><li><a href=login.asp>返回首页</a></li>")
		response.end
	end if
	if yxbbs.execute("select name from [yx_admin] where name='"&adminname&"' and password='"&md5(adminpassword)&"'").eof or session("checkcode")<>passcode then
		session(yxbbs.cachename&"adminname")=""
		session(yxbbs.cachename&"adminpassword")=""
		session("checkcode")=""
		call showtable("登陆失败","<li>您输入的用户名不存在或密码错误!</li><li>错误操作 "&yxbbs.updatecookiesinfo("adminlogin",1)&" 次!</li><li><a href=login.asp>返回首页</a></li>")
		response.end
	else
		session(yxbbs.cachename&"adminname")=adminname
		session(yxbbs.cachename&"adminpassword")=adminpassword
		session("checkcode")=""
		response.write "<script language=javascript>top.window.location.href='index.asp';</script>"
		response.end
	end if
end sub

sub exitlogin()
	session(yxbbs.cachename&"adminname")=""
	session(yxbbs.cachename&"adminpassword")=""
	session("checkcode")=""
	response.redirect"../default.asp"
end sub
%>