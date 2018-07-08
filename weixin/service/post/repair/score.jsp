<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.ajax.oa.RepairsAjax"%>
<%@ page import="com.lineteam.util.StringUtils"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	//清除缓存
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	//返回数据
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	/**
	code 页面状态 200 或者 404
	message 返回信息
	**/
	JSONObject json = new JSONObject();
	int code = 404;
	String message = "报修评分失败";
	try {
		String repairId = esapi.getCleanParam("repairId");
		String scoreStr = esapi.getCleanParam("score");
		if(!StringUtils.isBlank(repairId) && !StringUtils.isBlank(scoreStr)){
			RepairsAjax lqtRepair = new RepairsAjax();
			if(lqtRepair.score("WEIXIN", user.getSchoolId(), user.getUserId(), user.getUserType(), user.getStudentId(), repairId, scoreStr)){
				code = 200;
				message = "报修评分成功";
			}
		}else {
			message = "请传入正确的报修ID和评分";
		}
	} catch (Exception e) {
	}
	json.put("code", code);
	json.put("message", message);
%>
<%=json.toString() %>