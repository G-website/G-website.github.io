<%
'--------数据库连接部分--------------
dim dbkillSql,killSqlconn,connkillSql
dbkillSql=db
Set killSqlconn = Server.CreateObject("ADODB.Connection")
connkillSql="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath(dbkillSql)
killSqlconn.Open connkillSql
If Err Then
	err.Clear
	Set killSqlconn = Nothing
	Response.Write "数据库连接出错，请检查连接字串。"
	Response.End
End If


'--------定义部份------------------
Dim N_Post,N_Get,N_In,N_Inf,N_Xh,N_db,N_dbstr,N_i,Kill_IP
Dim N_rs,N_sql,N_info,alert_url,Sec_Forms,Sec_Form
set N_rs=server.CreateObject("adodb.recordset")
N_sql="select * from Yx_Config"
N_rs.open N_sql,killSqlconn
'获取配置信息
N_info=split(N_rs("info"),"|")
N_In = N_rs("N_In")
Kill_IP = N_info(67)
alert_url = N_rs("bbsurl")
Sec_Forms = N_rs("Safe_In")

'安全页面参数
Sec_Form = split(Sec_Forms,"|")
N_Inf = split(N_In,"|")

If Kill_IP=0 Then Stop_IP

		
If Instr(LCase(SelfName),"saveupload.asp")> 0 Then 

				else
If Request.Form<>"" Then StopInjection(Request.Form)

If Request.QueryString<>"" Then StopInjection(Request.QueryString)

'If Request.Cookies<>"" Then StopInjection(Request.Cookies)

	End If 
			

Function Stop_IP()
	Dim Sqlin_IP,rsKill_IP,Kill_IPsql
	Sqlin_IP=Request.ServerVariables("REMOTE_ADDR")
	Kill_IPsql="select IP from Yx_sql where IP='"&Sqlin_IP&"' and kill_ip=true"
	Set rsKill_IP=killSqlconn.execute(Kill_IPsql)
	If Not(rsKill_IP.eof or rsKill_IP.bof) Then
		Response.Write("您的IP已被记录！")
	Response.End
	End If
	rsKill_IP.close	
End Function

'输出警告信息
Function N_Alert()
	Dim str
	str = "<"&"Script Language=JavaScript"&">"
	str = str & "location.href='"&alert_url&"';"
	str = str & "<"&"/Script"&">"
	response.write  str
End Function 

'判断注入类型函数
Function intype(values)
	Select Case values
		Case Request.Form
			intype = "Post"
		Case Request.QueryString
			intype = "Get"
		Case Request.Cookies
			intype = "Cookies"
	end Select
End Function 

'sql通用防注入主函数
Function StopInjection(values)
	For Each N_Get In values
			For N_i=0 To UBound(Sec_Form)
		
				If Instr(LCase(SelfName),Sec_Form(N_i))> 0 Then 
					Exit Function
				else
					Select_BadChar(values)
				End If 
			Next
	Next
End Function 

Function Select_BadChar(values)
	For N_Xh=0 To Ubound(N_Inf)
		If Instr(LCase(values(N_Get)),N_Inf(N_Xh))<>0 Then
			InsertInfo(values)
			N_Alert()
			Response.End
		End If
	Next
End Function

'将注入记录记录到数据库函数
Function InsertInfo(values)
	Dim ip,url,sql
	ip = Request.ServerVariables("REMOTE_ADDR")
	url = Request.ServerVariables("URL")
	sql = "insert into Yx_Sql(IP,Web,FS,CS,SJ) values('"&ip&"','"&url&"','"&intype(values)&"','"&N_Get&"','"&N_Replace(values(N_Get))&"')"
	'response.write sql
	killSqlconn.Execute(sql)
	killSqlconn.close
	Set killSqlconn = Nothing
End Function

Function N_Replace(N_urlString)
	N_urlString = Replace(N_urlString,"'","''")
    N_urlString = Replace(N_urlString, ">", "&gt;")
    N_urlString = Replace(N_urlString, "<", "&lt;")
    N_Replace = N_urlString
End Function

'获取本页文件名
Function SelfName()
    SelfName = Mid(Request.ServerVariables("URL"),InstrRev(Request.ServerVariables("URL"),"/")+1)
End Function

%>

    