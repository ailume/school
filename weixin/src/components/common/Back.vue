<template>
  <div class="back-div">
    <p @click="goBack()" class="up-back">返回</p>
  </div>
</template>

<script>
    export default {
      methods:{
        goBack(){
          this.$router.go(-1)
        }
      }
    }
</script>

<style lang="less" scoped>
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
</style>
