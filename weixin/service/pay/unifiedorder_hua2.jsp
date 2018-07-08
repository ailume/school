<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.app.ajax.hua2.Hua2WXPayAjax"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	/**
	作业列表ajax查询页
	code 页面状态 200 或者 404
	list 列表内容
	**/
	//清除缓存
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	//返回数据
	Hua2WXPayAjax wxp = new Hua2WXPayAjax(request, response);
%>
<%=wxp.unifiedOrder(user, wxp.getCleanParam("appId"), wxp.getCleanParam("openId"), wxp.getCleanParam("feeCode"), "绿蜻蜓-一卡通充值") .toString() %>