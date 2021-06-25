<!--#include file="check.asp"-->
<%dim action,id,temp,i,str,skinconn
id=request.querystring("id")
if id="" then id=0
str="页面属性|菜单属性|页面头部|你的位置|快速登陆|用户信息|分区表格|版块列表|版块最后回复|分区底部表格|内容表格|在线统计|版块在线|在线显示|主题列表顶部|主题列表|主题列表底部|帖子顶部|显示投票|帖子信息|帖子底部|用户登陆|各项列表顶部|各项列表底部|页面底部|版块类型图片|用户类型图片|发帖图片|帖子状态图片"
response.write("<body>")
action=lcase(request.querystring("action"))
select case action
case "editplus"
	editplus
case "saveplus"
	saveplus
case "delplus"
	delplus
case "bank"
	bank
case "savebank"
	savebank
case  "skin"
	skinhead
	skin
case "skindel"
	skindel
case "auto"
	auto
case "ismode"
	ismode
case "addskin"
    skinhead
	addskin
case "saveaddskin"
	saveaddskin
case "editskin"
    skinhead
	editskin
case "saveeditskin"
	saveeditskin
case "updateskinname"
	updateskinname
case "skindata"
	skinhead
	skindata
case "load"
	skinhead
	load
case "datapost"
	datapost
case "n_sql"
	n_sql
case "lock"
	Lockip
case "unlock"
	UnLockip
case "delip"
	Delip
case "delallip"
    DelAllip
	
case else
      plus
end select
adminfooter()
%>
<script language="javascript">
<!--
var isopen=1;
function Edit(obj,Node){
	document.all.form1.NodeType.value = Node;
	document.all.form1.SkinName.value = Node;
	document.all.form1.Content.value = obj.innerText;
}
//-->
</script>

<% sub plus
	dim i
%>
	<form method=post name=form style='margin:0' action=plus.asp?action=saveplus>
	<div class="ta">
        <div class="th jz">添加论坛插件</div>
        <div class="td1 h20">插件名称：</div>
        <div class="td2 h20"><input type="text" name="plusname" size="20"></div>
	<div class="td1 h20">连接文件：</div>
	<div class="td2 h20"><input type="text" name="plusurl" size="38">(请填写相对路径)</div>
	<div style="clear: both;"></div><div class="tf jz"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div>
	</div></form><br />
<div class="ta">
<div class="td3 w231">插件名称</div>
<div class="td3 w231">连接文件</div>
<div class="td3 w291">操作</div>

	<%
	set rs=yxbbs.execute("select id,name,url,flag from [yx_plus] order by flag desc")
	do while not rs.eof
	%>
	<div class="td3 h20 w231"><%=rs(1)%></div><div class="td3 h20 w231">&nbsp;<a href="../<%=rs(2)%>" target="_blank"><%=rs(2)%></a></div>
	<div class="td3 h20 w291"><a href="?action=editplus&id=<%=rs(0)%>"><img src="../images/edit.gif" border="0" align="absmiddle"> 编辑</a> <a onclick=checkclick('删除后将不能恢复！您确定要删除吗？') href="plus.asp?action=delplus&id=<%=rs(0)%>"><img src="../images/del.gif" width="18" height="18" border="0" align="absmiddle"> 删除</a></div>
	<%rs.movenext
	loop
	rs.close
	%>
<div style="clear: both;"></div></div>
	</form>
<%
end sub

sub editplus
	set rs=yxbbs.execute("select name,url,flag from [yx_plus] where id="&id&"")
%>
	<form method=post name=form style='margin:0' action=plus.asp?action=saveplus>
        <div class="ta">
        <div class="th jz">修改论坛插件</div>
        <div class="td1 h20">插件名称：</div>
        <div class="td2 h20"><input name="id" type="hidden" value="<%=id%>"><input type="text" name="plusname" size="20" value="<%=rs(0)%>"></div>
	<div class="td1 h20">连接文件：</div>
	<div class="td2 h20"><input type="text" name="plusurl" size="38" value="<%=rs(1)%>">(请填写相对路径)</div>
	<div style="clear: both;"></div><div class="tf jz"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div>
	</div></form>
