
<%@page import="com.app.bussiness.weixin.WeixinMsgUtils"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.lineteam.util.StringUtils"%>
<%@ page import="com.app.common.AppUser"%>
<%@ include file="/inc/begin.inc"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	String objectId = request.getParameter("objectId");
  	String objectName = request.getParameter("objectName");
  	String redirectURL = WeixinMsgUtils.getInstance().getMsgLocationURL(user, objectName, objectId);
  	if(!StringUtils.isBlank(objectId)){
  		response.sendRedirect(redirectURL);
	}else {
		response.sendRedirect("/weixin/error/notFound.html");
	}
%>
<%@ include file="/inc/end.inc"%>
