<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.app.bussiness.AppCommentUtils"%>
<%@page import="java.util.Date"%>
<%@page import="com.lineteam.util.DateUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.app.bussiness.AppNoticeUtils"%>
<%@page import="com.app.common.AppUser"%>
<%@page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	//清除缓存
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	int code = 200;
	String message = "通知评论加载成功";
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	String initTime = esapi.getCleanParam("initTime");
	int pageNum = Integer.parseInt(esapi.getCleanParam("pageNum"));
	List noticeList = AppCommentUtils.getCommetByPage(esapi.getCleanParam("noticeId"), "T_NOTICE", initTime, pageNum, 20);
	if(noticeList == null){
		code = 404;
		message = "通知评论加载失败";
	}else if(noticeList.isEmpty()){
		message = "该通知还没有人评论";
	}
	JSONObject json = new JSONObject();
	json.put("message", message);
	json.put("list", noticeList);
	json.put("code", code);
	json.put("rootPath",ROOTPath);
%>
<%=json.toString() %>