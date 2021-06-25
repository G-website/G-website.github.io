<!-- #include File="Conn.Asp" -->
<!-- #include File="Public_Cls.Asp" -->
<!-- #include File="YX_Cls.Asp" -->
<%
Dim YxBBs,Cache
Set YxBBs = New Cls_Public
Set Cache = New Cls_Cache
YxBBs.SystemConfig()
YxBBs.CheckUser()
%>