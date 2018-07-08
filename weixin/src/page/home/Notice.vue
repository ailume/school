<template>
  <div>
    <!-- 返回组件 -->
    <back></back>
    <div class="clearfix">
      <div class="class-list">
        <h2 class="static-name" :class="{ gradeClass: gradeClass }">通知到班级</h2>
        <div class="class-title">
          <label class="class-left">通知对象</label>
          <div class="class-info">
            <checker
              v-model="targetData"
              type="checkbox"
              default-item-class="class-item"
              selected-item-class="class-item-selected"
            >
              <checker-item  class="border-redue" v-for="(item,index) in classData" :key="index" :value="item">{{item.typeName}}</checker-item>
            </checker>
          </div>
        </div>

        <div class="class-gomt">
          <h2 class="class-name">对象班级</h2>
          <div class="class-info-padding">
            <checker
              v-model="schoolValue"
              type="radio"
              default-item-class="class-item"
              selected-item-class="class-item-selected"
            >
              <checker-item class="border-redue" v-for="(item,index) in schoolData" :key="index" :value="item">{{item.toName}}</checker-item>
            </checker>

            <checker
              v-model="gradeValue"
              type="checkbox"
              default-item-class="class-item"
              selected-item-class="class-item-selected"
            >
              <checker-item class="border-redue" v-for="(item,index) in gradeData" :key="index" :value="item">{{item.toName}}</checker-item>
            </checker>

            <checker
              v-model="herdValue"
              type="radio"
              default-item-class="class-item"
              selected-item-class="class-item-selected"
            >
              <checker-item class="border-redue" v-for="(item,index) in herdData" :key="index" :value='item'>{{item.toName}}</checker-item>
            </checker>

          </div>
        </div>

      </div>
      <div class="class-list">
        <h2 class="static-name class-name-bottom" :class="{ flockClass: flockClass }">通知到群组</h2>
        <div class="group-info">
          <checker
            v-model="flockData"
            type="checkbox"
            default-item-class="group-item"
            selected-item-class="group-item-selected"
          >
            <checker-item class="border-redue" v-for="(item,index) in groupData" :key="index" :value="item">{{item.toName}}</checker-item>
          </checker>
        </div>

      </div>
    </div>
    <p class="complete-btn" @click="completeBtn()">完成</p>

  </div>
</template>

<script>
  import { Checker, CheckerItem, Divider, Group, Cell, Popup, TransferDom } from 'vux'
  import Back from "../../components/common/Back.vue"
  import apiRouter from "../../config/api.js"
  import {mapGetters,mapMutations} from 'vuex'
  export default {
    components:{
      Back,
      Checker,
      CheckerItem,
      Divider,
      Group,
      Cell,
      Popup
    },
    computed: {
      ...mapGetters([
        "choolesType"
      ])
    },
    created(){
      let stringStore = JSON.stringify(this.choolesType);
      if( stringStore === "{}" &&  stringStore.length === 2 ){
        this.objType = JSON.parse(window.localStorage.type);
        this.objType.objectId = this.objType.objectId;
        this.objType.type = this.objType.type;
        this.objType.objectName = this.objType.objectName;
      }else{
        this.objType = this.choolesType;
        this.objType.objectId = this.objType.objectId;
        this.objType.type = this.objType.type;
        this.objType.objectName = this.objType.objectName;
      }
    },
    mounted(){
      this.showData();
    },
    methods:{
      showData(){
        let _this = this;
        let pathUrl = apiRouter.SCOPE_DEPT + "?"+
          'objectId=' + this.objType.objectId +
          "&type=" + this.objType.type +
          "&objectName=" + this.objType.objectName;
        this.$http.get(pathUrl).then(response => {
            console.log(response.body.data)
          this.groupData = response.body.data.groupObj
          this.classData = response.body.data.userType
          this.schoolData = response.body.data.schoolObj
          this.herdData = response.body.data.classObj
          this.gradeData = response.body.data.classGroupObj
          return _this.deptData = response.body.data;
        }, response => {
          alert("请求失败了!!!!")
        });
      },
      completeBtn(){
        let arr = [];
        let notifyObject = [];
        let notifyClass = [];

        let arrData = [];

        let path = this.$route.name
        let toName = ""
        if( this.flockData === "" && this.targetData === "" && this.schoolValue ==="" && this.herdValue === "" && this.gradeValue === "" ){
          alert("请选择");
          return
        }
        if( this.targetData.length !== 0 ){
          this.targetData.forEach((item,index)=>{
            notifyObject.push(item);
          })
        }

        if( this.schoolValue.length !== 0 ){
          arrData.push(this.schoolValue);
          arrData.forEach((item,index)=>{
             notifyClass.push(item);
          })
        }

        if( this.herdValue.length !== 0 ){
          arrData.push(this.herdValue);
          arrData.forEach((item,index)=>{
            notifyClass.push(item);
          })
        }
        if( this.gradeValue.length !== 0 ){
          this.gradeValue.forEach((item,index)=>{
            notifyClass.push(item);
          })
        }

        if( notifyObject.length === 0 &&  notifyClass.length !== 0){
          alert("请选择通知对象");return
        }
        if( notifyClass.length === 0  && notifyObject.length !== 0){
          alert("请选择通知班级");return
        }

       //notifyObject 这是对象，
        // notifyClass  这是班级
        // arr 空对象

          notifyClass.forEach((item1,index1)=>{
            notifyObject.forEach((item2,index2)=>{
              let objData ={
                typeCode:item2.typeCode,
                typeName:item2.typeName,
                toName:item1.toName + item2.typeName,
                toObjectId:item1.toObjectId,
                toObjectName:item1.toObjectName,
              };
              arr.push(objData);
            })
          })
        if( this.flockData !== "" ){
          this.flockData.forEach((item,index)=>{
            arr.push(item);
          })
        }
          this.setSchool(arr);
          let noticeString = JSON.stringify(arr)
          window.localStorage.setItem("NOTICE",noticeString)
          this.$router.push({path:"posted",query: { path:"Notice"}});
      },

      ...mapMutations({
        setSchool:"SET_NOTICE"
      })

    },
    data(){
      return{
        objType:{
          type:"",
          objectId:"",
          objectName:""
        },

        deptData:"",

        gradeClass:false,
        flockClass:false,

        targetData:"",   // 通知对象的值
        flockData:"",   // 通知到群组
        classData:[
          "教师",
          "学生",
          "家长"
        ],
        schoolData:[
          "全校"
        ],
        schoolValue:"",  //  班级对象 1
        herdData:[
          "群组名称1",
          "群组名称2",
          "群组名称3",
          "群组名称4",
          "群组名称5",
          "群组名称七",
          "群组名称八",
        ],
        herdValue:"",  // 班级对象 2
        gradeData:[
          "一年纪",
          "二年纪",
          "三年纪",
          "四年纪",
          "五年纪",
          "六年纪",
          "七年纪",
          "八年纪",
          "九年纪"
        ],
        gradeValue:"",  // 班级对象 3
        groupData:[
          "群组名称1",
          "群组名称2",
          "群组名称3",
          "群组名称4",
          "群组名称5",
          "群组名称七",
          "群组名称八",
          "群组名称九",
          "群组名称七",
          "群组名称八",
          "群组名称九",
          "群组名称七",
          "群组名称八",
          "群组名称九",
          "群组名称十",
          "群组名称十一",
          "群组名称十二"
        ]
      }
    },
    watch:{
      targetData:function (vel) {
        if( vel.length !== 0  ){
          this.gradeClass = true;
          this.flockClass = false;
          this.flockData = "";
        }
      },


      schoolValue:function(vel){
        if( vel.length !== 0  ){
          this.gradeClass = true;
          this.flockClass = false;
          this.flockData = "";
          this.herdValue = "";
          this.gradeValue = "";
        }
      },

      herdValue:function(vel){
        if( vel.length !== 0  ){
          this.gradeClass = true;
          this.flockClass = false;
          this.flockData = "";
          this.schoolValue = "";
          this.gradeValue = "";
        }
      },

      gradeValue:function(vel){
        if( vel.length !== 0  ){
          this.gradeClass = true;
          this.flockClass = false;
          this.flockData = "";
          this.schoolValue = "";
          this.herdValue = "";
        }

        if( this.targetData.length === 0 &&  this.schoolValue.length && this.herdValue.length && this.gradeValue.length ){
          this.gradeClass = false;
        }

      },

      flockData: function (vel) {
        if( vel.length !== 0 ){
          this.flockClass = true;
          this.gradeClass = false;
          this.targetData = "";
          this.schoolValue = "";
          this.herdValue = "";
          this.gradeValue = "";
        }else{
          this.flockClass = false;
        }
      }
    }
  }
