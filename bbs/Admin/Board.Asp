<!--#include file="check.asp"-->
<%
const maxdepth=3
server.scripttimeout =999999
response.write("<body>")
call showtable("论坛版面管理","<center><a href='?'>论坛管理</a> | <a href=""?action=addclass"">增加分类</a> | <a href=""?action=addboard"">增加论坛</a> | <a href=""?action=classorders"">分类排序</a> | <a href=""?action=boardunite"">论坛合并</a></center>")

response.flush
select case request("action")
case "addclass"
	addclass
case "saveclass"
	saveclass
case "editclass"
	editclass
case "saveeditclass"
	saveeditclass
case "delclass"
	delclass
case "addboard"
	addboard
case "saveboard"
	saveboard
case "editboard"
	editboard
case "saveeditboard"
	saveeditboard
case "delboard"
	delboard
case "classorders"
	classorders
case "saveclassorders"
	saveclassorders
case "boardunite"
	boardunite
case "saveboardunite"
	saveboardunite
case "passuser"
	passuser
case "savepassuser"
	savepassuser
case "ordersboard"
	ordersboard
case else
	boardinfo()
end select
adminfooter()

sub boardinfo
	dim rs,brs,i,install,temp,ii,po,boardtype
%>
<div class="ta">
<div class="th1 jz w390">论坛版面</div>
<div class="th1 jz w390">相应操作</div>

	<%
	set rs=yxbbs.execute("select boardid,boardname,parentid,depth,child,boardtype from [yx_board] order by rootid,orders")
	if rs.eof or rs.bof then
		call goback("","论坛没有分类！请先<a href=board.asp?action=addclass> 添加分类</a>")
		exit sub
	end if
	brs=rs.getrows(-1)
	rs.close
	for i=0 to ubound(brs,2)
	temp=""
	install="&nbsp;&nbsp;<a href='?action=addboard&boardid="&brs(0,i)&"'>添加论坛</a>"
	if brs(3,i)=0 then'分类
		temp="<div class=""td1 jz"" style=""text-align: left;"">"&temp
		if brs(4,i)>0 then'如果有子论坛
			temp=temp&brs(1,i)&" ("&brs(4,i)&")"
		else
			temp=temp&brs(1,i)
		end if
		install=install & "&nbsp;|&nbsp;<a href='?action=editclass&boardid="&brs(0,i)&"'>分类改名</a>"
		if brs(4,i)>0 then
			install=install & "&nbsp;|&nbsp;<a href=javascript:alert('不能删除！该分类含有论坛!\n\n要删除本类，必须先把属下的论坛删除或移走。')>删除分类</a>"
		else
			install=install & "&nbsp;|&nbsp;<a onclick=checkclick('删除后将不能恢复！您确定要删除吗？') href='?action=delclass&boardid="&brs(0,i)&"'>删除分类</a>"
		end if
	else'版面
		temp="<div class=""td1 jz"" style=""text-align: left;"">"&temp
		po=""
			for ii=1 to brs(3,i)
				po=po&" <font color=red>∣</font> "
			next
		if brs(4,i)>0 then'如果有子论坛
			temp=temp&po&brs(1,i)&" ("&brs(4,i)&")"
		else
			temp=temp&po&brs(1,i)
		end if
		install=install & " | <a href='?action=editboard&boardid="&brs(0,i)&"'>修改</a>"
		if brs(4,i)>0 then
			install=install & " | <a href='javascript:' onclick=alert('不能删除！该版面含有子论坛!\n\n要删除本版，必须先把属下的子论坛删除或移走。')>删除</a>"
		else
			install=install & " | <a onclick=checkclick('删除后将不能恢复！您确定要删除吗？') href='?action=delboard&boardid="&brs(0,i)&"'>删除</a>"
		end if
		install=install & " | <a href='?action=ordersboard&boardid="&brs(0,i)&"'>置前</a>"
		if brs(5,i) then
			install=install & " | <a href='?action=passuser&boardid="&brs(0,i)&"'>认证用户</a>"
		end if
	end if
	response.write(temp&"</div><div class=""td2 jz"" style=""text-align: left;"">"&install&"</div>")
next
%>

<div style='clear: both;'></div> 
</div>

<%
end sub

sub addclass
	dim newboardid
	set rs=yxbbs.execute("select max(boardid) from [yx_board]")
	if rs.eof or rs.bof then
		newboardid=1
	else
		newboardid=rs(0)+1
	end if
	if not isnumeric(newboardid) then newboardid=1
	rs.close
	%><form method=post style="margin:0" action="?action=saveclass">
        <div class="ta">
        <div class="th jz">添加分类</div>
        <div class="td1 h30"><b>分类名称：</b><br />论坛的分类名称</div>
        <div class="td2 h30" style="text-align: left;"><input name="newboardid" type="hidden" value="<%=newboardid%>"><input type=text name="boardname" size=30></div>
        <div style="clear: both;"></div><div class="tf jz"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div></form> </div>
	<%
end sub

