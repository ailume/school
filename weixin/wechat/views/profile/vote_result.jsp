<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lineteam.util.NumberUtil"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.app.ajax.weixin.vote.VoteAjax"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%!
	//构建附件样式
	private String getFileHtml(String ROOTPath, JSONArray sFiles){
		StringBuffer fHtml = new StringBuffer();
		for(int sf=0; sf<sFiles.size(); sf++){
			JSONObject fileInfo = sFiles.getJSONObject(sf); 
			String filaName = fileInfo.getString("NAME");
			String filePath = ROOTPath+fileInfo.getString("URL");
			if("1".equals(fileInfo.getString("TYPE"))){	//图片
				fHtml.append("<a class=\"preview\" href=\"javascript:void(0)\"><img src=\""+filePath+"\"/></a>");
			}else if("2".equals(fileInfo.getString("TYPE"))){//视频
				fHtml.append("<video controls=\"controls\" x5-video-player-type=\"h5\"><source src=\""+filePath+"\" type=\"video/mp4\">Your browser does not support the video tag.</video>");
			}else if("3".equals(fileInfo.getString("TYPE"))){//音频
				fHtml.append("<p class=\"audio-name\">"+filaName+"</p><audio controls=\"controls\"><source src=\""+filePath+"\" type=\"audio/mpeg\">");
				fHtml.append("Your browser does not support the audio tag.</audio>");
			}else if("4".equals(fileInfo.getString("TYPE"))){//文件
				fHtml.append("<a class=\"file-name\" href=\""+filePath+"\">"+filaName+"</a>");
			}
		}
		return fHtml.toString();
	}
%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	String showVoteId = esapi.getRawParam("voteId");
	String voteId = IdEncodingUtil.decode(showVoteId);
	VoteAjax voteAjax = new VoteAjax();
	JSONObject info = voteAjax.getVoteJSON(user, voteId, true);
	if(info.isEmpty()){
		response.sendRedirect(ROOTPath+"/weixin/error/notFound.html");
		return;
	}
%>
<!DOCTYPE HTML5>
<html>
<head>
	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>投票结果</title>
    <link href="../../public/css/profile/qv.css" rel="stylesheet" />
</head>
<body>
<a class="a-back" href="../profile/vote_list.html">返回投票列表</a>
<div class="lqt-container" id="vote">
	<div class="homework-container" id="headerBox">
		<ul class="homework-list clearfix header-banner" id="bannerBox">
			<!-- 投票说明 -->
			<li class="it banner-sheet" data-type="checkbox" id="explain">
				<div class="scroll-wrapper">
					<div class="scroll-dom">
						<div class="explain-tips clearfix">
							<div class="tips-content clearfix">
								<b><%if("1".equals(info.getString("ANONYM_FLAG"))){%>匿名<%} else{%>实名<%}%>投票</b>
								<b>结果<%if("1".equals(info.getString("HIDE_FLAG"))){%>不<%}%>公示</b>
							</div>
							<span class="deadline"><%=info.getString("OUTDATE") %>截止</span>
						</div>
						<p class="explain-title"><b><%=info.getString("TITLE") %></b></p>
						<p class="explain-content"><%=info.getString("INTRINFO") %></p>
					</div>
				</div>
			</li>
			<!-- 投票说明end -->
