<template>
    <div class="box">
      <Back></Back>
      <div class="sorage-info clearfix">
        <div class="sorage-number bordr-bottom clearfix">
            <span class="sorage-left">学号姓名：</span>
            <div class="sorage-right sorage-right-one">
              <span>{{this.studentDetails.STU_CODE}}  {{this.studentDetails.STU_NAME}}</span>
            </div>
        </div>

        <div class="sorage-number bordr-bottom clearfix">
          <span class="sorage-left">最近评价：</span>
          <div class="sorage-right sorage-right-new">
            <p>
              <em><em v-if="this.gradedMack >0">+</em>{{this.studentDetails.LAST_SCORE}}</em>&nbsp;&nbsp;<em class="rialr-tighe">{{this.studentDetails.UNAME}}</em></p>
            <p>{{this.studentDetails.LAST_COMMENT}}</p>
          </div>
        </div>

        <div class="sorage-number clearfix">
          <span class="sorage-left">本次评价：</span>
          <div class="sorage-right sorage-right-number">
              <x-number align="left" v-model="SCORE" :min="min" :max="max" fillable></x-number>
          </div>
        </div>

        <ul class="lexicon clearfix">
          <li @click="doShowToast(1)"><span>评语库1</span></li>
          <li @click="doShowToast(2)"><span>评语库2</span></li>
          <li @click="doShowToast(3)"><span>个人评语库</span></li>
        </ul>

        <div class="sorage-number clearfix">
          <span class="sorage-left">评语：</span>
          <div class="sorage-right sorage-right-textarea">
            <x-textarea
              :max="100"
              @on-focus="onEvent('focus')"
              @on-blur="onEvent('blur')"
              class="x-textarea"
              placeholder="请输入评语"
              :rows="5"
              v-model="giveValue"
            >
            </x-textarea>
          </div>
        </div>
      </div>
      <p class="pltne-btn" @click="storage()">完成</p>

      <div v-transfer-dom>
        <x-dialog
          v-model="showDialogStyle"
          mask-z-index="1000"
          hide-on-blur :dialog-style="{'max-width': '100%', width: '100%', height: '100%', 'background-color': 'transparent'}">
          <div class="div-cibg clearfix">
          <h3 class="pop-title">{{commentKu}}</h3>
          <span class="clodesn-shouw" @click="showDialogStyle = false">关闭</span>

          <ul class="list-ci clearfix">
            <li @click="cheootCi(title) ,showDialogStyle = false" v-for="(title,index) in moreData">
              <p>
                <!--<em>{{index+1}}</em>-->
                <span>{{title}}</span>
              </p>
            </li>
          </ul>
          </div>

        </x-dialog>
      </div>

    </div>
</template>

<script>
  import { GroupTitle, Group, Cell, XInput, XNumber, XTextarea,XDialog, TransferDomDirective as TransferDom  } from 'vux'
  import Back from "../../components/common/Back.vue"
  import apiRouter from "../../config/api.js"
  import {mapGetters,mapMutations} from 'vuex'
  export default {
    directives: {
      TransferDom
    },
      components: {
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

      },

      mounted(){
        /*this.evalId = this.$route.query.evalId
        this.detailCode = this.$route.query.detailCode
        this.studentId = this.$route.query.studentId
        this.classId = this.$route.query.classId

        let stringStore = JSON.stringify(this.evaluateInfo);
        let stringArray = this.evaluateInfo;
        if( stringStore === "[]" &&  stringStore.length === 2 ){
          let remacrk = JSON.parse(window.localStorage.REMARK);
          console.log(remacrk)
          this.giveValue = remacrk.COMMENT
          this.SCORE = remacrk.SCORE
        }else{
          this.giveValue = stringArray.COMMENT
          this.SCORE = stringArray.SCORE
        }
        this.getStudentEtid()*/
      },
      computed: {
        ...mapGetters([
          "evaluateInfo",
        ])
      },
      activated(){
        this.evalId = this.$route.query.evalId
        this.detailCode = this.$route.query.detailCode
        this.studentId = this.$route.query.studentId
        this.classId = this.$route.query.classId

        let stringStore = JSON.stringify(this.evaluateInfo);
        let stringArray = this.evaluateInfo;
        this.getStudentEtid()
        console.log(stringArray)
        if( stringStore === "{}" &&  stringStore.length === 2 ){
          let remacrk = JSON.parse(window.localStorage.REMARK);
          console.log(remacrk.COMMENT)
          this.giveValue = remacrk.COMMENT
          this.SCORE = remacrk.SCORE
        }else{
          this.giveValue = stringArray.COMMENT
          this.SCORE = stringArray.SCORE
        }


      },
      methods: {
        getStudentEtid(){
          this.$http.get(apiRouter.GET_STUDENTINFO + "studentId=" + this.studentId + "&evalId=" + this.evalId + "&detailCode=" + this.detailCode)
            .then((response) => {
              if( response.body.status === 200 ){
                this.studentDetails = response.body.data
                this.gradedMack = response.body.data.LAST_SCORE
             //   console.log(this.studentDetails)

                console.log(response.body.data)
                this.min = response.body.data.SCORE_LIMIT[0]
                this.max = response.body.data.SCORE_LIMIT[1]

                this.dataOne = response.body.data.COMMENT_LIST1
                this.dataTwo = response.body.data.COMMENT_LIST2
                this.dataThree= response.body.data.COMMENT_LIST3
              }
            })
            .catch(function(response) {
              console.log(response)
            })
        },
        doShowToast (index) {
          this.showDialogStyle = true
          this.moreData= []
          if( index === 1 ){
            this.commentKu = "评语库1"
            for( let i = 0;i<this.dataOne.length;i++ ){
              this.moreData.push(this.dataOne[i])
            }
          }else if( index === 2 ){
            this.commentKu = "评语库2"
            for( let i = 0;i<this.dataTwo.length;i++ ){
              this.moreData.push(this.dataTwo[i])
            }
          }else{
            this.commentKu = "个人评语库"
            for( let i = 0;i<this.dataThree.length;i++ ){
              this.moreData.push(this.dataThree[i])
            }
          }

        },
        cheootCi(item){
        //  console.log(item)
          this.giveValue = this.giveValue + " " + item
        },
        storage(){
           let item = this.evaluateInfo
          let number = this.SCORE
          let info = this.giveValue
          console.log(number)
          console.log(info);
          this.$set(this.evaluateInfo,number,info);
          this.$route.query.comtItem(item,number,info)
          /*this.$router.go(-1)*/
          this.$router.push({
            path:"remarkInfo",
            query:{
                classId:this.classId,
                evalId:this.evalId,
                detailCode:this.detailCode,
                path:"Storage",

              className:this.$route.query.className,
              nameBt:this.$route.query.nameBt

            }})
        },
        onEvent (event) {
          //   console.log('on', event)
        },

      },
      data(){
          return {
            showDialogStyle: false,
            value:"",

            evalId:"",
            detailCode:"",
            studentId:"",
            classId:"",
            studentDetails:[],

            gradedMack:0,

            dataOne:[],
            dataTwo:[],
            dataThree:[],

            giveValue:"",

            moreData:[],
            commentKu:"",

            SCORE:"",

            min:0,
            max:0

          }
      }
  }