<%rs.close
end sub

sub saveplus
	dim plusname,plusurl,flag,id
	plusname=yxbbs.fun.getstr("plusname")
	plusurl=yxbbs.fun.getstr("plusurl")
	id=yxbbs.fun.getstr("id")
	if plusname="" or plusurl="" then
		call goback("",""):exit sub
	end if
	if id<>"" then
		yxbbs.execute("update [yx_plus] set name='"&plusname&"',url='"&plusurl&"' where id="&id)
		cache.name="plusmenu":cache.clean()
		call suc("","成功的修改了插件："&plusname&"","plus.asp?action=plus")	
	else
		yxbbs.execute("insert into [yx_plus](name,url) values('"&plusname&"','"&plusurl&"')")
		cache.name="plusmenu":cache.clean()
		call suc("","成功的添加了插件："&plusname&"","plus.asp?action=plus")
	end if
end sub

sub delplus
	dim id
	id=request.querystring("id")
	yxbbs.execute("delete from[yx_plus] where id="&id)
	cache.name="plusmenu":cache.clean()
	call suc("","成功删除了插件","plus.asp?action=plus")
end sub
sub bank
%>
<form method=post  style='margin:0' action=plus.asp?action=savebank  onsubmit="ok.disabled=true;ok.value='银行正在处理-请稍等。。。'">
<div class="ta">
<div class="th jz">后台银行</div>
<div class="td1 h20">对象：</div>
<div class="td2 h20"><select name='user' style='font-size: 9pt'>
<option value=0>所有在线用户</option>
<option value=1 selected>所有版主</option>
<option value=2>所有总版主</option>
<option value=3>所有管理员</option>
<option value=4>管理团队(板主+管理员)</option>
<option value=5>所有注册用户</option>
</select></div>
<div class="td1 h20">操作：</div>
<div class="td2 h20"><input name="flag" type="radio" value="1"  checked="true"> 送钱 <input name="flag"  type="radio"value="0"> 扣钱</div>
<div class="td1 h20">金额：</div>
<div class="td2 h20"><input name="coin" type="text" value="1000" size="10" maxlength="5"></div>
<div style="clear: both;"></div><div class="tf jz"><input  type='submit' value='确定' name="ok">&nbsp;<input type='reset' value='重写'></div>
</div>


</form>
<%
end sub

sub savebank
	dim usertype,sql,coin,flag,i,mrs
	usertype=yxbbs.fun.getstr("user")
	coin=yxbbs.fun.getstr("coin")
	flag=yxbbs.fun.getstr("flag")
	if coin="" then call goback("",""):exit sub
	if not isnumeric(coin) then call goback("","金额请用数字填写！"):exit sub
	select case usertype
		case"0"
			sql="select name from [yx_online] where classid<>6"
		case"1"
			sql="select name from [yx_user] where classid=3"
		case"2"
			sql="select name from [yx_user] where classid=2"
		case"3"
			sql="select name from [yx_user] where classid=1"
		case"4"
			sql="select name from [yx_user] where classid<=3"
		case"5"
			sql="select name from [yx_user] where classid=5"
		case else
			call goback("","非法操作"):exit sub
	end select
	set rs=yxbbs.execute(sql)
	if not rs.eof then
		mrs=rs.getrows(-1)
		rs.close
		for i=0 to ubound(mrs,2)
			if flag="1" then
				yxbbs.execute("update [yx_user] set coin=coin+"&coin&" where name='"&mrs(0,i)&"'")
			else
				set rs=yxbbs.execute("select coin,banksave from[yx_user] where name='"&mrs(0,i)&"'")
				if not rs.eof then
					if ccur(rs(0)) < ccur(coin) then
						if ccur(coin)-ccur(rs(0))>ccur(rs(1)) then
							yxbbs.execute("update [yx_user] set coin=0,banksave=0 where name='"&mrs(0,i)&"'")
						else
							yxbbs.execute("update [yx_user] set coin=0,banksave=banksave-"&ccur(coin)-ccur(rs(0))&" where name='"&mrs(0,i)&"'")
						end if
					else
						yxbbs.execute("update [yx_user] set coin=coin-"&coin&" where name='"&mrs(0,i)&"'")
					end if
				end if
				rs.close
			end if
		next
	end if
	call suc("","银行处理成功！","plus.asp?action=bank")
