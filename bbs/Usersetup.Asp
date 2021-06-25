<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/md5.Asp"-->
<%
Dim Action
Action=Lcase(Request.QueryString("Action"))
Select Case Action
Case"myinfo"
	MyInfo()
	%>
	<script>
	function ShowPic(){
	document.images.Pic.src=document.form.headpic.options[document.form.headpic.selectedIndex].value;
	document.form.PicUrl.value=document.form.headpic.options[document.form.headpic.selectedIndex].value;
	}
	function QQpic(){
	if (document.form.IsQQpic.checked == true){
		pic.style.display="none";
		pic1.style.display="none";
		}else{
		pic.style.display="block";
		pic1.style.display="block";
		}}
	QQpic()
	first("selectp","selectc","form",0,0);
	</script>
	<%
Case"savemyinfo"
	SaveMyInfo
Case"mypassword"
	MyPassword
Case"savemypassword"
	SaveMyPassword
Case"forgetpassword"
	forgetpassword
Case"getpassword"
	GetPassword
Case else
	YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
End Select
YxBBs.Footer()
Set YxBBs=Nothing


Sub Myinfo()
	Dim Rs,Caption,Content,temp,i
	Call YxBBs.Head("修改个人资料")
	If Not YxBBs.FoundUser Then YxBBs.Error("您还没有注册或者登陆！")
	Set Rs=YxBBs.Execute("Select Name,Sex,Birthday,Mail,Home,IsQQpic,QQ,Pic,Pich,Picw,IsSign,Sign,Honor,GradeNum From [YX_user]where Name='"&YxBBs.MyName&"' And PassWord='"&YxBBs.MyPwd&"' And ID="&YxBBs.MyID&"")
	IF Rs.eof Then YxBBs.MakeCookiesEmpty():YxBBs.Error("您没有进行这个操作的权限！")
	Content="<FORM name=form style='margin:0' method='POST' action='?action=SaveMyInfo'>"&_
	"<br><table align='center' width='100%' border='0' rules=rows frame=void cellpadding='0' cellspacing='5' bgcolor='#FFFFFF'>"&_
	
	"<tr><td width='35%'><b>用户名称</b>：<br>此为论坛ID帐号，自己不能修改</td><td width='65%'><b>"&Rs("Name")&"</b></td></tr>"
	If Int(Rs("GradeNum"))<Int(YxBBs.BBSSetting(25)) then
		 Temp="您的等级未达到 <B><font Color=red>"&YxBBs.BBSSetting(25)&"级</font></B> 不能自定头衔称号<input type='hidden' value='"&Rs("Honor")&"' name='Honor'>"
	Else
		 Temp="<input type='text' value='"&Rs("Honor")&"' name='Honor'>"
	End If
	Content=Content & "<tr><td><B>自定义街称号</B>：<BR>最多6个汉字</td><td>"&Temp&"</td></tr>"&_
	"<tr><td><b>您的性别：</b></td><td><input name='sex' type='radio' value='1'"
	If Rs("Sex") Then Content=Content & " checked"
	Content=Content & "><img src='Images/11.gif' align='absmiddle'></img> 帅哥&nbsp;&nbsp;<input type='radio' name='sex' value='0'"
	If Not Rs("Sex") Then Content=Content & " checked"
	Content=Content & "><img src='Images/01.gif' align='absmiddle'> 靓女</td></tr>"&_
	"<tr><td><b>Email地址</b>：<br>请输入有效的邮件地址</td><td><input type='text' name='Mail' size='30' maxlength='30' value='"&Rs("Mail")&"'></td></tr>"&_
	"<tr><td width='35%'><b>生日：</b><br>请按照1986-08-16格式填写</td><td width='65%'><input Type=text name='Birthday' value='"&Rs("Birthday")&"'></td></tr>"&_
	"<tr><td><b>主页：</b><br>填写你的个人主页，让大家见识见识！</td><td><input type=text name='Home' size='30' maxlength='200' value='"&Rs("Home")&"'></td></tr>"&_
	"<tr><td><B>QQ号码</B>：<BR>填写您的QQ地址，方便与他人的联系</td><td><input type='text' name='QQ' value='"&Rs("QQ")&"' maxlength='15'> <input type='checkbox' onclick='QQpic()' name='IsQQpic' value='1'"
	If Rs("IsQQPic") Then
		Content=Content & " checked"
	End If
	Content=Content & ">启用QQ形象作为头像</td></tr>"&_
	"<tr id=pic><td valign='top'><b>我的头像：</b><br>使用论坛自带的图像</td><td>"
	Content=Content & "<select name=headpic size=8 onChange='ShowPic()'><option value='"&Rs("Pic")&"' selected>默认头像</option>"
	for i=1 to Int(YxBBs.BBSSetting(14))
		Content=Content & "<option value=Images/UserHead/"&i&".gif>"&i&"</option>"
	Next
	Content=Content & "</select>"
	Content=Content & "<img src='"&Rs("Pic")&"' name='Pic'>&nbsp;&nbsp;<input onclick=javascript:window.open('See.Asp?Action=HeadPic','open','width=600,height=300,resizable=1,scrollbars=yes,menubar=no,status=yes') type=button value='全部头像'></td></tr>"&_
	"<tr id=pic1><td><B>自定义头像</B>：<br> 如果图像位置中有连接图片将以自定义的为主</td><td>"
	If YxBBs.BBSSetting(18)=0 then
        If Int(Rs("GradeNum"))>Int(YxBBs.BBSSetting(35)) then
		Content=Content & "<input type=button value='上传头像图片' onclick=""javascript:up.style.display='block';upf.location.href='ViewFile.Asp?Action=Upload&Flag=1';this.style.display='none'""><div id='up' style='display:none'><iframe id='upf' scrolling='no' frameborder='0' height='22' width='100%'></iframe></div><br>"
        Else
               Content=Content & "您的等级未达到 <B><font Color=red>"&YxBBs.BBSSetting(35)&"级</font></B> 不能上传头像图片<br>"
	End if
