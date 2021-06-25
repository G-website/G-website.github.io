
<!--#include file="check.asp"-->
<%
dim action,id
id=request.querystring("id")
if id="" then id=0
response.write("<body>")
select case request("action")
case "config"
	config
case "configsave"
        configsave
case "link"
       link
case "edit"
       edit
case "updatelink"
       updatelink
case "saveadd"
       saveadd
case "saveedit"
       saveedit
case "dellink"
       dellink
case "lockip"
       lockip
case "editip"
       editip
case "delip"
       delip
case "saveaddip"
       saveaddip
case "saveeditip"
       saveeditip
case "setad"
       setad
case "savead"
       savead
case "updatebbs"
       updatebbs
case "execlean"
	execlean
case"updatebbsdate"
	updatebbsdate
case"updatetopic"
	updatetopic
case"updatealluser"
	updatealluser
case"delwuiong"
	delwuiong
case"boardupdate"
	boardupdate
case else
      main
end select
adminfooter()
sub main%>

<div class="ta"> 
<div class="th jz">论坛系统信息</div> 
<div class="td1" >总帖数：<span class="blue"><%=yxbbs.allessaynum%></span></div> 
<div class="td2" >主题数：<span class="blue"><%=yxbbs.topicnum%></span></div> 
<div class="td1" >注册人数：<span class="blue"><%=yxbbs.usernum%></span></div> 
<div class="td2" >最新加入：<span class="blue"><%=yxbbs.newuser%></span></div> 
<div class="td1" >创建时间：<span class="blue"><%=yxbbs.builddate%></span></div> 
<div class="td2" >今日新帖：<span class="blue"><%=yxbbs.todaynum%></span></div> 
<div class="td1" >目前在线人数：<span class="blue"><%=yxbbs.execute("select count(id) from[yx_online]")(0)%></span></div> 
<div class="td2" >最大在线人数：<span class="blue"><%=yxbbs.maxonlinenum%> (<%=yxbbs.maxonlinetime%>)</span></div>
<div style="clear: both;"></div>
</div>
<br />
<%if object_install("scripting.filesystemobject")=true then%>
<div class="ta"> 
<div class="th jz">论坛空间占用情况</div> 
<div class="td1" >数 据 库占用空间</div> 
<div class="td2" >&nbsp;<%=getsize(0,"../data")%></div> 
<div class="td1" >管理目录占用空间</div> 
<div class="td2" >&nbsp;<%=getsize(0,"../"&yxbbs.bbssetting(2)&"")%></div>
<div class="td1" >图片目录占用空间</div> 
<div class="td2" >&nbsp;<%=getsize(0,"../images")%></div>  
<div class="td1" >皮肤目录占用空间</div> 
<div class="td2" >&nbsp;<%=getsize(0,"../skins")%></div> 
<div class="td1" >上传文件占用空间</div> 
<div class="td2" >&nbsp;<%=getsize(0,"../uploadfile")%></div> 
<div class="td1" >函数目录占用空间</div> 
<div class="td2" >&nbsp;<%=getsize(0,"../inc")%></div>
<div class="td1" >论坛占用空间总计</div> 
<div class="td2" >&nbsp;<%=getsize(0,"../")%></div> 
<div style="clear: both;"></div> 
</div>  
<% end if %>
<br />
<div class="ta"> 
<div class="th jz">服务器的有关参数</div> 
<div class="td1" >服务器</div> 
<div class="td2 w449" >&nbsp;<%response.write request.servervariables("local_addr")%></div> 
<div class="td1" >服务器时间：</div> 
<div class="td2 w449" >&nbsp;<%response.write now%></div>
<div class="td1" >服务器版本：</div> 
<div class="td2 w449" >&nbsp;<%response.write request.servervariables("server_software")%></div>  
<div class="td1" >服务器操作系统：</div> 
<div class="td2 w449" >&nbsp;<%if request.servervariables("os")="" then
	response.write "windows 2003"
	else
	response.write request.servervariables("os")
	end if%></div> 
<div class="td1" >脚本超时时间：</div> 
<div class="td2 w449" >&nbsp; <%response.write server.scripttimeout%></div> 
<div class="td1" >服务器解译引擎：</div> 
<div class="td2 w449" >&nbsp; <%response.write scriptengine & "/"& scriptenginemajorversion &"."&scriptengineminorversion&"."& scriptenginebuildversion %></div>
<div class="td1" >fso文本读写</div> 
<div class="td2 w449" >&nbsp;<%if object_install("scripting.filesystemobject")=false then
	session(yxbbs.cachename&"fso")="no"%>
        <span class="b1 red">×</span> （可能导致部分功能不能使用）
        <% else
	session(yxbbs.cachename&"fso")="" %>
        <span class="b1">√</span> （支持）
    <% end if %></div> 
<div class="td1" >stream文件流：</div> 
<div class="td2 w449" >&nbsp;<%if object_install("adodb.stream")=false then%>
        <span class="b1 red">×</span> （不支持）
        <% else %>
        <span class="b1">√</span> （支持）
    <% end if %></div> 
<div class="td1" >aspjpeg组件支持：</div> 
<div class="td2 w449" >&nbsp;<%if object_install("persits.jpeg")=false then%>
        <span class="b1 red">×</span> （可能导致不能使用上传水印的功能）
        <% else %>
       <span class="b1">√</span> （支持）
    <% end if %></div> 
<div class="td1" >JMail组件支持：</div> 
<div class="td2 w449" >&nbsp;<%if object_install("JMail.SMTPMail")=false then%>
        <span class="b1 red">×</span> （可能导致不能使用邮件发送的功能）
        <% else %>
       <span class="b1">√</span> （支持）
    <% end if %></div> 
<div style="clear: both;"></div> 
</div> 


<%
end sub
'空间占用
function getsize(f,drvpath)
	dim fso,d,size,showsize
	set fso=server.createobject("scripting.filesystemobject")
	drvpath=server.mappath(drvpath)
	if f=1 then
		set d=fso.getfile(drvpath)
	else
		set d=fso.getfolder(drvpath)
	end if
	size=d.size
	showsize=size & "&nbsp;byte"
	if size>1024 then
	   size=(size/1024)
	   showsize=formatnumber(size,2) & "&nbsp;KB"
	end if
	if size>1024 then
	   size=(size/1024)
	   showsize=formatnumber(size,2) & "&nbsp;MB"
	end if
	if size>1024 then
	   size=(size/1024)
	   showsize=formatnumber(size,2) & "&nbsp;GB"	   
	end if
	getsize=showsize
end function
'组件检测
function object_install(strclassstring)
  on error resume next
  object_install=false
  dim xtestobj
  err=0
  set xtestobj=server.createobject(strclassstring)
  if err=0 then object_install=true
  set xtestobj=nothing
  err=0
end function

'信息设置
sub config
dim info,rs
set rs=yxbbs.execute("select * from [yx_config]")
info=split(rs("info"),"|")
%>

<a name="inc"></a>
<%call showtable("论坛参数设置","<center><a href=""#inc1"">上传设置</a> | <a href=""#inc2"">金钱参数设置</a> | <a href=""#inc3"">论坛显示设置</a> | <a href=""#inc4"">论坛用户设置</a> | <a href=""#inc5"">论坛系统设置</a></center>")%>
<form method=post name=form style="margin:0" action="?action=configsave">
<br />
<div class="ta">
<div class="th jz">论坛基本设置</div>
<div class="td1 h22">论坛名称：</div>
<div class="td2 h22">
  <input type="text" name="bbsname"  value="<%=rs("bbsname")%>" />
