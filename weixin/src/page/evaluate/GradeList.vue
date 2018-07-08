<template>
  <div class="box">
    <div class="back-div">
      <p @click="goBack()" class="up-back">返回</p>
    </div>
    <div class="context clearfix">
      <h3 class="title">请选择需要评价{{nameBt}}的班级</h3>
      <ul class="maple-info">
        <li @click="remarkInfo(item.ID,item.NAME)" v-for="(item,index) in getGradeData" :key="index">
          <span>{{item.NAME}}</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
  import Back from "../../components/common/Back.vue"
  import apiRouter from "../../config/api.js"
  export default {
    components: {
      Back
    },
    mounted(){

    },
    activated(){
      this.evalId = this.$route.query.evalId
      this.detailCode = this.$route.query.detailCode
      this.nameBt = this.$route.query.nameBt
      this.getGradeWay()
    },

    methods: {
      getGradeWay(){
          console.log(apiRouter.GET_CLASSBYCODE + "evalId=" + this.evalId + "&detailCode=" + this.detailCode)
        this.$http.get(apiRouter.GET_CLASSBYCODE + "evalId=" + this.evalId + "&detailCode=" + this.detailCode)
          .then((response) => {
            if( response.body.status === 200 ){
              this.getGradeData = response.body.data
              console.log(this.getGradeData)
            }
          })
          .catch(function(response) {
            console.log(response)
          })
      },
      remarkInfo(classId,className){
        this.$router.push({path:"remarkInfo",query:{
            classId:classId,evalId:this.evalId,detailCode:this.detailCode,path:"gradeList",className:className,nameBt:this.nameBt}})
      },


      goBack(){
        window.location.href = roterPath + "/weixin/wechat/dist/index.html#/evaluate"
      }

    },
    data(){
      return {
        evalId:"",
        detailCode:"",
        getGradeData:[],
        nameBt:""
      }
    }
  }
</script>

<style lang="less" scoped>
  @import '../../style/minxin.less';
  .title {
    height: 60/@baseSize;
    background: @green;
    padding-left: 30/@baseSize;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
    font-size: @fontSize30;
    color: @white;
    line-height: 60/@baseSize;
    overflow: hidden;
  }

  .maple-list{
    width: 100%;
  }
  .maple-list h4{
    padding-left: 55/@baseSize;
    padding-right: 55/@baseSize;
    -webkit-background-origin: border-box;
    background-origin: border-box;
    height: 100/@baseSize;
    border-bottom: 1px solid #dddddd;
    line-height:100/@baseSize;

  }
  .maple-list h4 em {
    width: 40/@baseSize;
    height: 40/@baseSize;
    display: block;
    float: left;
    text-align: center;
    line-height: 40/@baseSize;
    background: @green;
    border-radius: 4px;
    color: @white;
    margin-top: 28/@baseSize;
  }
  .maple-list h4 span {
    margin-left: 20/@baseSize;
    float: left;
    color: @color42;
    font-size: @fontSize30;
  }

  .maple-info{
    width: 100%;
  }
  .maple-info li{
    padding-left: 55/@baseSize;
    padding-right: 55/@baseSize;
    -webkit-background-origin: border-box;
    background-origin: border-box;
    height: 100/@baseSize;
    border-bottom: 1px solid #dddddd;
    line-height:100/@baseSize;
  }
  .maple-info li span{
    color: @color42;
    font-size:@fontSize30;
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



</style>
