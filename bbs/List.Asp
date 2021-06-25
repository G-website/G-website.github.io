<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/Page_Cls.Asp"-->
<%
Dim PageString,strPageInfo,orderby,SqlWhere
orderby=Lcase(Request.QueryString("orderby"))
Select Case orderby
Case"addtime"
	SqlWhere="AddTime desc"
Case"hits"
	SqlWhere="Hits desc"
Case"replynum"
	SqlWhere="ReplyNum desc"
Case Else
	SqlWhere="LastTime desc"
End Select
YxBBs.CheckBoard()
YxBBs.Head("")
If YxBBs.BoardChild>0 Then PageString=ShowBoard()
If YxBBs.BoardDepth>0 Then PageString=PageString&ShowListTop()&ShowTopic()&ShowListBottom()

Response.Write(PageString)
YxBBs.Footer()
Set YxBBs=Nothing
'获得下级论坛
Function ShowBoard()
	Dim Temp,i,BoardTop,BoardList,BoardBottom,BoardStr
	BoardTop=YxBBs.Template.ReadTemplate("分区表格")
	BoardList=YxBBs.Template.ReadTemplate("版块列表")
	BoardBottom=YxBBs.Template.ReadTemplate("分区底部表格")
	For i=0 To Ubound(YxBBs.Board_Rs,2)
		Temp=""
		If Int(YxBBs.Board_Rs(1,i))=YxBBs.BoardID Then
			Temp = Temp & Replace(BoardTop,"{分类名称}",YxBBs.Board_Rs(3,i))
		ElseIf YxBBs.Board_Rs(2,i)=YxBBs.BoardID Then
			Temp=BoardList
			Temp=YxBBs.GetBoardInfo(Temp,i)
		End If
		BoardStr=BoardStr & Temp
	Next
	ShowBoard = BoardStr& BoardBottom & VbCrlf
End Function

Function Showonline()
	Dim Temp,BoardOnline,BoardUserOnline
	Temp=YxBBs.Template.ReadTemplate("版块在线")
	Temp=Replace(Temp,"{在线列表}","<span id=showon></span>")
	BoardOnline=YxBBs.Execute("select count(ID) from [YX_online] where BoardID="&YxBBs.BoardID&"")(0)
	Temp=Replace(Temp,"{在线信息}","论坛总在线：<b>"&YxBBs.AllOnlineNum&"</b>人，本版在线：<b>"&BoardOnline&"</b>人，本版有<b> "&YxBBs.UserOnlineNum&"</b> 会员和 <b>"&BoardOnline-YxBBs.UserOnlineNum&"</b> 游客在线。本版今日帖子<Font color=red>"&YxBBs.BoardTodayNum&"</Font>篇 ")
	If Session(YxBBs.CacheName&"online")="1" then
		Temp=Replace(Temp,"{在线列表开关}","<a target='hiddenframe' href='Online.Asp?Action=LoadIng&BoardID="&YxBBs.BoardID&"' onClick='ShowOnline();' ><span id='Showtxt' >关闭详细列表</span></a>")
		Temp=Temp&"<iframe name='hiddenframe' frameborder='0'  height='0' src='Online.Asp?Action=LoadIng&BoardID="&YxBBs.BoardID&"&id=1' id='hiddenframe'></iframe>"
	Else
		Temp=Replace(Temp,"{在线列表开关}","<a target='hiddenframe' href='Online.Asp?Action=LoadIng&BoardID="&YxBBs.BoardID&"' onClick='ShowOnline();' ><span id='Showtxt' >显示详细列表</span></a>")
		Temp=Temp&"<iframe name='hiddenframe' frameborder='0' height='0' id='hiddenframe'></iframe>"	
	End If
	ShowOnline=Temp
End Function

