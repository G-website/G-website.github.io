<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/Page_Cls.Asp"-->
<!--#include file="inc/ubb_Cls.Asp"-->
<%
Dim Action,ID,YxBBs_Ubb
If Not YxBBs.FoundUser Then YxBBs.Error("您还没有注册或者登陆！")
Call YxBBs.Head("论坛短信")

ID=YxBBs.CheckNum(Request.QueryString("ID"))
Action=Lcase(Request.QueryString("Action"))
Select Case Action
Case"save"
	SaveSms
Case"del"
	Dim ThisSize
	ThisSize=Len(YxBBs.execute("Select Content From [YX_Sms] where ID="&ID&" and MyName='"&YxBBs.MyName&"'")(0))
	If Not YxBBs.Execute("Select ID From [YX_Sms] where ID="&ID&" and IsNew and MyName='"&YxBBs.MyName&"'").Eof Then
		YxBBs.ExeCute("Update [YX_User] Set NewSmsNum=NewSmsNum-1 Where Name='"&YxBBs.MyName&"'")
	End If
	YxBBs.Execute("Delete From [YX_sms] where ID="&ID&" and MyName='"&YxBBs.MyName&"'")
	YxBBs.Execute("Update [YX_User] set SmsSize=SmsSize-"&ThisSize&" where Name='"&YxBBs.MyName&"'")
	Response.redirect ("Sms.Asp")
Case"delall"
	'Temp=YxBBs.Execute("select count(ID) From[YX_Sms] where MyName='"&MyName&"'")(0)
	YxBBs.Execute("Delete From[YX_sms] where MyName='"&YxBBs.MyName&"'")
	YxBBs.Execute("Update [YX_User] set SmsSize=0 where Name='"&YxBBs.MyName&"'")
	YxBBs.ExeCute("Update [YX_User] Set NewSmsNum=0 Where Name='"&YxBBs.MyName&"'")
	Session(YxBBs.CacheName & "MyInfo") = Empty
	Response.redirect ("Sms.Asp")
Case"write"
	WriteSms
Case"readsms"
	Set YxBBs_ubb=New YxBBsubb_Cls
	ReadSms
	Set YxBBs_ubb=Nothing
Case Else
	Call SmsList()
End Select
YxBBs.Footer()
Set YxBBs=Nothing

Sub ShowMySmsInfo()
	Dim Content,AllSmsSize
	AllSmsSize=(Int(YxBBs.MySmsSize)/(YxBBs.ClassSetting(13)*1000))*100
	If int(YxBBs.MySmsSize)>YxBBs.ClassSetting(13) Then Response.Write("<script language=javascript>alert('\n您的短信空间已经超过了系统限制！\n\n请尽快清理您的无用消息！\n');</script>")
	Content="<table border=0 height=40><tr><td width='35%'>&nbsp;<a href='Sms.Asp'><img src='Images/sms.gif' width='16' height='16' border='0'> 收取留言</a>&nbsp;<a href='?Action=Write'><img border='0' src='Images/edit.gif'> 写新留言</a>&nbsp;<a onclick=checkclick('按确定将删除所有接收短信！！\n\n您确定要删除吗？') href='Sms.Asp?Action=DelAll'><img src='Images/Del.gif' width='18' height='18' border='0' align='absmiddle'> 清空短信</a></td><td width='13%' align='right'>信箱容量：</td><td width='12%'><table width='250' height='10' border='1' cellpadding='0' cellspacing='0' style='TABLE-LAYOUT: fixed; WORD-BREAK: break-all;border-collapse:collapse' bordercolor='#FFCC00' bgcolor='#CCFF00'><tr><td width='250'><img src='Images/hr.gif' width='"&int(YxBBs.MySmsSize)/YxBBs.ClassSetting(13)*250/1000&"' height='10'></td></tr></table></td><td width='13%'>已使用 <font color=red>"&Int(AllSmsSize)&" </font>%</td><tr></table>"
	Call YxBBs.ShowTable("论坛留言信箱",Content)
End Sub

