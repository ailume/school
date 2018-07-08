<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.app.ajax.weixin.NoticeAjax"%>
<%@ page import="com.lineteam.util.NumberUtil"%>
<%@ page import="com.lineteam.util.PaginationUtils"%>
<%@ page import="com.system.RedPointCache"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	RedPointCache redPoint = RedPointCache.getInstance();
	redPoint.search(user);
	/**
	通知列表ajax查询页
	code 页面状态 200 或者 404
	list 列表内容
	**/
	//清除缓存
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	//返回数据
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	NoticeAjax notice = new NoticeAjax();
	JSONObject json = new JSONObject();
	int code = 200;
	String message = "通知列表加载成功";
	//每页显示数量
	int pageSize = 20;
	//通知总数
	int noticeCount = notice.getNoticeCount(user);
	//当前请求页
	int curPageStr = NumberUtil.toInt(esapi.getCleanParam("page"));		//微信端第一页=1
	curPageStr = curPageStr > 0 ? (curPageStr - 1) : 0;
	int curPage = PaginationUtils.getCurPage(curPageStr, noticeCount, pageSize);	//当前查询页
	JSONArray list = notice.getNoticeList(user, curPage, pageSize);
	if(list == null){
		message = "通知列表加载失败";
		code = 404;
	}else if(list.isEmpty()){
		message = "还没有关于您的通知";
	}
	json.put("message", message);
	json.put("code", code);
	json.put("list", list);
	//总页数
	int pageCount = noticeCount / pageSize + (noticeCount % pageSize > 0 ? 1 : 0);
	json.put("totalpage", pageCount);
%>
<%=json.toString() %>