<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.lineteam.ajax.DefaultPageAjax"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>作业</title>
    <link href="../public/css/homework/detail1.css" rel="stylesheet" />
  </head>
  <body>
  	<div class="lqt-container" id="scorll">
  		<div>
  			<div class="homework-container" id="headerBox" style="width:320px;">
  				<ul class="homework-list clearfix header-banner" id="bannerBox">
  					<!-- 多选 -->
  					<li class="it banner-sheet" data-type="checkbox">
  						<div class="homework-tips clearfix">
  							<div class="tips-content">
  								<p>【物理 课后作业】</p>
  								<p>法拉第电磁感应定律1</p>
  							</div>
  							<span class="homework-deadline">09-30 截止</span>
						</div>
						<div class="homework-content">
							<p class="homework-title">1.［多选题］穿过一个电阻为 R=1欧姆的单匝闭合线圈的磁通量始终每秒钟均匀的减少2Wb ，则：</p>
							<ul class="homework-answer select-data">
								<li class="answer clearfix" id="11">
									<label>
									<span class="icon-common icon-checkbox"><input class="selectBox" type="checkbox" name="checkbox" /><span class="icon-checkbox-point">&#x002c;</span></span>
									<span class="answer-content">A 线圈中的感应感应电动势感</span>
									</label>
								</li>
								<li class="answer clearfix" id="12">
									<label>
									<span class="icon-common icon-checkbox"><input class="selectBox" type="checkbox" name="checkbox" /><span class="icon-checkbox-point">&#x002c;</span></span>
									<span class="answer-content">B 线圈中的感应感应电动势感应电</span>
									</label>
								</li>
							</ul>
						</div>
						<input id="1" class="answer-data" type="hidden" /><!-- id：题目id -->
  					</li>
  					<!-- 多选end -->
  					<!-- 单选 -->
  					<li class="it banner-sheet" data-type="radio">
						<div class="homework-content">
							<p class="homework-title">2.［单选题］穿过一个电阻为 R=1欧姆的单匝闭合线圈的磁通量始终b ，则：</p>
							<ul class="homework-answer select-data">
								<li class="answer clearfix" id="21">
									<label>
									<span class="icon-common icon-radio"><input class="selectBox" type="radio" name="radio2" /><span class="icon-radio-point"></span></span>
									<span class="answer-content">A 线圈中的感应感应电动势感</span>
									</label>
								</li>
								<li class="answer clearfix" id="22">
									<label>
									<span class="icon-common icon-radio"><input class="selectBox" type="radio" name="radio2" /><span class="icon-radio-point"></span></span>
									<span class="answer-content">B 线圈中的感应感应电动势感应电</span>
									</label>
								</li>
								<li class="answer clearfix" id="23">
									<label>
									<span class="icon-common icon-radio"><input class="selectBox" type="radio" name="radio2" /><span class="icon-radio-point"></span></span>
									<span class="answer-content">C 线圈中的感应感应电动势感应电</span>
									</label>
								</li>
							</ul>
						</div>
						<input id="2" class="answer-data" type="hidden" /><!-- id：题目id -->
  					</li>
  					<!-- 单选end -->
  					<!-- 问答题 -->
  					<li class="it banner-sheet sheet-qs" data-type="qs" id="3"><!-- id：题目id -->
						<div class="homework-content">
							<p class="homework-title">3.穿过一个电阻为 R=1欧姆的单匝闭合线 圈的磁通量始终每秒钟均匀的减少2Wb ， 则：</p>
							<ul class="homework-answer">
								<li class="answer-qs qs-txt">
									<textarea class="qs-data qs-content" name="content" onpropertychange="this.style.height=this.scrollHeight + 'px'" oninput="this.style.height=this.scrollHeight + 'px'"></textarea>
								</li>
								<li class="answer-qs qs-img qs-delete" data-type="img">
									<img src="http://img0.bdstatic.com/img/image/shouye/chongwu1028.jpg" />
									<input class="qs-data" name="img" type="hidden" value="http://img0.bdstatic.com/img/image/shouye/chongwu1028.jpg" />
								</li>
								<li class="answer-qs qs-img qs-delete" data-type="img">
									<img src="http://img0.bdstatic.com/img/image/shouye/chongwu1023.jpg" />
									<input class="qs-data" name="img" type="hidden" value="http://img0.bdstatic.com/img/image/shouye/chongwu1023.jpg" />
								</li>
								<li class="answer-qs qs-voice it-m qs-delete clearfix" data-type="voice">
									<a class="btn-play" href="javascript:void(0)">
		  								<span class="lqt-arrow">
		  									<em class="arrow-in">◆</em>
		  									<em class="arrow-out">◆</em>
		  								</span>
		  								<span class="qs-voice-icon">&#x0026;</span>
		  								<audio src="../public/media/fqs.mp3">
										Your browser does not support the audio tag.
										</audio>
									</a>
									<input class="qs-data" name="voice" type="hidden" value="../public/media/fqs.mp3" />
				  				</li>
								<li class="answer-qs qs-voice it-m qs-delete clearfix" data-type="voice">
									<a class="btn-play" href="javascript:void(0)">
		  								<span class="lqt-arrow">
		  									<em class="arrow-in">◆</em>
		  									<em class="arrow-out">◆</em>
		  								</span>
		  								<span class="qs-voice-icon">&#x0026;</span>
		  								<audio src="../public/media/Never Had A Dream Come True.mp3">
										Your browser does not support the audio tag.
										</audio>
									</a>
									<input class="qs-data" name="voice" type="hidden" value="../public/media/Never Had A Dream Come True.mp3" />
				  				</li>
							</ul>
						</div>
		  				<div class="qs-bar clearfix">
		  					<p><a class="bar-btn btn-img" href="javascript:void(0)">&#x0028;</a></p>
		  					<p><a class="bar-btn btn-voice" href="javascript:void(0)">&#x0027;</a></p>
		  				</div>
  					</li>
  					<!-- 问答题end -->
  					<!-- 问答题 -->
  					<li class="it banner-sheet sheet-qs" data-type="qs" id="4"><!-- id：题目id -->
						<div class="homework-content">
							<p class="homework-title">3.穿过一个电阻为 R=1欧姆的单匝闭合线 圈的磁通量始终每秒钟均匀的减少2Wb ， 则：</p>
							<ul class="homework-answer">
								<li class="answer-qs qs-txt">
									<textarea class="qs-data qs-content" name="content" onpropertychange="this.style.height=this.scrollHeight + 'px'" oninput="this.style.height=this.scrollHeight + 'px'"></textarea>
								</li>
								<li class="answer-qs qs-img qs-delete" data-type="img">
									<img src="http://img0.bdstatic.com/img/image/shouye/fengjing1028.jpg" />
									<input class="qs-data" name="img" type="hidden" value="http://img0.bdstatic.com/img/image/shouye/fengjing1028.jpg" />
								</li>
								<li class="answer-qs qs-img qs-delete" data-type="img">
									<img src="http://img0.bdstatic.com/img/image/shouye/jiguang1028.jpg" />
									<input class="qs-data" name="img" type="hidden" value="http://img0.bdstatic.com/img/image/shouye/jiguang1028.jpg" />
								</li>
								<li class="answer-qs qs-voice it-m qs-delete clearfix" data-type="voice">
									<a class="btn-play" href="javascript:void(0)">
		  								<span class="lqt-arrow">
		  									<em class="arrow-in">◆</em>
		  									<em class="arrow-out">◆</em>
		  								</span>
		  								<span class="qs-voice-icon">&#x0026;</span>
		  								<audio src="../public/media/Arriettys Song.mp3">
										Your browser does not support the audio tag.
										</audio>
									</a>
									<input class="qs-data" name="voice" type="hidden" value="../public/media/Arriettys Song.mp3" />
				  				</li>
								<li class="answer-qs qs-voice it-m qs-delete clearfix" data-type="voice">
									<a class="btn-play" href="javascript:void(0)">
		  								<span class="lqt-arrow">
		  									<em class="arrow-in">◆</em>
		  									<em class="arrow-out">◆</em>
		  								</span>
		  								<span class="qs-voice-icon">&#x0026;</span>
		  								<audio src="../public/media/Never say never.mp3">
										Your browser does not support the audio tag.
										</audio>
									</a>
									<input class="qs-data" name="voice" type="hidden" value="../public/media/Never say never.mp3" />
				  				</li>
							</ul>
						</div>
		  				<div class="qs-bar clearfix">
		  					<p><a class="bar-btn btn-img" href="javascript:void(0)">&#x0028;</a></p>
		  					<p><a class="bar-btn btn-voice" href="javascript:void(0)">&#x0027;</a></p>
		  				</div>
  					</li>
  					<!-- 问答题end -->
  				</ul>
  			</div>
  		</div>
  	</div>
  	<div class="homework-bar clearfix" id="bar">
  		<a class="homework-btn homework-pre clearfix" href="javascript:void(0)">
  			<em class="icon-change icon-pre">&#x0025;</em><span class="txt-change">上一题</span>
		</a>
  		<a class="homework-btn homework-next clearfix" href="javascript:void(0)">
  			<span class="txt-change">下一题</span><em class="icon-change icon-next">&#x0025;</em>
		</a>
  		<a class="homework-btn homework-submit clearfix" href="javascript:void(0)">
  			<span class="txt-submit">提交作业</span>
		</a>
		<span class="pre-loc"></span>
  	</div>
  	<script>
  		var g_config = {
  			jsBasePath: '',
  			jsVersion: '',
  			pageType: 'homeworkDetail',
  			id: '6666',//作业id
  		};
  	</script>
	<script src="../public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="../public/js/config/lqt.js"></script>
	<script>seajs.use("../public/js/homework/detail.js");</script>
  </body>
</html>