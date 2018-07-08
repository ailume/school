<template>
  <div class="form-info clearfix">
    <p class="cancel-btn" @click="cancel()">取消发布</p>
    <!--<form action="/" method="post">-->
    <div class="scope clearfix">
      <div @click="goBack()">
        <cell class="scope-box" title="通知类型与发送范围" :value="this.objType.objectName" is-link></cell>
      </div>
      <!--<input type="hidden" name="type" v-model="type">-->
      <input type="hidden" name="objectId" v-model="objectId">
      <div class="span-cell clearfix">
        <span v-for="(item,index) in scope" :key="index">{{item}}</span>
      </div>
      <!-- <input type="hidden" name="userList" v-model="userList">-->


    </div>
    <div class="scope-title-box">
      <p class="scope-title">通知标题</p>
      <x-textarea
        :max="50"
        @on-focus="onEvent('focus')"
        @on-blur="onEvent('blur')"
        class="x-textarea"
        placeholder="请输入通知标题"
        :rows="2"
        v-model="titleValue"
      >
      </x-textarea>
      <!--<input type="hidden" name="title" v-model="titleValue">-->
    </div>

    <div class="write-back">
      <label class="write-back-left">通知是否允许回复</label>
      <div class="write-back-right">
        <checker
          v-model="allow"
          type="radio"
          default-item-class="write-back-item"
          selected-item-class="write-back-selected"
          radio-required="false"
        >
          <checker-item
            v-for="(item,i) in isBack" :key="i" :value="i">{{item}}
          </checker-item>
        </checker>
      </div>
    </div>

    <div class="scope-data-box">
      <x-address
        :title="title2"
        v-model="timeData"
        raw-value :list="addressData"
        hide-district
        value-text-align="right"
        class="x-address"
      >
      </x-address>
    </div>



    <div class="scope-title-box">
      <p class="scope-title">通知内容</p>
      <x-textarea
        :max="1000"
        @on-focus="onEvent('focus')"
        @on-blur="onEvent('blur')"
        class="x-textarea"
        placeholder="请输入通知内容"
        :rows="7"
        v-model="contentValue"
      >
      </x-textarea>
    </div>
    <div class="accessory-box">
      <p class="accessory-title">通知附件</p>
      <div class="accessory-img clearfix">
        <ul class="photo-img">
          <li v-for="(item,index) in localIdImgs" :key="index">
            <img :src="item" alt="" class="imgud">
            <img src="../../assets/cancel.png" alt="" class="cancel" @click="clodesd(index)">
          </li>
        </ul>
          <a class="up-photo" href="javascript:;" @click="onClickUp()" v-show="imgLenght">
            <img src="../../assets/addup.jpg" alt="">
          </a>
      </div>
    </div>

    <button
      @click="goUploder()"
      class="btn-uploder right"
      type="submit"
    >发布通知
    </button>

    <toast
      v-model="showPositionValue"
      type="text"
      :time="800"
      is-show-mask
      :position="position"
    >
      {{toastMessage}}
    </toast>

    <!-- </form>-->

  </div>
</template>

