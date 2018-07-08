<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.app.ajax.ResultsAjax"%>
<%@ page import="com.app.common.AppUser"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	ResultsAjax esapi = new ResultsAjax(request, response);
	String examId = esapi.getRawParam("resultsId");
	JSONObject chartJSON = esapi.getResultChartJSON(user, IdEncodingUtil.decode(examId));
	JSONObject userPower = esapi.getChartsConfig(user, examId);
	if(chartJSON.isEmpty()){
		response.sendRedirect(ROOTPath+"/weixin/error/notFound.html");
		return;
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
  	<div class="lqt-wrapper">
		<div class="detail-container">
			<p class="results-title">&nbsp;&nbsp;<%=chartJSON.getString("examName") %><%if("T_PARENT".equals(user.getUserType())){%>（<%=user.getStudentName() %>）<%}%></p>
			<div id="viewFirst" style="height:80%;width:100%;"></div>
			<%=chartJSON.getString("chartOneDesc") %>
			<div id="viewSecond" style="height:80%;width:100%;margin-top:10px;"></div>
			<%=chartJSON.getString("chartTwoDesc") %>
		</div>
	</div>
	<script src="../../public/js/lib/highcharts/adapters/standalone-framework.js"></script>
    <script src="../../public/js/lib/highcharts/highcharts.js"></script>
    <script src="../../public/js/lib/highcharts/highcharts-more.js"></script>
    <script>
   		var colors = ["#058DC7", "#50B432", "#ED561B", "#DDDF00", "#24CBE5", "#64E572", "#FF9655", "#FFF263", "#6AF9C4", "#A757A8"];
      	var viewFirst = new Highcharts.Chart({
			chart: {
	          	renderTo: "viewFirst",
	          	type: "column",
	    		plotBorderColor: "#999",
	    		plotBorderWidth: 0
	        },
	        title: {
				text: "科目实力图"
		    },
		<%if(userPower.containsKey("APP_SCOREINFO") && userPower.getBoolean("APP_SCOREINFO")){%>
			yAxis: {
	            min: 0,
	            title: {
	                text: ""
	            }
	        },
	        tooltip: {
	        	formatter: function() {
	            	var point = this.point;
	                return this.x +":"+this.y+"%</b>";
	            }
	        },
		<%}else {%>
			yAxis: {
	            min: 0,
	            title: {
	                text: ""
	            },
	            labels: {
	            	enabled: false
	            },
	            lineWidth: 0, 
	            tickWidth: 0
	        },
	        tooltip: {
	        	enabled: false
	        },
		<%}%>		    
		    xAxis: {
	            categories: <%=chartJSON.getJSONArray("categories").toString() %>
	        },
	        credits: {
	    		enabled:false
	    	},
	    	legend: {
	            layout: 'vertical',
	            align: 'right',
	            verticalAlign: 'top',
	            x: -10,
	            y: 45,
	            floating: true,
	            borderWidth: 1,
	            backgroundColor: '#FFFFFF'
	        },
	        series: [{
	         	name: "班内实力",
	          	data: <%=chartJSON.getJSONArray("chartOneData").toString() %>
	        }]
		});
      	var viewSecond = new Highcharts.Chart({
		    chart: {
		    	renderTo: "viewSecond",
		        polar: true,
		        type: "line", 
		        plotBorderColor: "#999",
	    		plotBorderWidth: 0
		    },
		    credits: {
	    		enabled:false
	    	},
		    colors: colors,
		    pane: {
		    	size: '80%'
		    },
		    legend: {
	            layout: 'vertical',
	            align: 'right',
	            verticalAlign: 'top',
	            x: -10,
	            y: 45,
	            floating: true,
	            borderWidth: 1,
	            backgroundColor: '#FFFFFF'
	        },
		    title: {
		        text: "科目雷达图"
		    },
		    xAxis: {
		        categories: <%=chartJSON.getJSONArray("categories").toString() %>,
		        tickmarkPlacement: 'on',
		        lineWidth: 0
		    },
	   	<%if(userPower.containsKey("SCORE_T") && userPower.getBoolean("SCORE_T")){%>
			yAxis: {
				gridLineInterpolation: 'polygon',
		        lineWidth: 0,
		        min: 0
	        },
	        tooltip: {
	        	formatter: function () {
	        		return this.x+'标准分<br/><b>'+this.series.name+'：'+this.y+'</b>';
	            }
	        },
		<%}else {%>
			yAxis: {
		        gridLineInterpolation: 'polygon',
		        lineWidth: 0,
		        min: 0
		    },
		    tooltip: {
	        	enabled: false
	        },
		<%}%>
		    series: <%=chartJSON.getJSONArray("chartTwoData").toString() %>
		});
    </script>
  </body>
</html>