End if
	Content=Content & "<input name='PicUrl' value='"&Rs("Pic")&"' size='40' maxlength='100'> 完整Url地址<br>图像宽度：<input type=text name='PicW' size='6' value='"&Rs("PicW")&"'> 高度：<input type=text name='PicH' size='6' value='"&Rs("PicH")&"'>(最大限度:"&YxBBs.BBSSetting(15)&")</td></tr>"&_
	"<tr><td valign='top'><B>个性签名</B>：<BR>最多255个字符<BR>此处支持UBB标签<a href=help.Asp?Action=ubb target='_blank'><font color=red>查看UBB帮助</font></a><br>文字将出现在您发表的文章的结尾处</td><td><TEXTAREA name='Sign' rows='4' style='PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px;WIDTH: 100%;'>"&Rs("Sign")&"</textarea></td></tr>"
Content=Content & "<tr><br><td colspan='2' height='30' ><input name=""submit"" type='submit' value='确定提交'></td></tr></table></form>"& vbCrLf
	Caption="修改我的资料"
	Call YxBBs.ShowTable(Caption,Content)
End Sub
	

Sub SaveMyInfo()
	Dim Caption,Content,Mail,PicUrl,HeadPic,PicW,PicH,Home,Sign,QQ,IsQQpic,Sex,Birthday,Honor
	If Not YxBBs.FoundUser Then YxBBs.Error("您还没有注册或者登陆！")
	YxBBs.Fun.CheckMake
	Call YxBBs.Head("修改个人资料")
	Mail=YxBBs.Fun.GetStr("Mail")
	If Mail="" Then YxBBs.Error("E-Mail地址不能为空！")	
	Mail=server.HTMLEncode(Mail)
	If Not YxBBs.Fun.IsValidEmail(Mail) Then YxBBs.Error("请填写有效的E-Mail地址！")
	PicUrl=YxBBs.Fun.ubbg(YxBBs.Fun.GetStr("PicUrl"))
	HeadPic=YxBBs.Fun.ubbg(YxBBs.Fun.GetStr("HeadPic"))
	Honor=YxBBs.Fun.GetStr("Honor")
	If Not YxBBs.Fun.CheckName(Honor) Then YxBBs.Error("自定义头衔包含非法字符！")
	Home=YxBBs.Fun.ubbg(YxBBs.Fun.GetStr("Home"))
	If Instr(Home,"://")=0 Then Home=""
	Sex=YxBBs.Checknum(Request("Sex"))
	Birthday=YxBBs.Fun.GetStr("Birthday")
	QQ=YxBBs.Fun.GetStr("QQ")
	IsQQpic=YxBBs.Fun.GetStr("IsQQpic")
	If IsQQpic<>"1" Then IsQQpic="0"
	Sign=Left(YxBBs.Fun.HtmlCode(YxBBs.Fun.GetStr("Sign")),255)
	PicH=YxBBs.Fun.GetStr("PicH")
	PicW=YxBBs.Fun.Getstr("PicW")
	If PicUrl="" then
		PicUrl="headpic/"& HeadPic &".gif"
		PicW= BBSSetting(16)
		PicH= BBSSetting(17)
	End If
	If (QQ<>"" And not isnumeric(QQ)) Or (IsQQpic="1" and QQ="") then YxBBs.Error("请填写有效的QQ号码！")
	If Len(Mail)>50 or Len(HeadPic)>220 or Len(QQ)>20 or Len(Home)>250 or Len("Honor")>12 Then YxBBs.Error("您填写的一些字符数超过了论坛的限制！")
	If Not isnumeric(PicW) or Not isnumeric(PicH) Then YxBBs.Error("头像宽度和高度必须用数字填写！")
	If Int(PicW)>int(YxBBs.BBSSetting(15)) or int(PicH)>int(YxBBs.BBSSetting(15)) then
		PicW=YxBBs.BBSSetting(16)
		PicH=YxBBs.BBSSetting(17)
	End If
	If Not isdate(Birthday) then Birthday=""
	
	
	YxBBs.execute("update [YX_User] set Birthday='"&Birthday&"',Sex="&Sex&",PicW="&PicW&",PicH="&PicH&",Mail='"&Mail&"',QQ='"&QQ&"',Honor='"&Honor&"',Pic='"&PicUrl&"',Home='"&Home&"',Sign='"&Sign&"',IsQQpic="&IsQQpic&" where name='"&YxBBs.MyName&"' And Password='"&YxBBs.MyPwd&"'")
	Caption="修 改 成 功"
	Content="<div style='margin:15;line-height: 150%'><li>资料修改成功！<li><a href=Profile.Asp>查看我的资料</a><li><a href=Default.Asp>返回首页</a></div>"
	Session(YxBBs.CacheName & "MyInfo") = Empty
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Sub MyPassword
	Dim Caption,Content
	If Not YxBBs.FoundUser Then YxBBs.Error("您还没有注册或者登陆！")
	Call YxBBs.Head("修改密码")
	Caption="修改密码"
	Content="<form style='margin:0' method='POST' action='?action=SaveMyPassword' name='form'>"&_
	"<br><table align='center' width='97%' border='0' cellpadding='0' cellspacing='5' rules=rows frame=void>"&_
	"<tr><td width='50%'><b>旧密码确认</b>：<br>请输入旧密码进入确认</td><td><input type='password' name='Password' size='30' maxlength='20'></td></tr><tr><td><b>新的密码(最多14位)</b>：<br>请不要使用任何类似 '*'、' ' 或 HTML 字符</td><td width='50%'><input type='password' name='NewPassword' size='30' maxlength='20'></td></tr><tr><td><b>重复密码</b>：<br>请再输一遍确认</td><td><input type='password' name='RePassword' size='30' maxlength='20'></td></tr>"&_
	"<tr><td><b>密码问题</b>：<br>忘记密码的提示问题</td><td><input type='text' name='Clue' size=30  maxlength='60'></td></tr>"&_
	"<tr><td><b>问题答案</b>：<br>忘记密码的提示问题答案，用于取回论坛密码</td><td><input type='text' name='Answer' size=30  maxlength='60'></td></tr>"&_
	"<tr><td colspan='2' height='30' align='center'><input type='submit' value=' 确 定 '>&nbsp;&nbsp; <input type=reset value=' 取 消 '></td></tr></table><br></form>"
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Sub SaveMyPassword
	Dim Rs,Sql,Password,NewPassword,RePassword,Clue,Answer,Caption,Content
	YxBBs.Fun.CheckMake'禁止外部提交
	Call YxBBs.Head("修改密码")
	Password=YxBBs.Fun.GetStr("Password")
	NewPassword=YxBBs.Fun.GetStr("NewPassword")
	RePassword=YxBBs.Fun.GetStr("RePassword")
	Clue=YxBBs.Fun.GetStr("Clue")
	Answer=YxBBs.Fun.GetStr("Answer")
	If Password="" or Repassword="" or NewPassword="" Then YxBBs.Error("请填写完整的必填项目！")	
	If Repassword<>NewPassword Then YxBBs.Error("确认新密码与新密码不一致！")
	If YxBBs.Fun.StrLength(NewPassword)>14 Then YxBBs.Error("密码长度不能超过14位！")
	If md5(Password)<>YxBBs.MyPwd Then YxBBs.Error("旧密码验证错误！")
	IF len(NewPassword)<4 Then YxBBs.Error("密码长度不能小于4个字符！")
	YxBBs.Execute("update [YX_User] set [password]='"&Md5(Newpassword)&"' where name='"&YxBBs.MyName&"'")	
	Response.Cookies(YxBBs.CookiesName)("MyPwd")=Md5(NewPassword)
	Caption=" 修 改 成 功"
	Content="<div style='margin:15;line-height: 150%'><li>你的密码修改成功!<li><a href=Profile.Asp>返回我的用户控制面版</a><li><a href=Default.Asp>返回首页</a></div>"
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Sub ForgetPassword
	Dim UserName,Caption,Content,rs
	Call YxBBs.Head("找回密码")
	Caption="找回密码"
	UserName=YxBBs.Fun.GetStr("UserName")
	If UserName="" Then
		Content="<form style='margin:0' method='POST'>"&_
		"<br><table align='center' width='97%' border='0' cellpadding='0' cellspacing='5' rules=rows frame=void>"&_
		"<tr><td width='50%'><b>您的用户名：</b><br><br>请输入注册的用户名称进入确认</td><td><input type='text' name='UserName' size='30' maxlength='20'></td></tr>"&_
		"<tr><td colspan='2' height='30' align='center'><br><input type='submit' value='确 定'> &nbsp;&nbsp; <input type=reset value='重 置'></td></tr></table><br></form>"
	Else
		YxBBs.Fun.CheckMake
		If Not YxBBs.Fun.CheckName(UserName) Then YxBBs.Error("用户名中包含非法字符！")
		If YxBBs.Execute("select name from [YX_User] where name='"&UserName&"'").Eof Then YxBBs.Error("用户名称不存在！")
		If Not YxBBs.execute("select name from [YX_User] where name='"&UserName&"' and ClassID<=3").Eof Then YxBBs.Error("版主等级以上用户找回密码请联系管理员！")
                set rs=YxBBs.Execute("select clue from [YX_User] where name='"&UserName&"'")
		Content="<form style='margin:0' method='POST' action='?Action=GetPassword'>"&_
		"<br><table align='center' width='97%' border='0' cellpadding='5' cellspacing='1' rules=rows frame=void>"&_
		"<tr><td width='50%'><b>用户名称：</b></td><td><input name='UserName' type='hidden' value='"&UserName&"'><b>"& UserName &"</b></td></tr><tr><td><b>提示问题：</b></td><td width='50%'>"&Rs("clue")&"</td></tr><tr><td><b>问题答案：</b><br>请输入您在注册时填写的问题答案</td><td><input type='text' name='Answer' size='30' maxlength='20'></td></tr>"&_
		"<tr><td colspan='2' height='30' align='center'><input type='submit' value='确 定'> &nbsp;&nbsp; <input type=reset value='重 置'></td></tr></table><br></form>"
	End If
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Sub GetPassword
	Dim UserName,Clue,Answer,Caption,NewPassword,Content
	YxBBs.Fun.CheckMake
	Call YxBBs.Head("找回密码")
	If YxBBs.GetCookiesInfo("Forge",0)>2 Then YxBBs.Error("您已经连续输入三次错误！不能再继续找回密码！请联系论坛管理员！")
	UserName=YxBBs.Fun.GetStr("UserName")
	Answer=YxBBs.Fun.GetStr("Answer")
	If UserName="" or Answer="" Then YxBBs.Error("请填写完整的必填项目！")
	If Not YxBBs.Fun.CheckName(UserName) Then YxBBs.Error("用户名中包含非法字符！")
	If YxBBs.execute("select name from [YX_User] where name='"&UserName&"'").Eof Then YxBBs.Error("用户名称不存在！")
	IF YxBBs.execute("select name from [YX_User] where name='"&UserName&"' And Answer='"&Md5(Answer)&"'").Eof  Then
		YxBBs.Error("<li>您的密码提示问题和问题答案不正确！<li>输入错误 <font color=red>"&YxBBs.UpdateCookiesInfo("Forge",1)&"</font> 次")
	Else
		Randomize
		NewPassword=int(90000*rnd)+10000
		YxBBs.execute("update [YX_user] set [password]='"&Md5(NewPassword)&"' where name='"&UserName&"'")
		YxBBs.execute("update [YX_admin] set [password]='"&Md5(NewPassword)&"' where name='"&UserName&"'")	
		Caption="成功通过验证"
		Content="<div style='margin:15;line-height: 150%'><li>您成功的通过密码保护的检验！<li>用户名称：<font color=red>"&UserName&"</font> &nbsp; 获得新密码：<font color=red>"&NewPassword&"</font><li>先记住新密码，请您马上登陆论坛，尽快修改密码！</div>"
		Call YxBBs.ShowTable(Caption,Content)
		
	End If	
End Sub
%>