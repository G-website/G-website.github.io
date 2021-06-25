
<!-- #include file="../inc/public_cls.asp" -->
<!-- #include file="../inc/yx_cls.asp" -->
<%
db="../data/Yxbbs.asa"
set conn=server.createobject("adodb.connection")
connstr="provider=microsoft.jet.oledb.4.0;data source="&server.mappath(db)
conn.open connstr

dim yxbbs,cache
set yxbbs = new cls_public
set cache = new cls_cache
yxbbs.systemconfig()
yxbbs.checkuser()



sub goback(str1,str2)
	if str1="" then str1="错误信息"
	if str2="" then str2="请填写完整必填项目"
	str2="<li>"&str2&"<li><a href=""javascript:history.go(-1)"">返回重填</a>"
        response.write("<div class=""ta""><div class=""th jz"">"&str1&"</div><div class=""w94"" style=""float: left;color:red;font: 50px/50px 宋体;height:70px;background-color:#f0f4f7;"">×</div><div class=""w700 jz1"" style=""float: left;height: 70px;background-color:#f0f4f7;"">"&str2&"</div><div style=""clear: both;""></div></div>")
	response.end()
end sub

sub suc(str1,str2,url)
	if str1="" then str1="操作成功"
	if str2="" then str2="成功的完成这次操作！"
	str2="<li>"&str2&"<li><a href="&url&">返回继续管理</a>"
        application.contents.removeall
response.write("<div class=""ta""><div class=""th jz"">"&str1&"</div><div class=""w94"" style=""float: left;color:red;font: 50px/50px 宋体;height:50px;background-color:#f0f4f7;"">√</div><div class=""w700 jz1"" style='float: left;height: 50px;background-color:#f0f4f7;'>"&str2&"</div><div style=""clear: both;""></div></div>")
end sub

sub showtable(str1,str2)
response.write("<div class=""ta""><div class=""th jz"">"&str1&"</div><div class=""td w772"">"&str2&"</div><div style=""clear: both;""></div> </div><br />")
end sub

sub table(str1,str2)
 response.write("<br /><div class=""ta""><div class=""td w772"">"&str1&"<br>"&str2&"</div><div style=""clear: both;""></div></div>")
end sub

sub adminfooter()
response.write"<br /><div style=""font-family:verdana, tahoma, arial;font-size: 7.5pt; text-align: center;"">copyright &copy; 2005-2018 <a href=http://www.grgbanking123.top/yxbbs/ target='_blank'><span style=""color:#800000;font-weight: bold;"">www.grgbanking123.top/yxbbs</span></a> all rights reserved .</span></div></body></html>"
	set yxbbs=nothing
end sub

sub space()
response.write"<div class=""w160"" style=""height:12px;""></div>"
end sub
  
%>
<!doctype html public "-//w3c//dtd xhtml 1.0 frameset//en" http://www.w3.org/tr/xhtml1/dtd/xhtml1-frameset.dtd">
<html xmlns=http://www.w3.org/1999/xhtml>
<head>
<meta http-equiv="content-type" content="text/html; charset=gb2312"  />
<title>Yxbbs 后台管理系统</title>
<link href="style.css" rel="stylesheet" type="text/css" />
</head>
