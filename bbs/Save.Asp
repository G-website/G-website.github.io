<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/Md5.Asp"-->
<%
Dim Action,Caption,Content,Face,Page,TmpUbbString,LowerCase,TemUrl,topicpic
If Not YxBBs.Founduser then YxBBs.Error("您还没有注册或者登陆！")
IF (Session(YxBBs.CacheName&"SayTime")+Int(YxBBs.BBSSetting(30))/86400)>Now() Then YxBBs.Error("本论坛为了防止灌水，限制了同一人发帖的时间间隔为 <Font color=red>"& YxBBs.BBSSetting(30)&"</Font> 秒！")
YxBBs.Fun.CheckMake
YxBBs.CheckBoard()
TemUrl=Replace(Request.Form("url"),"'","''")
if TemUrl="" then TemUrl=Request.ServerVariables("HTTP_REFERER")
Face=YxBBs.CheckNum(Request.form("face"))
Caption=YxBBs.Fun.checkbad(YxBBs.Fun.GetStr("caption"))
topicpic=Request.form("topicpic")
Content=YxBBs.Fun.checkbad(YxBBs.Fun.GetStr("content"))
If Caption="" Or Content="" then YxBBs.Error("主题或内容没有填写！")
Caption=Jncode(Caption)
Content=Jncode(Content)
Function Jncode(Istr)
Dim japArr,ArrNum
japArr=Array("ゴ","ガ","ギ","グ","ゲ","ザ","ジ","ズ","ヅ","デ","ド","ポ","ベ","プ","ビ","パ","ヴ","ボ","ペ","ブ","ピ","バ","ヂ","ダ","ゾ","ゼ")
For ArrNum=0 to Ubound(japArr)
Istr=Replace(Istr,japArr(ArrNum),"&#"&AscW(japArr(ArrNum))&";")
Next
Jncode=Istr
End Function
IF Len(Caption)>YxBBs.BoardSetting(2) Then YxBBs.Error("帖子主题字符数超出论坛限制！")
IF Len(Content)>int(YxBBs.BoardSetting(3)) or Len(Content)<int(YxBBs.BoardSetting(11)) Then YxBBs.Error("帖子字符应在 <b><font color=red>"&YxBBs.BoardSetting(11)&"</font> 到 <font color=red>"&YxBBs.BoardSetting(3)&"</font></b> 个字符之间")
IF Session("CheckCode")<>Request.form("CheckCode") And Cint(YxBBs.BoardSetting(0))=1 then YxBBs.Error("发帖验证码错误！")
YxBBs.Head("")
Page=YxBBs.CheckNum(Request.QueryString("page"))
Action=lcase(Request.QueryString("action"))
IF Action="reply" Then
 	Reply()
ElseIf Action="edit" Then
	Edit()
Else
	Say()
End if
If Cint(YxBBs.BoardSetting(0))=1 then Session("CheckCode")=""
Content="<div style='margin:15;line-height: 150%'>"&Content&"</div>"
Call YxBBs.ShowTable(Caption,Content)
Session(YxBBs.CacheName & "SayTime")=Now()
YxBBs.Footer()
Set YxBBs=Nothing

Function CheckUploadType(byval Str)
	Dim pos
	Str=split(Str,"[UPLOAD=")
	If ubound(Str)>=1 then
		pos=instr(str(1),"[/UPLOAD]")
		If pos=0 then exit function
		CheckUploadType=left(str(1),3)
	End if
End function