end sub


sub skinhead

call showtable("论坛风格设置","<center><a href=?action=skin>【风格管理】</a> &nbsp; <a href=?action=addskin>【添加风格】</a>&nbsp;&nbsp;<a href=?action=load>【风格数据导入】</a>&nbsp;&nbsp;<a href=?action=skindata>【风格数据导出】</a></center>")

end sub

function savereplace(str)
	str = replace(str,"[","{lfg}")
	str = replace(str,"]","{rfg}")
	savereplace = str
end function

sub skin
dim  rs,rst,mainid
set rst=yxbbs.execute("select skinid,skinname,flag,ismode from [yx_skinstyle] order by skinid asc")
rs=rst.getrows()
rst.close
%>
<div class="ta">
<div class="th1 jz w231">风格id</div>
<div class="th1 jz w258">风格名称</div>
<div class="th1 jz w291">风格管理</div>
  <%
	dim i
    for i=0 to ubound(rs,2)
	%>
	 <div class="td3 h20 w231"><%=rs(0,i)%></div><div class="td3 h20 w231"><%=rs(1,i)%></div><div class="td3 h20 w291">
		 <% if rs(2,i) then 
		 response.write "<font  color=#ff0033><b>√</b> 论坛默认</font>"
		 else
		 response.write "<b>×</b> <a href=""?action=auto&id="&rs(0,i)&""">论坛默认</a>"
		 end if
		 response.write " &nbsp; "
		 if rs(3,i) then
		 response.write "<font  color=#ff0033><b>√</b> 做为模版</font>"
		 else
		 response.write "<b>×</b> <a href=""?action=ismode&id="&rs(0,i)&""">做为模版</a>"
		 end if		 
		 %>　&nbsp; <a href="?action=editskin&id=<%=rs(0,i)%>"><img src="../images/edit.gif" border="0" align="absmiddle"> 修改</a> &nbsp; <a href="?action=skindel&id=<%=rs(0,i)%>" onclick="<%if rs(2,i) then%>alert('此风格论坛正在使用中，论坛默认风格不能删除！');return false;<%else%>checkclick('删除后将不能恢复！您确定要删除吗？')<%end if%>"><img src="../images/del.gif" border="0" align="absmiddle"> 删除</a></div>
    <%next%>
<div style="clear: both;"></div></div>
<%
end sub
sub auto
   yxbbs.execute("update [yx_config] set skinid="&id)
   yxbbs.execute("update [yx_skinstyle] set flag=true where skinid="&id )
   yxbbs.execute("update [yx_skinstyle] set flag=false where skinid<"&id&" or skinid>"&id)
   call suc("","风格设为论坛默认使用成功！","?action=skin")
end sub

sub ismode
   yxbbs.execute("update [yx_skinstyle] set ismode=true where skinid="&id )
   yxbbs.execute("update [yx_skinstyle] set ismode=false where skinid<"&id&" or skinid>"&id)
   call suc("","此风格被设置为添加论坛风格的引用模版！","?action=skin")
end sub

sub skindel
	yxbbs.execute("delete from [yx_skinstyle] where skinid="&id)
	call suc("","风格已被成功删除！","?action=skin")
end sub

