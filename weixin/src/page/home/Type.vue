<template>
  <div>
    <!-- 返回组件 -->
    <back></back>
    <h2 class="type-h2">请选择通知类型</h2>
    <ul class="get-type">
      <li class="type-list" v-for="(item,index) in typeData" @click="typeLink(item.type,item)">
        <span class="left type-name">{{ item.objectName }}</span>
        <em class="right type-icon"></em>
      </li>
    </ul>
  </div>
</template>

<script>
  import Back from "../../components/common/Back.vue"
  import apiRouter from "../../config/api.js"
  import {mapMutations} from 'vuex'
  export default {
    components:{
      Back
    },
    mounted(){
      this.showData();
    },
    methods:{
      showData(){
        let _this = this;
        this.$http.get(apiRouter.NOTICE_TYPE).then(response => {
          if( response.status === 200 ){
            return _this.typeData = response.body.data;
          }
        }, response => {
          alert("请求失败了!!!!")
        });
      },

      typeLink(path,item){
        this.choolesType(item)
        let string = JSON.stringify(item)
        window.localStorage.setItem("type",string)
        if( path === "DEPT" ){
          this.$router.push({path:'notice'})
        }
        if( path === "CLASS" ){
          this.$router.push({path:'grade'})
        }
        if( path === "COURSE" ){
          this.$router.push({path:'curriculum'})
        }
        if( path === "SELCOURSE" ){
          this.$router.push({path:'optional'})
        }
        if( path === "SPECIAL" ){
          this.$router.push({path:'space'})
        }
      },
      ...mapMutations({
        choolesType:"SET_TYPE"
      })
    },
    data(){
      return{
        typeData:[],
      }
    }
  }
</script>

<style lang="less" scoped>
  @import '../../style/minxin.less';
  .type-h2{
    width: 100%;
    height: 60/@baseSize;
    background:@green;
    line-height: 60/@baseSize;
    .mixin-padding(50/@baseSize,0);
    color: @white;
    font-size: @fontSize30;
  }
  .get-type{
    width: 100%;
  }
  .type-list{
    .mixin-padding(50/@baseSize,50/@baseSize);
    height: 100/@baseSize;
    border-bottom: 1px solid @colorDD;
    line-height: 99/@baseSize;
  }
  .type-name{
    font-size:@fontSize30;
    color: @color42;
  }
  .type-icon{
    width:14/@baseSize;
    height:24/@baseSize;
    background: url("../../assets/chevron right.png");
    background-size: 100% 100%;
    margin-top: 38/@baseSize;
  }
</style>
