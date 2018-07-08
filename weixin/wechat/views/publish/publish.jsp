<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.app.bussiness.AppNoticeUtils"%>
<%@ page import="com.app.ajax.ResultsAjax"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.lineteam.util.BeanUtils"%>
<%@ page import="com.lineteam.util.DateUtils"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.util.ValidateUtils"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	String spaceId = esapiPage.getRawParam("spaceid");
	JSONObject weixinConfig = esapiPage.getWeixinConfig(request, user.getSchoolId());
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>发布</title>
    <link href="../../public/css/publish/publish.css" rel="stylesheet" />
  </head>
  <body>
  	<div id="publish">
  		<p class="block textarea"><textarea id="content" placeholder="说点什么..."></textarea></p>
  		<div class="block">
  			<ul class="clearfix" id="preview-list">
  				<li class="it add"><p><a id="addpic" href="javascript:void(0)"></a></p></li>
  			</ul>
  		</div>
  		<p class="publish-btn"><a class="btn" id="button-close" href="javascript:void(0)">取消</a><a class="btn" id="button-confirm" href="javascript:void(0)">发送</a></p>
  	</div>
  	<script>
  		var g_config = {
  			pageType: 'publish',
  			SPACE_ID: "<%=spaceId %>",
  			wx: {
	  			appId: "<%=weixinConfig.getString("appId") %>", 
	  			timestamp: "<%=weixinConfig.getString("timestamp") %>", 
	  			nonceStr: "<%=weixinConfig.getString("nonceStr") %>", 
	  			signature: "<%=weixinConfig.getString("signature") %>", 
	  			pageUrl: "<%=weixinConfig.getString("pageUrl") %>", //传入的页面URL
	  			url: "<%=weixinConfig.getString("url") %>"			//返回的页面URL
  			}
  		};
  	</script>
	<script src="../../public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="../../public/js/config/lqt.js"></script>
	<script>seajs.use("../../public/js/publish/publish.js");</script>
  </body>
</html>