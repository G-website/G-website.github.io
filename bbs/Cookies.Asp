<!--#include file="Inc/SysConfig.Asp"-->
<%
Dim Action,Url
Response.Buffer=True
Url=Request.ServerVariables("HTTP_REFERER")
Action=Lcase(Request.QueryString("Action"))

Select Case action
Case"style"
	Style()
Case"online"
	MyOnline
End Select
Set YxBBs=Nothing
If isnull(Url) or Url="" Then Url="Default.Asp"
If InStr(Url,"cookies") Then Url="Default.Asp"
Response.Redirect Url


Sub Style()
	Response.Cookies(YxBBs.CookiesName&"SkinID").Expires= Date+7
	If Not Isnumeric(Request("SkinID")) Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
	Response.Cookies(YxBBs.CookiesName&"SkinID")=Request("SkinID")
End Sub

Sub MyOnline
	If YxBBs.MyHidden="" or YxBBs.Myhidden="2" Then
		Response.Cookies(YxBBs.CookiesName)("MyHidden")=1
	ElseIf YxBBs.MyHidden="1" Then
		Response.Cookies(YxBBs.CookiesName)("MyHidden")=2
	End If
	Session(YxBBs.CacheName & "Stats")="YxBBs"
End Sub

%>