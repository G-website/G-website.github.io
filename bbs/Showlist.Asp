<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/page_Cls.Asp"-->
<%
Dim Action,PageUrl,SqlWhere,Caption,Content,strPageInfo,TextInfo
If Not YxBBs.Founduser Then YxBBs.Error("您还没有注册或者登陆！")
If YxBBs.BoardID>0 Then
	YxBBs.CheckBoard()
	SqlWhere="BoardID="&YxBBs.BoardID&" And IsDel=False And "
Else
	SqlWhere="IsDel=False And "
End If


Action=Lcase(Request.QueryString("Action"))
Select Case Action
Case"mysay"
	Call YxBBs.Head("我的帖子")
	SqlWhere=SqlWhere&"Name='"&YxBBs.MyName&"'"
Case"myreply"
	Call YxBBs.Head("我的回复")
	SqlWhere=SqlWhere&"Name<>'"&YxBBs.MyName&"' and (TopicID in (select ReplyTopicID from [YX_bbs"&YxBBs.TB&"] where name='"&YxBBs.MyName&"'))"
Case"mygood"
        Call YxBBs.Head("我的精华帖子")
	SqlWhere=SqlWhere&"name='"&YxBBs.MyName&"' and IsGood"
Case"hot"
	Call YxBBs.Head("最旺人气帖")
	SqlWhere =SqlWhere& " Hits>100"
Case"good"
		Call YxBBs.Head("精华主题")
		SqlWhere =SqlWhere& " IsGood"
Case"new"
		Call YxBBs.Head("今日新帖")
		SqlWhere =SqlWhere& " DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')<1"
Case"48h"
		Call YxBBs.Head("48小时内新帖")
		SqlWhere =SqlWhere& " DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')<2"
	Case"week"
		Call YxBBs.Head("一周内新帖")
		SqlWhere =SqlWhere& " DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')<7"
	
	Case"reply"
		Call YxBBs.Head("最旺回复主题")
		SqlWhere =SqlWhere& " ReplyNum>9"
Case Else
	YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
End Select
If YxBBs.BoardID=0 Then
	PageUrl="?Action="&Action
Else
 	PageUrl="?Action="&Action&"&BoardID="&YxBBs.BoardID
End If
Response.Write ShowTopic()&ShowListBottom()
YxBBs.Footer()
Set YxBBs=Nothing



Function ShowListBottom()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("各项列表底部")
	Temp=Replace(Temp,"{分页}",strPageInfo)
	ShowListBottom=Temp
End Function

Function ShowTopic()
	Dim intPageNow,arr_Rs,i,pages,TopicImg,Conut,page
	Dim Temp,TopicS,Caption,Facepic,Moodpic,LastRe,RePageUrl,UploadType,RePage,leftn,ii
	Temp=YxBBs.Template.ReadTemplate("各项列表顶部")
	TopicS=Replace(Temp,"{标题}",YxBBs.Stats )
	intPageNow = Request.QueryString("page")
	Set pages = New Cls_PageView
	pages.strTableName = "[YX_Topic]"
	pages.strPageUrl = PageUrl
	pages.strFieldsList = "Top 200 TopicID,Face,Caption,Name,TopType,IsGood,AddTime,BoardID,LastTime,Hits,LastReply,UploadType,IsVote,ReplyNum,SqlTableID,IsLock"
	pages.strCondiction = SqlWhere
	pages.strOrderList = "TopType desc,LastTime desc"
	pages.strPrimaryKey = "TopicID"
	pages.intPageSize = Int(YxBBs.BBSSetting(26))
	pages.intPageNow = intPageNow
	pages.strCookiesName = "BBSList"&Action&YxBBs.BoardID
	pages.Reloadtime=3
	pages.strPageVar = "page"
	'pages.intRefresh = 0
	pages.InitClass
	Arr_Rs = pages.arrRecordInfo
	strPageInfo = pages.strPageInfo
	Set pages = nothing
	If IsArray(Arr_Rs) Then
	TopicImg=Split(YxBBs.Template.ReadTemplate("帖子状态图片"),"|")
	For i = 0 to UBound(Arr_Rs, 2)
	Moodpic=TopicImg(6)
	If Arr_Rs(13,i) > Int(YxBBs.BBSSetting(24)) Then Moodpic=TopicImg(5)
	If Arr_Rs(5,i) Then Moodpic=TopicImg(3)'精华
	If Arr_Rs(15,i) Then Moodpic=TopicImg(7)'锁定
	If Arr_Rs(12,i) Then Moodpic=TopicImg(4)'投票
	If Arr_Rs(4,i)=5 Then Moodpic=TopicImg(0)'总顶
	If Arr_Rs(4,i)=4 Then Moodpic=TopicImg(1)
	If Arr_Rs(4,i)=3 Then Moodpic=TopicImg(2)'顶
	                Facepic=""
                                If Arr_Rs(1,i)<>99 then Facepic="<img src='Images/face/"&Arr_Rs(1,i)&".gIf'>"
				UploadType=""
				If Arr_Rs(11,i)<>"" Then Facepic="<img title='此帖子含有附件' src='Inc/Editor/Images/common.gif' border=0> "
	LastRe=split(Arr_Rs(10,i),"|")
	RePage=(Arr_Rs(13,i)+1)\10
	If RePage<(Arr_Rs(13,i)+1)/10 Then RePage=RePage+1
	RePageUrl="Show.Asp?ID="&Arr_Rs(0,i)
	leftn=50
	If RePage>1 Then leftn=36
	If Repage>10 Then leftn=30
	Caption=UploadType
	Caption=Caption&"<a href="&Repageurl&" title='主题发布时间："&Arr_Rs(6,i)&"<br>最后回复内容："&YxBBs.Fun.StrLeft(LastRe(1),20)&"'>"&YxBBs.Fun.StrLeft(Arr_Rs(2,i),leftn)&"</a>"
	If Repage>1 Then
		Caption=Caption&" <a href='"&RePageurl&"&page="&RePage&"'>[<font color=#FF0000>"&RePage&"</font>]</a>"
	End If
	If Datediff("n",Arr_Rs(8,i),YxBBs.NowbbsTime)<=180 Then Caption=Caption&TopicImg(8)
	Temp=YxBBs.Template.ReadTemplate("主题列表")
	Temp=Replace(Temp,"{状态}","<a href="&Repageurl&" target='_blank'>"&Moodpic&"</a>")
	Temp=Replace(Temp,"{主题}",Caption)
	Temp=Replace(Temp,"{表情}",Facepic)
	Temp=Replace(Temp,"{用户名称}","<a href='Profile.Asp?name="&Arr_Rs(3,i)&"' title='查看 "&Arr_Rs(3,i)&" 的资料'>"&Arr_Rs(3,i)&"</a>")
	Temp=Replace(Temp,"{回复数}",Arr_Rs(13,i))
	Temp=Replace(Temp,"{点击数}",Arr_Rs(9,i))
	Temp=Replace(Temp,"{最后时间}","<font title='时间："&FORMATDATETIME(Arr_Rs(8,i),3)&"'>"&Datepart("yyyy",Arr_Rs(8,i))&"-"&Right(00&Datepart("m",Arr_Rs(8,i)),2)&"-"&Right(00&Datepart("D",Arr_Rs(8,i)),2)&"</font>")
	Temp=Replace(Temp,"{回复用户名称}",LastRe(0))
	TopicS=TopicS&Temp
	Next
	End If
	ShowTopic=TopicS
End Function

%>