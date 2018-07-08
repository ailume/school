<template>
    <div class="box">
      <div class="back-div">
        <p @click="goBack()" class="up-back">返回</p>
      </div>
      <div class="context clearfix">
        <h3 class="title">请选择评价类型与项目</h3>
            <div v-for="(items,index1) in getData" :key="index1">
                <cell
                  :title="items.SCOPE_NAME"
                  is-link
                  :border-intent="false"
                  :arrow-direction="items.SHOW_LIST ? 'up' : 'down'"
                  @click.native="items.SHOW_LIST = !items.SHOW_LIST">
                  <span slot="icon" class="grade-icon grade-icon-one" :style="{background: items.SCOPE_COLOR}">评</span>
                </cell>
                <ul class="maple-info slide" :class="items.SHOW_LIST?'animate':''">
                  <li v-for="(item,index2) in items.SCOPE_LIST" :key="index2">
                    <span @click="evluatObj(item.EVAL_ID,item.DETAIL_CODE,item.DETAIL_NAME)">{{item.EVAL_NAME}}-{{item.DETAIL_NAME}}</span>
                  </li>
                </ul>
          </div>
      </div>
    </div>
</template>

<script>
  import Back from "../../components/common/Back.vue"
  import { Cell, CellBox, CellFormPreview, Group, Badge } from 'vux'
  import apiRouter from "../../config/api.js"
  export default {
      components: {
        Back,
        Group,
        Cell,
        CellFormPreview,
        CellBox,
        Badge
      },
      mounted(){
      //  this.getObjData();
      },
    activated(){
      this.getObjData();
    },
      methods: {
        getObjData(){
          this.$http.get(apiRouter.GET_EVALUATE)
            .then((response) => {
              if( response.body.status === 200 ){
                this.getData = response.body.data
                console.log(this.getData)
              }
            })
            .catch(function(response) {
              console.log(response)
            })
        },

        evluatObj(evalId,detailCode,nameBt){
            this.$router.push({path:"gradeList",query:{evalId:evalId,detailCode:detailCode,nameBt:nameBt}})
        },

        goBack(){
          window.location.href = roterPath + "/weixin/wechat/dist/index.html#/"
        }

      },
      data(){
          return {
            title1:"班主任评价学生",
            title2:"任课教师评价学生",
            title3:"评价任意学生",
            showOne: true,
            showTwo: false,
            showThree: false,

            getData:[],

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
  .maple-info li{
    padding-left: 55/@baseSize;
    padding-right: 55/@baseSize;
    -webkit-background-origin: border-box;
    background-origin: border-box;
    height: 100/@baseSize;
    border-bottom: 1px dashed #dddddd;
    line-height:100/@baseSize;
  }
  .maple-info li span{
    color: #777777;
    font-size:@fontSize30;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    display: block;
  }

  .slide {
    padding: 0 0;
    overflow: hidden;
    max-height: 0;
    transition: max-height .5s cubic-bezier(0, 1, 0, 1) -.1s;
  }
  .animate {
    max-height: 9999px;
    transition-timing-function: cubic-bezier(0.5, 0, 1, 0);
    transition-delay: 0s;
  }

  .grade-icon{
    width: 40/@baseSize;
    height: 40/@baseSize;
    display: block;
    text-align: center;
    line-height: 40/@baseSize;
    border-radius: 4px;
    color: @white;
    margin-right: 0.2rem;
  }
  .grade-icon-one{
    background: @green;
  }
  .grade-icon-two{
    background: #2196F3;
  }
  .grade-icon-three{
    background: #E91E63;
  }


  .box{
    height: 100%;
  }
  .amenene{
    width: 10px;
  }
  .box .maple-nav .maple-info{
    padding: 0;
  }
  .box .maple-nav .weui-cells{
    margin-top: 0px;
  }
  .box .maple-nav .vux-no-group-title{
    margin-top: 0px;
  }

  .box .maple-nav .weui-cells{
    font-size: @fontSize30;
    color: @color42;
    margin-top: 0px;
  }

  .box .maple-nav .weui-cell:before{
    padding-top: 0;
  }


  .context .weui-cell{
    width: 100%;
    height: 100/@baseSize;
    border-bottom: 0;
    background: #f9f9f9;
    padding-top: 0;
    padding-bottom: 0;
    padding-right: 55/@baseSize;
    padding-left: 55/@baseSize;
    font-size: @fontSize30;
    color: @color42;
  }
  .context .weui-cell:before{
    left:0;
  }
  .context .vux-no-group-title{
    padding:0;
  }

  .maple-info li:last-child{
    border-bottom: 0;
  }

  .weui-cells{
    margin-top: 0px;
  }
  .vux-no-group-title{
    margin-top:0;
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
