<!--#include file="check.asp"-->
<!--#include file="../inc/page_cls.asp"-->
<%
response.write("<body>")
select case request("action")
case "update"
	updateuserdata
case "useredit"
	useredit
case "edituser"
	edituser
case "addadmin"
	addadmin
case "saveadmin"
	saveadmin
case "admin"
	admin
case "editadmin"
	editadmin
case "saveeditadmin"
	saveeditadmin
case "deladmin"
	deladmin
case "classadd"
	userclassadd
case "saveaddclass"
	saveaddclass
case "userclass"
	userclass
case "classedit"
	userclassedit
case "saveeditclass"
	saveeditclass
case "deluserclass"
        deluserclass
case "addgrade"
	usergradeadd
case "saveaddgrade"
	saveaddgrade
case "usergrade"
	usergrade
case "updategrade"
	updateusergrade
case "delusergrade"
	delusergrade
case "delmoreuser"
	delmoreuser
case else
	showuserlist

end select
adminfooter()

sub showuserlist()
dim action,wheresql,ordersql,order,pageinfo,keyword,search,classid
order=request.querystring("order")
keyword=request.querystring("keyword")
search=request.querystring("search")
classid=request.querystring("classid")
action=lcase(request.querystring("action"))
wheresql="id<>0"
if classid<>"" then wheresql=wheresql&" and classid="&classid
if keyword<>"" then
	if search="1" then
		wheresql=wheresql&" and mail like '%"&keyword&"%'"
	else
		wheresql=wheresql&" and name like '%"&keyword&"%'"
	end if
end if

select case action
	case"sex"
		ordersql="sex"
	case"coin"
		ordersql="coin"
	case"essay"
		ordersql="essaynum"
	case"mark"
		ordersql="mark"
	case"regtime"
		ordersql="regtime"
	case"grade"
		ordersql="gradenum"
	case"isdel"
		wheresql="isdel=FALSE"
	case else
		ordersql="id"
end select
if ordersql="" then ordersql="regtime"
if order<>"1" then ordersql =ordersql&" desc"
if order="3" then ordersql =""
%>

<form>
<div class="ta"><div class="th jz">查找用户</div><div class="tf"><font color="#800000">搜索 <select size="1" name="search">
		<option value=0>用户名</option>
		<option value=1>email</option>
	</select>&nbsp; <input type="text" name="keyword" size="20"> 
	<input type="submit" value="查找" name="b1"></font></div><div style="clear: both;"></div></div>
 </form>