<%	
JSONArray subArray = info.getJSONArray("SUBJECTS");
for(int i=0; i<subArray.size(); i++){
	JSONObject subInfo = subArray.getJSONObject(i);
	String sId = subInfo.getString("SID");						//主题ID
	String sIndex = subInfo.getString("SNO");					//主题编号
	String sTitle = subInfo.getString("STITLE");				//主题标题
	Integer sNum = subInfo.getInt("SNUM");						//主题可选择项目数
	JSONArray sFiles = subInfo.getJSONArray("SFILE");			//主题附件
	JSONArray sOption = subInfo.getJSONArray("SOPTIONS");		//主题选项
	Integer sCount = subInfo.getInt("SCOUNT");
	if(sNum>1){
		%>
			<!-- 多选 -->
			<li class="it banner-sheet" data-type="checkbox" id="<%=sId %>"><!-- id：题目id -->
				<div class="scroll-wrapper">
					<div class="scroll-dom">
						<div class="homework-content">
							<div class="homework-title"><%=sIndex %>.<b>［多选］</b><%=sTitle %><span>（最多可选<%=sNum %>项）</span></div>
							<%=getFileHtml(ROOTPath, sFiles) %>
							<ul class="homework-answer select-data">
						<%
						for(int o=0; o<sOption.size(); o++){
							JSONObject opInfo = sOption.getJSONObject(o);
							String opId = sId+o;
							String opTitle = opInfo.getString("OPTITLE");
							String opValue = opInfo.getString("OPVALUE");
							String active = opInfo.getBoolean("OPSELECT") ? "active" : "";
							Integer opCount = opInfo.getInt("OPCOUNT");
							double opCountStr = sCount > 0 ? NumberUtil.double45((double)opCount/(double)sCount*100, 2) : 0D;
							%>
								<li class="answer clearfix" id="<%=opValue %>">
									<label class="clearfix">
									<span class="icon-common icon-checkbox">
										<span class="icon-checkbox-point <%=active %>">&#x002c;</span>
									</span>
									<span class="answer-content"><%=opTitle %></span>
									</label>
									<%=getFileHtml(ROOTPath, opInfo.getJSONArray("OPFILE")) %>
									<%if("0".equals(info.getString("HIDE_FLAG"))){%>
									<div class="percent-container clearfix">
										<p class="percent"><span style="width:<%=opCountStr %>%"></span></p>
										<span class="tips"><%=opCount %>票</span>
									</div>
									<%}%>
								</li>
							<%
						}
						%>
							</ul>
						</div>
					</div>
				</div>
			</li>
			<!-- 多选end -->
		<%
	}else {
		%>
			<!-- 单选 -->
			<li class="it banner-sheet" data-type="radio" id="<%=sId %>"><!-- id：题目id -->
				<div class="scroll-wrapper">
					<div class="scroll-dom">
						<div class="homework-content">
							<p class="homework-title"><%=sIndex %>.<b>［单选］</b><%=sTitle %></p>
							<%=getFileHtml(ROOTPath, sFiles) %>
							<ul class="homework-answer select-data">
						<%
						for(int o=0; o<sOption.size(); o++){
							JSONObject opInfo = sOption.getJSONObject(o);
							String opId = sId+o;
							String opTitle = opInfo.getString("OPTITLE");
							String opValue = opInfo.getString("OPVALUE");
							String active = opInfo.getBoolean("OPSELECT") ? "active" : "";
							Integer opCount = opInfo.getInt("OPCOUNT");
							double opCountStr = sCount > 0 ? NumberUtil.double45((double)opCount/(double)sCount*100, 2) : 0D;
							%>
								<li class="answer clearfix" id="<%=opValue %>">
									<label class="clearfix">
									<span class="icon-common icon-radio">
										<span class="icon-radio-point <%=active %>"></span>
									</span>
									<span class="answer-content"><%=opTitle %></span>
									</label>
									<%=getFileHtml(ROOTPath, opInfo.getJSONArray("OPFILE")) %>
									<%if("0".equals(info.getString("HIDE_FLAG"))){%>
									<div class="percent-container clearfix">
										<p class="percent"><span style="width:<%=opCountStr %>%"></span></p>
										<span class="tips"><%=opCount %>票</span>
									</div>
									<%}%>
								</li>
							<%
						}
						%>
							</ul>
						</div>
					</div>
				</div>
			</li>
			<!-- 单选end -->
		<%
	}
}
%>
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
	<span class="pre-loc"></span>
</div>
<script>
	var g_config = {
		baseUrl: '',
		jsBasePath: '',
		jsVersion: '',
		pageType: 'vote_detail',
		id: '6666',//作业id
		wx: {
			appId: 'wx2e3a10f99ee1c75e',
			timestamp: '', // 必填，生成签名的时间戳
		    nonceStr: '', // 必填，生成签名的随机串
		    signature: '',// 必填，签名
		}
	};
	var ROOTPath = '';
</script>
<script src="../../public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
<script src="../../public/js/config/lqt.js"></script>
<script>seajs.use("../../public/js/profile/qv_detail.js");</script>
</body>
</html>