</div>
<div class="td1 h22">BBs副标题：</div>
<div class="td2 h22"><input name="fname" type="text"  value="<%=rs("fname")%>" size="50">
</div>
<div class="td1 h22">论坛地址：</div>
<div class="td2 h22"><input type="text" name="bbsurl" size="50" value="<%=rs("bbsurl")%>"></div>
<div class="td1 h22">论坛管理目录：</div>
<div class="td2 h22"><input type="text" name="info2" size="10" value="<%=info(2)%>">  <span class="red">*此处填写管理目录名称.</span></div>
<div class="td1 h22">建站日期：</div>
<div class="td2 h22"><input type="text" name="builddate" size="10"  value="<%=rs("builddate")%>"> (格式：yyyy-m-d)</td></div>
<div class="td1 h22">关闭论坛：</div>
<div class="td2 h22"><input type="radio" name="bbsclose" value="0" <%if not rs("bbsclose") then%>checked="true"<%end if%>> 开启  <input type="radio" name="bbsclose" value="1" <%if rs("bbsclose") then%>checked="true"<%end if%>> 关闭</div>
<div class="td1 h22">论坛关键字(keywords)：</div>
<div class="td2 h22"><input type="text" size="70" name="info65" value="<%=info(65)%>"></div>
<div class="td1 h22">论坛内容描述(description)：</div>
<div class="td2 h22"><input type="text" size="70" name="info66" value="<%=info(66)%>"></div>



<div class="td1 h65">关闭论坛显示信息：<br />支持html <a href="http://Yimxu.com/Editor.Htm" target="_blank">进入编辑器</a></div>
<div class="td2 h65 w446"><textarea rows="3" name="closeinfo"><%=rs("closeinfo")%></textarea></div>
<div class="td1 h65">论坛首页公告：<br />支持html <a href="http://Yimxu.com/Editor.Htm" target="_blank">进入编辑器</a></div>
<div class="td2 h65 w446"><textarea rows="3" name="srule"><%=rs("srule")%></textarea></div>
<div class="td1 h65">论坛版权信息：<br />支持html <a href="http://Yimxu.com/Editor.Htm" target="_blank">进入编辑器</a></div>
<div class="td2 h65 w446"><textarea rows="3" name="copyright" ><%=rs("copyright")%></textarea></div>
<div class="td1 h65">贴间广告信息：<br />支持html <a href="http://Yimxu.com/Editor.Htm" target="_blank">进入编辑器</a></div>
<div class="td2 h65 w446"><textarea rows="3" name="google" ><%=rs("google")%></textarea></div>
<div style="clear: both;"></div> 
</div>

<br />
<a name="inc1"></a>
<div class="ta">
<div class="th jz">上传设置 <a href="#inc">top</a></div>
<div class="td1 h22">是否允许上传头像：</div>
<div class="td2 h22"><input type="radio" name="info18" value="0" <%if info(18)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info18" value="1" <%if info(18)="1" then%>checked="true"<%end if%>> 否 </div>
<div class="td1 h22">上传头像类型(用@@分隔)：</div>
<div class="td2 h22"><input type="text" name="uploadtype" size="50" value="<%=rs("uploadtype")%>"></div>
<div class="td1 h22">头像上传大小限制：</div>
<div class="td2 h22"><input type="text" name="info19" size="5" value="<%=info(19)%>"> kb</div>
<div class="td1 h22">是否开启上传水印：</div>
<div class="td2 h22"><input type="radio" name="info56" value="0" <%if info(56)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info56" value="1" <%if info(56)="1" then%>checked="true"<%end if%>> 否 </div>
<div class="td1 h22">文字样式水印显示：</div>
<div class="td2 h22"><input type="text" name="info57" size="20" value="<%=info(57)%>"></div>
<div class="td1 h22">水印加盖模式：</div>
<div class="td2 h22"><input type="radio" name="info58" value="0" <%if info(58)="0" then%>checked="true"<%end if%>> 文字 <input type="radio" name="info58" value="1" <%if info(58)="1" then%>checked="true"<%end if%>> 图片   *如选图片，请在images下放名为logobox.gif标志.</div>
<div style="clear: both;"></div> 
</div>

<br />
<a name="inc2"></a>
<div class="ta">
<div class="th jz">金钱参数设置 <a href="#inc">top</a></div>
<div class="td1 h22">y币在您论坛的名称：</div>
<div class="td2 h22"><input type="text" name="info23" size="4" value="<%=info(23)%>"></div>
<div class="td1 h22">醒目标题需要金钱：</div>
<div class="td2 h22 blue">加 <input type="text" name="info13" size="2" value="<%=info(13)%>"> 元</div>
<div class="td1 h22">发送短信息需要金钱：</div>
<div class="td2 h22 blue">加 <input type="text" name="info3" size="2" value="<%=info(3)%>"> 元</div>
<div class="td1 h22">论坛发贴：</div>
<div class="td2 h22 blue">加 <input type="text" name="info37" size="2" value="<%=info(37)%>"> 元</div>
<div class="td1 h22">论坛回帖：</div>
<div class="td2 h22 blue">加 <input type="text" name="info38" size="2" value="<%=info(38)%>"> 元</div>
<div class="td1 h22">删除帖子：</div>
<div class="td2 h22 red">减 <input type="text" name="info59" size="2" value="<%=info(59)%>"> 元  减 <input type="text" name="info60" size="2" value="<%=info(60)%>"> YB</div>
<div class="td1 h22">论坛精华：</div>
<div class="td2 h22 blue">加 <input type="text" name="info39" size="2" value="<%=info(39)%>"> 元&nbsp;&nbsp; 加 <input type="text" name="info40" size="2" value="<%=info(40)%>"> YB &nbsp;&nbsp;<span class="red">减 <input type="text" name="info41" size="2" value="<%=info(41)%>"> 元&nbsp;&nbsp;减 <input type="text" name="info42" size="2" value="<%=info(42)%>"> YB</span></div>
<div class="td1 h22">论坛置顶：</div>
<div class="td2 h22 blue">加 <input type="text" name="info43" size="2" value="<%=info(43)%>"> 元&nbsp;&nbsp; 加 <input type="text" name="info44" size="2" value="<%=info(44)%>"> YB &nbsp;&nbsp;<span class="red">减 <input type="text" name="info45" size="2" value="<%=info(45)%>"> 元&nbsp;&nbsp;减 <input type="text" name="info46" size="2" value="<%=info(46)%>"> YB</span></div>
<div class="td1 h22">论坛区置顶：</div>
<div class="td2 h22 blue">加 <input type="text" name="info47" size="2" value="<%=info(47)%>"> 元&nbsp;&nbsp; 加 <input type="text" name="info48" size="2" value="<%=info(48)%>"> YB &nbsp;&nbsp;<span class="red">减 <input type="text" name="info49" size="2" value="<%=info(49)%>"> 元&nbsp;&nbsp;减 <input type="text" name="info50" size="2" value="<%=info(50)%>"> YB</span></div>
<div class="td1 h22">论坛总置顶：</div>
<div class="td2 h22 blue">加 <input type="text" name="info51" size="2" value="<%=info(51)%>"> 元&nbsp;&nbsp; 加 <input type="text" name="info52" size="2" value="<%=info(52)%>"> YB &nbsp;&nbsp;<span class="red">减 <input type="text" name="info53" size="2" value="<%=info(53)%>"> 元&nbsp;&nbsp;减 <input type="text" name="info54" size="2" value="<%=info(54)%>"> YB</span></div>
<div style="clear: both;"></div> 
</div>

