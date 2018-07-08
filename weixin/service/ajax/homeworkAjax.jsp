<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.app.ajax.weixin.HomeWorkAjax"%>
<%@ page import="com.lineteam.util.NumberUtil"%>
<%@ page import="com.lineteam.util.PaginationUtils"%>
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
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	HomeWorkAjax homeWork = new HomeWorkAjax();
	JSONObject json = new JSONObject();
	int code = 200;
	String message = "作业列表加载成功";
	//每页显示数量
	int pageSize = 20;
	//作业总数
	int homeworkCount = homeWork.getHomeWorkCount(user);
	//当前请求页
	int curPageStr = NumberUtil.toInt(esapi.getCleanParam("page"));		//微信端第一页=1
	curPageStr = curPageStr > 0 ? (curPageStr - 1) : 0;
	int curPage = PaginationUtils.getCurPage(curPageStr, homeworkCount, pageSize);	//当前查询页
	JSONArray list = homeWork.getHomeWorkList(user, curPage, pageSize);
	if(list == null){
		message = "作业列表加载失败";
		code = 404;
	}else if(list.isEmpty()){
		message = "还没有您的相关作业";
	}
	json.put("message", message);
	json.put("code", code);
	json.put("list", list);
	int pageCount = homeworkCount / pageSize + (homeworkCount % pageSize > 0 ? 1 : 0);
	pageCount = pageCount <= 0 ? 1 : pageCount;
	json.put("totalpage", pageCount);
%>
<%=json.toString() %>