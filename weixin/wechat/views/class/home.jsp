<%@page import="com.lineteam.security.IdEncodingUtil"%>
<%@page import="com.lineteam.security.SecurityFields"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.app.ajax.weixin.SpaceAjax"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	String spaceId = esapiPage.getRawParam("spaceid");
	SpaceAjax spaceAjax = new SpaceAjax(request, response);
	String objectName = spaceAjax.getObjectName(spaceId);
	String pageTitle = "";
	if("T_CLASS_SPACE".equals(objectName)){
		pageTitle = "班级空间";
	}else if("T_SEL_COURSE".equals(objectName)){
		pageTitle = "课程空间";
	}else if("T_TEACH_SPACE".equals(objectName)){
		pageTitle = "教学空间";
	}else if("T_SPECIAL_SPACE".equals(objectName)){
		pageTitle = "专项空间";
	}
	
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title><%=pageTitle %></title>
    <link href="../../public/css/class/home.css" rel="stylesheet" />
  </head>
  <body>
	<a class="a-back" href="../school/home.html?type=zone">返回空间</a>
  	<div id="home">
  		<ul id="home-list">
  			<!-- list -->
  		</ul>
  		<div id="more"><div id="loading"><span class="scale-point active-1 scalePoint"></span><span class="scale-point active-2 scalePoint"></span><span class="scale-point active-3 scalePoint"></span><span class="pullTxt">努力加载中</span></div></div>
  	</div>
  	<span id="publish" data-href="../publish/publish.jsp"><em class="icon icon-publish"></em><span>发布</span></span>
  	<div id="comment-container">
		<div class="comment-main">
			<span class="tips">回复</span>
			<p class="textarea"><textarea id="commentcontent" placeholder="说点什么..."></textarea></p>
			<p><a class="btn button-close" id="button-close" href="javascript:void(0)">取消</a><a class="btn button-confirm" id="button-confirm" href="javascript:void(0)">发送</a></p>
		</div>
	</div>
  	<div id="slide">
  		
  	</div>
  	<script>
  		var g_config = {
  			pageType: 'home',
  			SPACE_ID: "<%=spaceId %>",
  			userinfo: {
  				USER_ID: '<%=user.getUserId() %>',
				USER_ICON: '<%=user.getIcon() %>',
				USER_NAME: '<%=user.getName() %>'
  			}
  		};
  	</script>
	<script src="../../public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="../../public/js/config/lqt.js"></script>
	<script>seajs.use("../../public/js/class/home.js");</script>
  </body>
</html>