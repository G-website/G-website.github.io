<!--#include file="conn.asp"-->
<!--#include file="../inc/md5.asp"-->
<%
dim adminname,adminpassword,checkname,rs
adminname=session(yxbbs.cachename&"adminname")
adminpassword=session(yxbbs.cachename&"adminpassword")
checkname=session(yxbbs.cachename&"checkname")
if adminname="" or adminpassword="" then
	if  instr(lcase(request("url")),"index.asp")>0 then
		response.redirect"login.asp"
	else
	call showtable("论坛安全时间","系统安全管理超时，请重新 【<a href=login.asp target='_parent'>登陆</a>】")
	response.end
	end if
end if

if not yxbbs.fun.checkname(adminname) or checkname<>yxbbs.myname then response.redirect"login.asp"

if yxbbs.execute("select name from [yx_admin] where name='"&adminname&"' and password='"&md5(adminpassword)&"'").eof  then
	response.redirect"login.asp"
	response.end
end if

%>
<script language="JavaScript">
function checkclick(msg){if(confirm(msg)){event.returnValue=true;}else{event.returnValue=false;}}
</SCRIPT>
