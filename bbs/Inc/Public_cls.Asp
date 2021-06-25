<%
Class Cls_Public
	Public Fun,Template,Position,MenuInfo,Menu,Stats,Board_Rs,HeadLoad,rssurl
	Public BBSName,Fname,BBSUrl,BBSClose,CloseInfo,CopyRight,BBSSetting,BuildDate,BbsTable,RegAutoSms,UploadType,AllEssayNum,NewUser,TopicNum,TodayNum,YsterdayNum,MaxOnlineNum,MaxOnlineTime,MaxEssayNum,UserNum,NowDate,BadName,BadEssay
	Public CacheName,CookiesName,NowBBSTime,SkinID,UserOnlineNum,AllOnlineNum,Srule
	Public TB,BoardID,BoardName,BoardSetting,BoardIntroduce,BoardTopicNum,BoardEssayNum,BoardAdmin,BoardGrade,BoardLock,BoardType,BoardTodayNum,BoardDepth,BoardChild,BoardParentStr,BoardRootID,BoardRoots,Brule
	Public MyIp,MyName,MyPwd,MyID,MyHidden,MySessionID,FoundUser,CookiesDate,IsBoardAdmin
	Public MySex,MyEssayNum,MyGoodNum,MyCoin,MyMark,MyHome,MyQQ,MyIsQQpic,MyPic,MyPicw,MyPich,MyGradeNum,MyGradeName,MyGradePic,MyBirthday,MyRegTime,MyLastTime,MySmsSize,MyRegIp,MyLoginNum,MyLastIp,MyHonor,MyBankSave,ClassSetting,ClassID
	Private SQL,Rs,Temp,SysConfig,MyInfo
	
	Private Sub Class_Initialize()
		Set Fun = New Cls_Fun
		Set Template = New Cls_SkinTemplates
		MyIp=Userip()
		CacheName="YxBBs_"&Replace(Replace(Replace(Server.MapPath("Default.Asp"),"Default.Asp",""),":",""),"\","")
		CookiesName=LCase(Replace(Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL"),Split(Request.ServerVariables("SCRIPT_NAME"),"/")(ubound(Split(Request.ServerVariables("SCRIPT_NAME"),"/"))),""))
		MyName=Replace(Request.Cookies(CookiesName)("MyName"),"'","")
		MyPwd=Replace(Request.Cookies(CookiesName)("MyPwd"),"'","")
		MyID=Trim(Request.Cookies(CookiesName)("MyID"))
		MyHidden=Request.Cookies(CookiesName)("MyHidden")
		CookiesDate=Request.Cookies(CookiesName)("CookiesDate")
		TB = CheckNum(Request.querystring("TB"))
		BoardID = CheckNum(Request.querystring("BoardID"))
		SkinID=Request.Cookies(CookiesName&"SkinID")
		NowBBSTime=FormatDateTime(Now()+Timeset/24,0)'服务器时间
		MySessionID=Session.SessionID
		FoundUser=False
	End Sub
	
	Private Sub Class_Terminate()
		Set Fun = Nothing
		Set Rs = Nothing
		Set Template = Nothing
		If IsObject(Conn) Then
			Conn.Close
			Set Conn = Nothing
		End If
	End Sub
	'检验数据表
	Private Function GetSqlTable(Str)
		Dim AllTable,i
		Temp=""
		AllTable=Split(BbsTable(0),",")
		For i=0 to uBound(AllTable)
		 If Str= Int(AllTable(i)) Then Temp=Str:Exit For
		Next
		If Temp="" Then Str=BbsTable(1)
		GetSqlTable=Str
	End Function
   '读取IP
	Private Function UserIP()
		Dim GetClientIP
		GetClientIP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
		If GetClientIP = "" or isnull(GetClientIP) or isempty(GetClientIP) Then
		GetClientIP = Request.ServerVariables("REMOTE_ADDR")
		End if
		If Instr(GetClientIP,"'")>0 Then GetClientIP="0.0.0.0"
		Userip = GetClientIP
	End function
	
	Private Sub MyDataInfo()
		Temp=Session(CacheName & "MyInfo")
		If LCase(MyName)<>LCase(Temp(1)) Then
			YxBBs.MakeCookiesEmpty()
			YxBBs.Error("获取用户参数错误！")
		End If
		MySex=Temp(3)
		MyEssayNum=Temp(4)
		MyGoodNum=Temp(5)
		MyCoin=Temp(6)
		MyMark=Temp(7)
		MyHome=Temp(8)
		MyQQ=Temp(9)
		MyIsQQpic=Temp(10)
		MyPic=Temp(11)
		MyPicw=Temp(12)
		MyPich=Temp(13)
		MyGradeNum=Temp(14)
		MyBirthday=Temp(15)
		MyRegTime=Temp(16)
		MyLastTime=Temp(17)
		MySmsSize=Temp(18)
		MyRegIp=Temp(19)
		MyLoginNum=Temp(20)
		MyLastIp=Temp(21)
		MyHonor=Temp(22)
		MyBankSave=Temp(23)
		ClassSetting=Split(Temp(24),",")
		ClassID=Temp(25)
        SET Rs=YxBBs.Execute("Select GradeName,GradePic From [YX_UserGrade] where GradeNum="&Temp(14)&"")
		MyGradeName=Rs(0)
		MyGradePic=Rs(1)
		FoundUser=True
	End Sub
	
	Public Sub SystemConfig()
		If Not IsNumeric(MySessionID) Then Error("获取参数错误！")
		Fun.LockedIpCheck()
		Cache.Name="Config"
		If Cache.Valid then
			SysConfig=Split(Cache.Value,"<$><$>")
		Else
			Set Rs = Execute("Select Top 1 BBSName,BBSUrl,BBSClose,CloseInfo,CopyRight,Info,BuildDate,RegAutoSms,UploadType,AllEssayNum,TopicNum,TodayNum,YsterdayNum,MaxOnlineNum,MaxOnlineTime,MaxEssayNum,NewUser,UserNum,NowDate,BadName,BadEssay,BbsTable,SkinID,Srule,fname From[YX_Config]")
			SqlNum=SqlNum+1
			Temp = Rs.GetString(,1, "<$><$>","","")
			Rs.Close
			Cache.add Temp,dateadd("n",2000,NowBBSTime)
			SysConfig = Split(Temp,"<$><$>")
		End If
		BBSName=SysConfig(0)
		BBSUrl=SysConfig(1)
		BBSClose=SysConfig(2)
		CloseInfo=SysConfig(3)
		CopyRight=SysConfig(4)
		BBSSetting=Split(SysConfig(5),"|")
		BuildDate=SysConfig(6)
		RegAutoSms=SysConfig(7)
		UploadType=Split(SysConfig(8),"@@")
		AllEssayNum=SysConfig(9)
		TopicNum=SysConfig(10)
		TodayNum=SysConfig(11)
		YsterdayNum=SysConfig(12)
		MaxOnlineNum=SysConfig(13)
		MaxOnlineTime=SysConfig(14)
		MaxEssayNum=SysConfig(15)
		NewUser=SysConfig(16)
		UserNum=SysConfig(17)
		NowDate=SysConfig(18)
		BadName=SysConfig(19)
		BadEssay=Split(SysConfig(20),"@@")
		BbsTable=Split(SysConfig(21),"|")
		FName=SysConfig(24)
		If BBSClose then
			If Instr(Lcase(Request("url")),""&YxBBs.BBSSetting(2)&"/")=0 Then Response.Write(""&CloseInfo&"<br><br><br><a href="&YxBBs.BBSSetting(2)&"/index.asp target='_blank'><b><font size=2 color=red>管理员登陆</font><b></font>"):Response.end
		End If
		If Int(TB)<>Int(BbsTable(1)) Then TB=GetSqlTable(TB)
		If Datediff("d",FormatDateTime(NowBbsTime,2),NowDate)<>0 Then UpdateToday
		If  Not IsNumeric(SkinID) or SkinID="0"  Then
		SkinID=SysConfig(22)
		Response.Cookies(CookiesName&"SkinID")=SkinID
		End If
		Srule=SysConfig(23)
			Template.SkinID=SkinID
			Template.OpenFile()
		Position="<a href=Default.Asp onmouseover=""showmenu(event,'"&BoardList(1)&"')"">"&BBSName&"</a>"
                
	End Sub
	
	Private Sub UpdateToday()
                If DateDiff("d",Execute("Select NowDate From [YX_Config]")(0), NowBbsTime)=0 Then Exit Sub
			Cache.name="Config":Cache.clean()
			Cache.name="BoardInfo":Cache.clean()
			Temp=Execute("select Todaynum from [YX_Config]")(0)
			Execute("update [YX_config] set NowDate='"&FormatDateTime(NowBbsTime,2)&"',Todaynum=0,YsterdayNum="&Temp&"")
			Execute("update [YX_Board] set Todaynum=0")
	End Sub
	
	Public Sub CheckUser()
		If Not IsNumeric(MyID) Or MyID="" Or MyName="" Or MyPwd="" Then
			FoundUser=False
			UserLoginFalse()
		Else
			UserLoginTrue()
		End If
	End Sub
	'用户信息
	Public Sub UserLoginTrue()
		Dim MenuOnline,NewSmsNum,AddTime
		If Not IsArray(Session(CacheName & "MyInfo")) Then
			SQL="Select U.ID,U.Name,U.Password,U.Sex,U.EssayNum,U.GoodNum,U.Coin,U.Mark,U.Home,U.QQ,U.IsQQpic,U.Pic,U.Picw,U.Pich,U.GradeNum,U.Birthday,U.RegTime,U.LastTime,U.SmsSize,U.RegIp,U.LoginNum,U.LastIp,U.Honor,U.BankSave,C.ClassSetting,C.ClassID From YX_user As U inner join YX_UserClass As C on U.ClassID=C.ClassID where U.ID="&MyID&" And U.Name='"&MyName&"' And U.Password='"&MyPwd&"'"
			Set Rs=Execute(SQL)
			If Rs.Eof Or Rs.Bof Then
				MakeCookiesEmpty()
				FoundUser=False
			Else
				If lcase(MyName)<>lcase(Rs(1)) Or MyPwd<>Rs(2) Then
					FoundUser=False
				Else
					MyInfo=Rs.GetString(,1, "<$><$>","","")
					Rs.CLose
					Session(CacheName & "MyInfo")=Split(MyInfo,"<$><$>")
					MyDataInfo()
				End If
			End If
If Int(MyID)<>Int(Session(CacheName & "MyInfo")(0)) or LCase(MyName)<>LCase(Session(CacheName & "MyInfo")(1)) Or MyPwd<>Session(CacheName & "MyInfo")(2) Then
			MakeCookiesEmpty()
				Error("非法伪造Cookie对论坛进行攻击")
                         end if
		Else
			MyDataInfo()
		End If
		If Request.Cookies(CookiesName)("onlinetime")=Empty Then
			Response.Cookies(CookiesName)("onlinetime")=NowBbsTime
		ElseIf DateDiff("s",Request.Cookies(CookiesName)("onlinetime"),NowBbsTime)>30 then
			AddTime=DateDiff("s",Request.Cookies(CookiesName)("onlinetime"),NowBbsTime)
			Execute("update [YX_User] Set lasttime='"&NowBbsTime&"',TimeSum=TimeSum+"&AddTime&" where Name='"&MyName&"'")
			Response.Cookies(CookiesName)("onlinetime")=NowBbsTime
		End If
               rssurl="?BoardID="&BoardID&""
if rssurl="?BoardID=0" then
                rssurl=""
                end if   
                
		If MyHidden="" then MyHidden=1
		If MyHidden=1 then MenuOnline="<a href=cookies.Asp?Action=Online>隐身</a>"
		If MyHidden=2 then MenuOnline="<a href=cookies.Asp?Action=Online>上线</a>"
		MenuInfo="&raquo; <b><font Color=red>WelCome</font></b> [<a onmouseover=""showmenu(event,'<div class=menuitems><a href=Sms.Asp>论坛信箱</a></div><div class=menuitems><a href=showList.Asp?Action=MySay>我的主题</a></div><div class=menuitems><a href=showlist.Asp?action=MyReply>我的回复</a></div><div class=menuitems><a href=showList.Asp?Action=MyGood>我的精华</a></div><div class=menuitems><a href=UserSetup.Asp?Action=MyInfo>修改资料</a></div><div class=menuitems><a href=usersetup.Asp?action=mypassword>修改密码</a></div>')"" style='CURSOR: hand;'>"&MyName&"</a> - "&MenuOnline&"]"
		MenuInfo=MenuInfo&"&nbsp;┆&nbsp;<a onmouseover=""showmenu(event,'<div class=menuitems><a href=showList.Asp?Action=new>论坛新帖</a></div><div class=menuitems><a href=Search.Asp>论坛搜索</a></div><div class=menuitems><a href=Members.Asp?Action=top>用户排行</a></div><div class=menuitems><a href=Members.Asp?Action=admin>管理团队</a></div><div class=menuitems><a href=Members.Asp?Action=log>论坛日志</a></div>')"">菜单</a>&nbsp;┆&nbsp;<a onmouseover=""showmenu(event,'"&SkinList()&"')"">风格</a>"
		MenuInfo=MenuInfo&PlusMenu()&"&nbsp;┆&nbsp;<a href=help.Asp>帮助</a>"
	
		If Session(CacheName & "LastTime")="" Then
			Session(CacheName & "LastTime")=MyLastTime
			Execute("Update [YX_user] set Lasttime='"&NowBbsTime&"' where Name='"&MyName&"'")
		End If
		If Session(CacheName & "MyReNewTime")="" Or DateDiff("n",Session(CacheName & "MyRenewTime"),NowBbsTime) > 2 Then'3分钟
			Set Rs=Execute("select NewSmsNum from [YX_user] where Name='"&MyName&"' And Password='"&MyPwd&"'")
			If Rs.Eof Then
				MakeCookiesEmpty()
				Error("必须登录论坛后才能进行操作！")
			Else
				NewSmsNum=Rs(0)
			End If
			Rs.Close
			If Instr(Lcase(Request("url")),"sms.asp")=0 Then
				If NewSmsNum>0 then
						Dim NewMailNum
                                                %>
<SCRIPT Src=Inc/Sms.js></SCRIPT>
<DIV id=eMeng style="BORDER-RIGHT: #455690 1px solid; BORDER-TOP: #a6b4cf 1px solid; Z-INDEX: 99999; LEFT: 0px; VISIBILITY: hidden; BORDER-LEFT: #a6b4cf 1px solid; WIDTH: 180px; BORDER-BOTTOM: #455690 1px solid; POSITION: absolute; TOP: 0px; HEIGHT: 116px; BACKGROUND-COLOR: #c9d3f3">
	<TABLE style="BORDER-TOP: #ffffff 1px solid; BORDER-LEFT: #ffffff 1px solid" cellSpacing=0 cellPadding=0 width="100%" bgColor=#cfdef4 border=0>
	<TBODY>
		<TR>
			<TD style="FONT-SIZE: 12px;COLOR: #0f2c8c" vAlign=center width=30 height=24></TD>
			<TD style="FONT-WEIGHT: normal; FONT-SIZE: 9pt; COLOR: #1f336b; PADDING-TOP: 4px" vAlign=center width="100%">&nbsp;&nbsp;短消息提示：</TD>
			<TD PADDING-TOP: 2px" vAlign=center align=right width=19><IMG title=关闭 style="CURSOR: hand" onclick=closeDiv() hspace=3 src="images/msgClose.jpg"></TD>
		</TR>
		<TR>
			<TD style="PADDING-RIGHT: 1px; PADDING-BOTTOM: 1px" colSpan=3 height=90>
				<DIV style="BORDER-RIGHT: #b9c9ef 1px solid; PADDING-RIGHT: 13px; BORDER-TOP: #728eb8 1px solid; PADDING-LEFT: 13px; FONT-SIZE: 9pt; PADDING-BOTTOM: 13px; BORDER-LEFT: #728eb8 1px solid; WIDTH: 100%; COLOR: #1f336b; PADDING-TOP: 18px; BORDER-BOTTOM: #b9c9ef 1px solid; HEIGHT: 100%">您有 <font color="red"><%=NewSmsNum%> 新</font> 的短消息
<BR><BR>
				<DIV align=center style="word-break:break-all"><a href="sms.asp">点击查看这条新信息.</a></DIV>
				</DIV>
			</TD>
		</TR>
	</TBODY>
	</TABLE>
</DIV>
                                             <%
					Else
						Session(CacheName & "MyReNewTime")=NowBbsTime
					End If
			End If
		End If
		If ClassID=1 Then MenuInfo=MenuInfo&"&nbsp;┆&nbsp;<a href="&YxBBs.BBSSetting(2)&"/index.asp><font color=""#FF0000"">管理</font></a>"
		MenuInfo=MenuInfo&"&nbsp;┆&nbsp;<a href=Login.Asp?Action=Exit>退出</a>&nbsp;┆&nbsp;<a href=rss.asp"&rssurl&" target=_blank title=RSS订阅当前论坛><img border=0 src=images/rss.gif></a>"
	End Sub
	
	Private Sub UserLoginFalse()
		Dim NotFoundUserClassSetting
		Cache.Name = "NotFoundUserClassSetting"
 rssurl="?BoardID="&BoardID&""
if rssurl="?BoardID=0" then
                rssurl=""
                end if   
		If Cache.valid then
			ClassSetting=Split(Cache.Value,",")
			ClassID=6
		Else
			Temp = Execute("Select ClassSetting from YX_UserClass where ClassID=6")(0)
			SqlNum=SqlNum+1
			Cache.add NotFoundUserClassSetting,dateadd("n",2000,now)
			ClassSetting=Split(Temp,",")
			ClassID=6
		End if
MenuInfo="&raquo;  您尚未 [<b><a href=login.Asp>登录</a></b> - <b><a href=register.Asp>注册</a></b>]&nbsp;┆&nbsp;<a onmouseover=""showmenu(event,'"&SkinList()&"')"">风格</a>&nbsp;┆&nbsp;<a href=Search.Asp>搜索</a>"
		MenuInfo=MenuInfo&"&nbsp;┆&nbsp;<a href=help.Asp>帮助</a>&nbsp;┆&nbsp;<a href=rss.asp"&rssurl&" target=_blank title=RSS订阅当前论坛><img border=0 src=images/rss.gif></a>"
	End Sub
	
	Public function CheckNum(str)
		If isnull(str) or str=""  then
		Str=0
		End If
		if not isnumeric(str) then Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
		CheckNum=int(str)
	End function
	
	Public Sub GetOnline()
		Dim PicMood
		If Session(CacheName & "Stats") = Stats Then
			AllOnlineNum=Session(CacheName & "AllonlineNum")
			UserOnlineNum=Session(CacheName & "UserOnlineNum")
		Else
			Session(CacheName & "Stats")=Stats
			Dim UserSessionID
			UserSessionID=Request.Cookies("SessionID")("SID")
			If IsNumeric(UserSessionID)=0 or UserSessionID="" Then
				UserSessionID=Ccur(MySessionID)
				Response.Cookies("SessionID").Expires=date+1
				Response.Cookies("SessionID")("SID")=Ccur(MySessionID)
			Else
				UserSessionID=Ccur(UserSessionID)
			End If
			If FoundUser Then
				SQL = "Select Count(ID) From[YX_Online]Where Name='" & MyName & "' or ID=" & UserSessionID &" "
			Else
				SQL = "Select Count(ID) From[YX_Online]Where ID=" & UserSessionID &""
			End if
			Temp=Execute(SQL)(0)
			IF FoundUser Then
				If MyHidden=2 Then PicMood=0
				IF Temp >1 Then Execute("Delete * From[YX_online] where name='"&MyName&"'")
			End If
			If Temp < 1 Then
				SQL="Insert into [YX_Online](ID,ClassID,Name,OldTime,LastTime,Locate,Ip,BoardID,BoardUrl) values("&UserSessionID&","&ClassID&",'"& Myname &"','"& NowBbsTime &"','"&NowBbsTime&"','"& Stats &"','"& MyIp &"',"& BoardID &",'"&GetUrl()&"')"
			Else
				SQL="Update [YX_Online] set Name='"& Myname &"',ClassID='"&ClassID&"',LastTime='"&NowBbsTime&"',Locate='"&Stats&"',BoardID="&BoardID&",Ip='"& MyIp &"' where ID="&UserSessionID&""
			End If
			Execute(Sql)
			'全部在线用户
			AllOnlineNum=Execute("Select Count(ID) From[YX_online]")(0)
			'统计在线会员
			If BoardID=0 Then
				UserOnlineNum=Execute("Select Count(ID) From[YX_online] where ClassID<>6")(0)
			Else
				UserOnlineNum=Execute("Select Count(ID) From[YX_online] where ClassID<>6 And BoardID="&BoardID&"")(0)
			End If
			Session(CacheName & "AllOnlineNum")=AllOnlineNum
			Session(CacheName & "UserOnlineNum")=UserOnlineNum
			If Int(AllOnlineNum)>Int(MaxOnlineNum) then
				Execute ("update [YX_Config] Set MaxOnlineNum="&AllOnlineNum&",MaxOnlineTime='"&NowBbsTime&"'")
				Cache.name="Config"
				Cache.clean()
			End If
			Execute( "Delete FROM [YX_Online] WHERE DATEDIFF('s', LastTime,'"&NowBbsTime&"') > "&BBSSetting(27)*60&"") '分钟
		End If
	End Sub
	
	Public Sub MakeCookiesEmpty()
		Session(CacheName & "MyInfo") = Empty
		Response.Cookies(CookiesName)("MyID")=""
		Response.Cookies(CookiesName)("MyName")=""
		Response.Cookies(CookiesName)("MyPwd")=""
		Response.Cookies(CookiesName)("MyHidden")=""
		Response.Cookies(CookiesName)("CookiesData")=""
		Cache.Name="UserOnline"
		Cache.Clean()
	End Sub
	
	Public Function PageStats()
		Temp=Template.ReadTemplate("你的位置")
		Temp=Replace(Temp,"{位置}",Position)
		PageStats=Temp
	End Function
	
	Public Sub Head(Str)
		Dim i,KJZAction
		Temp = Template.ReadTemplate("页面属性")
		IF Str<>"" Then
			Position=Position&"&nbsp;->&nbsp;"& Str
Stats=Str
		End if
		Temp = Replace(Temp,"{页面标题}",Stats&" --- "&BBSName&"|"&FName)
		KJZAction = Mid(Request.ServerVariables("URL"),InstrRev(Request.ServerVariables("URL"),"/")+1)
		If Instr(LCase(KJZAction),"show.asp")> 0 Then 
 	    Temp = Replace(Temp,"{关键字}","<meta name=""robots"" content=""all"" />"& vbNewLine &"<meta name=""keywords"" content="""&Stats&"""/>"& vbNewLine &"<meta name=""description"" content="""&Stats&"""  />"& vbNewLine &"<meta name=""author"" content=""Yimxu.com"">")
Else
	Temp = Replace(Temp,"{关键字}","<meta name=""robots"" content=""all"" />"& vbNewLine &"<meta name=""keywords"" content="""&YxBBs.BBSSetting(65)&"""/>"& vbNewLine &"<meta name=""description"" content="""&YxBBs.BBSSetting(66)&"""  />"& vbNewLine &"<meta name=""author"" content=""Yimxu.com"">")
End if
		
		Temp= Temp & Template.ReadTemplate("菜单属性")& vbNewLine &"<SCRIPT Src=Inc/Menu.js></SCRIPT>"
		Temp = Temp & vbNewLine & Template.ReadTemplate("页面头部")
		Temp = Replace(Temp,"{菜单}",MenuInfo)
		Response.Write Temp&vbNewLine &PageStats()
		GetOnline()
		HeadLoad=True
	End Sub
	
	Public Sub Footer()
		Temp=Template.ReadTemplate("页面底部")
		Temp=Replace(Temp,"{版权}","<br>Powered By:<a href=""http://www.grgbanking123.top/yxbbs/"" target=""_blank""><font color=red>YxBBs 20180223 </font></a> "&getTimeOver(BBSSetting(33))&""&SqlNum&" queries. <br> "&CopyRight&"")
		Response.Write Temp
	End Sub
	'插件菜单
	Public Function PlusMenu()
		Cache.Name="PlusMenu"
		If Cache.Valid then
			PlusMenu=Cache.Value
		Else
			Set Rs=YxBBs.Execute("Select Name,Url,Flag From [YX_Plus]")
			SqlNum=SqlNum+1
			Do while not Rs.eof
				PlusMenu=PlusMenu&"<div class=menuitems><a href="&Rs(1)&">"&Rs(0)&"</a></div>"
				Rs.MoveNext
			Loop
			PlusMenu="&nbsp;┆&nbsp;<a onmouseover=""showmenu(event,'"&PlusMenu&"')"">设施</a>"
			Rs.Close
			Cache.add PlusMenu,dateadd("n",2000,NowBBSTime)
		End If
	End Function
	'风格菜单
	Public Function SkinList()
		Dim Temp,Arr_Rs,i
 		Cache.Name="SkinList"
		If Cache.valid Then
			Arr_Rs=Cache.Value
		Else
			Set Rs=Execute("Select SkinID,SkinName From[YX_SkinStyle]")
			If Rs.Eof Or Rs.Bof Then
			Exit Function
			Else
			Arr_Rs=Rs.GetRows
			Rs.Close
			Cache.add Arr_Rs,dateadd("n",2000,now)
			End If
		End if
			For i=0 To Ubound(Arr_Rs,2)
				If int(SkinID)=Int(Arr_Rs(0,i)) Then
					Temp=Temp&"<div class=menuitems><a href=Cookies.Asp?Action=Style&SkinID="&Arr_Rs(0,i)&"><font color=red>"&Arr_Rs(1,i)&"</font></a></div>"
				Else
					Temp=Temp&"<div class=menuitems><a href=Cookies.Asp?Action=Style&SkinID="&Arr_Rs(0,i)&">"&Arr_Rs(1,i)&"</a></div>"
				End if
			Next
		SkinList=Temp
	End Function
	'缓存版块
	Public Function CacheBoard()
		Cache.Name="BoardInfo"
		If Cache.valid then
			Board_Rs=Cache.Value
		Else
			Set Rs=Execute("Select Depth,BoardID,ParentID,Boardname,BoardSetting,BoardImg,Introduce,BoardAdmin,TopicNum,EssayNum,TodayNum,LastReply,PassUser,Child,ParentStr,RootID,BoardLock,BoardType,BoardGrade,Brule From[YX_Board] order by RootID,Orders")
			If Rs.Eof Or Rs.Bof Then
				Exit Function
			Else
				Board_Rs=Rs.GetRows(-1)
				Rs.Close
				Cache.add Board_Rs,dateadd("n",1000,now)'1000分钟更新
			End If
		End If
	End Function
	'版块信息
	Public Function GetBoardInfo(Str,Ast)
		Dim I,BoardtypePic,BoardtypepicTemp,BoardAdmin,BoardAdmin1,LastStr
		Temp= Replace(Trim(Template.ReadTemplate("版块类型图片")), CHR(10),"")
		Temp= Replace(temp,CHR(13),"")
		If Temp="" Then Response.Write("模版数据损坏！<br><A HREF=Cookies.Asp?Action=Style&SkinID=0>请点这里更新你的Cookies</A><br>如果依然存在问题，请清空Cookies,并重新启动浏览器！"):Response.end
		BoardtypepicTemp=split(Temp,"|")
		If Board_Rs(16,Ast) Then
			Boardtypepic=BoardtypepicTemp(2)
		Else
			If board_Rs(11,Ast)<>"" Then
				If Datediff("h",Split(board_Rs(11,Ast),"|")(2),NowbbsTime)<=24 Then
					Boardtypepic=BoardtypepicTemp(1)
				Else
					Boardtypepic=BoardtypepicTemp(0)
				End If
			Else
				Boardtypepic=BoardTypePicTemp(0)
			End If
		End If
		If board_Rs(5,Ast)="" or IsNull(board_Rs(5,Ast)) Then
			Temp=""
		Else
			Temp="<img src="&board_Rs(5,Ast)&">"
		End if
		Str = Replace(Str,"{版块类型图片}",BoardTypePic)
		Str = Replace(Str,"{版块图片}",Temp)
		If board_Rs(13,Ast)>0 Then Temp=" ["&board_Rs(13,Ast)&"]" Else Temp=""
		Str = Replace(Str,"{版块ID}",board_Rs(1,Ast))
		Str = Replace(Str,"{版块名称}","<a href=List.Asp?BoardID="&board_Rs(1,Ast)&">"&board_Rs(3,Ast)&Temp&"</a>")
		Str = Replace(Str,"{版块介绍}",board_Rs(6,Ast))
		If Board_Rs(7,Ast) = "" Or IsNull(board_Rs(7,Ast)) Then
			BoardAdmin="暂无":BoardAdmin1="暂无"
		Else
			Temp=split(board_Rs(7,Ast),"@@")
			BoardAdmin=""
			For I=0 to ubound(Temp)
				BoardAdmin=BoardAdmin&"<a href='Profile.Asp?Name="&Temp(I)&"' title='点击查看版主："&Temp(I)&" 的信息'>"&Temp(I)&"</a>&nbsp;"
			Next
			BoardAdmin1=Replace(BoardAdmin,"&nbsp;","<br>")
		End If
		Str=Replace(Str,"{版主竖排}",BoardAdmin1)
		Str = Replace(Str,"{版主}",BoardAdmin)
		Str = Replace(Str,"{主题数}",board_Rs(8,Ast))
		Str = Replace(Str,"{总帖数}",board_Rs(9,Ast))
		Str = Replace(Str,"{今日帖数}",board_Rs(10,Ast))
		If isnull(board_Rs(11,Ast)) or board_Rs(11,Ast)="" Then
			Str=Replace(Str,"{最后回复}","")
		Elseif Cint(Board_Rs(17,Ast)) Then
			Str=Replace(Str,"{最后回复}","<div align=center><font color=#999999>认证版面</font></div>")
		Else
			LastStr=Template.ReadTemplate("版块最后回复")
			Temp=Split(board_Rs(11,Ast),"|")
			LastStr = Replace(LastStr,"{用户名称}",Temp(0))
			LastStr = Replace(LastStr,"{帖子信息}",Temp(1))
			LastStr = Replace(LastStr,"{回复时间}",Temp(2))
			LastStr = Replace(LastStr,"{表情}",Temp(3))
			LastStr = Replace(LastStr,"{主题ID}",Temp(4))
			LastStr = Replace(LastStr,"{版块ID}",Temp(5))
			LastStr = Replace(LastStr,"{数据表ID}",Temp(6))
			Str = Replace(Str,"{最后回复}",LastStr)
		End if
		GetBoardInfo=Str
	End Function
	'表格显示（标题，内容）
	Public Sub ShowTable(Str1,Str2)
		Dim Temp
		Temp=Template.ReadTemplate("内容表格")
		Temp=Replace(Temp,"{标题}",Str1)
		Temp=Replace(Temp,"{内容}",Str2)
		Response.Write(Temp)
	End Sub
	'检验版块
	Public Sub CheckBoard()
		If Not IsArray(Board_Rs) Then CacheBoard()
		If Not IsArray(Board_Rs) Then Error("您所访问的版面不存在！")
		Dim Temp,PassUser,i
                rssurl="?BoardID="&BoardID&""
		If BoardID=0 Then Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
                For i=0 To Ubound(Board_Rs,2)
			If Int(Board_Rs(1,i))=Int(BoardID) Then
				BoardDepth=Board_Rs(0,i)
				BoardName=Board_Rs(3,i)
				Stats=Boardname
				BoardSetting=split(Board_Rs(4,i),",")
				BoardIntroduce=Board_Rs(6,i)
				BoardAdmin=Board_Rs(7,i)
				BoardEssayNum=Board_Rs(9,i)
				BoardTopicNum=Board_Rs(8,i)
				BoardTodayNum=Board_Rs(10,i)
				PassUser=Board_Rs(12,i)
				BoardChild=Board_Rs(13,i)
				BoardParentStr=Board_Rs(14,i)
				BoardRootID=Board_Rs(15,i)
				BoardLock=Board_Rs(16,i)
				BoardType=Board_Rs(17,i)
				BoardGrade=Board_Rs(18,i)
			End If
		Next
		IsBoardAdmin=False
		BoardRoots="|"
		If InStr("@@"&Lcase(BoardAdmin)&"@@","@@"&Lcase(MyName)&"@@")>0  And FoundUser And BoardAdmin<>"" Then IsBoardAdmin=True
		For i=0 To Ubound(Board_Rs,2)
			'记录区置顶信息
			If Board_Rs(15,i)=BoardRootID And Board_Rs(0,i)<>0 Then BoardRoots=BoardRoots&Board_Rs(1,i)&"|"
			If Int(BoardDepth)>0 Then
				If InStr(","&BoardParentStr&",",","&Board_Rs(1,i)&",")>0 Then
					'如果上级论坛为会员版面
					'If Board_Rs(4,i)=1 Then If Not Founduser then Error("该版面为只有注册会员可以进入")
					'上级版主继承管理
					If BBSSetting(1)="0" And FoundUser Then
						If InStr("|"&Board_Rs(7,i)&"|","|"&MyName&"|")>0 And FoundUser And BoardAdmin<>"" Then IsBoardAdmin=True
					End If
					Temp=Temp &" -> <a href='List.Asp?BoardID="&Board_Rs(1,i)&"'>"&Board_Rs(3,i)&"</a>"
				End If
			End If
		Next
		If ClassID=3 And Not IsBoardAdmin Then ClassSetting=Split(Execute("Select ClassSetting from YX_UserClass where ClassID=5")(0),",")
		Position=Position & Temp &" -> <a href='List.Asp?BoardID="&BoardID&"'>"&Stats&"</a>"
		If BoardName="" or IsNull(BoardName) Then Error("您所访问的版面不存在！")
		If  Instr(Lcase(Request("Url")),"list.asp")>0 Then
			If  isnull(Boardadmin) or Trim(BoardAdmin)="" then
				BoardAdmin="暂无"
			Else
				Temp=split(BoardAdmin,"@@")
				BoardAdmin=""
				For i=0 to ubound(Temp)
					Boardadmin=Boardadmin&"<a href='Profile.Asp?name="&Temp(i)&"'>"&Temp(i)&"</a>&nbsp;"
				Next
			End If
		End If
		If ClassID<=2 Then Exit Sub
		If Cint(MyGradeNum)<BoardGrade Then Error("您的等级还没有达到 <font color=#FF0000>"&BoardGrade&"</font> 级，不能进入这个版！当前您的等级是 <font color=#FF0000>"&CInt(MyGradeNum)&"</font> 级！")
		If BoardLock Then
			If  ClassID>2 or Not IsBoardAdmin then
				If (Instr(Lcase(Request("url")),"say.asp")>0 and Instr(Lcase(Request("url")),"show.asp")<1) or Instr(Lcase(Request("url")),"save.asp")>0 then Error("该版面已经锁定，你没有权限在本版发表帖子！") 
			End If
		End If
		If BoardType Then
			Dim IsPassUser
			ISpassUser=False
			If ClassID>2 Then
				If Not IsBoardAdmin Then
					If Not FoundUser or isnull(PassUser) or PassUser="" then
						Error("该版面为认证论坛，你还没有经过管理员的认证！")
					Else
						PassUser=Split(PassUser,"|")
						for i = 0 to ubound(PassUser)
							If MyName=trim(PassUser(i)) And MyName<>"" Then
								IsPassuser=True
								Exit for
							End If
						Next
						If Not IsPassUser Then Error("该版面为认证论坛，你还没有经过管理员的认证！")
					End If
				End If
			End if
		End If
		
		If Cint(MyEssayNum)<Cint(BoardSetting(5)) Then Error("您的贴数不足 "&Cint(BoardSetting(5))&" 帖，不能进入本版面！")
		If CLng(MyMark)<Cint(BoardSetting(6)) Then Error("您的Yb不足 "&Cint(BoardSetting(6))&" ，不能进入本版面！")
		If CLng(MyCoin)<Cint(BoardSetting(7)) Then Error("您的金币不足 "&Cint(BoardSetting(7))&" ，不能进入本版面！")
		If Cint(MyLoginNum)<Cint(BoardSetting(8)) Then Error("您的登陆不足 "&Cint(BoardSetting(8))&" 次，不能进入本版面！")
		If Cint(MyGoodNum)<Cint(BoardSetting(9)) Then Error("您的精华贴数不足 "&Cint(BoardSetting(9))&" 贴，不能进入本版面！")
		If DateDIff("n",MyRegTime,NowBBSTime)<Cint(BoardSetting(10)) Then Error("您的注册时间没有超过 "&Cint(BoardSetting(10))&" 分钟，不能进入本版面！")
	End Sub
	'版块下拉列表(当前ID，不显示的深度)
	Public Function BoardIDList(Ast,Depth)
		Dim Temp,I,II,po
		If Not IsArray(Board_Rs) Then YxBBs.CacheBoard()
		If IsArray(Board_Rs) Then
			For i=0 To Ubound(Board_Rs,2)
				Po=""
				If Board_Rs(0,i)=0 Then
					Temp=Temp&"<option value='"&Board_Rs(1,i)&"'"
					If Board_Rs(1,i)=Ast Then Temp=Temp&" selected"
					Temp=Temp&">≡"&Board_Rs(3,i)&"≡</option>"
				Else
					For II=2 to Board_Rs(0,i)
						po=Po&"∣"
					Next
					Temp=Temp&"<option value='"&Board_Rs(1,i)&"'"
					If Board_Rs(1,i)=Ast Then Temp=Temp&" selected"
					Temp=Temp&">"&po&"├ "&Board_Rs(3,i)&"</option>"
				End IF
			Next
			BoardIDList=Temp
		End If
	End Function
	'记录认证版块的标记
	Public Function NoShowTopic()
		Dim Temp,i
		If Not IsArrAy(Board_Rs) Then CacheBoard()
		If IsArray(Board_Rs) Then
			Temp=""
			For i=0 To Ubound(Board_Rs,2)
				If Board_Rs(17,I)=3 Then
					Temp=Temp&Board_Rs(1,I)&","
				End If
			Next
			If Temp<>"" Then Temp=left(temp,len(temp)-1)
			NoShowTopic=Temp
		End If
	End Function
	Public Function Execute(T_Sql)
		If Not IsObject(Conn) Then ConnectionDatabase
		Set Execute = Conn.Execute(T_Sql)
		SqlNum=SqlNum+1
	End Function
	Public Sub InToDataBase(DataBaseName,TableName,ColumnName,ColumnValue)
		On Error Resume Next
		
		YxBBs.Execute("insert into ["&TableName&"] ("&ColumnName&") values ("&Replace(Replace(ColumnValue,"True","1"),"False","0")&")")
		
		If Err Then
			Response.Write "在LOG数据库表"&TableName&"中添加记录失败！原因：<font color=red>" & Err.Description
			Err.Clear
		End If
	End Sub
	PubLic Sub InLog(LogInfo,ToName,LogType)
		If LogType = 1 Then
			InToDataBase db,"YX_Logs","UserName,UserIP,LogContent,LogTime","'"&YxBBs.MyName&"','"&YxBBs.MyIp&"','"&LogInfo&"','"&Now()&"'"
		Else
			InToDataBase db,"YX_Logs","ToName,UserName,UserIP,LogContent,LogTime","'"&ToName&"','"&YxBBs.MyName&"','"&YxBBs.MyIp&"','"&LogInfo&"','"&Now()&"'"
		End If
	End Sub
	'弹出JS错误消息
	Sub ErrMsg(Message)
		Response.Write("<script>alert('"&message&"');history.back();</script>")
		Set Cache = Nothing
		Set YxBBs = Nothing
		Response.End()
	End Sub
	'错误信息提示
	Public Sub Error(Message)
		If Not HeadLoad Then Call Head("错误信息")
		Call ShowTable("错误信息","<tr><td height=""100""><b>操作不成功的可能原因：</b><ul><li>"&Message&"<br><br><li><a href=javascript:history.go(-1)>返回上一页</a></ul></td></tr>")
		YxBBs.Footer()
		Set Cache = Nothing
		Set YxBBs = Nothing
		Response.End()
	End Sub
	'操作成功表格
	Public Sub Success(Info,Message)
		If Not HeadLoad Then Call Head("操作成功")
		Call ShowTable("操作成功","<tr><td height=""100""><div style='margin:15;line-height: 150%'><b>"&Info&"您可以进行以下操作：</b><br><ul>"&Message&"</ul></div></td></tr>")
		YxBBs.Footer()
		Set Cache = Nothing
		Set YxBBs = Nothing
		Response.End()
	End Sub
	'获取Cookies记录(cookies名称，来源)
	Public Function GetCookiesInfo(CkStr,From)
		GetCookiesInfo=Session(CacheName & CkStr)
		If GetCookiesInfo="" Then GetCookiesInfo=Request.Cookies(CookiesName&CkStr)(CkStr)
		If GetCookiesInfo="" Then
			GetCookiesInfo=From
			Session(CacheName & CkStr)=From
			Response.Cookies(CookiesName&CkStr)(CkStr)=From
			Response.Cookies(CookiesName&CkStr).Expires=Date+1
		Else
			Session(CacheName & CkStr)=GetCookiesInfo
			Response.Cookies(CookiesName&CkStr)(CkStr)=GetCookiesInfo
		End If
	End Function
	'获取当前URL地址
	Public Function GetUrl()
		On Error Resume Next
		Dim Temp
		If LCase(Request.ServerVariables("HTTPS")) = "off" Then
			Temp = "http://"
		Else
			Temp = "https://"
		End If
		Temp = Temp & Request.ServerVariables("SERVER_NAME")
		If Request.ServerVariables("SERVER_PORT") <> 80 Then Temp = Temp & ":" & Request.ServerVariables("SERVER_PORT")
		Temp = Temp & Request.ServerVariables("URL")
		If Trim(Request.QueryString)<>"" Then Temp = Temp & "?" & Request.QueryString
		GetUrl = Temp
	End Function

	Public Function UpdateCookiesInfo(CkStr,Ast)
		If Ast=0 Then
			Session(CacheName & CkStr)=""
			Response.Cookies(CookiesName&CkStr)(CkStr)=""
		Else
			Dim Temp
			Temp=Session(CacheName & CkStr)
			If Temp="" Then Temp=Request.Cookies(CookiesName&CkStr)(CkStr)
			If Temp="" Then Exit Function
			Temp=Temp+Ast
			Session(CacheName & CkStr)=Temp
			Response.Cookies(CookiesName&CkStr)(CkStr)=Temp
			UpdateCookiesInfo=Temp
		End If
	End Function

	'1菜单列表2下拉列表
	Public Function BoardList(Ast)
	   If Ast<1 or Ast>2 Then Exit Function
		Dim Temp,BoardNenu,BoardSelect,i,II,Po
 		Cache.Name="BoardList"&Ast
		If Cache.valid Then
			Temp=Cache.Value
			BoardList=Temp
			Exit Function
		Else
			If Not IsArray(Board_Rs) Then CacheBoard()
			If Not IsArray(Board_Rs) Then Exit Function
			Cache.Name="BoardList"&Ast
			For i=0 To Ubound(Board_Rs,2)
			Po=""
			If Board_Rs(0,i)=0 Then'类
				BoardNenu=BoardNenu&"<div class=menuitems><A Href=List.Asp?BoardID="&Board_Rs(1,i)&">≡ "&Board_Rs(3,i)&" ≡</a></div>"
				BoardSelect=BoardSelect&"<option value='"&Board_Rs(1,i)&"'>■≡"&Board_Rs(3,i)&"≡</option>"
			Else
				For II=2 to Board_Rs(0,i)
				po=Po&"∣"
				Next
				BoardNenu=BoardNenu&"<div class=menuitems><A Href=List.Asp?BoardID="&Board_Rs(1,i)&">"&po&"├ "&Board_Rs(3,i)&"</a></div>"
				BoardSelect=BoardSelect&"<option value='"&Board_Rs(1,i)&"'>&nbsp;&nbsp;"&po&"├ "&Board_Rs(3,i)&"</option>"
			End IF
			Next
			BoardSelect="<select onchange=if(this.options[this.selectedIndex].value!=''){location='list.Asp?boardID='+this.options[this.selectedIndex].value;} style='font-size: 9pt'><option selected>跳转论坛至...</option>"&BoardSelect&"</select>"
			If Ast = 1 Then
			Cache.add BoardNenu,dateadd("n",5000,now)'5000分钟更新
			BoardList=BoardNenu
			Else
			Cache.add BoardSelect,dateadd("n",5000,now)
			BoardList=BoardSelect
			End If
		End If
	End Function

	Function Cvt(Tstr,Iflag)
		Select Case Iflag
			Case"1"
				Tstr="<font color=""red""><b>"&Tstr&"</b></font>"
			Case"2"
				Tstr="<font color=""blue""><b>"&Tstr&"</b></font>"
			Case"3"    
				Tstr="<font color=""green""><b>"&Tstr&"</b></font>"
 			Case Else
				Tstr=Tstr
		End Select
	Cvt=Tstr
	End Function

	Function GetTimeOver(iflag)
		If iflag=0 Then Exit Function
		Dim tTimeOver
		If iflag = 1 Then
			tTimeOver = FormatNumber((Timer() - StartTime) * 1000, 3, true)
			getTimeOver = " Processed in:" & tTimeOver & "Ms,"
		Else
			tTimeOver = FormatNumber(Timer() - StartTime, 6, true)
			getTimeOver = " Processed in:" & tTimeOver & "s,"
		End If
	End Function

       Public Function GCode()
                GCode=" 验证码：<input name=""CheckCode"" type=""text"" size=""6"" maxlength=""5"" /> <script type=""text/javascript"">document.write(""<img align='absmiddle' Src=Inc/code.Asp alt='请点击刷新验证码' onclick=this.src='Inc/code.Asp'>"")</script>"
	End Function 
End Class


Dim YimXu,CookiesName
'读取Cookies 
CookiesName=LCase(Replace(Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL"),Split(request.ServerVariables("SCRIPT_NAME"),"/")(ubound(Split(request.ServerVariables("SCRIPT_NAME"),"/"))),""))
YimXu=Request.Cookies(CookiesName)("CookiesDate")
If YimXu>0 Then Response.Cookies(CookiesName).Expires=date+YimXu
%>