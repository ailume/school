<template>
  <div>
    <!-- 返回组件 -->
    <back></back>
    <div class="clearfix">
      <div class="class-list">
        <h2 class="static-name">通知到班级</h2>
        <div class="class-title">
          <label class="class-left">通知对象</label>
          <div class="class-info">
            <checker
              type="checkbox"
              default-item-class="class-item"
              selected-item-class="class-item-selected"
            >
              <checker-item v-for="(item,index) in classData" :key="index" :value="index">{{item}}</checker-item>
            </checker>
          </div>
        </div>

        <div class="class-gomt">
          <h2 class="class-name">对象班级</h2>
        </div>

      </div>
      <div class="class-list">
        <h2 class="static-name">通知到群组</h2>
        <checker
          type="checkbox"
          default-item-class="group-item"
          selected-item-class="group-item-selected"
        >
          <checker-item v-for="(item,index) in groupData" :key="index" :value="index">{{item}}</checker-item>
        </checker>
      </div>
    </div>
    <p class="complete-btn" @click="completeBtn()">完成</p>

  </div>
</template>

<script>
  import { Checker, CheckerItem, Divider, Group, Cell, Popup, TransferDom } from 'vux'
  import Back from "../../components/common/Back.vue"
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
    methods:{
      completeBtn(){
        this.$router.push({path:"posted"});
      }
    },
    data(){
      return{
        classData:[
          "教师",
          "学生",
          "家长"
        ],
        groupData:[
          "群组名称1",
          "群组名称2",
          "群组名称3",
          "群组名称4",
          "群组名称5",
          "群组名称5",
          "群组名称七",
          "群组名称八",
          "群组名称九",
          "群组名称十",
          "群组名称十一",
          "群组名称十二"
        ]
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
    text-align: center;
    line-height:60/@baseSize;
    font-size: @fontSize30;
    background: @color97;
  }
  .class-title{
    .mixin-padding(50/@baseSize,50/@baseSize);
    position: relative;
    height: 50/@baseSize;
    margin-top: 40/@baseSize;
  }
  .class-left{
    display: inline-block;
    position: absolute;
    top: 5/@baseSize;
    left:50/@baseSize;
    font-size:@fontSize30;
    color: @color42;
  }
  .class-info{
    margin-left: 140/@baseSize;
  }
  .class-item,.group-item {
    border: 1px solid @color97;
    margin-left: 15/@baseSize;
    height: 50/@baseSize;
    display: inline-block;
    line-height: 52/@baseSize;
    font-size: @fontSize24;
  }
  .class-item{
    .mixin-padding(50/@baseSize,50/@baseSize);
  }
  .group-item{
    .mixin-padding(15/@baseSize,15/@baseSize);
    margin-bottom:70/@baseSize;
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
    .mixin-padding(50/@baseSize,50/@baseSize);
  }
  .complete-btn{
    width: 100%;
    height: 80/@baseSize;
    background:@green;
    text-align: center;
    line-height:80/@baseSize;
    color: @white;
    font-size:@fontSize30;
    position: absolute;
    bottom:0;
  }

</style>
