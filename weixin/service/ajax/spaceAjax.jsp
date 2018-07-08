<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.lineteam.util.DateUtils"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.app.ajax.weixin.SpaceAjax"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="com.system.RedPointCache"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	RedPointCache redPoint = RedPointCache.getInstance();
	redPoint.search(user);
	/**
	空间列表ajax查询页
	code 页面状态 200 或者 404
	updateTime （下拉刷新时才有）
	list 列表内容
	**/
	//清除缓存
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	SpaceAjax spaceAjax = new SpaceAjax();
	//返回数据
	JSONObject json = new JSONObject();
	int code = 200;
	String message = "空间列表加载成功";
	JSONArray list = spaceAjax.getUserSpace(user);
	if(list == null){
		code = 404;
		message = "空间列表加载失败";
	}else if(list.isEmpty()){
		code = 204;
		message = "您还没有任何空间";
	}
	json.put("message", message);
	json.put("code", code);
	json.put("list", list);
	json.put("totalpage", 1);
%>
<%=json.toString() %>