<br />
<a name="inc3"></a>
<div class="ta">
<div class="th jz">论坛显示设置 <a href="#inc">top</a></div>
<div class="td1 h22">显示系统信息：</div>
<div class="td2 h22"><input type="radio" name="info7" value="0" <%if info(7)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info7" value="1" <%if info(7)="1" then%>checked="true"<%end if%>> 否 *包括首页公告、快速登陆</div>
<div class="td1 h22">显示在线信息：</div>
<div class="td2 h22"><input type="radio" name="info10" value="0" <%if info(10)="0" then%>checked="true"<%end if%>> 是  <input type="radio" name="info10" value="1" <%if info(10)="1" then%>checked="true"<%end if%>> 否 </div>
<div class="td1 h22">显示会员生日：</div>
<div class="td2 h22"><input type="radio" name="info32" value="0" <%if info(32)="0" then%>checked="true"<%end if%>> 是  <input type="radio" name="info32" value="1" <%if info(32)="1" then%>checked="true"<%end if%>> 否 </div>
<div class="td1 h22">显示论坛联盟：</div>
<div class="td2 h22"><input type="radio" name="info8" value="0" <%if info(8)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info8" value="1" <%if info(8)="1" then%>checked="true"<%end if%>> 否 </div>
<div class="td1 h22">显示执行时间：</div>
<div class="td2 h22"><input type="radio" name="info33" value="1" <%if info(33)="1" then%>checked="true"<%end if%>> 以毫秒显示 <input type="radio" name="info33" value="2" <%if info(33)="2" then%>checked="true"<%end if%>> 以秒显示 <input type="radio" name="info33" value="0" <%if info(33)="0" then%>checked="true"<%end if%>> 不显示</div>
<div style="clear: both;"></div> 
</div>

<br />
  <a name="inc4"></a>
<div class="ta">
<div class="th jz">用户信息设置 <a href="#inc">top</a></div>
<div class="td1 h22">是否审核注册用户：</div>
<div class="td2 h22"><input type="radio" name="info34" value="0" <%if info(34)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info34" value="1" <%if info(34)="1" then%>checked="true"<%end if%>> 否 </div>
<div class="td1 h22">自定义头衔级别 ：</div>
<div class="td2 h22"><input type="text" name="info25" size="4" value="<%=info(25)%>"> 级</div>
<div class="td1 h22">头像上传等级限制：</div>
<div class="td2 h22"><input type="text" name="info35" size="4" value="<%=info(35)%>"> 级</div>
<div class="td1 h22">文件上传等级限制：</div>
<div class="td2 h22"><input type="text" name="info36" size="4" value="<%=info(36)%>"> 级 *如果想禁止上传，就设置21级</div>
<div class="td1 h22">允许个人签名：</div>
<div class="td2 h22"><input type="radio" name="info12" value="0" <%if info(12)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info12" value="1" <%if info(12)="1" then%>checked="true"<%end if%>> 否</div>
<div class="td1 h22">游客查看上传资源 ：</div>
<div class="td2 h22"><input type="radio" name="info55" value="1" <%if info(55)="1" then%>checked="true"<%end if%>> 是 <input type="radio" name="info55" value="0" <%if info(55)="0" then%>checked="true"<%end if%>> 否</div>
<div class="td1 h22">允许新用户注册：</div>
<div class="td2 h22"><input type="radio" name="info0" value="0" <%if info(0)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info0" value="1" <%if info(0)="1" then%>checked="true"<%end if%>> 否</div>
<div class="td1 h22">注册发送留言：</div>
<div class="td2 h22"><input type="radio" name="info5" value="0" <%if info(5)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info5" value="1" <%if info(5)="1" then%>checked="true"<%end if%>> 否</div>
<div class="td1 h65">注册发送留言内容</div>
<div class="td2 h65 w446"><textarea rows="3" name="regautosms"><%=rs("regautosms")%></textarea> </div>
<div class="td1 h22">同一来源2次注册间隔：</div>
<div class="td2 h22"><input type="text" name="info28" size="4" value="<%=info(28)%>" onkeypress='event.returnvalue=(event.keycode >= 48) && (event.keycode <= 57);'> 分钟 <span class="red">*如果不想使用这项功能, 请设置为0</span></div>
<div class="td1 h22">同一来源2次登陆间隔：</div>
<div class="td2 h22"><input type="text" name="info29" size="4" value="<%=info(29)%>"> 分钟 <span class="red">*同上</span></div>
<div class="td1 h22">发贴时限：</div>
<div class="td2 h22"><input type="text" name="info30" size="4" value="<%=info(30)%>"> 秒&nbsp;&nbsp; <span class="red">&nbsp;*同上</span></div>
<div class="td1 h22">用户编辑帖子时间：</div>
<div class="td2 h22"><input type="text" name="info31" size="4" value="<%=info(31)%>"> 分钟  <span class="red">*同上</span></div>
<div class="td1 h22">2次举报间隔：</div>
<div class="td2 h22"><input type="text" name="info63" size="4" value="<%=info(63)%>"> 秒&nbsp;&nbsp; <span class="red">&nbsp;*同上</span></div>
<div class="td1 h22">接收举报ID：</div>
<div class="td2 h22"><input type="text" name="info64" size="6" value="<%=info(64)%>"> </div>
<div style="clear: both;"></div> 
</div>

