<!--#include file="Inc/SysConfig.Asp"-->

<%
Dim PageString,GCode
YxBBs.Head("论坛首页")
If YxBBs.BBSSetting(7)="0" then PageString=ShowInfo()
PageString=PageString&ShowBoard()
If YxBBs.BBSSetting(10)="0" then PageString=PageString&ShowOnline()
Response.Write PageString &"<iframe name='hiddenframe' frameborder='0' height='0' id='hiddenframe'></iframe>"
If YxBBs.BBSSetting(32)="0" then ShowBirthday()
If YxBBs.BBSSetting(8)="0" then ShowLink()
YxBBs.Footer()
Set Cache = Nothing
Set YxBBs = Nothing

Function ShowInfo()
	Dim Temp,OnlingType
	If YxBBs.FoundUser Then
		Temp = YxBBs.Template.ReadTemplate("用户信息")
		If YxBBs.MyIsQQpic Then
			Temp=Replace(Temp,"{用户头像}","<img src='http://qqshow-user.tencent.com/"&YxBBs.MyQQ&"/11/00/'>")
		Else
			Temp=Replace(Temp,"{用户头像}","<img src="&YxBBs.Mypic&" width="&YxBBs.Mypicw&" height="&YxBBs.Mypich&" >")
		End if
		OnlingType="<font Color=Red>［在线］</Font>"
		If YxBBs.MyHidden=2 Then OnlingType="<font Color=Red>［隐身］</Font>"
		Temp=Replace(Temp,"{用户名称}","<a href='Profile.Asp' title='查自己的资料信息'>"&YxBBs.MyName&"</a>")
		Temp=Replace(Temp,"{在线状态}",OnlingType)
		Temp=Replace(Temp,"{金钱数}",YxBBs.MyCoin)
		Temp=Replace(Temp,"{Y币}",""&YxBBs.BBSSetting(23)&"：<font color=red>"&YxBBs.MyMark&"</font>")
		Temp=Replace(Temp,"{帖数}",YxBBs.MyEssayNum)
		Temp=Replace(Temp,"{等级名称}",YxBBs.MyGradeName)
	Else
		Temp = YxBBs.Template.ReadTemplate("快速登陆")
	End If 
	Temp=Replace(Temp,"{公告}",YxBBs.Srule)
        Temp=Replace(Temp,"{新会员名称}",YxBBs.NewUser) 
	Temp=Replace(Temp,"{今日帖数}",YxBBs.TodayNum)
	Temp=Replace(Temp,"{最高日帖数}",YxBBs.MaxEssayNum)
	Temp=Replace(Temp,"{主题数}",YxBBs.TopicNum)
	Temp=Replace(Temp,"{总帖数}",YxBBs.AllEssayNum)
	Temp=Replace(Temp,"{会员数}",YxBBs.UserNum)
	Temp=Replace(Temp,"{昨日帖数}",YxBBs.YsterdayNum)
        If Cint(YxBBs.BBSSetting(6))=0 Then 
        Temp=Replace(Temp,"{验证码}",YxBBs.GCode)
        else
        Temp=Replace(Temp,"{验证码}","")
        end if
	ShowInfo=Temp
End Function

Function ShowBoard()
	Dim Rs,Temp,i,BigBoard,BoardChild,BoardBottom,BoardStr
	BigBoard=YxBBs.Template.ReadTemplate("分区表格")
	BoardChild=YxBBs.Template.ReadTemplate("版块列表")
	BoardBottom=YxBBs.Template.ReadTemplate("分区底部表格")
	If Not IsArray(YxBBs.Board_Rs) Then YxBBs.CacheBoard()
	If Not IsArray(YxBBs.Board_Rs) Then Exit Function
	For i=0 To Ubound(YxBBs.Board_Rs,2)
		If YxBBs.Board_Rs(0,i)<2 Then
			Temp=""
			If YxBBs.Board_Rs(0,i)=0 Then
				If i >= 1 Then Temp = Temp & BoardBottom & VbCrlf
				Temp = Temp & Replace(BigBoard,"{分类名称}",YxBBs.Board_Rs(3,i))
			Else
				Temp=BoardChild
				Temp=YxBBs.GetBoardInfo(Temp,i)
			End If
			BoardStr=BoardStr & Temp
		End If
	Next
	ShowBoard = BoardStr& BoardBottom & VbCrlf
End Function

