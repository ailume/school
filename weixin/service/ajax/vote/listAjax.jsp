<%@page import="com.lineteam.util.BeanUtils"%>
<%@page import="com.lineteam.security.IdEncodingUtil"%>
<%@page import="com.param.DBParam"%>
<%@page import="com.lineteam.db.QueryUtil"%>
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
	String message = "投票列表加载成功";
	Integer totalpage = 0;
	Integer pageSize = 20;												//每页显示数量
	String status = esapi.getCleanParam("status");						//指定的报修状态
	String listType = esapi.getCleanParam("listType");					//指定的查询列表类型 1=报修处理列表, 其他=报修列表
	Integer curPage = NumberUtil.toInt(esapi.getCleanParam("page"));	//当前请求页 微信端第一页=1
	curPage = curPage > 0 ? (curPage - 1) : 0;
	//查询
	QueryUtil query = DBParam.getLqteduDB();
	String studentId = "";
	String parentSql = "";
	String ansFlagStr = "teu.user_id='"+user.getUserId()+"'";
	if("T_PARENT".equals(user.getUserType())){
		studentId = user.getStudentId();
		parentSql = "and s.stu_id='"+studentId+"' ";
		ansFlagStr = "teu.stu_id='"+studentId+"' "; 
	}
	JSONArray list=new JSONArray();			//报修数据
	try{
		//报修记录总数
		Integer dataCount = query.executeCountQuery("SELECT count(t.id) FROM (" 
				+ "select tv.id from t_sys_notice_see s inner join t_vote_main tv " 
				+ "on s.notice_type=? and s.object_id=tv.id " 
				+ "where s.school_id=? and s.USER_ID=? "+parentSql+" and tv.PUBLISH_DATE<NOW() "
				+ "and (tv.out_date>now() or s.status=1) "	//过滤已过期未填写投票
			+ ") t " 
			+ "LEFT JOIN t_common_activity_partake teu ON (teu.OBJECT_ID=t.ID AND teu.OBJECT_NAME='T_VOTE_MAIN' and "+ansFlagStr+") " 
			//人员不在职的情况下，只显示已读通知 
			+ "WHERE ("+ansFlagStr+" or '1'=?)", 
			new String[]{RedPointCache.TYPECODE_VOIT, user.getSchoolId(), user.getUserId(), user.getStatus()});
		if(dataCount == -1){
			code = 404;
			message = "投票列表加载失败，投票总数查询失败";
		}else if(dataCount == 0){
			code = 200;
			message = "无投票记录";
		}else {
			curPage = PaginationUtils.getCurPage(curPage, dataCount, pageSize);
			totalpage = dataCount / pageSize + (dataCount % pageSize > 0 ? 1 : 0);
			//数据信息
			List dataList = query.executeQuery("SELECT t.ID, t.TITLE, date_format(t.OUT_DATE, '%m-%d') OUTDATE, td.`NAME` DEPTNAME, "
					+ "if(t.IS_ANONYM='1', '1', '0') ANONYM_FLAG, " 
					+ "IF(t.OUT_DATE>NOW(), '0', '1') OVER_FLAG, " 
					+ "IF(teu.ID is not null, '1', '0') ANSWER_FLAG " 
					+ "FROM (" 
						+ "select tv.* from t_sys_notice_see s inner join t_vote_main tv " 
						+ "on s.notice_type=? and s.object_id=tv.id " 
						+ "where s.school_id=? and s.USER_ID=? "+parentSql+" and tv.PUBLISH_DATE<NOW() " 
						+ "and (tv.out_date>now() or s.status=1) "	//过滤已过期未填写投票
					+ ") t " 
					//+ "JOIN t_user tu ON (tu.id = t.USERID) " 
					+ "JOIN t_departments td ON (td.CODE= t.DEPT_CODE AND td.SCHOOL_ID=t.school_id) "
					+ "LEFT JOIN t_common_activity_partake teu ON (teu.OBJECT_ID=t.ID AND teu.OBJECT_NAME='T_VOTE_MAIN' and "+ansFlagStr+") " 
					//人员不在职的情况下，只显示已读通知
					+ "WHERE ("+ansFlagStr+" or '1'=?) "
					+ "ORDER BY t.OUT_DATE DESC", 
					new String[]{RedPointCache.TYPECODE_VOIT, user.getSchoolId(), user.getUserId(), user.getStatus()}, curPage*pageSize, pageSize);
			list = JSONArray.fromObject(dataList);
			for(int i=0; i<list.size(); i++){
				JSONObject info = list.getJSONObject(i);
				info.put("ID", IdEncodingUtil.encode(info.getString("ID")));
			}
		}
	}catch(Exception e){
		code = 404;
		message = "投票列表查询失败";
	}
	json.put("message", message);
	json.put("code", code);
	json.put("list", list);
	json.put("totalpage", totalpage);
%>
<%=json.toString() %>