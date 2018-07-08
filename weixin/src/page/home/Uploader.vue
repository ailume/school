<template>
<div>
  <h1
    style=
      "line-height: 2rem;
      text-align: center;
      margin-top:1rem;
      color: #4444;
      font-size: 1rem;"
  >{{title}}</h1>

</div>
</template>

<script>
  import Uploader from 'vux-uploader'
    export default {
      components:{
        Uploader
      },
      data () {
          return{
              title:"上传图片"
          }
      }
    }
</script>

<style scoped>

</style>
