<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.app.ajax.weixin.repair.RepairAjax"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	JSONObject weixinConfig = esapiPage.getWeixinConfig(request, user.getSchoolId());
	String showReopairId = esapiPage.getRawParam("repairId");
	String listType = esapiPage.getRawParam("listType");
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>报修详情</title>
    <link href="../../public/css/profile/repair_detail.css" rel="stylesheet" />
  </head>
  <body>
  	<a class="leave_msg" id="floatWindow" href="javascript:void(0)">留言</a>
  	<a class="a-back" href="../profile/repair_list.jsp?listType=<%=listType %>">返回报修列表</a>
  	<div class="lqt-wrapper">
  		<section id="lqt-top">
  			<template v-if="status==201">
  			<div class="btn clearfix">
  				<span class="tips">请尽快受理，别让他/她久等哦~</span>
				<a id="comfirm-p" href="javascript:;">受理</a>
  			</div>
  			</template>
  			<template v-else-if="status==202">
  			<div class="btn clearfix">
  				<span class="tips">早点修完，大家心安~</span>
				<a id="comfirm-f" href="javascript:;">维修完毕</a>
  			</div>
  			</template>
  			<template v-else-if="status==203">
  			<div class="clearfix">
  				<span class="tips">等待评价</span>
  			</div>
  			</template>
  			<template v-else-if="status==204">
  			<div class="clearfix">
  				<span class="tips">收获评价</span>
  				<p class="clearfix" id="star-container">
  					<!--评价分数-->
  				</p>
  			</div>
  			</template>
  			<template v-else-if="status==101">
  			<div class="clearfix">
  				<span class="tips">待受理，请耐心等待</span>
  			</div>
  			</template>
  			<template v-else-if="status==102">
  			<div class="clearfix">
  				<span class="tips">已受理，维修中</span>
  			</div>
  			</template>
  			<template v-else-if="status==103">
  			<div class="clearfix">
  				<span class="tips">维修完毕，给个评价哟~</span>
  				<span class="clearfix">
  					<a class="icon-star_e" href="javascript:;"></a>
  					<a class="icon-star_e" href="javascript:;"></a>
  					<a class="icon-star_e" href="javascript:;"></a>
  					<a class="icon-star_e" href="javascript:;"></a>
  					<a class="icon-star_e" href="javascript:;"></a>
  					<a id="comfirm-comment" data-score="0" href="javascript:void(0);">评价</a>
  				</span>
  			</div>
  			</template>
  			<template v-else-if="status==104">
  			<div class="clearfix">
  				<span class="tips">已评价</span>
  				<p class="clearfix"id="star-container">
  					<!--评价分数-->
  				</p>
  			</div>
  			</template>
  		</section>
  		<section>
	  		<ul id="chat">
	  			<!--留言-->
	  		</ul>
  		</section>
  		<section>
  			<p class="info-title">报修内容</p>
  			<p class="info-content" name="CONTENT"></p>
  			<p class="info-title">报修地点</p>
  			<p class="info-content" name="PLACE"></p>
  			<p class="info-title">报修对象</p>
  			<p class="info-content" name="DEPTNAME"></p>
  			<p class="info-title">联系电话</p>
  			<p class="info-content" name="PHONE"></p>
  			<p class="info-title">报修人</p>
  			<p class="info-content" name="USER_NAME"></p>
  			<p class="info-title">图片</p>
			<ul class="pic clearfix" id="repair_list">
				<!-- pic -->
			</ul>
  		</section>
	</div>
	<div class="animated" id="msg-box">
  		<a class="a-back" id="close-comment" href="javascript:void(0)">返回报修详情</a>
  		<div class="msg-wrapper">
  			<p class="tips">留言：</p>
  			<textarea name="content" id="content"></textarea>
  			<ul class="pic clearfix" id="preview-list">
  				<li class="it add"><p><a id="addpic" href="javascript:void(0)"></a></p></li>
  			</ul>
  			<a id="comment-submit" href="javascript:void(0)">留言</a>
  		</div>
	</div>
	<script type="text/template" id="COMMENT_LIST">
		{@each comments as it}
		<li class="it clearfix" id="$@{it.COMMENTID}" uid="$@{it.USERID}" uname="$@{it.USERNAME}">
			<span class="avatar" style="background-image:url('$@{it.USERPIC}');"></span>
			<div class="main">
				<a class="link leave_msg" href="javascript:void(0)">
				<p class="name">$@{it.USERNAME}</p>
				<p class="content">{@if it.TO_USERNAME!= ''}<span>回复$@{it.TO_USERNAME}：</span>{@/if}$@{it.CONTENT}</p>
				</a>
				<p class="creattime">$@{it.FORMATDATE}</p>
				{@if it.IMG_LIST.length > 0}
				<ul class="pic clearfix" id="img_list">
				{@each it.IMG_LIST as pic}
				<li><a class="fullscreenview" href="javacripe:void(0);"><span data-url="$@{pic}" style="background-image:url($@{pic})"></span></a></li>
				{@/each}
				</ul>
				{@/if}
			</div>
		</li>
		{@/each}
	</script>
  	<script type="text/javascript">
		var g_config = {
			pageType: "repair_detail",
			REPAIRID: "<%=showReopairId %>",
			LISTTYPE: "<%=listType %>",
			UID: "<%=IdEncodingUtil.encode(user.getUserId()) %>",
			wx: {
				appId: "<%=weixinConfig.getString("appId") %>", 
				timestamp: "<%=weixinConfig.getString("timestamp") %>", 
				nonceStr: "<%=weixinConfig.getString("nonceStr") %>", 
				signature: "<%=weixinConfig.getString("signature") %>"
			}
		}
  	</script>
	<script src="../../public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="../../public/js/config/lqt.js"></script>
	<script>seajs.use("../../public/js/profile/repair_detail.js");</script>
  </body>
</html>