<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.app.ajax.weixin.SpaceAjax"%>
<%@ page import="com.lineteam.db.QueryUtil"%>
<%@ page import="com.lineteam.util.StringUtils"%>
<%@ page import="com.lineteam.util.BeanUtils"%>
<%@ page import="com.lineteam.common.LogUtil"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	//清除缓存
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	//返回数据
	SpaceAjax likePage = new SpaceAjax(request, response);
	String spaceId = likePage.getRawParam("spaceId");
	String topicId = likePage.getRawParam("topicId");
	JSONObject json = new JSONObject();
	int code = 404;
	String message = "";
	try {
		String objectId = likePage.getObjectId(spaceId);
		if(!StringUtils.isBlank(objectId)){
			String objectName = likePage.getObjectName(spaceId);
			QueryUtil query = QueryUtil.getInstance();
			Map spaceMap = query.firstRecord("select USERID from t_space_topic " 
				+ "where id=? and object_id=? and object_name=? and ifnull(lock_flag, 0)=0", new String[]{topicId, objectId, objectName});
			if(spaceMap != null && !spaceMap.isEmpty()){
				String topicUserId = BeanUtils.getPropertyStr(spaceMap, "USERID");
				List<String> sqls = new ArrayList<String>();
				List<String[]> args = new ArrayList<String[]>();
				int likeCount = query.executeCountQuery("select count(id) from t_action_log " 
						+ "where object_id=? and object_name='T_SPACE_TOPIC' and userid=?", new String[]{topicId, user.getUserId()});
				if(likeCount > 0){
					sqls.add("delete from t_action_log where object_id=? and object_name='T_SPACE_TOPIC' and userid=?");
					args.add(new String[]{topicId, user.getUserId()});
					sqls.add("update t_space_topic set zannum=zannum-1 where id=?");
					args.add(new String[]{topicId});
					message = "成功取消点赞";
				}else {
					sqls.add("insert into t_action_log(id, object_id, object_name, userid, user_type, optype, opdate, par_stu_id) " 
							+ "values(func_seq('SEQ_T_ACTION_LOG', 1), ?, 'T_SPACE_TOPIC', ?, ?, 1, now(), ?)");
					args.add(new String[]{topicId, user.getUserId(), user.getUserType(), user.getStudentId()});
					sqls.add("update t_space_topic set zannum=zannum+1 where id=?");
					args.add(new String[]{topicId});
					sqls.add("insert into T_SPACE_USER_NEWS(id, space_id, space_type, object_id, object_type, " 
							+ "user_id, user_type, stu_id, news_type, to_user_id, add_time) " 
							+ "values(func_seq('SEQ_T_SPACE_USER_NEWS', 1), ?, ?, ?, 'TOPIC', ?, ?, ?, 'LIKE', ?, now())");
					args.add(new String[]{objectId, objectName, topicId, user.getUserId(), user.getUserType(), user.getStudentId(), topicUserId});
					message = "点赞成功";
				}
				query.transactUpdate(sqls, args);
				code = 200;
			}else {
				message = "点赞出错，要赞的帖子不存在或已被锁定";
			}
		}
	} catch (Exception e) {
		message = "点赞出错";
		LogUtil.error("weixin空间帖子点赞出错！错误信息："+e);
	}
	json.put("code", code);
	json.put("message", message);
%>
<%=json.toString() %>