<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.app.bussiness.AppNoticeUtils"%>
<%@ page import="com.app.ajax.ResultsAjax"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.lineteam.util.BeanUtils"%>
<%@ page import="com.lineteam.util.DateUtils"%>
<%@ page import="com.util.ValidateUtils"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>首页</title>
    <link href="<%=ROOTPath %>/weixin/public/css/school/home.css" rel="stylesheet" />
  </head>
  <body>
	<nav id="nav">
		<ul class="clearfix"><!-- tab数2个：num-2 -->
			<li class="it" data-type="zone" data-page="1"><a href="javascript:void(0)">空间</a></li>
			<li class="it" data-type="notice" data-page="1"><a href="javascript:void(0)">通知</a></li>
			<li class="it"><a href="../profile/profile.jsp">我的<em class="icon"></em></a></li>
			<li id="border"></li>
		</ul>
	</nav>
  	<div id="home">
  		<ul class="lqt-list" id="zone">
  			<!-- 空间 -->
  		</ul>
		<ul class="lqt-list" id="notice">
			<!-- 通知 -->
		</ul>
		<div id="more"><div id="loading"><span class="scale-point active-1 scalePoint"></span><span class="scale-point active-2 scalePoint"></span><span class="scale-point active-3 scalePoint"></span><span class="pullTxt">正在加载中</span></div></div>
  	</div>
  	<script>
  		var g_config = {
  			jsBasePath: ROOTPath+"/weixin/public/js/",
  			pageType: "home",
  			isstudent: <%if(!"T_TEACHER".equals(user.getUserType())){%>1<%}else{ %>0<%}%>
  		};
  	</script>
	<script src="<%=ROOTPath %>/weixin/public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="<%=ROOTPath %>/weixin/public/js/config/lqt.js"></script>
	<script>seajs.use("<%=ROOTPath %>/weixin/public/js/school/index.js");</script>
  </body>
</html>