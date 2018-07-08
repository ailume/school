<%@page import="com.lineteam.util.PaginationUtils"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.lineteam.util.NumberUtil"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.app.ajax.weixin.repair.RepairAjax"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="com.system.RedPointCache"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache"); 
	response.setDateHeader("Expires", 0);
	//返回数据
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	RepairAjax repairAjax = new RepairAjax();
	/**
	code 页面状态 200 204 或者 404
	info 报修详情
	message 返回信息
	**/
	JSONObject json = new JSONObject();
	Integer code = 200;
	JSONArray list=new JSONArray();
	String message = "报修详情加载成功";
	String repairId = esapi.getCleanParam("repairId");
	String listType = esapi.getCleanParam("listType");
	//报修详情
	JSONObject info = repairAjax.getRepairJSON(user, repairId, listType, ROOTPath);
	if(info.isEmpty()){
		code = 404;
		message = "报修详情加载失败";
	}else {
		//报修留言回复
		json.put("comments", new JSONArray());
		List commentList = repairAjax.getRepairComments(user, repairId, ROOTPath);
		if(commentList == null){
			code = 404;
			message = "留言/回复详情加载失败";
		}else if(commentList.isEmpty()){
			message = "没有相关的留言/回复";
		}else {
			json.put("comments", JSONArray.fromObject(commentList));
		}
	}
	json.put("message", message);
	json.put("code", code);
	json.put("info", info);
	
%>
<%=json.toString() %>