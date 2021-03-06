<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.app.ajax.weixin.SpaceAjax"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	String spaceId = esapiPage.getCleanParam("spaceid");
	SpaceAjax spaceAjax = new SpaceAjax(request, response);
	spaceAjax.addUserSpaceLog(user, spaceId);
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>详情</title>
    <link href="<%=ROOTPath %>/weixin/public/css/class/detail.css" rel="stylesheet" />
  </head>
  <body>
  	<div id="detail">
  		<ul id="home-list">
  			<li class="it clearfix" topicid="TOPIC_ID" userid="USER_ID" likeflag="0">
				<span class="avatar avatar-m" style="background-image:url('/public/images/1.jpg')"></span>
				<div class="content">
					<p class="title">USER_NAME</p>
					<span class="intro"><p><span>CONTENT</span></p></span>
					<ul class="pic clearfix two"><!-- 1张图：无；两张图：two；三张及三张以上：ninecell -->
						<!-- 一张图用这段 -->
						<!-- <li class="i"><a class="fullscreenview" href="javascript:void(0)"><p><img src="/public/images/1.jpg"></p></a></li> -->
						<!-- 一张图以上用这段 -->
					</ul>
					<div class="info">
						<span class="creattime">PUB_TIME</span>
						<a class="btn-set icon-op" href="javascript:void(0)"><em></em></a>
						<div class="op-container">
						<div class="op-box clearfix">
							<a class="btn-like" href="javascript:void(0)"><em class="icon icon-like-w"></em><span>赞</span></a>
							<a class="btn-comment" href="javascript:void(0)" type="btn"><em class="icon icon-comment"></em>评论</a>
						</div>
						</div>
					</div>
					<div class="like clearfix">
						<span class="left"><em class="icon icon-like animated"></em></span><!-- 当前用户已赞em加active -->
						<div class="u-info" userid="$${like.USER_ID}">
							<span class="avatar u-avatar" style="background-image:url('/public/images/1.jpg')"></span>
							<p class="u-nick">USER_NAME</p>
						</div>
					</div>
					<ul class="comment">
						<li>
							<a class="btn-comment" href="javascript:void(0)" type="comment" commentid="COMMENT_ID" username="USER_NAME">
								<span>USER_NAME：<em>回复</em>TO_USER_NAME</span>
								<span class="content">CONTENT</span>
							</a>
						</li>
					</ul>
				</div>
			</li>
  		</ul>
  	</div>
  	<div id="comment-container">
		<div class="comment-main">
			<p class="textarea"><textarea id="commentcontent" placeholder="期待更多有趣内容，请留下您的建议..."></textarea></p>
			<p><a class="btn button-close" id="button-close" href="javascript:void(0)">取消</a><a class="btn button-confirm" id="button-confirm" href="javascript:void(0)">发送</a></p>
		</div>
	</div>
  	<script>
  		var g_config = {
  			pageType: 'detail',
  			jsBasePath: ROOTPath + "/weixin/public/js/",
  			SPACE_ID: "<%=spaceId %>",
  			userinfo: {
  				USER_ID: '<%=user.getUserId() %>',
				USER_ICON: '<%=user.getIcon() %>',
				USER_NAME: '<%=user.getName() %>'
  			}
  		};
  	</script>
	<script src="<%=ROOTPath %>/weixin/public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="<%=ROOTPath %>/weixin/public/js/config/lqt.js"></script>
	<script>seajs.use("<%=ROOTPath %>/weixin/public/js/class/detail.js");</script>
  </body>
</html>