sub addskin
dim temp,skinname,txt,ismode
set rs=yxbbs.execute("select top 1 skinname,skinid,skincontent from [yx_skinstyle] where ismode")
if not rs.eof then
	ismode=true
	skinname=rs("skinname")
	yxbbs.template.templatecontent=rs("skincontent")
	temp=yxbbs.template.readtemplatename
	txt="当前的元素引用 风格模版 <font color=red>" & SkinName &"</font>"
else
	ismode=false
	temp=split(str,"|")
	txt="当前没有引用 风格模版 "
end if
rs.close
%>
<script>
var isopen=1;
</script>
<form method=post style="margin:0 " action="?action=saveaddskin">
<div class="ta">
<div class="th jz">添加新风格</div>
<div class="tf">风格名称：<input type="text" name="skinname" >&nbsp;&nbsp;&nbsp;<%=txt%></div>
<%
		for i = 0 to ubound(temp)
			 response.write "<div class=""td3 w771""><li>" & temp(i) & "</div><div class=""tf w771""><TEXTAREA NAME='TmpName_"&i&"' ROWS=10>"
			 If IsMode Then
			 Response.Write YxBBs.Fun.HtmlCode(YxBBs.Template.ReadTemplate(Temp(i)))
			 End If
			 response.write"</textarea></div>"
		next
%>
<div style="clear: both;"></div><div class="tf"><input name="submit" type="submit" value=" 添 加 "></div>
</div></form>
<%
end sub

sub saveaddskin
dim temp,content,resulterr,ts
  if request("skinname")="" then
     call goback("","请填写风格名称！")
	 exit sub
  end if
  temp=split(str,"|")
  for i = 0 to ubound(temp)
      content=content&vbcrlf&vbcrlf&"["&temp(i)&"]"&vbcrlf&vbcrlf&savereplace(request("tmpname_"&i))&vbcrlf&vbcrlf&"[/"&temp(i)&"]"
      if request("tmpname_"&i)="" then
        resulterr=resulterr&"<font color=#ff0033>"&temp(i)&"</font>，"
	  end if
  next
  yxbbs.execute("insert into yx_skinstyle(skinname,skincontent) values('"&replace(request("skinname"),"'","''")&"','"&replace(content,"'","''")&"')")
  if resulterr<>"" then
	  call suc("","此风格模版以下的元素"&resulterr&" 没有内容!<li>请到风格管理里面编辑！","?action=skin")
  else
	  call suc("","成功添加<b>"&request("skinname")&"</b>风格","?action=skin")
  end if
end sub

sub editskin
	dim temp,skinname
	set rs=yxbbs.execute("select skinname,skincontent from [yx_skinstyle] where skinid="&id)
	skinname=rs(0)
	yxbbs.template.templatecontent=rs(1)
	rs.close
	temp=yxbbs.template.readtemplatename
	%>
<div class="ta">
<div class="th jz">修改风格</div>
<div class="tf h20"><form method=post style="margin:0" action="?action=updateskinname">风格名称:<input type="text" name="skinname" value="<%=skinname%>"> <input type="hidden" name="id" value="<%=id%>"><input type="submit" value="更改风格名称">
</form></div>
<%
	if isarray(temp) then
		for i = 0 to ubound(temp)
			 response.write "<div class=""td3 h20 w100""><li>" & temp(i) & " </div><div class=""td3 h20 w680""><a href=#edit onclick=""Edit(viewcode" & i & ",'" & Temp(i) & "')"">修改</a></div><div class=""tf w770"" id='viewcode"& i &"' bordercolor=#999999 style='color:#888888;display:none'>" &HtmlenCode(YxBBs.Template.ReadTemplate(Temp(i)))&  "</div>"
		next
	else
		response.write "<div class=""td3 w771"">暂时还没有风格模板元素</div>"
	end if
%>

<br />
<form name=form1 style="margin:0 " method=post action="?action=saveeditskin">
<div class="td1 w770"><INPUT TYPE="hidden" Name="SkinName" value="no"><INPUT TYPE="hidden" name="ID" value="<%=ID%>">
       <font color=red>修改风格元素</font><a name=Edit></a>：&nbsp;<INPUT TYPE="text" NAME="NodeType" ReadOnly>
       <br> &nbsp;&nbsp;<br><textarea name=Content cols="100" rows="15" style="font-size:12px"></textarea><input type=submit value=" 修改风格 "></div>
