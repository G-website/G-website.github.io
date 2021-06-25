<!--#include file="Inc/SysConfig.Asp"-->

<%
YxBBs.Head("调用系统")
dim Rs
Set Rs=YxBBs.execute("Select BBSUrl From [YX_config]")%>
<script language="JavaScript" type="text/javascript">
function Show(ast){
//主题
if(ast==1){
str="topic"
tmp=document.ToYxBBs.bid.options[document.ToYxBBs.bid.selectedIndex].value
if(tmp!="")str+="&boardid="+tmp;
tmp=document.ToYxBBs.num.value;
if(tmp!="")str+="&num="+tmp;
tmp=document.ToYxBBs.type.options[document.ToYxBBs.type.selectedIndex].value
if(tmp!="")str+="&type="+tmp;
tmp=document.ToYxBBs.order.options[document.ToYxBBs.order.selectedIndex].value
if(tmp!="")str+="&order="+tmp;
tmp=document.ToYxBBs.day.options[document.ToYxBBs.day.selectedIndex].value
if(tmp!="")str+="&day="+tmp;
tmp=document.ToYxBBs.len.value
if(tmp!="")str+="&len="+tmp;
tmp=document.ToYxBBs.user.options[document.ToYxBBs.user.selectedIndex].value
if(tmp!="")str+="&user="+tmp;
tmp=document.ToYxBBs.time.options[document.ToYxBBs.time.selectedIndex].value
if(tmp!="")str+="&time="+tmp;
tmp=document.ToYxBBs.face.options[document.ToYxBBs.face.selectedIndex].value
if(tmp!="")str+="&face="+tmp;
}
//信息
if(ast==2){
str="info"
var obj=document.getElementsByTagName("input");
tmp="|"
	for (var i=0;i<obj.length;i++)
	{
		if (obj[i].checked==true){tmp+=obj[i].value+"|"};
	}
	if (tmp!="|")str+="&flag="+tmp;
tmp=document.ToYxBBs.face.options[document.ToYxBBs.face.selectedIndex].value
if(tmp!="")str+="&face="+tmp;
}
//会员
if(ast==3){
str="user"
tmp=document.ToYxBBs.flag.options[document.ToYxBBs.flag.selectedIndex].value
if(tmp!="")str+="&flag="+tmp;
tmp=document.ToYxBBs.num.value;
if(tmp!="")str+="&num="+tmp;
tmp=document.ToYxBBs.face.options[document.ToYxBBs.face.selectedIndex].value
if(tmp!="")str+="&face="+tmp;
}
//版块
if(ast==5){
str="board"
}
if(ast==6){
str="login"
tmp=document.ToYxBBs.CK.options[document.ToYxBBs.CK.selectedIndex].value
if(tmp!="")str+="&CK="+tmp;
tmp=document.ToYxBBs.HI.options[document.ToYxBBs.HI.selectedIndex].value
if(tmp!="")str+="&HI="+tmp;
}
//共用样式
tmp=document.ToYxBBs.tg.options[document.ToYxBBs.tg.selectedIndex].value
if(tmp!="")str+="&tg="+tmp;
tmp=document.ToYxBBs.h.value
if(tmp!="")str+="&h="+tmp;
tmp=document.ToYxBBs.bo.options[document.ToYxBBs.bo.selectedIndex].value
if(tmp!="")str+="&bo="+tmp;
tmp=document.ToYxBBs.boc.value
if(tmp!="")str+="&boc="+tmp;
tmp=document.ToYxBBs.bgc.value
if(tmp!="")str+="&bgc="+tmp;
document.ToYxBBs.ShowScript.value='<SCR'+'IPT language="JavaScript" type="text/javascript" src="'+'<%=Rs("BBSUrl")%>'+'/News.Asp?action='+str+'"></SC'+'RIPT>';
document.ToYxBBs.ShowScript.focus();
}
</script>
<%
dim ParentID,BBSUrl,Content
Content="<table width='98%' border='0' align='center'><tr><td align='center'><a href='?action=topic'>主题帖子调用</a> | <a href='?action=info'>论坛信息调用</a> | <a href='?action=board'>版块列表导航</a> | <a href='?action=login'>登陆信息调用</a></td></tr></table>"
Response.flush
Call YxBBs.ShowTable("调用系统",Content)
Select Case Request("Action")
Case"info"
Info
Case"board"
Board
Case"login"
Login
Case Else
Topic
End Select
YxBBs.Footer()
Set YxBBs=Nothing

