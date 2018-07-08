<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.lineteam.util.DateUtils"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.app.ajax.weixin.SpaceAjax"%>
<%@ page import="com.lineteam.util.NumberUtil"%>
<%@ page import="com.lineteam.util.PaginationUtils"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
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
	String spaceId = esapi.getRawParam("spaceId");
	SpaceAjax spaceAjax = new SpaceAjax(request, response);
	//返回数据
	JSONObject json = new JSONObject();
	int code = 200;
	String message = "帖子列表加载成功";
	//每页显示数量
	int pageSize = 20;
	//通知总数
	int noticeCount = spaceAjax.getSpaceTopicCount(user, spaceId);
	//当前请求页
	int curPageStr = NumberUtil.toInt(esapi.getCleanParam("page"));					//微信端第一页=1
	curPageStr = curPageStr > 0 ? (curPageStr - 1) : 0;
	int curPage = PaginationUtils.getCurPage(curPageStr, noticeCount, pageSize);	//当前查询页
	JSONArray list = spaceAjax.getSpaceTopic(user, spaceId, curPage, pageSize);
	if(list == null){
		code = 404;
		message = "帖子列表加载失败";
	}else if(list.isEmpty()){
		message = "该空间没有发表过任何帖子";
	}
	json.put("code", code);		
	json.put("message", message);				
	json.put("list", list);					//帖子列表
	int pageCount = noticeCount / pageSize + (noticeCount % pageSize > 0 ? 1 : 0);
	json.put("totalpage", pageCount);		//帖子总页数
	JSONArray news = spaceAjax.getSpaceNews(user, spaceId);
	json.put("news", news);					//新消息列表
	//纪录空间最后访问时间
	spaceAjax.addUserSpaceLog(user, spaceId);
%>
<%=json.toString() %>