<%
response.write "<form method=""post"" action=""?action=update"" name=""recycle""><div class=""ta""><div class=""th jz"">用户信息管理</div><div class=""tf w470"" style=""float: left;"">查看按：<a href=?action=sex&order="&order&"&search="&search&"&keyword="&keyword&"&classid="&classid&">性别</a>&nbsp;/&nbsp;<a href=?action=essay&order="&order&"&search="&search&"&keyword="&keyword&"&classid="&classid&">贴数</a>&nbsp;/&nbsp;<a href=?action=coin&order="&order&"&search="&search&"&keyword="&keyword&"&classid="&classid&">金钱</a>&nbsp;/&nbsp;<a href=?action=mark&order="&order&"&search="&search&"&keyword="&keyword&"&classid="&classid&">y币</a>&nbsp;/&nbsp;<a href=?action=regtime&order="&order&"&search="&search&"&keyword="&keyword&"&classid="&classid&">注册时间</a>&nbsp;/&nbsp;<a href=?action=grade&order="&order&"&search="&search&"&keyword="&keyword&"&classid="&classid&">等级</a>&nbsp;/&nbsp;<a href=?action=isdel&order=3>审核</a></div><div class=""tf w280"" style=""float: left;"">排序方式：<a href=?action="&action&"&order=1&search="&search&"&keyword="&keyword&"&classid="&classid&">顺</a> / <a href=?action="&action&"&order=2&search="&search&"&keyword="&keyword&"&classid="&classid&">倒</a></div>"
	dim pages,page,arr_rs,i,temp,content
	page = request.querystring("page")
	set pages = new cls_pageview
	pages.strtablename = "[yx_user]"
	pages.strpageurl = "?action="&action&"&order="&order&"&search="&search&"&keyword="&keyword&"&classid="&classid
	pages.strfieldslist = "id,name,sex,mail,essaynum,coin,mark,regtime,GradeNum,isdel"
	pages.strcondiction = wheresql
	pages.strorderlist = ordersql
	pages.strprimarykey = "id"
	pages.intpagesize = 20
	pages.intpagenow = page
	pages.strcookiesname = "members"&keyword&search&classid
	pages.reloadtime=3
	pages.strpagevar = "page"
	pages.initclass
	arr_rs = pages.arrrecordinfo
	pageinfo = pages.strpageinfo
	page=pages.intpagenow
	set pages = nothing
	response.write "<div class=""td1 h20 jz w131"">用户名</div><div class=""td1 jz h20 w50"">性别</div><div class=""td1 h20 jz w87"">e-mail</div><div class=""td1 jz h20 w87"">发帖数</div><div class=""td1 jz h20 w50"">金钱</div><div class=""td1 jz h20 w50"">y币</div><div class=""td1 jz h20 w100"">注册时间</div><div class=""td1 jz h20 w94"">等级</div><div class=""td1 jz h20 w50""><input type=checkbox value=""on"" name=""chkall"" onclick=""checkall(this.form)""></div>"
	if isarray(arr_rs) then
		for i = 0 to ubound(arr_rs, 2)
			SET Rs=YxBBs.Execute("Select GradeName,GradePic From [YX_UserGrade] where GradeNum="&Arr_Rs(8,i)&"")
			if arr_rs(2,i) then temp="男" else temp="女"
			response.write "<div class=""td1 h20 jz w131""><a href='?action=useredit&userid="&arr_rs(0,i)&"'>"&arr_rs(1,i)&"</a></div><div class=""td1 jz h20 w50"">"&temp&"</div><div class=""td1 h20 jz w87""><a href='mailto:"&arr_rs(3,i)&"'><img src='../images/mail.gif' border='0' /></a></div><div class=""td1 jz h20 w87"">"&arr_rs(4,i)&"</div><div class=""td1 jz h20 w50"">"&arr_rs(5,i)&"</div><div class=""td1 jz h20 w50"">"&arr_rs(6,i)&"</div><div class=""td1 jz h20 w100"">"&formatdatetime(arr_rs(7,i),2)&"</div><div class=""td1 jz h20 w94""><img src='../"&Rs("Gradepic")&"' alt="&Rs("GradeName")&"></div><div class=""td1 jz h20 w50""><input type=""checkbox"" name=""userid"" value="""&arr_rs(0,i)&"""></div>"
		next
	end if
	response.write "<div class=""td2 w770""><input type=""radio"" value=""0"" name=""useraction""> 审核用户 <input type=""radio"" value=""1"" name=""useraction""> 屏蔽用户 <input type=""radio"" value=""2"" name=""useraction""> 解除屏蔽 <input type=""radio"" value=""3"" name=""useraction""> 删除用户资料 <input type=""radio"" value=""4"" name=""useraction""> 删除用户帖子 <input type=""radio"" value=""5"" name=""useraction""  checked=""true""> 移动到用户组 <select size=""1"" name=""classid"">"
		dim ucl
		set ucl=conn.execute("select classid,classname from yx_userclass where classid<>6 order by classid asc")
		while not ucl.eof
			if ucl(0)=5 then
				response.write "<option value="&ucl(0)&" selected>"&ucl(1)&"</option>"
			else
				response.write "<option value="&ucl(0)&">"&ucl(1)&"</option>"
			end if
		ucl.movenext
		wend
		set ucl=nothing
	response.write "</select> <input type=""submit"" value=""执行操作"" name=""b1"" onclick=""{if(confirm('确定执行选择的操作吗?')){this.document.recycle.submit();return true;}return false;}""></div>"
	response.write "<div class=""tf h20"">"&pageinfo&"</div><div style=""clear: both;""></div></div></form>"
%>
<form method="post" action="?action=delmoreuser">
<div class="ta"><div class="th jz">批量删除用户</div><div class="tf"><font color="#800000">发帖数 <select size="1" name="EssayNum">
		<option value=0>0帖</option>
		<option value=1>1帖</option>
		<option value=3>3帖</option>
		<option value=5>5帖</option>
	</select>&nbsp; 登陆次数<select size="1" name="LoginNum">
		<option value=0>0次</option>
		<option value=1>1次</option>
		<option value=3>3次</option>
		<option value=5>5次</option>
	</select>
	<input type="submit" value="删除" name="b1"></font></div><div style="clear: both;"></div></div>
 </form>
<script language="javascript">
<!--
function checkall(form) {
 for (var i=0;i<form.elements.length;i++)	{
	var e = form.elements[i];
	if (e.name != 'chkall')
		e.checked = form.chkall.checked; 
	}
 }
//-->
</script>
<%
end sub

Sub delmoreuser
dim EssayNum,LoginNum
	EssayNum=request.form("EssayNum")
	LoginNum=request.form("LoginNum")
	yxbbs.execute("delete from[yx_user] where EssayNum<="&EssayNum&" and LoginNum<="&LoginNum&"")
	call suc("","成功的删除了帖子少于"&EssayNum&",并且登陆少于"&LoginNum&"次的用户！","users.asp")
end sub
sub updateuserdata
	dim useraction,userid,classid,succstr,topiccount,flag,i,urs,alltable
	useraction=request.form("useraction")
	userid=request.form("userid")
	classid=request.form("classid")
	if replace(userid,",","")="" then
		call goback("","请选择相应的用户！")
		exit sub
	end if

	select case useraction
		case 0
			yxbbs.execute("update [yx_user] set isdel=1 where id in (" &userid& ")")
			call suc("","用户审核通过！","users.asp")
		case 1
			yxbbs.execute("update [yx_user] set isshow=true where id in (" &userid& ")")
			call suc("","成功屏蔽用户发言！","users.asp")
		case 2
			yxbbs.execute("update [yx_user] set isshow=false where id in (" &userid& ")")
			call suc("","成功解除屏蔽用户发言！","users.asp")
		case 3
			'计算被删贴子数
			set urs=conn.execute("select name from [yx_user] where id in (" &userid& ")")
				while not urs.eof
					alltable=split(yxbbs.bbstable(0),",")
					for i=0 to ubound(alltable)
						yxbbs.execute("delete from[yx_bbs"&alltable(i)&"] where name='"&urs(0)&"'")
						yxbbs.execute("delete from[yx_bbs"&alltable(i)&"] where replytopicid in (select topicid from[yx_topic] where name='"&urs(0)&"')")
					next
					yxbbs.execute("delete from[yx_topic] where  name='"&urs(0)&"'")
					yxbbs.execute("delete from[yx_sms] where  myname='"&urs(0)&"'")
					yxbbs.execute("delete from[yx_admin] where username='"&urs(0)&"'")
					yxbbs.execute("delete from[yx_user] where name='"&urs(0)&"'")
					urs.movenext
				wend
			set urs=nothing
			call suc("","所选用户（包括所有帖子、留言等）已经被彻底删除！","users.asp")
		case 4
			'计算被删贴子数
			set urs=conn.execute("select name from [yx_user] where id in (" &userid& ")")
				while not urs.eof
					alltable=split(yxbbs.bbstable(0),",")
					for i=0 to ubound(alltable)
					yxbbs.execute("delete from[yx_bbs"&alltable(i)&"] where name='"&urs(0)&"'")
					yxbbs.execute("delete from[yx_bbs"&alltable(i)&"] where replytopicid in (select topicid from[yx_topic] where name='"&urs(0)&"')")
					next
					yxbbs.execute("delete from[yx_topic] where name='"&urs(0)&"'")
					urs.movenext
				wend
			set urs=nothing
			call suc("","成功删除所选用户发表的所有帖子！","users.asp")
		case 5
			set rs=conn.execute("select gradenum,gradename,gradepic from yx_usergrade where classid="&classid)
			if rs.eof or rs.bof then
				call goback("错误提示","没有此用户组或已被删除。")
				exit sub
			end if
			conn.execute("update yx_user set gradenum="&rs("gradenum")&",classid="&classid&" where id in (" &userid& ")")
			set rs=nothing
			call suc("","成功转移所选用户!","users.asp")
	end select
end sub

sub useredit
dim rs,i,classid,username,userid,password,question,answer,sex,gradename,email,homepage,qq,icq,msn,headfile,headwidth
dim usertitle,mark,coin,banksave
dim headheight,sign,birthday,registtime,lastlogintime,useraction
userid=request("userid")
set rs=conn.execute("select * from yx_user where id="&userid)
if rs.eof then
	call goback("错误提示","找不到用户或已被删除！")
	response.end
end if
classid=rs("classid")
username=rs("name")
password=rs("password")
question=rs("clue")
answer=rs("answer")
sex=rs("sex")
email=rs("mail")
homepage=rs("home")
qq=rs("qq")
headfile=rs("pic")
headwidth=rs("picw")
headheight=rs("pich")
sign=rs("sign")
usertitle=rs("honor")
mark=rs("mark")
coin=rs("coin")
banksave=rs("banksave")
birthday=rs("birthday")
registtime=rs("regtime")
lastlogintime=rs("lasttime")
useraction=rs("isshow")
set rs=nothing
%>
<form action="?action=edituser" method=post>
<div class="ta">
<div class="th jz">用户基本资料修改</div>
<div class="td1 h20">用户组</div>
<div class="td2 h20"><input type="hidden" name="userid" value="<%=userid%>">
		<input type="hidden" name="oldclassid" value="<%=classid%>">
		<select size="1" name="classid">
		<%
		dim ucl
		set ucl=conn.execute("select classid,classname from yx_userclass where classid<>6 order by classid asc")
		while not ucl.eof
			response.write "<option value='"&ucl("classid")&"'"
			if classid=ucl("classid") then response.write "selected"
			response.write ">"&ucl("classname")&"</option>"
			ucl.movenext
		wend
		set ucl=nothing
		%>
		</select></div>
<div class="td1 h20">用户名</div>
<div class="td2 h20"><input type="hidden" name="oldusername" value="<%=username%>"><input name="username" size="30" value="<%=username%>"></div>
<div class="td1 h20">密&nbsp;&nbsp; 码</div>
<div class="td2 h20"><input type="hidden" name="oldpassword" value="<%=password%>"><input name="password" size="30" >　如不修改请留空</div>
<div class="td1 h20">密码问题</div>
<div class="td2 h20"><input name="question" size="30" value="<%=question%>"></div>
<div class="td1 h20">密码答案</div>
<div class="td2 h20"><input type="hidden" name="oldanswer" value="<%=answer%>"><input name="answer" size="30">　如不修改请留空</div>
<div class="td1 h20">性别</div>
<div class="td2 h20"><input type="radio" name="sex" value="1" <%if sex then response.write"checked=""true"""%>>
		男 <input type="radio" name="sex" value="0" <%if not sex then response.write"checked=""true"""%>>
		女</div>
