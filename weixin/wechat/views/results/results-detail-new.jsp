<%@page import="com.param.DBParam"%>
<%@page import="com.app.bussiness.BrowseLogUtils"%>
<%@page import="com.ajax.department.jiaow.NewExam.count.StudentZong"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.app.ajax.ResultsAjax"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ include file="/inc/begin.inc" %>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	ResultsAjax esapi = new ResultsAjax(request, response);
	String examId = esapi.getRawParam("resultsId");
	String realExamId = IdEncodingUtil.decode(examId);
	StudentZong zongPage = new StudentZong();
	//综合分析考试科目
	String studentId = "T_PARENT".equals(user.getUserType()) ? user.getStudentId() : user.getUserId();
	JSONArray courseArray = zongPage.getStudentCourse(user.getSchoolId(), realExamId, studentId);
	if(courseArray == null || courseArray.isEmpty()){
		response.sendRedirect(ROOTPath+"/weixin/error/notFound.html");
		return;
	}
	//指定的科目ID
	String courseId = esapi.getRawParam("courseId");
	String courseName = "";
	if("".equals(courseId)){
		courseId = courseArray.getJSONObject(0).getString("COURSE_ID");
		courseName = courseArray.getJSONObject(0).getString("COURSE_NAME");
	}
	//图表数据
	JSONObject chartData = zongPage.getStudentData(user.getSchoolId(), realExamId, courseId, studentId);
	//添加浏览记录
	try{
		BrowseLogUtils.addLog(DBParam.getLqteduDB(), user, realExamId, BrowseLogUtils.RESULTS_INFO);
	}catch(Exception e){
	}
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>成绩分析</title>
    <link href="../../public/css/results/detail.css" rel="stylesheet" />
  </head>
  <body>
  	<a class="a-back" href="index.html">返回成绩</a>
  	<nav id="nav">
  		<ul class="clearfix">
  		<%for(int i=0; i<courseArray.size(); i++){
  			JSONObject cJSON=courseArray.getJSONObject(i);
  			String cId=cJSON.getString("COURSE_ID");
  			String cName=cJSON.getString("COURSE_NAME");
  			String active = "";
  			if(courseId.equals(cId)){
  				active = "active";
  				courseName = cName;
  			}else {
  				active = "";
  			}
  			%>
  			<li class="<%=active %>"><a href="results-detail-new.jsp?resultsId=<%=examId %>&courseId=<%=cId %>"><%=cName %></a></li>
  		<%}%>
  			<li class="bg"></li>
  		</ul>
  	</nav>
  	<div class="lqt-wrapper" id="new">
		<div class="detail-container">
			<div id="viewFirst" style="height:80%;width:100%;"></div>
		</div>
	</div>
	<script src="../../public/js/lib/jquery/jquery-1.9.1.min.js"></script>
	<script src="../../public/js/lib/highcharts/adapters/standalone-framework.js"></script>
    <script src="../../public/js/lib/highcharts/highcharts.js"></script>
    <script src="../../public/js/lib/highcharts/highcharts-more.js"></script>
    <script>
		$(function(){
			var $nav = $('#nav'),
				$li = $nav.find('li');
			var _len = $nav.find('li').length;
			$nav.find('ul').width($li.width()*(_len-1));
			$nav.show();
			console.log($nav.find('li.active').position().left)
			$('#nav').scrollLeft($nav.find('li.active').position().left);
			$nav.find('.bg').css('left', $li.width()*$nav.find('li.active').index());
		});
    	var coursename = "<%=courseName %>";
    	var score = <%=chartData.getJSONObject("score").toString() %>;
    	var template = <%=chartData.getJSONArray("template").toString() %>;
   		var initChart = function (score, template, coursename){
			//trace(score);trace(template);
			var colors = ["#50B432", "#058DC7", "#DDDF00", "#ED561B"];
			var viewFirst = {
				"name":"<%=chartData.getString("examName") %><%if("T_PARENT".equals(user.getUserType())){%>（<%=user.getStudentName() %>）<%}%>"+" "+coursename,
				"subname":"科目综合评价 "+score["CLASS_NAME"]+score["STU_NAME"],
				"categories":[],
				"series":{
		        	name: "大版块详情",
		            data: [],
		            color: "#ED561B"
		        }
			}
			for(var i=0; i<template.length; i++){
				var dt = template[i];
				var dtCode = dt["CODE"];
				var dtName = dt["NAME"];
				var dtScore = score[dtCode+"_SCORE"];
				var dtLevel = score[dtCode];
				var dtLevelName = score[dtCode+"_NAME"];
				var xtArray = dt["XIAOTI"];
				viewFirst["categories"][i] = "【"+dtName+"】"+dtLevelName;
				var drill = {
		            "name":viewFirst["name"]+"-【"+dtName+"】版块",
		            "subname":viewFirst["subname"],
		            "categories": [],
		            "series":{
			        	name: "",
			            data: [],
			            color: "#ED561B"
			        }
	           	}
				for(var j=0; j<xtArray.length; j++){
					var xt=xtArray[j];
					var xtCode = xt["CODE"];
					var xtName = xt["NAME"];
					var xtScore = score[dtCode+"_"+xtCode+"_SCORE"];
					var xtLevel = score[dtCode+"_"+xtCode];
					var xtLevelName = score[dtCode+"_"+xtCode+"_NAME"];
					drill["categories"][j] = "【"+dtName+"】-"+xtName+" "+xtLevelName;
					drill["series"]["name"] = "【"+dtName+"】-子版块详情";
					drill["series"]["data"][j] = {
						y: xtScore,
						color: colors[xtLevel-1]
					}
				}
				drill["categories"][xtArray.length] = "【"+dtName+"】-总评 "+dtLevelName;
				drill["series"]["data"][xtArray.length] = {
					y: dtScore,
					color: colors[dtLevel-1]
				};
				viewFirst["series"]["data"][i] = {
					y: dtScore,
					color: colors[dtLevel-1],
					drilldown: drill
				};
			}
			if(score["ZONG"]){
				viewFirst["categories"][template.length] = "科目总评 "+score["ZONG_NAME"];
				viewFirst["series"]["data"][template.length] = {
					y: score["ZONG_SCORE"],
					color: colors[score["ZONG"]-1]
				}
			}
			//点击切换图
			var setChart = function (name, subname, categories, series){
				firstChart.setTitle({"text":name}, {"text":subname}, false);
				firstChart.xAxis[0].setCategories(categories, false);
				firstChart.series[0].remove(false);
				firstChart.addSeries(series);
				firstChart.redraw();
			}
			var firstChart = new Highcharts.Chart({
				chart: {
		          	renderTo: "viewFirst",
		          	type: "column",
		    		plotBorderColor: "#999",
		    		plotBorderWidth: 0
		        },
		        title: {
		            text: viewFirst["name"]
		        },
		        subtitle: {
		            text: viewFirst["subname"]
		        },
		        xAxis: {
		            categories: viewFirst["categories"],
		            labels:{
		            	rotation: -45
	               	}
		        },
		        yAxis: {
		            min: 0,
		            labels: {
		            	enabled: false
		            },
		            title: {
		                text: ""
		            },
		            lineWidth: 0,
		            tickWidth: 0
		        },
		        credits: {
		    		enabled:false
		    	},
		        plotOptions: {
		            column: {
		                point: {
		                    events: {
		                        click: function() {
		                            var drilldown = this.drilldown;
		                            if (drilldown) { // drill down
		                                setChart(drilldown.name, drilldown.subname, drilldown.categories, drilldown.series);
		                            } else { // restore
		                                setChart(viewFirst["name"], viewFirst["subname"], viewFirst["categories"], viewFirst["series"]);
		                            }
		                        }
		                    }
		                },
		                cursor: 'pointer',
		                dataLabels: {
		                    enabled: false,
		                }
		            }
		        },
		        tooltip: {
		            formatter: function() {
		            	var point = this.point;
		            	if(point.drilldown){
		            		return "<b>"+this.x+"，<br/>点击查看版块详情。</b>";
		            	}else {
		            		return "<b>"+this.x+"</b>";
		            	}
		            }
		        },
		        series: [viewFirst["series"]]
			});
		};
		initChart(score, template, coursename);
    </script>
  </body>
</html>
<%@ include file="/inc/end.inc" %>