sub saveclass
	dim boardname,newboardid,maxrootid
	boardname=yxbbs.fun.getstr("boardname")
	newboardid=yxbbs.fun.getstr("newboardid")
	if boardname="" or not isnumeric(newboardid) then
		call goback("",""):exit sub
	else
		set rs=yxbbs.execute("select boardid from [yx_board] where boardid="&newboardid)
		if not (rs.eof and rs.bof) then
			call goback("错误提示","不能指定和别的论坛一样的序号！")
			exit sub
		end if
		rs.close
		set rs=yxbbs.execute("select max(rootid) from yx_board")
		maxrootid=rs(0)+1
		if isnull(maxrootid) then maxrootid=1
		rs.close
		yxbbs.execute("insert into [yx_board](boardname,boardid,boardsetting,rootid,depth,parentid,orders,child,parentstr)values('"&boardname&"',"&newboardid&",'0,0,30,30720,10,0,0,0,0,0,0',"&maxrootid&",0,0,0,0,'0')")
		call suc("","成功的添加了论坛分类 <b>"&boardname&"</b> !","?")
	end if
end sub

sub editclass
	dim boardid
	set rs=yxbbs.execute("select boardname from[yx_board] where boardid="&yxbbs.boardid&"")
	if rs.eof then
		call goback("系统出错","论坛找不到这个分类，可能已经删除了。"):exit sub
	end if
	%><form method=post style="margin:0" action="?action=saveeditclass">
          <div class="ta">
        <div class="th jz">添加分类</div>
        <div class="td1 h30"><b>分类名称：</b><br />论坛的分类名称</div>
        <div class="td2 h30" style="text-align: left;"><input name="boardid" type="hidden" value="<%=yxbbs.boardid%>"><input type=text name="boardname" value="<%=rs(0)%>" size=30></div>
        <div style="clear: both;"></div><div class="tf"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div></form></div>
	<%rs.close
end sub

sub saveeditclass
	dim boardname,boardid
	boardname=yxbbs.fun.getstr("boardname")
	boardid=yxbbs.fun.getstr("boardid")
	if boardname="" or not isnumeric(boardid) then
		call goback("",""):exit sub
	else
		if yxbbs.execute("select boardid from [yx_board] where boardid="&boardid).eof then
			call goback("系统出错","论坛找不到这个分类，可能已经删除了。"):exit sub
		end if
		yxbbs.execute("update [yx_board] set boardname='"&boardname&"' where boardid="&boardid)
		call suc("","成功的把论坛分类名称改为 <b>"&boardname&"</b> !","?")
	end if
end sub

sub delclass
	if  yxbbs.execute("select count(boardid) from[yx_board] where parentid="&yxbbs.boardid)(0)=0 then
		yxbbs.execute("delete from[yx_board] where parentid=0 and boardid="&yxbbs.boardid)
		call suc("","成功的删除了分类!","?")
	end if
end sub

sub addboard
	if yxbbs.execute("select boardid from [yx_board] where depth=0").eof then
		call goback("","没有分类不能添加论坛！请先<a href=board.asp?action=addclass> ·添加分类</a>")
		exit sub
	end if%>
        <form method=post style="margin:0" action="?action=saveboard">
        <div class="ta">
        <div class="th jz">论坛添加</div>
        <div class="td1 h40">论坛名称：</div>
        <div class="td2 h40"><input type=text name="boardname" size=30></div>
        <div class="td1 h40">标志图片：<br />论坛版面logo地址，可以不填</div>
        <div class="td2 h40"><input type=text name="boardimg" size=30></div>
        <div class="td1 h40">论坛版主：<br />添加多版主请用@@分隔，如：name@@name</div>
        <div class="td2 h40"><input type=text name="boardadmin" size=30></div>
        <div class="td1 h70">论坛介绍：</div>
        <div class="td2 h70 w446"><textarea rows="3" name="introduce"></textarea></div>
	<div class="td1 h40">属于分类或论坛：</div>
        <div class="td2 h40"><select size="1" name="parentid"><%=yxbbs.boardidlist(yxbbs.boardid,20)%></select></div>
	<div class="td1 h40">限制用户等级：</div>
        <div class="td2 h40"><select size="1" name="boardgrade">
	<option value="0" selected>0级：游客</option>
	<%
	dim ug
	set ug=conn.execute("select gradenum,gradename from yx_usergrade order by gradenum asc")
	while not ug.eof
		response.write "<option value="&ug(0)&">"&ug(0)&"级："&ug(1)&"</option>"
	ug.movenext
	wend
	set ug=nothing
	%>
	</select></div>
        <div class="td1 h40">是否认证版面：<br />认证版只有版主和人证会员</div>
        <div class="td2 h40"><input type="radio" value="1" name="boardtype">是&nbsp; <input name="boardtype" type="radio" value="0" checked="true">否</div>
        <div class="td1 h40">锁定版面：<br /> 锁定之后不可以发布帖子</div>
        <div class="td2 h40"><input type="radio" value="1" name="boardlock">是&nbsp; <input name="boardlock" type="radio" value="0" checked="true">否</div>
<div style="clear: both;"></div><div class="tf jz"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div>
 </div></form>
	<%
end sub