<br />
<a name="inc5"></a>
<div class="ta">
<div class="th jz">论坛系统设置 <a href="#inc">top</a></div>
<div class="td1 h22">Smtp服务器：</div>
<div class="td2 h22"><input type="text" name="info9"  value="<%=info(9)%>"></div>
<div class="td1 h22">Smtp用户名：</div>
<div class="td2 h22"><input type="text" name="info20"  value="<%=info(20)%>"></div>
<div class="td1 h22">Smtp密码：</div>
<div class="td2 h22"><input type="text" name="info21"  value="<%=info(21)%>"></div>
<div class="td1 h22">是否开启防盗链 ：</div>
<div class="td2 h22"><input type="radio" name="info61" value="0" <%if info(61)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info61" value="1" <%if info(61)="1" then%>checked="true"<%end if%>> 否</div>
<div class="td1 h22">是否开启附件显示 ：</div>
<div class="td2 h22"><input type="radio" name="info22" value="0" <%if info(22)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info22" value="1" <%if info(22)="1" then%>checked="true"<%end if%>> 否</div>
<div class="td1 h22">版主继承：</div>
<div class="td2 h22"><input type="radio" name="info1" value="0" <%if info(1)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info1" value="1" <%if info(1)="1" then%>checked="true"<%end if%>> 否</div>
<div class="td1 h22">登录验证码：</div>
<div class="td2 h22"><input type="radio" name="info6" value="0" <%if info(6)="0" then%>checked="true"<%end if%>> 是 <input type="radio" name="info6" value="1" <%if info(6)="1" then%>checked="true"<%end if%>> 否</div>
<div class="td1 h22">论坛在线人数统计超时：</div>
<div class="td2 h22"><input type="text" name="info27" size="5" value="<%=info(27)%>"> 分钟 </div>
<div class="td1 h22">帖子列表最多显示字符：</div>
<div class="td2 h22"><input type="text" name="info62" size="5" value="<%=info(62)%>"> 字</div>
<div class="td1 h22">帖子列表显New标志取消：</div>
<div class="td2 h22"><input type="text" name="info4" size="5" value="<%=info(4)%>"> 分钟</div>
<div class="td1 h22">论坛分页显示条数：</div>
<div class="td2 h22"><input type="text" name="info26" size="5" value="<%=info(26)%>"> 条</div>
<div class="td1 h22">成为热帖的最低人气值：</div>
<div class="td2 h22"><input type="text" name="info24" size="5" value="<%=info(24)%>"> 条</div>
<div class="td1 h22">论坛头像个数：</div>
<div class="td2 h22"><input type="text" name="info14" size="5" value="<%=info(14)%>"> 个</div>
<div class="td1 h22">头像最大寸尺：</div>
<div class="td2 h22"><input type="text" name="info15" size="5" value="<%=info(15)%>"> 像素</div>
<div class="td1 h22">头像默认寸尺：</div>
<div class="td2 h22"><input type="text" name="info17" size="5" value="<%=info(17)%>">×<input type="text" name="info16" size="5" value="<%=info(16)%>"> 高×宽(像素)</div>
<div class="td1 h22">发现SQL注入者：</div>
<div class="td2 h22"><input type="radio" name="info67" value="0" <%if info(67)="0" then%>checked="true"<%end if%>> 锁定IP <input type="radio" name="info67" value="1" <%if info(67)="1" then%>checked="true"<%end if%>> 不锁定IP</div>
<div class="td1 h22">防SQL注入关键字：</div>
<div class="td2 h22"><input type="text" size="70" name="N_in" value="<%=rs("N_in")%>"></div>
<div class="td1 h22">安全文件（不进行SQL注入过滤）：</div>
<div class="td2 h22"><input type="text" size="70" name="Safe_in" value="<%=rs("Safe_in")%>"></div>
<div class="td1 h22">禁止注册的用户名(用@@分隔)：</div>
<div class="td2 h22"><input type="text" size="70" name="badname" value="<%=rs("badname")%>"></div>
<div class="td1 h22">帖子过滤脏字(用@@分隔)：</div>
<div class="td2 h22"><input type="text" size="70" name="badessay" value="<%=rs("badessay")%>"></div>
<div style="clear: both;"></div> 
<div class="tf jz w770"><input type="submit" value="确定修改"></div>
</div>
</form>
<%
rs.close 
end sub

sub configsave
	dim bbsname,fname,bbsurl,bbsclose,closeinfo,srule,copyright,i,temp,uploadtype,builddate,badname,badessay,regautosms,google,N_in,Safe_in
	temp=""
	for i=0 to 67
		if i=0 or i=1 then
			if yxbbs.fun.getstr("info"&i)="" then
				call goback("","")
				exit sub
			end if
			if not yxbbs.fun.isinteger(yxbbs.fun.getstr("info"&i)) then
				call goback("","一些参数必须填为正整数，否则论坛不能正常运行。")
				exit sub
			end if
		end if
		temp=temp&yxbbs.fun.getstr("info"&i)&"|"
	next
	bbsname=yxbbs.fun.getstr("bbsname")
	fname=yxbbs.fun.getstr("fname")
	bbsurl=yxbbs.fun.getstr("bbsurl")
	bbsclose=yxbbs.fun.getstr("bbsclose")
	closeinfo=yxbbs.fun.getstr("closeinfo")
	copyright=yxbbs.fun.getstr("copyright")
	builddate=yxbbs.fun.getstr("builddate")
	uploadtype=yxbbs.fun.getstr("uploadtype")
	badname=yxbbs.fun.getstr("badname")
	badessay=yxbbs.fun.getstr("badessay")
	regautosms=yxbbs.fun.getstr("regautosms")
	N_In=replace(request.form("N_In"),"'","''")
	Safe_in=replace(request.form("Safe_in"),"'","''")
        srule=yxbbs.fun.getstr("srule")
	google=yxbbs.fun.getstr("google")
    yxbbs.execute("update [yx_config] set bbsname='"&bbsname&"',fname='"&fname&"',bbsurl='"&bbsurl&"',bbsclose="&bbsclose&",closeinfo='"&closeinfo&"',copyright='"&copyright&"',info='"&temp&"',uploadtype='"&uploadtype&"',builddate='"&builddate&"',badname='"&badname&"',badessay='"&badessay&"',regautosms='"&regautosms&"',srule='"&srule&"',google='"&google&"',N_in='"&N_in&"',Safe_in='"&Safe_in&"'")
	call suc("修改成功","论坛名称以及其他参数修改成功","basic.asp?action=config")
	cache.name="config"
	cache.clean()
end sub

'联盟
sub link
dim rs,i%>
<form method=post name=form style='margin:0' action=?action=saveadd>
<div class="ta">
<div class="th jz">添加论坛联盟</div>
<div class="td1 h22">论坛名称：</div>
<div class="td2 h22"><input type="text" name="bbsname" size="20"></div>
<div class="td1 h22">论坛地址：</div>
<div class="td2 h22"><input type="text" name="url" size="38"></div>
<div class="td1 h22">论坛图片：</div>
<div class="td2 h22"><input type="text" name="pic" size="38">(可留空)</div>
<div class="td1 h22">论坛说明：</div>
<div class="td2 h22"><input type="text" name="readme" size="38">(可留空)</div>
<div class="td1 h22">图片显示：</div>
<div class="td2 h22"><input type="radio" name="ispic" value="yes"  checked="true">  是 <input type="radio" name="ispic" value="no" > 否</div>
<div style="clear: both;"></div><div class="tf jz w770"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div>
</div></form>

<br />
<form method=post name=form  action=?action=updatelink>
<div class="ta">
<div class="th1 jz w231">论坛联盟信息</div>
<div class="th1 jz w87">排序</div>
<div class="th1 jz w231">显示图片</div>
<div class="th1 jz w231">操作</div>
	<%
	i=0
	set rs=yxbbs.execute("select id,ispic,orders,bbsname,url,readme from[yx_link] order by orders")
	do while not rs.eof
		i=i+1
	%>
	<div class="td3 w219 jz"><a href="<%=rs("url")%>" target="_blank" title="<%=rs("readme")%>"><%=rs("bbsname")%></a></div>
        <div class="td3 w87  jz"><input name="id" value="<%=rs("id")%>" type="hidden"><input type="text" name="orders" value="<%=rs("orders")%>" size="2"></div>
        <div class="td3 w219 jz"><input type="radio" name="ispic<%=i%>" value="yes" <%if rs("ispic") then%> checked="true" <%end if%>> 是 <input type="radio" name="ispic<%=i%>" value="no" <%if not rs("ispic") then%> checked="true" <%end if%>> 否</div>
	<div class="td3 w219 jz"><a href="?action=edit&id=<%=rs("id")%>"><img src="../images/edit.gif" border="0" align="absmiddle" /> 编辑</a> <a onclick=checkclick('删除后将不能恢复！您确定要删除吗？') href="?action=dellink&id=<%=rs("id")%>"><img src="../images/del.gif" width="18" height="18" border="0" align="absmiddle"  /> 删除</a></div>
	<%rs.movenext
	loop
	rs.close
	%>
<div style="clear: both;"></div><div class="tf w770 jz" ><input type="submit" value=" 更 新 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div></div></form>
<%
end sub

sub edit
	set rs=yxbbs.execute("select id,orders,ispic,pic,bbsname,url,readme from[yx_link]where id="&id&"")
	if rs.eof then
		call goback("这条论坛联盟不存在！")
		exit sub
	end if
	%>
