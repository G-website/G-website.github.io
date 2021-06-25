<!--#include file="Inc/SysConfig.Asp"-->
<%
Dim Caption,Action,Submiturl,bbsCaption,ThisFace,IsTitle,BbsContent,Quote,Page,bbsVote,ID,Rs,rs1
If Not YxBBs.Founduser then YxBBs.Error("您还没有注册或者登陆！")
YxBBs.CheckBoard()
ID=YxBBs.CheckNum(Request.QueryString("ID"))
Page=YxBBs.CheckNum(Request.QueryString("page"))
IsTitle=True
Action=lcase(Request.QueryString("action"))
Select Case Action
	Case"vote"
		Vote()
	Case"reply"
		Reply()
	Case"edit"
		Edit()
	Case Else
		YxBBs.Stats="发表新帖"
		Caption=YxBBs.Stats
		bbsCaption="<input name='Caption' type='text' style='width:80%' maxlength=200>"
		Submiturl="Save.Asp?BoardID="&YxBBs.BoardID&""
End Select
YxBBs.Head(YxBBs.Stats)
Set Rs=YxBBs.Execute("Select Name,GradeNum From [YX_user]where Name='"&YxBBs.MyName&"' And PassWord='"&YxBBs.MyPwd&"' And ID="&YxBBs.MyID&"")%>

<script type="text/javascript" charset="utf-8" src="Inc/Editor/Editor.js"></script>
   <script type="text/javascript">
      KE.show({
          id : 'content',
          cssPath : 'Inc/Editor/images/tinymce.css'
      });
      function clearEditor(id) {
          KE.g[id].iframeDoc.open();
          KE.g[id].iframeDoc.write(KE.util.getFullHtml(id));
          KE.g[id].iframeDoc.close();
          KE.g[id].newTextarea.value = '';
      }
      function insertHtml(id, html) {
          KE.util.focus(id);
          KE.util.selection(id);
          KE.util.insertHtml(id, html);
      }
    </script>
<%
ShowMain()
YxBBs.Footer()
Set YxBBs=Nothing

Sub Vote()
	Dim Temp,i
	Temp=YxBBs.BoardSetting(4)
	If Cint(YxBBs.ClassSetting(3))=0 Then YxBBs.Error("您没有查看投票的权限！")
	bbsVote="<tr><td valign=top><br><b>&nbsp;投票选项：<b></td><td>&nbsp;请选择投票项目数：<SELECT align=absmiddle name=VoteNum id=VoteNum onchange=SetNum(this)>"
	for i = 2 to int(Temp)
		bbsVote=bbsVote&"<option value='"&I&"'>"&I&"</option>"
	Next
	bbsVote=bbsVote&"</SELECT> 允许多选 <input type='checkbox' name='VoteType' value='2'> 过期时间：<select size='1' name='OutTime' ><option value='1'>一天</option><option value='3'>三天</option><option value='7'>一周</option><option value='15'>半个月</option><option value='31'>一个月</option><option value='93'>三个月</option><option value='365'>一年</option><option value='10000' selected>不过期</option></select><hr size=1 width='98%'><span id=optionid><table cellpadding=0 cellspacing=3 width='100%' border=0><tr><td>选项1：</td><td><input type='text' name='Votes1' style='width:300'></td></tr><tr><td>选项2：</td><td><input type='text' name='Votes2' style='width:300'><INPUT TYPE='hidden' name='AutoValue' value='2'></td></tr></table></span></td></tr>"
	YxBBs.Stats="发表新投票"
	Caption="发表新投票"
	bbsCaption="<input name='Caption' type=text style='width:80%' maxlength=200>"
	Submiturl="Save.Asp?BoardID="&YxBBs.BoardID
End Sub