Function ShowListTop()
	Dim Temp,Button,PostPic,Brule,rs
	PostPic=Split(YxBBs.Template.ReadTemplate("发帖图片"),"||")
	Button="<a href='Say.Asp?BoardID="&YxBBs.BoardID&"'>"&PostPic(0)&"</a> <a href='Say.Asp?action=vote&BoardID="&YxBBs.BoardID&"'>"&PostPic(1)&"</a>"
	Temp=YxBBs.Template.ReadTemplate("主题列表顶部")
	Temp=Replace(Temp,"{发帖按钮}",Button)
	Temp=Replace(Temp,"{版主}",YxBBs.BoardAdmin)
	Temp=Replace(Temp,"{版块ID}",YxBBs.BoardID)
	Temp=Replace(Temp,"{数据表ID}",YxBBs.TB)
        Set Rs=YxBBs.execute("select Brule from [YX_Board] where BoardID="&YxBBs.BoardID&"")
        If Rs("Brule")<>"" Then 
        Temp=Replace(Temp,"{公告}",""&Rs("Brule")&"")
	Else  
	Temp=Replace(Temp,"{公告}","")
	End If

If YxBBs.BBSSetting(10)="0" then Temp=Replace(Temp,"{显示在线}",ShowOnline()) Else Temp=Replace(Temp,"{显示在线}","")
ShowListTop=Temp
End Function