</script>

<style lang="less" scoped>
  @import '../../style/minxin.less';
  .class-list{
    width: 100%;
    margin-bottom: 60/@baseSize;
  }
  .static-name{
    width: 100%;
    height: 60/@baseSize;
    color: @white;
   // text-align: center;
    line-height:60/@baseSize;
    font-size: @fontSize30;
    background: @color97;
    padding-left: 30/@baseSize;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
  }
  .class-title{
    .mixin-padding(30/@baseSize,30/@baseSize);
    position: relative;
    height: 50/@baseSize;
    margin-top: 40/@baseSize;
  }
  .class-left{
    display: inline-block;
    position: absolute;
    top: 2/@baseSize;
    left:30/@baseSize;
    font-size:@fontSize30;
    color: @color42;
  }
  .class-info{
    margin-left: 140/@baseSize;
  }
  .class-item,.group-item {
    border: 1px solid @color97;
    margin-right: 15/@baseSize;
    height: 50/@baseSize;
    display: inline-block;
    line-height: 52/@baseSize;
    font-size: @fontSize24;
  }
  .class-item,.group-info{
    .mixin-padding(40/@baseSize,40/@baseSize);
  }
  .group-item{
    .mixin-padding(15/@baseSize,15/@baseSize);
    margin-bottom:30/@baseSize;
  }
  .class-list .group-item{
    margin-left: 0;
    margin-right:15/@baseSize;
  }
  .class-item-selected,.group-item-selected {
    background: url("../../assets/combined.png") no-repeat right bottom;
    background-size:25/@baseSize 24/@baseSize ;
    border-color: @green;
  }

  .class-gomt{
    .mixin-padding(30/@baseSize,30/@baseSize);
  }
  .complete-btn{
    width: 100%;
    height: 80/@baseSize;
    background:@green;
    text-align: center;
    line-height:80/@baseSize;
    color: @white;
    font-size:@fontSize30;
  }

  .gradeClass,.flockClass{
    background:@green;
    color: @white;
  }

  .class-name-bottom{
    margin-bottom: 30/@baseSize;
  }

  .border-redue{
    border-radius: 4px;
    margin-bottom: 30/@baseSize;
  }
  .class-name{
    font-size:@fontSize30;
    color: @color42;
    margin-top: 60/@baseSize;
  }
  .class-info-padding{
    margin-top: 30/@baseSize;
  }

</style>