Sub Reply()
	Dim Rs,BbsID,TopicCaption
	if Id=0 Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
	If Cint(YxBBs.ClassSetting(3))=0 Then YxBBs.Error(12)
	YxBBs.Stats="回复帖子"
	IsTitle=False
	Set Rs=YxBBs.Execute("Select Caption,SqlTableID,IsLock From [YX_Topic] where TopicID="&ID)
	If Rs.Eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	ElseIf Rs(2) Then
		YxBBs.Error("该帖子已经被锁定！")
	Else
		TopicCaption=Rs(0)
		YxBBs.TB=Rs(1)
	End If
	Set Rs=Nothing
	bbsCaption=" <input type=hidden name='Caption' value='Re:"&TopicCaption&"'>"
	Caption="回复主题："&TopicCaption
	Submiturl="Save.Asp?Action=Reply&BoardID="&YxBBs.BoardID&"&TB="&YxBBs.TB&"&ID="&ID&"&page="&page&""
	BbsID=YxBBs.CheckNum(Request.QueryString("BbsID"))
	If BbsID<>"" Then
		Set Rs=YxBBs.Execute("select top 1 B.ReplyTopicID,B.TopicID,B.Name,B.AddTime,B.Content,B.BoardID,U.IsShow from [YX_Bbs"&YxBBs.TB&"] As B inner join [YX_User] As U on B.Name=U.Name where B.BbsID="&BbsID&" And B.IsDel=False")
			If Not Rs.Eof Then
				If Rs(1)<>ID And Rs(0)<> Id Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
				If Rs(6) Then
					BbsCaption=BbsCaption &"<Font Color=Red>屏蔽内容不能引用</Font>"
				Else
					BbsCaption=BbsCaption &" <Font Color=Red>引用 "&Rs(2)&" 的发言</Font>"
					Quote="<tr><td>&nbsp;<b>引用的内容：<input name='QuoteName' type='hidden' value='[quote]以下是引用  <font color=0000FF>"&Rs(2)&"</font>  在( "&Rs(3)&" )的发言："&chr(10)&chr(10)&"'></b><br>&nbsp;可以编辑要引用的内容</td><td width='76%'>&nbsp;<TEXTAREA name='Quote'  cols=90 rows='5' style='WIDTH: 95%;'>"&YxBBs.Fun.StrLeft(QuoteCode(Rs(4)),500)&"</textarea></td>"
				End If
			End if
		Set Rs=Nothing
	End If
End Sub

Sub Edit()
	Dim Rs,BbsID,TopicIsLock,TopicRs,IsTop,Content
	BbsID=YxBBs.CheckNum(Request.QueryString("BbsID"))
	IF BbsID=0 Or ID=0 Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
	Set Rs=YxBBs.Execute("Select BoardID,TopType,SqlTableID,IsLock,TitleType,face From [YX_Topic] where IsDel=False And TopicID="&ID)
	If Rs.Eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		TopicRs=Rs.GetRows(-1)
	End If
	Rs.Close
	'如果是总顶或顶
	Set Rs=YxBBs.Execute("select BoardID,Name,AddTime,TopicID,Caption,Content,IsDel From [YX_Bbs"&TopicRs(2,0)&"] where IsDel=False And BbsID="&BbsID&"")
	Set Rs1=YxBBs.Execute("select face From [YX_Topic] where TopicID="&ID)
	If Rs.eof  Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		If Not(TopicRs(1,0)=5 or TopicRs(1,0)=4) and TopicRs(0,0)<>YxBBs.BoardID Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
		If lcase(YxBBs.MyName)<>lcase(rs("name")) Then
			If Cint(YxBBs.ClassSetting(18))=0 Then YxBBs.Error("您没有编辑别人帖子的权限！")
		Else
			'编辑自己帖子的权限
			If Cint(YxBBs.ClassSetting(9))=0 Then YxBBs.Error("您没有编辑自己帖子的权限！")
		End If
		If YxBBs.ClassID>2 And Not YxBBs.IsBoardAdmin Then
			If YxBBs.BBSSetting(31)<>0 Then If lcase(YxBBs.MyName)=lcase(rs("name")) And DateDiff("s",Rs("AddTime")+YxBBs.BBSSetting(31)/1440,YxBBs.NowBbsTime)>0 Then YxBBs.Error("你超过了允许普通用户编辑自己帖子的时限 (发帖后<Font color=red>"&YxBBs.BBSSetting(31)&"</Font>分钟内)")
			If lcase(YxBBs.MyName)=lcase(rs("name")) And TopicRs(3,0) Then YxBBs.Error("该帖子已经被锁定！")
		End If
		BbsCaption=rs("Caption")
				IF Rs("TopicID")=0 Then
			IsTitle=False
			bbsCaption="<input type=hidden name='Caption' value='"&BbsCaption&"'>编辑回复帖"
		Else 
			bbsCaption="<input name='Caption' type=text value='"&bbsCaption&"' size=70 maxlength=200><input type=hidden name=OldTitleType value='"&TopicRs(4,0)&"'>"
		End If
		ThisFace=Rs1("Face")
		BbsContent=replaceUBB(rs("Content"))
	End if
	Rs.Close
	YxBBs.Stats="编辑帖子"
	Caption=YxBBs.Stats
	Submiturl="Save.Asp?Action=Edit&ID="&ID&"&BbsID="&BbsID&"&BoardID="&YxBBs.BoardID&"&TB="&YxBBs.TB&"&page="&page&""
