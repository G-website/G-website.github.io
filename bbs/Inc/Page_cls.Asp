<%
 Class Cls_PageView
  Private CookiesCacheName,CookiesCacheData,sstrCookiesName,CSQL
  Private sstrPageUrl,sstrPageVar,sstrTableName,sstrFieldsList,sstrCondiction,sstrOrderList,sstrPrimaryKey,sintRefresh
  Private sintRecordCount,sintPageSize,sintPageNow,sintPageMax,sstrPageInfo,sReloadtime
  
  Private Sub Class_Initialize
   sstrCookiesName = ""
   sstrPageUrl = ""
   sstrPageVar = "page"
   sstrTableName = ""
   sstrFieldsList = ""
   sstrCondiction = ""
   sstrOrderList = ""
   sstrPrimaryKey = ""
   sintRefresh = 0
   Reloadtime=3
   sintRecordCount = 0
   sintPageSize = 0
   sintPageNow = 0
   sintPageMax = 0
   CSQL=""
   CookiesCacheName=LCase(Replace(Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL"),Split(request.ServerVariables("SCRIPT_NAME"),"/")(ubound(Split(request.ServerVariables("SCRIPT_NAME"),"/"))),""))
  End Sub
   
  Private Sub class_terminate()
  ' Set Conn=nothing
  End Sub
    
 '类初始化,外部调用
  Public Sub InitClass()
	If Not IsObject(Conn) Then ConnectionDatabase
	Call InitRecordCount()
	Call InitPageInfo()   
  End Sub
  
  '保存记录数的 Cookies 变量
  Public Property Let strCookiesName(Value)
   sstrCookiesName = Value
  End Property
  '保存更新 Cookies 的时间
  Public Property Let Reloadtime(Value)
   sReloadtime = Value
  End Property  
  '转向地址
  Public Property Let strPageUrl(Value)
   sstrPageUrl = Value
  End Property
   

  ' 表名
  Public Property Let strTableName(Value)
   sstrTableName = Value
  End Property
  '字段列表
  Public Property Let strFieldsList(Value)
   sstrFieldsList = Value
  End Property
  '查询条件
  Public Property Let strCondiction(Value)
   If Value <> "" Then
    sstrCondiction = " WHERE " & Value
   Else
    sstrCondiction = ""
   End If
  End Property
  '排序字段, 如: [ID] ASC, [CreateDateTime] DESC
  Public Property Let strOrderList(Value)
   If Value <> "" Then
    sstrOrderList = " ORDER BY " & Value
   Else
    sstrOrderList = ""
   End If
  End Property
   '获得总记录数
  Public Property Let CountSQL(TSQL)
	CSQL=TSQL
  End Property 
 '用于统计记录数的字段
  Public Property Let strPrimaryKey(Value)
   sstrPrimaryKey = Value
  End Property
  
  '每页显示的记录条数
  Public Property Let intPageSize(Value)
   sintPageSize = toNum(Value, 20)
  End Property

  '当前页
  Public Property Let intPageNow(Value)
   sintPageNow = toNum(Value, 1)
  End Property
  
  '页面参数名称
  Public Property Let strPageVar(Value)
   sstrPageVar = Value
  End Property
  
  '是否刷新. 1 为刷新, 其他值则不刷新
  Public Property Let intRefresh(Value)
   sintRefresh = toNum(Value, 0)
  End Property
  
  '获得当前页
  Public Property Get intPageNow()
   intPageNow = sintPageNow
  End Property
  
  '获得分页信息
  Public Property Get strPageInfo()
   strPageInfo = sstrPageInfo
  End Property
  
    'cookies时间是否清空
   	Private Function ObjIsEmpty()
		Dim Temp
		ObjIsEmpty=True
		Temp = Request.Cookies("YxBBs")(CookiesCacheName&"_"&sstrCookiesName)
		CookiesCacheData=Split(Temp,"|||")
		If Instr(Temp,"|||")=0 Then Exit Function
		If Not IsArray(CookiesCacheData) Then Exit Function
		If Not IsDate(CookiesCacheData(1)) Then Exit Function
		If DateDiff("s",CDate(CookiesCacheData(1)),Now()) < 60*sReloadtime  Then
			ObjIsEmpty=False
		End If
	End Function

  
  '取得记录集, 二维数组或字串, 在进行循环输出时必须用 IsArray() 判断
  Public Property Get arrRecordInfo()
	Dim rs, sql
	sql = "SELECT " & sstrFieldsList & " FROM " & sstrTableName & sstrCondiction & sstrOrderList
	If Not IsObject(Conn) Then ConnectionDatabase
	Set rs = Server.CreateObject("Adodb.RecordSet")
	rs.open sql, Conn, 1, 1
	If Not(rs.eof or rs.bof) Then
		rs.PageSize = sintPageSize
		If sintpageNow=0 Then sintpageNow=1
		rs.AbsolutePage = sintPageNow
		If Not(rs.eof or rs.bof) Then
			arrRecordInfo = rs.getrows(sintPageSize)
		Else
			arrRecordInfo = ""
		End If
	Else
		arrRecordInfo = ""
	End If
	rs.close
	Set rs = nothing
  End Property
  
  '初始化记录数
  Private Sub InitRecordCount()
	If Not ObjIsEmpty() Then
		sintRecordCount = Value
	Else
		Dim sql,rs
		If CSQL="" Or IsNull(CSQL) Then
			sql = "SELECT COUNT(" & sstrPrimaryKey & ")" & " FROM " & sstrTableName & sstrCondiction
			If Not IsObject(Conn) Then ConnectionDatabase
			Set rs = Conn.execute(sql)
			If rs.eof or rs.bof Then
			sintRecordCount = 0
			Else
			sintRecordCount = rs(0)
			End If
			Rs.close
			Set Rs=nothing
		Else
			sintRecordCount=CSQL
		End If
		Value=sintRecordCount
	End If
End Sub

    Private  Property Let Value(ByVal vNewValue)
	Dim Temp
		If sstrCookiesName<>"" Then 
		    Temp = Request.Cookies("YxBBs")(CookiesCacheName&"_"&sstrCookiesName)
			CookiesCacheData=Split(Temp,"|||")
			If IsArray(CookiesCacheData) And Instr(Temp,"|||")>0 Then
				CookiesCacheData(0)=vNewValue
				CookiesCacheData(1)=Now()
			Else
				ReDim CookiesCacheData(2)
				CookiesCacheData(0)=vNewValue
				CookiesCacheData(1)=Now()
			End If
			SetCookies CookiesCacheName&"_"&sstrCookiesName,CookiesCacheData
		Else
			Err.Raise vbObjectError + 1, "YxBBsCacheServer", " please change the CacheName."
		End If		
	End Property
	
	Private Property Get Value()
	Dim Temp
		If sstrCookiesName<>"" Then 
		    Temp = Request.Cookies("YxBBs")(CookiesCacheName&"_"&sstrCookiesName)
			CookiesCacheData=Split(Temp,"|||")
			If IsArray(CookiesCacheData) And Instr(Temp,"|||")>0 Then
				Value=CookiesCacheData(0)
			Else
				Err.Raise vbObjectError + 1, "YxBBsCacheServer", " The CacheData Is Empty."
			End If
		Else
			Err.Raise vbObjectError + 1, "YxBBsCacheServer", " please change the CacheName."
		End If
	End Property 
  
  '初始化分页信息
  Private Sub InitPageInfo()
	Dim surl,i,PageNMin,PageNMax
	sstrPageInfo = ""
	surl = sstrPageUrl   
	If Instr(1, surl, "?", 1) > 0 Then
	surl = surl & "&" & sstrPageVar & "="
	Else
	surl = surl & "?" & sstrPageVar & "="
	End If
	If sintPageNow <= 0 Then sintPageNow = 1
	If sintRecordCount mod sintPageSize = 0 Then
		sintPageMax = sintRecordCount \ sintPageSize
	Else
		sintPageMax = sintRecordCount \ sintPageSize + 1
	End If
	If sintPageNow > sintPageMax Then sintPageNow = sintPageMax
	sstrPageInfo =  "<div class=""page"" style=""text-align: left; float: left;width:40%;padding-top:4px; "" >&nbsp;每页<font color=""red"">"&sintPageSize&"</font>条,共<font color=""red"">"&sintPageMax&"</font>页"
	sstrPageInfo = sstrPageInfo&",合计<font color=""red"">"&sintRecordCount&"</font>条记录"
	
	sstrPageInfo = sstrPageInfo &"</div><div class=""page"" style="" text-align: center; float: left;width:30%;padding-top:4px;"">"
	PageNMin=sintPageNow-4
	if PageNMin<1 then PageNMin=1' 显示最小页数
	PageNMax=sintPageNow+4
	if PageNMax>sintPageMax then PageNMax=sintPageMax' 显示最大页面
		sstrPageInfo = sstrPageInfo &"<a href='" & surl & "1'><font title='首页' face=webdings>9</font></a>&nbsp;&nbsp;"
	If sintPageNow>5 Then'如果页码值大于5则显示(更前)当前
		sstrPageInfo = sstrPageInfo &"<a href='" & surl & (sintPageNow - 5) & "' ><font face=webdings title='上五页'>7</font></a> "
	End if
	For i =PageNMin To PageNMax'循环输出页码
	If(i=sintPageNow) Then
	sstrPageInfo = sstrPageInfo &"<b><font color='#FF6600' >"& i &"</font></b>&nbsp;&nbsp;"
	else
	sstrPageInfo = sstrPageInfo &"<b><A title='转到第"& i &"页' HREF='" & surl & i &"'>"& i &"</A></b>&nbsp;&nbsp;"
	End if
	Next
	If (sintPageMax-sintPageNow)>5  Then
		sstrPageInfo = sstrPageInfo &"<a href='" & surl & (sintPageNow + 5) & "'><font face=webdings  title='下五页'>8</font></a>&nbsp;&nbsp;"
	End if
	sstrPageInfo = sstrPageInfo &"<a href='" & surl & sintPageMax & "' ><font title='尾页' face=webdings>:</font></a>"
	sstrPageInfo = sstrPageInfo &"</div><div class=""page"" style="" text-align: right; float: left;width:20%;padding-top:1px;"">转到<input maxLength='6' size='2' name='topage' value='"&sintPageNow&"' onkeydown=if(window.event.keyCode==13){window.location.href='"&surl&"'+topage.value;}> <input Class='go' value='GO' type='button' onClick=location.href='"&surl&"'+topage.value>&nbsp;</div>"
End Sub
    
  '记录Cookies
  Private Sub SetCookies(Name,NewValue)
	   Response.Cookies("YxBBs").Expires = Date()+1
       Response.Cookies("YxBBs")(Name)=Join(NewValue,"|||")
  End Sub
 '清空Cookies
    Public Sub DelCookiesCache(Name)
        Response.Cookies("YxBBs").Expires = Date()+1
		Response.Cookies("YxBBs")(CookiesCacheName&"_"&Name)=""
	End Sub
   '长整数转换
  Private function toNum(s, Default)
	s = s & ""
	If s <> "" And IsNumeric(s) Then
		toNum = int(s)
	Else
		toNum = Default
	End If
  End function
End Class
 %>