<div class="td1 h20">自定头衔</div>
<div class="td2 h20"><input name="usertitle" size="30" value="<%=usertitle%>"></div>
<div class="td1 h20">用户状态</div>
<div class="td2 h20">正常 
		<input type="radio" value="0" name="useraction" <%if not useraction then response.write " checked=""true"""%>>&nbsp; 
		屏蔽 
		<input type="radio" value="1" name="useraction" <%if useraction then response.write " checked=""true"""%>></div>
<div class="td1 h20">邮箱</div>
<div class="td2 h20"><input name="email" size="30" value="<%=email%>"></div>
<div class="td1 h20">个人主页</div>
<div class="td2 h20"><input name="homepage" size="30" value="<%=homepage%>"></div>
<div class="td1 h20">qq号码</div>
<div class="td2 h20"><input name="qq" size="30" value="<%=qq%>"></div>
<div class="td1 h20">论坛头像</div>
<div class="td2 h20"><input name="headfile" size="30" value="<%=headfile%>">　图片宽<input name="headwidth" size="5" value="<%=headwidth%>">&nbsp; 
		图片高<input name="headheight" size="5" value="<%=headheight%>"></div>
<div class="td1 h65">个人签名</div>
<div class="td2 h65 w446"><textarea rows="3" name="sign" cols="29"><%=sign%></textarea></div>

<div class="td1 h20">用户金钱</div>
<div class="td2 h20"><input name="coin" size="30" value="<%=coin%>"></div>
<div class="td1 h20">用户存款</div>
<div class="td2 h20"><input name="banksave" size="30" value="<%=banksave%>"></div>
<div class="td1 h20">用户y币</div>
<div class="td2 h20"><input name="mark" size="30" value="<%=mark%>"></div>

<div class="td1 h20">出生日期</div>
<div class="td2 h20"><input name="birthday" size="30" value="<%=birthday%>">　格式:1986-8-16</div>
<div class="td1 h20">注册时间</div>
<div class="td2 h20"><input name="registtime" size="30" value="<%=registtime%>"></div>
<div class="td1 h20">最后登录</div>
<div class="td2 h20"><input name="lastlogintime" size="30" value="<%=lastlogintime%>"></div>
<div style="clear: both;"></div><div class="tf jz"><input type="submit" value="编 辑" name="b1"></div>
</div></form>
	
<%
end sub

sub edituser

dim rs,classid,username,userid,oldpassword,password,question,answer,sex,gradename,email,homepage,qq,icq,msn,headfile,headwidth
dim usertitle,mark,coin,banksave
dim headheight,sign,birthday,registtime,lastlogintime,useraction,oldclassid,oldanswer,oldpassowrd,sql,oldusername,alltable,i
userid=request.form("userid")
classid=request.form("classid")
oldclassid=request.form("oldclassid")
username=request.form("username")
oldusername=request.form("oldusername")
password=request.form("password")
oldpassword=request.form("oldpassword")
question=request.form("question")
answer=request.form("answer")
oldanswer=request.form("oldanswer")
sex=request.form("sex")
usertitle=request.form("usertitle")
mark=request.form("mark")
coin=request.form("coin")
banksave=request.form("banksave")
email=request.form("email")
homepage=request.form("homepage")
qq=request.form("qq")
icq=request.form("icq")
msn=request.form("msn")
headfile=request.form("headfile")
headwidth=request.form("headwidth")
headheight=request.form("headheight")
sign=request.form("sign")
birthday=request.form("birthday")
registtime=request.form("registtime")
lastlogintime=request.form("lastlogintime")
useraction=request.form("useraction")
if cint(classid)<>cint(oldclassid) then
	set rs=conn.execute("select gradenum,gradename,gradepic from yx_usergrade where classid="&classid)
	if rs.eof or rs.bof then
		call goback("错误提示","没有此用户组或已被删除！")
		exit sub
	end if
	conn.execute("update yx_user set gradenum="&rs("gradenum")&",classid="&classid&" where id =" &userid)
	set rs=nothing
