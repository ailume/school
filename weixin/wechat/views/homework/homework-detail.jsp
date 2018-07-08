<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.bussiness.myapp.utils.JsoupUtils"%>
<%@ page import="com.util.ValidateUtils"%>
<%@ page import="com.bussiness.space.PreLessUtils"%>
<%@ page import="com.lineteam.util.BeanUtils"%>
<%@ page import="com.bussiness.space.HomeworkUtils"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	Calendar open = Calendar.getInstance();
	String showHomeworkId = esapiPage.getRawParam("homeworkId");
	String homeworkId = IdEncodingUtil.decode(showHomeworkId);
	List list = HomeworkUtils.getQuestionListByHomeworkId(homeworkId);
	Map workMap = PreLessUtils.getHomework(homeworkId, user.getSchoolId());
	JSONObject weixinConfig = esapiPage.getWeixinConfig(request, user.getSchoolId());
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <meta name="format-detection" content="telephone=no">
    <title>作业</title>
    <link href="../../public/css/homework/detail.css" rel="stylesheet" />
  </head>
  <body>

	<a class="a-back" href="index.html">返回作业</a>
  	<div class="lqt-container lqt-wrapper" id="scorll"><!-- lqt-wrapper -->
		<div class="homework-container" id="headerBox" style="width:320px;">
			<ul class="homework-list clearfix header-banner" id="bannerBox">
	<%	for(Object homework : list){
			String id = BeanUtils.getPropertyStr(homework, "ID");
			String type = BeanUtils.getPropertyStr(homework, "QUESTYPE");
			String no = BeanUtils.getPropertyStr(homework, "QUESNO");
			String content = BeanUtils.getPropertyStr(homework, "CONTENT");
			String answer = BeanUtils.getPropertyStr(homework, "ANS_CONTENT");
			String limitDate = BeanUtils.getPropertyStr(workMap, "OUTDATE");
			if(!ValidateUtils.isEmpty(limitDate)){
				if(limitDate.length() > 12){
					limitDate = limitDate.substring(6, 11);
				}
			}
			if("2".equals(type)){ %>
				<!-- 多选 -->
				<li class="it banner-sheet" data-type="checkbox" id="<%=id %>"><!-- id：题目id -->
					<div class="scroll-wrapper">
						<div class="scroll-dom">
						<%if("1".equals(no)){ %>
							<div class="homework-tips clearfix">
								<div class="tips-content">
									<p>【<%=BeanUtils.getPropertyStr(workMap, "COUSENAME") %> <%=BeanUtils.getPropertyStr(workMap, "VALUE") %>】</p>
									<p><%=BeanUtils.getPropertyStr(workMap, "TITLE") %></p>
								</div>
								<span class="homework-deadline"><%=limitDate %> 截止</span>
							</div>
						<%}%>
							<div class="homework-content">
								<div class="homework-title"><%=no %>.［多选题］<%=content %></div>
								<ul class="homework-answer select-data">
									<% List quesList = HomeworkUtils.getQuestionrById(id);
									   for(Object qobj:quesList){
									%>
										<li class="answer clearfix" id="<%=BeanUtils.getPropertyStr(qobj, "ORDERNO")%>">
											<label class="clearfix">
											<span class="icon-common icon-checkbox"><input class="selectBox" type="checkbox" name="checkbox" /><span class="icon-checkbox-point">&#x002c;</span></span>
											<span class="answer-content"><%=BeanUtils.getPropertyStr(qobj, "ORDERNO")%> <%=JsoupUtils.addAppUrl(BeanUtils.getPropertyStr(qobj, "CONTENT"), APPURL) %></span>
											</label>
										</li>
									<%
									   }
									%>
								</ul>
							</div>
							<input class="answer-data" type="hidden" />
						</div>
					</div>
				</li><!-- 多选end -->
			<%}else if("1".equals(type)){ %>
				<!-- 单选 -->
				<li class="it banner-sheet" data-type="radio" id="<%=id %>"><!-- id：题目id -->
					<div class="scroll-wrapper">
						<div class="scroll-dom">
						<%if("1".equals(no)){ %>
							<div class="homework-tips clearfix">
								<div class="tips-content">
									<p>【<%=BeanUtils.getPropertyStr(workMap, "COUSENAME") %> <%=BeanUtils.getPropertyStr(workMap, "VALUE") %>】</p>
									<p><%=BeanUtils.getPropertyStr(workMap, "TITLE") %></p>
								</div>
								<span class="homework-deadline"><%=limitDate %> 截止</span>
							</div>
						<%}%>
							<div class="homework-content">
								<p class="homework-title"><%=no %>.［单选题］<%=JsoupUtils.addAppUrl(content, APPURL) %></p>
								<ul class="homework-answer select-data">
								<% List quesList = HomeworkUtils.getQuestionrById(id);
								   for(Object qobj:quesList){
								%>
									<li class="answer clearfix" id="<%=BeanUtils.getPropertyStr(qobj, "ORDERNO")%>">
										<label class="clearfix">
										<span class="icon-common icon-radio"><input class="selectBox" type="radio" name="radio2" /><span class="icon-radio-point"></span></span>
										<span class="answer-content"><%=BeanUtils.getPropertyStr(qobj, "ORDERNO")%> <%=JsoupUtils.addAppUrl(BeanUtils.getPropertyStr(qobj, "CONTENT"), APPURL) %></span>
										</label>
									</li>
								<%
								   }
								%>
								</ul>
							</div>
							<input class="answer-data" type="hidden" />
						</div>
					</div>
				</li><!-- 单选end -->
			<%}else if("5".equals(type)){ %>
				<li class="it banner-sheet" data-type="radio" id="<%=id %>">
					<div class="scroll-wrapper">
						<div class="scroll-dom">
						<%if("1".equals(no)){ %>
							<div class="homework-tips clearfix">
								<div class="tips-content">
									<p>【<%=BeanUtils.getPropertyStr(workMap, "COUSENAME") %> <%=BeanUtils.getPropertyStr(workMap, "VALUE") %>】</p>
									<p><%=BeanUtils.getPropertyStr(workMap, "TITLE") %></p>
								</div>
								<span class="homework-deadline"><%=limitDate %> 截止</span>
							</div>
						<%}%>
							<div class="homework-content">
								<p class="homework-title"><%=no %>.［判断题］<%=JsoupUtils.addAppUrl(content, APPURL) %></p>
								<ul class="homework-answer select-data">
									<li class="answer clearfix" id="true">
										<label class="clearfix">
										<span class="icon-common icon-radio"><input class="selectBox" type="radio" name="radio2" /><span class="icon-radio-point"></span></span>
										<span class="answer-content">对</span>
										</label>
									</li>
									<li class="answer clearfix" id="false">
										<label class="clearfix">
										<span class="icon-common icon-radio"><input class="selectBox" type="radio" name="radio2" /><span class="icon-radio-point"></span></span>
										<span class="answer-content">错</span>
										</label>
									</li>
								</ul>
							</div>
							<input class="answer-data" type="hidden" />
						</div>
					</div>
				</li>
			<%}else if("3".equals(type)||"4".equals(type)){ %>
				<!-- 问答题 -->
				<li class="it banner-sheet sheet-qs homework-detail" data-type="qs" id="<%=id %>"><!-- id：题目id -->
					<div class="scroll-wrapper">
						<div class="scroll-dom">
						<%if("1".equals(no)){ %>
							<div class="homework-tips clearfix">
								<div class="tips-content">
									<p>【<%=BeanUtils.getPropertyStr(workMap, "COUSENAME") %> <%=BeanUtils.getPropertyStr(workMap, "VALUE") %>】</p>
									<p><%=BeanUtils.getPropertyStr(workMap, "TITLE") %></p>
								</div>
								<span class="homework-deadline"><%=limitDate %> 截止</span>
							</div>
						<%}%>
							<div class="homework-content">
								<p class="homework-title"><%=no %>.［<%="4".equals(type) ? "其它作业" : "问答题"  %>］<%=JsoupUtils.addAppUrl(content, APPURL) %></p>
								<ul class="homework-answer">
									<li class="answer-qs qs-txt">
									   <textarea class="qs-data" name="content"></textarea>
									   <div class="qs-content" contenteditable="true"></div>
									</li>
								</ul>
							</div>
			 			</div>
					</div>
				<%if("T_STUDENT".equals(user.getUserType())){%>
					<div class="qs-bar clearfix">
	 					<p><span class="bar-btn btn-img">&#x0028;</span></p>
	 					<p><span class="bar-btn btn-voice">&#x0027;</span></p>
	 				</div>
	 			<%}%>
				</li><!-- 问答题end -->
			<%}}%>
			</ul>
		</div>
  	</div>
  	<div class="homework-bar clearfix" id="bar">
  		<a id="pre" class="homework-btn homework-pre clearfix" href="javascript:void(0)">
  			<em class="icon-change icon-pre">&#x0025;</em><span class="txt-change">上一题</span>
		</a>
  		<a id="next" class="homework-btn homework-next clearfix" href="javascript:void(0)">
  			<span class="txt-change">下一题</span><em class="icon-change icon-next">&#x0025;</em>
		</a>
	<%if("T_STUDENT".equals(user.getUserType())){%>
		<a class="homework-btn homework-submit clearfix" href="javascript:void(0)">
  			<span class="txt-submit">提交作业</span>
		</a>
	<%}%>
		<span class="pre-loc"></span>
  	</div>
  	<script>
  		var g_config = {
  			jsBasePath: "",
  			jsVersion: '',
  			baseUrl: '<%=APPURL %>',
  			pageType: 'homeworkDetail',
  			id: '<%=showHomeworkId %>',		//作业id
  			wx: {
  				appId: "<%=weixinConfig.getString("appId") %>",
	  			timestamp: "<%=weixinConfig.getString("timestamp") %>",
	  			nonceStr: "<%=weixinConfig.getString("nonceStr") %>",
	  			signature: "<%=weixinConfig.getString("signature") %>"
  			}
  		};
  	</script>
	<script src="../../public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="../../public/js/config/lqt.js"></script>
	<script>seajs.use("../../public/js/homework/detail.js?v=1.10002");</script>
  </body>
</html>