Sub SmsList()
	Dim Temp,Content,CanWrite,UserPic,Rs,Pages,strPageInfo,intPageNow,Arr_Rs,I,Caption
	intPageNow = Request.QueryString("page")
	Set Pages = New Cls_PageView
	Pages.strTableName = "[YX_Sms]"
	Pages.strFieldsList = "ID,name,Title,Addtime,IsNew"
	Pages.strCondiction = "MyName='"&YxBBs.MyName&"'"
	Pages.strOrderList = "ID desc"
	Pages.strPrimaryKey = "ID"
	Pages.intPageSize = 10
	Pages.intPageNow = intPageNow
	Pages.strCookiesName = "Sms"&YxBBs.MyName'客户端记录总数
	Pages.Reloadtime=3'每三分钟更新Cookies
	Pages.strPageVar = "page"
	Pages.InitClass
	Arr_Rs = Pages.arrRecordInfo
	strPageInfo = Pages.strPageInfo
	Set Pages = nothing
	If IsArray(Arr_Rs) Then
Content=Content&"<tr><td width='50' align='center'>状态</td><td width='10%'>发件人</td><td width='50%'>短信标题</td><td> 发送时间 </td><td>操作</td></tr>"
		For i = 0 to UBound(Arr_Rs,2)
			Temp="<tr><td width='50' align='center'>"
			IF Arr_Rs(4,I) Then
				Temp=Temp&"<b><font color=red>未读</font></b>"
			Else
				Temp=Temp&"<b><font color=#NaNNaNNaN>已读</font></b>"
			End If
			Temp=Temp&"</td><td width='10%'><b>"
			If Arr_Rs(1,I)="系统消息" Then
				Temp=Temp&Arr_Rs(1,I)
			Else
				Temp=Temp&"<a href=""Profile.Asp?name="&Arr_Rs(1,I)&""">"&Arr_Rs(1,I)&"</a>"
			End If
			Temp=Temp&"</b></td><td width='50%'><a href=""Sms.Asp?Action=ReadSms&ID="&Arr_Rs(0,I)&""">"&Arr_Rs(2,I)&"</a>"
			Temp=Temp&"</td><td> <img src='Images/edit.gif' border='0'> "&Arr_Rs(3,I)&"</td><td><a onclick=checkclick('按确定将删除这条留言！！\n\n您确定要删除吗？') href='?id="&Arr_Rs(0,I)&"&Action=Del'><img border='0' alt='删除' src='Images/Del.gif'></a></td></tr>"
			Content=Content&Temp
		Next
	End If
		
		Content=Content&"<tr><td colspan='5' height=25>"&strPageInfo&"</td></tr>"
	Caption="收取留言"
	ShowMySmsInfo()
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Sub ReadSms()
	Dim Rs,Caption,Content
	Set Rs=YxBBs.Execute("Select Top 1 ID,name,Title,Content,Addtime,IsNew,UbbString from [YX_sms] where MyName='"&YxBBs.MyName&"' and Id="&ID&"")
	if not Rs.eof then
		YxBBs_ubb.UbbString=Rs(6)
		Caption="阅读短信"
		Content="<tr><td><br>短信标题："&YxBBs.Fun.HtmlCode(Rs(2))&"<br><br>短信作者："
			If Rs(1)="系统消息" Then
				Content=Content&Rs(1)
			Else
				Content=Content&"<a href=""Profile.Asp?name="&Rs(1)&""">"&Rs(1)&"</a>"
			End If
		Content=Content&"<br><br><fieldset><legend>消息内容</legend><br>"&YxBBs_Ubb.UBB(Rs(3),2)&"<br><br></fieldset><br><img src='Images/edit.gif' border='0'> "&Rs(4)&" <a href=""Sms.Asp?Action=Write&ID="&Rs(0)&"&Name="&Rs(1)&"&title=Re:"&Rs(2)&""">【回复】</a><a onclick=""checkclick('按确定将删除这条留言！！\n\n您确定要删除吗？')"" href=""Sms.Asp?Action=Del&ID="&Rs(0)&""">【删除】</a><br></td></tr>"
  		If Rs(5) Then
			YxBBs.ExeCute("Update [YX_User] Set NewSmsNum=NewSmsNum-1 Where Name='"&YxBBs.MyName&"'")
			YxBBs.Execute("Update [YX_Sms] Set IsNew=False where MyName='"&YxBBs.MyName&"' and ID="&ID&"")
		End If
	Else
		Caption="阅读短信"
		Content="<tr><td><br>没有找到消息<br></td></tr>"
	End If
	Rs.Close
	ShowMySmsInfo()
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Sub WriteSms()
	Dim Name,title,Rs,Caption,Content,Temp
	If Cint(YxBBs.ClassSetting(10))=0 Then YxBBs.Error("您没有发送论坛消息的权限！")
	Name=Request.QueryString("Name")
	title=Request.QueryString("title")
	If Not YxBBs.Fun.CheckName(Name) Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
	Set Rs=YxBBs.execute("select Content from [YX_sms] where name='"&Name&"' and Id="&ID&"")
	if not Rs.eof then 
	Temp=Rs("Content")
	Temp=vbcrlf & vbcrlf& vbcrlf &"============在 "&Name&" 的来信中提到=========="& vbcrlf&YxBBs.Fun.StrLeft(Temp,250)&""
	End if
	Rs.Close
	ShowMySmsInfo()
	Caption="发送留言"
	Content="</tr><tr><td><form method=POST name=yimxu action='?Action=Save'><p style='margin: 10'>留言对象：<input type=text name='name' size=20 value='"&Name&"'><p style='margin: 10'>消息标题：<input type=text name='title' size=40 value='"&title&"'><p style='margin: 10'><textarea onkeydown=presskey(); rows=9 name='content' cols=90>"&Temp&"</textarea><p style='margin: 10'><input type='submit' value=' 发 送 '> <input type='reset' value=' 重 置 '></form>"
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Sub SaveSms()
	Dim Temp,i,Title,Content,Caption,ToName,TmpUbbString
	YxBBs.Fun.CheckMake()
	ToName=YxBBs.Fun.GetStr("Name")
	Title=YxBBs.Fun.HtmlCode(YxBBs.Fun.GetStr("Title"))
	Content=YxBBs.Fun.htmlcode(YxBBs.Fun.GetStr("Content"))
	If ToName="" or Title="" or Content="" then YxBBs.Error("请填写完整的必填项目！")
        If Lcase(ToName)=Lcase(YxBBs.MyName) Then YxBBs.Error("您不能给自己发送信息！")
        If yxbbs.execute("select Name From [yx_User] where name='"&ToName&"'").eof Then YxBBs.Error("用户 "&ToName&" 不存在！")
	TmpUbbString=YxBBs.Fun.UbbString(Content)
	ToName=Split(ToName,",")
	IF Len(Content)>1000 Then YxBBs.Error("短信内容超过大小限制！")
        IF int(YxBBs.MyCoin)<int(YxBBs.BBSSetting(3)) Then YxBBs.Error("您的金钱数小于"&YxBBs.BBSSetting(3)&",不能发送留言！")
	If Ubound(ToName)>Cint(YxBBs.ClassSetting(11)) Then YxBBs.Error("您最多发送用户不得超过 <font color=Red>"&YxBBs.ClassSetting(11)&"</font> ！")
	For i=0 To Ubound(ToName)
		If Not YxBBs.Fun.CheckName(ToName(i)) Then YxBBs.Error("用户 "&ToName(i)&" 不存在！")
		YxBBs.execute("Insert into [YX_sms](name,Title,Content,Myname,ubbString)values('"&YxBBs.MyName&"','"&Title&"','"&Content&"','"&ToName(i)&"','"&TmpUbbString&"')")
		YxBBs.ExeCute("Update [YX_user] Set NewSmsNum=NewSmsNum+1,SmsSize=SmsSize+"&Len(Content)&" Where Name='"&ToName(i)&"'")
                YxBBs.ExeCute("Update [YX_user] Set coin=coin-"&int(YxBBs.BBSSetting(3))&" Where Name='"&YxBBs.MyName&"'")
	Next
	Caption="发送成功"
	Content="<Div style='margin:15;line-height: 150%'><b>操作成功：</b><ul><li>此次发送扣除信息费 <font color=red><b>"&YxBBs.BBSSetting(3)&"</b></font> 元</li><li><a href=Default.Asp>返回首页</a></li><li><a href=Sms.Asp>返回我的信箱</a></li></ul></Div>"
	Call YxBBs.ShowTable(Caption,Content)
End Sub
%>