<div style="clear: both;"></div>
</form>
</div>
<%
end sub


sub saveeditskin
	dim temp
	id=yxbbs.fun.getstr("id")
	set rs=yxbbs.execute("select skincontent from[yx_skinstyle] where skinid="&id)
	yxbbs.template.templatecontent=rs(0)
	rs.close
	if request.form("skinname")<>"no" and request.form("skinname")<>"" then
		temp=yxbbs.template.edittemplate(request.form("skinname"),request.form("content")) 
		temp=replace(temp,"&#160;"," ")
		yxbbs.execute("update [yx_skinstyle] set skincontent='"&replace(temp,"'","''")&"' where skinid="&id)
		call suc("","风格的元素 ["&request.form("skinname")&"] 风格修改成功。",request.servervariables("http_referer"))
		cache.name="skin_"& id
		cache.clean()
	else
	     call goback("","请先选取相应的风格元素。")
	end if
end sub

function HtmlenCode(fstring)
	if not isnull(fstring) then
		fstring = replace(fstring, ">", "&gt;")
		fstring = replace(fstring, "<", "&lt;")
		fstring = replace(fstring, chr(32), "&nbsp;")
		fstring = replace(fstring, chr(9), "&nbsp;")
		fstring = replace(fstring, chr(34), "&quot;")
		fstring = replace(fstring, chr(39), "&#39;")
		fstring = replace(fstring, chr(13), "")
		fstring = replace(fstring, chr(10) & chr(10), "</p><p> ")
		fstring = replace(fstring, chr(10), "<br /> ")
		htmlencode = fstring
	end if
end function

sub updateskinname
	ID=Request("ID")
	YxBBs.Execute("Update [YX_SkinStyle] Set SkinName='"&Replace(Request("SkinName"),"'","''")&"' Where SkinID="&ID)
	Call Suc("","风格名称修改成功。","?action=skin")
	'Cache.name="Skin_"& ID
	'Cache.clean()
	'Cache.Name="SkinList"
	'Cache.clean()
	Application.Contents.RemoveAll
End Sub

sub datapost
	dim msg,mdbname,sid
	sID=Request("sID")
	if sid="" then call goback("","您还没有选定一个项目！"):exit sub
	mdbname=request("skinmdb")
        if request("to")="inputskin" then
	    skinconnection(mdbname)
	    if request("submit")="删除" then
	       skinconn.execute("delete from [yx_skinstyle] where skinid in ("&sid&")")
		   call suc("","风格模版成功删除！","?action=skin"):exit sub
		else
		  set rs=skinconn.execute(" select skinname,skincontent from [yx_skinstyle] where skinid in ("&sid&")  order by skinid ")
          while not rs.eof
              yxbbs.execute("insert into [yx_skinstyle](skinname,skincontent) values('"&replace(rs(0),"'","''")&"','"&replace(rs(1),"'","''")&"')")  
		rs.movenext
          wend
		  	rs.close
		  call suc("","风格模版数据导入成功！","?action=skin")
		  cache.name="skinlist"
		  cache.clean()
		  exit sub
		end if
    else
	      skinconnection(mdbname)
	      set rs=yxbbs.execute(" select skinname,skincontent from [yx_skinstyle] where skinid in ("&sid&")  order by skinid ")
          while not rs.eof
              skinconn.execute("insert into [yx_skinstyle](skinname,skincontent) values('"&replace(rs(0),"'","''")&"','"&replace(rs(1),"'","''")&"')")  
			  rs.movenext
          wend 
		  rs.close
		  call suc("","风格模版数据导出成功！","?action=skin")
   end if
end sub


