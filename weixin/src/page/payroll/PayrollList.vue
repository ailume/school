<template>
  <div class="box" ref="boxHeight">
    <div class="back-div" ref="heightBack">
      <p @click="goBack()" class="up-back">返回</p>
    </div>
    
    <div class="lisnem">
       <div class="payroll-div">
        <div class="payroll-title">
          <h1>
            <span>2017年全年</span>
            <a href="javascript:;">
              <x-address 
                @on-hide="logHide" 
                @on-show="logShow" 
                :title="title" 
                v-model="value" 
                :list="addressData" 
                @on-shadow-change="onShadowChange" 
                :show.sync="showAddress"
                >
                </x-address>
            </a>
          </h1>
        </div>
    </div>
    <ul class="payroll-list">
          <li @click="goToDetail">
            <span>1月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>2月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>3月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>4月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>5月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>6月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>7月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>8月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>9月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>10月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>11月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>12月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>10月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>11月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>12月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>10月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>11月</span>
            <span>¥ 12,580</span>
          </li>
          <li>
            <span>12月</span>
            <span>¥ 12,580</span>
          </li>

        </ul>
        <div class="payroll-bottom">
          <p>
            <span>合计金额</span>
            <a href="#">¥ 125,800</a>
          </p>
        </div> 
    </div>



    <div class="empty" style="display:none">
      <img src="../../assets/emission.png" alt="">
      <span>暂时还没有相关信息哟〜</span>
    </div>
  
    

  </div>



</template>

<script type="es6">
  import Back from "../../components/common/Back.vue"
  import apiRouter from "../../config/api.js"
   import {getSelectDates} from '../../utils/DateUtils';
  import { Group, XAddress, ChinaAddressV4Data, XButton, Cell, Value2nameFilter as value2name } from 'vux'
  export default {
    components: {
      Back,
      Group,
    XAddress,
    XButton,
    Cell
    },
    mounted(){

    },
    data(){
      return {
        lastShow:false,
        wwwUrl:roterPath,

        title: '更换工资表',
        value_0_1: [],
        value: [],
        title2: '设置值',
        value2: ['天津市', '市辖区', '和平区'],
        value3: ['广东省', '中山市', '--'],
        addressData: ChinaAddressV4Data,
        value4: [],
        value5: ['广东省', '深圳 市', '南山区'],
        showAddress: false
      }
    },
    methods: {
      goBack(){
        window.location.replace(roterPath + "/weixin/wechat/dist/index.html")
      },
      goToDetail(){
        this.$router.push({ path: "payrolldetail" });
      },
      

      doShowAddress () {
      this.showAddress = true
      setTimeout(() => {
        this.showAddress = false
      }, 2000)
    },
    onShadowChange (ids, names) {
      console.log(ids, names)
    },
    changeData () {
      this.value2 = ['430000', '430400', '430407']
    },
    changeDataByLabels () {
      this.value2 = ['广东省', '广州市', '天河区']
    },
    changeDataByLabels2 () {
      this.value2 = ['广东省', '中山市', '--']
    },
    getName (value) {
      return value2name(value, ChinaAddressV4Data)
    },
    logHide (str) {
      console.log('on-hide', str)
    },
    logShow (str) {
      console.log('on-show')
    }
      
  }
  }
</script>

<style lang="less" type="text/less" scoped>
  @import '../../style/minxin.less';
  .box{
    height: 100%;
  }
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
   .payroll-list{
     width: 100%;
     padding-bottom: 100/@baseSize;
   }
   .payroll-list li{
     display: flex;
    justify-content: space-between;
    line-height: 90/@baseSize;
    padding-left: 40/@baseSize;
     padding-right: 40/@baseSize;
     box-sizing: border-box;
   }
    .payroll-list li span{
      font-size: @fontSize30;
      color: #666666;
    }
   .payroll-list li:nth-child(even){
     background: #F4F9EE;
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

   .empty{
     display: flex;
     justify-content: center;
     align-content: center;
     flex-direction: column;
     align-items: center;
     height: calc(100% - 500/@baseSize);
   }


    .empty img{
      width: 208/@baseSize;
      display: block;
    }
    
  .empty span{
    padding-top: 74/@baseSize;
    font-size:  @fontSize30;
    color: #666666;
  }

  .payroll-title .weui-cell{
    padding: 0;
  }

  
</style>