end if

if oldusername<>"" or username<>"" or username <> oldusername then
	if lcase(username)=lcase(oldusername) then
		if yxbbs.execute("select name from[yx_user] where name='"&oldusername&"'").eof then call goback("","这个用户根本不存在！"):exit sub
	else
		if yxbbs.execute("select name from[yx_user] where name='"&oldusername&"'").eof then call goback("","这个用户根本不存在！"):exit sub
		if not yxbbs.execute("select name from[yx_user] where name='"&username&"'").eof then call goback("","新用户名称已经被注册了！"):exit sub
	end if
	alltable=split(yxbbs.bbstable(0),",")
	for i=0 to ubound(alltable)
		yxbbs.execute("update [yx_bbs"&alltable(i)&"] set name='"&username&"' where lcase(name)='"&oldusername&"'")
	next
	yxbbs.execute("update [yx_topicvoteuser] set [user]='"&username&"' where lcase([user])='"&oldusername&"'")
	yxbbs.execute("update [yx_topic] set name='"&username&"' where lcase(name)='"&oldusername&"'")
	yxbbs.execute("update [yx_sms] set myname='"&username&"' where lcase(myname)='"&oldusername&"'")
	yxbbs.execute("update [yx_sms] set name='"&username&"' where lcase(name)='"&oldusername&"'")
	yxbbs.execute("update [yx_user] set name='"&username&"' where lcase(name)='"&oldusername&"'")
	yxbbs.execute("update [yx_admin] set name='"&username&"' where lcase(name)='"&oldusername&"'")
end if

set rs=server.createobject("adodb.recordset")
sql="select * from yx_user where id="&userid
rs.open sql,conn,1,3
if rs.eof then
	call goback("错误提示","没有此用户或已被删除。")
	exit sub
end if
rs("name")=username
if password<>"" then rs("password")=md5(password)
rs("clue")=question
if answer<>"" then rs("answer")=md5(answer)
rs("sex")=sex
rs("home")=homepage
rs("qq")=qq
rs("mail")=email
rs("pic")=headfile
rs("picw")=headwidth
rs("pich")=headheight
rs("sign")=sign
rs("honor")=usertitle
rs("mark")=mark
rs("coin")=coin
rs("banksave")=banksave
rs("birthday")=birthday
rs("regtime")=registtime
rs("lasttime")=lastlogintime
rs("isshow")=useraction
rs.update
rs.close
set rs= nothing
call suc("","用户修改成功!","users.asp")
end sub

sub addadmin%>
 <form action="?action=saveadmin" method=post>
<div class="ta">
        <div class="th jz">管 理 员 添 加</div>
        <div class="td1 h20">后台登陆名称</div>
        <div class="td2 h20""><input name="adminname" size="30"></div>
	<div class="td1 h20"">后台登陆密码</div>
	<div class="td2 h20""><input type=password name="password" size="30"></div>
        <div class="td1 h20"">前台用户名称</div>
	<div class="td2 h20""><input type="text" name="username" size="30"></div>
	<div style="clear: both;"></div><div class="tf jz"><input type="submit" value="添 加" name="b1"></div>
	</div></form>
<%end sub

sub saveadmin
Dim Password,UserName,UserID
AdminName=Request.form("AdminName")
Password=Request.form("Password")
UserName=Request.form("UserName")

if AdminName="" or UserName="" then
	Call GoBack("","请输入前台或后台登陆名称！")	
end if

if Password="" then
	Call GoBack("","请输入后台密码！")	
else
 	Password=Md5(Password)
end if

set rs=Conn.execute("Select ID from YX_User where Name='"&UserName&"'")
if rs.eof or rs.bof then
	Call GoBack("","无效的注册用户")
else
	UserID=rs(0)
end if
set Rs=Conn.execute("select Name from YX_Admin where Name='"&AdminName&"'")
if not (rs.eof and rs.bof) then
	Call GoBack("","此用户已存在！请使用其他名称！")

end if
dim GradeNum
set Rs=Conn.Execute("select GradeNum from YX_UserGrade where GradeID=1")
GradeNum=Rs(0)
set rs=nothing

Conn.execute("Update YX_User set ClassID=1,GradeNum="&GradeNum&" where ID="&UserID)
Conn.execute("Insert into YX_Admin (Name,[Password],UserName) values('"&AdminName&"','"&Password&"','"&UserName&"')")
Call Suc("","恭喜您！添加成功！","?action=admin")
end sub


sub admin%>
	<div class="ta">
        <div class="th jz">管 理 员 信 息</div>
        <div class="td3 h20 w231"  style="float: left;">用户名</div>
        <div class="td3 h20 w231"  style="float: left;">前台用户名</div>
        <div class="td3 h20 w291"  style="float: left;">操作</div>
		<%
		set rs=conn.execute("select id,name,username from yx_admin")
		while not rs.eof
		%>
 		<div class="td3 w231"><a href="?action=useredit&userid=<%=rs("id")%>"><%=rs("name")%></a></div>		
		<div class="td3 w231"><%=rs("username")%></div>		
		<div class="td3 w291" ><a href="?action=editadmin&id=<%=rs("id")%>">编辑</a> <a href="?action=deladmin&id=<%=rs("id")%>" onclick="return okdel()">删除</a></div>		
		<%
		rs.movenext
		wend
		set rs=nothing
		%>
<div style="clear: both;"></div></div>
<%end sub

