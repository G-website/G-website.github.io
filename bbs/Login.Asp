<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="inc/md5.Asp"-->
<%Dim Action,Caption,Content,GCode
Call YxBBs.Head("论坛登陆")
Action=Lcase(Request.QueryString("action"))
Select Case Action
Case "exit"
	ExitLogin()
Case "login"
	CheckLogin()
Case Else
	Content=Replace(YxBBs.Template.ReadTemplate("用户登陆"),"</form>","<input type='hidden' name='url' value='"&Request.ServerVariables("HTTP_REFERER")&"'></form>")
        If Cint(YxBBs.BBSSetting(6))=0 Then 
         Content=Replace(Content,"{验证码}","<input  type=text name='CheckCode' size=8><img align='absmiddle' Src=Inc/code.Asp>")
       else
         Content=Replace(Content,"{验证码}","<input size=8 name=CheckCode maxlength=4 value=暂未启用 disabled><img align='absmiddle' Src=Inc/code.Asp>")
        end if
	Response.Write(Content)
End select
YxBBs.Footer()
Set YxBBs=Nothing

Sub CheckLogin()
	Dim Temp,TemUrl,Rs,UserName,Password,IsHidden,CookiesDate	
	If (Session(YxBBs.CacheName&"lgtime")+YxBBs.BBSSetting(29)/1440)>now() then YxBBs.Error("本站为了防止恶意尝试机器登陆，两次登陆间隔被设为<Font color=red>"&YxBBs.BBSSetting(29)&"</Font>分钟")
	TemUrl=Replace(Request.Form("url"),"'","''")
	if TemUrl="" then TemUrl=Request.ServerVariables("HTTP_REFERER")
	UserName=Lcase(YxBBs.Fun.GetStr("name"))
	Password=YxBBs.Fun.GetStr("password")
	IsHidden=YxBBs.Fun.GetStr("hidden")
	CookiesDate=YxBBs.CheckNum(Request.Form("cookies"))
	If UserName="" or Password=""  Then YxBBs.Error("用户名或密码不得为空！")
	if Not YxBBs.Fun.Checkname(UserName) then YxBBs.Error("此用户还没有注册！")
        IF Session("CheckCode")<>Request.form("CheckCode") And Cint(YxBBs.BBSSetting(6))=0 then YxBBs.Error("验证码错误！")
If Cint(YxBBs.BBSSetting(6))=1 then Session("CheckCode")=""
	Password=md5(Password)
	Set Rs = YxBBs.Execute("select top 1 Id,Name,EssayNum,ClassID From [YX_User] where Lcase(name)='"&UserName&"' and password='"&Password&"' and Isdel=true")
	If Rs.Eof then
		YxBBs.Error("您的用户名密码错误！<br><br><li>或暂未通过用户审核！")
	Else
		Dim UG:UserName=Rs(1)
		Set UG = YxBBs.Execute("Select Top 1 GradeNum,UserMinPostNum from YX_UserGrade Where ClassID="&Rs(3)&" And UserMinPostNum<="&Rs(2)&" Order By UserMinPostNum Desc")
		If Not UG.Eof Then
			YxBBs.Execute("Update [YX_User] Set GradeNum="&UG(0)&" Where ID="&Rs(0))
		End If
		UG.Close
		Set UG=nothing
		
		Response.Cookies(YxBBs.CookiesName)("MyID")=Rs(0)
		Response.Cookies(YxBBs.CookiesName)("MyName")=UserName
		Response.Cookies(YxBBs.CookiesName)("MyPwd")=Password
		Response.Cookies(YxBBs.CookiesName)("MyHidden")=IsHidden
		Response.Cookies(YxBBs.CookiesName)("CookiesDate")=CookiesDate
		If CookiesDate=1 then
			Response.Cookies(YxBBs.CookiesName).Expires=date+1
		Elseif CookiesDate=30 then
			Response.Cookies(YxBBs.CookiesName).Expires=date+30
		Elseif CookiesDate=365 then
			Response.Cookies(YxBBs.CookiesName).Expires=date+365
		End if
		YxBBs.Execute("update [YX_user] set loginnum=loginnum+1,LastTime='"&YxBBs.NowBbsTime&"',LastIp='"&YxBBs.MyIp&"' where name='"&UserName&"'")
		Dim MyID
		If instr(LCase(TemUrl),"register.asp")>0 or instr(LCase(TemUrl),"login.asp")>0 or instr(LCase(TemUrl),"default.asp")>0 or TemUrl="" then
			TemUrl=""
		Else
			TemUrl="<li><a href="&TemUrl&">"&YxBBs.Fun.HtmlCode(TemUrl)&"</a><br>"
		End if
		Session(YxBBs.CacheName&"lgtime")=Now()
		Cache.Name="UserOnline"
		Cache.Clean()
		Caption="登陆成功"
		Content="<meta http-equiv=refresh content=2;url=Default.Asp><div style='margin: 15;line-height: 150%'><li><b>3</b> 秒钟后将自动返回首页<li><a href='Default.Asp'>立即进入论坛首页</a>"&TemUrl&"</p>"
	End If
	Rs.Close
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Sub ExitLogin()
	YxBBs.MakeCookiesEmpty()
	Caption="退出论坛"
	Content="<div style='margin: 15;line-height: 150%'><li>已经成功的退出论坛<li><a href=login.Asp>重新登陆</a><li><a href=Default.Asp>进入论坛首页</a></div>"
	Call YxBBs.ShowTable(Caption,Content)
End Sub
%>