Sub Say()
	Dim Temp,I,ISvote,TitleType,VoteType,VoteAutoValue,Votes,VoteNum,Outtime,UploadType,TopicLastReply,BoardLastReply,MaxID
	If Cint(YxBBs.ClassSetting(3))=0 Then YxBBs.Error("您没有发表主题的权限！")
	TmpUbbString=YxBBs.Fun.UbbString(Content)
	IsVote=false
	If instr(","&Join(Split(YxBBs.BoardSetting(1),"|"),",")&",",","&CheckUploadType(Content)&",")>0 then
		UploadType=CheckUploadType(Content)
	Else
		UploadType=""
	End if
	TitleType=YxBBs.CheckNum(request.Form("topicximoo"))
	VoteType=YxBBs.CheckNum(Request.Form("VoteType"))
	VoteAutoValue=YxBBs.CheckNum(Request.Form("AutoValue"))
	If Int(TitleType)<>0 Then
		If Int(YxBBs.MyCoin)<Int(YxBBs.BBSSetting(13)) Then YxBBs.Error("您的金钱不足于 <font color=#FF0000>"&Int(YxBBs.BBSSetting(13))&"</font> 啦!不能使用醒目标题!")
		YxBBs.Execute("Update [YX_user] Set Coin=Coin-"&Int(YxBBs.BBSSetting(13))&" WHERE Name='"&YxBBs.MyName&"'")
	End If
	If VoteType<>2 Then VoteType=1
	For i=1 to VoteAutoValue
	Temp=Left(YxBBs.Fun.Checkbad(Trim(YxBBs.Fun.GetStr("Votes"&I))),250)
	IF not Temp="" Then
		votes=Votes&"|"&Temp
		VoteNum=VoteNum&"|0"
	End If
	Next
	Outtime=cDate(YxBBs.NowBbsTime)+int(Request.form("OutTime"))
	If Votes<>"" Then
		IsVote=True
		'投票权限
		If Cint(YxBBs.ClassSetting(7))=0 Then YxBBs.Error("您没有发表投票的权限！")
	End If
	If Session(YxBBs.CacheName&"SayContent")=Md5(Caption&Content) Then YxBBs.Error("您的帖子已经发表成功，请不要重复提交！")

	

	'插入主题表
	TopicLastReply=YxBBs.Myname&"|"&YxBBs.Fun.StrLeft(YxBBs.Fun.FixReply(Content),40)
	YxBBs.Execute("Insert into [YX_Topic](Caption,Name,Face,IsVote,AddTime,LastTime,Lastreply,UploadType,BoardID,SqlTableID,TitleType)Values('"&Caption&"','"&YxBBs.Myname&"',"&Face&","&IsVote&",'"&YxBBs.NowBbsTime&"','"&YxBBs.NowBbsTime&"','"&TopicLastReply&"','"&UploadType&"',"&YxBBs.BoardID&","&YxBBs.TB&","&TitleType&")")
	'得到新发表主题的ID
	MaxID=YxBBs.Execute("select Max(TopicID) from [YX_Topic]")(0)
	'插入投票
	IF IsVote Then YxBBs.Execute("insert into[YX_TopicVote](TopicID,Vote,VoteNum,VoteType,OutTime)values("&MaxID&",'"&votes&"','"&VoteNum&"',"&votetype&",'"&Outtime&"')")
	'插入帖子
	YxBBs.Execute("Insert into [YX_bbs"&YxBBs.TB&"](TopicID,Caption,name,Content,AddTime,LastTime,BoardID,UbbString,IP)VALUES("&MaxID&",'"&Caption&"','"&YxBBs.MyName&"','"&Content&"','"&YxBBs.NowBbsTime&"','"&YxBBs.NowBbsTime&"',"&YxBBs.BoardID&",'"&TmpUbbString&"','"&YxBBs.MyIP&"')")

	'更新上传
	if topicpic<>""then
	YxBBs.Execute("Update [YX_UpFile] Set topid='"&MaxID&"' WHERE FileName='"&topicpic&"'")
	end if
	
	
	'更新用户信息
	Dim UG
	Set UG = YxBBs.Execute("Select Top 1 GradeNum,GradeName,GradePic,UserMinPostNum from YX_UserGrade Where ClassID="&YxBBs.ClassID&" And UserMinPostNum<="&YxBBs.MyEssayNum&" Order By UserMinPostNum Desc")
	If Not UG.Eof Then
		YxBBs.Execute("Update [YX_User] Set Coin=Coin+"&YxBBs.BBSSetting(37)&",EssayNum=EssayNum+1,GradeNum="&UG(0)&" Where ID="&YxBBs.MyID)
	Else
		YxBBs.Execute("Update [YX_user] set Coin=Coin+"& YxBBs.BBSSetting(37)&",EssayNum=EssayNum+1 WHERE ID="&YxBBs.MyID)
	End If
	UG.Close
	Set UG=nothing
	'更新版块
	BoardLastReply=YxBBs.MyName&"|"&YxBBs.Fun.StrLeft(Caption,20)&"|"&YxBBs.NowBbsTime&"|"&Face&"|"&MaxID&"|"&YxBBs.BoardID&"|"&YxBBs.TB
	YxBBs.Execute("Update [YX_Board] set TopicNum=TopicNum+1,TodayNum=TodayNum+1,EssayNum=EssayNum+1,LastReply='"&BoardLastReply&"' where BoardID="&YxBBs.BoardID&" And Depth>0")
	'更新上级版块
	If YxBBs.BoardDepth>1 Then
		YxBBs.Execute("Update [YX_Board] set TopicNum=TopicNum+1,TodayNum=TodayNum+1,EssayNum=EssayNum+1,LastReply='"&BoardLastReply&"' where BoardID In ("&YxBBs.BoardParentStr&") And Depth>0")
	End If
	'更新系统
	YxBBs.Execute("Update [YX_config] set Topicnum=Topicnum+1,allEssayNum=AllEssayNum+1,TodayNum=TodayNum+1")
	UpdateCache()
	Session(YxBBs.CacheName&"SayContent")=Md5(Caption&Content)
	Caption="发帖成功"
	Content="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&MaxId&"><b>本页面将在3秒后自动返回您发布的帖子！您可以选择以下操作：</b><br><ul><li><a href=Default.Asp>返回首页</a><li></li><a href=list.Asp?BoardID="&YxBBs.BoardID&">"&YxBBs.Boardname&"</a></li><li><a href=Show.Asp?ID="&MaxId&">回到你发布的帖</a></li></ul>"
