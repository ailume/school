<template>
  <div id="app">
    <keep-alive>
      <router-view></router-view>
    </keep-alive>
  </div>
</template>


<script>
  export default {
  name: 'app'
}
</script>

<style lang="less">
  @import 'style/common.less';
  @import '~vux/src/styles/reset.less';
  #app{
    height: 100%;
  }
</style>
