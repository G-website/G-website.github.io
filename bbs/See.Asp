<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="inc/ubb_Cls.Asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style type="text/css">
td,tr,table,body{font-size: 9pt; margin:0}
</style>
<%Dim Action,ID,UserName,BbsID
Action=Lcase(Request.QueryString("Action"))
ID=YxBBs.Checknum(Request.QueryString("ID"))
Select Case Action
Case"vote"
	Vote
Case"preview"
	Preview()
Case"checkname"
	CheckUserName()
Case"headpic"
	HeadPic()
End Select

Set YxBBs=Nothing
Sub Vote()
YxBBs.Head"投票详情"
	Dim Rs,Arr_Rs,i,Temp,Caption,Content,Vote,VoteNum,AllvoteNum,VotePicW,ii,VoteShow,VoteType,voteopt
	If Not YxBBs.FoundUser Then Response.Write"你还没有登陆，不能查看投票详细信息。":Response.End
	Set Rs=YxBBs.Execute("Select TopicID,Vote,VoteNum,VoteType,OutTime From [YX_TopicVote] where TopicID="&ID&"")
	If Not Rs.Eof then
		VoteType=Rs("VoteType")
		Vote=Split(Rs("Vote"),"|")
		VoteNum=split(Rs("VoteNum"),"|")
		For i=1 to ubound(Vote)
			AllvoteNum=Int(AllvoteNum+VoteNum(i))
		Next
		IF AllVoteNum=0 then AllvoteNum=1
		For i=1 To ubound(Vote)
			ii=ii+1
			VotePicW=VoteNum(i)/AllvoteNum*85
			IF ii>6 Then ii=1
			VoteShow=VoteShow&"<tr><td width='5%' height=25 >&nbsp;"&i&"</td><td width='40%'>&nbsp;"&YxBBs.Fun.HtmlCode(Vote(i))&"</td><td width='35%' >&nbsp;<img border=0 height=8 width=2 src=Images/line.gif><img border=0 height=8 width='"&VotePicW&"%' src='Images/hr.gif'> <b>"&VoteNum(i)&"</b> 票</td></tr>"
		next
	End if
	Caption="投票选项"
	Content="<table frame=void border='1' cellpadding='3' cellspacing='0' bordercolor='#999999' style='border-collapse: collapse' width='100%'><tr>"&VoteShow&"<tr><td width='100%' height=25 colspan=4>&nbsp; 共投了："&AllvoteNum&"票&nbsp;截止时间："&Rs("OutTime")&" </td></tr></table>"
	Rs.Close
	Call YxBBs.ShowTable(Caption,Content)
	Set Rs=YxBBs.execute("select VoteNum,User From[YX_TopicVoteUser] where TopicID="&ID&"")
	Content=""
	If Not Rs.eof Then Arr_Rs=Rs.GetRows
	Rs.Close
	If IsArray(Arr_Rs) Then
		For i=0 To Ubound(Arr_Rs,2)
			If VoteType=1 Then
				Temp="投票第"&Arr_Rs(0,i)&"项："&YxBBs.Fun.HtmlCode(Vote(int(Arr_Rs(0,i))))
			ElseIf VoteType=2 Then
				VoteOpt=Split(Arr_Rs(0,i),",")
					Temp=""
					For II=0 to ubound(VoteOpt)
					If VoteOpt(ii)<>"" then
						Temp=Temp&"投票第"&VoteOpt(ii)&"项："&YxBBs.Fun.HtmlCode(Vote(int(VoteOpt(ii))))&"<br>"
						End if
					Next
			End If
			Content=Content&"<tr><td height='25'>&nbsp;"&Arr_Rs(1,i)&"</td><td>"&Temp&"</td></tr>"
		Next
		Caption="投票用户"
		Content="<table frame=void border='1' cellpadding='3' cellspacing='0' bordercolor='#999999' style='border-collapse: collapse' width='100%'>"&Content&"</table>"
		Call YxBBs.ShowTable(Caption,Content)
YxBBs.Footer()
	End If
End Sub
Sub HeadPic()
	Dim Temp,Caption,Content,I,tr_I
	Response.Write"<title>论坛头像选择器</title>"
	Caption="论坛自带的头像 共"& YxBBs.BBSSetting(14) &"个"
	For I=1 To Int(YxBBs.BBSSetting(14))
		tr_i=tr_i+1
		Temp=Temp &"<td style='cursor:hand' title='点击选择 "& I &" 号头像' onclick=instrPic("& I &")><img Src='Images/UserHead/"& i &".Gif'></td>"
		If tr_i=5 Then Temp=temp &"</tr><tr>":Tr_i=0
	Next
	Content="<table width='100%' barder=1>"& Temp &"</td></tr></table>"
	Call YxBBs.ShowTable(Caption,Content)
End Sub
Sub Preview()
YxBBs.Head"帖子预览"
	Dim Caption,Content,YxBBs_ubb
	Set YxBBs_ubb=New YxBBsubb_Cls
	Caption="帖子主题： "&YxBBs.Fun.HtmlCode(trim(Request.form("Caption")))
	Content=trim(Request.form("Content"))
	YxBBs_ubb.UbbString=YxBBs.Fun.UbbString(Content)
	Content="<tr><td><blockquote><span style='line-height:150%;table-layout:fixed;word-wrap:break-word;word-break:break-all; width:100%'><br>"&YxBBs_ubb.UBB(Content,1)&"</Span></blockquote></td></tr>"
      Set YxBBs_ubb=Nothing
Call YxBBs.ShowTable(Caption,Content)
YxBBs.Footer()
End Sub

Sub CheckUserName()
	dim name,Can,sResult,sResult1
	name = unescape(request("name"))
	If YxBBs.Fun.CheckName(name) Then
			If Not YxBBs.execute("select name from [YX_User] where name='"&Name&"'").eof Then
				sResult="对不起!该用户已被注册."
			Else
				If instr("@@"&lcase(YxBBs.BadName)&"@@","@@"& lcase(Name) &"@@")>0 Then
					Can=true
				End If
				If Can Then
					sResult="非法用户名，不能注册!"
				Else
					sResult=""	
				End If
			End If
	else
	 sResult="用户名中有非法字符或被屏蔽字符！"
	 End If
Response.Write(escape(sResult))
End Sub%>
<script type="text/javascript">
function instrPic(id){
self.opener.document.images.Pic.src="Images/UserHead/"+id+".gif";
self.opener.form.PicUrl.value="Images/UserHead/"+id+".gif";
window.close();
}
</script>