End Sub

Sub Reply()
	Dim Rs,ID,TopicUserName,TopicLastReply,BoardLastReply,Temp,Quote,QuoteName,Coins
	ID=YxBBs.Checknum(Request.QueryString("Id"))
	Quote=YxBBs.Fun.GetStr("Quote")
	If Trim(Quote)<>"" Then Content=YxBBs.Fun.GetStr("QuoteName") & Quote & "[/quote]" & Content
	If Id=0 or YxBBs.BoardID=0 Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
	TmpUbbString=YxBBs.Fun.UbbString(content)
	Set Rs=YxBBs.Execute("Select Name,IsLock,SqlTableID,BoardID From [YX_Topic] where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" Or TopType=4 or TopType=5) And SqlTableID="&YxBBs.TB&" And IsDel=False")
	IF Rs.Eof Then YxBBs.Error("该帖子不存在或已经删除")
	IF YxBBs.MyName=Rs(0) Then
		IF Rs(1) Then YxBBs.Error("该帖子已经被锁定！")
	End If
	'回复权限
	If Rs(0)=YxBBs.MyName Then
		If Cint(YxBBs.ClassSetting(4))=0 Then YxBBs.Error("您没有回复自己帖子的权限！")
	Else
		If Cint(YxBBs.ClassSetting(5))=0 Then YxBBs.Error("您没有回复别人帖子的权限！")
	End If
	TopicUserName=Rs(0)
	YxBBs.TB=Rs(2)
	YxBBs.BoardID=Rs(3)
	Set RS=Nothing
	If Session(YxBBs.CacheName&"SayContent")=Md5(Caption&Content) Then YxBBs.Error("您的回复发表成功，请不要重复提交！")
	'插入帖子
	YxBBs.Execute("insert into [YX_bbs"&YxBBs.TB&"](ReplyTopicID,name,Caption,Content,AddTime,LastTime,Boardid,UbbString,ip)VALUES("&ID&",'"&YxBBs.MyName&"','"&Caption&"','"&Content&"','"&YxBBs.NowBbsTime&"','"&YxBBs.NowBbsTime&"',"&YxBBs.BoardID&",'"&TmpUbbString&"','"&YxBBs.MyIp&"')")
	'更新主题帖子
	YxBBs.Execute("Update [YX_bbs"&YxBBs.TB&"] Set LastTime='"&YxBBs.NowBbsTime&"' where TopicId="&ID&"")
	'更新主题
	TopicLastReply=""&YxBBs.MyName&"|"&YxBBs.Fun.StrLeft(YxBBs.Fun.FixReply(Content),40)
	YxBBs.Execute("Update [YX_Topic] set ReplyNum=ReplyNum+1,LastTime='"&YxBBs.NowBbsTime&"',LastReply='"&TopicLastReply&"' where TopicId="&ID&"")
	'更新版块
	BoardLastReply=""&YxBBs.MyName&"|"&YxBBs.Fun.StrLeft(Caption,20)&"|"&YxBBs.NowBbsTime&"|"&Face&"|"&ID&"|"&YxBBs.BoardID&"|"&YxBBs.TB
	YxBBs.Execute("Update [YX_Board] set lastReply='"&BoardLastReply&"',TodayNum=TodayNum+1,EssayNum=EssayNum+1 where BoardID="&YxBBs.BoardID&" and Depth<>0")
	If YxBBs.BoardDepth>1 Then
		YxBBs.Execute("Update [YX_Board] set TopicNum=TopicNum+1,TodayNum=TodayNum+1,EssayNum=EssayNum+1,LastReply='"&BoardLastReply&"' where BoardID In ("&YxBBs.BoardParentStr&") And Depth>0")
	End If
	'更新用户
	If Len(Content)<10 Then Coins=0 Else 
	YxBBs.Execute("Update [YX_user] set Coin=Coin+"&YxBBs.BBSSetting(38)&",EssayNum=EssayNum+1 WHERE Name='"&YxBBs.Myname&"'")
	'更新楼主
	If Lcase(YxBBs.MyName)<>Lcase(TopicUserName) Then
		YxBBs.Execute("Update [YX_user] set Coin=Coin+"&YxBBs.BBSSetting(38)&" WHERE Name='"&TopicUserName&"'")
	End If
	'更新上传
	if topicpic<>""then
	YxBBs.Execute("Update [YX_UpFile] Set topid='"&ID&"' WHERE FileName='"&topicpic&"'")
	end if
	'更新系统
	YxBBs.Execute("Update [YX_Config] set TodayNum=TodayNum+1,AllEssayNum=AllEssayNum+1")
	UpdateCache()
	Session(YxBBs.CacheName&"SayContent")=Md5(Caption&Content)
	Caption="回复成功"
	Content="<meta http-equiv=refresh content=3;url=Show.Asp?id="&ID&"&page="&page&"><b>本页面将在3秒后自动返回您回复帖子页面！您可以选择以下操作：</b><br><ul><li><a href=Default.Asp>返回首页</a><li></li><a href=list.Asp?BoardID="&YxBBs.BoardID&">"&YxBBs.Boardname&"</a></li><li><a href=Show.Asp?id="&ID&"&page="&page&">回到你回复的帖子</a></li></ul>"
