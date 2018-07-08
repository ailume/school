<%@page import="com.lineteam.util.PaginationUtils"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.lineteam.util.NumberUtil"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.app.ajax.weixin.vote.VoteAjax"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="com.system.RedPointCache"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache"); 
	response.setDateHeader("Expires", 0);
	//返回数据
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	VoteAjax voteAjax = new VoteAjax();
	/**
	code 页面状态 200 204 或者 404
	info 报修详情
	message 返回信息
	**/
	JSONObject json = new JSONObject();
	Integer code = 200;
	String message = "投票详情加载成功";
	String voteId = esapi.getCleanParam("voteId");
	//报修详情
	JSONObject info = voteAjax.getVoteJSON(user, voteId, true);
	if(info.isEmpty()){
		code = 404;
		message = "投票详情加载失败";
	}
	json.put("rootPath", ROOTPath);
	json.put("message", message);
	json.put("code", code);
	json.put("info", info);
	
%>
<%=json.toString() %>