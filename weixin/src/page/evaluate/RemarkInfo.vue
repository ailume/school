<template>
  <div class="box">
    <div class="back-div">
      <p @click="goBack()" class="up-back">返回</p>
    </div>
    <div class="context clearfix">
      <h3 class="title">{{className}}-{{nameBt}}</h3>
      <div class="remarck-table clearfix">
        <span class="table-number">学号姓名</span>
        <span class="table-remarck">评分</span>
        <span class="table-word">评语</span>
      </div>
      <ul class="remarck-list">
        <li class="clearfix" v-for="(item,index) in detailsData" :key="index">   <!--currt-->
          <span class="table-number left-name" @click="editStudent(item,item.STU_ID)">
            <i>{{item.STU_CODE}}</i><em>{{item.STU_NAME}}</em>
          </span>
          <span class="table-remarck">
            <div class="sorage-right sorage-right-number">
              <x-number align="left" v-model="item.SCORE" :min="item.SCORE_LIMIT[0]" :max="item.SCORE_LIMIT[1]" fillable></x-number>
            </div>
          </span>
          <span class="table-word table-word-left">
            <textarea v-model="item.COMMENT" placeholder="" value="" maxlength="100" class="boreder-box"></textarea>
          </span>
        </li>
      </ul>
    </div>
    <p class="pltne-btn" @click="completeBtn()">全部提交</p>

    <toast
      v-model="showPositionValue"
      type="text"
      :time="800"
      is-show-mask
      :position="position"
    >
      {{toastMessage}}
    </toast>

  </div>
</template>

<script>
  import { Toast,GroupTitle, Group, Cell, XInput, XNumber, XTextarea,XDialog, TransferDomDirective as TransferDom  } from 'vux'
  import Back from "../../components/common/Back.vue"
  import apiRouter from "../../config/api.js"

  import {mapGetters,mapMutations} from 'vuex'

  export default {
    components: {
      Toast,
      Back,
      GroupTitle,
      Group,
      Cell,
      XInput,
      XNumber,
      XTextarea,
      XDialog
    },
    created(){
      /*this.evalId = this.$route.query.evalId
      this.detailCode = this.$route.query.detailCode
      this.classId = this.$route.query.classId*/
    },
    mounted(){
//      this.getStudentWay()
      this.key += 1;
    },
    activated(){
      this.key += 1;
      this.nameBt = this.$route.query.nameBt

      this.className = this.$route.query.className

      let path = this.$route.query.path
      this.evalId = this.$route.query.evalId
      this.detailCode = this.$route.query.detailCode
      this.classId = this.$route.query.classId
      if( path !== "Storage" ){
         this.getStudentWay()
      }
    },
    methods: {
      getStudentWay(){
        this.detailsData = []
        this.$http.get(apiRouter.GET_STUDENT + "classId=" + this.classId + "&evalId=" + this.evalId + "&detailCode=" + this.detailCode)
          .then((response) => {
            if( response.body.status === 200 ){
              this.detailsData = response.body.data
              this.barcknData = response.body.data.COMMENT
              console.log(this.detailsData)
            }
          })
          .catch(function(response) {
            console.log(response)
          })
      },
      editStudent(item,studentId){
       let _this = this;
        _this.setEbaluate(item)
        let string = JSON.stringify(item)
        window.localStorage.setItem("REMARK",string)
        _this.$router.push({
          path:"storage",
          query: {
              classId:this.classId,
              studentId:studentId,
              evalId:this.evalId,
              detailCode:this.detailCode,
              className:this.className,
              nameBt:this.nameBt,
              comtItem:function(item,number,info){
                _this.comtItem(item,number,info)
              }
          }})
      },
      comtItem(item,number,info){
        item.COMMENT = info
        item.SCORE = number
      },

      completeBtn(position,msg){
          let _this = this;
          this.studentInfo = []
          let lenghts = this.detailsData
          lenghts.forEach((item,index) =>{
              this.studentInfo.push({STU_ID:item.STU_ID,SCORE:item.SCORE,COMMENT:item.COMMENT})
          })

          let sendData={
            evalId:this.evalId,
            detailCode:this.detailCode,
            userList:JSON.stringify(this.studentInfo)
          }

        _this.$http.post(apiRouter.POST_EVALUATE,sendData)
          .then(
            (response) => {
              if( response.body.status === 200 ){
                _this.position = position
                _this.toastMessage = response.body.message
                _this.showPositionValue = true
                setTimeout(_this.backHome,1200)
              }else{
                _this.position = position
                _this.toastMessage = response.body.message
                _this.showPositionValue = true
              }
            },
            (error) => {
              _this.position = position
              _this.toastMessage = response.body.message
              _this.showPositionValue = true
            }
          );

      },
      backHome(){
        console.log(roterPath + "/weixin/wechat/dist/index.html#/gradeList?evalId=" + this.evalId + "&detailCode=" + this.detailCode + "&nameBt=" + this.nameBt)
        window.location.href = roterPath + "/weixin/wechat/dist/index.html#/gradeList?evalId=" + this.evalId + "&detailCode=" + this.detailCode + "&nameBt=" + this.nameBt
        //  this.deleteLocalStorage()
      },
      goBack(){
        window.location.href = roterPath + "/weixin/wechat/dist/index.html#/gradeList?evalId=" + this.evalId + "&detailCode=" + this.detailCode + "&nameBt=" + this.nameBt
      },

      ...mapMutations({
        setEbaluate: "SET_EVALUATE"
      })

    },
    data(){
      return {
        evalId:"",
        detailCode:"",
        classId:"",
        detailsData:[],

        barcknData:"",
        showPositionValue: false,
        toastMessage:"",
        position: 'default',

        studentInfo:[],

        message:"",

        key:1,

        className:"",
        nameBt:""

      }
    }
  }
