<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.common.LogUtil"%>
<%@ page import="com.lineteam.util.StringUtils"%>
<%@ page import="com.app.ajax.weixin.SpaceAjax"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.lineteam.db.QueryUtil"%>
<%@ page import="com.lineteam.util.BeanUtils"%>
<%@ page import="com.util.PKUtils"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>

<%
	SpaceAjax commentPage = new SpaceAjax(request, response);
	String spaceId = commentPage.getCleanParam("SPACE_ID");
	String topicId = commentPage.getCleanParam("TOPIC_ID");
	String content = commentPage.getCleanParam("CONTENT");
	String commentId = commentPage.getCleanParam("COMMENT_ID");
	JSONObject json = new JSONObject();
	json.put("code", 404);
	json.put("message", "提交评论失败！");
	json.put("comment_id", "");
	json.put("content", content);
	try {
		String objectId = commentPage.getObjectId(spaceId);
		if(!StringUtils.isBlank(objectId)){
			String objectName = commentPage.getObjectName(spaceId);
			QueryUtil query = QueryUtil.getInstance();
			Map spaceMap = query.firstRecord("select USERID from t_space_topic " 
				+ "where id=? and object_id=? and object_name=? and ifnull(lock_flag, 0)=0", new String[]{topicId, objectId, objectName});
			if(spaceMap == null || spaceMap.isEmpty()){
				json.put("message", "提交评论出错，要评论的帖子不存在或已被锁定！");
				out.println(json.toString());
				return;
			}
			List<String> sqls = new ArrayList<String>();
			List<String[]> args = new ArrayList<String[]>();
			String topicUserId = BeanUtils.getPropertyStr(spaceMap, "USERID");
			String newCommentId = PKUtils.getPKStr("T_SPACE_DISCUSS");
			if(!StringUtils.isBlank(commentId)){
				Map commentMap = query.firstRecord("select USERID, PAR_STU_ID, USER_TYPE from t_space_discuss " 
						+ "where id=? and object_id=? and object_name='T_SPACE_TOPIC'", new String[]{commentId, topicId});
				if(commentMap == null || commentMap.isEmpty()){
					json.put("message", "提交评论出错，要评论的对象不存在！");
					out.println(json.toString());
					return;
				}
				String toUserId = BeanUtils.getPropertyStr(commentMap, "USERID");
				String toStuId = BeanUtils.getPropertyStr(commentMap, "PAR_STU_ID");
				String toUserType = BeanUtils.getPropertyStr(commentMap, "USER_TYPE");
				sqls.add("insert into t_space_discuss(id, object_name, object_id, content, " 
						+ "userid, pub_date, status, school_id, par_stu_id, user_type, pid, p_userid, p_user_type, p_par_stu_id) " 
						+ "values(?, 'T_SPACE_TOPIC', ?, ?, " 
						+ "?, now(), 1, ?, ?, ?, ?, ?, ?, ?)");
				args.add(new String[]{newCommentId, topicId, content, user.getUserId(), user.getSchoolId(), user.getStudentId(), user.getUserType(), 
						commentId, toUserId, toUserType, toStuId});
				//添加微信原评论人提醒
				sqls.add("insert into T_SPACE_USER_NEWS(id, space_id, space_type, object_id, object_type, " 
						+ "user_id, user_type, stu_id, news_type, to_user_id, add_time) " 
						+ "values(func_seq('SEQ_T_SPACE_USER_NEWS', 1), ?, ?, ?, 'TOPIC', ?, ?, ?, 'LIKE', ?, now())");
				args.add(new String[]{objectId, objectName, topicId, user.getUserId(), user.getUserType(), user.getStudentId(), toUserId});
			}else {
				sqls.add("insert into t_space_discuss(id, object_name, object_id, content, " 
						+ "userid, pub_date, status, school_id, par_stu_id, user_type) " 
						+ "values(func_seq('SEQ_T_SPACE_DISCUSS', 1), 'T_SPACE_TOPIC', ?, ?, " 
						+ "?, now(), 1, ?, ?, ?)");
				args.add(new String[]{topicId, content, user.getUserId(), user.getSchoolId(), user.getStudentId(), user.getUserType()});
			}
			//更新帖子回复数
			sqls.add("update T_SPACE_TOPIC set replynum=replynum+1 where id=?");
			args.add(new String[]{topicId});
			//更新空间帖子动态
			sqls.add("update T_COURSE_NEWS_FEED set action_type='2', create_date=now(), userid=?, user_type=? where tuid=? and tuname='T_SPACE_TOPIC'");
			args.add(new String[]{user.getUserId(), user.getUserType(), topicId});
			//添加微信发帖人提醒
			sqls.add("insert into T_SPACE_USER_NEWS(id, space_id, space_type, object_id, object_type, " 
					+ "user_id, user_type, stu_id, news_type, to_user_id, add_time) " 
					+ "values(func_seq('SEQ_T_SPACE_USER_NEWS', 1), ?, ?, ?, 'TOPIC', ?, ?, ?, 'LIKE', ?, now())");
			args.add(new String[]{objectId, objectName, topicId, user.getUserId(), user.getUserType(), user.getStudentId(), topicUserId});
			query.transactUpdate(sqls, args);
			json.put("code", 200);
			json.put("message", "评论提交成功！");
			json.put("comment_id", newCommentId);
		}
	} catch (Exception e) {
		LogUtil.error("weixin提交帖子评论出错，错误信息:"+e.getMessage(), e);
	}
	out.println(json.toString());
%>