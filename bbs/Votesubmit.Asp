<!--#include file="Inc/SysConfig.Asp"-->
<%Dim Action,ID
YxBBs.Fun.CheckMake
If not YxBBs.FoundUser Then YxBBs.Error("您还没有注册或者登陆！")
ID=YxBBs.CheckNum(Request.QueryString("Id"))
Action=Lcase(Request.QueryString("Action"))
'投票权限
If Cint(YxBBs.ClassSetting(8))=0 Then YxBBs.Error("您没有参与投票的权限！")
If Action="vote" Then
	SubmitVote()
Else
	SubmitBuyer()
End If
Set YxBBs=Nothing
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

Sub SubmitVote()
	Dim Temp,Rs,i,VoteType,Vote,VoteNum,TempVote,MyOpt,OutTime,AllVoteNum
	IF ID=0 Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
	VoteType=YxBBs.checknum(Request.QueryString("type"))
	Set Rs=YxBBs.execute("select Vote,VoteNum,VoteType,OutTime From[YX_TopicVote] where TopicID="&ID&"")
	IF Not Rs.Eof Then
		Vote=split(Rs("vote"),"|")
		VoteNum=split(Rs("voteNum"),"|")
		OutTime=Rs("OutTime")
		IF VoteType<>Int(Rs("VoteType")) Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
		TempVote=Vote
		if VoteType=1 then
			Temp=YxBBs.CheckNum(Request.form("opt"))
			MyOpt=Temp
			For i=1 to ubound(Vote)
				If i=Temp then VoteNum(i)=VoteNum(i)+1
				AllVoteNum=AllVoteNum&"|"&VoteNum(i)
			Next
		ElseIf VoteType=2 Then
			Temp=0
			TempVote=Vote
			For i=1 to ubound(Vote)
				TempVote(i)=YxBBs.Checknum(Request.form("opt"&i&""))
				Temp=TempVote(i)+Temp
				IF TempVote(i)=0 Then TempVote(i)=VoteNum(i)
				IF TempVote(i)=i Then
				 TempVote(i)=Votenum(i)+1
				 MyOpt=MyOpt&","&i
				End if
				AllVoteNum=AllVoteNum&"|"&TempVote(i)  
			Next
		Else
			YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
		End if
		If Temp=0 Then Call alert("您还没有选择投票项目！")
		IF Temp<>0 And YxBBs.execute("select User From [YX_TopicVoteUser] where User='"&YxBBs.MyName&"' and TopicID="&ID&"").Eof Then
			If DateDiff("s",YxBBs.NowBbsTime,OutTime)>0 then
			YxBBs.execute("update [YX_TopicVote] Set VoteNum='"&AllvoteNum&"' where TopicID="&ID&"")
			YxBBs.execute("update [YX_Topic] Set LastTime='"&YxBBs.NowBbsTime&"' where TopicID="&ID&"")
			YxBBs.execute("update [YX_bbs"&YxBBs.TB&"] Set LastTime='"&YxBBs.NowBbsTime&"' where TopicID="&ID&"")
			YxBBs.execute("Insert into [YX_TopicVoteUser](TopicID,[User],VoteNum)VALUES("&ID&",'"&YxBBs.MyName&"','"&MyOpt&"')")
			End If
		End If
	End if
	Rs.Close
End Sub

Sub SubmitBuyer()
	If ID=0 Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
	Dim Temp,Rs,Rss,Buyer,re,str
	Set Rs=YxBBs.execute("Select Content,Name,Buyer From[YX_bbs"&YxBBs.TB&"] where BbsID="&ID&"")
	IF Rs.eof Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
	Rss=Rs.GetRows(1)
	Rs.Close
	Temp=Replace(Rss(0,0),chr(10),"")
	Temp=Replace(Temp,chr(10),"")
	Set re=new RegExp
	re.IgnoreCase =true
	re.Global=True
	re.Pattern="(^.*)(\[BUYPOST=*([0-9]*)\])(.*)(\[\/BUYPOST\])(.*)"
	Str=re.Replace(Temp,"$3")
	Set re=Nothing
	If isnumeric(Str) Then
		Str=int(Str)
	Else
		Str=0
	End if
	If Lcase(Rss(1,0))=Lcase(YxBBs.MyName) Then Call alert("您不能向自己购买！")
	If Int(YxBBs.MyCoin)<Str Then Call alert("钱不够，请再努力发帖赚钱吧！")
	If Not isnull(Rss(2,0)) Then
		If instr("|"&Lcase(Rss(2,0))&"|","|"&Lcase(YxBBs.MyName)&"|")>0 Then Call alert("您已经购买过了呀？")
	End IF
	Temp=Rss(2,0)&"|"&YxBBs.MyName
	YxBBs.execute("update [YX_user] set Coin=Coin-"&Str&" where name='"&YxBBs.MyName&"'")
	YxBBs.execute("update [YX_user] set Coin=Coin+"&Str&" where name='"&Rss(1,0)&"'")
	YxBBs.execute("Update [YX_bbs"&YxBBs.TB&"] Set Buyer='"&Trim(Temp)&"' Where BbsID="&ID&"")
	Session(YxBBs.CacheName & "MyInfo")=""
End Sub
Sub Alert(message)
  message = replace(message,"'","\'")
  Response.Write ("<script LANGUAGE='javascript'>alert('" & message & "');history.go(-1);</script>")
  Response.End
End Sub
%>