<template>
   <div class="box">
    <div class="back-div" ref="heightBackPub">
      <p @click="goBack()" class="up-back">取消发布</p>
    </div>

    <div class="spacedetail">
      <x-textarea
        :max="1000"
        @on-focus="onEvent('focus')"
        @on-blur="onEvent('blur')"
        class="x-textarea"
        placeholder="说点什么…"
        :rows="7"
        v-model="contentValue"
      >
      </x-textarea>
    </div>


    <div class="photo-ims"></div>
    <div class="accessory-box">
      <div class="accessory-img clearfix">
        <ul class="photo-img">
          <!-- <li v-for="(item,index) in uploadImg" :key="index">
            <img :src="item" alt="" class="imgud">
            <img src="../../assets/cancel.png" alt="" class="cancel" @click="clodesd(index)">
          </li> -->
        </ul>
          <!-- <a class="up-photo" href="javascript:;" @click="onClickUp()" v-show="imgLenght">
            <img src="../../assets/addup.jpg" alt="">
          </a> -->
           <div id='image-list' class="mui_uploader">
                <input id="uploaderInput" class="mui_uploader_input" type="file" multiple  accept="image/*" >
              </div>
            <div><span id="uploaderInput_mess"></span></div>
      </div>
    </div>

    

    <div class="ps-info">
        <!-- <p>注：小视频的长度不能超过10秒,超过的视频服务器会自动截取前10秒内容。</p> -->
        <div>
            <button
                @click="goUploder()"
                class="btn-uploder right"
                type="submit"
                >发布
            </button>
        </div>
    </div>

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
  import {Confirm,XTextarea, Group, XSwitch, XButton, Toast,TransferDomDirective as TransferDom} from 'vux'
  import Back from "../../components/common/Back.vue"
  import apiRouter from "../../config/api.js"
    import wx from "weixin-js-sdk";
  import {mapMutations} from 'vuex'
  export default {
    directives: {
      TransferDom
    },
    components: {
      Back,
      Confirm,
      Group,
      XSwitch,
      XButton,
      Toast,
      XTextarea
    },
    created: function() {
    //getSelectDates();
    //timeData()
  },
    mounted(){
        
    },
    data(){
      return {
          contentValue: "",
          uploadImg:[],
          imgLenght: true,
          showPositionValue: false,
          showToast: true,
          position: "default",
          toastMessage: ""
      }
    },
    methods: {
      goBack(){
        window.location.replace(roterPath + "/weixin/wechat/dist/index.html")
      },
      onEvent (event) {
        //   console.log('on', event)
      },


    // 上传图片
    onClickUp() {
      let data=[];
    let formData = new FormData();
    var f2 = document.querySelector('#uploaderInput');
    f2.onchange = function (e) {
        var files = e.target.files;
        var len = files.length;
        // console.log(files)
//		console.log($("#uploaderInput")[0].files)
        if (len > 9){
            alert('图片最多只能上传9张', 'error');
            return false;
        }
        var img =  $("div[name='all_pic_img']");
        if (img.length + len > 9 ){
            alert('图片最多只能上传9张', 'error');
            return false;
        }
        for(var i=0;i<len;i++){
            $("#all_pic").append("<div style='float: left;width:100px;height:50px' name='all_pic_img'><img style='width:50px;height:50px' src='"+getFileURL(files[i])+"'/><a onclick=\"del('"+files[i].name+"',"+i+")\" id='all_pic_img_"+i+"'>删除</a></div>")
            var a={
                'val':files[i]
            };
            data.push(a);
        }
    }
    function del(name,id){
        var r=confirm("是否删除？");
        if(r==true){
            data.splice(id, 1)
            $("#all_pic_img_"+id).parent().remove();
        }
    }
    },

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

  .accessory-box {
    .mixin-padding(30/@baseSize, 30/@baseSize);
  }

  .accessory-title {
    font-size: @fontSize30;
    color: @color42;
    margin-top: 15/@baseSize;
  }

  .form-info .vux-label {
    font-size: @fontSize30;
  }

  .accessory-img {
    margin-top: 50/@baseSize;
  }

  .weui-cell__ft, .vux-cell-value {
    font-size: @fontSize28;
  }

  .photo-img, .up-photo, .photo-img li {
    float: left;
  }

  .photo-img li{
    margin-bottom: 20/@baseSize;
  }
  .up-photo{
    margin-left: 20/@baseSize;
  }

  .photo-img li {
    margin-right: 22/@baseSize;
    position: relative;
  }
  .photo-img li:last-child{
    margin-right: 0;
  }

  .photo-img li, .photo-img li img.imgud, .up-photo img {
    width: 150/@baseSize;
    height: 150/@baseSize;
  }

  .photo-img li img.imgud, .up-photo img {
    display: block;
  }

  .cancel{
    width:50/@baseSize;
    height: 50/@baseSize;
    font-size: 50/@baseSize;
    position: absolute;
    top: -25/@baseSize;
    right:-25/@baseSize;
    display: block;
  }


.btn-uploder {
    line-height: 80/@baseSize;
    text-align: center;
    font-size: @fontSize30;
    color: @white;
    width: 200/@baseSize;
    background: @green;
    margin-right: 40/@baseSize;
    margin-top: 80/@baseSize;
  }

  .cancel-btn {
    width: 100%;
    height: 100/@baseSize;
    font-size: @fontSize36;
    color: @white;
    text-align: center;
    line-height: 100/@baseSize;
    position: fixed;
    top:0;
    left:0;
    background:rgba(0, 0, 0, 0.6);
    z-index: 999;
  }
  .ps-info p{
      color: #4CAF50;
      font-size: @fontSize28;
      padding-left: 30/@baseSize;
      padding-right: 30/@baseSize;
      box-sizing: border-box;
      margin-top: 30/@baseSize;
  }

  

</style>