End Sub

Function QuoteCode(str)
	Dim re,restr
	Set re=new RegExp
	re.IgnoreCase=true
	re.Global=True
	restr="[COLOR=RED]…… 加密内容不能引用 ……[/COLOR]"
	re.Pattern="(\[DATE=(.[^\[]*)\])(.[^\[]*)(\[\/DATE\])"
	str=re.Replace(str,restr)
	re.Pattern="(\[SEX=*([0-1]*)\])(.[^\[]*)(\[\/SEX\])"
	str=re.Replace(str,restr)
	re.Pattern="(\[COIN=*([0-9]*)\])(.[^\[]*)(\[\/COIN\])"
	str=re.Replace(str,restr)		
	re.Pattern="(\[USERNAME=(.[^\[]*)\])(.[^\[]*)(\[\/USERNAME\])"
	str=re.Replace(str,restr)	
	re.Pattern="(\[GRADE=*([0-9]*)\])(.[^\[]*)(\[\/GRADE\])"
	str=re.Replace(str,restr)	
	re.Pattern="(\[MARK=*([0-9]*)\])(.[^\[]*)(\[\/MARK\])"		
	str=re.Replace(str,restr)
	re.Pattern="(\[BUYPOST=*([0-9]*)\])(.[^\[]*)(\[\/BUYPOST\])"
	str=re.Replace(str,restr)
	re.Pattern=vbcrlf&vbcrlf&vbcrlf&"(\[RIGHT\])(\[COLOR=(.[^\[]*)\])(.[^\[]*)(\[\/COLOR\])(\[\/RIGHT\])"
	str=re.Replace(str,"")
	re.Pattern="(<p align=right><font color=#0080FF>「该帖子被(.*)编辑过」</font></p>)" 
	str=re.Replace(str," ")
	Str = Replace(Str, chr(10), "")
	re.Pattern="(\[reply\])(.+?)(\[\/reply\])"
	str=re.Replace(str,restr)	
	set re=Nothing
	QuoteCode=str
End Function

Function replaceUBB(str)
	dim re
	If Str="" Then Exit Function
	Set re=new RegExp
	re.IgnoreCase=true
	re.Global=True
	re.Pattern="(>)("&vbNewLine&")(<)"
	Str=re.Replace(Str,"$1$3")
	re.Pattern="(>)("&vbNewLine&vbNewLine&")(<)"
	Str=re.Replace(Str,"$1$3")
	re.Pattern=vbNewLine
	Str=re.Replace(Str,"<br>")	
        re.Pattern="(<p align=right><font color=#0080FF>(.[^\[]*)</font></p>)"
        str=re.Replace(str," ")
	str=Replace(Str,"  ","&nbsp;&nbsp;")
	Set re=Nothing
	replaceUBB=str
End function

