function killerrors()
{
return true
}
window.onerror = killerrors

tPopWait=50;
tPopShow=5000;
showPopStep=20;
popOpacity=99;
fontcolor=c3;
bgcolor=c2;
bordercolor=c1;
sPop=null;curShow=null;tFadeOut=null;tFadeIn=null;tFadeWaiting=null;
document.write("<style type='text/css' id='defaultPopStyle'>");
document.write(".cPopText {  background-color: " + bgcolor + ";color:" + fontcolor + "; border: 1px " + bordercolor + " solid;font-color: font-size: 12px; padding-right: 4px; padding-left: 4px; height: 20px; padding-top: 2px; padding-bottom: 2px; filter: Alpha(Opacity=0)}");
document.write(".tab a{DISPLAY: block; WHITE-SPACE: nowrap; margin-bottom:1; background-repeat:repeat; background-attachment:scroll;margin-top: 1;margin-left: 2;padding-left:25px; padding-right:20px;}");
document.write(".tab a:hover {color:"+c5+";border:1px solid "+c2+"; DISPLAY: block; MARGIN: 0px; background-repeat:repeat; background-attachment:scroll; background-color:"+c4+"}");
document.write("</style>");
document.write("<body leftmargin='0' topmargin='0' onmouseover='HideMenu()'>");
document.write("<div id='dypopLayer' style='position:absolute;z-index:1000;' class='cPopText'></div><DIV id=menuDiv style='Z-INDEX: 2; VISIBILITY: hidden;  POSITION: absolute;'></DIV>");

function showPopupText()
{
  var o=event.srcElement;MouseX=event.x;MouseY=event.y;
  if(o.alt!=null && o.alt!=""){o.dypop=o.alt;o.alt=""};
    if(o.title!=null && o.title!=""){o.dypop=o.title;o.title=""};
  if(o.dypop!=sPop)
  {
    sPop=o.dypop;clearTimeout(curShow);clearTimeout(tFadeOut);clearTimeout(tFadeIn);clearTimeout(tFadeWaiting);  
    if(sPop==null || sPop=="")
    {
      dypopLayer.innerHTML="";dypopLayer.style.filter="Alpha()";dypopLayer.filters.Alpha.opacity=0;  
    }
    else
    {
      if(o.dyclass!=null) popStyle=o.dyclass 
      else popStyle="cPopText";
        curShow=setTimeout("showIt()",tPopWait);
    }
  }
}

function showIt()
{
  dypopLayer.className=popStyle;dypopLayer.innerHTML=sPop;
  popWidth=dypopLayer.clientWidth;popHeight=dypopLayer.clientHeight;
  if(MouseX+12+popWidth>document.body.clientWidth) popLeftAdjust=-popWidth-24
  else popLeftAdjust=0;
  if(MouseY+12+popHeight>document.body.clientHeight) popTopAdjust=-popHeight-24
  else popTopAdjust=0;
  dypopLayer.style.left=MouseX+12+document.body.scrollLeft+popLeftAdjust;
  dypopLayer.style.top=MouseY+12+document.body.scrollTop+popTopAdjust;
  dypopLayer.style.filter="Alpha(Opacity=0)";fadeOut();
}

function fadeOut()
{
  if(dypopLayer.filters.Alpha.opacity<popOpacity)
  { dypopLayer.filters.Alpha.opacity+=showPopStep;tFadeOut=setTimeout("fadeOut()",1); }
  else
  { dypopLayer.filters.Alpha.opacity=popOpacity;tFadeWaiting=setTimeout("fadeIn()",tPopShow); }
}

function fadeIn()
{
  if(dypopLayer.filters.Alpha.opacity>0)
  { dypopLayer.filters.Alpha.opacity-=1;tFadeIn=setTimeout("fadeIn()",1); }
}
document.onmouseover=showPopupText;

var menuOffX=0
var menuOffY=20
var ie4=document.all&&navigator.userAgent.indexOf("Opera")==-1
var ns6=document.getElementById&&!document.all
function showmenu(e,vmenu,mod){
	which=vmenu
	menuobj=document.getElementById("popmenu")
	menuobj.thestyle=menuobj.style
	menuobj.innerHTML=which
	menuobj.contentwidth=menuobj.offsetWidth
	eventX=e.clientX
	eventY=e.clientY
	var rightedge=document.body.clientWidth-eventX
	var bottomedge=document.body.clientHeight-eventY

		if (rightedge<menuobj.contentwidth)
			menuobj.thestyle.left=document.body.scrollLeft+eventX-menuobj.contentwidth+menuOffX
		else
			menuobj.thestyle.left=ie4? ie_x(event.srcElement)+menuOffX : ns6? window.pageXOffset+eventX : eventX
		
		if (bottomedge<menuobj.contentheight&&mod!=0)
			menuobj.thestyle.top=document.body.scrollTop+eventY-menuobj.contentheight-event.offsetY+menuOffY-23
		else
			menuobj.thestyle.top=ie4? ie_y(event.srcElement)+menuOffY : ns6? window.pageYOffset+eventY+10 : eventY

	menuobj.thestyle.visibility="visible"
}

function ie_y(e){  
	var t=e.offsetTop;  
	while(e=e.offsetParent){  
		t+=e.offsetTop;  
	}  
	return t;  
}

function ie_x(e){  
	var l=e.offsetLeft;  
	while(e=e.offsetParent){  
		l+=e.offsetLeft;  
	}  
	return l;  
}

function highlightmenu(e,state){
	if (document.all)
		source_el=event.srcElement
		while(source_el.id!="popmenu"){
			source_el=document.getElementById? source_el.parentNode : source_el.parentElement
			if (source_el.className=="menuitems"){
				source_el.id=(state=="on")? "mouseoverstyle" : ""
		}
	}
}


function hidemenu(){if (window.menuobj)menuobj.thestyle.visibility="hidden"}
function dynamichide(e){if ((ie4||ns6)&&!menuobj.contains(e.toElement))hidemenu()}
document.onclick=hidemenu
document.write("<div class=menuskin id=popmenu onmouseover=highlightmenu(event,'on') onmouseout=highlightmenu(event,'off');dynamichide(event)></div>")


function ShowOnline()
{
	if (Showtxt.innerText!="关闭详细列表")
	{
		Showtxt.innerText="关闭详细列表";
		showon.innerHTML='<div style="margin-top:8; margin-bottom:8;width:240px;margin-left:18px;border:1px solid black;background-color:lightyellow;color:black;padding:2px" onClick="ShowOnline();">正在读取在线信息，请稍侯……</div>';
	}
	else
	{
		Showtxt.innerText='显示详细列表';
	}
}
function bbimg(o){
	var zoom=parseInt(o.style.zoom, 10)||100;zoom+=event.wheelDelta/12;if (zoom>0) o.style.zoom=zoom+'%';
	return false;
}
function ValidateTextboxAdd(box, button)
{
	var buttonCtrl = document.getElementById( button );
	if ( buttonCtrl != null )
	{
		if (box.value == "" || box.value == box.helptext)
		{
			buttonCtrl.disabled = true;
		}
		else
		{
			buttonCtrl.disabled = false;
		}
	}
}

function showtb(tbnum){whichEl = eval("tbtype" + tbnum);if (whichEl.style.display == "none"){eval("tbtype" + tbnum + ".style.display=\"\";");}else{eval("tbtype" + tbnum + ".style.display=\"none\";");}}