<script>
  import {mapGetters} from 'vuex'
  import {
    Toast,
    Checker,
    CheckerItem,
    Group,
    XAddress,
    XTextarea,
    ChinaAddressV3Data,
    XButton,
    Cell,
    Radio,
    Value2nameFilter as value2name
  } from 'vux'
  import axios from 'axios'
  import wx from 'weixin-js-sdk'
  import {getSelectDates} from '../../utils/DateUtils';
  import apiRouter from "../../config/api.js"
  export default {
    created: function () {
      //getSelectDates();
      //timeData()
      this.showTop()
      this.localIdImgs = []
    },
    components: {
      Toast,
      Group,
      XAddress,
      Cell,
      XButton,
      XTextarea,
      Checker,
      CheckerItem,
      Radio
    },
    data () {
      return {
        imgLenght: true,
        imgaesMaxLenght:9,
        images:{
          localId: [],
          serverId: []
        },

        radio: [ '允许', '不允许' ],
        radioValue: '允许',

        itemId:"",

        objType: {
          type: "",
          objectId: "",
          objectName: ""
        },
        userList: [],
        localIdImgs: [],
        serverId: [],
        localData:[],
        type: '',
        objectId: '',
        noticeTime: "",
        urlPath: "",
        commentFlag: true,
        objectName: "",
        allow: 0,
        scope: [],
        titleValue: "",
        contentValue: "",
        showPositionValue: false,
        showToast: true,
        position: 'default',
        toastMessage: '',
        title: "时间选择",
        title2: '通知发送时间',
        timeData: ['今天', '立刻发送'],
        isBack: [
          "允许",
          "不允许"
        ],
        addressData: getSelectDates(),
        showAddress: false
      }
    },

    computed: {
      ...mapGetters([
        "spaceStore",
        "optionalStore",
        "curriculumStore",
        "gradeStore",
        "schoolStore",
        "messageStore"
      ])
    },
    activated(){
      this.showTop()
      this.localIdImgs = []
      this.titleValue = "";
      this.contentValue = "";
      let path = this.$route.query.path
      if (path === "Space") {
        let stringStore = JSON.stringify(this.spaceStore);
        let stringArray = this.spaceStore;
        if (stringStore === "[]" && stringStore.length === 2) {
          this.userList = JSON.parse(window.localStorage.SPACE);
          this.objType = JSON.parse(window.localStorage.type);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.userList.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        } else {
          this.userList = JSON.parse(window.localStorage.SPACE);
          this.objType = JSON.parse(window.localStorage.type);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.scope = [];
          stringArray.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        }
      } else if (path === "Optional") {
        let stringStore = JSON.stringify(this.optionalStore);
        let stringArray = this.optionalStore;
        if (stringStore === "[]" && stringStore.length === 2) {
          this.userList = JSON.parse(window.localStorage.OPTIONAL);
          this.objType = JSON.parse(window.localStorage.type);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.userList.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        } else {
          this.userList = JSON.parse(window.localStorage.OPTIONAL);
          this.objType = JSON.parse(window.localStorage.type);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.scope = [];
          stringArray.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        }
      } else if (path === "curriculum") {
        let stringStore = JSON.stringify(this.curriculumStore);
        let stringArray = this.curriculumStore;
        if (stringStore === "[]" && stringStore.length === 2) {
          this.userList = JSON.parse(window.localStorage.CURRICULUM);
          this.objType = JSON.parse(window.localStorage.type);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.userList.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        } else {
          this.userList = JSON.parse(window.localStorage.CURRICULUM);
          this.objType = JSON.parse(window.localStorage.type);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.scope = [];
          stringArray.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        }
      } else if (path === "Grade") {
        let stringStore = JSON.stringify(this.gradeStore);
        let stringArray = this.gradeStore;
        if (stringStore === "[]" && stringStore.length === 2) {
          this.userList = JSON.parse(window.localStorage.GRADE);
          this.objType = JSON.parse(window.localStorage.type);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.userList.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        } else {
          this.userList = JSON.parse(window.localStorage.GRADE);
          this.objType = JSON.parse(window.localStorage.type);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.scope = [];
          stringArray.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        }
      } else if (path === "Notice") {
        let stringStore = JSON.stringify(this.schoolStore);
        let stringArray = this.schoolStore;
        if (stringStore === "[]" && stringStore.length === 2) {
          this.userList = JSON.parse(window.localStorage.NOTICE);
          this.objType = JSON.parse(window.localStorage.type);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.userList.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        } else {
          this.userList = JSON.parse(window.localStorage.NOTICE);
          this.objType = JSON.parse(window.localStorage.type);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.scope = [];
          stringArray.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        }
      } else if (path === "Message") {
        let stringStore = JSON.stringify(this.messageStore);
        this.itemId = this.$route.query.itemId
        let stringArray = this.messageStore;
        if (stringStore === "[]" && stringStore.length === 2) {
          this.userList = JSON.parse(window.localStorage.MESSAGE).userList;
          this.titleValue = JSON.parse(window.localStorage.MESSAGE).title;
          let cheoonOn = JSON.parse(window.localStorage.MESSAGE).commentFlag
          let imgs  = JSON.parse(window.localStorage.MESSAGE).imgList;
          this.serverId = imgs;
            imgs.forEach((item, index) => {
              this.localIdImgs.push( roterPath +  item.url);
          })

          if( cheoonOn === true ){
            this.allow = 0;
          }else{
            this.allow = 1;
          }
          this.contentValue = JSON.parse(window.localStorage.MESSAGE).content;
          this.objType = JSON.parse(window.localStorage.MESSAGE);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;
          this.userList.forEach((item, index) => {
            this.scope.push(item.toName)
          })
        } else {
          let cheoonOn = stringArray.commentFlag
          if( cheoonOn === true ){
            this.allow = 0;
          }else{
            this.allow = 1;
          }
          this.titleValue = stringArray.title;
          this.contentValue = stringArray.content;
          this.objType = JSON.parse(window.localStorage.MESSAGE);
          this.objType.objectId = this.objType.objectId;
          this.objType.type = this.objType.type;
          this.objType.objectName = this.objType.objectName;

          let imgs  = stringArray.imgList;
          this.serverId = imgs;
          this.localIdImgs = [];
          imgs.forEach((item, index) => {
            this.localIdImgs.push( roterPath +  item.url);
          })

          this.scope = [];
          stringArray.userList.forEach((item, index) => {
            this.scope.push(item.toName)
          })
          this.userList = stringArray.userList
        }
      }

      if( this.localIdImgs.length >= this.imgaesMaxLenght ){
        this.imgLenght = false
      }else{
        this.imgLenght = true
      }

    },


    mounted(){
     // console.log(apiRouter.POST_SEND)
      this.localIdImgs = []
      this.urlPath = window.location.href.split("#")[0];
      this.getUrlConfig()
    },
    methods: {

      showTop(){
        window.scrollTo(0,0);
      },

      goBack(){
        if( this.$route.query.path === "Message" ){
          return;
        }else{
          this.$router.go(-1)
        }
      },

      add0(m){return m<10?'0'+m:m },
      format(shijianchuo){
        var time = new Date(parseInt(shijianchuo));
        var y = time.getFullYear();
        var m = time.getMonth()+1;
        var d = time.getDate();
        return y+'-'+this.add0(m)+'-'+this.add0(d);
      },

      change(value, label) {
      //  console.log('change:', value, label)
      },
      goUploder(position, msg){

        if( this.allow === 0 ){
          this.commentFlag = true
        }else{
          this.commentFlag = false
        }

        let data = this.format(this.timeData[0]);
        let time = this.timeData[1]
        let dataDatime = data + " " + time


        if (this.titleValue === "") {
          this.position = position
          this.toastMessage = "请填写标题"
          this.showPositionValue = true
        } else if (this.contentValue === "") {
          this.position = position
          this.toastMessage = "请填写内容"
          this.showPositionValue = true
        } else {
        //    console.log(this.userList);return
          let sendObj = {
            id:this.itemId,
            type: this.objType.type,
            objectId: this.objType.objectId,
            title: this.titleValue,
            content: this.contentValue,
            commentFlag: this.commentFlag,
            noticeTime: dataDatime,
            userList: JSON.stringify(this.userList),
            imgList: JSON.stringify(this.serverId)

          }
        //  console.log(JSON.stringify(sendObj))
          let _this = this;
          _this.$http.post(apiRouter.POST_SEND,sendObj)
            .then(
              (response) => {
                if( response.body.status === 200 ){
                  _this.position = position
                  _this.toastMessage = response.body.message
                  _this.showPositionValue = true
                  setTimeout(_this.backHome,1200)
                }else{
                  _this.position = position
                  _this.toastMessage = response.body.message
                  _this.showPositionValue = true
                }
              },
              (error) => {
                _this.position = position
                _this.toastMessage = response.body.message
                _this.showPositionValue = true
              }
            );
        }

      },
      backHome(){
      //  this.$router.replace("/")
        window.location.replace(roterPath + "/weixin/wechat/dist/index.html")
      //  this.deleteLocalStorage()
      },
      cancel(){
      //  this.$router.push({path: "/"})
        this.$router.go(-1)
        //window.location.href = roterPath + "/weixin/wechat/dist/index.html#/"
      },
     /* deleteLocalStorage(){
        localStorage.removeItem('type');
        localStorage.removeItem('SPACE');
        localStorage.removeItem('OPTIONAL');
        localStorage.removeItem('CURRICULUM');
        localStorage.removeItem('GRADE');
        localStorage.removeItem('MESSAGE');
      },*/
      onEvent (event) {
        //   console.log('on', event)
      },



      // 获取 微信接口 config 的配置参数
      getUrlConfig(){
        let wiexin = apiRouter.GET_CONFIG + encodeURIComponent(this.urlPath)
        this.$http.get(wiexin).then(response => {
          let data = response.body
          wx.config({
           // debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: data.appId, // 必填，企业号的唯一标识，此处填写企业号corpid
            timestamp: data.timestamp, // 必填，生成签名的时间戳
            nonceStr: data.nonceStr, // 必填，生成签名的随机串
            signature: data.signature,// 必填，签名，见附录1
            jsApiList: ["chooseImage", "uploadImage", "downloadImage","getLocalImgData","previewImage","chooseWXPay"] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
          });
          wx.error(function (res) {
         //   alert(res)
          });

        }, response => {
          // console.log("请求失败了!!!!")
        });
      },


      // 上传图片
      onClickUp(){
        let _this = this;
        wx.chooseImage({
          count: _this.imgaesMaxLenght -  _this.localIdImgs.length, // 默认9
          sizeType: ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
          sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有
          success: function (res) {
            let localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
            if (window.__wxjs_is_wkwebview) {
            //  _this.wxgetLocalImgData(localIds);
            //  setTimeout(function (){
                _this.wxgetLocalImgData(localIds);
            //  }, 10);
            }else{
              localIds.forEach((item, index) => {
                _this.localIdImgs.push(item);
                if( _this.localIdImgs.length >= _this.imgaesMaxLenght ){
                  _this.imgLenght = false
                }
              });
            }
          //  _this.wxuploadImage(localIds);
          //  setTimeout(function (){
              _this.wxuploadImage(localIds);
          //  }, 10);
          },
          fail: function (res) {
            console.log("失败")
          }
        });
      },

     wxuploadImage(localIds) {
       let _this = this;
       var i = 0; var length = localIds.length;
       var upload = function() {
         let loacId = localIds[i];
         if (window.__wxjs_is_wkwebview) {
           if (loacId.indexOf("wxlocalresource") != -1) {
             loacId = loacId.replace("wxlocalresource", "wxLocalResource");
           }
         }
         wx.uploadImage({
           localId: loacId, // 需要上传的图片的本地ID，由chooseImage接口获得
           isShowProgressTips: 1, // 默认为1，显示进度提示
           success: function (res) {
         //    alert(res.serverId);
             var serverId = {
               id:'',
               serverid:res.serverId
             }
             _this.serverId.push(serverId);
             i++;
           //  i < length && upload();
             if(i < length){
               setTimeout(function (){
                 upload();
               }, 10);
             }
           },
           fail: function (error) {
             alert("失败11")
           }
         });
       }
       upload();
      },
      wxgetLocalImgData(localIds){
        let _this = this;
        var i = 0; var length = localIds.length;
        var upload = function() {
          wx.getLocalImgData({
            localId: localIds[i], // 图片的localID
            success: function (res) {
              let localData = res.localData; // localData是图片的base64数据，可以用img标签显示
              localData = localData.replace('jgp', 'jpeg');
              _this.localIdImgs.push(localData);
              if( _this.localIdImgs.length >= _this.imgaesMaxLenght ){
                _this.imgLenght = false
              }
              i++;
            //  i < length && upload();
              if(i < length){
                setTimeout(function (){
                  upload();
                }, 10);
              }
            }
          });
        }
        upload();
      },

      removeByValue(arr, val) {
        for(var i=0; i<arr.length; i++) {
          if(i == val) {
            arr.splice(i, 1);
            break;
          }
        }
      },
      clodesd(index){
        let _this = this;
        _this.removeByValue(_this.localIdImgs,index);
        _this.removeByValue(_this.serverId,index);
        if( _this.localIdImgs.length < _this.imgaesMaxLenght ){
          _this.imgLenght = true
        }
      }
  }
  }
