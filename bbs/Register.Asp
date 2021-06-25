<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="inc/md5.Asp"-->
<script>
function checkusername(name)
{
	if (name.length>14 |name.length<3)
	{
	   var divobj = document.getElementById("divusername");
       divobj.innerHTML = "用户名长度需要在3-14之间!";
	}
		else
	{
	   	   var exitdos = new ActiveXObject("Microsoft.XMLHTTP"); 
           ////中文等特殊字符要先用escape编码 
           exitdos.open("POST","See.Asp?Action=CheckName&name="+escape(name),false); 
           exitdos.send(); 
           //解码用escape方法进行了编码的String对象
           //document.form.name.value=unescape(exitdos.responseText) 
		    var divobj = document.getElementById("divusername");
		   divobj.innerHTML = unescape(exitdos.responseText);
		  
	}
	
}

function checkpassword(Password)
{
	if (Password.length>14 |Password.length<6)
	{
	   var divobj = document.getElementById("divpassword");
       divobj.innerHTML = "密码长度需要在6-16之间!";

	}
	else
	{
		
		var divobj = document.getElementById("divpassword");
		divobj.innerHTML = "";
		
	}
}

function checkrepassword(RePassword)
{
		if(form.Password.value==form.RePassword.value)
		{
		  var divobj = document.getElementById("divrepassword");  
		   divobj.innerHTML = "";			 
		}
		else
		{
		   var divobj = document.getElementById("divrepassword");
		   divobj.innerHTML = "密码不一致!";
		}
	}
function checkClue(Clue)
{
		if(form.Clue.value=="")
		{
		  var divobj = document.getElementById("divClue");  
		   divobj.innerHTML = "请输入问题!";			 
		}
		else
		{
		   var divobj = document.getElementById("divClue");
		   divobj.innerHTML = "";
		}
	}
function checkAnswer(Answer)
{
		if(form.Answer.value=="")
		{
		  var divobj = document.getElementById("divAnswer");  
		   divobj.innerHTML = "请输入答案!";			 
		}
		else
		{
		   var divobj = document.getElementById("divAnswer");
		   divobj.innerHTML = "";
		}
	}
	
	function checkemail(name)
{
	if (name.length<5)
	{
	   var divobj = document.getElementById("divemail");
       divobj.innerHTML = "邮箱不正确!";

	}
	else
	{
		var myReg = /^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([abcegimnortvz]{2,3})$/;
		  if(myReg.test(name)) 
		{
		  var divobj = document.getElementById("divemail");  
		   divobj.innerHTML = "";			 
		}
		else
		{
		   var divobj = document.getElementById("divemail");
		   divobj.innerHTML = "邮箱检查不通过！";
		}
	}
}
</script> 

<%
Dim Action
If Session(YxBBs.CacheName&"LoginTime")+YxBBs.BBSSetting(28)/1440>now() then YxBBs.Error("在同一用户来源限制注册间隔<b>"&YxBBs.BBSSetting(28)&"</b> 分钟！")
If YxBBs.BBSSetting(0)="1" then YxBBs.Error("论坛暂不允许新用户注册！")
Call YxBBs.Head("注册新用户")
Action=Request.QueryString("action")
Select Case Action
Case"agree"
	Register()
Case"check"
	RegSaveData()
Case Else
	RegMain()
End Select
YxBBs.Footer()
Set YxBBs=Nothing

Sub RegMain()
	Dim Caption,Content
	Caption="注册协议"
	Content="<table width='98%' align='center'><tr><td><br>"&_
	"欢迎您加入【"&YxBBs.BBSName&"】参加交流和讨论，【"&YxBBs.BBSName&"】为公共论坛，为维护网上公共秩序和社会稳定，请遵守以下条款： <br>"& vbCrLf&_
	"<br>"& vbCrLf&_
	"一、不得利用本站危害国家安全、泄露国家秘密，不得侵犯国家社会集体的和公民的合法权益，不得利用本站传播下列信息： <br>"& vbCrLf&_
	"<br>"& vbCrLf&_
	"（一）煽动抗拒、破坏宪法和法律、行政法规实施的； <br>"& vbCrLf&_
	"（二）煽动颠覆国家政权，推翻社会主义制度的； <br>"& vbCrLf&_
	"（三）煽动分裂国家、破坏国家统一的； <br>"& vbCrLf&_
	"（四）煽动民族仇恨、民族歧视，破坏民族团结的； <br>"& vbCrLf&_
	"（五）捏造或者歪曲事实，散布谣言，扰乱社会秩序的； <br>"& vbCrLf&_
	"（六）宣扬封建迷信、淫秽、色情、赌博、暴力、凶杀、恐怖、教唆犯罪的； <br>"& vbCrLf&_
	"（七）公然侮辱他人或者捏造事实诽谤他人的，或者进行其他恶意攻击的； <br>"& vbCrLf&_
	"（八）损害国家机关信誉的； <br>"& vbCrLf&_
	"（九）其他违反宪法和法律行政法规的； <br>"& vbCrLf&_
	"（十）进行商业广告行为的。 <br>"& vbCrLf&_
	"<br>"& vbCrLf&_
	"二、互相尊重，对自己的言论和行为负责。"& vbCrLf&_
	"</td></tr>"&_
	"<tr><td><form method=POST action='?action=agree'><center><input type=submit class=submit value=' 确 定 '> <input type='button' value=' 取 消 ' onClick=window.location.href='Default.Asp'></center></form></td></tr></table>"
	Call YxBBs.ShowTable(Caption,Content)
