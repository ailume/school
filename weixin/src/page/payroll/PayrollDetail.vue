<template>
  <div class="box" ref="boxHeight">
    <div class="back-div" ref="heightBack">
      <p @click="goBack()" class="up-back">返回</p>
    </div>
      <div class="payroll-div">
        <div class="payroll-title">
          <h1>
            <span>2018年</span>
            <a href="#">更换工资表</a>
          </h1>
        </div>
      </div>
      <ul class="payroll-list-d">
          <li>
            <span>基本工资</span>
            <i>¥ 12,580</i>
          </li>
          <li>
            <span>交通补贴</span>
            <i>¥ 580</i>
          </li>
          <li>
            <span>伙食补贴</span>
            <i>¥ 580</i>
          </li>
          <li>
            <span>职务工资-班主任如果太长换行显示太长换行效果如下</span>
            <i>¥ 2,580</i>
          </li>
          <li>
            <span>工作量-加班</span>
            <i>¥ 580</i>
          </li>
          <li>
            <span>工作量-出勤</span>
            <i>¥ 580</i>
          </li>
          <li>
            <span>扣除</span>
            <i>¥ - 580</i>
          </li>
      </ul>
      <div class="payroll-bottom">
        <p>
          <span>合计金额</span>
          <a href="#">¥ 125,800</a>
        </p>
      </div>
  </div>
</template>

<script type="es6">
  import Back from "../../components/common/Back.vue"
  import apiRouter from "../../config/api.js"
  export default {
    components: {
      Back
    },
    mounted(){

    },
    methods: {
      goBack(){
        window.location.replace(roterPath + "/weixin/wechat/dist/index.html")
      }      
  },
  data(){
    return {
      lastShow:false,
      wwwUrl:roterPath
    }
  }
  }
</script>

<style lang="less" type="text/less" scoped>
  @import '../../style/minxin.less';
  .back-div{
    padding-bottom: 100/@baseSize;
  }
  .up-back{
    width: 100%;
    height: 100/@baseSize;
    font-size:@fontSize36;
    line-height: 100/@baseSize;
    color: @white;
    text-align: center;
    position: fixed;
    top:0;
    left:0;
    background:rgba(0, 0, 0, 0.6);
    z-index: 999;
  }

  .payroll-div{
    padding-bottom: 100/@baseSize;
  }
  .payroll-title{
      width: 100%;
      height: 100/@baseSize;
      font-size:@fontSize36;
      line-height: 100/@baseSize;
      color: @white;
      text-align: center;
      position: fixed;
      top:100/@baseSize;
      left:0;
      z-index: 999;
  }
  .payroll-title h1{
    display: flex;
    justify-content: space-between;
    padding-left: 40/@baseSize;
    padding-right: 40/@baseSize;
    border-bottom: 1px solid #AAB2C0;
    box-sizing: border-box;
    background: #ffffff;
  }
   .payroll-title h1 span{
     color: #333333;
     font-size: @fontSize30;
   }
   .payroll-title h1 a{
     color: #48B319;
     font-size: @fontSize30;
   }
   .payroll-list-d{
     width: 100%;
     padding-bottom: 100/@baseSize;
   }
   .payroll-list-d li{
     display: flex;
    justify-content: space-between;
    padding-left: 40/@baseSize;
     padding-right: 40/@baseSize;
     box-sizing: border-box;
     padding-top: 20/@baseSize;
     padding-bottom: 20/@baseSize;
     flex-flow:row;
   }
   .payroll-list-d li:last-child i{
     font-size: @fontSize30;
      color: #E51C23;
   }
    .payroll-list-d li span{
      font-size: @fontSize30;
      color: #666666;
      width: 80%;
      overflow:hidden; 
      text-overflow:ellipsis;
      display:-webkit-box; 
      -webkit-box-orient:vertical;
      -webkit-line-clamp:2; 
    }
   .payroll-list-d li:nth-child(even){
     background: #F4F9EE;
   }

   .payroll-list-d li i{
     display: inline;
     font-style: normal;
   }

.payroll-bottom{
      width: 100%;
      height: 100/@baseSize;
      font-size:@fontSize36;
      line-height: 100/@baseSize;
      color: @white;
      text-align: center;
      position: fixed;
      bottom:0;
      left:0;
      z-index: 999;
      background: #ffffff;
}
   .payroll-bottom p{
     width: 100%;
     height: 100/@baseSize;
     display: flex;
     justify-content: space-between;
     align-items: center;
     border-top: 1px solid #AAB2C0;
     padding-left: 40/@baseSize;
     padding-right: 40/@baseSize;
     box-sizing: border-box;

   }
   .payroll-bottom p span,.payroll-bottom p a{
     font-size: @fontSize32;
    color: #666666;
   }

</style>