<form method=post name=form style='margin:0' action=?action=saveedit>
<div class="ta">
<div class="th jz">修改论坛联盟</div>
<div class="td1 h22">论坛名称：</div>
<div class="td2 h22"><input name="id" value="<%=rs("id")%>" type="hidden"><input type="text" name="bbsname" size="20" value="<%=rs("bbsname")%>"></div>
<div class="td1 h22">论坛地址：</div>
<div class="td2 h22"><input type="text" name="url" size="38" value="<%=rs("url")%>"></div>
<div class="td1 h22">论坛图片：</div>
<div class="td2 h22"><input type="text" name="pic" size="38" value="<%=rs("pic")%>"></div>
<div class="td1 h22">论坛说明：</div>
<div class="td2 h22"><input type="text" name="readme" size="38" value="<%=rs("readme")%>"></div>
<div class="td1 h22">图片显示：</div>
<div class="td2 h22"><input type="radio" name="ispic" value="yes" <%if rs("ispic") then%> checked="true" <%end if%>>  是 <input type="radio" name="ispic" value="no" <%if not rs("ispic") then%> checked="true" <%end if%>> 否</div>
<div style="clear: both;"></div><div class="tf jz w770"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div>
</div> </form>
<%rs.close
end sub

sub updatelink
	dim id,i,orders,ispic
	for i=1 to request.form("id").count
	id = replace(request.form("id")(i),"'","")
	orders = replace(request.form("orders")(i),"'","")
	ispic= replace(request.form("ispic"&i&""),"'","")
	if not isnumeric(id) or not isnumeric(orders) then
		call goback("","请用数字填写!")
		exit sub
	end if
	yxbbs.execute("update [yx_link]set orders="&orders&",ispic="&ispic&" where id="&id&"")
	next
	cache.name="link_list":cache.clean()
	call suc("","更新联盟信息成功！","basic.asp?action=link")
end sub

sub saveadd
	dim bbsname,url,pic,readme,orders,ispic
	bbsname=yxbbs.fun.getstr("bbsname")
	url=yxbbs.fun.ubbg(yxbbs.fun.getstr("url"))
	pic=yxbbs.fun.getstr("pic")
	readme=yxbbs.fun.getstr("readme")
	ispic=yxbbs.fun.getstr("ispic")
	if bbsname=""  or url=""  then
		call goback("","")
		exit sub
	elseif not yxbbs.fun.checkname(bbsname) then
		call goback("","请不要使用了非法字符")
		exit sub
	end if
	orders=yxbbs.execute("select count(id) from[yx_link]")(0)
	orders=int(orders+1)
	yxbbs.execute("insert into[yx_link](bbsname,url,pic,readme,orders,ispic)values('"&bbsname&"','"&url&"','"&pic&"','"&readme&"',"&orders&","&ispic&")")
	cache.name="link_list":cache.clean()
	call suc("","添加论坛联盟成功！","basic.asp?action=link")
end sub

sub saveedit
	dim bbsname,url,pic,readme,id,ispic
	id=yxbbs.fun.getstr("id")
	bbsname=yxbbs.fun.getstr("bbsname")
	url=yxbbs.fun.ubbg(yxbbs.fun.getstr("url"))
	pic=yxbbs.fun.getstr("pic")
	readme=yxbbs.fun.getstr("readme")
	ispic=yxbbs.fun.getstr("ispic")	
	if bbsname=""  or url=""  then
		call goback("","")
		exit sub
	elseif not yxbbs.fun.checkname(bbsname) then
		call goback("","请不要使用了非法字符")
		exit sub
	end if
	yxbbs.execute("update [yx_link]set url='"&url&"',pic='"&pic&"',bbsname='"&bbsname&"',readme='"&readme&"',ispic="&ispic&" where id="&id&"")
	cache.name="link_list":cache.clean()
	call suc("","修改论坛联盟成功！","basic.asp?action=link")
end sub

sub dellink
	dim id
	id=request.querystring("id")
	if  not isnumeric(id) then
		call goback("","提交的参数不正确！")
	else
		yxbbs.execute("delete from [yx_link] where id="&id&"")
		cache.name="link_list":cache.clean()
		call suc("","删除论坛联盟成功！","basic.asp?action=link")
	end if
end sub

sub lockip%>
<form method=post name=form style='margin:0' action=?action=saveaddip>
<div class="ta"> 
<div class="th jz">ip封锁</div> 
<div class="td1 h22">起始ip：</div> 
<div class="td2 h22">&nbsp;<input name='startip' type='text'></div> 
<div class="td1 h22">结束ip：</div> 
<div class="td2 h22">&nbsp;<input name='endip' type='text'> *封锁单个ip时不必填写</div> 
<div class="td1 h22">封禁说明：</div> 
<div class="td2 h22">&nbsp;<input name='readme' type='text' style="width:90%"></div> 
<div style="clear: both;"></div><div class="tf w770 jz"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div>
</div></form><br />


<div class="ta">
<div class="th jz">已经被封的ip记录</div>
<div class="td3 jz w231">网段</div><div class="td3 jz w231">说明</div><div class="td3 jz w291">操作</div>
<% 
	set rs=yxbbs.execute("select startip,endip,readme,id from [yx_lockip]")
	if rs.eof then
	response.write"<div style=""clear: both;""></div><div class=""tf jz w770"" >没有记录</div>"
	else
	do while not rs.eof
               response.write"<div class=""td3 jz w231"">"&yxbbs.fun.ipdecode(rs("startip"))&" - "&yxbbs.fun.ipdecode(rs("endip"))&"</div><div class=""td3 jz w231"">&nbsp;"&rs("readme")&"</div><div class=""td3 jz w291""><a href=?action=editip&id="&rs("id")&"><img src=../images/edit.gif border=0 align='absmiddle'  /> 修改</a> <a href=?action=delip&id="&rs("id")&"><img src=../images/del.gif border='0' align='absmiddle'  /> 删除</a></div><br />"	
	rs.movenext
	loop
	end if
	rs.close
%>
<div style="clear: both;"></div></div>
<%end sub

sub editip
	set rs=yxbbs.execute("select startip,endip,readme,id from[yx_lockip] where id="&id&"")
	if rs.eof then
		call goback("","记录不存在"):exit sub
	end if
%>
<form method=post name=form style='margin:0' action=?action=saveeditip>
<div class="ta"> 
<div class="th jz">ip封锁</div> 
<div class="td1 h22" >起始ip：</div> 
<div class="td2 h22" >&nbsp;<input name="id" value="<%=rs("id")%>" type="hidden"><input name='startip' type='text' value="<%=yxbbs.fun.ipdecode(rs("startip"))%>"></div> 
<div class="td1 h22" >结束ip：</div> 
<div class="td2 h22" >&nbsp;<input name='endip' type='text' value="<%=yxbbs.fun.ipdecode(rs("endip"))%>"> *封锁单个ip时不必填写</div> 
<div class="td1 h22" >封禁说明：</div> 
<div class="td2 h22" >&nbsp;<input name='readme' type='text' style="width:90%" value="<%=rs("readme")%>"></div> 
<div style="clear: both;"></div><div class="tf w770 jz" ><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></div>
</div></form>
	<%
	rs.close
end sub

sub delip
	dim id
	id=int(request("id"))
	yxbbs.execute("delete from[yx_lockip] where id="&id&"")
	cache.name="ipdata"
	cache.clean()
	response.redirect "?action=lockip"
end sub

