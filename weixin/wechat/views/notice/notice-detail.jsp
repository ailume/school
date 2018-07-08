<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="com.lineteam.util.BeanUtils"%>
<%@ page import="com.bussiness.oa.NoticeUtils"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.app.ajax.weixin.NoticeAjax"%>
<%@ page import="com.system.RedPointCache"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="com.lineteam.util.DateUtils"%>
<%@ page import="com.bussiness.myapp.utils.JsoupUtils"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	String showNoticeId = esapi.getRawParam("noticeId");
	String noticeId = IdEncodingUtil.decode(showNoticeId);
	Map map = NoticeUtils.getNoticeMap(user.getSchoolId(), noticeId);
	if(map == null){
		response.sendRedirect(ROOTPath+"/weixin/error/notFound.html");
		return;
	}
	//添加通知阅读纪录
	NoticeUtils.addViewCount(user.getSchoolId(), noticeId, user);
	//删除红点纪录
	RedPointCache.getInstance().read(user.getStudentId(), "WEIXIN", user.getSchoolId(), user.getUserId(), RedPointCache.TYPECODE_NOTICE, noticeId);
	boolean reply = "1".equals(BeanUtils.getPropertyStr(map, "ALLOWREPLEY"));
	String initTime = DateUtils.formatDate(new Date(),"yyyy-MM-dd HH:mm:ss");
	//读取通知评论列表
	NoticeAjax noticeAjax = new NoticeAjax(request, response);
	JSONArray commenList = noticeAjax.getNoticeCommentList(noticeId);
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>通知详情</title>
    <link href="../../public/css/notice/detail.css" rel="stylesheet" />
  </head>
  <body>
	<a class="a-back" href="../school/home.html?type=notice">返回通知</a>
  	<div class="lqt-container">
		<div class="detail-container">
			<div class="detail-title"><%=BeanUtils.getPropertyStr(map, "TITLE")%></div>
			<div class="detail-content"><%=JsoupUtils.addAppUrl(BeanUtils.getPropertyStr(map, "CONTENT"), APPURL) %></div>
			<div class="detail-info"><%=BeanUtils.getPropertyStr(map, "DEPTNAME") %> <%=DateUtils.getWeiXinTime(BeanUtils.getPropertyStr(map, "PUBLISHDATE")) %></div>
			<ul class="lqt-list detail-comment">
			<%
			for(int i=0; i<commenList.size(); i++){
				JSONObject cInfo = commenList.getJSONObject(i);
			%>
				<li class="it clearfix it-m">
  					<div class="list-title avatar">
  						<img class="avatar" src="<%=cInfo.getString("userIcon") %>" />
  					</div>
  					<div class="list-content">
					    <p class="comment-name"><%=cInfo.getString("userName") %></p>
					    <div class="comment-warpper">
					        <span class="lqt-arrow">
					           <em class="arrow-up"></em>
					           <em class="arrow-down"></em>
					        </span>
					        <p class="comment-content">
					           <span><%=JsoupUtils.addAppUrl(cInfo.getString("content"), APPURL) %></span>
					        </p>
					    </div>
					    <p class="comment-time"><%=cInfo.getString("pubDate") %></p>
					</div>
  				</li>
  			<%}%>
			</ul>
		</div>
  	</div>
<%if(reply){ %>
  	<div class="comment-container clearfix" id="comment">
  		<div class="comment-input fl">
  			<p class="input-warpper"><input type="text" placeholder="回复一下吧..." /></p>
  		</div>
  		<a class="comment-btn fr" href="javascript:void(0)">回复</a>
  	</div>
<%}%>
  	<div id="backtop">
  		<a class="lqt-backtop" href="javascript:void(0)"><em class="icon-rise">&#x0024;</em></a>
  	</div>
  	<script>
  		var g_config = {
  			comment: "<%=BeanUtils.getPropertyStr(map, "ALLOWREPLEY")%>",
  			commentObj:{
  				NAME: "<%=user.getName() %>",
  				FORMATDATE: "0分钟之前",
  				CONTENT: "",
  				USERPIC: "<%=user.getIcon() %>"
  			},
  			noticeId:'<%=showNoticeId %>',
  			initTime:'<%=initTime %>',
  			pageType: 'noticeDetail'
  		};
  	</script>
	<script src="../../public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="../../public/js/config/lqt.js"></script>
	<script>seajs.use("../../public/js/notice/detail.js");</script>
  </body>
</html>