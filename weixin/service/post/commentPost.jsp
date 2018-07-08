<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.hibernate.DAO.IDaoService"%>
<%@ page import="com.lineteam.hibernate.DAO.IDao"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="com.entity.TSpaceDiscuss"%>
<%@ page import="com.entity.TNotice"%>
<%@ page import="com.util.PKUtils"%>
<%@ page import="com.lineteam.hibernate.DAO.Dao"%>
<%@ page import="com.lineteam.hibernate.DAO.DaoService"%>
<%@ page import="net.sf.json.JSONObject"%>
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
	String message = "";
	IDao dao = Dao.getInstance(false);
	IDaoService daoService = DaoService.getInstance();
	try {
		String p_id = esapi.getCleanParam("noticeId");
		TNotice tn = (TNotice)dao.get(TNotice.class, p_id);
		if(tn != null && tn.getAllowrepley() == 1){
			TSpaceDiscuss tt = new TSpaceDiscuss();
			tt.setId(PKUtils.getPKStr("T_SPACE_DISCUSS"));
			tt.setObjectId(p_id);
			tt.setObjectName("T_NOTICE");
			tt.setStatus(1);
			tt.setPubDate(new Date());
			tt.setUserid(user.getUserId());
			tt.setUserType(user.getUserType());
			if(user.isParent()){
				tt.setParStuId(user.getStudentId());
			}
			String content = esapi.getParam("content");
			tt.setContent(content);
			daoService.beginTransaction();
			dao.create(tt);
			daoService.commitTransaction();
			code = 200;
		}else {
			code = 201;
			message = "当前通知不存在或不允许回复";
		}
	} catch (Exception e) {
		daoService.rollbackTransaction();
		
	}
	json.put("code", code);
	json.put("message", message);
%>
<%=json.toString() %>