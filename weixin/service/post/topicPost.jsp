<%@page import="com.lineteam.hibernate.DAO.Search"%>
<%@page import="com.lineteam.hibernate.DAO.ISearch"%>
<%@page import="com.lineteam.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.hibernate.DAO.DaoService"%>
<%@ page import="com.lineteam.hibernate.DAO.Dao"%>
<%@ page import="com.lineteam.hibernate.DAO.IDaoService"%>
<%@ page import="com.lineteam.hibernate.DAO.IDao"%>
<%@ page import="com.app.ajax.weixin.SpaceAjax"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.entity.TSpaceHis"%>
<%@ page import="com.validata.classesspace.TSpaceTopicValidata"%>
<%@ page import="com.entity.TSpaceTopic"%>
<%@ page import="com.entity.TCourseNewsFeed"%>
<%@ page import="com.util.PKUtils"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.lineteam.common.LogUtil"%>
<%@ page import="com.entity.TPicQueue"%>
<%@ page import="com.entity.TSpacePic"%>
<%@ page import="com.upload.FileToolkit"%>
<%@ page import="java.io.File"%>
<%@ page import="com.lineteam.common.Params"%>
<%@ page import="com.upload.ImageUtils"%>
<%@ page import="com.lineteam.util.DateUtils"%>
<%@ include file="/weixin/common/checkLoginAjax.jsp" %>
<%
	SpaceAjax ajax=new SpaceAjax(request, response);
	String spaceId=ajax.getCleanParam("SPACE_ID");
	String content=ajax.getCleanParam("CONTENT");
	String imgListStr=ajax.getParam("IMG_LIST");
	//LogUtil.error("00000000000000000000000          00000000000000000000000          imgListStr="+imgListStr);
	String title=content;
	if(content.length()>18){
		title=content.substring(0,18)+"…";
	}
	JSONObject json=new JSONObject();
	String code="404";
	String message="发布帖子操作失败！";
	
	IDao dao = Dao.getInstance(false);
	IDaoService daoService=DaoService.getInstance();
	TCourseNewsFeed tcnf = new TCourseNewsFeed();
	try {
		String[] imgList = null;
		if(!StringUtils.isBlank(imgListStr)){
			imgList = imgListStr.split(",");
		}
		String topicId=PKUtils.getPKStr("T_SPACE_TOPIC");		//T_SPACE_TOPIC topic
		TSpaceTopic tt = new TSpaceTopic();
		String objId=ajax.getObjectId(spaceId);
		String objName=ajax.getObjectName(spaceId);
		tt.setObjectId(objId);
		tt.setObjectName(objName);
		tt.setId(topicId);
		tt.setUserid(user.getUserId());
		tt.setPubDate( new Date());
		tt.setReplynum(0);
		tt.setStatus(1);
		tt.setTopFlag(0);
		tt.setLockFlag(0);
		tt.setZannum(0);
		tt.setUserType(user.getUserType());
		tt.setContent(content);
		tt.setTitle(title);
		tt.setIsNew(1);
		if(user.isParent()){
			tt.setParStuId(user.getStudentId());
		}
		tt.setSchoolId(user.getSchoolId());
		TSpaceTopicValidata.validateFormInfo(tt);
		tcnf.setActionType("1");
		tcnf.setCreateDate( new Date());
		tcnf.setUserid(user.getUserId());
		tcnf.setUserType(user.getUserType());
		tcnf.setId(PKUtils.getPKStr("T_COURSE_NEWS_FEED"));
		tcnf.setCourseId(tt.getObjectId());
		tcnf.setTuid(topicId);
		tcnf.setTuname("T_SPACE_TOPIC");
		TSpaceTopicValidata.validateFormInfo(tt);
		daoService.beginTransaction();
		dao.create(tt);//T_SPACE_TOPIC
		
		List<TSpaceHis> list=(List<TSpaceHis>)dao.findByProperty(TSpaceHis.class, new String[]{"objectId", "objectName"},  new String[]{tt.getObjectId(), tt.getObjectName()});
		TSpaceHis his=null;
		if(list.size()==0){
			his=new TSpaceHis();
			his.setId(PKUtils.getPKStr("T_SPACE_HIS"));
		}else{
			his=list.get(0);
		}
		his.setTitle(title);
		his.setUpdateTime(new Date());
		his.setObjectId(tt.getObjectId());
		his.setObjectName(tt.getObjectName());
		his.setTopicId(tt.getId());
		dao.createOrUpdate(his);
		dao.create(tcnf);//T_COURSE_NEWS_FEED
		String imgInfo = "";
		if(imgList != null && imgList.length > 0){
			//获取服务器密钥
			String accessToken = esapiPage.getWeixinAccessToken(user.getSchoolId(), param.getLqtWeixinAPPId());
			for(String mediaId : imgList){
				JSONObject downLoadInfo = esapiPage.weiXinTopicDownload(request, accessToken, mediaId, "IMG");
				if(downLoadInfo.getInt("byteSize") == 0){
					imgInfo = "帖子配图上传失败！";
					break;
				}else {	//文件另存为成功
					String pid = PKUtils.getPKStr("T_SPACE_PIC");
					TSpacePic pic=new TSpacePic();
					pic.setId(pid);
					pic.setTopicId(topicId);
					pic.setObjectName("T_SPACE_TOPIC");
					pic.setObjectId(topicId);
					pic.setCreator(user.getUserId());
					pic.setCreateDate(new Date());
					pic.setFilename(downLoadInfo.getString("fileName"));
					pic.setFilesize(downLoadInfo.getInt("byteSize"));
					pic.setUrl(downLoadInfo.getString("dbPath"));
					dao.create(pic);
					String fid = PKUtils.getPKStr("T_COURSE_NEWS_FEED");
					TCourseNewsFeed feed = new TCourseNewsFeed(fid, "T_SPACE_PIC", pid, user.getUserId(), user.getUserType(), tt.getObjectId(), "1", new Date()); 
					dao.create(feed);
					//待加裁切及缩小图片队列
					TPicQueue queue = new TPicQueue(PKUtils.getPKStr("T_PIC_QUEUE"), pid, "T_SPACE_PIC", downLoadInfo.getString("dbPath"), new Date());
					dao.create(queue);
				}
			}
		}
		daoService.commitTransaction();
		code="200";
		message="发帖成功！"+imgInfo;
	}catch (Exception e) {
		daoService.rollbackTransaction();
		message="发帖失败！";
		LogUtil.error("weixin空间发帖失败！错误信息："+e.getMessage(), e);
	}
	json.put("code", code);
	json.put("message", message);
	out.println(json.toString());
%>