sub saveboard
	dim boardname,introduce,boardadmin,boardimg,boardgrade,boardlock,boardtype,parentid,newboardid,rootid,depth,child,orders,parentstr,i
	boardname=yxbbs.fun.getstr("boardname")
	introduce=yxbbs.fun.getstr("introduce")
	boardadmin=yxbbs.fun.getstr("boardadmin")
	boardgrade=yxbbs.fun.getstr("boardgrade")
	boardlock=yxbbs.fun.getstr("boardlock")
	boardtype=yxbbs.fun.getstr("boardtype")
	boardimg=yxbbs.fun.getstr("boardimg")
	parentid=yxbbs.fun.getstr("parentid")
	if not isnumeric(parentid) or boardname="" or introduce="" then
		call goback("",""):exit sub
	end if
	set rs=yxbbs.execute("select max(boardid) from [yx_board]")
	if rs.eof or rs.bof then
		call goback("","没有分类不能添加论坛！请先<a href=board.asp?action=addclass> ·添加分类</a>")
		exit sub
	else
		newboardid=rs(0)+1
	end if
	rs.close
	set rs=yxbbs.execute("select rootid,depth,child,orders,parentstr,parentid from[yx_board] where boardid="&parentid&"")
	if rs.eof or rs.bof then
		call goback("系统程序出错！","没有指定父类或父论坛！")
		exit sub
	end if
	rootid=rs(0)
	depth=rs(1)
	child=rs(2)
	orders=rs(3)
	parentstr=rs(4)
	rs.close
	if depth+1>maxdepth then
		call goback("","考虑到论坛的实用易用，本论坛限制了最多只能有" & maxdepth & "级论坛!")
		exit sub
	end if
	if parentstr=0 then
		parentstr=parentid
	else
		parentstr=parentstr & "," & parentid
	end if
	yxbbs.execute("insert into [yx_board](boardid,boardname,introduce,boardadmin,boardimg,boardsetting,boardlock,boardtype,rootid,depth,parentid,parentstr,orders,child)values("&newboardid&",'"&boardname&"','"&introduce&"','"&boardadmin&"','"&boardimg&"','0,gif|jpg|swf|zip|rar|bmp,30,30720,10,0,0,0,0,0,0,4',"&boardlock&","&boardtype&","&rootid&","&depth+1&","&parentid&",'"&parentstr&"',"&orders+1&",0)")
	if boardadmin <> "" then call addmaster(boardadmin,"none",0)
	if parentid<>0 then
		if depth>0 then
			'当上级分类深度大于0的时候要更新其父类（或父类的父类）的版面数和相关排序
			for i=1 to depth
				'更新其父类版面数
				yxbbs.execute("update [yx_board] set child=child+1 where boardid="&parentid)
				'得到其父类的父类的版面id
				set rs=yxbbs.execute("select parentid from [yx_board] where boardid="&parentid)
				if not (rs.eof and rs.bof) then
					parentid=rs(0)
				end if
				rs.close
				'当循环次数大于1并且运行到最后一次循环的时候直接进行更新
				if i=depth then
				yxbbs.execute("update [yx_board] set child=child+1 where boardid="&parentid)
				end if
			next
			'更新该版面排序以及大于本需要和同在本分类下的版面排序序号
			yxbbs.execute("update [yx_board] set orders=orders+1 where rootid="&rootid&" and orders>"&orders)
			yxbbs.execute("update [yx_board] set orders="&orders&"+1 where boardid="&newboardid&"")
		else
			'当上级分类深度为0的时候只要更新上级分类版面数
			yxbbs.execute("update [yx_board] set child=child+1 where boardid="&parentid)
			set rs=yxbbs.execute("select max(orders) from [yx_board]")
			yxbbs.execute("update [yx_board] set orders="&rs(0)&"+1 where boardid="&newboardid )
			rs.close
		end if
	end if
	call suc("","成功的添加了论坛 <b>"&boardname&"</b> !","board.asp")	
end sub

