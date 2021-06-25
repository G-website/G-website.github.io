 <!--#include file="Inc/SysConfig.Asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<%
Const int_rate=0.0005	'银行利率
Dim Coin,mark
If Not YxBBs.Founduser Then YxBBs.Error("您还没有注册或者登陆！")

Coin=YxBBs.Fun.GetStr("Coin")
mark=YxBBs.Fun.GetStr("mark")
If Coin<>"" Then If Not YxBBs.Fun.isInteger(Coin) then Call Alert("请输入正确的金额！")
Select Case Request.QueryString("Action")
Case "Save"
	Save
Case "Draw"
	Draw
Case "Virement"
	Virement
Case"Convert"
	Convert
Case "Zhanhuan"
	Zhanhuan
Case "Zhanhuan1"
	Zhanhuan1
Case Else
	Main
End Select
YxBBs.Footer()
Set YxBBs=Nothing

Function GetInterest()
	Dim Interest,Rs
	IF Session(YxBBs.CacheName & "Bank")="" Then
		Set Rs=YxBBs.Execute("select Coin,BankSave,Banktime from [YX_user] where Name='"&YxBBs.MyName&"' and password='"&YxBBs.MyPwd&"'")
		If Rs.Eof Then YxBBs.Error("您操作的参数错误！")
		If Day(Rs(2))<>Day(YxBBs.NowBbsTime) then
			Interest=ccur(ccur(rs(1))*int(Datediff("d",cdate(rs("banktime")),cdate(YxBBs.NowBbsTime)))*int_rate)
			YxBBs.Execute("Update [YX_user] Set BankSave=BankSave+"&Interest&",BankTime='"&YxBBs.NowBbsTime&"' where Name='"&YxBBs.MyName&"' ")
			'更新缓存
			Session(YxBBs.CacheName & "MyInfo") = Empty
			YxBBs.UserLoginTrue
		Else
			Interest=0
		End If
		Rs.Close
		Session(YxBBs.CacheName & "Bank")=Interest
		GetInterest=Interest
	Else
		GetInterest=Session(YxBBs.CacheName & "Bank")
	End IF
End Function


Sub Main
	Call YxBBs.Head("论坛银行")
	Dim Interest,Content
	Interest=GetInterest()
	Content="<table border=0 cellpadding=4 cellspacing=0 style='border-collapse: collapse' width='100%'><tr><td width='46%' align='center'><img src=images/bank.gif width=249 height=107></td><td>"&_
	"<table align='center' width='97%' border='0' cellpadding='0' cellspacing='5' bgcolor='#FFFFFF' style='border-right: #BCBCBC 2px solid; border-bottom: #BCBCBC 2px solid;border-top: #e8e8e8 1px solid; border-left: #e8e8e8 1px solid;'>"&_
	"<tr><td height='25' bgcolor='#E8E8E8' colspan=2>财务状况&nbsp;[存款利率:<font color=red>"&int_rate*1000&"</font>‰|&nbsp;"&YxBBs.BBSSetting(23)&"：金钱=1：<font color=red>100</font>]</td></tr>"&_
	"<tr><td width='15%'>&nbsp;银行户主：</td><td width='39%'><b>"&YxBBs.MyName&"</b></td></tr>"&_
	"<tr><td>&nbsp;存款(含利息)：</td><td><b><font color='red'>"&YxBBs.MyBankSave&"</font></b> 元</td></tr>"&_
	"<tr><td>&nbsp;今日结算利息：</td><td><b><font color='red'>"&Interest&"</font></b> 元</td></tr>"&_
	"<tr><td>&nbsp;持有现金：</td><td><b><font color='Red'>"&YxBBs.MyCoin&"</font></b> 元</td></tr>"&_
	"<tr><td>&nbsp;个人资金总共：</td><td><b><font color='red'>"&Ccur(YxBBs.MyBankSave)+Ccur(YxBBs.MyCoin)&"</font></b> 元</td></tr>"&_
	"</table></td></tr></table>"&_
	"<table width='100%' border='0' cellPadding='0' cellSpacing='0'><tr><td>"&_
	"<form action='?Action=Save' method='post'><table align='center' width='97%' border='0' cellpadding='0' cellspacing='5' bgcolor='#FFFFFF' style='border-right: #BCBCBC 2px solid; border-bottom: #BCBCBC 2px solid;border-top: #e8e8e8 1px solid; border-left: #e8e8e8 1px solid;'>"&_
	"<tr><td height='25' bgcolor='#E8E8E8'>存款柜台</td></tr>"&_
	"<tr><td>&nbsp;现金：<b><font color=red>"&YxBBs.MyCoin&"</font></b> 元</td></tr>"&_
	"<tr><td align='center'>存储：<input size='10' value='1000' name='Coin'>元&nbsp;&nbsp;<input type='submit'  value=' 存钱 '></td></tr></table></form>"&_
	"</td><td>"&_
	"<form action='?Action=Draw' method='post'><table align='center' width='97%' border='0' cellpadding='0' cellspacing='5' bgcolor='#FFFFFF' style='border-right: #BCBCBC 2px solid; border-bottom: #BCBCBC 2px solid;border-top: #e8e8e8 1px solid; border-left: #e8e8e8 1px solid;'>"&_
	"<tr><td height='25' bgcolor='#E8E8E8'>支取柜台</td></tr>"&_
	"<tr><td>&nbsp;存款：<b><font color=Red>"&YxBBs.MyBankSave&"</font></b> 元</td></tr>"&_
	"<tr><td align='center'>支取 <input size='10' value='1000' name='Coin'> 元&nbsp;&nbsp;<input type='submit'  value=' 支取 '></td></tr></table></form>"&_
	"</td><td>"&_
