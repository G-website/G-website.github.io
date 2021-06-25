<!--#include file="Inc/SysConfig.Asp"-->
<%
Dim UserName,NoShow
UserName=Request.QueryString("name")
If YxBBs.FoundUser Then
	If Trim(UserName)="" Then UserName=YxBBs.MyName
	If Lcase(UserName)<>lCase(YxBBs.MyName) Then If Cint(YxBBs.ClassSetting(0))=0 Then YxBBs.Error("您没有权限查看其他人资料！")
Else
	If Trim(UserName)="" Then YxBBs.Error("缺少用户参数！")
	If Cint(YxBBs.ClassSetting(0))=0 Then YxBBs.Error("您没有权限查看其他人资料！")
End If

If Not YxBBs.Fun.CheckName(UserName) then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
If Lcase(UserName)=lCase(YxBBs.MyName) Then
	
	Call YxBBs.Head("查看本人资料")
	
Else
	Call YxBBs.Head("查看『 "&UserName&" 』的资料")
End If
NoShow=YxBBs.NoShowTopic()
ShowUserInfo()
ShowUserBBS()
YxBBs.Footer()
Set YxBBs=Nothing



Sub ShowUserInfo()
	Dim Caption,Content
	Dim Rs,Grade,UserPic,UserSex,RegIP,LastIP,rs1
	SET Rs=YxBBs.Execute("Select Name,Sex,Birthday,Mail,Home,TimeSum,IsQQpic,QQ,Pic,Pich,Picw,RegIp,Gradenum,LastIp,EssayNum,GoodNum,Mark,Coin,BankSave,RegTime,LastTime,IsShow,LoginNum,Honor,Sign From[YX_user]where Name='"&UserName&"'")
	If Rs.eof then YxBBs.Error("该用户不存在或者已经被删除！")
	SET Rs1=YxBBs.Execute("Select GradeName,GradePic From [YX_UserGrade] where GradeNum="&Rs("Gradenum")&"")
	If Rs("IsQQpic") Then
		UserPic="<img src='http://qqshow-user.tencent.com/"&Rs("QQ")&"/10/00/'>"
	Else
		UserPic="<img src="&YxBBs.Fun.GetSqlStr(Rs("pic"))&" width="&Rs("picw")&" height="&Rs("pich")&" >"
	End If
	IF Rs("Sex") Then UserSex="帅哥" Else UserSex="美女"
	IF YxBBs.ClassID<=2 or Lcase(YxBBs.MyName)=Lcase(UserName) Then
		RegIP=YxBBs.Fun.GetSqlStr(Rs("RegIp"))
		LastIP=YxBBs.Fun.GetSqlStr(Rs("LastIp"))
	Else 
		RegIP=YxBBs.Fun.GetIp(Rs("RegIp"),2)
		LastIP=YxBBs.Fun.GetIp(Rs("LastIp"),2)
	End If
	Caption="用户信息"
	Content="<table border=0 cellpadding=8 cellspacing=0 style='border-collapse: collapse' width='100%'><tr>"&_
	"<td width='70%'>"&_
	"<table width='100%'  border='0' cellspacing='0' cellpadding='0'>"&_
	"<tr><td height='190'><table border='0' width='100%'><tr><td>登陆次数：　</td><td>"&Rs("LoginNum")&"　</td></tr>"&_
	"<tr><td>注册时IP：　</td><td>"&RegIP&"　</td></tr>"&_
	"<tr><td>最后访问IP：　</td><td>"&LastIP&"　</td></tr>"&_
    "<tr><td>注册时间：　</td><td>"&Rs("RegTime")&"　</td></tr>"&_
    "<tr><td>最后访问：　</td><td>"&Rs("LastTime")&"　</td></tr>"&_
    "<tr><td>在线时长：　</td><td><b>"&YxBBs.Fun.DateToSting(Rs("TimeSum"))&"</b>　</td></tr>"&_
	"<tr><td colspan='2'><hr noshade align='left' size='0' width='80%' class=a2></td></tr>"&_
	"<tr><td>发帖总数：　</td><td>"&Rs("EssayNum")&"　</td></tr>"&_
    "<tr><td>精华帖数：　</td><td>"&Rs("GoodNum")&"　</td></tr>"&_
    "<tr><td>用户金钱：　</td><td>"&Rs("Coin")&"　</td></tr>"&_
    "<tr><td>用户存款：　</td><td>"&Rs("BankSave")&"　</td></tr>"&_
    "<tr><td>用户"&YxBBs.BBSSetting(23)&"：　</td><td>"&Rs("Mark")&"　</td></tr>"&_
    "<tr><td colspan='2'><hr align='left' noshade size='0' width='80%'></td></tr>"&_
    "<tr><td>ＱＱ：　</td><td>"&YxBBs.Fun.GetSqlStr(Rs("QQ"))&"　</td></tr>"&_
    "<tr><td>网站：　</td><td><a href="&YxBBs.Fun.GetSqlStr(Rs("Home"))&">"&YxBBs.Fun.GetSqlStr(Rs("Home"))&"</a></td></tr>"&_
    "<tr><td>邮箱：　</td><td>"&YxBBs.Fun.GetSqlStr(Rs("Mail"))&"</td></tr>"&_
    "</table></td><td width='30%' valign=top>"&_
	"<table width='80%' border='1' style='border-collapse: collapse' cellpadding='2' cellspacing='5' ><tr><td colspan='2'><b><font color=blue>"&UserName&"</font></b>　</td></tr><tr>"&_
	"<td align='center' colspan='2'>"&UserPIc&"</td></tr><tr><td>性别：　</td><td>"&UserSex&"　</td></tr>"&_
	"<tr><td>生日：　</td><td>"&Rs("Birthday")&"　</td></tr><tr><td>头街：　</td><td>"&YxBBs.Fun.GetSqlStr(Rs("Honor"))&"　</td></tr>"&_
	"<tr><td>等级：　</td><td><img src='"&Rs1(1)&"' alt="&Rs1(0)&" vAlign=middle></td></tr><td align='center' colspan='2'><a href='Sms.Asp?Action=write&Name="&UserName&"'>[发短消息]</a></td></tr></table></td></tr></table></td></tr></table>"
	Rs.Close
	Call YxBBs.ShowTable(Caption,Content)
