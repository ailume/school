<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ page import="com.system.RedPointCache"%>
<%@ page import="com.app.ajax.weixin.repair.RepairAjax"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	DefaultPageAjax esapi = new DefaultPageAjax(request, response);
	//判断是否有报修管理功能
	RepairAjax repairAjax = new RepairAjax();
	String listType = esapi.getCleanParam("listType");
	listType = "2".equals(listType) && repairAjax.isRepairManager(user) ? "2" : "1";
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>报修列表</title>
    <link href="../../public/css/profile/list.css" rel="stylesheet" />
  </head>
  <body>
  	<a class="a-back" href="../profile/profile.jsp">返回个人中心</a>
  	<nav id="nav" style="display:none;">
  		<ul class="clearfix">
  			<li class="active"><a href="javascript:void(0)" status="all">全部</a></li>
  		<%if("1".equals(listType)){%>
  			<li><a href="javascript:void(0)" status="101">待受理</a></li>
  			<li><a href="javascript:void(0)" status="102">维修中</a></li>
  			<li><a href="javascript:void(0)" status="103">需确认</a></li>
  			<li><a href="javascript:void(0)" status="104">已完成</a></li>
  		<%}else {%>
  			<li><a href="javascript:void(0)" status="201">需受理</a></li>
  			<li><a href="javascript:void(0)" status="202">需完工</a></li>
  			<li><a href="javascript:void(0)" status="203">需确认</a></li>
  			<li><a href="javascript:void(0)" status="204">已完成</a></li>
  		<%}%>
  			<li class="bg"></li>
  		</ul>
  	</nav>
  	<div class="lqt-wrapper">
  		<ul class="lqt-list" id="repair_list" data-page="1">
			<!-- 报修 -->
		</ul>
		<div id="more"><div id="loading"><span class="scale-point active-1 scalePoint"></span><span class="scale-point active-2 scalePoint"></span><span class="scale-point active-3 scalePoint"></span><span class="pullTxt">正在加载中</span></div></div>
  	</div>
<%if("1".equals(listType)){%>
	<a id="floatWindow" href="repair_form.jsp"><span>我要<br>报修</span></a>
<%}%>
  	<script>
  		var g_config = {
  			jsBasePath: '',
  			jsVersion: '',
  			pageType: 'repair_list',
  			pageName: 'repair_list',
  			listType: <%=listType %>
  		};
  	</script>
	<script src="../../public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="../../public/js/config/lqt.js"></script>
	<script>seajs.use("../../public/js/list/list.js");</script>
  </body>
</html>