<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.app.ajax.ResultsAjax"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.lineteam.util.BeanUtils"%>
<%@ page import="com.lineteam.util.DateUtils"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.lineteam.util.PaginationUtils"%>
<%@ page import="com.lineteam.util.NumberUtil"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	//清除缓存
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	//返回数据
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	ResultsAjax results = new ResultsAjax(request, response);
	JSONObject json = new JSONObject();
	int code = 200;
	String message = "成绩列表加载成功";
	//每页显示数量
	int pageSize = 20;
	//作业总数
	int resultsCount = results.getMyExamCount(user);
	//当前请求页
	int curPageStr = NumberUtil.toInt(esapi.getCleanParam("page"));		//微信端第一页=1
	curPageStr = curPageStr > 0 ? (curPageStr - 1) : 0;
	int curPage = PaginationUtils.getCurPage(curPageStr, resultsCount, pageSize);	//当前查询页
	JSONArray list = results.getMyExamList(user, curPage, pageSize);
	if(list == null){
		message = "成绩列表加载失败";
		code = 404;
	}else if(list.isEmpty()){
		message = "还没有您的相关成绩";
	}
	json.put("message", message);
	json.put("code", code);
	json.put("list", list);
	int pageCount = resultsCount / pageSize + (resultsCount % pageSize > 0 ? 1 : 0);
	pageCount = pageCount <= 0 ? 1 : pageCount;
	json.put("totalpage", pageCount);
%>
<%=json.toString() %>