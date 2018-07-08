<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ include file="/weixin/common/checkLogin.jsp" %>
<%
	JSONObject weixinConfig = esapiPage.getWeixinConfig(request, user.getSchoolId());
%>
<!DOCTYPE HTML5>
<html>
  <head>
  	<meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
    <title>一卡通充值</title>
    <link href="../../public/css/profile/list.css" rel="stylesheet" />
    <link href="../../public/css/card/weui.min.css" rel="stylesheet" />
    <link href="../../public/css/card/jquery-weui.min.css" rel="stylesheet" />
  </head>
  <body>
  	<a class="a-back" href="../profile/profile.jsp">返回个人中心</a>
  	<div class="lqt-wrapper">
        <div id="cardInfo" class="weui-panel__bd" style="background:#fff;margin:.3rem 0 .5rem 0">
          	<div class="weui-media-box weui-media-box_text">
            	<p class="weui-media-box__desc" style="color:#000000;font-size:.5rem;"><span class="number">*********</span></p>
            	<p class="weui-media-box__desc" style="margin-top:.1rem;color:#48B319;"><span class="schName">*********学校</span> - <span class="name">***</span></p>
          	</div>
          	<div class="weui-media-box weui-media-box_text cardMoney">
            	<p class="weui-media-box__desc" style="text-align:center;font-size:.5rem;color:#48B319;">余额：<span class="money">*.**</span>元</p>
          	</div>
          	<div class="weui-media-box weui-media-box_text cardPay" style="display:none;">
            	<p class="weui-media-box__desc" style="margin-bottom:.3rem">充值金额</p>
            	<div class="weui-flex">
			      	<div class="weui-flex__item" style="margin: 0 .1rem 0 .1rem;">
			      		<button type="button" name="btn_lqtpay" class="weui-btn weui-btn_default" paycode="LQT_YKT_30">30元</button>
			      	</div>
			      	<div class="weui-flex__item" style="margin: 0 .1rem 0 .1rem;">
			      		<!-- <button type="button" name="btn_lqtpay" class="weui-btn weui-btn_primary" paycode="LQT_YKT_5000">50元</button> -->
			      		<button type="button" name="btn_lqtpay" class="weui-btn weui-btn_default" paycode="LQT_YKT_50">50元</button>
			      	</div>
			      	<div class="weui-flex__item" style="margin: 0 .1rem 0 .1rem;">
			      		<button type="button" name="btn_lqtpay" class="weui-btn weui-btn_default" paycode="LQT_YKT_100">100元</button>
			      	</div>
			   	</div>
			    <div class="weui-flex" style="margin-top:.2rem;">
			    	<div class="weui-flex__item" style="margin: 0 .1rem 0 .1rem;">
			      		<button type="button" name="btn_lqtpay" class="weui-btn weui-btn_default" paycode="LQT_YKT_200">200元</button>
			      	</div>
			      	<div class="weui-flex__item" style="margin: 0 .1rem 0 .1rem;">
			      		<button type="button" name="btn_lqtpay" class="weui-btn weui-btn_default" paycode="LQT_YKT_300">300元</button>
			      	</div>
			      	<div class="weui-flex__item" style="margin: 0 .1rem 0 .1rem;">
			      		<button type="button" name="btn_lqtpay" class="weui-btn weui-btn_default" paycode="LQT_YKT_500">500元</button>
			      	</div>
			    </div>
          	</div>
        </div>
        <div class="cardMoney" style="padding:0 .2rem .2rem .2rem;">
       		<button type="button" name="btnGoPay" class="weui-btn weui-btn_primary">充值</button>
        </div>
        <div class="cardPay" style="padding:0 .2rem .2rem .2rem;display:none;">
       		<button type="button" name="btnWXPay" class="weui-btn weui-btn_primary">提交</button>
       		<button type="button" name="btnBackPay" class="weui-btn weui-btn_default">取消</button>
        </div>
  	</div>
  	<script>
  		var g_config = {
  			jsBasePath: '',
  			jsVersion: '',
  			pageType: 'card',
  			pageName: 'card_pay', 
  			wx: {
  				appId: "<%=weixinConfig.getString("appId") %>", 
	  			timestamp: "<%=weixinConfig.getString("timestamp") %>", 
	  			nonceStr: "<%=weixinConfig.getString("nonceStr") %>", 
	  			signature: "<%=weixinConfig.getString("signature") %>", 
	  			openId: "<%=user.getOpenId() %>"
  			}
  		};
  	</script>
	<script src="../../public/js/lib/seajs/seajs/2.3.0/sea.js"></script>
	<script src="../../public/js/config/lqt.js"></script>
	<script>seajs.use("../../public/js/card/pay.js");</script>
  </body>
</html>