sub skindata
dim flagname,mdbname,act
if request("flag")="loadthis" then
    flagname="导入"
    act="inputskin"
    mdbname=trim(request.form("skinmdb"))
    if mdbname="" then
		call goback("","请填写导出风格模版保存的表名")
		exit sub
	end if
else
	flagname="导出"
	act="outskin"
end if
%>
 <%
   if act="inputskin" then
	  skinconnection(mdbname)
	  set rs=skinconn.execute("select skinid,skinname from [yx_skinstyle] order by skinid")
   else
	 set  rs=yxbbs.execute("select skinid,skinname from [yx_skinstyle] order by skinid")
	 mdbname="../skins/yx_skinstyle.mdb"
   end if
   dim temp,i
   if rs.eof then call goback("","该数据库中没有风格模版的数据！"):exit sub%>
<form action="?action=datapost&to=<%=act%>" method=post name=even>
<div class="ta">
<div class="th jz"><%=flagname%>风格模版数据</div>
<div class="td3 jz w87">序号</div>
<div class="td3 jz w600">风格名称</div>
<div class="td3 jz w87">选择</div>
<%
   temp=rs.getrows()
   for i=0 to ubound(temp,2)
   %><div class="td3 jz w87"><%=temp(0,i)%></div><div class="td3 jz w600"><%=temp(1,i)%></div><div class="td3 jz w87"><input type="checkbox" name="sid" value="<%=temp(0,i)%>"></div>
    <%next%>
    <div class="tf w987"> <%=flagname%>的数据库：
          <input type="text" name="skinmdb" size="30" value="<%=mdbname%>"> <input type="submit" name="submit" value="<%=flagname%>">
          <%if act="inputskin" then%>
          <input type="submit" name="submit" value=删除  onclick="checkclick('删除后将不能恢复！您确定要删除吗？');">
          <%end if%>
<input type=checkbox name=chkall value=on onclick="checkall(this.form)"> 全选</div></div></form><%
end sub

sub load()
%>
<form action="?action=skindata&flag=loadthis" method=post>
<div class="ta">
<div class="th jz">导入风格模版数据库名：</div>
<div class="td w770">导入风格模版数据库名：<input name="skinmdb"  size="30" value="../skins/yx_skinstyle.mdb"></div>
<div style="clear: both;"></div><div class="tf jz"> <input type="submit" value="下一步" name="b1"></div>
</div>
</form>
<%end sub

sub skinconnection(mdbname)
on error resume next 
	set skinconn = server.createobject("adodb.connection")
	skinconn.open "provider=microsoft.jet.oledb.4.0;data source=" & server.mappath(mdbname)
	if err then 
		call goback("",mdbname&" 数据库不存在！")
		adminfooter()
		response.end
	end if
end sub


sub n_sql%>
<div class="ta"><div class="th jz">SQL注入记录</div>
<%
dim sql,listnum,page,j,nn,n
sql="select * from Yx_Sql order by id desc"
set rs=server.createobject("adodb.recordset")
rs.open sql,conn,1,1
if rs.eof and rs.bof then
	response.write "<div class=tf h20>暂无内容</div></div>"
else
'分页的实现 
listnum=20
Rs.pagesize=listnum
page=Request("page")
if (page-Rs.pagecount) > 0 then
page=rs.pagecount
elseif page = "" or page < 1 then
page = 1
end if
rs.absolutepage=page
'编号的实现
j=rs.recordcount
j=j-(page-1)*listnum
i=0
nn=request("page")
if nn="" then
n=0
else
nn=nn-1
n=listnum*nn
end if%>

<div class="td1 h20 jz w50">编号</div>
<div class="td1 jz h20 w87">操作ＩＰ</div>
<div class="td1 jz h20 w50">操作</div>
<div class="td1 jz h20 w100">操作页面</div>
<div class="td1 jz h20 w87">操作时间</div>
<div class="td1 jz h20 w50">提交方式</div>
<div class="td1 jz h20 w50">提交参数</div>
<div class="td1 jz h20 w231">提交数据</div>

