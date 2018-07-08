<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.entity.THomeworkAnsDetail"%>
<%@ page import="com.entity.THomework"%>
<%@ page import="com.util.PKUtils"%>
<%@ page import="com.entity.THomeworkAnswerMain"%>
<%@ page import="com.lineteam.common.LogUtil"%>
<%@ page import="com.lineteam.hibernate.DAO.DaoService"%>
<%@ page import="com.param.DBParam"%>
<%@ page import="com.lineteam.db.QueryUtil"%>
<%@ page import="com.lineteam.hibernate.DAO.IDaoService"%>
<%@ page import="com.lineteam.hibernate.DAO.Dao"%>
<%@ page import="com.lineteam.hibernate.DAO.IDao"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	//清除缓存
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	
	String info = "";//返回数据
	JSONObject outInfo = new JSONObject();
	outInfo.put("code", 404);
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	
	IDao dao = Dao.getInstance(false);
	IDaoService daoService = DaoService.getInstance();
	QueryUtil queryUtil = DBParam.getLqteduDB(false);
	try {
		String homeworkId = esapi.getCleanParam("id");
		String answerStr = esapi.getParam("answer");
		LogUtil.error("________________________answerStr = "+answerStr);
		String studentId = "T_STUDENT".equals(user.getUserType()) ? user.getUserId() : user.getStudentId();
		int count = queryUtil.executeCountQuery("SELECT count(*) FROM t_homework_answer_main WHERE WORK_ID=? and USER_ID=?", 
				new String[]{homeworkId, studentId});
		if(count > 0){
			outInfo.put("message", "请不要重复提交");
		}else{
			JSONObject answerInfo = JSONObject.fromObject(answerStr);
			if(answerInfo.getBoolean("submit")){
				daoService.beginTransaction();
				//保存答题主体信息
				THomeworkAnswerMain tm =  new THomeworkAnswerMain();
				tm.setId(PKUtils.getPKStr("T_HOMEWORK_ANSWER_MAIN"));
				tm.setUserId(studentId);
				tm.setWorkId(homeworkId);
				tm.setAdddate(new Date());
				//循环保存答题信息
				JSONArray dataList = answerInfo.getJSONArray("dataList");
				LogUtil.error("________________________dataList="+dataList.toString());
				//获取服务器密钥
				String accessToken = dataList.size() > 0 ? esapiPage.getWeixinAccessToken(user.getSchoolId(), param.getLqtWeixinAPPId()) : "";
				for(int i=0; i<dataList.size(); i++){
					JSONObject dataInfo = dataList.getJSONObject(i);
					String questionId = dataInfo.getString("id");
					String type = dataInfo.getString("type");
					String value = dataInfo.getString("value");
					THomeworkAnsDetail ta = new THomeworkAnsDetail();
					ta.setId(PKUtils.getPKStr("T_QUESTION_ANS"));
					ta.setQuestionId(questionId);
					ta.setType(type);
					ta.setOrderno(i);
					ta.setAnswer(value);
					if("1".equals(type)){
						//微信图片
						JSONObject downLoadInfo = esapiPage.weiXinDownload(request, accessToken, value, "IMG");
						if("".equals(downLoadInfo.getString("dbPath"))){
							outInfo.put("message", "提交失败，服务器保存图片出错~");
							out.print(outInfo.toString());
							return;
						}else {
							ta.setAnswer(downLoadInfo.getString("dbPath"));
						}
					}else if("2".equals(type)){
						//微信录音
						JSONObject downLoadInfo = esapiPage.weiXinDownload(request, accessToken, value, "VOICE");
						if("".equals(downLoadInfo.getString("dbPath"))){
							outInfo.put("message", "提交失败，服务器保存录音文件出错~");
							out.print(outInfo.toString());
							return;
						}else {
							ta.setAnswer(downLoadInfo.getString("dbPath"));
						}
					}
					ta.setMainId(tm.getId());
					dao.create(ta);
				}
				//更新题目回答信息
				THomework te = (THomework)dao.get(THomework.class, homeworkId);
				te.setFinalcount(te.getFinalcount()+1);
				dao.update(te);
				dao.create(tm);
				daoService.commitTransaction();
				outInfo.put("code", 200);
			}else {
				outInfo.put("message", "提交失败，还有题目没答~");
			}
		}
		/*
		Map answer =  (Map)JSON.parse(answerStr);
		int count = queryUtil.executeCountQuery("SELECT count(*) FROM t_homework_answer_main WHERE WORK_ID = ? and USER_ID = ?",new String[]{homeworkId,user.getUserId()}) ;
		if(count > 0){
			map.put("message", "请不要重复提交");
		}else{
			daoService.beginTransaction();
			THomeworkAnswerMain tm =  new THomeworkAnswerMain();
			tm.setId(PKUtils.getPKStr("T_HOMEWORK_ANSWER_MAIN"));
			tm.setUserId(user.getUserId());
			tm.setWorkId(homeworkId);
			tm.setAdddate(new Date());
			List list = HomeworkUtils.getQuestionListByHomeworkId(homeworkId);
			for(Object question:list){
				if("1".equals(BeanUtils.getPropertyStr(question, "QUESTYPE"))||"2".equals(BeanUtils.getPropertyStr(question, "QUESTYPE"))||"5".equals(BeanUtils.getPropertyStr(question, "QUESTYPE"))){
					THomeworkAnsDetail ta = new THomeworkAnsDetail();
					ta.setId(PKUtils.getPKStr("T_QUESTION_ANS"));
					ta.setQuestionId(BeanUtils.getPropertyStr(question, "ID"));
					ta.setAnswer((String)answer.get(BeanUtils.getPropertyStr(question, "ID")));
					ta.setMainId(tm.getId());
					dao.create(ta);
				}else{
					Map ansObj = (Map)answer.get(BeanUtils.getPropertyStr(question, "ID"));
					if(ansObj != null){
						THomeworkAnsDetail ta = new THomeworkAnsDetail();
						ta.setId(PKUtils.getPKStr("T_QUESTION_ANS"));
						ta.setQuestionId(BeanUtils.getPropertyStr(question, "ID"));
						ta.setAnswer((String)ansObj.get("content"));
						ta.setMainId(tm.getId());
						dao.create(ta);
					}
					
					String jsonArrStr = ansObj.get("file").toString();
					List<Map> maps = JSON.parseArray(jsonArrStr,Map.class);
					if(maps != null){
						for(int i=0;i<maps.size();i++){
							THomeworkAnsDetail ta = new THomeworkAnsDetail();
							ta.setId(PKUtils.getPKStr("T_QUESTION_ANS"));
							ta.setQuestionId(BeanUtils.getPropertyStr(question, "ID"));
							ta.setAnswer(maps.get(i).get("src").toString());
							ta.setType(maps.get(i).get("type").toString());
							ta.setOrderno(i);
							ta.setMainId(tm.getId());
							dao.create(ta);
						}
					}
				}
			}
			
			THomework te = (THomework)dao.get(THomework.class, homeworkId);
			te.setFinalcount(te.getFinalcount()+1);
			dao.update(te);
			dao.create(tm);
			daoService.commitTransaction();
			map.put("code", 200);
		}
		*/
	} catch (Exception e) {
		LogUtil.error("__________homeworkPost.jsp______________error="+e);
		outInfo.put("message", "提交失败，服务器保存答案出错~");
	}
	out.print(outInfo.toString());
%>