End Sub


Function Jncode(Istr)
Dim japArr,ArrNum
japArr=Array("ゴ","ガ","ギ","グ","ゲ","ザ","ジ","ズ","ヅ","デ","ド","ポ","ベ","プ","ビ","パ","ヴ","ボ","ペ","ブ","ピ","バ","ヂ","ダ","ゾ","ゼ")
For ArrNum=0 to Ubound(japArr)
Istr=Replace(Istr,japArr(ArrNum),"&#"&AscW(japArr(ArrNum))&";")
Next
Jncode=Istr
End Function

Sub RegSaveData()
	YxBBs.Fun.CheckMake
	Dim Temp,Caption,Content,Rs,Sql,Name,password,RePassword,Clue,Answer,Mail,PicUrl,HeadPic,PicW,PicH,Home,Sign,QQ,IsQQpic,Sex,Birthday
	Name=YxBBs.Fun.GetStr("Name")
	password=YxBBs.Fun.GetStr("Password")
	RePassword=YxBBs.Fun.GetStr("RePassword")
	Clue=YxBBs.Fun.GetStr("Clue")
	Answer=YxBBs.Fun.GetStr("Answer")
	Mail=YxBBs.Fun.GetStr("Mail")
	If name="" or Password="" or RePassword="" or Mail="" or Clue="" or Answer="" Then YxBBs.Error("请填写完整的必填项目！")	
	If Not YxBBs.Fun.CheckName(name) Then YxBBs.Error("用户名中有非法字符或被屏蔽字符！")
	If YxBBs.Fun.StrLength(name)>14  or YxBBs.Fun.strLength(password)>14 or YxBBs.Fun.StrLength(name)<3 Then YxBBs.Error("用户名或密码长度不符合字符个数.")
	If instr("@@"&lcase(YxBBs.BadName)&"@@","@@"& lcase(Name) &"@@")>0 Then YxBBs.Error("用户名中有非法字符或被屏蔽字符！")
	If Not YxBBs.Execute("SELECT name FROM [YX_user] where Name='"&Name&"'").Eof Then YxBBs.Error("您申请注册的这个昵称已经被另一个用户使用了！")
	IF len(Password)<6 Then YxBBs.Error("密码长度不能小于6个字符！")
	If Repassword<>Password Then YxBBs.Error("两次输入密码不一致！")
	Mail=Server.HTMLEncode(Mail)
	If Not YxBBs.Fun.IsValidEmail(Mail) Then YxBBs.Error("错误的E-Mail地址！")
	PicUrl=YxBBs.Fun.HtmlCode(YxBBs.Fun.GetStr("PicUrl"))
	HeadPic=YxBBs.Fun.HtmlCode(YxBBs.Fun.GetStr("HeadPic"))
	Home=YxBBs.Fun.HtmlCode(YxBBs.Fun.GetStr("Home"))
	Sex=YxBBs.Fun.GetStr("Sex")
	Birthday=Trim(YxBBs.Fun.GetStr("BirthYear"))&"-"&Trim(YxBBs.Fun.GetStr("BirthMonth"))&"-"&Trim(YxBBs.Fun.GetStr("Birthday"))
	QQ=YxBBs.Fun.GetStr("QQ")
	IsQQpic=YxBBs.Fun.GetStr("IsQQpic")
	If Instr(Home,"://")=0 Then Home=""
	If IsQQpic<>"1" Then IsQQpic="0"
	Sign=Left(YxBBs.Fun.HtmlCode(YxBBs.Fun.GetStr("Sign")),255)
	PicH=YxBBs.Fun.GetStr("PicH")
	PicW=YxBBs.Fun.Getstr("PicW")
        Name=Jncode(Name)
	If PicUrl="" then
		PicUrl="Images/UserHead/"& HeadPic &".gif"
		PicW= YxBBs.BBSSetting(16)
		PicH= YxBBs.BBSSetting(17)
	End If
	If (QQ<>"" And not isnumeric(QQ)) Or (IsQQpic="1" and QQ="") then YxBBs.Error("您的QQ号码填写错误！")
	If Len(Clue)>70 Or Len(Answer)>70 or Len(Mail)>50 or Len(HeadPic)>220 or Len(QQ)>20 or Len(Home)>250 Then YxBBs.Error("您填写的一些字符数超过了论坛的限制！")
	If Not isnumeric(PicW) or Not isnumeric(PicH) Then YxBBs.Error("头像宽度和高度必须用数字填写！")
	If PicW>int(YxBBs.BBSSetting(15)) or PicH>int(YxBBs.BBSSetting(15)) then
		PicW=YxBBs.BBSSetting(16)
		PicH=YxBBs.BBSSetting(17)
	End If
	Birthday=Replace(Replace(Birthday,",","-")," ","")
	If Not isdate(Birthday) then Birthday="1900-01-01"
	
	Dim GradeNum,Grs,Isdel,Auditing
	Set Grs=YxBBs.Execute("Select GradeNum from YX_UserGrade where ClassID=5 Order By UserMinPostNum Asc")
	GradeNum=Grs(0)
	Set Grs=Nothing
	If YxBBs.BBSSetting(34)="0" Then
	Isdel="0"
	Auditing="<div style='margin:15;line-height: 150%'><b>恭喜您在注册成功！</b><li>您的用户名是：<font color=red><b>"&name&"</b></font>.<br><li>但目前论坛开启了用户审核机制，请您稍后登陆！<br><li><a href='Default.Asp'>返回首页</a></div>"
	else
	Isdel="1"
	Auditing="<div style='margin:15;line-height: 150%'><b>恭喜您成为本论坛会员</b><li>您的用户名是：<font color=red><b>"&name&"</b></font>，请记住您的密码！<li>现在<a href='login.Asp'>登陆</a>？&nbsp;&nbsp;返回<a href='Default.Asp'>首页</a></div>"
	end if
	YxBBs.Execute("Insert into [YX_User](Name,[Password],Clue,Answer,Mail,Home,Sex,IsQQpic,Birthday,QQ,GradeNum,ClassID,Pic,PicW,PicH,RegTime,LastTime,Sign,Regip,LastIp,isdel)VALUES('"&Name&"','"&Md5(password)&"','"&Clue&"','"&Md5(Answer)&"','"&Mail&"','"&Home&"',"&Sex&","&IsQQpic&",'"&Birthday&"','"&QQ&"',"&GradeNum&",5,'"&PicUrl&"',"&PicW&","&PicH&",'"&YxBBs.NowBbsTime&"','"&YxBBs.NowBbsTime&"','"&Sign&"','"&YxBBs.MyIP&"','"&YxBBs.MyIP&"','"&isdel&"')")
	YxBBs.Execute("update [YX_Config] set NewUser='"&name&"',UserNum=UserNum+1")

	If YxBBs.BBSSetting(5)="0" Then
		YxBBs.Execute("insert into [YX_sms](name,MyName,Title,Content,ubbString) values('系统消息','"&name&"','"&YxBBs.BBSName&"欢迎您！','"&YxBBs.RegAutoSms&"',',')")
		YxBBs.Execute("update [YX_User] set NewSmsNum=NewSmsNum+1 Where Name='"&name&"'")
	End If
	Caption="注册成功"
	Content=Auditing
	Call YxBBs.ShowTable(Caption,Content)
	Session(YxBBs.CacheName&"LoginTime")=Now()
