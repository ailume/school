<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.app.AppParam"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.app.ajax.PageAjax"%>
<%@ page import="com.lineteam.common.LogUtil"%>
<%@ page import="com.lineteam.security.IdEncodingUtil"%>
<%@ page import="com.param.SessionParam"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	SessionParam param=new SessionParam(request);
	String APPURL = AppParam.APP_URL;
	PageAjax esapiPage = new PageAjax(request, response);
	String ROOTPath = esapiPage.getRootPath();
	String token = esapiPage.getCleanParam("token");
	AppUser user = esapiPage.weiXinLogin(token);
	if(null == user){
		response.sendRedirect(ROOTPath+"/weixin/error/sessionFail.html");
		return;
	}else {
		//用户登录成功的情况下，保存微信ID
		if("".equals(token)){
			token = param.getLqtWeixinId();
		}else {
			param.setLqtWeixinId(token);
		}
	}
	//AppUser user=new AppUser("111");
%>
<script>
var ROOTPath="<%=ROOTPath %>";
var APPURL="<%=APPURL %>";
</script>