<%do while not rs.eof and i<listnum
n=n+1%>
<form action="?Action=delip" method=post name=check>
<div class="td1 h20 jz w50"><input name="id" type="checkbox" id="ID" value=<%=rs("id")%>><%=n%></div>
<div class="td1 jz h20 w87"><%=rs("IP")%></div>
<div class="td1 jz h20 w50">
 <%	if rs("Kill_ip")=true then 
			response.write "<a href=?action=unlock&id="&rs("id")&">解锁IP</a>"
		else
			response.write "<a href=?action=lock&id="&rs("id")&">锁定IP</a>"
		end if
	%>
</div>
<div class="td1 jz h20 w100"><%=rs("WEB")%></div>
<div class="td1 jz h20 w87"><%=rs("TIME")%></div>
<div class="td1 jz h20 w50"><%=rs("FS")%></div>
<div class="td1 jz h20 w50"><%=rs("CS")%></div>
<div class="td1 jz h20 w231"><%=N_Replace(rs("SJ"))%></div>
<%rs.movenext 
i=i+1 
j=j-1
loop%>
<div class="tf h20" align="right"><%=Rs.recordcount%> 条记录&nbsp;&nbsp;<%=listnum%> 条记录/页&nbsp;&nbsp;共 <%=rs.pagecount%> 页 
      <% if page=1 then %>
      <%else%>
      <a href=?action=n_sql><strong>|<<</strong></a>
      <a href=?action=n_sql&page=<%=page-1%>><strong><<</strong></a>
      <a href=?action=n_sql&page=<%=page-1%>><b>[<%=page-1%>]</b></a>
      <%end if%><% if rs.pagecount=1 then%><%else%><b>[<%=page%>]</b><%end if%>
	  <% if rs.pagecount-page <> 0 then %>
      <a href=?action=n_sql&page=<%=page+1%>><b>[<%=page+1%>]</b></a>
      <a href=?action=n_sql&page=<%=page+1%>><strong>>></strong></a>
      <a href=?action=n_sql&page=<%=rs.pagecount%>><strong>>>|</strong></a>
	  <%end if%>
      <input type=checkbox value="on" name="chkall" onclick="checkall(this.form)">全选
	  <input type=submit name=action value="删除" style="font-size: 9pt;  color: #000000; background-color: #EAEAF4; solid #EAEAF4" >&nbsp;&nbsp;<input type=button   value="清空所有记录" style="font-size: 9pt;  color: #000000; background-color: #EAEAF4; solid #EAEAF4"  onclick="document.location.href='?action=DelAllip';">   
  </div><div style=""clear: both;""></div></div>
<%end if%>
</form>






<%end sub

Sub Delip()
dim id 
id = request.form("id")
conn.execute("delete from Yx_Sql where id in ( " & id & ")")
Response.Redirect "?action=n_sql"
End sub

Sub DelAllip()
dim id 
id = request.form("id")
conn.execute("delete from Yx_Sql")
Response.Redirect "?action=n_sql"
End sub

Sub Lockip()
id = clng(request("id"))
conn.execute("update Yx_Sql set Kill_ip=true where id="&id)
Response.Redirect "?action=n_sql"
End sub

Sub UnLockip()
id = clng(request("id"))
conn.execute("update Yx_Sql set Kill_ip=False where id="&id)
Response.Redirect "?action=n_sql"
End sub

Function N_Replace(N_urlString)
	N_urlString = Replace(N_urlString,"'","''")
    N_urlString = Replace(N_urlString, ">", "&gt;")
    N_urlString = Replace(N_urlString, "<", "&lt;")
    N_Replace = N_urlString
End Function

%>
<script language="javascript">
<!--
function checkall(form) {
 for (var i=0;i<form.elements.length;i++)	{
	var e = form.elements[i];
	if (e.name != 'chkall')
		e.checked = form.chkall.checked; 
	}
 }
//-->
</script>