</script>
<style lang="less">
  @import '../../style/minxin.less';

  .form-info {
    padding-bottom: 100/@baseSize;
    padding-top: 100/@baseSize;
  }

  .img-t{
    width: 80/@baseSize;
    height: 80/@baseSize;
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

  .posted-title {
    display: block;
    font-size: @fontSize30;
    color: @color42;
    line-height: 1.5rem;
    .mixin-padding(50/@baseSize, 50/@baseSize)
  }

  .x-textarea {
    font-size: @fontSize24;
  }

  .weui-label {
    font-size: @fontSize30;
  }

  .vux-popup-picker-placeholder {
    font-size: @fontSize30;
  }

  .form-info .vux-cell-box:before, .form-info .weui-cell:before {
    left: 0;
  }

  .span-cell {
    .mixin-padding(30/@baseSize, 30/@baseSize);
    margin-top: 20/@baseSize;
    margin-bottom: 20/@baseSize;
  }

  .span-cell span {
    border: 1px solid @green;
    border-radius: 4px;
    .mixin-padding(20/@baseSize, 20/@baseSize);
    font-size: @fontSize24;
    color: @color42;
    height: 50/@baseSize;
    line-height: 52/@baseSize;
    display: inline-block;
    float: left;
    margin-right: 20/@baseSize;
    margin-bottom: 20/@baseSize;
  }

  .scope, .scope-data-box {
    border-bottom: 1px solid @colorDD;
  }

  .scope-title {
    padding-left: 30/@baseSize;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
    font-size: @fontSize30;
    color: @color42;
    margin-top: 15/@baseSize;
  }

  .scope-title-box {
    border-bottom: 1px solid @colorDD
  }

  .form-info .weui-cell:before {
    border-top: none;
  }

  .write-back {
    line-height: 90/@baseSize;
    height: 90/@baseSize;
    .mixin-padding(30/@baseSize, 30/@baseSize);
    position: relative;
  }

  .write-back-left {
    display: inline-block;
    position: absolute;
    line-height: 90/@baseSize;
    height: 90/@baseSize;
    left: 30/@baseSize;
    font-size: @fontSize30;
  }

  .write-back-right {
    margin-left: 280/@baseSize;
  }

  .write-back-item {
    border: 1px solid @color97;
    margin-left: 15/@baseSize;
    height: 50/@baseSize;
    display: inline-block;
    line-height: 52/@baseSize;
    font-size: @fontSize24;
    .mixin-padding(30/@baseSize, 30/@baseSize);
    color: @color97;
    border-radius: 4px;
  }

  .write-back-selected, .write-back-selected {
    background: url("../../assets/combined.png") no-repeat right bottom;
    background-size: 25/@baseSize 24/@baseSize;
    border-color: @green;
    color: @color42;
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

</style>