Function ShowOnline()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("在线统计")
	Temp=Replace(Temp,"{在线列表}","<span id=showon></span>")
	Temp=Replace(Temp,"{用户IP}",YxBBs.MyIp)
	Temp=Replace(Temp,"{建站时间}",FORMATDATETIME(YxBBs.BuildDate,1))
	Temp=Replace(Temp,"{在线总数}",YxBBs.AllOnlineNum)
	Temp=Replace(Temp,"{会员数}",YxBBs.UserOnlineNum)
	Temp=Replace(Temp,"{游客数}",YxBBs.AllOnlineNum-YxBBs.UserOnlineNum)
	Temp=Replace(Temp,"{在线最大数}",YxBBs.MaxOnlineNum)
	Temp=Replace(Temp,"{最大数时间}",YxBBs.MaxOnlineTime)
	If Session(YxBBs.CacheName&"online")="1" then
		Temp=Replace(Temp,"{在线列表开关}","<a target='hiddenframe' href='Online.Asp?Action=LoadIng' onClick='ShowOnline();' ><span id='Showtxt' >关闭详细列表</span></a>")
		Temp=Temp&"<iframe frameborder='0'  height='0' src='Online.Asp?Action=LoadIng&id=1'></iframe>"
	Else
		Temp=Replace(Temp,"{在线列表开关}","<a target='hiddenframe' href='Online.Asp?Action=LoadIng' onClick='ShowOnline();' ><span id='Showtxt' >显示详细列表</span></a>")
	End If
	ShowOnline=Temp
End Function

Sub ShowLink()
	Dim Link_List,LogoLink,TxtLink,Rs,Arr_Rs,I,Sql,j,k
	Cache.Name="Link_List"
	If Cache.Valid then
		Link_List=Cache.Value
	Else
		Sql = "Select BbsName,Url,Pic,Readme,IsPic From [YX_Link] Where  Orders  order by Orders Asc"
		If Not IsObject(Conn) Then ConnectionDatabase
		Set Rs = Server.CreateObject("Adodb.RecordSet")
		Rs.open Sql,Conn,1,1
		SqlNum=SqlNum+1
		If Not(rs.eof or rs.bof) Then Arr_Rs = Rs.getrows()
		Rs.Close:Set Rs=Nothing
		If IsArray(Arr_Rs) Then
			TxtLink="":LogoLink="":j=0:k=0
			For i = 0 to UBound(Arr_Rs,2)
				If Arr_Rs(4,i) And Arr_Rs(2,i)<>"" Then
					j=j+1
					LogoLink=LogoLink&"<td align=""center""><a href="""&Arr_Rs(1,i)&""" target=""_blank""><img src="""&Arr_Rs(2,i)&""" border=""0"" alt=""::"&Arr_Rs(0,i)&"::"&Arr_Rs(3,i)&""" width=""88"" height=""31""></a></td>"
					If j=7 Then j=0:LogoLink=LogoLink&"</tr><tr>"
				Else
					k=k+1
					TxtLink=TxtLink&"<td align=""center""><a href="""&Arr_Rs(1,i)&""" target=""_blank"" title="""&Arr_Rs(3,i)&""">"&Arr_Rs(0,i)&"</a></td>"
					If k=7 Then k=0:TxtLink=TxtLink&"</tr><tr>"
				End If
			Next
		End If
		Link_List="<tr><td align=""center""><table width=""100%"" border=""0"" cellpadding=""4"" cellspacing=""0""><tr>"&TxtLink&"</tr></table><table width=""100%"" border=""0"" cellpadding=""4"" cellspacing=""0""><tr>"&LogoLink&"</tr></table></td></tr>"
		Cache.add Link_List,dateadd("n",5000,YxBBs.NowBBSTime)
	End If
	Call YxBBs.ShowTable("论坛联盟",Link_List)
End Sub

Sub ShowBirthday()
	Dim UserBirthday,temp,rs,Arr_Rs,i,Num
	Cache.Name="Birthday"
	If Cache.valid then
		Temp=Split(Cache.Value,"|")
		Num=Temp(0)
		UserBirthday=Temp(1)
	Else
		Set Rs=YxBBs.Execute("Select Name,Birthday From[YX_User] where Month(Birthday)=Month(now) and day(Birthday)=day(now) and Birthday<>Cdate('1900-1-1')")
		IF Not Rs.eof Then Arr_Rs=Rs.getrows()
		Rs.Close
		Num=0
		If IsArray(Arr_Rs) Then
			For i = 0 to UBound(Arr_Rs,2)
				Num=Num+1
				UserBirthday=UserBirthday&"  <a href=Profile.Asp?Name="&Arr_Rs(0,i)&"><img src=Images/Birthday.gif align=""absmiddle"" border=0> 祝［"&Arr_Rs(0,i)&"］生日快乐</a>  "
			Next
		End If
		If i>3 Then UserBirthday="<marquee onMouseOver='this.stop()' onMouseOut='this.start()' scrollamount='3' >"&UserBirthday&"</marquee>"
		Temp=Num&"|"&UserBirthday
		Cache.add Temp,dateadd("n",100,now)
	End If
	If num > 0 Then
		Call YxBBs.ShowTable("今天共有 "&num&" 位会员过生日","<tr><td height=30>"&UserBirthday&"</td></tr>")
	End If
End Sub
%>
