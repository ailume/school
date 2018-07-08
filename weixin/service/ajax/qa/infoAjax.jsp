<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.app.ajax.weixin.examen.ExamenAjax"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="com.lineteam.security.IdEncodingUtil"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache"); 
	response.setDateHeader("Expires", 0);
	//返回数据
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	ExamenAjax voteAjax = new ExamenAjax();
	/**
	code 页面状态 200 204 或者 404
	info 报修详情
	message 返回信息
	**/
	JSONObject json = new JSONObject();
	Integer code = 200;
	String message = "问卷详情加载成功";
	String qId = esapi.getCleanParam("qid");
	//报修详情
	JSONObject info = voteAjax.getExamenJSON(user, IdEncodingUtil.decode(qId), true);
	if(info.isEmpty()){
		code = 404;
		message = "问卷详情加载失败";
	}
	json.put("message", message);
	json.put("code", code);
	json.put("info", info);
	
%>
<%=json.toString() %>