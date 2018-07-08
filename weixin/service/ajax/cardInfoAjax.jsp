<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.app.ajax.weixin.CardAjax"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="com.system.RedPointCache"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	RedPointCache redPoint = RedPointCache.getInstance();
	redPoint.search(user);
	/**
	查询学生一卡通卡片详情页
	code 页面状态 200 或者 404
	updateTime （下拉刷新时才有）
	list 列表内容
	**/
	//清除缓存
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	CardAjax spaceAjax = new CardAjax();
%>
<%=spaceAjax.getCardInfo(user).toString() %>