sub ShowScript(ast)
Content=Content&"<td >打开方式：<SELECT size=1 name='tg'><OPTION value=1 selected>用新窗口打开</OPTION><OPTION value=0>用本窗口打开</OPTION></SELECT></tr></td>"&_
"<tr ><td>表格边框：<SELECT size=1 name='bo'><OPTION value='' selected>0</OPTION><OPTION value=1>1</OPTION><OPTION value=1>2</OPTION></SELECT></td>"&_
"<td>每行高度：<INPUT name='h' class='text' size='2' value='18' onkeypress='if (event.keyCode < 48 || event.keyCode >  57) event.returnValue = false;' /></tr></td>"&_
"<tr ><td>边框颜色：<INPUT name='boc' class='text' size='7' /></td>"&_
"<td>背影颜色：<INPUT name='bgc' class='text' size='7' /></tr></td>"&_
"<tr ><td colspan=2><INPUT class='button' onclick='Show("&ast&")' type='button' size='9' value='生成调用代码' >↓把下面的代码插入你的网页单元格中即可实现论坛帖子调用</tr></td><tr ><td colspan=2><div style='text-align:center'><textarea name='ShowScript' rows='4' cols='150'></textarea></div><div style='text-align:left; padding:5px'><b>说明：</b>本功能用于生成用于插入用户自己普通网页的代码，代码能够把论坛主题资源动态显示在普通网页任何地方！ <br>至于文字的大小将跟随主页的CSS样式表设置！</div></tr></td>"
End sub

Sub Topic
Content="<table width=98% border=0 align=center cellpadding=4 cellspacing=1><FORM name='ToYxBBs' action=?type=resosave method=post>"&_
"<tr><td colspan=2><li style='color:#f00'>参数设置：</li></td></tr>"&_
"<tr ><td>调用论坛：<SELECT size=1 name=bid><OPTION value=0 selected>所有论坛</OPTION>"&YxBBs.BoardIDList(ParentID,20)&"</SELECT></td>"&_
"<td>主题类型：<SELECT size=1 name='type'><OPTION selected>全部主题</OPTION><OPTION value=1>置顶主题</OPTION><OPTION value=2>精华主题</OPTION><OPTION value=3>投票主题</OPTION></SELECT></td></tr>"&_
"<tr ><td>显示方式：<SELECT size=1 name='order'><OPTION selected>按最后更新主题排列</OPTION><OPTION value=1 >按主题发布时间</OPTION><OPTION value=2>按最多回复主题（热帖）</OPTION><OPTION value=3>按主题点击数（人气帖）</OPTION></SELECT></td>"&_
"<td>时间范围：<SELECT size=1 name='day'><OPTION selected>所有日期</OPTION><OPTION value=3 >三天内</OPTION><OPTION value=7>一周内</OPTION><OPTION value=30>一个月内</OPTION><OPTION value=90>三个月内</OPTION></SELECT></td></tr>"&_
"<tr ><td>主题数量：<INPUT name='num' class='text' onkeypress='if (event.keyCode < 48 || event.keyCode >  57) event.returnValue = false;' value='10' size=4 maxlength='2'></td>"&_
"<td>字数限制：<INPUT name='len' class='text' onkeypress='if (event.keyCode < 48 || event.keyCode >  57) event.returnValue = false;' value=25  size=4 maxlength='3'></td></tr>"&_
"<tr ><td colspan=2><li style='color:#f00'>样式设置：</td></tr>"&_
"<tr ><td>题头标识：<SELECT size=1 name='face'><OPTION selected value=1>帖子表情</OPTION><OPTION value=0 >数字序列</OPTION><OPTION value=*>符号*</OPTION><OPTION value=★>符号★</OPTION><OPTION value=☆>符号☆</OPTION><OPTION value=◆>符号◆</OPTION><OPTION value=◇>符号◇</OPTION><OPTION>不要标识</OPTION></SELECT></td>"&_
"<td>帖子作者：<SELECT size=1 name='user'><OPTION value='' selected>不显示</OPTION><OPTION value=1>显示</OPTION></SELECT></tr></td>"&_
"<tr ><td>发帖时间：<SELECT size=1 name='time'><OPTION value='' selected>不显示</OPTION><OPTION value=1>显示</OPTION></SELECT></td>"
call ShowScript(1)
Content=Content&"</form></td></tr></table>"
Call YxBBs.ShowTable("帖子调用",Content)
End Sub

