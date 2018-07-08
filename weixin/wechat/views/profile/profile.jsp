<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.system.RedPointCache"%>
<%@ page import="com.app.ajax.weixin.HomeWorkAjax"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	//加载用户红点信息
	RedPointCache redPoint = RedPointCache.getInstance();
	redPoint.search(user);
	//判断用户个人图标
	String navType = "teacher";
	if("T_STUDENT".equals(user.getUserType())){
		navType = "student";
	}else if("T_PARENT".equals(user.getUserType())){
		navType = "parents";
	}
	//其他红点提醒模块
	JSONObject notice = redPoint.getMyWeixinShiwu(user.getUserId(), user.getStudentId());
	HomeWorkAjax hwa = new HomeWorkAjax();
	String homeworkNew = !"T_TEACHER".equals(user.getUserType()) && hwa.getNewHomeWorkCount(user) > 0 ? "new" : "";
	String examenNew = notice.getInt(RedPointCache.TYPECODE_EXAMEN) > 0 ? "new" : "";
	String voteNew = notice.getInt(RedPointCache.TYPECODE_VOIT) > 0 ? "new" : "";
	String repairNew = notice.getInt(RedPointCache.TYPECODE_REPAIR) > 0 ? "new" : "";
	String repairDeptNew = user.isRepairManager() && redPoint.getDeptRepairCount(user.getUserId()) > 0 ? "new" : "";
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>个人中心</title>
    <link href="../../public/css/profile/profile.css" rel="stylesheet" />
    <style type="text/css">
   	.list li[type=card] figure:before {
	    background-color: #90ED7D;
	    background-image: url("<%=ROOTPath %>/weixin/wechat/public/images/icon/card.png");
	}
    </style>
  </head>
  <body>
  	<div class="lqt-wrapper">
  		<nav nav-type="<%=navType %>" id="lqt-nav">
  			<ul class="clearfix">
  				<li><a href="../school/home.html?type=zone">空间</a></li>
  				<li><a href="../school/home.html?type=notice">通知</a></li>
  				<li class="active"><a href="profile.jsp">我的<em class="icon"></em></a></li>
  			</ul>
  		</nav>
  		<div class="lqt-content">
	  		<section class="lqt-myapp">
	  			<p class="lqt-title">我的应用</p>
	  			<ul class="list clearfix">
  				<%if(!"T_TEACHER".equals(user.getUserType())){%>
  					<li class="<%=homeworkNew %>" type="homework">
  						<a href="../homework/index.html">
		  					<figure>
		  						<figcaption>作业</figcaption>
		  					</figure>
	  					</a>
	  				</li>
  				<%}%>
  				<%if(!"T_TEACHER".equals(user.getUserType())){%>
  					<li class="" type="score">
	  					<a href="../results/index.html">
		  					<figure>
		  						<figcaption>成绩</figcaption>
		  					</figure>
	  					</a>
	  				</li>
  				<%}%>
	  				<li class="<%=examenNew %>" type="ques">
	  					<a href="qa_list.html">
		  					<figure>
		  						<figcaption>问卷</figcaption>
		  					</figure>
	  					</a>
	  				</li>
	  				<li class="<%=voteNew %>" type="vote">
	  					<a href="vote_list.html">
		  					<figure>
		  						<figcaption>投票</figcaption>
		  					</figure>
	  					</a>
	  				</li>
	  			<%if(!"T_PARENT".equals(user.getUserType())){%>
	  				<li class="<%=repairNew %>" type="fix">
	  					<a href="repair_list.jsp?listType=1">
		  					<figure>
		  						<figcaption>报修</figcaption>
		  					</figure>
	  					</a>
	  				</li>
	  			<%}%>
	  			<%if(user.useYKTWXPay()){%>
	  				<li class="" type="card">
	  					<a href="../card/pay.jsp">
		  					<figure>
		  						<figcaption>一卡通</figcaption>
		  					</figure>
	  					</a>
	  				</li>
	  			<%}%>
	  			</ul>
	  		</section>
	  	<%if(user.isRepairManager()){%>
	  		<section class="lqt-manage">
	  			<p class="lqt-title">我的管理</p>
	  			<ul class="list clearfix">
	  				<li class="<%=repairDeptNew %>" type="fix">
	  					<a href="repair_list.jsp?listType=2">
		  					<figure>
		  						<figcaption>报修处理</figcaption>
		  					</figure>
	  					</a>
	  				</li>
	  			</ul>
	  		</section>
	  	<%}%>
  		</div>
  	</div>
  	<script type="text/javascript">
  		var g_config = {
  			jsBasePath: '',
  			jsVersion: '',
  			pageType: 'profile'
  		};
  		document.documentElement.style.fontSize = (document.body.clientWidth*100)/750;
  	</script>
  </body>
</html>