"<form action='?Action=Zhanhuan' method='post'><table align='center' width='97%' border='0' cellpadding='0' cellspacing='5' bgcolor='#FFFFFF' style='border-right: #BCBCBC 2px solid; border-bottom: #BCBCBC 2px solid;border-top: #e8e8e8 1px solid; border-left: #e8e8e8 1px solid;'>"&_
	"<tr><td height='25' bgcolor='#E8E8E8'>金钱换"&YxBBs.BBSSetting(23)&"</td></tr>"&_
	"<tr><td>&nbsp;现金：<b><font color=red>"&YxBBs.MyCoin&"</font></b> 元</td></tr>"&_
	"<tr><td align='center'>转换 <input size='10' value='100' name='Coin'> 元&nbsp;&nbsp;<input type='submit'  value=' 转换 '></td></tr></table></form>"&_
        "</td><td>"&_
"<form action='?Action=Zhanhuan1' method='post'><table align='center' width='97%' border='0' cellpadding='0' cellspacing='5' bgcolor='#FFFFFF' style='border-right: #BCBCBC 2px solid; border-bottom: #BCBCBC 2px solid;border-top: #e8e8e8 1px solid; border-left: #e8e8e8 1px solid;'>"&_
	"<tr><td height='25' bgcolor='#E8E8E8'>"&YxBBs.BBSSetting(23)&"换金钱</td></tr>"&_
	"<tr><td>&nbsp;"&YxBBs.BBSSetting(23)&"：<b><font color=red>"&YxBBs.Mymark&"</font></b> 个</td></tr>"&_
	"<tr><td align='center'>转换 <input size='10' value='10' name='mark'> 个&nbsp;&nbsp;<input type='submit'  value=' 转换 '></td></tr></table></form>"&_
	"</td><td>"&_
	"<form action='?Action=Virement' method='post'><table align='center' width='97%' border='0' cellpadding='0' cellspacing='5' bgcolor='#FFFFFF' style='border-right: #BCBCBC 2px solid; border-bottom: #BCBCBC 2px solid;border-top: #e8e8e8 1px solid; border-left: #e8e8e8 1px solid;'>"&_
	"<tr><td height='25' bgcolor='#E8E8E8'>转帐柜台</td></tr>"&_
	"<tr><td>&nbsp;把存款转帐给好友</td></tr>"&_
	"<tr><td align='center'><input size='5' value='1000' name='Coin'>元&nbsp;给<input size='5' name='ToUserName'>&nbsp<input type='submit' value=' 转帐 '></td></tr></table></form>"&_
	"</td></tr><tr><td colspan=4><br>&nbsp;&nbsp;1.目前银行的存款利率:.<font color=red>"&int_rate*1000&"</font>‰<br>&nbsp;&nbsp;2."&YxBBs.BBSSetting(23)&"与金钱交换的比率为<font color=red>1：100</font>，注意一次转换最少输入<font color=red>100</font><br><br></td></tr></table>"
	Call YxBBs.ShowTable("论坛银行",Content)
End Sub

