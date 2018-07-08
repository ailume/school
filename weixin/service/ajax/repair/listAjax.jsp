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
	list 列表内容
	message 返回信息
	totalpage 总页数
	**/
	JSONObject json = new JSONObject();
	Integer code = 200;
	String message = "报修列表加载成功";
	Integer totalpage = 0;
	Integer pageSize = 20;												//每页显示数量
	String status = esapi.getCleanParam("status");						//指定的报修状态
	String listType = esapi.getCleanParam("listType");					//指定的查询列表类型 1=报修处理列表, 其他=报修列表
	Integer curPage = NumberUtil.toInt(esapi.getCleanParam("page"));	//当前请求页 微信端第一页=1
	curPage = curPage > 0 ? (curPage - 1) : 0;
	//查询
	JSONArray list=new JSONArray();			//报修数据
	Integer dataCount = 0;					//报修记录总数
	if("2".equals(listType)){
		dataCount = repairAjax.getDEPTListCount(user, status);
	}else {
		dataCount = repairAjax.getMyListCount(user, status);
	}
	if(dataCount == -1){
		code = 404;
		message = "报修列表加载失败，报修总数查询失败";
	}else if(dataCount == 0){
		code = 200;
		message = "无报修记录";
	}else {
		curPage = PaginationUtils.getCurPage(curPage, dataCount, pageSize);
		totalpage = dataCount / pageSize + (dataCount % pageSize > 0 ? 1 : 0);
		if("2".equals(listType)){
			list = repairAjax.getDEPTList(user, status, pageSize, curPage);
		}else {
			list = repairAjax.getMyList(user, status, pageSize, curPage);
		}
		if(list == null){
			code = 404;
			message = "报修列表查询失败";
		}
	}
	json.put("message", message);
	json.put("code", code);
	json.put("list", list);
	json.put("totalpage", totalpage);
%>
<%=json.toString() %>