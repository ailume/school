<%@page import="com.lineteam.security.IdEncodingUtil"%>
<%@page import="com.app.bussiness.AppCommentUtils"%>
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
	String message = "提交留言/回复失败";
	try {
		String repairId = esapi.getCleanParam("repairId");
		String content = esapi.getCleanParam("content");
		String imgListStr = esapi.getParam("imgs");
		String toCommentId = esapi.getRawParam("toCommentId");
		toCommentId = StringUtils.isBlank(toCommentId) ? "" : IdEncodingUtil.decode(toCommentId);
		if(!StringUtils.isBlank(repairId) && (!StringUtils.isBlank(content) || !StringUtils.isBlank(imgListStr))){
			JSONArray imgArray = new JSONArray();
			if(!StringUtils.isBlank(imgListStr)){
				String[] imgList = imgListStr.split(",");
				//获取服务器密钥
				String accessToken = esapiPage.getWeixinAccessToken(user.getSchoolId(), param.getLqtWeixinAPPId());
				for(String mediaId : imgList){
					JSONObject downLoadInfo = esapiPage.weiXinTopicDownload(request, accessToken, mediaId, "IMG");
					if(downLoadInfo.getInt("byteSize") > 0){
						imgArray.add(downLoadInfo);
					}
				}
			}
			if(AppCommentUtils.addWeixinComment(user, content, imgArray, toCommentId, "T_REPAIRS", repairId)){
				code = 200;
				message = "留言/回复提交成功";
			}
		}else {
			message = "留言/回复信息不完整";
		}
	} catch (Exception e) {
	}
	json.put("code", code);
	json.put("message", message);
%>
<%=json.toString() %>