Function ShowMain()
	Dim Temp,Face,I,J     
	Temp=Temp&"<tr><td><form style='margin:0;' method=POST name='topicform' action='"&Submiturl&"' ><table border='1' align='center' cellpadding='5' cellspacing='0' style='width:100%; text-align:left;'>"
	If IsTitle Then
		Temp=Temp&"<tr><td width='24%' height='30'><b>&nbsp;帖子主题：</b><select name=title onChange=DoTitle(this.options[this.selectedIndex].value) style='font-size: 9pt'><option selected value="""">话题</option><option value=[原创]>[原创]</option><option value=[转帖]>[转帖]</option><option value=[分享]>[分享]</option><option value=[求助]>[求助]</option><option value=[推荐]>[推荐]</option><option value=[公告]>[公告]</option><option value=[注意]>[注意]</option><option value=[贴图]>[贴图]</option><option value=[建议]>[建议]</option><option value=[下载]>[下载]</option><option value=[视频]>[视频]</option><option value=[源码]>[源码]</option><option value=[经验]>[经验]</option></select></td><td>"
	Else
		Temp=Temp&Quote&"<tr><td colspan=2 height='30'>"
	End If
	
	If Action="reply" Then
		Temp=Temp&"&nbsp;"&bbsCaption&"</td></tr>"
	Else
		Temp=Temp&"&nbsp;"&bbsCaption&"&nbsp;&nbsp;<select name=""topicximoo""><option value=0>标题醒目</option><option value=1>红色醒目</option><option value=2>蓝色醒目</option><option value=3>绿色醒目</option></select></td></tr>"
	Temp=Temp&"<tr><td width='24%'>&nbsp;<b>图标：</b></td><td>"


Face="&nbsp;<input name=face type=radio value=99 checked>无&nbsp;<script>for(i=1;i<=9;i=i+1) {document.write(""<input type=radio value=""+i+"" name=face><img border=0 src=images/face/""+i+"".gif>"")}</script>"
        End If
	Temp=Temp&Face&"</td></tr>"&bbsVote&"<tr><td>&nbsp;<b>附件上传类型：</b>&nbsp;"&Join(Split(YxBBs.BoardSetting(1),"|"),",")&"</td><td>"
	
        If Int(Rs("GradeNum"))<Int(YxBBs.BBSSetting(36)) then
		Temp=Temp&"您的等级未达到 <B><font Color=red>"&YxBBs.BBSSetting(36)&"级</font></B> 不能上传文件！<br>"
        Else
		Temp=Temp&"<table border=0 cellpadding=0 cellspacing=0><tr><td>&nbsp;<input type=""hidden"" name=""topicpic""><iframe Src='ViewFile.Asp?Action=Upload&BoardID="&YxBBs.BoardID&"' scrolling='no' frameborder='0' height='20' width='260'></iframe></td><td>[每日您可以上传 <font color=blue>"&YxBBs.ClassSetting(11)&"</font> 个 小于 <font color=blue>"&YxBBs.ClassSetting(12)&"</font> KB / 每个]</td></tr></table>"
               
        End if
	
	Temp=Temp&"</td></tr><tr><td valign='top'><table width='100%'  border='0' cellpadding='0' cellspacing='4'><tr><td colspan='2'><b>发特殊帖：</b></td></tr>"
	Temp=Temp&"<tr><td rowspan='4' width=10 ></td></tr><tr><td><br><li><a href=""javascript:insertHtml('content', '[Reply]内容[/Reply]');"">回复可见</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=""javascript:insertHtml('content', '[Coin=10]内容[/Coin]');"">金钱可见</a></li><br><li><a href=""javascript:insertHtml('content','[Grade=1]内容[/Grade]');"">等级可见</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=""javascript:insertHtml('content','[Username=昵称]内容[/Username]');"">指定读者</a></li><br><li><a href=""javascript:insertHtml('content','[Buypost=100]内容[/Buypost]');"">付费可见</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=""javascript:insertHtml('content','[Date=2006-10-1]内容[/Date]');"">日期可见</a></li><br><li><a href=""javascript:insertHtml('content','[Sex=1]内容[/Sex]');"">性别可见</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=""javascript:insertHtml('content','[Login]内容[/Login]');"">登陆可见</a></li></td></tr><tr><td><br><li>帖子内容最多允许：<font color=red>"&YxBBs.BoardSetting(3)/1024&"KB</font></li><br><br><li>如发帖失败,按<font color=bule>Ctrl+v</font>可找回内容!</li><br><br></td></tr></table></td>"
	Temp=Temp&"<td width='76%' valign='top'><table border='0' cellpadding='0' cellspacing='3'  width='100%'><tr><td colspan='2'>"
        Temp=Temp&"<textarea name='content' id='content' style='width:100%;height:250px;visibility:hidden;'>"&BbsContent&"</textarea><script type=""text/javascript"">editor.show()</script></tr></table></td></tr><tr><td height='40' colspan='2' align='center'>"
        If Action="edit" And (YxBBs.ClassID<=3) Then Temp= Temp & "<input name='EditChalk' type='checkbox' value='No'>不留下编辑标记 "
	If Cint(YxBBs.BoardSetting(0))=1 Then Temp=Temp&""&YxBBs.GCode&""
	Temp=Temp&"&nbsp;<input class=submit type=submit value=OK_！发表 name='B1' accessKey='S'>&nbsp;&nbsp;&nbsp; <input class=submit type=button value='预  览！' onclick='preview()' name='B3'>&nbsp;&nbsp;&nbsp; <input class=submit type='button' value=NO_！重写 onclick=""javascript:clearEditor('content');"" name=B2>&nbsp; [ 按 Alt+S 直接发送 ]" 
	Temp=Temp&"<font color=#D8D8D8></font></td></tr></table></form></td></tr>"
	Call YxBBs.ShowTable(Caption,Temp)
	Response.Write"<form style='margin:0;' name='form1' action='See.asp?Action=preview' method='post' target='showgg'><input type='hidden' name='Caption' /><input type='hidden' name='content' /></form>"
	End Function
%>
%>