<%
Class Cls_Cache
	Private cache
	Private cacheNames
	Private expireTime
	Private expireTimeName
	Private path
	
	Private Sub class_initialize()
	path=Request.servervariables("url")
	path=left(path,instrRev(path,"/"))
	end sub
	 
	Private Sub class_terminate()
	End Sub
	
	Public Property Get Version
	Version="Cache v1.2"
	End Property

	Public property Get valid '读取缓存是否有效/属性
		if isempty(cache) or (not isdate(expireTime) or CDate(expireTime)<now) then
			valid=false
		else
			valid=true
		end if
	end property

	public property get value '读取当前缓存内容/属性
		if isempty(cache) or (not isDate(expireTime)) then
			value=null
		elseif CDate(expireTime)<now then
			value=null
		else
			value=cache
		end if
	end property

	public property let name(str) '设置缓存名称/属性
		cacheNames=str&path
		cache=application(cacheNames)
		expireTimeName=str&"expire"&path
		expireTime=application(expireTimeName)
	end property

	Public property let expire(tm) '设置缓存过期时间/属性
		expireTime=tm
		application.Lock()
		application(expireTimeName)=expireTime
		application.UnLock()
	End property
	
	public sub add(varCache,varExpireTime) '对缓存赋值/方法
		if isempty(varCache) or not isDate(varExpireTime) then
			exit sub
		end if
		cache=varCache
		expireTime=varExpireTime
		application.lock
		application(cacheNames)=cache
		application(expireTimeName)=expireTime
		application.unlock
	end sub

	public sub clean()
		application.lock
		application(cacheNames)=empty
		application(expireTimeName)=empty
		application.unlock
		cache=empty
		expireTime=empty
	End sub
	'比较缓存值是否相同/方法——返回是或否
	public function verify(varcache2)
		If typename(cache)<>typename(varcache2) then
			verify=false
		Elseif typename(cache)="Object" then
			If cache is varcache2 then
				verify=true
			Else
				verify=false
			End if
		Elseif typename(cache)="Variant()" then
			If join(cache,"^")=join(varcache2,"^") then
				verify=true
			Else
				verify=false
			End if
		Else
			If cache=varcache2 then
				verify=true
			Else
				verify=false
			End if
		End if
	End function