</script>

<style lang="less" scoped>
  @import '../../style/minxin.less';
  .box{
    padding-bottom: 80/@baseSize;
  }
  .sorage-number{
    padding-left: 50/@baseSize;
    padding-right:50/@baseSize;
    box-sizing: border-box;
    position: relative;
  }
  .bordr-bottom{
    border-bottom: 1px solid #dddddd;
  }
  .sorage-left{
    position: absolute;
    height: 100/@baseSize;
    line-height: 100/@baseSize;
    left: 50/@baseSize;
    top:0;
    width: 180/@baseSize;
    overflow: hidden;
  }

  .sorage-right{
    margin-left: 200/@baseSize;
  }
  .sorage-right-one{
    height: 100/@baseSize;
    line-height: 100/@baseSize;
    overflow: hidden;
  }
  .sorage-left{
    font-size: 30/@baseSize;
    color: #333333;
  }

  .sorage-right .weui-cell,.sorage-right .vux-x-textarea{
    padding:0px;
  }
  .sorage-right .vux-x-textarea{
    border: 1px solid #dddddd;
    padding:0.2rem;
    border-radius: 4px;
  }

  .lexicon{
    padding-left: 0.89285714rem;
    padding-right: 0.89285714rem;
    box-sizing: border-box;
  }
  .lexicon li{
    width: 100/3*1%;
    text-align: center;
    float: left;
    height: 100/@baseSize;
    line-height:100/@baseSize;
  }
  .lexicon li:first-child{
    text-align: left;
  }
  .lexicon li:last-child{
    text-align: right;
  }

  .lexicon li span{
    font-size: 30/@baseSize;
    color: @green;
  }
  .sorage-right-textarea{
  //  height: 170/@baseSize;
    padding-top: 0.55rem;
  }

  .sorage-right-number .weui-cell{
    padding-top: 0.45rem;
    padding-bottom: 0.45rem;
  }

  .sorage-right-new{
    padding-top: 0.45rem;
    padding-bottom: 0.5rem;
  }
  .sorage-right-new p em.rialr-tighe{
    margin-left: 0.2rem;
  }
  .sorage-right-one span,.sorage-right-new p{
    color: #333333;
    font-size: @fontSize30;
  }
  .sorage-right-number .vux-number-input{
    height: 50/@baseSize;
    width: 50/@baseSize;
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


  //  弹窗样式
  .div-cibg{
    width: 100%;
    height: 100%;
    padding-bottom: 80/@baseSize;

    box-sizing: border-box;
    background:rgba(0, 0, 0, 0.3);
  }
  .list-ci{
    width: 100%;
    height:100%;
    //background: #FFFFFF;
    overflow: scroll;
  }
  .list-ci li{
    padding-left: 44/@baseSize;
    padding-right: 44/@baseSize;
    border-bottom: 1px dashed #dddddd;
    padding-top:0.3rem;
    padding-bottom:0.3rem;
  }
  .list-ci li p{
    color: @white;
    text-align: left;
    position: relative;
    opacity:0.9;
  }
  .list-ci li p em{
    display: inline-block;
    width:50/@baseSize;
    position: absolute;
  }
  .list-ci li p span{
    /*margin-left:50/@baseSize;*/
    overflow : hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
  }
  .pop-title{
    width: 100%;
    height: 100/@baseSize;
    background:  @green;
    position: relative;
    line-height:100/@baseSize;
    font-size: @fontSize30;
    color: white;
  }

  .clodesn-shouw{
    position: absolute;
    right:44/@baseSize;
    top:0;
    display: block;
    width: 80/@baseSize;
    height: 100/@baseSize;
    line-height:100/@baseSize;
    color: white;
  }

  .vux-number-input{
    border: 1px solid #dddddd;
  }

</style>
