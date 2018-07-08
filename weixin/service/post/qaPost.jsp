<%@page import="com.lineteam.security.IdEncodingUtil"%>
<%@page import="com.lineteam.util.StringUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.ajax.oa.ExamenAjax"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	//清除缓存
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	//返回数据
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	JSONObject json = new JSONObject();
	int code = 404;
	String message = "提交投票失败";
	try{
		String examenId = esapi.getCleanParam("qid");
		examenId = IdEncodingUtil.decode(examenId);
		JSONArray questionInfo = JSONArray.fromObject(esapi.getParam("answer"));
		//[{"questionId":"123123123", "value":"1,2,4", "otherValue":""}]
		if(!StringUtils.isBlank(examenId) && questionInfo != null && !questionInfo.isEmpty()){
			ExamenAjax examenAjax = new ExamenAjax();
			JSONObject doSave = examenAjax.addExamenAnswer("WEIXIN", user.getSchoolId(), examenId, user.getUserId(), user.getUserType(), user.getStudentId(), questionInfo);
			if(doSave.getBoolean("status")){
				code = 200;
				message = "提交问卷成功";
			}else {
				message = doSave.getString("message");
			}
		}else {
			message = "问卷参数传递错误";
		}
	}catch(Exception e){
	}
	json.put("code", code);
	json.put("message", message);
%>
<%=json.toString() %>