sub saveaddip
	dim startip,endip,readme
	startip=yxbbs.fun.getstr("startip")
	endip=yxbbs.fun.getstr("endip")
	readme=yxbbs.fun.getstr("readme")
	if startip="" then
		call goback("","")
		exit sub
	end if
	if endip="" then endip=startip
	yxbbs.execute("insert into [yx_lockip](startip,endip,readme)values("&yxbbs.fun.ipencode(startip)&","&yxbbs.fun.ipencode(endip)&",'"&readme&"')")
	call suc("操作成功","成功添加封锁ip纪录!","?action=lockip")
	cache.name="ipdata"
	cache.clean()
end sub

sub saveeditip
	dim id,startip,endip,readme
	id=yxbbs.fun.getstr("id")
	startip=yxbbs.fun.getstr("startip")
	endip=yxbbs.fun.getstr("endip")
	readme=yxbbs.fun.getstr("readme")
	if startip="" then
		call goback("",""):exit sub
	end if
	if endip="" then endip=startip
	yxbbs.execute("update [yx_lockip]set startip="&yxbbs.fun.ipencode(startip)&",endip="&yxbbs.fun.ipencode(endip)&",readme='"&readme&"' where id="&id&"")
	call suc("","修改封锁ip成功!","?action=lockip")
	cache.name="ipdata"
	cache.clean()
end sub
sub setad
%>

<form method=post action=?action=savead>
<div class="ta"> 
<div class="th jz">广告管理</div> 
<div class="td1 jz h70" style="float: left;text-align: left;">论坛已有广告的显示效果：</div> 
<div class="td2 jz h70" style="float: left;text-align: left;">论坛已有广告的代码：<br />清空代码即删除广告。<br /><font color=red>注意：此处仅支持简单的文字图片连接，不支持google adsense等广告!</div> 
<%
dim fso1,openfile,tmpstr,tmp,ad_num,ad_i,ad_tmp
set fso1 = server.createobject("scripting.filesystemobject")
Set openfile=fso1.OpenTextFile(Server.MapPath("../inc/ads.js"))
tmpstr=openfile.readall
tmp=split(tmpstr,chr(13)&chr(10))
ad_num=replace(tmp(1),"a = ","")
ad_num=int(replace(ad_num,";if(a==0){a=1}",""))
for ad_i=1 to ad_num
ad_tmp=replace(tmp(ad_i+8),"b["&ad_i&"].under =","")
ad_tmp=replace(ad_tmp,"'","")
response.write"<div class=""td1 h75"">"&ad_tmp&"</div><div class=""td2 jz h75""><textarea  rows=5 cols=60 name=ad_v"&ad_i&" style='font-family: 宋体; font-size: 9pt'>"&ad_tmp&"</textarea></div>"
next
openfile.close
set fso1=nothing
%>  
<div class="td1 h75">增加广告：</div> 
<div class="td2 jz h75"><textarea row=3 cols=60 name=ad_v<%=ad_num+1%> rows="5" style="font-family: 宋体; font-size: 9pt"></textarea></div> 
<div style="clear: both;"></div><div class="tf jz"> <input type="submit" value="     确  认  修  改     " name="b1"></div>
</div></form>


