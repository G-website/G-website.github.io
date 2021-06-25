<!-- #include File="Inc/SysConfig.Asp" -->
<%
Class Upload_Cls
	Public FileSize,Conn,FileTypeFlag,MaxFile
	Public Width,Height,ReWidth,FileSizeKB,FileName,FileTypeName,OldFileName

	Private FormData,DataSize,NewFileName,FileData
	Private VbEnter
	Private spStr,lenOfspStr,bpos
	Private loopcnt,exitflag,ppoint,npoint
	Private FldData,fldHeadStr,infldpos
	Private databpos,datalen
	Private FldInfo(15,1)
	Private Sub Class_Initialize()
	MaxFile=1	
	End Sub

	Private Function IsvalidFile(TypeName)'
		dim Forumupload,i,DebarUpload
		DebarUpload=Split("asp,aspx,jsp,php,cgi,shtml,cdx,asa,cer.sthm",",")
		for i=0 to ubound(Debarupload)
			If lcase(TypeName)=lcase(trim(DebarUpload(i))) then
				IsvalidFile=false
				Exit Function
			End if
		Next
		Forumupload=FileTypeFlag
		for i=0 to ubound(Forumupload)
			if lcase(TypeName)=lcase(trim(Forumupload(i))) then
				IsvalidFile=true
				exit Function
			Else
				IsvalidFile=false
			end if
		next
	End Function
	
	Private Function Bytes2bStr(vin)
		If Lenb(vin) =0 Then
			Bytes2bStr = ""
			Exit Function
		End If
		Dim S,StringReturn
		Set S = Server.CreateObject("ADODB.Stream")
		With S
			.Type = 2 
			.Open
			.WriteText vin
			.Position = 0
			.CharSet = "gb2312"
			.Position = 2
 			StringReturn = .ReadText
		End With
		S.close
		Set S = Nothing
		Bytes2bStr = StringReturn
	End Function

	Private Function BinVal(bin)
		Dim i
		Dim ret:ret = 0
		For i = Lenb(bin) To 1 Step - 1
			ret = ret *256 + Ascb(Midb(bin,i,1))
		Next
		BinVal = ret
	End Function

	Private Function BinVal2(bin)
		Dim i
		Dim ret:ret = 0
		For i = 1 To Lenb(bin)
			ret = ret *256 + Ascb(Midb(bin,i,1))
		Next
		BinVal2 = ret
	End Function

	Private Function MyRequest(fldname)
		Dim i
		Dim fldHead
		Dim tmpvalue
		For i = 0 To loopcnt - 1
			fldHead = fldInfo(i,0)
			If Instr(Lcase(fldHead),Lcase(fldname)) > 0 Then
				tmpvalue = FldInfo(i,1)
				If instr(fldHead,"filename=""") < 1 Then
					Tmpvalue = Bytes2bStr(tmpvalue)
					If myRequest <> "" Then 
						myRequest = myRequest & "," & tmpvalue
					Else
						MyRequest = tmpvalue
					End If
				Else
					myRequest = tmpvalue
				End If
			End If
		Next
	End Function

	Private Function GetFileName(fldName)
		Dim i
		Dim fldHead
		Dim fnpos
		For i = 0 To loopcnt-1
			fldHead = Lcase(fldInfo(i,0))
			If instr(fldHead,Lcase(fldName)) > 0 Then
				fnpos = Instr(fldHead,"filename=""")
				If fnpos < 1 Then Exit For
				fldHead = Mid(fldHead,fnpos+10)
				GetFileName = Mid(fldHead,1,instr(fldHead,"""") - 1)
				GetfileName = Mid(GetFileName,instrRev(GetFileName,"\") + 1)
			End If
		Next
	End Function

	Private Sub SaveToFile(fd,path,fname)
		dim S
		Set S = Server.CreateObject("adodb.stream")
		With S
			.Mode = 3
			.Type = 1
			.Open
			.Position = 0
			.Write fd
			.SaveToFile Server.Mappath(path & "/" & fname),2
		End With
		S.Close
		set S = Nothing
	End Sub

	Private Function GetFileTypeName(Fldname)
		GetFileTypeName = "unknow"
		If Instr(Fldname,".") > 0 Then
			GetFileTypeName = replace(Replace(Lcase(Split(Fldname,".")(UBound(Split(Fldname,".")))),chr(0),""),"'","")
		Else
			ErrPrint "文件名非法，请修改后再上传"
		End If
	End Function
	
	Public Sub ErrPrint(MText)
		Response.Write "<body leftmargin=0 topmargin=0>&nbsp;&nbsp;<font style='font-size:12px'>" & Mtext & "</font> <input type=button value='返回上传界面' onclick='javascript:history.go(-1)' style='font-size:12px'></body>"
		Response.End
	End Sub

	Public Function getImageWH(FData) 

		Dim ret(2),BFlag,FSize,s

		FSize = Clng(Lenb(FData))
		If FSize = 0 Then	Exit Function

		Set S = Server.CreateObject("ADODB.Stream")
		With S
			.Type = 1 
			.Mode = 3 
			.Open
			.Write FData
			.Position = 0
			BFlag = .Read(3)

			If IsNull(BFlag) Then 
				ret(0) = "unknow"
				ret(1) = 0
				ret(2) = 0
				GetImageWH = ret
				Exit Function
			End If

			Select Case Hex(BinVal(BFlag))
			Case "4E5089":
				.Read(15)
				ret(0) = "png"
				ret(1) = BinVal2(.Read(2))
				.read(2)
				ret(2) = BinVal2(.Read(2))
			Case "464947":
				.Read(3)
				ret(0) = "gif"
				ret(1) = BinVal(.Read(2))
				ret(2) = BinVal(.Read(2))
			Case "FFD8FF":
				Dim p1
				Do 
				Do: p1 = BinVal(.Read(1)): Loop While p1 = 255 And Not .EOS

				If p1 > 191 And p1 < 196 Then Exit Do Else .Read(Binval2(.Read(2)) - 2)
				Do:p1 = BinVal(.Read(1)):Loop While p1 < 255 And Not .EOS
				Loop While True
				.Read(3)
				ret(0) = "jpg"
				ret(2) = Binval2(.Read(2))
				ret(1) = Binval2(.Read(2))
			Case Else:
				If Left(Bytes2bStr(BFlag),2) = "BM" Then
					.Read(15)
					ret(0) = "bmp"
					ret(1) = Binval(.Read(4))
					ret(2) = Binval(.Read(4))
				Else
					ret(0) = ""
				End If
			End Select
		End With

		S.Close
		Set S = Nothing

		Select Case ret(0)
		Case "png","jpg","bmp","gif"
			ret(1) = ret(1)
			ret(2) = ret(2)
			ret(0) = ret(0)
		Case Else
			ret(1) = 0
			ret(2) = 0
			ret(0) = "unknow"
		End Select

		GetImageWH = ret
	End Function

	Public Function GetWebData(StrUrl)
		On Error Resume Next
		If StrUrl = "" Then
			GetWebData = ""
			Exit Function
		End If
		Dim TempStr

		TempStr = Split(StrUrl,"/")
		If TempStr(UBound(TempStr)) = "" Or InStr(StrUrl,"/") = 0 Then
			GetWebData = ""
			Exit Function
		End If

		Dim Retrieval
		Set Retrieval = Server.CreateObject("Microsoft.XMLHTTP")
		With Retrieval
			.Open "Get", StrUrl, False, "", ""
			.Send
			GetWebData =.ResponseBody
		End With
		Set Retrieval = Nothing
		If Err.Number <> 0 Then
			GetWebData = ""
			Err.Clear
			Exit Function
		End If
	End Function

	Public Sub SaveData(TargetPath,Myname,Flag)
		If MaxFile = 0 Then ErrPrint "您今天已经不能再上传文件了"
		DataSize = Request.TotalBytes
		If DataSize < 1 Then ErrPrint "无文件信息"
		IF DataSize > 0 Then
			IF Flag=1 Then
				If DataSize > Int(YxBBs.BBSSetting(19)) * 1024 Then ErrPrint "文件大小 > " & YxBBs.BBSSetting(19) & " KByte"
			Else
				If DataSize > Int(YxBBs.ClassSetting(12)) * 1024 Then ErrPrint "文件大小 > " & YxBBs.ClassSetting(12) & " KByte"
			End IF
		End IF
		FormData = Request.BinaryRead(DataSize)
		VbEnter = CHRB(13) & CHRB(10)

		Dim s
		Set S = Server.CreateObject("ADODB.Stream")
		With S
			.Type = 1
			.Mode = 3
			.Open
			.Write FormData

			bpos = Instrb(FormData,VbEnter)
			SpStr = Midb(FormData,1,bpos + 1)
			LenOfspStr = Lenb(Spstr) 
			ppoint = LenOfspStr+1
			FormData = Midb(formdata,ppoint)
			loopcnt = 0
			Do 
			bpos = Instrb(FormData,spStr)
			npoint = (ppoint + bpos + lenofspstr - 1)
			If bpos < 1 Then
				fldData = Midb(FormData,1,Instrb(FormData,Leftb(spStr,lenOfspstr - 2)) - 1)
				bpos = Lenb(fldData) + 1
				ExitFlag = True
			Else
				FldData = Leftb(FormData,bpos - 1)		
				formdata = Midb(FormData,bpos + LenOfspstr)
			End If
			Infldpos = Instrb(fldData,vbEnter & vbEnter)
			fldHeadStr = bytes2bstr(Midb(fldData,1,infldpos - 1))
			fldInfo(loopcnt,0) = fldHeadStr
			databpos = (ppoint + infldpos + 3)
			.Position = databpos - 1
			datalen = (bpos - infldpos - 6)
			If datalen = 0 Then
				fldInfo(loopcnt,1) = ""
			Else
				fldInfo(loopcnt,1) = .Read(datalen)
			End If
			ppoint = npoint
			loopcnt = loopcnt + 1
			Loop Until ExitFlag = True
		End With

		S.close
		Set S = Nothing

		FileData = MyRequest("filedata")
		FileSize = Lenb(FileData)
		If FileSize = 0 Then 
			ErrPrint "无文件信息"
		Else 
			OldFileName = GetFileName("filedata")
		End If
		FileTypeName = GetFileTypeName(OldFileName)
		If Not IsvalidFile(FileTypeName) Then ErrPrint "不允许上传" & FileTypeName & "文件"
		If FileSize > 0 Then
			Dim aW,W
			aW = getImageWH(FileData)
			If aW(1) > 450 Then
				W = 450
			Else
				W = aW(1)
			End If
			If aW(2) > 1500 Then ErrPrint "不允许上传高度超过1500像素的图片"

			Dim Sid
			If IsNumeric(Session.SessionID) Then Sid = Session.SessionID
			NewFileName = Cstr(Year(Date)) & Cstr(Month(Date)) & Cstr(Day(Date)) & Cstr(Hour(Time)) & Cstr(Minute(Time)) & Cstr(Second(Time)) & Right(Cstr(Sid),2) & "." & FileTypeName 
			If Flag=1 Then
				NewFileName = MyName & "." & FileTypeName
				If aW(2) > Int(YxBBs.BBSSetting(15)) Or aW(1) > Int(YxBBs.BBSSetting(15)) Then ErrPrint "头像超出限制尺寸"&YxBBs.BBSSetting(15)&"×"&YxBBs.BBSSetting(15)&"(单位:px)."
			End If
			Dim BasePath,SQL
			BasePath = TargetPath

			Call SavetoFile(FileData,BasePath,NewFileName)
			'UPLOADStr = "[UPLOAD=" & FileTypeName & "," & FormatNumber(FileSize/1024,2) & "," & W & "," & aW(1) & "," & aW(2) & "]" & NewFileName & "[/UPLOAD]"
			Width = aW(1)
			Height = aW(2)
			ReWidth = W
			FileSizeKB = FormatNumber(FileSize/1024,2,-1,-2,0)

			FileName = NewFileName
		Else
			ErrPrint "系统出错，请稍后再试"
		End If

	End Sub
End Class
%>
<%
Const FilePath = "./UploadFile/TopicFile"
Const FacePath = "./UploadFile/Head"
Dim Upload,ReturnString,Temp
YxBBs.Fun.CheckMake
If Not YxBBs.FoundUser Then YxBBs.Error("您还没有注册或者登陆！")
Set Upload = New Upload_Cls
If Request.QueryString("Flag") = "0" Then
	YxBBs.CheckBoard()
End If
IF Cint(YxBBs.ClassSetting(6))=0 Then YxBBs.Error("您没有上传文件的权限！")
Temp=YxBBs.Execute("Select Count(*) From[YX_UpFile] where UserName='"&YxBBs.MyName&"' And DATEDIFF('d',[UpTime],'"&YxBBs.NowBbsTime&"')<1")(0)
If IsNull(Temp) Then Temp=YxBBs.ClassSetting(11)
If Int(Temp) => Int(YxBBs.ClassSetting(11)) Then Upload.MaxFile=0
If Request.QueryString("Flag") = "0" Then
	Upload.FileTypeFlag = Split(YxBBs.BoardSetting(1),"|")
Else
	Upload.FileTypeFlag = YxBBs.UploadType
End If
If Request.QueryString("Flag") = "0" Then
	Upload.SaveData FilePath,"",0
        If YxBBs.BBSSetting(56)="0" then
        If YxBBs.BBSSetting(58)="0" then
        If Lcase(upload.FileTypeName)="gif" or Lcase(upload.FileTypeName)="jpg" or Lcase(upload.FileTypeName) = "bmp" Then 
        On Error Resume Next
Dim Jpeg
Set Jpeg = Server.CreateObject("Persits.Jpeg") 
Jpeg.Open Server.MapPath(FilePath&"/"&Upload.FileName) 
Jpeg.Canvas.Font.Color = &Hffffff
Jpeg.Canvas.Font.Size=12 
Jpeg.Canvas.Font.Family = "monospace" 
Jpeg.Canvas.Print 10,10, ""&YxBBs.BBSSetting(57)&"" 
Jpeg.Save Server.MapPath(FilePath&"/"&Upload.FileName)
End If
else
If Lcase(upload.FileTypeName)="gif" or Lcase(upload.FileTypeName)="jpg" or Lcase(upload.FileTypeName) = "bmp" Then 
Dim Logobox
Set Jpeg = Server.CreateObject("Persits.Jpeg") 
  Jpeg.Open Server.MapPath(FilePath&"/"&Upload.FileName) 
  If Jpeg.OriginalWidth > 82 And Jpeg.OriginalWidth > 14 Then
   Set Logobox = Server.CreateObject("Persits.Jpeg")
   Logobox.Open Server.MapPath("images/logobox.gif")
   Logobox.Width = 119 'logobox.gif的宽
   Logobox.Height = 30 'logobox.gif的高
   Jpeg.DrawImage Jpeg.OriginalWidth - 119 , Jpeg.OriginalHeight - 31, Logobox, .70,"&h0066cc",90
   '82 13 哪些测试修改一下。
   Logobox.Close 
   Set Logobox=Nothing
   Jpeg.Save Server.MapPath(FilePath&"/"&Upload.FileName)
  End If
Jpeg.Close 
Set Jpeg = Nothing 
End If
End If
End If
	ReturnString = "[UPLOAD=" & Upload.FileTypeName & "," & Upload.FileSizeKB & "," & Upload.ReWidth & "," & Upload.Width & "," & Upload.Height & "]" & Upload.FileName & "[/UPLOAD]"
	YxBBs.Execute("insert into [YX_UpFile](FileName,FileType,FileSize,UpTime,UserName,Dname) values ('"&Upload.FileName & "','" & upload.FileTypeName & "'," & upload.FileSize & ",'"& YxBBs.NowBBSTime &"','" & YxBBs.MyName & "','"&Replace(upload.OldFileName,"'","''")&"')")
Else
	Upload.SaveData FacePath,YxBBs.MyID,1
	ReturnString =  "ViewFile.Asp?Path=Face&FileName=" & Upload.FileName
End If
If Request.QueryString("Flag") = "0" Then

	Response.Write("<body leftmargin=""0"" topmargin=""0"" onload=""javascript:parent.KE.g['content'].iframeDoc.body.innerHTML +='"&ReturnString&"';parent.topicform.topicpic.value='"&Upload.FileName&"';"">")
Else
	Response.Write("<body leftmargin=""0"" topmargin=""0"" onload=""javascript:parent.form.PicUrl.value='"&ReturnString&"';parent.form.Pic.src='"&ReturnString&"';parent.form.PicW.value='"&Upload.Width&"';parent.form.PicH.value='"&Upload.Height&"';"">")
End If
Upload.ErrPrint "上传成功"
Set Upload=Nothing
Set YxBBs=Nothing
%>