End Sub

Sub Register()
	Dim Caption,Content,HeadPic
	HeadPic=HeadPicOpt()
	Caption="新用户注册"
	Content="<form style='margin:0' method='POST' action='?action=check' name='form'>"&_
	"<table align='center' width='100%' border='0' cellpadding='0' cellspacing='5' rules=rows frame=void><tr><td height='25' bgcolor='#E8E8E8' colspan=3>&nbsp;<font color=blue>+=必填资料=+</font></td></tr>"&_
	"<tr><td width='35%'><b>用户名称</b>：<br>注册用户名不能超过14个字符（7个汉字）</td><td width='65%'><input type=text name='Name' maxlength='20' onblur='checkusername(this.value)'> <span id='divusername' style='color:#FF0000'></span></td></tr>"&_
	"<tr><td><b>您的性别：</b></td><td><input name='sex' type='radio' value='1' checked><img src='Images/11.gif' align='absmiddle'></img> 帅哥&nbsp;&nbsp;<input type='radio' name='sex' value='0'><img src='Images/01.gif' align='absmiddle'> 靓女</td></tr>"&_
	"<tr><td><b>密码(最少6位,最多16位)</b>：<br>请不要使用任何标点或HTML字符</td><td><input type='Password' name='Password'  maxlength='20' onblur='checkpassword(this.value)'> <span id='divpassword' style='color:#FF0000'></span></td> </tr>"&_
	"<tr><td><b>重复密码</b>：<br>请再输一遍确认</td><td><input type='password' name='RePassword' maxlength='20' onblur=checkrepassword(this.value)> <span id='divrepassword' style='color:#FF0000'></span></td></tr>"&_
	"<tr><td><b>密码问题</b>：<br>忘记密码的提示问题</td><td><input type='text' name='Clue' size=30  maxlength='60' onblur='checkClue(this.value)'> <span id='divClue' style='color:#FF0000'></span></td></tr>"&_
	"<tr><td><b>问题答案</b>：<br>忘记密码的提示问题答案，用于取回论坛密码</td><td><input type='text' name='Answer' size=30  maxlength='60' onblur='checkAnswer(this.value)'> <span id='divAnswer' style='color:#FF0000'></span></td></tr>"&_
	"<tr><td><b>Email地址</b>：<br>请输入有效的邮件地址</td><td><input type='text' name='Mail' size='30' maxlength='30'  onblur='checkemail(this.value)'> <span id='divemail' style='color:#FF0000'></span></td></tr>"&_
	"<tr><td height='25' bgcolor='#E8E8E8' colspan=3>&nbsp;&nbsp;<font color=blue>+=选填资料=+</font></td></tr><tr><td>"&_
	"<tr><td width='35%'><b>生日：</b><br>请把年月日全部填写</td><td width='65%'><input  Type=text name='BirthYear' size='4' maxlength='4' value='19'>年<input type=text name='BirthMonth' size='2' maxlength='2'>月<input type='text' name='Birthday' size='2' maxlength='2'>日</td></tr>"&_
	"<tr><td><b>主页：</b><br>填写你的个人主页促进大家展现自我</td><td><input type=text name='Home' size='30' maxlength='200'></td></tr>"&_
	"<tr><td><B>OICQ号码</B>：<BR>填写您的QQ地址，方便与他人的联系</td><td><input type='text' name='QQ'  maxlength='15'> <input type='checkbox' onclick='QQpic()' name='IsQQpic' value='1'>启用QQ形象作为头像</td></tr>"&_
	"<tr id=pic><td valign='top'><b>我的头像：</b><br>使用论坛自带的图像</td><td>" & HeadPic &"<img src='Images/UserHead/1.gif' name='Pic'>&nbsp;&nbsp;<input onclick=javascript:window.open('See.Asp?Action=HeadPic','open','width=680,height=300,resizable=1,top=150,left=80,scrollbars=yes,menubar=no,status=yes') type=button value='全部头像'></td></tr>"&_
	"<tr id=pic1><td><B>自定义头像</B>：<br> 如果图像位置中有连接图片将以自定义的为主</td><td><input name='PicUrl' size='40' maxlength='100'> 完整Url地址<br>图像宽度：<input type=text name='PicW' size='6' value='"& YxBBs.BBSSetting(16) &"'> 高度：<input type=text name='PicH' size='6' value='"&YxBBs.BBSSetting(17)&"'>(最大限度:"&YxBBs.BBSSetting(15)&")</td></tr>"&_
	"<tr><td valign='top'><B>个性签名</B>：<BR>最多255个字符<BR>  文字将出现在您发表的文章的结尾处<br>体现您的个性</td><td><TEXTAREA name='Sign' rows='4' style='PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px;WIDTH: 98%;'></textarea></td></tr>"&_
	"<tr><td colspan='2' height='30' align='center'><input type='submit' value='确定注册'>&nbsp;&nbsp; <input type=reset value='取消重写！'></td></tr></table></form>"
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Function HeadPicOpt()
	Dim Temp,i
	for i=2 to Int(YxBBs.BBSSetting(14))
		Temp=Temp&"<option value="&i&">"&i&"</option>"
	Next
	HeadPicOpt="<select name=headpic size=8 onChange='ShowPic()'><option value='1' selected>1</option>"&Temp&"</select>"
End Function
%>
<script>
function QQpic(){
if (document.form.IsQQpic.checked == true){
	pic.style.display="none";
	pic1.style.display="none";
	}else{
	pic.style.display="block";
	pic1.style.display="block";
	}}
function ShowPic(){
document.images.Pic.src="Images/UserHead/"+document.form.headpic.options[document.form.headpic.selectedIndex].value+".gif";
document.form.PicUrl.value="Images/UserHead/"+document.form.headpic.options[document.form.headpic.selectedIndex].value+".gif";
}
</script>