sub editboard
	dim boardname,boardlock,boardtype,introduce,boardimg,parentid,boardadmin,boardgrade
	set rs=yxbbs.execute("select parentid,boardname,boardadmin,boardgrade,boardlock,boardtype,introduce,boardimg from[yx_board] where boardid="&yxbbs.boardid&"")
	if rs.eof then
		call goback("","该版面不存在，可能已经删除了")
		exit sub
	else
		parentid=rs(0)
		boardname=rs(1)
		boardadmin=rs(2)
		boardgrade=rs(3)
		boardlock=rs(4)
		boardtype=rs(5)
		introduce=rs(6)
		boardimg=rs(7)
	end if
	rs.close%><form method=post style="margin:0" action="?action=saveeditboard">
         <div class="ta">
        <div class="th jz">论坛修改</div>
        <div class="td1 h40">论坛名称：</div>
        <div class="td2 h40"><input name="boardid" value="<%=yxbbs.boardid%>" type="hidden"><input name="boardname" type=text value="<%=boardname%>" size=30></div>
        <div class="td1 h40">标志图片：<br />论坛版面logo地址，可以不填</div>
        <div class="td2 h40"><input type=text name="boardimg" value="<%=boardimg%>" size=30></div>
        <div class="td1 h40">论坛版主：<br />添加多版主请用@@分隔，如：name@@name</div>
        <div class="td2 h40"><input type=text name="boardadmin" size=30 value="<%=boardadmin%>"><input type="hidden" name="oldboardadmin" size=30 value="<%=boardadmin%>"></div>
        <div class="td1 h70">论坛介绍：</div>
        <div class="td2 h70 w446"><textarea rows="3" name="introduce"><%=introduce%></textarea></div>
	<div class="td1 h40">属于分类或论坛：</div>
        <div class="td2 h40"><select size="1" name="parentid"><%=yxbbs.boardidlist(parentid,20)%></select></div>
	<div class="td1 h40">限制用户等级：</div>
        <div class="td2 h40"><select size="1" name="boardgrade">
	<option value="0" selected>0级：游客</option>
	<%
	dim ug
	set ug=conn.execute("select gradenum,gradename from yx_usergrade order by gradenum asc")
	while not ug.eof
		if ug(0)=boardgrade then
			response.write "<option value="&ug(0)&" selected>"&ug(0)&"级："&ug(1)&"</option>"
		else
			response.write "<option value="&ug(0)&">"&ug(0)&"级："&ug(1)&"</option>"
		end if
	ug.movenext
	wend
	set ug=nothing
	%></select></div>
        
        <div class="td1 h40">是否认证版面：<br />认证版只有版主和人证会员</div>
        <div class="td2 h40"><input type="radio" value="1" name="boardtype" <%if boardtype=1 then response.write "checked=""true"""%>>是&nbsp; <input type="radio" value="0" name="boardtype" <%if boardtype=0 then response.write "checked=""true"""%>>否</div>

<div class="td1 h40">锁定版面：<br /> 锁定之后不可以发布帖子</div>
        <div class="td2 h40"><input type="radio" value="1" name="boardlock" <%if boardlock=1 then response.write "checked=""true""" %>>是&nbsp; <input type="radio" value="0" name="boardlock" <%if boardlock=0 then response.write "checked=""true"""%>>否</div>
<div style="clear: both;"></div><div class="tf jz"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div>
</div></form>
	<%
end sub

