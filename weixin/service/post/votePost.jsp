<%@page import="com.lineteam.util.StringUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.ajax.oa.VoteAjax"%>
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
		String voteId = esapi.getCleanParam("voteId");
		JSONArray voteInfo = JSONArray.fromObject(esapi.getParam("answer"));
		//[{"subjectId":"123123123", "values":"1,2,4"},{"subjectId":"213123123", "values":"1,3,4"}]
		if(!StringUtils.isBlank(voteId) && voteInfo != null && !voteInfo.isEmpty()){
			VoteAjax voteAjax = new VoteAjax();
			JSONObject doSave = voteAjax.addVoteAnser(voteId, user.getUserId(), user.getUserType(), user.getStudentId(), "WEIXIN", voteInfo);
			if(doSave.getBoolean("status")){
				code = 200;
				message = "提交投票成功";
			}else {
				message = doSave.getString("message");
			}
		}else {
			message = "投票参数传递错误";
		}
	}catch(Exception e){
	}
	json.put("code", code);
	json.put("message", message);
%>
<%=json.toString() %>