sub editadmin
dim id
id=request("id")
if id="" or not isnumeric(id) then
	call goback("","错误参数！")	
end if

set rs=conn.execute("select name,username from yx_admin where id="&id)
if rs.eof or rs.bof then
	call goback("","没有此管理员！")
else
%>
 <form action="?action=saveeditadmin" method=post>
<div class="ta">
        <div class="th jz">管 理 员 编 辑</div>
        <div class="td1 h20">后台登陆名称</div>
        <div class="td2 h20"><input type="hidden" name="id" value="<%=id%>">
		<input name="adminname" size="30" value="<%=rs(0)%>"></div>
	<div class="td1 h20">后台登陆密码</div>
	<div class="td2 h20"><input type=password name="password" size="30"> <font color="#999999">如不更改请留空！</font></div>
        <div class="td1 h20">前台用户名称</div>
	<div class="td2 h20"><%=rs(1)%></div>
	<div style="clear: both;"></div><div class="tf jz"><input type="submit" value="编 辑" name="b1"></div>
	</div></form>
<%
end if
set rs=nothing
end sub

sub saveeditadmin
dim id,sql,password
adminname=request.form("adminname")
password=request.form("password")
id=request.form("id")

if id="" or not isnumeric(id) then
	call goback("","参数错误！")	
end if

if adminname="" then
	call goback("","请输入后台登录名称！")	
end if

set rs=server.createobject("adodb.recordset")
sql="select * from yx_admin where id="&id
rs.open sql,conn,1,3
if rs.eof or rs.bof then
	call goback("","没有此用户！")	
else
	rs("name")=adminname
	if password <> "" then rs("password")=md5(password)
	rs.update
end if
rs.close
set rs=nothing
call suc("","管理员修改成功！","?action=admin")
end sub

sub deladmin
        if conn.execute("select count(*) from yx_admin")(0)<=1 then 
        call goback("","目前只有一个管理员，不能删除！")
        else
        conn.execute("delete from yx_admin where id="&request("id")&"")
        call suc("","管理员删除成功！","?action=admin")
		    end if
end sub

sub userclassadd
%>
 <form action="?action=saveaddclass" method=post name="creator">
<div class="ta">
<div class="th jz">用 户 组 添 加</div>
<div class="td1 h20">组名称</div>
<div class="td2 h20"><input name="classname" size="20"></div>
<div style="clear: both;"></div><div class="tf">一般权限</div>
<div class="td1 h20">可以查看会员信息</div>
<div class="td2 h20">是<input  checked="true" name="canviewuserinfo" type="radio" value="1">&nbsp;否<input name="canviewuserinfo" type="radio" value="0"></div>
<div class="td1 h20">可以查看其他人发布的主题</div>
<div class="td2 h20">是<input  checked="true" name="canviewnewtopic" type="radio" value="1">&nbsp;否<input name="canviewnewtopic" type="radio" value="0"></div>
<div class="td1 h20">可以浏览精华帖子</div>
<div class="td2 h20">是<input checked="true" name="canviewtopicdigest" type="radio" value="1">&nbsp;否<input name="canviewtopicdigest" type="radio" value="0"></div>
<div class="td1 h20">可以发布新主题</div>
<div class="td2 h20">是<input checked="true" name="cannewtopic" type="radio" value="1">&nbsp;否<input name="cannewtopic" type="radio" value="0"></div>
<div class="td1 h20">可以回复自己的主题</div>
<div class="td2 h20">是<input checked="true" name="canpostmytopic" type="radio" value="1">&nbsp;否<input name="canpostmytopic" type="radio" value="0"></div>
<div class="td1 h20">可以回复其他人的主题</div>
<div class="td2 h20">是<input checked="true" name="canpostorthertopic" type="radio" value="1">&nbsp;否<input name="canpostorthertopic" type="radio" value="0"></div>
<div class="td1 h20">可以上传附件</div>
<div class="td2 h20">是<input checked="true" name="canupfile" type="radio" value="1">&nbsp;否<input name="canupfile" type="radio" value="0"></div>
<div class="td1 h20">可以发布新投票</div>
<div class="td2 h20">是<input checked="true" name="cannewtopicvote" type="radio" value="1">&nbsp;否<input name="cannewtopicvote" type="radio" value="0"></div>
<div class="td1 h20">可以参与投票</div>
<div class="td2 h20">是<input checked="true" name="canposttopicvote" type="radio" value="1">&nbsp;否<input name="canposttopicvote" type="radio" value="0"></div>
<div class="td1 h20">可以编辑自己的帖子</div>
<div class="td2 h20">是<input checked="true" name="caneditmytopic" type="radio" value="1">&nbsp;否<input name="caneditmytopic" type="radio" value="0"></div>
<div class="td1 h20">可以发送短信</div>
<div class="td2 h20">是<input name="cansendmessage" type="radio" value="1" checked="true">&nbsp;否<input name="cansendmessage" type="radio" value="0"></div>
<div class="td1 h20">每日最多上传</div>
<div class="td2 h20"><input name="sendmaxcount" size="10" value="5"></div>
<div class="td1 h20">上传大小限制</div>
<div class="td2 h20"><input name="sendmessagemaxsize" size="10" value="300"> KB</div>
<div class="td1 h20">信箱大小限制</div>
<div class="td2 h20"><input name="messagemaxsize" size="10" value="100"> KB</div>
<div style="clear: both;"></div><div class="tf">管理权限</div>
<div class="td1 h20">可以删除其它人帖子</div>
<div class="td2 h20">是<input name="candeltopic" type="radio" value="1">&nbsp;否<input name="candeltopic" type="radio" value="0" checked="true"></div>
<div class="td1 h20">可以移动其它人帖子</div>
<div class="td2 h20">是<input name="canmovetopic" type="radio" value="1">&nbsp;否<input name="canmovetopic" type="radio" value="0" checked="true"></div>
<div class="td1 h20">可以固顶/解除固顶帖子</div>
<div class="td2 h20">是<input name="cantoptopic" type="radio" value="1">&nbsp;否<input name="cantoptopic" type="radio" value="0" checked="true"></div>
<div class="td1 h20">可以进行帖子总固顶操作</div>
<div class="td2 h20">是<input name="canttoptopic" type="radio" value="1">&nbsp;否<input name="canttoptopic" type="radio" value="0" checked="true"></div>
<div class="td1 h20">可以编辑其它人帖子</div>
<div class="td2 h20">是<input name="canedittopic" type="radio" value="1">&nbsp;否<input name="canedittopic" type="radio" value="0" checked="true"></div>
<div class="td1 h20">可以加入/解除精华帖子v</div>
<div class="td2 h20">是<input name="candigesttopic" type="radio" value="1">&nbsp;否<input name="candigesttopic" type="radio" value="0" checked="true"></div>
<div class="td1 h20">可以锁定/解除锁定其它人帖子</div>
<div class="td2 h20">是<input name="canlocktopic" type="radio" value="1">&nbsp;否<input name="canlocktopic" type="radio" value="0" checked="true"></div>
<div class="td1 h20">可以提升他人帖子</div>
<div class="td2 h20">是<input name="tstopic" type="radio" value="1">&nbsp;否<input name="tstopic" type="radio" value="0" checked="true"></div>
<div style="clear: both;"></div><div class="tf jz"><input type="submit" value="添 加" name="b1"></div></div></form>
<%
end sub

