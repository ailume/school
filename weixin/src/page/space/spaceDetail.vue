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



    <div class="send-type">
         <div class="type-photo" v-if="this.type === 'photo'">
            <div class="accessory-box">
              <div class="accessory-img clearfix">
                <ul class="photo-img">
                  <li  v-for="(item,index) in imgfileData" :key="index">
                    <img :src="getimgUrl(item.url)" alt="" class="imgud">
                    <img src="../../assets/cancel.png" alt="" class="cancel" @click="clodesd(item.url,index)">
                  </li>
                </ul>
                  <a class="up-photo" href="javascript:;">
                    <img src="../../assets/addup.jpg" alt="">
                    <div id='image-list' class="mui_uploader">
                      <input id="uploaderInput" class="mui_uploader_input" value="" type="file" multiple  accept="image/*" >
                    </div>
                  </a>
                  <!-- <div id="all_pic">
                      <img v-for="(item,index) in imgfileData" :key="index" style='width:50px;height:50px' :src="getimgUrl(item.url)" />
                  </div>
                  <div><span id="uploaderInput_mess"></span></div> -->
              </div>
            </div>

            <div class="ps-info">
                <!-- <p>注：小视频的长度不能超过10秒,超过的视频服务器会自动截取前10秒内容。</p> -->
                <div>
                    <button
                        @click="submit()"
                        class="btn-uploder right"
                        type="submit"
                        >发布
                    </button>
                </div>
            </div>
         </div>

        <div class="type-video" v-if="this.type === 'video'">
            <div class="accessory-box">
              <div class="accessory-img clearfix">
                <ul class="photo-img">
                  <li  v-for="(item,index) in videoFilesData" :key="index">
                    <img :src="getimgUrl(item.imgUrl)" alt="" class="imgud">
                    <img src="../../assets/cancel.png" alt="" class="cancel" @click="clodesd(getimgUrl(item.url))">
                  </li>
                </ul>
                  <a class="up-photo" href="javascript:;" v-show="imgLenght">
                    <img src="../../assets/addup.jpg" alt="">
                    <div id='image-list' class="mui_uploader">
                      <input id="uploaderInputVideo" class="mui_uploader_input" value="" type="file"  accept="video/*" capture="camcorder" >
                    </div>
                  </a>
                  <video width="352" height="264" controls autobuffer v-if="videoFiles.videoUrl">
                    <source :src="getimgUrl(videoFiles.videoUrl)" type='video/mp4; codecs="avc1.42E01E, mp4a.40.2"'></source>
                  </video>
              </div>
            </div>

            <div class="ps-info">
                <p>注：小视频的长度不能超过10秒,超过的视频服务器会自动截取前10秒内容。</p>
                <div>
                    <button
                        @click="submitVideo()"
                        class="btn-uploder right"
                        type="submit"
                        >发布
                    </button>
                </div>
            </div>
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
  //import Photo from "./photo.vue"
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
    this.type = this.$route.query.path;
    console.log(this.type);

  },
    mounted(){
      let _this = this
      _this.type = this.$route.query.path;
      if( _this.type === 'photo' ){
        _this.onClickUp()
      }
      if( _this.type === 'video' ){
        _this.uploaderInputVideo()
      }
    },
    data(){
      return {
          type:'',
          contentValue: "",
          uploadImg:[],
          imgLenght: true,
          showPositionValue: false,
          showToast: true,
          position: "default",
          toastMessage: "",
          imgfileData:[],
          pathImgs:[],
          videoFilesData:[],
          videoFiles:{},
          SPACE_ID:'',
          CONTENT:'',
          IMG_LIST:'',
          TOPIC_ID:'',
          DEL_LIST:''
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
        let _this = this;
        let formData = new FormData();
        var f2 = document.querySelector('#uploaderInput');
        f2.onchange = function (e) {
          console.log(e);
            var files = e.target.files;
            var len = files.length;
            var data = [];
            if (len > 9 || _this.imgfileData.length + len > 9 ){
                alert('图片最多只能上传9张', 'error');
                e.target.value = '';
                return false;
            }
            for(var i=0;i<len;i++){
                //$("#all_pic").append("<div style='float: left;width:100px;height:50px' name='all_pic_img'><img style='width:50px;height:50px' src='"+getFileURL(files[i])+"'/><a onclick=\"del('"+files[i].name+"',"+i+")\" id='all_pic_img_"+i+"'>删除</a></div>")
                var a={
                    'val':files[i]
                };
                data.push(a);
            }
            _this.goUploder(data,function(re_files){
                e.target.value = '';
                _this.imgfileData = _this.imgfileData.concat(re_files);
                console.log('_this.imgfileData::',_this.imgfileData);

            })
        }
      },
      clodesd(url){
          let _this = this;
          let arr = [];
          for(let i = 0; i < _this.imgfileData.length; i++) {
            arr.push(_this.imgfileData[i].url)
          }

          var r=confirm("是否删除？");
          console.log(arr)
          if(r==true){
              var index = arr.indexOf(url);
              console.log(index);
              if (index > -1) {
                  _this.imgfileData.splice(index, 1);
                  console.log(_this.imgfileData);
              }
              // $("#all_pic_img_"+id).parent().remove();
          }
      },
      goUploder(data,callback){
        let _this = this;
        let len = data.length;
        let formData = new FormData();
        if(len < 1){
          alert("请选择文件")
        }else {
          for(var i=0;i<len;i++){
            formData.append('file',data[i].val);
          }
          _this.$http.post(apiRouter.POST_IMG,formData)
          .then(
            (response) => {
              if( response.status === 200 ){
                let _files = response.body.files;
                callback && callback(_files);
              }
            },
            (error) => {
              alert("请求失败了!!!!")
            }
          );
        }
      },
      getimgUrl(uri){
        return "https://gz.lqtedu.com"+uri
      },
      submit(){
        let _this = this;
        // let objData = {
        //     SPACE_ID
        //     CONTENT:_this.contentValue
        // }
        let url = apiRouter.SEND_SPACE + "?SPACE_ID=" +  _this.SPACE_ID + '&CONTENT=' + _this.CONTENT + '&IMG_LIST=' + _this.IMG_LIST + '&TOPIC_ID=' + _this.TOPIC_ID + '&DEL_LIST=' + _this.DEL_LIST;
         _this.$http.post(url,objData)
          .then(
            (response) => {
              if( response.status === 200 ){
                alert("ok")
              }
            },
            (error) => {
              alert("请求失败了!!!!")
            }
          );
      },



        // 上传视频
        uploaderInputVideo(){
          let _this = this;
          let formData = new FormData();
          var f2 = document.querySelector('#uploaderInputVideo');
          f2.onchange = function (e) {
            var files = f2.files;
            var len = files.length;
            var data = [];
            console.log('files::',files);
            if (len > 1 || _this.videoFilesData.length + len > 1 ){
                alert('图片最多只能上传1张', 'error');
                e.target.value = '';
                return false;
            } else {
              var a={
                'val':files[0]
              };
              data.push(a);
            }
            _this.goUploderVideo(data,function(re_file){
                e.target.value = '';
                _this.videoFiles = re_file;
                //_this.videoFilesData = _this.videoFilesData.concat(re_files);
                console.log('_this.videoFiles::',_this.videoFiles);

            })
          }
        },

        goUploderVideo(data,callback){
        let _this = this;
        let len = data.length;
        let formData = new FormData();
        if(len < 1){
          alert("请选择文件")
        }else {
          for(var i=0;i<len;i++){
            formData.append('file',data[i].val);
          }
          _this.$http.post(apiRouter.GET_VIDEO,formData)
          .then(
            (response) => {
              if( response.status === 200 ){
                let _file = response.body.file;
                callback && callback(_file);
              }
            },
            (error) => {
              alert("请求失败了!!!!")
            }
          );
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
    width: 150/@baseSize;
    height: 150/@baseSize;
    display: block;
    position: relative;
  }

  .photo-img li {
    margin-right: 22/@baseSize;
    position: relative;
  }
  // .photo-img li:last-child{
  //   margin-right: 0;
  // }

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



  .mui_uploader{
    width: 150/@baseSize;
    height: 150/@baseSize;
    position: absolute;
    top: 0px;
    left: 0px;
  }
  .mui_uploader .mui_uploader_input{
    width: 150/@baseSize;
    height: 150/@baseSize;
    display: block;
    opacity: 0;
  }


</style>
