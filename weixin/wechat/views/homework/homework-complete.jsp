<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.util.ValidateUtils"%>
<%@ page import="com.bussiness.space.PreLessUtils"%>
<%@ page import="com.bussiness.space.HomeworkUtils"%>
<%@ page import="com.lineteam.util.BeanUtils"%>
<%@ page import="com.tooss.OssUtils"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	String showHomeworkId = esapiPage.getRawParam("homeworkId");
	String homeworkId = IdEncodingUtil.decode(showHomeworkId);
	Map workMap = PreLessUtils.getHomework(homeworkId, user.getSchoolId());
	String studentId = "T_STUDENT".equals(user.getUserType()) ? user.getUserId() : user.getStudentId();
	Map checkMap = PreLessUtils.getCheckHomeWork(homeworkId, studentId);
	String rComment = BeanUtils.getPropertyStr(checkMap, "RCOMMENT");
	String comment = BeanUtils.getPropertyStr(checkMap, "COMMENT");
	List list = HomeworkUtils.getQuestionListByHomeworkIdNoAnswer(homeworkId, studentId);
	JSONObject weixinConfig = esapiPage.getWeixinConfig(request, user.getSchoolId());
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>作业-已完成</title>
    <link href="../../public/css/homework/detail.css" rel="stylesheet" />
  </head>
  <body>
  	<a class="a-back" href="index.html">返回作业</a>
  	<div class="lqt-container lqt-wrapper" id="complete">
  		<div class="homework-container" id="headerBox" style="width:320px;">
  			<ul class="homework-list clearfix header-banner" id="bannerBox">
	<%	for(Object obj:list){
			String id = BeanUtils.getPropertyStr(obj, "ID");
			String type = BeanUtils.getPropertyStr(obj, "QUESTYPE");
			String no = BeanUtils.getPropertyStr(obj, "QUESNO");
			String content = PreLessUtils.addAppUrl(BeanUtils.getPropertyStr(obj, "CONTENT"), APPURL);
			String answer = BeanUtils.getPropertyStr(obj, "ANS_CONTENT");
			String sinAnswer = "";
			String mainId = BeanUtils.getPropertyStr(obj, "MAINID");
			List detailes = PreLessUtils.getCheckHomeWorkDetail(mainId, id);
			if(detailes.size() == 1){
				Map map = (Map)detailes.get(0);
				sinAnswer = BeanUtils.getPropertyStr(map, "ANSWER");
			}
  			if("2".equals(type)){ %>
  				<!-- 多选 -->
  				<li class="it banner-sheet" id="liId<%=id%>"><!-- id：题目id -->
					<div class="scroll-wrapper">
						<div class="scroll-dom">
  						<%if("1".equals(no)){ %>
	  						<div class="homework-tips clearfix">
	  							<div class="tips-content">
	  								<p>【<%=BeanUtils.getPropertyStr(workMap, "COUSENAME") %> <%=BeanUtils.getPropertyStr(workMap, "VALUE") %>】</p>
	  								<p><%=BeanUtils.getPropertyStr(workMap, "TITLE") %></p>
	  							</div>
	  							<span class="homework-deadline"><%=BeanUtils.getPropertyStr(workMap, "OUTDATE").substring(5, 11) %> 截止</span>
							</div>
						<%}%>
							<div class="homework-content">
								<div class="homework-title"><%=no %>.［多选题］<%=content %></div>
								<ul class="homework-answer">
								<%
									   List quesList = HomeworkUtils.getQuestionrById(id);
									   for(Object qobj:quesList){
										   String qContent = PreLessUtils.addAppUrl(BeanUtils.getPropertyStr(qobj, "CONTENT"), APPURL);
										   boolean checked = sinAnswer.indexOf(BeanUtils.getPropertyStr(qobj, "ORDERNO")) > -1;
								%>
									<li class="answer clearfix">
										<label>
											<span class="icon-common icon-checkbox">
												<span class="icon-checkbox-point<%if(checked){%> active<%}%>">&#x002c;</span>
											</span>
											<span class="answer-content"><%=BeanUtils.getPropertyStr(qobj, "ORDERNO")%> <%=qContent%></span>
										</label>
									</li>
								<%
									   }
								%>
									<li class="correct-answer">答案：<%=answer %><%=answer.equals(sinAnswer)?"<span class='answer-right'>（ √ ）</span>":"<span class='answer-wrong'>（ &chi; ）</span>" %></li>
								</ul>
							</div>
						</div>
					</div>
  				</li><!-- 多选end -->
  			<%}else if("1".equals(type)){ %>
  				<!-- 单选 -->
 				<li class="it banner-sheet" id="liId<%=id%>"><!-- id：题目id -->
					<div class="scroll-wrapper">
						<div class="scroll-dom">
 					 	<%if("1".equals(no)){ %>
 							<div class="homework-tips clearfix">
	 							<div class="tips-content">
	 								<p>【<%=BeanUtils.getPropertyStr(workMap, "COUSENAME") %> <%=BeanUtils.getPropertyStr(workMap, "VALUE") %>】</p>
	 								<p><%=BeanUtils.getPropertyStr(workMap, "TITLE") %></p>
	 							</div>
	 							<span class="homework-deadline"><%=BeanUtils.getPropertyStr(workMap, "OUTDATE").substring(5, 11) %> 截止</span>
							</div>
						<%}%>
							<div class="homework-content">
								<div class="homework-title"><%=no %>.［单选题］<%=content %></div>
								<ul class="homework-answer">
								<%
									   List quesList = HomeworkUtils.getQuestionrById(id);
									   for(Object qobj:quesList){
										   boolean checked = BeanUtils.getPropertyStr(qobj, "ORDERNO").equals(sinAnswer);
								%>
									<li class="answer clearfix">
										<label>
											<span class="icon-common icon-radio">
												<span class="icon-radio-point<%if(checked){%> active<%}%>"></span>
											</span>
											<span class="answer-content"><%=BeanUtils.getPropertyStr(qobj, "ORDERNO")%> <%=BeanUtils.getPropertyStr(qobj, "CONTENT")%></span>
										</label>
									</li>
								<%
									   }
								%>
									<li class="correct-answer">答案：<%=answer %> <%=answer.equals(sinAnswer)?"<span class='answer-right'>（ √ ）</span>":"<span class='answer-wrong'>（ &chi; ）</span>" %></li>
								</ul>
							</div>
						</div>
					</div>
  				</li><!-- 单选end -->
  			<%}else if("5".equals(type)){ %>
  				<!-- 单选 -->
  				<li class="it banner-sheet" id="liId<%=id%>"><!-- id：题目id -->
					<div class="scroll-wrapper">
						<div class="scroll-dom">
  					 	<%if("1".equals(no)){ %>
	  						<div class="homework-tips clearfix">
	  							<div class="tips-content">
	  								<p>【<%=BeanUtils.getPropertyStr(workMap, "COUSENAME") %> <%=BeanUtils.getPropertyStr(workMap, "VALUE") %>】</p>
	  								<p><%=BeanUtils.getPropertyStr(workMap, "TITLE") %></p>
	  							</div>
	  							<span class="homework-deadline"><%=BeanUtils.getPropertyStr(workMap, "OUTDATE").substring(5, 11) %> 截止</span>
							</div>
						<%} %>
							<div class="homework-content">
								<div class="homework-title"><%=no %>.［判断题］<%=content %></div>
								<ul class="homework-answer">
									<li class="answer clearfix">
										<label>
										<span class="icon-common icon-radio"><span class="icon-radio-point <%if("true".equals(sinAnswer)){%>active<%}%>"></span></span>
										<span class="answer-content">对</span>
										</label>
									</li>
									<li class="answer clearfix">
										<label>
										<span class="icon-common icon-radio"><span class="icon-radio-point  <%if("false".equals(sinAnswer)){%>active<%}%>"></span></span>
										<span class="answer-content">错</span>
										</label>
									</li>
									<li class="correct-answer">答案：<%="true".equals(answer)?"对":"错" %> <%=answer.equals(sinAnswer)?"<span class='answer-right'>（ √ ）</span>":"<span class='answer-wrong'>（ &chi; ）</span>" %></li>
								</ul>
							</div>
						</div>
					</div>
  				</li><!-- 单选end -->
  			<%} if("3".equals(type)||"4".equals(type)){ %>
  				<!-- 问答题 -->
  				<li class="it banner-sheet sheet-qs" id="liId<%=id%>"><!-- id：题目id -->
					<div class="scroll-wrapper">
						<div class="scroll-dom">
	  					 <%if("1".equals(no)){ %>
	  						<div class="homework-tips clearfix">
	  							<div class="tips-content">
	  								<p>【<%=BeanUtils.getPropertyStr(workMap, "COUSENAME") %> <%=BeanUtils.getPropertyStr(workMap, "VALUE") %>】</p>
	  								<p><%=BeanUtils.getPropertyStr(workMap, "TITLE") %></p>
	  							</div>
	  							<span class="homework-deadline"><%=BeanUtils.getPropertyStr(workMap, "OUTDATE").substring(5, 11) %> 截止</span>
							</div>
						<%}%>
							<div class="homework-content">
								<div class="homework-title"><%=no %>.［<%="4".equals(type) ? "其它作业" : "问答题"  %>］<%=content %></div>
								<ul class="homework-answer">
						<%	for(Object detail: detailes){
								String dtype = BeanUtils.getPropertyStr(detail, "TYPE");
								String danswer = BeanUtils.getPropertyStr(detail, "ANSWER");
								if("".equals(dtype)){%>
									<li class="answer-qs qs-txt">
										<%=danswer %>
										<!--
									   <textarea class="qs-data" style="display:none;" name="content" readonly="readonly"><%=danswer %></textarea>
									   <div class="qs-content" contenteditable="true"></div>
									    -->
									</li>
								<%}else if("1".equals(dtype)){ %>
									<li class="answer-qs qs-img">
										<img src="<%=OssUtils.getInstance().getOSSLqtUrl(danswer) %>" />
									</li>
								<%} else if("2".equals(dtype)){ %>
									<li class="answer-qs qs-voice it-m clearfix">
										<a class="btn-play" href="javascript:void(0)">
			  								<span class="lqt-arrow">
												<em class="arrow-up"></em>
												<em class="arrow-down"></em>
											</span>
			  								<span class="qs-voice-icon">&#x0026;</span>
			  								<audio preload="auto">
				  								<source src="<%=OssUtils.getInstance().getOSSLqtUrl(danswer) %>" type="audio/mpeg">
				  								Your browser does not support the audio tag.
			  								</audio>
										</a>
		  								<span class="recordtime"></span>
					  				</li>
								<%}} %>
									<li class="answer-qs qs-answer">答案：</li>
									<li class="answer-qs qs-txt" style="border:none;">
									   <textarea class="qs-data" name="content" readonly="readonly"><%=answer %></textarea>
									   <div class="qs-content" contenteditable="true"></div>
									</li>
								</ul>
							</div>
						</div>
					</div>
  				</li><!-- 问答题end -->
  			<%}}%>
  				<!-- 评语 -->
			<%if(!"".equals(rComment) || !"".equals(comment)){%>
				<li class="it banner-sheet sheet-comment" data-type="comment" id="comment">
					<div class="homework-content">
					<%if(!"".equals(rComment)){%>
						<p class="homework-title">评价：</p>
						<p class="homework-msg"><%=rComment %></p>
					<%}%>
					<%if(!"".equals(comment)){%>
						<p class="homework-title">老师留言：</p>
						<p class="homework-msg"><%=comment %></p>
					<%}%>
					</div>
				</li><!-- 评语end -->
			<%}%>
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
  			pageType: 'homeworkComplete',
  			id: '<%=showHomeworkId %>',		//作业id
  			wx: {
  				appId: "<%=weixinConfig.getString("appId") %>",
	  			timestamp: "<%=weixinConfig.getString("timestamp") %>",
	  			nonceStr: "<%=weixinConfig.getString("nonceStr") %>",
	  			signature: "<%=weixinConfig.getString("signature") %>"
  			}
  		};
		/* $(".homework-content p img").each(function(){
			alert($(this).attr("src"));
		}); */
  	</script>
	<script src="../../public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="../../public/js/config/lqt.js"></script>
	<script>seajs.use("../../public/js/homework/detail.js");</script>
  </body>
</html>