Sub Save
	If Coin="" Then Call Alert("失败！请输入存款的金额！")
	If Int(Coin) > Int(YxBBs.MyCoin) Then Call Alert("失败！金额不足！")
	YxBBs.Execute("update [YX_user] Set BankSave=BankSave+"&Coin&",Coin=Coin-"&Coin&" where Name='"&YxBBs.MyName&"'")
	Session(YxBBs.CacheName & "MyInfo") = Empty
	Call Alert("恭喜！银行存款成功！")
End sub

Sub Zhanhuan
	If Coin="" or Int(Coin) <100  Then Call Alert("失败！未输入要转换的金额或金额小于100！")
	If Int(Coin) > Int(YxBBs.MyCoin) Then Call Alert("失败！金额不足！")
	YxBBs.Execute("update [YX_user] Set mark=mark+"&Coin&"/100,Coin=Coin-"&Coin&" where Name='"&YxBBs.MyName&"'")
	Session(YxBBs.CacheName & "MyInfo") = Empty
	Call Alert("恭喜！转换成功，本次操作增加"&Coin/100&""&YxBBs.BBSSetting(23)&"，减少了"&Coin&"金钱")
End sub

Sub Zhanhuan1
	If mark="" or Int(mark) <1  Then Call Alert("失败！未输入要转换的金额或金额小于1！")
	If Int(mark) > Int(YxBBs.Mymark) Then Call Alert("失败！金额不足！")
	YxBBs.Execute("update [YX_user] Set mark=mark-"&mark&",Coin=Coin+"&mark*100&" where Name='"&YxBBs.MyName&"'")
	Session(YxBBs.CacheName & "MyInfo") = Empty
	Call Alert("恭喜！转换成功，本次操作增加"&mark*100&"金钱，减少了"&mark&""&YxBBs.BBSSetting(23)&"")
End sub

Sub Draw
	If Coin="" Then Call Alert("失败！请输入取款的金额！")
	If int(Coin) > Int(YxBBs.MyBankSave) Then Call Alert("失败！金额不足！")
	YxBBs.Execute("update [YX_user] Set BankSave=BankSave-"&Coin&",Coin=Coin+"&Coin&" where Name='"&YxBBs.MyName&"'")
	Session(YxBBs.CacheName & "MyInfo") = Empty
	Call Alert("恭喜！银行取款成功！")
End Sub

Sub Virement
	Dim ToUserName,Sms,TmpUbbString
	ToUserName=LCase(YxBBs.Fun.GetStr("ToUserName"))
	IF Not YxBBs.Fun.CheckIn(ToUserName) Or ToUserName="" Then Call Alert("失败！查无此人！")
	If Int(Coin) > Int(YxBBs.MyBankSave) then call Alert("失败！金额不足！")
	If ToUserName=LCase(YxBBs.MyName) Then Call Alert("失败！不能给自己转帐！")
	IF YxBBs.Execute("Select Name From[YX_user] where Name='"&ToUserName&"'").Eof Then
 	  Call Alert("失败！查无此人！")
	End if
	YxBBs.Execute("Update [YX_user] Set BankSave=BankSave-"&Coin&" where LCase(Name)='"&LCase(YxBBs.MyName)&"'")
	Sms=""&YxBBs.MyName&"通过转帐中心转给您"&Coin&"元现金！您可以到社区银行柜台查收！"&vbcrlf&"<font color=#FF0000>「社区银行」系统消息</font>"
	TmpUbbString=YxBBs.Fun.UbbString(Sms)
	YxBBs.Execute("Update [YX_user] Set BankSave=BankSave+"&Coin&",NewSmsNum=NewSmsNum+1,SmsSize=SmsSize+"&Len(Sms)&" where Name='"&ToUserName&"'")
	YxBBs.execute("insert Into [YX_Sms](Name,Title,Content,MyName,ubbString)VALUES('系统消息','来自银行的系统信息','"&Sms&"','"&ToUserName&"','"&TmpUbbString&"')")
	Session(YxBBs.CacheName & "MyInfo") = Empty
	Call Alert("恭喜！转帐成功,系统已自动发信通知了您的朋友！")
End sub

Sub Alert(message)
	message = replace(message,"'","\'")
	Response.Write ("<script LANGUAGE='javascript'>alert('" & message & "');window.location.href='Bank.Asp';</script>")
	Response.End
End Sub
%>