Function ShowListBottom()
	Dim Temp,StrSearch,ppost
	StrSearch="<form name=search method=""post"" style=""margin:0"" action=""Search.Asp?SType=2&STime=0&tb="&YxBBs.TB&"&BoardID="&YxBBs.BoardID&""">快速搜索： <input name=""Key"" size=20 onkeyup=""ValidateTextboxAdd(this,'BtnSearch')"" onpropertychange=""ValidateTextboxAdd(this,'BtnSearch')""> <input name=""BtnSearch"" type=submit  value=' 搜 索 ' disabled></form>"
ppost="<select onchange=if(this.options[this.selectedIndex].value!=''){location='list.Asp?boardID="&yxbbs.BoardID&"&orderby='+this.options[this.selectedIndex].value;} style='font-size: 9pt'><option>帖子显示</option><option value='LastTime'>回复时间</option><option value='addtime'>发帖时间</option><option value='replynum'>回复数量</option><option value='hits'>浏览次数</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"
	Temp=YxBBs.Template.ReadTemplate("主题列表底部")
	Temp=Replace(Temp,"{分页}",strPageInfo)
	Temp=Replace(Temp,"{快速搜索}",StrSearch)
	Temp=Replace(Temp,"{版块下拉列表}",ppost&YxBBs.BoardList(2))

	ShowListBottom=Temp
End Function

Function ShowTopic()
	Dim intPageNow,arr_Rs,i,Pages,TopicImg,Conut,page
	Dim Temp,TopicS,Caption,Facepic,Moodpic,LastRe,RePageUrl,UploadType,RePage,leftn,ii
	intPageNow = Request.QueryString("page")
	Set Pages = New Cls_PageView
	Pages.strTableName = "[YX_Topic]"
	Pages.strPageUrl = "?BoardID="&YxBBs.BoardID&"&orderby="&orderby
	Pages.strFieldsList = "TopicID,Face,Caption,Name,TopType,IsGood,AddTime,BoardID,LastTime,Hits,LastReply,UploadType,IsVote,ReplyNum,SqlTableID,IsLock,TitleType"
	Pages.strCondiction = "(BoardID="&YxBBs.BoardID&" or TopType=4 or TopType=5)  And IsDel=False "
	Pages.strOrderList = "TopType desc,"&SqlWhere
	Pages.strPrimaryKey = "TopicID"
	Pages.intPageSize = Int(YxBBs.BBSSetting(26))
	Pages.intPageNow = intPageNow
	Pages.strCookiesName = "BBSList"&YxBBs.BoardID'客户端记录总数
	Pages.Reloadtime=3'每三分钟更新Cookies
	Pages.strPageVar = "page"
	Pages.InitClass
	Arr_Rs = Pages.arrRecordInfo
	strPageInfo = Pages.strPageInfo
	Set Pages = nothing
	If IsArray(Arr_Rs) Then
		TopicImg=Split(YxBBs.Template.ReadTemplate("帖子状态图片"),"|")
		For i = 0 to UBound(Arr_Rs, 2)
			Moodpic=TopicImg(6)
			If Arr_Rs(13,i) > Int(YxBBs.BBSSetting(24)) Then Moodpic=TopicImg(5)
			If Arr_Rs(5,i) Then Moodpic=TopicImg(3)'精华
			If Arr_Rs(15,i) Then Moodpic=TopicImg(7)'锁定
			If Arr_Rs(12,i) Then Moodpic=TopicImg(4)'投票
			If Arr_Rs(4,i)=5 Then Moodpic=TopicImg(0)'总顶
			If Arr_Rs(4,i)=4 Then Moodpic=TopicImg(1)'区顶
			If Arr_Rs(4,i)=3 Then Moodpic=TopicImg(2)'顶
                        If Arr_Rs(4,i)<>4 or (Arr_Rs(4,i)=4 And InStr(YxBBs.BoardRoots,"|"&Arr_Rs(7,i)&"|"))>0 Then
                                Facepic=""
                                If Arr_Rs(1,i)<>99 then Facepic="<img src='Images/face/"&Arr_Rs(1,i)&".gIf'>"
				UploadType=""
				If Arr_Rs(11,i)<>"" Then Facepic="<img title='此帖子含有附件' src='Inc/Editor/Images/common.gif' border=0> "

                                
				LastRe=split(Arr_Rs(10,i),"|")
				RePage=(Arr_Rs(13,i)+1)\10
				If RePage<(Arr_Rs(13,i)+1)/10 Then RePage=RePage+1
				RePageUrl="Show.Asp?ID="&Arr_Rs(0,i)
				leftn=int(YxBBs.BBSSetting(62))
				If RePage>1 Then leftn=leftn-4
				Caption=UploadType
				Caption=Caption&"<a href="&Repageurl&">"&YxBBs.Cvt("<span title='发布时间："&Arr_Rs(6,i)&"-"&leftn&"<br>最后回复："&YxBBs.Fun.StrLeft(LastRe(1),20)&"'>"&YxBBs.Fun.StrLeft(Arr_Rs(2,i),leftn)&"</span>",Arr_Rs(16,i))&"</a>"
					If Repage>1 Then
	Caption=Caption&" [<img src='images/Edit.gif'><b> "
	If RePage<=5 Then
		For ii=2 To RePage
			Caption=Caption&"<a href='"&RePageurl&"&page="&ii&"'><font color=red>"&ii&"</font></a> "
		Next
	Else
		For ii=2 To 4
			Caption=Caption&"<a href='"&RePageurl&"&page="&ii&"'><font color=red>"&ii&"</font></a> "
		Next
			Caption=Caption&"... <a href='"&RePageurl&"&page="&RePage&"'><font color=red>"&RePage&"</font></a>"
	End If
	Caption=Caption&"</b> ]"
	End If
	dim newtime
       newtime=YxBBs.BBSSetting(4)
				If Datediff("n",Arr_Rs(8,i),YxBBs.NowbbsTime)<=int(YxBBs.BBSSetting(4)) Then Caption=Caption&" "&TopicImg(8)
				Temp=YxBBs.Template.ReadTemplate("主题列表")
				Temp=Replace(Temp,"{状态}","<a href="&Repageurl&" target='_blank'>"&Moodpic&"</a>")
				Temp=Replace(Temp,"{表情}",Facepic)
				Temp=Replace(Temp,"{用户名称}","<a href='Profile.Asp?name="&Arr_Rs(3,i)&"' title='查看 "&Arr_Rs(3,i)&" 的资料'>"&Arr_Rs(3,i)&"</a>")
				Temp=Replace(Temp,"{回复数}",Arr_Rs(13,i))
				Temp=Replace(Temp,"{点击数}",Arr_Rs(9,i))
				Temp=Replace(Temp,"{最后时间}","<font title='时间："&FORMATDATETIME(Arr_Rs(8,i),3)&"'>"&Datepart("yyyy",Arr_Rs(8,i))&"-"&Right(00&Datepart("m",Arr_Rs(8,i)),2)&"-"&Right(00&Datepart("D",Arr_Rs(8,i)),2)&"</font>")
				Temp=Replace(Temp,"{回复用户名称}","<a href='Profile.Asp?name="&LastRe(0)&"' title='查看 "&LastRe(0)&" 的资料'>"&LastRe(0)&"</a>")
                                Temp=Replace(Temp,"{主题}",Caption)
				TopicS=TopicS&Temp
			End If
		Next
	End If
	ShowTopic=TopicS
End Function
%>