sub saveaddclass
	dim classname,classsetting
	classname=request.form("classname")
	if classname="" then
		call goback("","您没有输入组名,请输入组名。")
		exit sub
	end if
	
	classsetting=request.form("canviewuserinfo") & "," & request.form("canviewnewtopic") & "," & request.form("canviewtopicdigest") & "," & request.form("cannewtopic") & "," & request.form("canpostmytopic") & "," & request.form("canpostorthertopic") & "," & request.form("canupfile") & "," & request.form("cannewtopicvote") & "," & request.form("canposttopicvote") & "," & request.form("caneditmytopic") & "," & request.form("cansendmessage") & "," & request.form("sendmaxcount") & "," & request.form("sendmessagemaxsize") & "," & request.form("messagemaxsize") & "," & request.form("candeltopic") & "," & request.form("canmovetopic") & "," & request.form("cantoptopic") & "," & request.form("canttoptopic") & ","& request.form("canedittopic") & "," & request.form("candigesttopic") & "," & request.form("canlocktopic") & "," & request.form("tstopic")
	dim rs
	set rs=conn.execute("select * from yx_usergrade where gradename='" & classname & "'")
	
	if not(rs.eof and rs.bof) then
		call goback("","该等级名称已经存在!")
		exit sub
	end if
	
	dim sql
	set rs=server.createobject("adodb.recordset")
	sql="select * from yx_userclass where classname='"& classname &"'"
	rs.open sql,conn,1,3
	if rs.eof or rs.bof then
		rs.addnew
		rs("classname")=classname
		rs("classsetting")=classsetting
		rs.update
	else
		call goback("","该用户组名称已经存在！")
		exit sub
	end if
	
	rs.close
	set rs=nothing
	call suc("","用户组添加成功！","?action=userclass")
end sub

sub userclass
%>
<div class="ta">
<div class="th jz">用 户 组 管 理</div>
<div class="td3 w160">用户组</div>
<div class="td3 w100">用户数量</div>
<div class="td3 w152">编辑权限</div>
<div class="td3 w160">例出所有用户</div>
<div class="td3 w162">操作</div>
	  <%
		dim user_count,uc
		set rs=conn.execute("select classid,classname from yx_userclass")
		while not rs.eof 
			set uc=conn.execute("select count(id) from yx_user where classid="&rs(0)&"")
				user_count=uc(0)
				uc.close
			set uc=nothing
		%>
	
		<div class="td3 w160"><%=rs("classname")%></div>		
		<div class="td3 w100"><%=user_count%></div>		
		<div class="td3 w152"><a href="?action=classedit&classid=<%=rs("classid")%>">编辑</a></div>		
		<div class="td3 w160"><a href="users.asp?classid=<%=rs("classid")%>">查看</a></div>
                <div class="td3 w162"><a href="users.asp?action=deluserclass&classid=<%=rs("classid")%>" onclick="checkclick('删除前请先将该组用户全部移动到其他组,否则后果自负!\n\n您确定要删除吗？')">删除</a></div>		
	  <%
		rs.movenext
		wend
		rs.close
		set rs=nothing
		%>
	<div style="clear: both;"></div></div>
<%end sub

sub userclassedit
	dim rs,classid,classname,classsetting
	classid=request("classid")
	if not isnumeric(classid) then
		call goback("错误提示","参数错误，请提交正确的参数")
		exit sub
	end if
	set rs=conn.execute("select * from yx_userclass where classid="& classid)
	if rs.eof or rs.bof then
		call goback("错误提示","找不到此用户组或已被删除。")
		exit sub
	else
		classname=rs("classname")
				classsetting=split(rs("classsetting"),",")
%>
<form action="?action=saveeditclass" method=post name="creator">
<div class="ta">
<div class="th jz">用 户 组 添 加</div>
<div class="td1 h20">组名称</div>
<div class="td2 h20"><input type="hidden" name="classid" value="<%=classid%>">
		<input name="classname" size="20" value="<%=classname%>" readonly></div>
