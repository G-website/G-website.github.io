<!--#include file="Inc/SysConfig.Asp"-->
<%
Dim Action,num,Border,trHeight,Bordercolor,Bgcolor,BBSURL,Show,Face,tg,slen,rs,Shokw
Set Rs=YxBBs.execute("Select BBSUrl From [YX_config]")
BBSURL=""&Rs("BBSUrl")&""
Num=request.querystring("num")
Border=request.querystring("bo")
bordercolor=Left(request.querystring("boc"),9)
bgcolor=Left(request.querystring("bgc"),9)
trHeight=Left(request.querystring("h"),2)
Face=Left(request.querystring("face"),2)
tg=left(request.querystring("tg"),2)
slen=Request.QueryString("len")
If Num="" or Not YxBBs.Fun.isInteger(Num) Then Num="10"
If Int(Num)>50 then Num="50"
If slen="" Or Not YxBBs.Fun.isInteger(slen) Then slen=25
If Border="" or not YxBBs.Fun.isInteger(Border) Then Border="0"
If bgcolor<>"" Then bgcolor="bgcolor='#"&bgcolor&"' "
If bordercolor<>"" Then bordercolor="bordercolor='#"&bordercolor&"'"
If trHeight="" or not YxBBs.Fun.isInteger(trHeight) Then trHeight="18"

Action=Request.querystring("action")
If len(Action)>10 Then Response.Write"请检查调用语句":Response.End
Select Case Action
Case"topic"
Topic
Case"board"
Board
Case"info"
Info
Case"login"
Login
End Select
Set YxBBs=Nothing

Sub Login
Show="<form method='POST' action='"&BBSURL&"/login.asp?action=login' style='margin:0'"
If tg="1" then Show=Show&" target='_blank' "
Show=Show&"><tr height='"&trHeight&"'><td>用户：<input size='8' name='name' /></td></tr><tr><td> 密码：<input type='password' size='8' name='password' class='text' /></td></tr>"
If request.querystring("CK")="1" Then Show=Show&"<tr height='"&trHeight&"'><td>保存：<SELECT size=1 name='cookies'><OPTION value=0 selected>不保存</OPTION><OPTION value=1>保存一天</OPTION><OPTION value=30>保存一月</OPTION><PTION value=365>保存一年</OPTION></SELECT></td></tr>"
If request.querystring("HI")="1" Then Show=Show&"<tr height='"&trHeight&"'><td>方式：<SELECT size=1 name='hidden'><OPTION value='1' selected>正常登陆</OPTION><OPTION value=2>隐身登陆</OPTION></SELECT></td></tr>"
If YxBBs.BBSSetting(6)="0" Then Show=Show&"<tr height='"&trHeight&"'><td><input  type=text name='CheckCode' size=8><img align='absmiddle' Src='"&BBSURL&"/Inc/code.Asp'></td></tr>"
Show=Show&"<tr height='"&trHeight&"'><td><input type='submit' class='button' value='登 陆' /></td></tr></form>"
End Sub