</script>

<style lang="less" scoped>
  @import '../../style/minxin.less';
  .box{
    padding-bottom: 80/@baseSize;
  }
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

  .remarck-table{
    width: 100%;
    height: 100/@baseSize;
    line-height: 100/@baseSize;
    background: #f9f9f9;
  }
  span.table-number,span.table-remarck,span.table-word{
    float: left;
    text-align: center;
    display: block;
    overflow: hidden;
  }
  span.table-number{
     width: 20%;
  }
  span.table-remarck{
    width: 40%;
    text-align: center;
  }
  span.table-word{
    width: 36%;
    float: right;
    margin-right: 2%;
  }

  .remarck-table span.table-number,.remarck-table span.table-remarck,.remarck-table span.table-word{
    font-size: @fontSize30;
    color: @green;
  }

  .remarck-list li{
    width: 100%;
    height: 100/@baseSize;

    border-bottom: 1px solid @colorDD;
    box-sizing: border-box;
    overflow: hidden;
  }

  .remarck-list li span.left-name{
    text-align: center;
    box-sizing: border-box;
  }

  .remarck-list li.currt{
    background: #EEEEEE;
    border-left: 3px solid @green;
  }
  .remarck-list li.currt input,.remarck-list li.currt textarea{

  }

  .minus-number,.remarck-value,.add-number{
    display: inline-block;
    width: 51/@baseSize;
    height: 51/@baseSize;
    line-height:51/@baseSize;
    text-align: center;
    float: left;
    box-sizing: border-box;
    background: #ffffff;
  }
  .remarck-value{
    -webkit-background-origin: border-box;
    background-origin: border-box;
    background: #ffffff;
  }
  .minus-number{
    border-right:1px solid @colorDD;

  }
  .add-number{
    border-left:1px solid @colorDD;
  }
  .table-remarck-suan{
    width: 100%;
    height: 55/@baseSize;
    border: 1px solid @colorDD;
    margin-top: 0.4rem;
    font-size: @fontSize28;
    color: @color42;
  }
  .table-remarck-suan .remarck-common{
    width: 100/3*1%;
  }

  .table-number{
    display: block;
    line-height: 100/@baseSize;
    color: #1ba0e1;
    text-align: left;
  }
  .table-number i{
    margin-right: 0.1rem;
  }
  .table-number i,.table-number em{
    font-style: normal;
    font-size: @fontSize30;
  }
  .table-word .table-word-input {
    line-height: 30/@baseSize;
    height: 1rem;
    margin-top: 0.3rem;
    float: right;
    background:none;
  }

  .pltne-btn {
    width: 100%;
    height: 80/@baseSize;
    line-height: 80/@baseSize;
    font-size: @fontSize30;
    color: @white;
    background: @green;
    margin-top: 80/@baseSize;
    text-align: center;
    position: fixed;
    bottom:0;
  }


  .sorage-right{
    margin-left: auto;
    margin-right: auto;
  }

  .remarck-list li span.table-word-left{
    text-align: left;
    height: 80/@baseSize;
    overflow : hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    margin-top: 10/@baseSize;


    justify-content: space-around;
    flex-direction: column;
    padding-right:0.1rem;
    box-sizing: border-box;
    margin-right: 2%;
  }

  .boreder-box{
    border: 1px solid #eeeeee;
    margin-right: 2%;
    width: 98%;
    box-sizing: border-box;
    margin-top: 0.2rem;
    border-radius: 4px;
    line-height: 28/@baseSize;
    padding: 0.08rem;
  }

  .sorage-right-number{
    margin-top: 0.2rem;
  //  width: 105px;
  }
.remarck-list .weui-cell{
      padding: 10px;
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