End Sub 

Sub ShowUserBBS()
	Dim Rs,I,SysInfo,ReplyInfo
	Set Rs=YxBBs.Execute("select Face,BoardID,Caption,AddTime,TopicID,Name,SqlTableID from  [YX_Topic] where name='"&UserName&"' And IsDel=False order by AddTime desc")
	 Do While not Rs.Eof
		If InStr(","&NoShow&",",","&Rs("BoardID")&",")=0 or (Lcase(UserName)=Lcase(YxBBs.MyName) or YxBBs.ClassID=1) Then
			i=i+1
			SysInfo=SysInfo& "<tr height='24'><td width='65%'>&nbsp;<img src='Images/bullet.gif' align='absmiddle'><a href=Show.Asp?ID="&Rs("TopicID")&">"&YxBBs.Fun.StrLeft(Rs("Caption"),50)&"</a></td><td width='15%'>"&Rs("name")&"<td width='20%'> "&Rs("AddTime")&"</td></tr>"
		End If
		IF i=5 Then Exit Do
		Rs.MoveNext
	 Loop
	Rs.Close
	SysInfo="<table align='center' width='100%' border='0' cellpadding='0' cellspacing='3'><tr><td height='25' colspan=3 align='left' bgcolor='#E8E8E8'>&nbsp;<b>+=最近发表=+</b></td></tr>"&SysInfo&"</table>"
	i=0
	Set Rs=YxBBs.Execute("select Face,BoardID,Caption,LastTime,TopicID,Name,SqlTableID from [YX_Topic] where Name<>'"&UserName&"' And IsDel=False and TopicID in (Select ReplyTopicID from [YX_Bbs"&YxBBs.TB&"] where name='"&UserName&"') order by LastTime desc")
	 Do While not Rs.Eof
		If InStr(","&NoShow&",",","&Rs("BoardID")&",")=0 or (Lcase(UserName)=Lcase(YxBBs.MyName) or YxBBs.ClassID=1) Then
			i=i+1
			ReplyInfo=ReplyInfo& "<tr height='24'><td width='65%'><img src='Images/bullet.gif' align='absmiddle'><a href=Show.Asp?ID="&Rs("TopicID")&">"&YxBBs.Fun.StrLeft(Rs("Caption"),50)&"</a></td><td width='15%'>"&Rs("name")&"<td width='20%'> "&Rs("LastTime")&"</td></tr>"
		End If
		IF i=5 Then Exit Do
		Rs.MoveNext
	 Loop
	Rs.Close
	ReplyInfo="<table align='center' width='100%' border='0' cellpadding='0' cellspacing='3'><tr><td height='25'   align='left' bgcolor='#E8E8E8' colspan=3>&nbsp;<b>+=最近回复=+</b></td></tr>"&ReplyInfo&"</table>"
	Call YxBBs.ShowTable(UserName&" 帖子信息",SysInfo&ReplyInfo)
End Sub
%>