sub saveeditboard
	dim boardid,boardname,introduce,boardadmin,oldboardadmin,boardgrade,boardlock,boardtype,boardimg,parentid,rootid,depth,child,orders,parentstr,i
	dim newparentid,boardnum,p_rs
	boardid=yxbbs.fun.getstr("boardid")
	boardname=yxbbs.fun.getstr("boardname")
	introduce=yxbbs.fun.getstr("introduce")
	boardadmin=yxbbs.fun.getstr("boardadmin")
	boardgrade=yxbbs.fun.getstr("boardgrade")
	oldboardadmin=yxbbs.fun.getstr("oldboardadmin")
	boardlock=yxbbs.fun.getstr("boardlock")
	boardtype=yxbbs.fun.getstr("boardtype")
	boardimg=yxbbs.fun.getstr("boardimg")
	newparentid=yxbbs.fun.getstr("parentid")
	if not isnumeric(newparentid) or boardname="" or introduce="" then
		call goback("",""):exit sub
	elseif boardid=newparentid then
		call goback("","所属论坛不能指定自己！"):exit sub
	end if
	set rs=yxbbs.execute("select rootid,depth,child,orders,parentid,parentstr from[yx_board] where boardid="&boardid)
	if rs.eof or rs.bof then
		call goback("系统出错！","该版面不存在，可能已经删除了！")
		exit sub
	end if
	rootid=rs(0)
	depth=rs(1)
	child=rs(2)
	orders=rs(3)
	parentid=rs(4)
	parentstr=rs(5)
	rs.close
	if parentid=0 then
		call goback("系统出错！","分类不能设置"):exit sub
	elseif int(newparentid)<>int(parentid) then
		'判断所指定的论坛是否其下属论坛
		set rs=yxbbs.execute("select boardid from [yx_board] where parentstr like '%"&parentstr&","&boardid&"%' and boardid="&newparentid)
		if not (rs.eof and rs.bof) then
			call goback("","您不能指定该版面的下属子论坛作为所属论坛")
			exit sub
		end if
		rs.close
		'获得新选的父级
		set p_rs=yxbbs.execute("select * from [yx_board] where boardid="&newparentid)
			if p_rs("depth")+1> maxdepth or (child>0 and p_rs("depth")+2>maxdepth) then
			p_rs.close:set p_rs=nothing
			call goback("","本论坛限制了最多只能有" & maxdepth & "级论坛.")
			exit sub
		end if
	end if
	yxbbs.execute("update [yx_board] set boardname='"&boardname&"',introduce='"&introduce&"',boardadmin='"&boardadmin&"',boardgrade="&boardgrade&",boardlock="&boardlock&",boardtype="&boardtype&",boardimg='"&boardimg&"' where boardid="&boardid&"")
	if boardadmin <> oldboardadmin then call addmaster(boardadmin,oldboardadmin,1)
	if int(newparentid)<>int(parentid) then
	'将一个分论坛移动到其他分论坛下
	'获得所指定的论坛的相关信息
	'得到其下属版面数
	parentstr=parentstr & ","
	boardnum=yxbbs.execute("select count(*) from [yx_board] where parentstr like '%"&parentstr & boardid&"%'")(0)
	if isnull(boardnum) then boardnum=1
	'在获得移动过来的版面数后更新排序在指定论坛之后的论坛排序数据
	yxbbs.execute("update [yx_board] set orders=orders + "&boardnum&"+1  where rootid="&p_rs("rootid")&" and orders>"&p_rs("orders")&"")
	'更新当前版面数据
	if p_rs("parentstr")="0" then
		yxbbs.execute("update [yx_board] set depth="&p_rs("depth")&"+1,orders="&p_rs("orders")&"+1,rootid="&p_rs("rootid")&",parentid="&newparentid&",parentstr='" & p_rs("boardid") & "' where boardid="&boardid)
	else
		yxbbs.execute("update [yx_board] set depth="&p_rs("depth")&"+1,orders="&p_rs("orders")&"+1,rootid="&p_rs("rootid")&",parentid="&newparentid&",parentstr='" & p_rs("parentstr") & ","& p_rs("boardid") &"' where boardid="&boardid)
	end if
	dim tempparentstr
	i=1
	'更新下属，同时获得移动总数i
	'如果有则更新下属版面数据
	'深度为原有深度加上当前所属论坛的深度
	set rs=yxbbs.execute("select * from [yx_board] where parentstr like '%"&parentstr & boardid&"%' order by orders")
	do while not rs.eof
	i=i+1
	if p_rs("parentstr")="0" then'如果其父级为类，那么其下属的版面数据
		tempparentstr=p_rs("boardid") & "," & replace(rs("parentstr"),parentstr,"")
	else
		tempparentstr=p_rs("parentstr") & "," & p_rs("boardid") & "," & replace(rs("parentstr"),parentstr,"")
	end if
	yxbbs.execute("update [yx_board] set depth=depth+"&p_rs("depth")&"-"&depth&"+1,orders="&p_rs("orders")&"+"&i&",rootid="&p_rs("rootid")&",parentstr='"&tempparentstr&"' where boardid="&rs("boardid"))
	rs.movenext
	loop
	rs.close
	dim tempparentid,ii
	tempparentid=newparentid
	if rootid=p_rs("rootid") then'在同一分类下移动
		'更新所指向的上级论坛版面数，i为本次移动过来的版面数
		'更新其父类版面数
		yxbbs.execute("update [yx_board] set child=child+"&i&" where (not parentid=0) and boardid="&tempparentid)
		for ii=1 to p_rs("depth")
			'得到其父类的父类的版面id
			set rs=yxbbs.execute("select parentid from [yx_board] where (not parentid=0) and boardid="&tempparentid)
			if not (rs.eof and rs.bof) then
				tempparentid=rs(0)
				'更新其父类的父类版面数
			yxbbs.execute("update [yx_board] set child=child+"&i&" where (not parentid=0) and boardid="&tempparentid)
			''''yxbbs.execute("update [yx_board] set child=child+"&i&" where (not parentid=0) and boardid in　（）)
			end if
		next
		'更新其原父类版面数
		yxbbs.execute("update [yx_board] set child=child-"&i&" where (not parentid=0) and boardid="&parentid)
		'更新其原来所属论坛数据
		for ii=1 to depth
			'得到其原父类的父类的版面id
			set rs=yxbbs.execute("select parentid from [yx_board] where (not parentid=0) and boardid="&parentid)
			if not (rs.eof and rs.bof) then
				parentid=rs(0)
				'更新其原父类的父类版面数
				yxbbs.execute("update [yx_board] set child=child-"&i&" where (not parentid=0) and  boardid="&parentid)
			end if
		next
	else
	'更新所指向的上级论坛版面数，i为本次移动过来的版面数
	'更新其父类版面数
		yxbbs.execute("update [yx_board] set child=child+"&i&" where boardid="&tempparentid)
		for ii=1 to p_rs("depth")
			'得到其父类的父类的版面id
			set rs=yxbbs.execute("select parentid from [yx_board] where boardid="&tempparentid)
			if not (rs.eof and rs.bof) then
				tempparentid=rs(0)
				'更新其父类的父类版面数
			yxbbs.execute("update [yx_board] set child=child+"&i&" where  boardid="&tempparentid)
			end if
		next
	'更新其原父类版面数
	yxbbs.execute("update [yx_board] set child=child-"&i&" where boardid="&parentid)
	'更新其原父类的其它版面排序
	yxbbs.execute("update [yx_board] set orders=orders-"&i&" where rootid="&rootid&" and orders>"&orders)
	'更新其原来所属论坛数据
		for ii=1 to depth
			'得到其原父类的父类的版面id
			set rs=yxbbs.execute("select parentid from [yx_board] where boardid="&parentid)
			if not (rs.eof and rs.bof) then
				parentid=rs(0)
				'更新其原父类的父类版面数
				yxbbs.execute("update [yx_board] set child=child-"&i&" where boardid="&parentid)
			end if
		next
	end if
	p_rs.close:set p_rs=nothing
  end if
	call suc("","论坛修改成功 !","board.asp")	
end sub

sub delboard
	dim alltable,i,ii,depth,parentid,rootid,orders
	set rs=yxbbs.execute("select depth,parentid,rootid,orders,child from[yx_board] where boardid="&yxbbs.boardid)
	if rs.eof then 
		call goback("系统出错","不存在，论坛可能已经删除了 !")
		exit sub
	elseif rs(4)>0 then
		call goback("系统出错","该论坛含有属下论坛，不能删除 !")
		exit sub
	else
		depth=rs(0)
		parentid=rs(1)
		rootid=rs(2)
		orders=rs(3)
	end if
	rs.close
	alltable=split(yxbbs.bbstable(0),",")
	for i=0 to ubound(alltable)
		yxbbs.execute("delete from [yx_bbs"&alltable(i)&"] where boardid="&yxbbs.boardid&"")
	next

	set rs=yxbbs.execute("select topicid from[yx_topic] where boardid="&yxbbs.boardid&" and isvote ")
	do while not rs.eof
		yxbbs.execute("delete from [yx_topicvote] where topicid="&rs(0))
		yxbbs.execute("delete from [yx_topicvoteuser] where topicid="&rs(0))
	rs.movenext
	loop
	rs.close
	'删除主题记录
	yxbbs.execute("delete from[yx_topic] where boardid="&yxbbs.boardid)
	yxbbs.execute("delete from[yx_board] where boardid="&yxbbs.boardid)
	'更新其父类的版面数
	yxbbs.execute("update [yx_board] set child=child-1 where boardid="&parentid)
	'更新其父类的其它版面排序
	yxbbs.execute("update [yx_board] set orders=orders-1 where rootid="&rootid&" and orders>"&orders)
	'更新其所属论坛数据
		for ii=1 to depth
			'得到其父类的父类的版面id
			set rs=yxbbs.execute("select parentid from [yx_board] where boardid="&parentid)
			if not (rs.eof and rs.bof) then
				parentid=rs(0)
				'更新其父类的父类版面数
				yxbbs.execute("update [yx_board] set child=child-1 where boardid="&parentid)
			end if
			rs.close
		next
	call suc("","成功的删除论坛版面 (包括该论坛的所有帖子)!","board.asp")	
end sub

sub classorders
	dim boardid
	set rs=yxbbs.execute("select boardid,boardname,rootid from[yx_board] where depth=0 order by rootid")
	if rs.eof then
		call goback("","论坛没有分类！请先<a href=?action=addclass> 添加分类</a>")
		exit sub
	end if
	%><form method=post style="margin:0" action="?action=saveclassorders">
        <div class="ta">
	<div class="th jz">分类排序</div>
       
        <%
	do while not rs.eof
	response.write"<div class=""td1 h30"">&nbsp;"&rs(1)&"</div><div class=""td2 h30""><input name='boardid' type='hidden' value='"&rs(0)&"'><input name='rootid' type='hidden' value='"&rs(2)&"'><input type=text name='newrootid' value='"&rs(2)&"' size=4 ></div>"
	rs.movenext
	loop
	%><div style="clear: both;"></div><div class="tf jz"><input type="submit" value=" 修 改 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div>
        </div></form>
	
	<%rs.close
end sub

sub saveclassorders
	dim boardid,rootid,newrootid,temp,i
	temp=","
	for i=1 to request.form("boardid").count
		boardid = request.form("boardid")(i)
		rootid = request.form("rootid")(i)
		newrootid = request.form("newrootid")(i)
		if instr(temp,","&newrootid&",")>0 then 
			call goback("排序错误","各分类排序的数字不能一样!")
			exit sub
		end if
		temp=temp&newrootid&","
		if not isnumeric(boardid) or not isnumeric(newrootid) then
			call goback("排序错误","请用数字填写!")
			exit sub
		end if
	next
	for i=1 to request.form("boardid").count
		boardid = request.form("boardid")(i)
		rootid = request.form("rootid")(i)
		newrootid = request.form("newrootid")(i)
		if rootid<>newrootid then
			yxbbs.execute("update [yx_board]set rootid="&newrootid&" where boardid="&boardid)
			temp=boardid
			yxbbs.execute("update [yx_board] set rootid="&newrootid&" where parentstr like '%"&temp&"%' and rootid="&rootid&"")
		end if
	next
	call suc("","排序成功！","?")	
end sub
sub addmaster(s,o,n)
	dim arr,oarr,i,sql
	dim gradenum,gradename,gradepic
	set rs=conn.execute("select gradenum,gradename,gradepic from yx_usergrade where classid = 3 order by userminpostnum desc")
	if not (rs.eof and rs.bof) then
		gradenum = rs(0)
		gradename = rs(1)
		gradepic = rs(2)
	end if
	randomize
	arr = split(s,"@@")
	oarr = split(o,"@@")
	set rs = server.createobject("adodb.recordset")
	for i = 0 to ubound(arr)
		sql = "select * from [yx_user] where name = '" & arr(i) & "'"
		rs.open sql,conn,1,3
		if rs.eof and rs.bof then
			call goback("",arr(i) &"这个用户还没有注册!")
		else
			if rs("classid") = 5 then
				rs("gradenum") = gradenum
				rs("classid") = 3
				rs.update
			end if
		end if
		rs.close
	next
	'判断原版主在其他版面是否还担任版主，如没有担任则撤换该用户职位。
	if n = 1 then
		dim iboardmaster
		dim usergrade, article
		iboardmaster = false
		for i = 0 to ubound(oarr)
			set rs = yxbbs.execute("select boardadmin from yx_board")
			do while not rs.eof
				if instr("|" & trim(rs(0)) & "|","|" & trim(oarr(i)) & "|") > 0 then
					iboardmaster = true
					exit do
				end if
				rs.movenext
			loop
			if not iboardmaster then
				set rs = yxbbs.execute("select id,classid,essaynum from [yx_user] where name='" & trim(oarr(i)) & "' or classid=3")
				if not (rs.eof and rs.bof) then
					'if rs(1) > 2 then
						if not isnumeric(rs(2)) or rs(2) = "" then
							article = 0
						else
							article = cstr(rs(2))
						end if
						'取对应注册会员的等级
						set usergrade = yxbbs.execute("select top 1 gradenum,gradename,gradepic from yx_usergrade where userminpostnum <= " & article & " and not userminpostnum = -1 and classid = 5 order by userminpostnum desc")
						if not (usergrade.eof and usergrade.bof) then
							yxbbs.execute("update [yx_user] set gradenum="&usergrade(0)&",classid=5 where id="&rs(0))
						end if
						usergrade.close:set usergrade = nothing
					'end if
				end if
			end if
			iboardmaster = false
		next
	end if
	set rs = nothing
end sub

sub boardunite
	%><form method=post style="margin:0" action="?action=saveboardunite">
        <div class="ta">
        <div class="th jz">论坛合并</div>
        <div class="td w772">将论坛： 
	  <select size="1" name="boardid"><option value='0'>请选择原论坛</option><%=yxbbs.boardidlist(0,0)%></select> 合并到论坛： <select size="1" name="newboardid"><option value='0'>请选择目标论坛</option><%=yxbbs.boardidlist(0,0)%></select> 中 <input type="submit" onclick=checkclick('操作后将不能恢复！您确定要合并吗？') value=" 论坛合并 ">
	<br /><br /><b>注意事项：</b><font color=red>此操作不可恢复，请慎重操作！</font><br />
	分类不能操作，不能和其属下的论坛合并。<br />
	合并后原论坛(包括属下论坛)将被删除，所有帖子(包括属下论坛的帖子)将转移到指定的目标论坛中</div>
	<div style="clear: both;"></div></div></form>
	<%
end sub

sub saveboardunite
	dim boardid,newboardid,tempparentstr,tempparentid,rs1
	dim i,alltable
	dim parentstr,depth,parentid,child,rootid
	boardid=yxbbs.fun.getstr("boardid")
	newboardid=yxbbs.fun.getstr("newboardid")
	if boardid="" or newboardid="" then
		call goback("","请先指定论坛后再进行合并！")
		exit sub
	elseif boardid=newboardid then
		call goback("","同一个论坛不用合并了！")
		exit sub
	end if

	set rs=yxbbs.execute("select parentstr,boardid,depth,parentid,child,rootid from yx_board where boardid="&boardid)
	if rs(2)="0" then
		call goback("系统错误","分类不能做合并操作！")
		exit sub
	end if
	parentstr=rs(0) & "," & rs(1)
	parentid=rs(3)
	tempparentstr=rs(1)
	depth=rs(2)
	child=rs(4)+1
	rootid=rs(5)
	rs.close
	tempparentid=parentid
	'判断是否合并到下属论坛
	set rs=yxbbs.execute("select boardid from [yx_board] where boardid="&newboardid&" and parentstr like '%"&parentstr&"%'")
	if not (rs.eof and rs.bof) then
		call goback("","不能将论坛合并到其下属论坛中!")
		exit sub
	end if
	rs.close
	'得到全部下属论坛id
	i=0
	set rs=yxbbs.execute("select boardid from [yx_board] where rootid="&rootid&" and parentstr like '%"&parentstr&"%'")
	do while not rs.eof
		if i=0 then
			tempparentstr=rs(0)
		else
			tempparentstr=tempparentstr & "," & rs(0)
		end if
		i=i+1
		rs.movenext
	loop
	if i>0 then
		parentstr=tempparentstr & "," & boardid
	else
		parentstr=boardid
	end if
	'更新其原来所属论坛版面数
	yxbbs.execute("update [yx_board] set child=child-"&child&" where boardid="&tempparentid)
	'更新其原来所属论坛数据，排序相当于剪枝而不需考虑
	for i=1 to depth
		'得到其父类的父类的版面id
		set rs=yxbbs.execute("select parentid from [yx_board] where boardid="&tempparentid)
		if not (rs.eof and rs.bof) then
			tempparentid=rs(0)
			yxbbs.execute("update [yx_board] set child=child-"&child&" where boardid="&tempparentid)
		end if
	next
	'更新论坛帖子数据
	alltable=split(yxbbs.bbstable(0),",")
	for i=0 to ubound(alltable)
		yxbbs.execute("update [yx_bbs"&alltable(i)&"] set boardid="&newboardid&" where boardid in ("&parentstr&")")
	next
	yxbbs.execute("update [yx_topic] set boardid="&newboardid&" where boardid in ("&parentstr&")")
	'删除被合并论坛
	set rs=yxbbs.execute("select sum(essaynum),sum(topicnum),sum(todaynum) from [yx_board] where rootid="&rootid&" and boardid in ("&parentstr&")")
	yxbbs.execute("delete from [yx_board] where rootid="&rootid&" and boardid in ("&parentstr&")")
	'更新新论坛帖子计数
	yxbbs.execute("update [yx_board] set essaynum=essaynum+"&rs(0)&",topicnum=topicnum+"&rs(1)&",todaynum=todaynum+"&rs(2)&" where boardid ="&newboardid&"")
	'更新上级版块
	set rs1=yxbbs.execute("select depth,parentstr,boardid from [yx_board] where boardid="&newboardid)
	if rs1(0)>1 then
	parentstr=rs1(0)
	yxbbs.execute("update [yx_board] set essaynum=essaynum+"&rs(0)&",topicnum=topicnum+"&rs(1)&",todaynum=todaynum+"&rs(2)&" where boardid in ("&parentstr&")")
	end if
	rs1.close:set rs1=nothing
	rs.close
	call suc("","合并成功！已经将原论坛（包括属下）的所有帖子合并到目标论坛。","?")
end sub
sub ordersboard
	dim boardid,parentid,rootid,orders,parentstr,i,boardnum,p_rs,boardname
	boardid=yxbbs.boardid
	set rs=yxbbs.execute("select orders,parentid,parentstr,boardname from[yx_board] where boardid="&yxbbs.boardid)
	if rs.eof or rs.bof then
		call goback("系统出错！","该版面不存在，可能已经删除了！")
		exit sub
	end if
	orders=rs(0)
	parentid=rs(1)
	parentstr=rs(2)
        
	rs.close
	'当版面为类时
	if parentid=0 then call goback("系统出错！","版面id出错。"):exit sub
	'得到其下属版面数
	parentstr=parentstr & ","
	boardnum=yxbbs.execute("select count(*) from [yx_board] where parentstr like '%"&parentstr & boardid&"%'")(0)
	if isnull(boardnum) then boardnum=1
	'获得父级信息
	set p_rs=yxbbs.execute("select * from [yx_board] where boardid="&parentid)
	'在获得移动过来的版面数后更新排序在指定论坛之后的论坛排序数据
	yxbbs.execute("update [yx_board] set orders=orders + "&boardnum&"+1  where rootid="&p_rs("rootid")&" and orders>"&p_rs("orders")&"")
	'更新当前版面数据
	yxbbs.execute("update [yx_board] set orders="&p_rs("orders")&"+1 where boardid="&boardid)
	dim tempparentstr
	i=1
	'更新下属，同时获得移动总数i
	'如果有则更新下属版面数据
	set rs=yxbbs.execute("select * from [yx_board] where parentstr like '%"&parentstr & boardid&"%' order by orders")
	do while not rs.eof
	i=i+1
	if p_rs("parentstr")="0" then'如果其父级为类，那么其下属的版面数据
		tempparentstr=p_rs("boardid") & "," & replace(rs("parentstr"),parentstr,"")
	else
		tempparentstr=p_rs("parentstr") & "," & p_rs("boardid") & "," & replace(rs("parentstr"),parentstr,"")
	end if
	yxbbs.execute("update [yx_board] set orders="&p_rs("orders")&"+"&i&",parentstr='"&tempparentstr&"' where boardid="&rs("boardid"))
	rs.movenext
	loop
	rs.close
	p_rs.close
	set p_rs=nothing
	call suc("","成功的将该版面置前!","?")
	response.end
end sub

sub passuser
	set rs=yxbbs.execute("select passuser,boardname from [yx_board] where boardid="&yxbbs.boardid&" and parentid<>0")
	if rs.eof then
		call goback("","此论坛的类型不是认证论坛，不能设置认证用户。")
		exit sub
	end if%>
	<form method=post style='margin:0' action="?action=savepassuser">
	<div class="ta">
        <div class="th jz">修改论坛认证用户</div>
        <div class="td1">所在论坛：</div>
        <div class="td2"><input name="boardid" value="<%=yxbbs.boardid%>" type="hidden"><%=rs("boardname")%></div>
        <div class="td1 h50"><b>通过认证的用户：</b><br />各用户之间用“|”隔开<br />请不要使用回车键enter</div>
        <div class="td2 h50 w446"><textarea name="passuser" rows="2"><%=rs("passuser")%></textarea></div>
	<div style="clear: both;"></div><div class="tf"><input type="submit" value=" 提 交 "> &nbsp;&nbsp;<input type="reset" name="submit" value=" 重 置 "></div></div></form>
	<%rs.close
end sub

sub savepassuser
	dim passusers,boardid
	boardid=yxbbs.fun.getstr("boardid")
	passusers=trim(replace(request.form("passuser"),"'",""))
	passusers=replace(passusers,chr(10), "")
	passusers=replace(passusers,chr(13), "")
	yxbbs.execute("update [yx_board] set passuser='"&passusers&"' where boardid="&boardid&" and parentid<>0")
	cache.name="boardinfo"
	cache.clean()
	call suc("","成功的更新了该论坛的认证会员！","?")
end sub
%>