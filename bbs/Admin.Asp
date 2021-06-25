<!--#include file="Inc/SysConfig.Asp"-->
<%
Dim Caption,Content,Rs,ID,Url,Action,SetUserName,GoToUrl,BoardID
YxBBs.Fun.CheckMake()
ID=YxBBs.Checknum(Request.QueryString("ID"))
Action=lcase(Request.QueryString("Action"))
YxBBs.CheckBoard()
URl="Show.Asp?ID="&ID
GoToUrl=True
Call YxBBs.Head("论坛管理")
Select Case Action
Case"精华"
Call cheak()
	If Cint(YxBBs.ClassSetting(19))=0 Then YxBBs.Error("您没有操作精华帖子权限！")
	Set Rs=YxBBs.Execute("Select IsGood,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		IF Rs(0) Then
			YxBBs.Error("该主题帖子已经是精华帖子了！")
		ELse
			YxBBs.Execute("update [YX_Topic] set IsGood=True where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.Execute("update [YX_User] set Coin=Coin+"&YxBBs.BBSSetting(39)&",Mark=Mark+"&YxBBs.BBSSetting(40)&",GoodNum=GoodNum+1 where name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》设为精华，主题ID："&ID,Rs(1),0
		End If
	End If
	Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">设定为精华帖子成功!3秒后返回主题!"
	Rs.Close
	Call Show()
Case"取消精华"
Call cheak()
	If Cint(YxBBs.ClassSetting(19))=0 Then YxBBs.Error("您没有操作精华帖子权限！")
	Set Rs=YxBBs.Execute("Select IsGood,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.Eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		IF Not Rs(0) Then
			YxBBs.Error("该主题帖子不是精华帖子！")
		ELse
			YxBBs.Execute("update [YX_Topic] set IsGood=False where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_User] set Coin=Coin-"&YxBBs.BBSSetting(41)&",Mark=Mark-"&YxBBs.BBSSetting(42)&",GoodNum=GoodNum-1 where name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》取消精华，主题ID："&ID,Rs(1),0
		End If
	End If
	Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">取消帖子精华成功!3秒后返回主题!"
	Rs.Close
	Call Show()
Case"置顶"
Call cheak()
	If Cint(YxBBs.ClassSetting(16))=0 Then YxBBs.Error("您没有置顶主题的权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		IF Rs(0)=5 Then
			YxBBs.Error("该帖子已经是总置顶帖！")
		ElseIf Rs(0)=4 Then
			YxBBs.Error("该帖子已经是区置顶帖！")
		ElseIF Rs(0)=3 Then
			YxBBs.Error("该主题帖子已经被置顶了！")	
		Else
			YxBBs.Execute("update [YX_Topic] Set TopType=3 where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_User] set Coin=Coin+"&YxBBs.BBSSetting(43)&",Mark=Mark+"&YxBBs.BBSSetting(44)&" Where name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》设为置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功将主题设为置顶帖子!3秒后返回主题!"
	End If
	Rs.Close
	Call Show()
Case"取消置顶"
Call cheak()
	If Cint(YxBBs.ClassSetting(16))=0 Then YxBBs.Error("您没有操作置顶主题的权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		IF Rs(0)=5 Then
			YxBBs.Error("该帖子已经是总置顶帖！")
		ElseIf Rs(0)=4 Then
			YxBBs.Error("该帖子已经是区置顶帖！")
		ElseIF Rs(0)<>3 Then
			YxBBs.Error("该主题已经不是置顶帖！")
		Else
			YxBBs.Execute("update [YX_Topic] Set TopType=0 where TopicId="&ID&" ")
			YxBBs.execute("update [YX_User] set Coin=Coin-"&YxBBs.BBSSetting(45)&",Mark=Mark-"&YxBBs.BBSSetting(46)&" Where Name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》取消置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功的取消帖子的置顶!3秒后返回主题!"
	End If
	Set Rs=Nothing
	Call Show()
Case"总置顶"
Call cheak()
	If Cint(YxBBs.ClassSetting(17))=0 Then YxBBs.Error("您没有管理总置顶帖子的权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" or TopType=5)")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Rs(0)=5 Then
			YxBBs.Error("该帖子已经是总置顶主题！")
		Else
			YxBBs.execute("update [YX_Topic] Set TopType=5 where TopicID="&id&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_user] Set Coin=Coin+"&YxBBs.BBSSetting(51)&",Mark=Mark+"&YxBBs.BBSSetting(52)&" where Name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》设为总置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功将帖子设置为总置顶!3秒后返回主题!"
	End If
	Rs.Close
	Call Show()
Case"取消总置顶"
Call cheak()
	If Cint(YxBBs.ClassSetting(17))=0 Then YxBBs.Error("您没有管理总置顶帖子的权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" or TopType=5)")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Rs(0)<>5 Then
			YxBBs.Error("该帖子不是总置顶主题！")
		Else
		YxBBs.execute("update [YX_Topic] set TopType=0 where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
		YxBBs.execute("update [YX_user] set Coin=Coin-"&YxBBs.BBSSetting(53)&",Mark=Mark-"&YxBBs.BBSSetting(54)&" where name='"&SetUserName&"'")
		YxBBs.InLog "将主题《"&Rs(2)&"》取消总置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功的取消帖子的总置顶!3秒后返回主题!"
	End If
	Rs.Close
	Call Show()
Case"区置顶"
Call cheak()
	If Cint(YxBBs.ClassSetting(17))=0 Then YxBBs.Error("您没有管理区置顶帖子的权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" or TopType=4)")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Rs(0)=5 Then
			YxBBs.Error("该帖子已经是总置顶主题！")
		ElseIf Rs(0)=4 Then
			YxBBs.Error("该帖子已经是区置顶主题！")
		Else
			YxBBs.execute("update [YX_Topic] Set TopType=4 where TopicID="&id&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_user] Set Coin=Coin+"&YxBBs.BBSSetting(47)&",Mark=Mark+"&YxBBs.BBSSetting(48)&" where Name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》设为区置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功将帖子设置为区置顶!3秒后返回主题!"
	End If
	Rs.Close	
	Call Show()
Case"取消区置顶"
Call cheak()
	If Cint(YxBBs.ClassSetting(17))=0 Then YxBBs.Error("对不起，您没有管理权限！")
	IF YxBBs.ClassID>2 Then YxBBs.Error("对不起，您没有管理权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" or TopType=4)")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Rs(0)<>4 Then
			YxBBs.Error("该帖子不是区置顶主题！")
		Else
			YxBBs.execute("update [YX_Topic] set TopType=0 where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_user] set Coin=Coin-"&YxBBs.BBSSetting(49)&",Mark=Mark-"&YxBBs.BBSSetting(50)&" where name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》取消区置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功的取消帖子的区置顶!3秒后返回主题!"
	End If
	Rs.Close
	Call Show()
Case"锁定"
Call cheak()
	If Cint(YxBBs.ClassSetting(20))=0 Then YxBBs.Error("您没有锁定主题的权限！")
	Set Rs=YxBBs.execute("Select IsLock,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Rs(0) Then
			YxBBs.Error("该主题帖子已经被锁定！")
		Else
			YxBBs.execute("update [YX_Topic] set IsLock=True where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.InLog "将主题《"&Rs(2)&"》锁定，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">主题已经锁定成功!3秒后返回主题!"
	End If
	Rs.Close			
	Call Show()
Case"解锁"
Call cheak()
	If Cint(YxBBs.ClassSetting(20))=0 Then YxBBs.Error("您没有解除锁定的权限！")
	Set Rs=YxBBs.execute("Select Islock,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Not Rs(0) Then
			YxBBs.Error("该帖子没有被锁定！")
		Else
			YxBBs.execute("update [YX_Topic] set IsLock=False where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.InLog "将主题《"&Rs(2)&"》解除锁定，主题ID："&ID,Rs(1),0
		End IF
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">解除主题锁定成功!3秒后返回主题!"
	End if
	Rs.Close	
	Call Show()

Case"删除主题"
Call cheak()
	If Cint(YxBBs.ClassSetting(14))=0 Then YxBBs.Error("您没有删除主题的权限！")
Set Rs=YxBBs.execute("Select IsDel,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	IF Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
End If
	Caption="删除主题"
	Content="<form method=POST name='move' action='?BoardID="&YxBBs.BoardID&"&ID="&ID&"&TB="&YxBBs.TB&"&Action=删除主题1'> <input type=submit value=' 确定删除 '> <br><br>是否用留言通知帖子的作者：<input name='issms' onclick='if(sms.disabled==true){sms.disabled=false;sms.value=""通知：您的帖子《"&Rs(2)&"》被管理员("&YxBBs.MyName&")删除，原因是：""}else{sms.disabled=true;sms.value="""";}' type='checkbox' value='yes'> <input name='sms' size='50' type='text' value='' disabled='true'></p></form>"
	YxBBs.ShowTable Caption,"<tr><td height=""100"">"&Content&"</td></tr>"
Case"删除主题1"
Call cheak()
        IsSms=YxBBs.Fun.GetStr("issms")
	Sms=YxBBs.Fun.GetStr("sms")
	If Cint(YxBBs.ClassSetting(14))=0 Then YxBBs.Error("您没有删除主题的权限！")
	Set Rs=YxBBs.execute("Select IsDel,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	IF Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Not Rs(0) Then
			GoToUrl=False
			'得出要删除的帖数
			Temp=YxBBs.Execute("Select Count(BbsID) From[YX_bbs"&YxBBs.TB&"] where (TopicID="&ID&" Or  ReplyTopicID="&ID&") And BoardID="&YxBBs.BoardID)(0)
			YxBBs.Execute("update [YX_Topic] set IsDel=True,ReplyNum=0 where TopicID="&ID&" And BoardID="&YxBBs.BoardID)
			YxBBs.Execute("update [YX_Bbs"&YxBBs.TB&"] set IsDel=True where (TopicID="&ID&" Or  ReplyTopicID="&ID&") And BoardID="&YxBBs.BoardID) 
			YxBBs.Execute("update [YX_Config] set AllEssayNum=AllEssayNum-"&Temp&",TopicNum=TopicNum-1")
                        YxBBs.Execute("update [YX_User] set Coin=Coin-"&YxBBs.BBSSetting(59)&",Mark=Mark-"&YxBBs.BBSSetting(60)&" Where Name='"&SetUserName&"'")			
                        YxBBs.Execute("update [YX_Board] set EssayNum=EssayNum-"&Temp&",TopicNum=TopicNum-1 where BoardID="&YxBBs.BoardID&"")
			yxbbs.execute("delete*from [Yx_appraise] where TopicID="&id&"")
                   If IsSms="yes" Then
                YxBBs.Execute("insert into [YX_Sms](name,MyName,Title,Content) values('系统消息','"&SetUserName&"','您的主题被删除通知','"&Sms&"')")
		YxBBs.Execute("update [YX_User] set NewSmsNum=NewSmsNum+1,SmsSize=SmsSize+"&Len(Sms)&" Where Name='"&SetUserName&"'")
                End if
			If YxBBs.BoardDepth>1 Then
				YxBBs.Execute("Update [YX_Board] set TopicNum=TopicNum-1,EssayNum=EssayNum-"&Temp&" where BoardID In ("&YxBBs.BoardParentStr&") And Depth>0")
			End If
			BoardLastRaply()
			YxBBs.InLog "将主题《"&Rs(2)&"》删除，主题ID："&ID,Rs(1),0
		Else
			YxBBs.Error("该帖子不存在或已经删除")
		End IF
		Caption="<meta http-equiv=refresh content=3;url=List.Asp?BoardID="&YxBBs.BoardID&">成功删除主题帖子！"
	End if
	Rs.Close
	Call Show()
Case"删除回复"
Call cheak()
	If Cint(YxBBs.ClassSetting(14))=0 Then YxBBs.Error("您没有删除回复的权限！")
	GoToUrl=False
	Dim BbsID,Temp
	BbsID=YxBBs.CheckNum(Request.QueryString("BbsID"))
	Set Rs=YxBBs.execute("Select IsDel,Name,Caption From [YX_bbs"&YxBBs.TB&"] where ReplyTopicID="&ID&" And BbsID="&BbsID&" And BoardID="&YxBBs.BoardID&"")
	IF Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Not Rs(0) Then
			YxBBs.execute("update [YX_bbs"&YxBBs.TB&"] set IsDel=True where ReplyTopicID="&ID&" And BbsID="&BbsID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_Config] Set AllEssayNum=AllEssayNum-1")
			YxBBs.execute("update [YX_Board] Set EssayNum=EssayNum-1 where BoardID="&YxBBs.BoardID&"")
                        YxBBs.execute("update [YX_Topic] set ReplyNum=ReplyNum-1 where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			Yxbbs.execute("delete*from [Yx_appraise] where BbsID="&BbsID&"")
			If YxBBs.BoardDepth>1 Then
				YxBBs.Execute("Update [YX_Board] set TopicNum=TopicNum-1,,EssayNum=EssayNum-1 where BoardID In ("&YxBBs.BoardParentStr&") And Depth>0")
			End If
			BoardLastRaply()
			YxBBs.InLog "删除回复《"&Rs(2)&"》，主题ID："&ID,Rs(1),0
		Else
			YxBBs.Error("该帖子不存在或已经删除")
		End IF
		Caption="成功删除回复帖子！"
	End if
	Rs.Close
	Call Show()
Case"移动"
Call cheak()
	If Cint(YxBBs.ClassSetting(15))=0 Then YxBBs.Error("您没有移动主题的权限！")
	GoToUrl=False
	Caption="移动帖子"
	Content="<form method=POST name='move' action='?action=move&TB="&YxBBs.TB&"&ID="&ID&"&BoardID="&YxBBs.BoardID&"'><p style='margin: 15'>请选择帖子要移动到的论坛："&GetBoardList()&" <input type=submit value=' 移 动 '> <br><br>是否用留言通知帖子的作者：<input name='issms' onclick='if(sms.disabled==true){sms.disabled=false;sms.value=""通知：您的帖子被管理员("&YxBBs.MyName&")移动了！""}else{sms.disabled=true;sms.value="""";}' type='checkbox' value='yes'> <input name='sms' size='50' type='text' value='' disabled='true'></p></form>"
	YxBBs.ShowTable Caption,"<tr><td height=""100"">"&Content&"</td></tr>"
	
	
	Function Options(A,B,Steps)
	dim I
	For I=A to B Step Steps
	Options=Options&"<option value="&I
	If I=0 Then Options=Options&" selected"
	Options=Options&">"&I&"</option>"
	Next
End Function
	
Case"评帖"
IF YxBBs.ClassID>3 Then YxBBs.Error("管理权限不足！")	
Call cheak()

	BbsID=Yxbbs.CheckNum(request.querystring("BbsID"))
	Set Rs=Yxbbs.execute("Select BbsID From [Yx_bbs"&Yxbbs.TB&"] where BbsID="&BbsID&" And BoardID="&Yxbbs.BoardID&"")
	IF Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
	Caption="帖子评价"
	Content="<br><table align='center'><form method=POST action='?action=appraise&TB="&Yxbbs.TB&"&BbsID="&BbsID&"&ID="&ID&"&BoardID="&Yxbbs.BoardID&"'><tr><td>操作理由：<select name='select' onChange='cause.value=this.options[this.selectedIndex].value'><option selected>帖子评价自定义</option><option value='奖！此帖子不错哦'>奖！此帖子不错哦</option><option value='奖！感谢无私贡献'>奖！感谢无私贡献</option><option value='奖！好文章给奖励'>奖！好文章给奖励</option><option value='罚！本版严禁广告'>罚！本版严禁广告</option><option value='罚！帖子内容违规'>罚！帖子内容违规</option><option value='罚！无聊的乱灌水'>罚！无聊的乱灌水</option><option value='罚！重复发此类帖'>罚！重复发此类帖</option></select>&nbsp;&nbsp;<input name='cause' type='text' value='' size='20' maxlength='10'>最多10个字符</td></tr>"&_
	"<tr><td><br>奖罚操作：积分&nbsp;&nbsp;<select name='mark'>"&Options(-5,5,1)&"</select>&nbsp;&nbsp;&nbsp;金钱&nbsp;&nbsp;<select name='coin'>"&Options(-200,200,10)&"</select>  </td></tr><tr><td align='center'><br><input type='submit' name='Submit' value='确定操作'></td></tr></form></table><br>"
	Call YxBBs.ShowTable(Caption,Content)
	End If

Case"appraise"	
	Dim Cause,mark,Coin
	BbsID=Yxbbs.CheckNum(request.querystring("BbsID"))
	Cause=Yxbbs.Fun.GetStr("cause")
	Mark=Yxbbs.Fun.GetStr("mark")
	Coin=Yxbbs.Fun.GetStr("coin")

	Caption="评帖错误"
	Set Rs=Yxbbs.execute("Select Name From [Yx_bbs"&Yxbbs.TB&"] where BbsID="&BbsID&" And BoardID="&Yxbbs.BoardID&"")
	IF Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	ElseIf Lcase(Rs(0))=Lcase(Yxbbs.MyName) Then
		YxBBs.Error("管理员和版主不能对自己进行评帖！")
	ElseIf Cause="" And (Mark=0 and Coin=0) Then
		YxBBs.Error("请填写完整再提交！")	
	ElseIf Len(Cause)>10 Then
		YxBBs.Error("评帖理由描述不能超过10个字符！")
	Else
		Cause=Yxbbs.Fun.HtmlCode(Cause)
		Yxbbs.execute("insert into [Yx_Appraise](BbsID,TopicID,Cause,Mark,Coin,AdminName,AddTime)VALUES("&BbsID&","&ID&",'"&Cause&"',"&Mark&","&Coin&",'"&Yxbbs.MyName&"','"&Yxbbs.NowBbsTime&"')")
		
		Yxbbs.Execute("Update [Yx_user] set Mark=Mark+"&Mark&",Coin=Coin+"&Coin&" where Name='"&Rs(0)&"'")
		
		Rs.Close
		Yxbbs.Execute("Update [Yx_bbs"&Yxbbs.TB&"] Set IsAppraise=True where BbsID="&BbsID&" And BoardID="&Yxbbs.BoardID&"")
		Caption="评帖成功"
Call Show()
	End If
	
Case"delappraise"	
	IF Yxbbs.classid<>1 Then YxBBs.Error("管理权限不足！")
	BbsID=Yxbbs.CheckNum(request.querystring("BbsID"))
	Yxbbs.Execute("delete from [Yx_appraise] where BbsID="&BbsID&" and TopicID="&ID)
	Yxbbs.Execute("update [Yx_bbs"&Yxbbs.TB&"] set IsAppraise=False where BbsID="&BbsID&" And BoardID="&Yxbbs.BoardID&"")
	Call Show()
	
	
Case"move"
Call cheak()
	If Cint(YxBBs.ClassSetting(15))=0 Then YxBBs.Error("您没有移动主题的权限！")
	Dim IsSms,Sms,TmpBoardID
	GoToUrl=False
	IsSms=YxBBs.Fun.GetStr("issms")
	Sms=YxBBs.Fun.GetStr("sms")
	TmpBoardID=YxBBs.Checknum(Request.form("BoardID"))
	Set Rs=YxBBs.Execute("Select BoardID,Name,Caption From[YX_Topic] where TopicID="&ID&" and BoardID="&YxBBs.BoardID&"")
	YxBBs.execute("update [YX_Topic] Set BoardID="&TmpBoardID&" where TopicID="&ID&"")
	YxBBs.execute("update [YX_bbs"&YxBBs.TB&"] Set BoardID="&TmpBoardID&" where TopicId="&ID&" or ReplyTopicid="&ID&"")
	YxBBs.InLog "将主题《"&Rs(2)&"》从ID为"&Rs(0)&"的版面移动到版面ID为"&TmpBoardID&"的版面，主题ID："&ID,Rs(1),0
	If IsSms="yes" Then
		Sms=Sms&vbcrlf&"主题："&Rs(2)&",被移动到版面ID为"&TmpBoardID&"的版块."
		YxBBs.Execute("insert into [YX_Sms](name,MyName,Title,Content) values('系统消息','"&SetUserName&"','您的主题被移动通知','"&Sms&"')")
		YxBBs.Execute("update [YX_User] set NewSmsNum=NewSmsNum+1,SmsSize=SmsSize+"&Len(Sms)&" Where Name='"&SetUserName&"'")
	End If
	Rs.Close
	BoardLastRaply()
	Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">主题移动成功!3秒后返回主题!"
	Call Show()
Case"提升"
Call cheak()
       If Cint(YxBBs.ClassSetting(21))=0 Then YxBBs.Error("您没有提升主题的权限！")
	YxBBs.Execute("update [YX_Topic] set LastTime='"&YxBBs.NowBbsTime&"' where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	YxBBs.Execute("update [YX_bbs"&YxBBs.TB&"] set LastTime='"&YxBBs.NowBbsTime&"' where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	Set Rs=YxBBs.Execute("Select BoardID,Name,Caption From[YX_Topic] where TopicID="&ID&" and BoardID="&YxBBs.BoardID&"")
	YxBBs.InLog "成功提升主题《"&Rs(2)&"》，主题ID："&ID,Rs(1),0
	Rs.Close
	Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">主题提升成功!3秒后返回主题!"
	Call Show()

Case "editsetting"
Dim BoardSetting,sql,Brule
IF YxBBs.ClassID>3 Then YxBBs.Error("管理权限不足！")
IF  YxBBs.ClassID=3 And YxBBs.IsBoardAdmin=False Then YxBBs.Error("管理权限不足！")
BoardID=Request.form("BoardID")
Brule=YxBBs.Fun.GetStr("Brule")
IF BoardID="" or not isNumeric(BoardID) then
	YxBBs.Error("参数错误码，请确认正确的参数！")
End if
BoardSetting=Request.form("TopicCode") & "," & Request.form("UpLoadType") & "," & Request.form("TopicMaxLong") & "," & Request.form("ArticleMaxLong") & "," & Request.form("BoardMaxVote") & "," & Request.form("UserMinPost") & "," & Request.form("UserMinRemark") & "," & Request.form("UserMinMoneys") & "," & Request.form("UserMinLoginTimes") & "," & Request.form("UserMinDigestNum") & "," & Request.form("UserMinRegTime") & "," & Request.form("ALeast")

If not YxBBs.Fun.CheckIn(BoardSetting) Then
	YxBBs.Error("您输入的信息含有非法内容！")
End If

Set Rs=Server.CreateObject("Adodb.Recordset")
YxBBs.execute("update [YX_Board] Set BoardSetting='"&BoardSetting&"',Brule='"&Brule&"' where BoardID="&BoardID&"")
Set rs=nothing
Cache.name="BoardInfo":Cache.clean()
Caption="操作成功"
Content="<div style='margin:15;line-height: 150%'><li>版块权限设置成功！ <li><a href=?BoardID="&BoardID&">返回版块设置</a></div>"
Call YxBBs.ShowTable(Caption,Content)


Case Else
IF YxBBs.ClassID>3 Then YxBBs.Error("管理权限不足！")
IF  YxBBs.ClassID=3 And YxBBs.IsBoardAdmin=False Then YxBBs.Error("管理权限不足！")
dim ClassID,BoardName
BoardID=Request("BoardID")
if Not IsNumeric(ClassID) then
	YxBBs.Error("参数错误，请从新检查！")
end if

set rs=Conn.execute("Select BoardID,BoardName,BoardSetting,brule from YX_Board where BoardID="& BoardID)
if rs.eof or rs.bof then
	YxBBs.Error("找不到此版块或已删除！")
else
	BoardName=rs("BoardName")
	BoardSetting=split(rs("BoardSetting"),",")
Temp=YxBBs.Template.ReadTemplate("各项列表顶部")
	Temp=Replace(Temp,"{标题}",YxBBs.Stats )
	Response.Write Temp
%>
<form action='?action=editsetting&BoardID=<%=BoardID%>' method=post name='creator'><table cellpadding=6 cellspacing=1 border=0 width=100% align='center'>
 <tr><td width=35% height=20>版块名称</td><td height=20><INPUT TYPE=hidden name=BoardID value=<%=BoardID%> readonly><%=BoardName%></td>
</tr><tr><td colspan=2 height=14><font color=#000077><b>版块相关</b></font></td>
</tr><tr><td height=20>发贴使用验证码</td>
<td height=20>是<input name=TopicCode type=radio value=1
                <%if BoardSetting(0)=1 then%>
                checked>
                <%else%>
                >
		<%end if%>
&nbsp;否<input name=TopicCode type=radio value=0
		<%if BoardSetting(0)=0 then%>
checked></td>
                <%else%>
></td>
                <%end if%>
</tr><tr><td height=20>上传类型</td><td height=0>
<input name=UpLoadType size=20 value=<%=BoardSetting(1)%>></td></tr><tr><td height=20>主题限制长度</td>
<td height=20><input name=TopicMaxLong size=20 value=<%=BoardSetting(2)%>></td></tr><tr>
<td height=26>帖子内容最多字节数</td><td height=26><input name=ArticleMaxlong size=20 value=<%=BoardSetting(3)%>></td>
</tr><tr><td height=20>最多投票项目</td><td height=20>
<input name=BoardMaxVote size=20 value=<%=BoardSetting(4)%> ></td></tr><tr>
</tr><tr><td>版块规则设置<br>* 设置版规的内容支持HTML.<br>* 版规默认支持样式<font color=red>&lt;div class=rule&gt;版规内容&lt;/div&gt;</font><br>* 内容只支持255个字符.  </td><td>
<textarea rows=6 cols=70 name=Brule><%=Rs("Brule")%></textarea></td></tr><tr>
<td colspan=2 height=14><font color=#000077><b>用户相关</b></font></td>		
</tr><tr><td height=20>用户至少文章数</td><td height=20>
<input name=UserMinPost size=20 value=<%=BoardSetting(5)%> ></td></tr><tr>
<td height=20>用户至少积分</td><td height=20>
<input name=UserMinRemark size=20 value=<%=BoardSetting(6)%> ></td>
</tr><tr><td height=20>用户至少金钱</td><td height=20>
<input name=UserMinMoneys size=20 value=<%=BoardSetting(7)%> ></td></tr><tr>
<td height=20>登陆次数至少几次</td><td height=20>
<input name=UserMinLoginTimes size=20 value=<%=BoardSetting(8)%> ></td>
</tr><tr><td height=20>用户至少精华文章</td><td height=20>
<input name=UserMinDigestNum size=20 value=<%=BoardSetting(9)%> ></td>
</tr><tr><td height=20>至少注册时间（单位为分钟）</td><td  height=20>
<input name=UserMinRegTime size=20 value=<%=BoardSetting(10)%> ></td></tr><tr>
<td height=26>帖子内容最少字节数</td><td height=26><input name=ALeast size=20 value=<%=BoardSetting(11)%> ></td></tr><tr>
<td valign=middle colspan=2 align=center height=20><input type=submit value='修 改' name='B1'></td></tr>
</table></form>
<%	
        Temp=YxBBs.Template.ReadTemplate("各项列表底部")
	Temp=Replace(Temp,"{分页}","")
	Response.Write Temp
end if
End Select
YxBBs.Footer()
Set YxBBs=Nothing

Sub Show()
	Dim Temp
	IF GoToUrl Then Temp="<li><a href="&Url&">回到帖子</a></li>"
	Content=Content&Temp&"<li><a href=List.Asp?BoardID="&YxBBs.BoardID&">"&YxBBs.BoardName&"</a></li><li><a href=Default.Asp>返回首页</a>"
	YxBBs.Success Caption,Content
End Sub

Function GetBoardList()
	Dim Temp,I,II,po
	Temp="<select Style='font-size: 9pt' name='BoardID' >"
	If IsArray(YxBBs.Board_Rs) Then
		For i=0 To Ubound(YxBBs.Board_Rs,2)
			Po=""
			If YxBBs.Board_Rs(0,i)=0 Then
				Temp=Temp&"<option value='"&YxBBs.Board_Rs(1,i)&"'>≡"&YxBBs.Board_Rs(3,i)&"≡</option>"
			Else
				For II=2 to YxBBs.Board_Rs(0,i)
					po=Po&"∣"
				Next
				Temp=Temp&"<option value='"&YxBBs.Board_Rs(1,i)&"'>"&po&"├ "&YxBBs.Board_Rs(3,i)&"</option>"
			End IF
		Next
	End If
	GetBoardList=Temp&"</select>"
End Function

Sub BoardLastRaply()
	Dim Rs,Temp,TempID,TempContent
	Set Rs=YxBBs.execute("select top 1 ReplyTopicID,Name,Caption,Content,TopicID,LastTime,BoardID from [YX_bbs"&YxBBs.TB&"] where BoardID="&YxBBs.BoardID&" And IsDel=False order by BbsID desc")
	if Rs.eof then
		Temp=""
	Else
		if Rs("ReplyTopicID")=0 then
			TempContent=YxBBs.Fun.StrLeft(Rs("Caption"),20)
			TempID=Rs("Topicid")
		Else
			TempContent=YxBBs.Fun.StrLeft(YxBBs.Fun.FixReply(Rs("Caption")),20)
			TempID=Rs("ReplyTopicID")
			'更新主题
			Dim ReRs,TopicLastReply
			Set ReRs=YxBBs.execute("select top 1 Name,Content from [YX_bbs"&YxBBs.TB&"] where BoardID="&YxBBs.BoardID&" And ReplyTopicID="&TempID&" And IsDel=False order by BbsID desc")
			If Not ReRs.Eof Then
				TopicLastReply=""&ReRs(0)&"|"&YxBBs.Fun.StrLeft(ReRs(1),40)
				YxBBs.execute("Update [YX_Topic] set LastReply='"&TopicLastReply&"' where TopicId="&TempID&"")
			End If
			ReRs.CLose:Set ReRs=Nothing
		End if
	Temp=""&Rs("name")&"|"&TempContent&"|"&Rs("LastTime")&"|99|"&TempID&"|"&Rs("BoardID")&"|"&YxBBs.TB&""
	end if
	Rs.Close
	IF Temp<>"" Then 
		YxBBs.execute("update [YX_Board] set LastReply='"&Temp&"' where BoardID="&YxBBs.BoardID&" and ParentID<>0")
		If YxBBs.BoardDepth>1 Then
			YxBBs.Execute("Update [YX_Board] set LastReply='"&Temp&"' where BoardID In ("&YxBBs.BoardParentStr&") And ParentID<>0")
		End If
	End IF
	Cache.name="Config"
	Cache.clean()
	Cache.Name="BoardInfo"
	Cache.clean()
End Sub

sub cheak
If YxBBs.Execute("Select ID From[YX_user]where Name='"&YxBBs.MyName&"' And PassWord='"&YxBBs.MyPwd&"'").Eof Then
	YxBBs.MakeCookiesEmpty()
	YxBBs.Error("该用户不存在或者已经被删除！")
End IF

Set Rs=YxBBs.Execute("Select Name,BoardID From[YX_topic] Where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" or TopType=5)")
	IF Not Rs.eof Then
		SetUserName=Rs("Name")
		YxBBs.BoardID=Rs("BoardID")
		Rs.Close
	Else
		YxBBs.Error("该帖子不存在或已经删除！")
	End IF
end sub
%>