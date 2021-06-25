<%Const MaxLoopcount=100%>
<script language=vbscript runat=server>
Class YxBBsubb_Cls
	Public UbbString,Re
	Private Sub Class_Initialize()
	End Sub
	Rem 入口(内容，1=帖子|2=留言公告等)
	Public Function Ubb(Str,PostType)
		If isNull(Str) or Str="" then
			Ubb=""
			Exit function
		End if
		If UbbString="" Or IsNull(UbbString) Then
			UbbString=YxBBs.Fun.UbbString(Str)
		End If
		If instr(UbbString,",41,")>0 And PostType=1 Then
			Str=YxBBs_Code(Str,PostType)
		Else
			Str=YxBBs_UBB(str,postType)
		End If
		UBB=Str
	End Function
	
	Private Function YxBBs_UBB(Str,PostType)
		If isNull(Str) or Str="" then
			YxBBs_UBB=""
			Exit function
		End if
		Str=Html_Code(Str)
		Set re=new RegExp
		re.IgnoreCase =True
		re.Global=True
		If InStr(UbbString,",0,")>0 Then
			   re.pattern="((script)|(style)|(javascript:)|(jscript:)|(object)|(js:)|(location.)|(vbscript:)|(vbs:)|(\.value)|(about:)|(file:)|(document.cookie)|(on(mouse|exit|error|click|key|load)))"
			str=re.replace(str,"<font color=#000000>$1</font>")
		End If
                If InStr(UbbString,",35,")>0 Then Str=YxBBs_Ubb_Login(Str,PostType)
		If InStr(UbbString,",36,")>0 Then Str=YxBBs_Ubb_Sex(Str,PostType)
		If InStr(UbbString,",37,")>0 Then Str=YxBBs_Ubb_Name(Str,PostType)
		If InStr(UbbString,",38,")>0 Then Str=YxBBs_Ubb_Date(Str,PostType)
		If InStr(UbbString,",39,")>0 Then Str=YxBBs_Ubb_Reply(Str,PostType)
		If InStr(UbbString,",40,")>0 Then Str=YxBBs_Ubb_Buy(Str,PostType)
		If InStr(UbbString,",24,")>0 Then Str=YxBBs_Ubb2(Str,"\[img\]","\[\/img\]","<img src=$1>","",YxBBs.BBSSetting(22)) 
		If InStr(UbbString,",25,")>0 Then
		If YxBBs.BBSSetting(22)="0" Then
		If Not YxBBs.FoundUser and YxBBs.BBSSetting(55)="0" Then 
		Str=YxBBs_Ubb3(Str,"\[upload=(txt|zip|rar|mdb|swf),*(#*[0-9\.]*),*(#*[0-9\.]*),*(#*[0-9\.]*),*(#*[0-9\.]*)\]","\[\/upload\]","<fieldset><legend>上传的附件</legend><br>&nbsp;&nbsp;<font color=gray>抱歉,您所在的组无权下载附件,请<a href=register.asp>注册</a>或<a href=login.asp>登陆</a>.</font><br><br></fieldset>")
		Str=YxBBs_Ubb2(Str,"\[upload=(gif|jpg|jpeg|bmp|png),*(#*[0-9\.]*),([0-9]{1,3}),*(#*[0-9\.]*),*(#*[0-9\.]*)\]","\[\/upload\]","<fieldset><legend>上传的图片</legend><br>&nbsp;&nbsp;<font color=gray>抱歉,您所在的组无权下载附件,请<a href=register.asp>注册</a>或<a href=login.asp>登陆</a></font></fieldset>","",YxBBs.BBSSetting(22))
                Else
	        Str=YxBBs_Ubb3(Str,"\[upload=(txt|zip|rar|mdb|swf),*(#*[0-9\.]*),*(#*[0-9\.]*),*(#*[0-9\.]*),*(#*[0-9\.]*)\]","\[\/upload\]","<fieldset><legend>上传的附件</legend><br>&nbsp;&nbsp;<IMG SRC=INc/Editor/images/common.gif align=absmiddle> <a href=""ViewFile.Asp?FileName=$6"" TARGET=_blank>$6</a> ( <font color=blue>$2</font> KB ) "&chr(60)&"script type=""text/javascript"" src=""Info.asp?FileName=$6"">"&chr(60)&"/script><br><br></fieldset>")
		Str=YxBBs_Ubb2(Str,"\[upload=(gif|jpg|jpeg|bmp|png),*(#*[0-9\.]*),([0-9]{1,3}),*(#*[0-9\.]*),*(#*[0-9\.]*)\]","\[\/upload\]","<fieldset><legend>上传的图片</legend><br>&nbsp;&nbsp;<img src=INc/Editor/images/image.gif align=absmiddle> <A HREF=""ViewFile.Asp?FileName=$6"" TARGET=_blank>$6</a> [ <font color=blue>$2</font> KB <font color=blue>$4</font>×<font color=blue>$5</font> ] <font color=#999999>(缩略时请点击查看原图)</font><br><br>&nbsp;&nbsp;<IMG SRC=""ViewFile.Asp?FileName=$6"" border=0><br><br></fieldset>","<A HREF=""ViewFile.Asp?FileName=$6"" TARGET=_blank>$6</a>",YxBBs.BBSSetting(22)) 
		End If
		End If
		End If
		If InStr(UbbString,",31,")>0 Then Str=UbbCode_Q(Str)
		If InStr(UbbString,",32,")>0 Then Str=YxBBs_GetUBB(Str,"\[coin=*([0-9]*)\]","\[\/coin\]","$1<hr noshade size=1><font color=gray>以下内容需要金钱数达到<B>$3</B>才可以浏览</font><BR>$4<hr noshade size=1>$6","$1<hr noshade size=1><font color=Red>以下内容需要金钱数达到<B>$3</B>才可以浏览</font><hr noshade size=1>$6",PostType,YxBBs.MyCoin)
		If InStr(UbbString,",33,")>0 Then Str=YxBBs_GetUBB(Str,"\[mark=*([0-9]*)\]","\[\/mark\]","$1<hr noshade size=1><font color=gray>以下内容需要积分数达到<B>$3</B>才可以浏览</font><BR>$4<hr noshade size=1>$6","$1<hr noshade size=1><font color=Red>以下内容需要积分数达到<B>$3</B>才可以浏览</font><hr noshade size=1>$6",PostType,YxBBs.MyMark)
		If InStr(UbbString,",34,")>0 Then Str=YxBBs_GetUBB(Str,"\[grade=*([0-9]*)\]","\[\/grade\]","$1<hr noshade size=1><font color=gray>以下内容需要等级为 <b>$3</b> 或更高的等级以及作者才能浏览</font><BR>$4<hr noshade size=1>$6","$1<hr noshade size=1><font color=Red>以下内容需要等级为<B>$3</B>或更高的等级以及作者才可以浏览</font><hr noshade size=1>$6",PostType,YxBBs.MyGradeNum)
       		re.Pattern="<img(.[^>]*)>"
		str=re.replace(str,"<img$1 onmousewheel=""return bbimg(this)"" onload=""javascript:if(this.width>screen.width-500) this.style.width=screen.width-500;"" border=0>")
		re.Pattern="<embed(.[^>]*)>"
		str=re.replace(str,"<embed$1 wmode=""transparent"">")
		re.Pattern="<a(.[^>]*)>"
		str=re.replace(str,"<a$1 target=_blank>")
		Set re=Nothing
		YxBBs_UBB=Str
	End function
	
	Private Function Html_Code(byval Str)
		If IsNull(Str) then
			 Html_code=""
		Else
			Str=replace(Str,chr(39),"&#39;")
			Str=replace(Str,chr(36),"&#36;")
            str = Replace(str, "SCRIPT", "&#115cript")
			Str = Replace(Str, chr(10) &chr(10), "<br><br> ")
                        Html_Code = Replace(Str, chr(10), "<p></p>")
		End if
	End Function

	Public Function Sign_Code(byval Str)
		If IsNull(Str) or Str="" Then
			Sign_Code=""
			Exit Function
		End If
		Str=Html_Code(Str)
		Set re=new regExp
		re.IgnoreCase=true
		re.Global=true	
		re.pattern="((javascript:)|(jscript:)|(object)|(js:)|(location.)|(vbscript:)|(vbs:)|(\.value)|(about:)|(file:)|(document.cookie)|(on(mouse|exit|error|click|key|load)))"
		str=re.replace(str,"<font color=#000000>$1</font>")
		If InStr(Lcase(Str),"[/b]")>0 Then Str=YxBBs_Ubb1(Str,"\[b\]","\[\/b\]","<b>$1</b>")
		If InStr(Lcase(Str),"[/i]")>0 Then Str=YxBBs_Ubb1(Str,"\[i\]","\[\/i\]","<i>$1</i>")
		If InStr(Lcase(Str),"[/u]")>0 Then Str=YxBBs_Ubb1(Str,"\[u\]","\[\/u\]","<u>$1</u>")
                If InStr(Lcase(Str),"[/fly]")>0 Then Str=YxBBs_Ubb1(Str,"\[fly\]","\[\/fly\]","<marquee width=90% behavior=alternate scrollamount=3>$1</marquee>") 
                If InStr(Lcase(Str),"[/url]")>0 Then Str=YxBBs_Ubb1(Str,"\[url=(.{5,}?)\]","\[\/url\]","<a href=""$1"" target='_blank'>$2</a>")
                If InStr(Lcase(Str),"[/color]")>0 Then Str=YxBBs_Ubb1(Str,"\[color=((#.{6})|.{3,6})\]","\[\/color\]","<font color=#$1>$3</font>") 
		If InStr(Lcase(Str),"[/img]")>0 Then Str=YxBBs_Ubb2(Str,"\[img\]","\[\/img\]","<img src=$1 border=0 onload=""javascript:if(this.width>screen.width-333)this.width=screen.width-333"" >","",YxBBs.BBSSetting(22)) 
		Set re=nothing
		Sign_Code=Str
	End Function
	
	Private Function UbbCode_Q(strText)
		Dim s
		Dim Test
		Dim LoopCount
		LoopCount=0
		s=strText
		re.Pattern="\[QUOTE\]"
		Test=re.Test(s)
		If Test Then
			re.Pattern="\[\/QUOTE\]"
			Test=re.Test(s)
			If Test Then
				re.Pattern="\[QUOTE\]"
				s=re.replace(s, chr(1) & "QUOTE" & chr(2))
				re.Pattern="\[\/QUOTE\]"
				s=re.replace(s, chr(1) & "/QUOTE" & chr(2))
				Do
					re.Pattern="\x01QUOTE\x02\x01\/QUOTE\x02"
					s=re.Replace(s,"")
					re.Pattern="\x01QUOTE\x02(.[^\x01]*)\x01\/QUOTE\x02"
					s=re.Replace(s,"<table cellpadding=0 cellspacing=0 border=1 WIDTH='90%' style='border-collapse: collapse' bordercolor=#CCCCCC align=center><tr><td bgcolor='#f2f8ff'><p style='margin:15'>$1</p></td></tr></table><br>")
					Test=re.Test(s)
					LoopCount=LoopCount+1
					If LoopCount>MaxLoopCount Then Exit Do
				Loop While(Test)
				re.Pattern="\x02"
				s=re.replace(s, "]")
				re.Pattern="\x01"
				s=re.replace(s, "[")
			End If 
		End If
		UbbCode_Q=s
	End Function

	Private Function YxBBs_Ubb1(Str,uCodeL,uCodeR,tCode)
		Dim s
		s=str
		re.Pattern=uCodeL&uCodeR
		s=re.Replace(s,"")
		re.Pattern=uCodeL&"(.+?)"&uCodeR
		s=re.Replace(s,tCode)
		re.Pattern=uCodeL
		s=re.Replace(s,"")
		re.Pattern=uCodeR
		s=re.Replace(s,"")
		YxBBs_Ubb1=s
	End Function
	
	Private Function YxBBs_Ubb2(Str,uCodeL,uCodeR,tCode1,tCode2,BBSCheck)
		Dim s
		s=str
		re.Pattern=uCodeL&uCodeR
		s=re.Replace(s,"")
		re.Pattern=uCodeL&"(.+?)"&uCodeR
		If BBScheck="0" Then
		s=re.Replace(s,tCode1)
		Else
		s=re.Replace(s,tCode2)
		End If
		re.Pattern=uCodeL
		s=re.Replace(s,"")
		re.Pattern=uCodeR
		s=re.Replace(s,"")
		YxBBs_Ubb2=s
	End Function

	Private Function YxBBs_Ubb3(Str,uCodeL,uCodeR,tCode)
		Dim s
		s=str
		re.Pattern=uCodeL&uCodeR
		s=re.Replace(s,"")
		re.Pattern=uCodeL&"(.+?)"&uCodeR
		s=re.Replace(s,tCode)
		YxBBs_Ubb3=s
	End Function

	Private Function YxBBs_Code(Str,PostType)
		dim ary_String,i,n,n_pos
		ary_String=split(Str,"[code]")
		n=ubound(ary_String)
		If n<1 then
			YxBBs_Code=YxBBs_UBB(Str,PostType)
			Exit function
		End If
		ary_String(0)=YxBBs_UBB(ary_String(0),postType)
		for i=1 to n
			n_pos=inStr(ary_String(i),"[/code]")
			If n_pos>0 then
                                   ary_String(i)="<table cellpadding=0 cellspacing=0 border=1 WIDTH='98%' style='border-collapse: collapse' bordercolor=#CCCCCC align=center><tr><td bgcolor='#f2f8ff'><p style='margin:15'><b>本贴相关代码：</b><br>" & left(ary_String(i),n_pos-1) & "</p></td></tr></table><br>" & YXBBS_UBB(right(ary_String(i),len(ary_String(i))-n_pos-6),PostType)
			Else
				ary_String(i)="[code]" & YxBBs_UBB(ary_String(i),PostType)
			End if
		next
		YxBBs_Code=join(ary_String,"")
	End Function

	Rem 入口（内容,开始的UBB，结束的UBB，显示允许，显示不允许，标记：1=帖子/2=留言公告，用户的信息）
	Rem (Str,"\[grade=*([0-9]*)\]","\[\/grade\]","$1<hr noshade size=1><font color=gray>以下内容需要等级为 <b>$3</b> 或更高的等级以及作者才能浏览</font><BR>$4<hr noshade size=1>$6","$1<hr noshade size=1><font color=Red>以下内容需要等级为<B>$3</B>或更高的等级以及作者才可以浏览</font><hr noshade size=1>$6",PostType,YxBBs.MyGrade)
	Private Function YxBBs_GetUBB(Str,uCodeL,uCodeR,tCode1,tCode2,postType,MyInfo)
		Dim Test
		Dim po,ii
		Dim LoopCount
		LoopCount=0
		Do While True
			re.Pattern=uCodeL
			Test=re.Test(Str)
			If Test Then
				re.Pattern=uCodeR
				Test=re.Test(Str)
				If Test Then
					If PostType=1 Then
						re.Pattern="(^.*)("&uCodeL&")(.+?)("&uCodeR&")(.*)"
						po=re.Replace(Str,"$3")
						If  IsNumeric(po) Then
							ii=int(po) 
						Else
							ii=0
						End If 
						If YxBBs.Founduser and (Lcase(YxBBs.MyName)=Lcase(UserName) or int(MyInfo)>=int(ii) or YxBBs.ClassID<=2 or YxBBs.IsBoardAdmin) Then
							Str=re.Replace(str,tCode1)
						Else
							Str=re.Replace(str,tCode2)
						End If
					Else
						re.Pattern="("&uCodeL&")(.+?)("&uCodeR&")"
						s=re.Replace(s,"$3")
					End If 
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_GetUBB=Str
	End Function

	Private Function YxBBs_Ubb_Login(Str,PostType)
		Dim Test
		Dim LoopCount
		LoopCount=0
		Do While True
			re.Pattern="\[login\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/login\]"
				Test=re.Test(Str)
				If Test Then
					re.Pattern="(^.*)(\[login\])(.+?)(\[\/login\])(.*)"
					If YxBBs.FoundUser Then
						Str=re.Replace(str,"$1<hr height=1><font color=#A2A2A2>此帖内容<b>必须登陆</b>后才能浏览</font><BR>$3</font><hr size=1>$5")
					Else
						Str=re.Replace(str,"$1<hr height=1><font color=Red>此帖内容<b>必须<a href=login.Asp>登陆</a></b>后才能浏览<BR></font><hr size=1>$5")
					End if
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Login=Str
	End Function

	Private Function YxBBs_Ubb_Sex(Str,PostType)
		Dim Test
		Dim LoopCount
		Dim Tmp_Str,po
		LoopCount=0
		Do While True
			re.Pattern="\[sex=*([0-1]*)\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/sex\]"
				Test=re.Test(Str)
				If Test Then
					re.Pattern="(^.*)(\[sex=*([0-1]*)\])(.+?)(\[\/sex\])(.*)"
					If PostType=1 Then
						po=re.replace(str,"$3")
						If isnumeric(po) then
							If int(po)=0 then Tmp_Str="女"
							If int(po)=1 then Tmp_Str="男"
							If Not YxBBs.FoundUser Then
								str=re.Replace(str,"$1<hr size=1><font color=Red>此内容需要性别为<font color=red> <b>"&Tmp_Str&"</b></font> 和作者才能浏览：</font><BR><hr size=1>$6")
							Else
							If (YxBBs.MySex And int(po)=1) or (Not YxBBs.MySex And int(po)=0) or Lcase(YxBBs.MyName)=Lcase(UserName) Then
								str=re.Replace(str,"$1<hr size=1><font color=#A2A2A2>此内容需要性别为<font color=red> <b>"&Tmp_Str&"</b></font> 和作者才能浏览：</font><BR>$4<hr size=1>$6")
							Else
								str=re.Replace(str,"$1<hr size=1><font color=Red>此内容需要性别为<font color=red> <b>"&Tmp_Str&"</b></font> 和作者才能浏览：</font><BR><hr size=1>$6")
							End If
							End If
						End if
					Else
						Str=re.Replace(str,"$4")
					End If
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Sex=Str
	End Function

	Private Function YxBBs_Ubb_Name(Str,PostType)
		Dim Test
		Dim LoopCount
		Dim Tmp_My,tmp_str,I
		LoopCount=0
		Do While True
			re.Pattern="\[username=(.[^\[]*)\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/username\]"
				Test=re.Test(Str)
				If Test Then
					re.Pattern="(^.*)(\[username=(.[^\[]*)\])(.+?)(\[\/username\])(.*)"
					If PostType=1 Then
						Tmp_Str=re.replace(str,"$3")
						Tmp_Str=split(Tmp_Str,",")
						Tmp_My=False
						For i=0 to ubound(Tmp_Str)
							If lcase(YxBBs.MyName)=lcase(Tmp_Str(i)) then Tmp_My=True:Exit For
						Next
						If Tmp_My or Lcase(YxBBs.MyName)=Lcase(UserName) Then
							Str=re.Replace(str,"$1<hr size=1><font color=#A2A2A2>此内容只有作者和 <b>$3</b> 能浏览：</font><BR>$4<hr size=1>$6")
						Else
							Str=re.Replace(str,"$1<hr size=1><font color=Red>此内容只有作者和 <b>$3</b> 能浏览：</font><BR><hr size=1>$6")
						End if
					Else
						Str=re.Replace(str,"$4")
					End If
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Name=Str
	End Function
	
	Private Function YxBBs_Ubb_Reply(Str,PostType)
		Dim Test
		Dim LoopCount
		LoopCount=0
		Do While True
			re.Pattern="\[reply\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/reply\]"
				Test=re.Test(Str)
				If Test Then
					re.Pattern="(^.*)(\[reply\])((.|\n)+?)(\[\/reply\])(.*)"
					IF PostType=1 Then
						If YxBBs.ClassID=1 or Not(YxBBs.execute("select BbsID From[YX_bbs"&YxBBs.TB&"] where ReplyTopicID="&ID&" and name='"&YxBBs.MyName&"'").eof) or Lcase(YxBBs.MyName)=Lcase(UserName) then
							str=re.Replace(str,"$1<hr size=1><font color=Red>此内容只有作者和已经回复此帖的浏览者能浏览：</font><BR>$3<hr size=1>$6")
						Else
							str=re.Replace(str,"$1<hr size=1><font color=Red>此内容只有作者和已经回复此帖的浏览者能浏览：</font><BR><hr size=1>$6")
						End if
					Else
						str=re.Replace(str,"$3")
					End If
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Reply=Str
	End Function

	Private Function YxBBs_Ubb_Date(Str,PostType)
		Dim Tmp_int,Tmp_My,tmp_str
		Dim Test
		Dim LoopCount
		LoopCount=0
		Do While True
			re.Pattern="\[date=(.[^\[]*)\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/date\]"
				Test=re.Test(Str)
				If Test Then	
					re.Pattern="(^.*)(\[date=(.[^\[]*)\])(.[^\[]*)(\[\/date\])(.*)"
					IF PostType=1 Then
						Tmp_Str=re.replace(str,"$3")
						If IsDate(Tmp_Str) Then Tmp_Int=Datediff("d",cdate(Tmp_Str),cdate(YxBBs.NowBbsTime)) Else Tmp_Int=-1
						If int(Tmp_Int)>0 Then
							Str=re.Replace(Str,"$1<hr size=1><font color=Red>此内容只有：<b>"&Tmp_Str&"</b>这天以后才能浏览：</font><BR>$4<hr size=1>$6")
						Else
							Str=re.Replace(str,"$1<hr size=1><font color=Red>此内容只有：<b>"&Tmp_Str&"</b>这天以后才能浏览：</font><BR><hr size=1>$6")
						End If
					Else
						Str=re.Replace(str,"$1")
					End If
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Date=Str					
	End Function

	Private Function YxBBs_Ubb_Buy(Str,PostType)
		Dim Tmp_int,Tmp_My,tmp_str,i
		Dim Test
		Dim LoopCount
		LoopCount=0
		Do While True
			re.Pattern="\[buypost=*([0-9]*)\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/buypost\]"
				Test=re.Test(Str)
				If Test Then
					re.Pattern="(^.*)(\[buypost=*([0-9]*)\])(.+?)(\[\/buypost\])(.*)"
					If PostType=1 Then
						If Not YxBBs.FoundUser Then
							Str=re.Replace(str,"$1<hr size=1><font color=Red>此内容要求金钱数达到$3以上才可以购买并浏览</font><hr noshade size=1>$6")
						Else
							Tmp_My="<Form action='VoteSubmit.Asp?Action=buy' method='Get'><input type=hidden value="&BbsID&" name='ID'><input type=hidden value="&YxBBs.TB&" name='TB'><input type=submit  value='好黑啊…我…我买了！'></form>"
							Tmp_Int=re.Replace(str,"$3")
							If isnumeric(Tmp_Int) Then Tmp_Int=int(Tmp_Int) Else Tmp_Int=0
							If BBSID=0 Then
							Tmp_Str=""
							Else
							Tmp_Str=YxBBs.execute("select Buyer From[YX_bbs"&YxBBs.TB&"] where BbsID="&BbsID&"")(0)
							End If
							If Lcase(YxBBs.MyName)=Lcase(UserName) or YxBBs.ClassID<=2 Or YxBBs.IsBoardAdmin Then
								Dim PostBuyUser
								If (not isnull(Tmp_Str)) and Tmp_Str<>"" then
									Tmp_Str=split(Tmp_Str,"|")
									PostBuyUser=""
									For i=0 to ubound(Tmp_Str)
									PostBuyUser=PostBuyUser & "<option value="&i&">"&Tmp_Str(i)&"</option>"
									Next
									PostBuyUser="<select name=buyuser size=1><option value=0>共有"&ubound(Tmp_Str)&"位用户购买</option>"&PostBuyUser & "</select>"
								Else
									PostBuyUser="<select name=buyuser size=1><option value=0>还没有用户购买</option></select>"
								End if
								If YxBBs.MyName<>UserName Then PostBuyUser=Tmp_My&PostBuyUser
								Str=re.Replace(str,"$1<hr size=1><font color=Red>以下为需要金钱数达到<B>$3</B>才能浏览的内容</font>&nbsp;&nbsp;"&PostBuyUser&"<BR>$4<hr size=1>$6")
							Else
								If instr("|"&Tmp_Str&"|","|"&YxBBs.MyName&"|")>0 then
									Str=re.Replace(str,"$1<hr noshade size=1>以下为需要花 <del><B>$3</B></del> 金钱才能购买并浏览的内容，您已经购买本帖<BR>$4<hr noshade size=1>$6")
								Else
									If Int(YxBBs.MyCoin)>Tmp_Int then
										str=re.Replace(str,"$1<hr size=1><font color=Red>此帖子内容需要您花 <B>$3</B> 金钱来购买浏览&nbsp;&nbsp;"&Tmp_My&"</font><hr size=1>$6")
									Else
										str=re.Replace(str,"$1<hr size=1><font color=Red>此内容要求金钱数达到 <B>$3</B> 以上才可以购买并浏览</font><hr size=1>$6")
									end if
								End if
							End if
						End if
					Else
						Str=re.Replace(str,"$4")
					End If
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Buy=Str
	End Function
End Class
</script>