<%
end sub
sub savead
dim adv_num,ad_msg,fso1,OpenFile,tmpstr,tmp,ad_num,ad_i,ad_tmp
set fso1 = server.createobject("scripting.filesystemobject")
Set openfile=fso1.OpenTextFile(Server.MapPath("../inc/ads.js"))
tmpstr=openfile.readall
tmp=split(tmpstr,chr(13)&chr(10))
ad_num=replace(tmp(1),"a = ","")
ad_num=int(replace(ad_num,";if(a==0){a=1}",""))
openfile.close
set fso1=nothing
adv_num=0
for ad_i=1 to ad_num+1
ad_tmp=replace(request.form("ad_v"&ad_i&""),"'","")
if trim(ad_tmp)<>"" or isnull(ad_tmp)then
adv_num=adv_num+1
ad_msg=ad_msg&"b["&adv_num&"].under ='"&ad_tmp&"'"&vbcrlf
end if
next
dim objFSO,objname
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
Set objname=objFSO.CreateTextFile(Server.MapPath("../inc/ads.js"),True)
objname.Write"<!--"&vbcrlf&"a = "&adv_num&";if(a==0){a=1}"&vbcrlf&"var slump = Math.random();"&vbcrlf&"var talet = Math.round(slump * (a-1))+1;"&vbcrlf&"function create() { "&vbcrlf&"this.under = '' "&vbcrlf&"}"&vbcrlf&"b = new Array() "&vbcrlf&"for(var i=1; i<=a; i++) { b[i] = new create() } "&vbcrlf&ad_msg&"var visa = """";"&vbcrlf&"document.write(b[talet].under); "&vbcrlf&"//-->"
objname.close
set objfso=nothing
response.redirect"?action=setad"
end sub

sub updatebbs
%>

<div class="ta">
<div class="th jz">论坛整理修复</div>
<div class="tf h30"><b>注意事项：</b>论坛整理中的各项运行都需要消耗比较多的资源<br />所以请你选择论坛访问人数较少的时候进行整理，或者在整理过程中可以先暂时关闭论坛</div>
<div class="td3 w152 h40">更新空间缓存</div><div class="td3 w470 h40" style="text-align: left;">论坛采用了服务器缓存技术，一些改动有时不会马上生效，所以您需要更新空间的缓存才能看到效果！本站现使用缓存<font color=red><%=application.contents.count%></font>个</div><div class="td3 w131 h40 jz"><input value="开始更新" type="button" onclick=window.location.href='?action=execlean'></div>
<div class="td3 w152 h40">论坛系统整理</div><div class="td3 w470 h40" style="text-align: left;">重新计算总主题数、总帖数、今日帖数、用户数、新注册用户等<br /> 建议每隔一段时间运行一次。</div><div class="td3 w131 h40 jz"><input value="开始整理" type="button" onclick=window.location.href='?action=updatebbsdate'></div>
<div class="td3 w152 h40">论坛版面整理</div><div class="td3 w470 h40" style="text-align: left;">各版面总帖数、主题数、今日帖数、各版版主、最后回复等.建议每隔一段时间运行一次。清理的过程中请不要刷新和关闭！</div><div class="td3 w131 h40 jz"><input value="开始整理" type="button" onclick=window.location.href='?action=boardupdate'></div>
<div class="td3 w152 h40">论坛垃圾清理</div><div class="td3 w470 h40" style="text-align: left;">清理无效版主、无效帖子、无效主题、无效帖子、无效投票、元效留言、无效用户帖等.清理的过程中请不要刷新和关闭！</div><div class="td3 w131 h40 jz"><input value="开始清理" type="button" onclick=window.location.href='?action=delwuiong'></div>
<div class="td3 w152 h40">修复主题帖数</div><div class="td3 w470 h40" style="text-align: left;">重新整理计算每个主题帖的回复帖数、最后回复信息等<br />如果论坛帖子非常多，整理过程可能将消耗大量资源。</div><div class="td3 w131 h40 jz"><input value="开始整理" type="button" onclick=window.location.href='?action=updatetopic'></div>
<div class="td3 w152 h40">修复用户信息</div><div class="td3 w470 h40" style="text-align: left;">各版面总帖数、主题数、今日帖数、各版版主、最后回复等.建议每隔一段时间运行一次。清理的过程中请不要刷新和关闭！</div><div class="td3 w131 h40 jz"><input value="开始整理" type="button" onclick=window.location.href='?action=updatealluser'></div>
<div style="clear: both;"></div></div>
<%
end sub

sub execlean
application.contents.removeall
call suc("","更新缓存成功","?action=updatebbs")
end sub

sub updatebbsdate
	dim essaynum,topicnum,newuser,todaynum,usernum,alltable,i
	usernum=yxbbs.execute("select count(id) from[yx_user]")(0)
	newuser=yxbbs.execute("select top 1 name from [yx_user] order by id desc")(0)
	alltable=split(yxbbs.bbstable(0),",")
	for i=0 to ubound(alltable)
		essaynum=essaynum+yxbbs.execute("select count(bbsid) from[yx_bbs"&alltable(i)&"] where isdel=false")(0)
		todaynum=todaynum+yxbbs.execute("select count(bbsid) from[yx_bbs"&alltable(i)&"] where isdel=false and datediff('d',lasttime,'"&yxbbs.nowbbstime&"')<1")(0)
	next
	topicnum=yxbbs.execute("select count(topicid) from[yx_topic]")(0)
	yxbbs.execute("update [yx_config] set usernum="&usernum&",allessaynum="&essaynum&",topicnum="&topicnum&",todaynum="&todaynum&",newuser='"&newuser&"'")
	call suc("论坛系统整理成功","论坛系统整理成功，整理后：<li>总帖数："&essaynum&" | 主题数："&topicnum&" | 今日帖数："&todaynum&" | 注册用户数："&usernum&" | 最新注册用户："&newuser&"","?action=updatebbs")
	cache.name="config"
	cache.clean()
end sub

sub updatetopic
	dim caption,content,id1,id2,lastreply,go,replynum,alltable,i,temp,maxid
	id1=yxbbs.fun.getstr("id1")
	id2=yxbbs.fun.getstr("id2")
	maxid=yxbbs.execute("select max(topicid)from [yx_topic]")(0)
	if id1="" then
		id1=1:id2=100
		go= " 开始整理 "
	else
		if not isnumeric(id1) or not isnumeric(id2) then call goback("","<li>请用数字填写！"):exit sub
		set rs=yxbbs.execute("select topicid,sqltableid from [yx_topic] where topicid>="&id1&" and topicid<="&id2&"")
		if rs.eof then
			if int(id2) < int(maxid) then
				call goback("数据据中没有数据","在id：<font color=red>"&id1&"</font> 至 <font color=red>"&id2&"</font> 之间不存在帖子，请把结束id的数字填大一些。")
			else
				call suc("整理结束","全部整理成功!","?action=updatebbs")
			end if
			exit sub
		end if
		alltable=split(yxbbs.bbstable(0),",")
		do while not rs.eof
		for i=0 to ubound(alltable)
			if int(rs(1))=int(alltable(i)) then
				replynum=yxbbs.execute("select count(bbsid) from [yx_bbs"&rs(1)&"] where isdel=false and replytopicid="&rs(0)&"")(0)
				yxbbs.execute("update [yx_topic] set replynum="&replynum&" where topicid="&rs(0)&"")
				exit for
			end if
		next
		rs.movenext
		loop
		rs.close
		temp=id1
		id1=int(id2)+1
		id2=int(id2)+int(id2)-int(temp)+1
		go=" 继续整理 "
	end if
	caption="主题帖子整理"
	content="<div style=""height:109px;text-align: left;""><form method=post action='?action=updatetopic' onsubmit='ok.disabled=true;ok.value=""正在整理-请稍等...""'>请填写你要整理的帖子的开始id和结束id：（两者之间不要相差太大）<br />你的论坛帖子最大的 id 为："&maxid&"<br />初始id：<input type=text name='id1' size=20 value="&id1&"><br />结束id：<input type=text name='id2' size=20 value="&id2&"><br /><input type=submit name='ok' value="&go&"><input type=reset value=' 重 置 '> </p></form></div>"
	call showtable(caption,content)
end sub

sub updatealluser
	dim caption,content,id1,id2,gradenum,goodnum,essaynum,ug,go,alltable,i,temp,maxid
	id1=yxbbs.fun.getstr("id1"):id2=yxbbs.fun.getstr("id2")
	maxid=yxbbs.execute("select max(id)from [yx_user]")(0)
	if id1="" then
		id1=1:id2=100
		go= " 开始整理 "
	else
		if not isnumeric(id1) or not isnumeric(id2) then call goback("","<li>请用数字填写！"):exit sub
		set rs=yxbbs.execute("select name,classid from [yx_user] where id>="&id1&" and id<="&id2&"")
		if rs.eof then
			if int(id2) < int(maxid) then
				call goback("数据据中没有数据","在id：<font color=red>"&id1&"</font> 至 <font color=red>"&id2&"</font> 之间不存在用户，请把结束id的数字填大一些。")
			else
				call suc("整理结束","全部整理成功!","?action=updatebbs")
			end if		
			exit sub
		end if
		alltable=split(yxbbs.bbstable(0),",")
		do while not rs.eof
			essaynum=0
			goodnum=0
			for i=0 to ubound(alltable)
				essaynum=essaynum+yxbbs.execute("select count(bbsid) from [yx_bbs"&alltable(i)&"] where name='"&rs(0)&"'")(0)
			next
				goodnum=yxbbs.execute("select count(topicid) from [yx_topic] where name='"&rs(0)&"' and isgood=true")(0)
			set ug=yxbbs.execute("select top 1 gradenum from yx_usergrade where classid="&rs(1)&" and userminpostnum<="&essaynum&" order by userminpostnum desc")
			if not ug.eof then
				gradenum=ug(0)
			end if
			ug.close
			set ug=nothing
			yxbbs.execute("update [yx_user] set essaynum="&essaynum&",goodnum="&goodnum&",gradenum="&gradenum&" where name='"&rs(0)&"'")
		rs.movenext
		loop
		rs.close
		temp=id1
		id1=int(id2)+1
		id2=int(id2)+int(id2)-int(temp)+1
		go=" 继续整理 "
	end if
	caption="用户整理修复"
	content="<form method=post action='?action=updatealluser' onsubmit='ok.disabled=true;ok.value=""正在整理-请稍等...""'><div style=""height:109px;text-align: left;"">请填写你要整理用户的开始id和结束id：（两者之间不要相差太大）<br />论坛注册用户最大的 id 为："&maxid&"<br />初始id：<input type=text name='id1' size=20 value="&id1&"><br />结束id：<input type=text name='id2' size=20 value="&id2&"><br /><input name='ok'  type=submit value="&go&" ><input type=reset value=' 重 置 '> </p></div></form>"
	call showtable(caption,content)
end sub

sub delwuiong
	dim ii,i,alltable%>
<div class="ta">
<div class="th jz">论坛垃圾清理</div>
<div class="tf jz h75" style="text-align: left;"><b><span id=YxBBsT name=YxBBsT>正在清理无效主题！请稍等...</span></b><br /><img src="../images/hr.gif" width=0 height=16 id=YxBBsimg name=YxBBsimg align=absmiddle /><br /><span id=YxBBstxt name=YxBBstxt style="font-size:9pt">0</span><span style="font-size:9pt">%</span></div>
</div>

	
	<%response.flush
	alltable=split(yxbbs.bbstable(0),",")
	for i=0 to ubound(alltable)
		yxbbs.execute("delete * from [yx_bbs"&alltable(i)&"] where topicid<>0 and not exists (select name from [yx_topic] where [yx_bbs"&alltable(i)&"].topicid=[yx_topic].topicid)")
		yxbbs.execute("delete * from [yx_topic] where sqltableid="&alltable(i)&" and not exists (select name from [yx_bbs"&alltable(i)&"] where [yx_topic].topicid=[yx_bbs"&alltable(i)&"].topicid)")
	next
	call table("无效主题清理完毕！","")
	
	call picpro(1,6,"正在清理无效投票！请稍等...")
		yxbbs.execute("delete * from [yx_topicvote] where  not exists (select name from [yx_topic] where [yx_topicvote].topicid=[yx_topic].topicid)")
		yxbbs.execute("delete * from [yx_topicvoteuser] where  not exists (select name from [yx_topic] where [yx_topicvoteuser].topicid=[yx_topic].topicid)")
	call table("无效投票清理完毕！","")
	
	call picpro(2,6,"正在清理无效留言！请稍等...")
		yxbbs.execute("delete * from [yx_sms] where not exists (select name from [yx_user] where [yx_sms].myname=[yx_user].name)")
	call table("无效留言清理完毕！","")
	
	call picpro(3,6,"正在清理删除用户的帖子！请稍等...")
		for i=0 to ubound(alltable)
		yxbbs.execute("delete * from [yx_bbs"&alltable(i)&"] where not exists (select name from [yx_user] where [yx_bbs"&alltable(i)&"].name=[yx_user].name)")
		next
		yxbbs.execute("delete * from [yx_topic] where not exists (select name from [yx_user] where [yx_topic].name=[yx_user].name)")
	call table("无效用户的帖子清理完毕！","")

	call picpro(4,6,"正在清理无效回复帖子！请稍等...;")
	for i=0 to ubound(alltable)
		set rs=yxbbs.execute("select replytopicid from [yx_bbs"&alltable(i)&"] where replytopicid<>0")
		do while not rs.eof
			if yxbbs.execute("select topicid from [yx_bbs"&alltable(i)&"] where topicid="&rs(0)&"").eof then
			yxbbs.execute("delete from [yx_bbs"&alltable(i)&"] where replytopicid="&rs(0)&"")
			end if
		rs.movenext
		loop
		rs.close
	next
	call table("无效回复清理完毕！","")
	Response.Write "<script>YxBBsimg.width=400;YxBBstxt.innerHTML=""100"";YxBBsT.innerHTML=""<font color=red>成功完成整理！</font>"";</script>"
end sub


'进度条
Sub PicPro(i,sum,strtxt)
	Response.Write "<script>YxBBsimg.width=" & Fix((i/sum) * 400) & ";" & VbCrLf
	Response.Write "YxBBstxt.innerHTML=""" & FormatNumber(i/sum*100,4,-1) & """;" & VbCrLf
	Response.Write "YxBBsT.innerHTML="""& StrTxt & """;"& VbCrLf
	Response.Write "</script>" & VbCrLf
	Response.Flush
End Sub

sub boardupdate
	%>
<div class="ta">
<div class="th jz">论坛版面整理</div>
<div class="tf jz h75" style="text-align: left;"><b><span id=YxBBsT name=YxBBsT>数据版面正在整理，请稍等</span></b><br /><img src="../images/hr.gif" width=0 height=16 id=YxBBsimg name=YxBBsimg align=absmiddle><br /><span id=YxBBstxt name=YxBBstxt style="font-size:9pt">0</span><span style="font-size:9pt">%</span></div>
</div>
	<%response.flush
	dim boardnum,essaynum,topicnum,todaynum,parentstr,lastreply,lastcaption
	dim alltable,i,ii,iii,sql
	boardnum=yxbbs.execute("select count(boardid) from[yx_board] where parentid<>0")(0)
	ii=0
	set rs=yxbbs.execute("select boardid,boardname,child,parentstr,rootid from[yx_board] where parentid<>0  order by child,rootid,orders desc")
	if not rs.eof then 
	sql=rs.getrows()
	rs.close
	for i=0 to ubound(sql,2)
	essaynum=0
	topicnum=0
	todaynum=0
	lastreply=""
	lastcaption="无"
	alltable=split(yxbbs.bbstable(0),",")
	for iii=0 to ubound(alltable)
		essaynum=essaynum+yxbbs.execute("select count(*) from[yx_bbs"&alltable(iii)&"] where boardid="&sql(0,i)&" and isdel=false")(0)
		todaynum=todaynum+yxbbs.execute("select count(*) from[yx_bbs"&alltable(iii)&"] where boardid="&sql(0,i)&" and isdel=false and datediff('d',[lasttime],'"&yxbbs.nowbbstime&"')<1")(0)
	next
	topicnum=yxbbs.execute("select count(topicid) from[yx_topic] where boardid="&sql(0,i)&" and isdel=false")(0)
	set rs=yxbbs.execute("select top 1 topicid,name,caption,addtime,face,sqltableid,boardid from [yx_topic] where isdel=false and boardid="&sql(0,i)&" order by topicid desc")
	if not rs.eof then
		lastcaption=replace(yxbbs.fun.strleft(rs("caption"),20),"'","&#39;")
		lastreply=rs("name")&"|"&lastcaption&"|"&rs("addtime")&"|"&rs("face")&"|"&rs("topicid")&"|"&rs("boardid")&"|"&rs("sqltableid")&""
	end if
	rs.close
	yxbbs.execute("update [yx_board] set essaynum="&essaynum&",todaynum="&todaynum&",topicnum="&topicnum&",lastreply='"&lastreply&"' where boardid="&sql(0,i)&"")
	'如果有上级论坛，那么更新上级论坛
	if sql(2,i)>0 then
		parentstr=sql(3,i) & "," & sql(0,i)
		set rs=yxbbs.execute("select sum(essaynum),sum(topicnum),sum(todaynum) from [yx_board] where parentstr = '"&parentstr&"'")
		if not isnull(rs(0)) then essaynum = rs(0) + essaynum
		if not isnull(rs(1)) then topicnum = rs(1) + topicnum
		if not isnull(rs(2)) then todaynum = rs(2) + todaynum
		rs.close
		set rs=yxbbs.execute("select top 1 topicid,name,caption,addtime,face,sqltableid,boardid from [yx_topic] where isdel=false and boardid in ("&parentstr&") order by lasttime desc")
		if not rs.eof then
			lastcaption=replace(yxbbs.fun.strleft(rs("caption"),20),"'","&#39;")
			lastreply=rs("name")&"|"&lastcaption&"|"&rs("addtime")&"|"&rs("face")&"|"&rs("topicid")&"|"&rs("boardid")&"|"&rs("sqltableid")&""
		end if
		rs.close
		yxbbs.execute("update [yx_board] set essaynum="&essaynum&",todaynum="&todaynum&",topicnum="&topicnum&",lastreply='"&lastreply&"' where boardid="&sql(0,i)&"")
	end if
	call table("论坛 <font color=blue>"&sql(1,i)&"</font> 整理成功","总帖数"&essaynum&" | 主题数："&topicnum&" | 今日帖："&todaynum&" | 最新主题："&lastcaption&"")
	ii=ii+1
	Response.Write "<script>YxBBsimg.width=" & Fix((ii/BoardNum) * 400) & ";" & VbCrLf
	Response.Write "YxBBstxt.innerHTML=""" & FormatNumber(ii/BoardNum*100,4,-1) & """;" & VbCrLf
	Response.Write "</script>" & VbCrLf
	response.flush
	next
	end if
	Response.Write "<script>YxBBsimg.width=400;YxBBstxt.innerHTML=""100"";YxBBsT.innerHTML=""<font color=red>成功完成整理！</font>"";</script>"
end sub
%>