Sub Topic
	Dim Sql,Rs,ARs,Sqlwhere,Sqlorder,i,Order,BoardID,TopicType,UserName,ShowTime,DayBound,temp
	Dim Border,Height
	BoardID=request.querystring("boardid")
	TopicType=request.querystring("type")
	Order=request.querystring("order")
	UserName=request.querystring("user")
	ShowTime=request.querystring("time")
	DayBound=request.querystring("day")
	If Order="1" Then
		Sqlorder="AddTime DESC"
	ElseIf Order="2" Then
		Sqlorder="ReplyNum DESC"
	ElseIf Order="3" Then
		Sqlorder="Hits DESC"
	Else
		Sqlorder="LastTime DESC"
	End If
	Sqlwhere="isdel=0"
	If DayBound<>"" And YxBBs.Fun.isInteger(DayBound) then
		Sqlwhere=Sqlwhere&" And DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')<"&DayBound
	End If
	If BoardID<>"" And Yxbbs.Fun.IsInteger(BoardID) And BoardID<>"0" Then
			Temp=BoardID&","
				Set Rs=Yxbbs.Execute("Select BoardID,ParentStr From Yx_Board")
					Do While Not Rs.Eof
						If  Instr(Rs("ParentStr")&",",Temp)>0 Then
						BoardID=BoardID&","&Rs("BoardID")
						End If
					Rs.MoveNext
					Loop
				Rs.Close
				Set Rs=Nothing
		Sqlwhere=Sqlwhere&" and boardid in("&BoardID&")"
	End If
	Select Case Int(TopicType)
	Case 1
	Sqlwhere=Sqlwhere&" AND topType>0"
	Case 2
	Sqlwhere=Sqlwhere&" AND isGood"
	Case 3
	Sqlwhere=Sqlwhere&" AND isVote=1"
	End Select 
	Sql="SELECT Top "&Num&" TopicID,Name,Face,Caption,BoardID,LastTime,SqlTableID FROM [Yx_Topic] WHERE "&Sqlwhere&" ORDER BY "&Sqlorder&""
	Set Rs=YxBBs.Execute(Sql)
	If Not Rs.Eof Then
		ARs=Rs.GetRows(Num)
		Rs.Close
		Set Rs=Nothing
		For I=0 To Ubound(ARs,2)
                  if ARs(2,i)=99 then ARs(2,i)=1
			Show=Show&"<tr height='"&trHeight&"'>"
			If Face="1" Then Show=Show&"<td width='20'><img src='"&BBSURL&"/images/face/"&ARs(2,i)&".gIf'/></td>"
			Show=Show&"<td width=*>"
			If Face<>"1" Then
			If Face="0" Then
				Show=Show&i+1&"."
			Else
				Show=Show&Face
			End If
			End If
			Show=Show&" <a"
			If tg="1" then Show=Show&" target='_blank' "
			Show=Show&" href='"&BBSURL&"/Show.asp?ID="&ARs(0,i)&"&BoardID="&ARs(4,i)&"&TB="&ARs(6,i)&"'>"&YxBBs.Fun.StrLeft(ARs(3,i),Int(slen))&"</a></td>"
			If UserName="1" Then Show=Show&"<td width='110' align='center'>"&ARs(1,i)&"</td>"
			If ShowTime="1" Then Show=Show&"<td width='120' align='center'>"&ARs(5,i)&"</td>"
			Show=Show&"</tr>"
		Next
	Else
		Show="<tr height="&trHeight&"><td>没有内容</td></tr>"
	End If
End Sub

Sub Board
	Dim I,II,po
	If Not IsArray(YxBBs.Board_Rs) Then YxBBs.CacheBoard()
	If IsArray(YxBBs.Board_Rs) Then
		For i=0 To Ubound(YxBBs.Board_Rs,2)
			po=""
			If YxBBs.Board_Rs(0,i)<>0  Then
				For II=1 To YxBBs.Board_Rs(0,i)
				Po=Po&"&nbsp;"
				Next
			End If
			Show=Show&"<tr height="&trHeight&"><td>"&Po&" ├ <a "
			If tg="1" Then Show=Show&"target='_blank' "
			Show=Show&"href='"&BBSURL&"/List.asp?boardID="&YxBBs.Board_Rs(1,i)&"'>"&YxBBs.Board_Rs(3,i)&"</a></td></tr>"
		Next
	End If
End Sub

Sub Info
Dim flag
flag=request.querystring("flag")
YxBBs.Getonline'读取在线
If instr(flag,"|1|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 论坛帖数：<font color=red>"&YxBBs.AllEssayNum&"</a></td></tr>"
If instr(flag,"|2|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 主题帖数：<font color=red>"&YxBBs.TopicNum&"</a></td></tr>"
If instr(flag,"|3|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 今日帖数：<font color=red>"&YxBBs.TodayNum&"</a></td></tr>"
If instr(flag,"|4|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 昨日帖数：<font color=red>"&YxBBs.YsterdayNum&"</a></td></tr>"
If instr(flag,"|5|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 最高日帖：<font color=red>"&YxBBs.MaxEssayNum&"</a></td></tr>"
If instr(flag,"|6|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 注册人数：<font color=red>"&YxBBs.UserNum&"</a></td></tr>"
If instr(flag,"|7|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 最新会员：<a target='_blank' href='"&BBSURL&"/Userinfo.asp?name="&YxBBs.NewUser&"'><font color=red>"&YxBBs.NewUser&"</a></td></tr>"
If instr(flag,"|8|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 论坛在线：<font color=red>"&YxBBs.AllonlineNum&"</a></td></tr>"
If instr(flag,"|9|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 在线会员：<font color=red>"&YxBBs.useronlineNum&"</a></td></tr>"
If instr(flag,"|10|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 在线游客：<font color=red>"&YxBBs.AllonlineNum-YxBBs.useronlineNum&"</a></td></tr>"
If instr(flag,"|11|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 最高在线：<font color=red>"&YxBBs.MaxOnlineNum&"</a></td></tr>"
If instr(flag,"|12|")=0 then Show=Show&"<tr height="&trHeight&"><td>"&face&" 建站时间：<font color=red>"&FORMATDATETIME(YxBBs.BuildDate,1)&"</a></td></tr>"
End Sub
%>
document.write("<table width='100%' border='<%=border%>' <%=bgcolor&bordercolor%> cellpadding='0' cellspacing='0' style='border-collapse:collapse'><%=Show%></table>");