<div style="clear: both;"></div><div class="tf">一般权限</div>
<div class="td1 h20">可以查看会员信息</div>
<div class="td2 h20">是<input name="canviewuserinfo" type="radio" value="1" <%if classsetting(0)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canviewuserinfo" type="radio" value="0" <%if classsetting(0)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以查看其他人发布的主题</div>
<div class="td2 h20">是<input name="canviewnewtopic" type="radio" value="1" <%if classsetting(1)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canviewnewtopic" type="radio" value="0" <%if classsetting(1)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以浏览精华帖子</div>
<div class="td2 h20">是<input name="canviewtopicdigest" type="radio" value="1" <%if classsetting(2)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canviewtopicdigest" type="radio" value="0" <%if classsetting(2)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以发布新主题</div>
<div class="td2 h20">是<input name="cannewtopic" type="radio" value="1" <%if classsetting(3)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="cannewtopic" type="radio" value="0" <%if classsetting(3)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以回复自己的主题</div>
<div class="td2 h20">是<input name="canpostmytopic" type="radio" value="1" <%if classsetting(4)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canpostmytopic" type="radio" value="0" <%if classsetting(4)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以回复其他人的主题</div>
<div class="td2 h20">是<input name="canpostorthertopic" type="radio" value="1" <%if classsetting(5)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canpostorthertopic" type="radio" value="0" <%if classsetting(5)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以上传附件</div>
<div class="td2 h20">是<input name="canupfile" type="radio" value="1" <%if classsetting(6)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canupfile" type="radio" value="0" <%if classsetting(6)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以发布新投票</div>
<div class="td2 h20">是<input name="cannewtopicvote" type="radio" value="1" <%if classsetting(7)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="cannewtopicvote" type="radio" value="0" <%if classsetting(7)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以参与投票</div>
<div class="td2 h20">是<input name="canposttopicvote" type="radio" value="1" <%if classsetting(8)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canposttopicvote" type="radio" value="0" <%if classsetting(8)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以编辑自己的帖子</div>
<div class="td2 h20">是<input name="caneditmytopic" type="radio" value="1" <%if classsetting(9)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="caneditmytopic" type="radio" value="0" <%if classsetting(9)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以发送短信</div>
<div class="td2 h20">是<input name="cansendmessage" type="radio" value="1" <%if classsetting(10)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="cansendmessage" type="radio" value="0" <%if classsetting(10)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">每日最多上传</div>
<div class="td2 h20"><input name="sendmaxcount" size="10" value="<%=classsetting(11)%>"></div>
<div class="td1 h20">上传大小限制</div>
<div class="td2 h20"><input name="sendmessagemaxsize" size="10" value="<%=classsetting(12)%>"> KB</div>
<div class="td1 h20">信箱大小限制</div>
<div class="td2 h20"><input name="smsboxmaxsize" size="10" value="<%=classsetting(13)%>"> KB</div>
<div style="clear: both;"></div><div class="tf">管理权限</div>
<div class="td1 h20">可以删除其它人帖子</div>
<div class="td2 h20">是<input name="candeltopic" type="radio" value="1" <%if classsetting(14)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="candeltopic" type="radio" value="0" <%if classsetting(14)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以移动其它人帖子</div>
<div class="td2 h20">是<input name="canmovetopic" type="radio" value="1" <%if classsetting(15)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canmovetopic" type="radio" value="0" <%if classsetting(15)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以固顶/解除固顶帖子</div>
<div class="td2 h20">是<input name="cantoptopic" type="radio" value="1" <%if classsetting(16)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="cantoptopic" type="radio" value="0" <%if classsetting(16)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以进行帖子总固顶操作</div>
<div class="td2 h20">是<input name="canttoptopic" type="radio" value="1" <%if classsetting(17)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canttoptopic" type="radio" value="0" <%if classsetting(17)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以编辑其它人帖子</div>
<div class="td2 h20">是<input name="canedittopic" type="radio" value="1" <%if classsetting(18)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canedittopic" type="radio" value="0" <%if classsetting(18)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以加入/解除精华帖子</div>
<div class="td2 h20">是<input name="candigesttopic" type="radio" value="1" <%if classsetting(19)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="candigesttopic" type="radio" value="0" <%if classsetting(19)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以锁定/解除锁定其它人帖子</div>
<div class="td2 h20">是<input name="canlocktopic" type="radio" value="1" <%if classsetting(20)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="canlocktopic" type="radio" value="0" <%if classsetting(20)=0 then response.write "checked=""true"""%>></div>
<div class="td1 h20">可以提升他人帖子</div>
<div class="td2 h20">是<input name="tstopic" type="radio" value="1" <%if classsetting(21)=1 then response.write "checked=""true"""%>>&nbsp;否<input name="tstopic" type="radio" value="0" <%if classsetting(21)=0 then response.write "checked=""true"""%>></div>
<div style="clear: both;"></div><div class="tf jz"><input type="submit" value="修 改" name="b1"></div></div>
</form>

<%
end if
end sub

sub saveeditclass
	dim classid,classsetting,sql
	classid=request.form("classid")
	if classid="" or not isnumeric(classid) then
		call goback("错误提示","参数错误码，请确认正确的参数。")
		exit sub
	end if
	
	classsetting=request.form("canviewuserinfo") & "," & request.form("canviewnewtopic") & "," & request.form("canviewtopicdigest") & "," & request.form("cannewtopic") & "," & request.form("canpostmytopic") & "," & request.form("canpostorthertopic") & "," & request.form("canupfile") & "," & request.form("cannewtopicvote") & "," & request.form("canposttopicvote") & "," & request.form("caneditmytopic") & "," & request.form("cansendmessage") & "," & request.form("sendmaxcount") & "," & request.form("sendmessagemaxsize") & "," & request.form("smsboxmaxsize") & "," & request.form("candeltopic") & "," & request.form("canmovetopic") & "," & request.form("cantoptopic") & "," & request.form("canttoptopic") & ","& request.form("canedittopic") & "," & request.form("candigesttopic") & "," & request.form("canlocktopic") & "," & request.form("tstopic")
	
	dim rs
	set rs=server.createobject("adodb.recordset")
	sql="select * from yx_userclass where classid="& request.form("classid")
	rs.open sql,conn,1,3
	if not (rs.eof and rs.bof) then
		'rs("classname")=classname
		rs("classsetting")=classsetting
		rs.update
	else
		call goback("错误提示","没有此用户组，或者已被删除。")
		exit sub
	end if
	rs.close
	set rs=nothing
	
	call suc("","用户组修改成功！","?action=userclass")
end sub

sub deluserclass
dim classid
classid=request("classid")
yxbbs.execute("delete * from [yx_userclass] where classid="&classid&"")
call suc("","用户组删除成功！建议您到更新用户数据中进行更新操作！","?action=userclass")
end sub