End Sub

Sub Edit()
	Dim Rs,ID,BbsID,IsTopic,TopicID,TitleType,OldTitleType,EditChalk,Rs_tb
	EditChalk=YxBBs.Fun.GetStr("EditChalk")
	ID=YxBBs.CheckNum(Request.QueryString("ID"))
	BbsID=YxBBs.CheckNum(Request.QueryString("BbsID"))
	If BbsID=0 Or ID=0 Then YxBBs.Error("请不要手动去更改地址栏参数！")
	IsTopic=False
	If EditChalk<>"No" Then
	Content=""&Content&vbcrlf&vbcrlf&vbcrlf&"<p align=right><font color=#0080FF>「该帖子被 "&YxBBs.MyName&" 在 "&YxBBs.NowBbsTime&" 编辑过」</font></p>"
	End If
	TmpUbbString=YxBBs.Fun.UbbString(content)
	Set Rs_tb=YxBBs.Execute("Select SqlTableID From [YX_Topic] where IsDel=False And TopicID="&ID)
	Set Rs=YxBBs.Execute("select Name,TopicID,ReplyTopicID from [YX_bbs"&Rs_tb(0)&"] where BbsID="&BbsID&"")
	If Not Rs.eof  Then
		If Lcase(YxBBs.MyName)<>Lcase(rs("name")) Then
			If Cint(YxBBs.ClassSetting(18))=0 Then YxBBs.Error("您没有编辑别人帖子的权限！")
		Else
			'编辑自己帖子的权限
			If Cint(YxBBs.ClassSetting(9))=0 Then YxBBs.Error("您没有编辑自己帖子的权限！")
		End If
		IF Rs("ReplyTopicID")=0 Then
			TopicID=Rs("TopicID")
			IsTopic=True
		End IF
		Rs.Close
	Else
		YxBBs.Error("该帖子不存在或已经删除！")
	End if
	YxBBs.Execute("Update [YX_bbs"&Rs_tb(0)&"] set Caption='"&Caption&"',Content='"&Content&"',LastTime='"&YxBBs.NowBbsTime&"',UbbString='"&TmpUbbString&"' where BbsID="&BbsID&"")
	If IsTopic then
		TitleType=YxBBs.CheckNum(Request.Form("topicximoo"))
		OldTitleType=YxBBs.CheckNum(Request.Form("OldTitleType"))
		If Int(TitleType)<>0 Then
		 If Int(YxBBs.MyCoin)<Int(YxBBs.BBSSetting(13)) Then 
		 YxBBs.Error("您的金钱不足于 <font color=#FF0000>"&Int(YxBBs.BBSSetting(13))&"</font> 啦!不能使用醒目标题!")
		 else
		 YxBBs.Execute("Update [YX_User] Set Coin=Coin-"&Int(YxBBs.BBSSetting(13))&" WHERE Name='"&YxBBs.MyName&"'")
		 End If
                else
                TitleType=OldTitleType
		End If
		YxBBs.Execute("Update [YX_Topic] set Caption='"&Caption&"',Face="&Face&",LastTime='"&YxBBs.NowBbsTime&"',TitleType="&TitleType&" where TopicID="&TopicID&"")
	End if
	Caption="修改成功"
	Content="<meta http-equiv=refresh content=3;url=Show.Asp?id="&ID&"&page="&page&">本页面将在3秒后自动返回您编辑的帖子！<b>您可以选择以下操作：</b><br><ul><li><a href=Default.Asp>返回首页</a><li></li><a href=list.Asp?BoardID="&YxBBs.BoardID&">"&YxBBs.Boardname&"</a></li><li><a href=Show.Asp?id="&ID&"&page="&page&">回到你编辑的帖子</a></li></ul>"
End Sub

Sub UpdateCache()
	Dim Temp
	Temp=YxBBs.TodayNum+1
	If Int(Temp)>Int(YxBBs.MaxEssayNum) Then
		YxBBs.Execute("Update [YX_Config] set MaxEssayNum="&Temp&"")
	End If
	Session(YxBBs.CacheName & "MyInfo") = Empty
	'更新系统
	Cache.Name="Config"
	Cache.clean()
	'更新版块
	Cache.Name="BoardInfo"
	Cache.clean()
End Sub
%>