Sub Info
dim s,i
Content="<table width=98% border=0 align=center cellpadding=4 cellspacing=1 bgcolor=#FFFFFF><FORM name='ToYxBBs' action=?type=resosave method=post>"
s=Split("0,论坛帖数,主题帖数,今日帖数,昨日帖数,最高日帖,注册人数,最新会员,论坛在线,在线会员,在线游客,最高在线,建站时间",",")
Content=Content&"<tr ><td colspan=2><li style='color:#f00'>调用论坛信息：(下面各项如果不想显示，请选择)</td></tr>"
for i=1 to uBound(s)
Content=Content&"<tr ><td colspan=2><input name='n"&i&"' id='n"&i&"' type='checkbox' value='"&i&"' /> "&s(i)&"</td>"
next
Content=Content&"<tr ><td colspan=2><li style='color:#f00'>样式设置：</li></td></tr>"&_
"<tr ><td>题头标识：<SELECT size=1 name='face'><OPTION selected value='□-'>□-</OPTION></OPTION><OPTION value='*'>*</OPTION><OPTION value='★'>★</OPTION><OPTION value=☆>☆</OPTION><OPTION value=◆>◆</OPTION><OPTION value=◇>◇</OPTION><OPTION>不要标识</OPTION></SELECT></tr></td>"
CALL ShowScript(2)
Content=Content&"</form></td></tr></table>"
Call YxBBs.ShowTable("信息调用",Content)
End Sub


Sub Login
Content="<table width=98% border=0 align=center cellpadding=4 cellspacing=1 bgcolor=#FFFFFF><FORM name='ToYxBBs' action=?type=resosave method=post>"&_
"<tr ><td colspan=2><li style='color:#f00'>参数设置：</td></tr>"&_
"<tr ><td>Cookies选项：<SELECT size=1 name='CK'><OPTION value=1 selected>显示</OPTION><OPTION value=''>不显示</OPTION></SELECT></td>"&_
"<td >登陆方式：<SELECT size=1 name='HI'><OPTION value=1 selected>显示</OPTION><OPTION value=''>不显示</OPTION></SELECT></td></tr>"&_
"<tr ><td colspan=2><li style='color:#f00'>样式设置：</li></td></tr>"
CALL ShowScript(6)
Content=Content&"</form></td></tr></table>"
Call YxBBs.ShowTable("登陆系统",Content)
End Sub

Sub board
Content="<table width=98% border=0 align=center cellpadding=4 cellspacing=1 bgcolor=#FFFFFF><FORM name='ToYxBBs' action=?type=resosave method=post><tr ><td colspan=2><li style='color:#f00'>样式设置：</td></tr>"
CALL ShowScript(5)
Content=Content&"</form></td></tr></table>"
Call YxBBs.ShowTable("版块导航",Content)
End Sub
%>