sub usergradeadd
%>
	<form action="?action=saveaddgrade" method=post>
	<div class="ta">
        <div class="th jz">添加新的用户等级</div>
        <div class="td1 h20">名称</div>
        <div class="td2 h20"><input name="gradename" size="30"></div>
	<div class="td1 h20">等级</div>
	<div class="td2 h20"><input name="gradenum" size="30"></div>
        <div class="td1 h20">图片</div>
	<div class="td2 h20"><input name="gradepic" size="30"></div>
	<div class="td1 h20">最少发贴量</div>
	<div class="td2 h20"><input name="userminpostnum" size="30"></div>
	<div class="td1 h20">所属用户组</div>
	<div class="td2 h20"><select size="1" name="classid">
		<%
		dim rs
		set rs=conn.execute("select classid,classname from yx_userclass order by classid asc")
		while not rs.eof
		%>
		<option value="<%=rs("classid")%>"><%=rs("classname")%></option>
		<%
		rs.movenext
		wend
		rs.close
		set rs=nothing
		%>
		</select></div>
	<div style="clear: both;"></div><div class="tf jz"><input type="submit" value="添 加" name="b1"></div>
	</div></form>
	
<%
end sub

sub saveaddgrade
	dim gradename,gradenum,gradepic,userminpostnum,classid,flag,errstr
	gradename=request.form("gradename")
	gradenum=request.form("gradenum")
	gradepic=request.form("gradepic")
	userminpostnum=request.form("userminpostnum")
	classid=request.form("classid")
	flag=false
	errstr=""
	if gradename="" then
		errstr="<li>等级名没写。</li><br />"
		flag=true
	end if
	
	if gradenum="" then
		errstr=errstr&"<li>等级序号没写。</li><br />"
		flag=true
	elseif not isnumeric(gradenum) then
		errstr=errstr&"<li>等级序号只能是数字。</li><br />"
		flag=true
	end if
	
	if gradepic="" then
		errstr=errstr&"<li>等级图片没有。</li><br />"
		flag=true
	end if
	
	if userminpostnum="" then
		errstr=errstr&"<li>新的等级需要文章数没写</li>"
		flag=true
	elseif not isnumeric(userminpostnum) then
		errstr=errstr&"<li>新的等级文章数只能是数字</li>"
		flag=true
	end if
	
	if flag then
		call goback("错误提示",errstr)
		exit sub
	end if
	
	dim rs,sql
	set rs = server.createobject ("adodb.recordset")
	sql="select * from yx_usergrade where gradename='" & gradename& "'"
	rs.open sql,conn,1,3
	if rs.eof or rs.bof then
		rs.addnew
		rs("gradename")=gradename
		rs("gradenum")=gradenum
		rs("gradepic")=gradepic
		rs("userminpostnum")=userminpostnum
		rs("classid")=classid
		rs.update
	else
		call goback("","<li>该等级名称已经存在。")
                
		exit sub
	end if
	rs.close
	set rs=nothing
	call suc("","用户等级添加成功！建议您到更新用户数据中进行更新操作！","?action=usergrade")
end sub

sub usergrade
%>
	<form method="post" action="?action=updategrade">
<div class="ta">
<div class="th jz">用 户 等 级 管 理</div>
<div class="td3 h20 w160">名称</div>
<div class="td3 h20 w160">图片</div>
<div class="td3 h20 w100">等级</div>
<div class="td3 h20 w100">最少发贴量</div>
<div class="td3 h20 w100">所属用户组id</div>
<div class="td3 h20 w106">操作</div>
		<%
		dim rs
		set rs=conn.execute("select * from yx_usergrade order by gradeid asc")
		while not rs.eof 
		%>
 		<div class="td3 h20 w160">
		<input type="hidden" name="gradeid"  value="<%=rs("gradeid")%>">
		<input type="text" name="gradename" size="14" value="<%=rs("gradename")%>"></div>		
		<div class="td3 h20 w160">
		<input type="text" name="gradepic" size="22" value="<%=rs("gradepic")%>"></div>		
		<div class="td3 h20 w100">
		<input type="text" name="gradenum" size="10" value="<%=rs("gradenum")%>"></div>			
		<div class="td3 h20 w100"><input type="text" name="userminpostnum" size="10" value="<%=rs("userminpostnum")%>"></div>	
		<div class="td3 h20 w100"><input type="text" name="classid" size="10" value="<%=rs("classid")%>"></div>
		<div class="td3 h20 w106">		
		<a href="?action=delusergrade&gradeid=<%=rs("gradeid")%>">删除</a></div>	
		<%
		rs.movenext
		wend
		rs.close
		set rs=nothing
		%>
		<div style="clear: both;"></div><div class="tf jz">
		<input type="submit" value="提交" name="b1"></div>
	</div>
	</form>

<%
end sub

sub updateusergrade
server.scripttimeout=99999999
dim gradenum,gradename,gradepic,userminpostnum,classid,i
for i=1 to request.form("gradenum").count
	gradenum=replace(request.form("gradenum")(i),"'","")
	gradename=replace(request.form("gradename")(i),"'","")
	gradenum=replace(request.form("gradenum")(i),"'","")
	gradepic=replace(request.form("gradepic")(i),"'","")
	userminpostnum=replace(request.form("userminpostnum")(i),"'","")
	classid=replace(request.form("classid")(i),"'","")
	if isnumeric(gradenum) and gradename<>"" and gradepic<>"" and isnumeric(userminpostnum) and isnumeric(classid) and isnumeric(gradenum)then
		dim rs
		set rs=conn.execute("select gradenum,classid from yx_user where gradenum="&gradenum)
		if not rs.eof then
			if rs("classid")<>cint(classid) then
				conn.execute("update yx_user set gradenum=" & gradenum & ",classid="&classid&" where gradename='"& rs("gradename") &"'")
			end if
		end if
		set rs=nothing
		conn.execute("update yx_usergrade set gradename='"&gradename &"',gradenum="&gradenum&",gradepic='"&gradepic&"',userminpostnum="&userminpostnum&",classid="&classid&" where gradenum="&gradenum)
	end if
next
call suc("","用户等级设置成功！","?action=usergrade")
end sub

sub delusergrade
dim gradeid
gradeid=request("gradeid")
yxbbs.execute("delete * from [yx_usergrade] where gradeid="&gradeid&"")
call suc("","用户等级删除成功！建议您到更新用户数据中进行更新操作！","?action=usergrade")
end sub
%>