End Class
%>
<%
Class Cls_Fun
	Public Function LockedIpCheck()
	Dim num_ip,rs,Arr_Rs,I
	Cache.Name="IPData"
		If Cache.valid Then
			Arr_Rs=Cache.Value
		Else
			Set Rs=YxBBs.execute("select id,StartIp,EndIP,ReadMe from [YX_lockip]")
			If Rs.Eof Or Rs.Bof Then
				Exit Function
			Else
				Arr_Rs=Rs.GetRows(-1)
				Rs.Close
				Cache.add Arr_Rs,dateadd("n",5000,now)'5000分钟更新
			End If
		End If
		num_ip=IpEncode(YxBBs.MyIp)
		For i=0 To Ubound(Arr_Rs,2)
		If Arr_Rs(1,I)<=num_ip And Arr_Rs(2,I)>=num_ip Then
			Response.Write "<font size=3><b>你所在网段已被封锁：</b><font color=#FF0000>"&Arr_Rs(3,I)&"</font></font>"
			Response.End
		End If
		Next
	End Function
	Public  Function IpDecode(byval uip)
		If trim(uip)="" or not isnumeric(uip) Then
			IpDecode=0
		Else
			uip=Cdbl(uip)
			Dim ary_ip(3)
			ary_ip(0)=fix(uip/16777216)
			ary_ip(1)=fix((uip-ary_ip(0)*16777216)/65536)
			ary_ip(2)=fix((uip-fix(uip/65536)*65536)/256)
			uip=uip-fix(uip/65536)*65536
			ary_ip(3)=fix(uip-fix(uip/256)*256)
			IpDecode=join(ary_ip,".")
		End If
	End Function
	Public Function IpEncode(byval uip)
		If isnull(uip) or uip="" Then
			IpEncode=0
		else
			Dim ary_ip,n
			ary_ip=split(trim(uip),".")
			n=ubound(ary_ip)
			If n=3 Then
				IpEncode=ary_ip(0)*256*256*256+ary_ip(1)*65536+ary_ip(2)*256+ary_ip(3)
			else
				IpEncode=0
			End If
		End If
	End Function
	'禁止外部提交
	Public Function CheckMake()
		Dim Come,Here
		Come=Request.ServerVariables("HTTP_REFERER")
		Here=Request.ServerVariables("SERVER_NAME")
		If Mid(Come,8,len(Here))<>Here Then YxBBs.Error("您所提交的数据来自本站外部，请不要从论坛外部提交数据，谢谢合作！")
	End Function

	'传字符值
	Public Function GetStr(Str)
		Str = Trim(Request.Form(Str))
		If IsEmpty(Str) Then
			Str = ""
		Else
			Str = Replace(Str,"{","｛")
			Str = Replace(Str,"}","｝")
			Str = Replace(Str,"'","&#39")
			Str = Replace(Str,"|","&#124;")
		End If
		GetStr = Trim(Str)
	End Function
	
	Public Function GetSqlStr(Str)
		If IsEmpty(Str) Or Isnull(Str) Then
			Str = ""
		End If
		GetSqlStr = Trim(Str)
	End Function
	'整数检验
	Public Function isInteger(para)
		   on error resume Next
		   Dim str
		   Dim l,i
		   If isNUll(para) Then 
			  isInteger=false
			  Exit Function
		   End If
		   str=cstr(para)
		   If trim(str)="" Then
			  isInteger=false
			  Exit Function
		   End If
		   l=len(str)
		   For i=1 to l
			   If mid(str,i,1)>"9" or mid(str,i,1)<"0" Then
				  isInteger=false 
				  Exit Function
			   End If
		   Next
		   isInteger=true
		   If err.number<>0 Then err.clear
	End Function
	'名字字符检验
	Public Function CheckName(str)
		checkname=true
		If Instr(str,"=")>0  or Instr(str,"%")>0 or Instr(str,chr(32))>0  or Instr(str,"?")>0 or Instr(str,"&")>0 or Instr(str,";")>0 or Instr(str,",")>0  or Instr(str,"'")>0 or Instr(str,chr(34))>0 or Instr(str,chr(9))>0  or Instr(str,"")>0 or Instr(str,"$")>0 or Instr(str,chr(255))>0 or Instr(str,":") or instr(str,"|")>0  or instr(str,"#")>0 or instr(str,"`")>0 or instr(str,"\")>0 or instr(str,"(")>0 or instr(str,"[")>0 or instr(str,"-")>0 or instr(str,"~")>0 or Instr(str,"<")>0 or Instr(str,">")>0  Then
		checkname=False
		End If
	End Function
	'过滤Html标签
	Public Function HtmlCode(str)
		If Not isnull(str) And str<>"" Then
			str = replace(str, ">", "&gt;")
			str = replace(str, "<", "&lt;")
			str = Replace(str, CHR(32), " ")
			str = Replace(str, CHR(9), "&nbsp;")
			str = Replace(str, CHR(34), "&quot;")
			str = Replace(str, CHR(39), "&#39;")
			str = Replace(str, CHR(13), "")
			str = Replace(str, "script", "&#115cript")
			HtmlCode = str
		End If
	End Function
	'过滤地址路径
	Public Function ubbg(str)
		Dim re
		Set re=new RegExp
		re.IgnoreCase=true
		re.Global=True
		re.Pattern="((javascript:)|(<)|(>)|(height)|(width)|(jscript:)|(object)|(script)|(js:)|(vbscript:)|(vbs:)|(\.value)|(about:)|(file:)|(document.cookie)|(on(mouse|Exit|error|click|key|load)))"
		str=re.Replace(str," ")
		re.Pattern="(&#)"
		str=re.Replace(str,"＆＃")
		Set re=Nothing
		ubbg=str
	End Function
	'邮箱检测
	Function IsValidEmail(email)
		Dim names,name,i,c
		IsValidEmail = True
		names = Split(email, "@")
		If UBound(names) <> 1 Then
		   IsValidEmail = false
		   Exit Function
		End If
		for each name in names
		   If Len(name) <= 0 Then
			 IsValidEmail = false
			 Exit Function
		   End If
		   for i = 1 to Len(name)
			 c = Lcase(Mid(name, i, 1))
			 If InStr("abcdefghijklmnopqrstuvwxyz_-.", c) <= 0 and not IsNumeric(c) Then
			   IsValidEmail = false
			   Exit Function
			 End If
		   next
		   If Left(name, 1) = "." or Right(name, 1) = "." Then
			  IsValidEmail = false
			  Exit Function
		   End If
		next
		If InStr(names(1), ".") <= 0 Then
		   IsValidEmail = false
		   Exit Function
		End If
		i = Len(names(1)) - InStrRev(names(1), ".")
		If i <> 2 and i <> 3 Then
		   IsValidEmail = false
		   Exit Function
		End If
		If InStr(email, "..") > 0 Then
		   IsValidEmail = false
		End If
	End Function
	'字符长度（汉字为2）
	Public Function StrLeft(str,strlen)
	   Dim l,t,i,c
	   If str="" Then
	      StrLeft=""
		  Exit Function
	   End If
	   str=Replace(Replace(Replace(Replace(str,"&nbsp;"," "),"&quot;",Chr(34)),"&gt;",">"),"&lt;","<")
	   str=Replace(Replace(str,"&#39;","'"),"&#124;","|")
	   l=Len(str)
	   t=0
	   For i=1 To l
		  c=Abs(Asc(Mid(str,i,1)))
		  If c>255 Then
		    t=t+2
		  Else
		    t=t+1
		  End If
		  If t>=strlen Then
		    StrLeft=Left(str,i) & "..."
		    Exit For
		  Else
		    StrLeft=str
		  End If
	   Next
	   StrLeft=Replace(Replace(Replace(replace(StrLeft," ","&nbsp;"),Chr(34),"&quot;"),">","&gt;"),"<","&lt;")
	   StrLeft=Replace(Replace(StrLeft,"'","&#39;"),"|","&#124;")
	End Function
	'字符长度
	Public Function strLength(findstr)
		Dim Rep,lens,i
		Set rep=new regexp
		rep.Global=true
		rep.IgnoreCase=true
		rep.Pattern="[\u4E00-\u9FA5\uF900-\uFA2D]"
		For each i in rep.Execute(findstr)
			lens=lens+1
		Next
		lens=lens + len(findstr)
		strLength=lens
	End Function
	'脏字过滤
	Public Function Checkbad(str)
		Dim Fun_I
		If IsNull(Str) Then Exit Function
		For Fun_i=0 to ubound(YxBBs.BadEssay)
			Str=Replace(str, YxBBs.BadEssay(Fun_i), String(Len(YxBBs.BadEssay(Fun_i)),"*"))
		Next
		Checkbad=Str
	End Function
	'注入检查
	Public Function CheckIn(str)
		If instr(1,str,chr(39))>0 or instr(1,str,chr(34))>0 or instr(1,str,chr(59))>0 Then
			CheckIn=False
		Else
			CheckIn=True
		End If
	End Function

	Public Function UbbString(byval Str1)
		Dim UBB_YxBBs,i,Str,Temp
		Str=LCase(Str1)
		UBB_YxBBs="javascript:,jscript:,object,js:,location.,vbscript:,vbs:,.value,about:,file:,document.cookie,onmouse,onExit,onerror,onclick,onkey,onload,www.,http,https,ftp,rtsp,mms,[/b],[/i],[/u],[/sup],[/sub],[/color],[/url],[/right],[/light],[em,[/size],[/dir],[/fly],[/move],[/align],[/shadow],[/sound],[/img],[/upload],[/email],[/flash],[/mp],[/rm],[/ra],[/quote],[/coin],[/mark],[/grade],[/login],[/sex],[/username],[/date],[/reply],[/buypost],[/code],[/html]"
		UBB_YxBBs=Split(UBB_YxBBs,",")
		Temp=","
		For i=0 to 16
			If InStr(Str,UBB_YxBBs(i))>0 Then
				Temp=Temp&"0,"
				Exit For
			End If
		Next
		For i=17 to 58
			If InStr(Str,UBB_YxBBs(i))>0 Then
				temp=temp & i-16 &","
			End If
		Next
		UbbString=Temp
	End Function

	Function FixReply(Byval Tstr)
		If Tstr="" Then Exit Function
		Dim Re
		Set Re = New RegExp
		Re.Global = True
		Re.IgnoreCase = True
		'基本标签过滤
		Re.pattern="\[((?:/?b)|(?:/?u)|(?:/?i)|(?:/?quote)|(?:/?sub)|(?:/?email)|(?:/?flash)|(?:/?right)|(?:/?sub)|(?:/?light)|(?:/?code)|(?:/?sup))\]"
		Tstr=Re.Replace(Tstr,"")
		re.pattern="\[SIZE=(?:[1-4])\]((?:.|\r\n)+?)\[\/SIZE\]"
		Tstr=re.Replace(Tstr,"$1")
		re.pattern="\[em*([0-9]*)\]"
		Tstr=Re.Replace(Tstr,"")
		Re.pattern="\[align=(?:center|left|right)\](.*)\[\/align\]"
		Tstr=Re.Replace(Tstr,"$1")
		Re.pattern="\[color=(?:(?:#.{6})|.{3,6})\]((?:.|\r\n)*?)\[/color\]"
		Tstr=Re.replace(Tstr,"$1")
		'特殊帖标签
		Re.Pattern="(^.*)\[(.*)\](.*)"
		FixReply=Lcase(Re.Replace(Tstr,"$2"))
		If Instr(FixReply,"=") Then
			FixReply=Left(FixReply,Instr(FixReply,"=")-1)
		Else
			FixReply=Replace(FixReply,"/","")
		End If
		Select Case FixReply
			Case"upload"
				Tstr="此帖包含上传附件!"
			Case "coin","mark","grade","login","username","reply","date","buypost"
				Tstr="此帖内容保密"
		End Select
		FixReply=Tstr
	End Function

	Function GetIp(Ip,IpNum)
		Dim Arr_Ip
		If Ip="" Then Exit Function
		Arr_Ip=split(Ip,".")
		Select Case IpNum
			Case "1"
				GetIp=Arr_Ip(0) & ". * . * . * "
			Case "2"
				GetIp=Arr_Ip(0) & "." & Arr_Ip(1) & ". * . * "
			Case "3"
				GetIp=Arr_Ip(0) & "." & Arr_Ip(1) & "." & Arr_Ip(2) & ". * "
			Case "4"
				GetIp=Arr_Ip(0) & "." & Arr_Ip(1) & "." & Arr_Ip(2) & "." & Arr_Ip(3)
			Case Else
				GetIp=" * . * . * . * "
		End Select
	End Function

	Function DateToSting(TS)
		Dim S,N,H,D,M,Y
		If TS="" Then Exit Function
		S=TS
		If S>60 Then
			N=Int(S/60)
			S=S-60*N
			If N>60 Then
				H=Int(N/60)
				N=N-H*60
				If H>24 Then
					D=Int(H/24)
					H=H-24*D
					If D>30 Then
						M=Int(D/30)
						D=D-30*M
						If M>12 Then
							Y=Int(M/12)
							M=M-12*Y
							DateToSting=Y&" 年 "&M&" 个月 "&D&" 天 "&H&" 小时 "&N&" 分 "&S&" 秒"
						Else
							DateToSting=M&" 个月 "&D&" 天 "&H&" 小时 "&N&" 分 "&S&" 秒"
						End If
					Else
						DateToSting=D&" 天 "&H&" 小时 "&N&" 分 "&S&" 秒"
					End If
				Else
					DateToSting=H&" 小时 "&N&" 分 "&S&" 秒"
				End If
			Else
				DateToSting=N&" 分 "&S&" 秒"
			End If
		Else
			DateToSting=S&" 秒"
		End If
	End Function
End Class
%>
<%
Class Cls_SkinTemplates
   Public TemplateContent,SkinID
   Private RegEx
   Private Sub Class_Initialize()
	 Set RegEx = New RegExp
	 RegEx.IgnoreCase = False
     RegEx.Global = True 
   End Sub
   Private Sub Class_Terminate()
        Set RegEx =Nothing
   End Sub
   Public Function OpenFile()
     Dim Rs,rs1
		Cache.name="Skin_"& SkinID
		'Cache.clean()
		If Cache.valid then
			TemplateContent=Cache.value
		Else 
	    Set Rs=YxBBs.Execute("Select Top 1 SkinContent From [YX_SkinStyle] Where SkinID="&SkinID)
		 If Not Rs.Eof Then
			 Cache.add Rs(0),dateadd("n",5000,now)
			 TemplateContent=Rs(0)
		 Else
			 Set Rs1=YxBBs.Execute("Select Top 1 SkinID From [YX_SkinStyle] Where Flag=True")
			 If Not Rs1.Eof Then
				YxBBs.Execute("Update [YX_Config] Set SkinID="&Rs1(0))
				Cache.name="Config"
				Cache.clean()
				ShowMsg "没有模版或已被删除了！<br>请打开IE工具--InterNet选项--删除Cookies--重新启动IE."
			 Else
				ShowMsg "论坛模版数据出错，请到<A HREF=http://www.YimXu.com/>YxBBs 官方站</A>寻求帮助。"
			 End IF
			Set Rs1=Nothing
			StopWrite
		 End If
         Set Rs= Nothing
	  End If
	  OpenFile=TemplateContent
   End Function
   
   Private Sub ShowMsg(Msg)
    	'输出提示信息
  		Response.Write "<br><font style='font-size:12px;color:blue'>" & Msg & "</font>"
   End Sub

   Private Sub StopWrite()
    	'停止往下执行程序
		Response.Write "<br><font style='font-size:12px;color:red'>程序被终止</font><br><a href='javascript:history.go(-1);' style='font-size:12px'>返回上一页</a>"
		Response.End()
   End Sub

   Public Function ReadTemplate(TempLateName)
       Dim TempStr
        If Not IsFound(TempLateName) Then
		   ShowMsg "模版不存在"
		   StopWrite
		End If
		TempStr=GetStr(TempLateName)
        ReadTemplate=WriteReplace(TempStr)
   End Function

   Public Function EditTempLate(TempLateName,FileContent)
      Dim TempStr
        If Not IsFound(TempLateName) Then
		   ShowMsg "模版不存在"
		   StopWrite
		End If
        TempStr=GetStr(TempLateName)
		TempStr=Replace(TemplateContent,"["&TempLateName&"]"&TempStr&"[/"&TempLateName&"]","["&TempLateName&"]"&SaveReplace(FileContent)&"[/"&TempLateName&"]")
		EditTempLate=TempStr
   End Function


   Private Function GetStr(TemplateName)
      Dim TempStr,BeNum,EnNum,BStr,EStr
	  
	  BStr="["&TempLateName&"]"
	  EStr="[/"&TempLateName&"]"
	  BeNum=InStr(TemplateContent,BStr)
	  EnNum=InStr(BeNum+Len(BStr),TemplateContent,EStr)
	  On Error Resume Next
	  TempStr=Mid(TemplateContent,BeNum+Len(BStr),EnNum-BeNum-Len(BStr))
      If Err Then
		  ShowMsg "在处理["&TempName&"]模版时出错"
		  StopWrite 
	  End If
	  GetStr=TempStr
   End Function
   Private Function IsFound(TempLateName)
     IsFound=False
      If Instr(TemplateContent,"["&TempLateName&"]")>0 And Instr(TemplateContent,"[/"&TempLateName&"]")>0 Then
	      IsFound=True
	  End If
   End Function

   Private Function WriteReplace(Str)
		Str = Replace(Str,"{LFG}","[")
        Str = Replace(Str,"{RFG}","]")
		WriteReplace = Str
	End Function
	Private Function SaveReplace(Str)
		Str = Replace(Str,"[","{LFG}")
        Str = Replace(Str,"]","{RFG}")
		SaveReplace = Str
	End Function
	Public Function ReadTemplateName()
	   Dim Pattern,RetStr, Match,TempStr,Matches
	   Pattern="\[[^\/]*\]"
       RegEx.Pattern = Pattern
	   Set Matches = RegEx.Execute(TemplateContent)
	   For Each Match In Matches
	      TempStr= TempStr & Match.Value & "|"
	   Next
	   TempStr=Replace(TempStr,"[","")
       TempStr=Replace(TempStr,"]","")
	   TempStr=Left(TempStr,Len(TempStr)-1)
	   ReadTemplateName=Split(TempStr,"|")
	End Function
End Class
%>