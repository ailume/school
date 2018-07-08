<template>
  <div class="box">
    <back></back>
    <h3 class="title">请选择通知范围</h3>
    <div class="curriculum clearfix">
      <div class="curriculum-list clearfix" v-for="(items,index1) in curriculum">
        <h4><em>课</em><span>{{items.courseNmae}}</span></h4>
        <ul class="curriculum-name">
          <li class="cleafix" @click="chooseBtn(item,index1)" v-for="(item,index2) in items.members">
            <em :class="{ icon: item.selected }"><i></i></em>
            <span>{{item.toName}}</span>
          </li>
        </ul>
      </div>
    </div>
    <p class="pltne-btn" @click="pltneBtn('middle','请选择')">完成</p>
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
  import { Toast } from 'vux'
  import Back from "../../components/common/Back.vue"
  import apiRouter from "../../config/api.js"
  import {mapGetters,mapMutations} from 'vuex'
  export default {
    components: {
      Back,
      Toast
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
    methods: {
      chooseBtn(item, groupIndex){
        if (typeof item.selected === 'undefined') {
          item.selected = true;
        } else {
          item.selected = !item.selected;
        }
        this.$set(this.curriculum, groupIndex, this.curriculum[groupIndex]);
      },
      pltneBtn(position,msg){
        let choices = [];
        this.curriculum.forEach((course, index) => {
          course.members.forEach((student) => {
            if (student.selected) {
              choices.push(student);
            }
          });
        });

        this.curriculumMeans(choices);
        let curriculumString = JSON.stringify(choices)
        window.localStorage.setItem("CURRICULUM",curriculumString)
        if( curriculumString === "[]" && curriculumString.length === 2 ){
          this.position = position
          this.toastMessage=msg
          this.showPositionValue = true
        }else{
          this.$router.push({path: "posted",query:{path:"curriculum"}})
        }

      },
      showData(){
        let _this = this;
        let pathUrl = apiRouter.SCOPE_CURRICULUM+"?"+
          'objectId=' + this.objType.objectId +
          "&type=" + this.objType.type +
          "&objectName=" + this.objType.objectName;
        this.$http.get(pathUrl).then(response => {
          return _this.curriculum = response.body.data;
        }, response => {
          alert("请求失败了!!!!")
        });
      },
      ...mapMutations({
        curriculumMeans:"SET_CURRICULUM"
      })
    },
    data(){
      return {
        isActive: false,
        curriculum:[],

        showPositionValue: false,
        showToast: true,
        position: 'default',
        toastMessage: '',

        objType:{
          type:"",
          objectId:"",
          objectName:""
        }


      }
    }
  }
</script>

<style lang="less" scoped>
  @import '../../style/minxin.less';
.box{
  padding-bottom: 80/@baseSize;
}

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

  .curriculum-list {
    width: 100%;
  }

  .curriculum-list h4 {
    .mixin-padding(30/@baseSize, 30/@baseSize);
    height: 100/@baseSize;
    line-height: 100/@baseSize;
    border-bottom: 1px solid @colorDD;
  }

  .curriculum-list h4 em {
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

  .curriculum-list h4 span {
    margin-left: 20/@baseSize;
    float: left;
    font-size: @fontSize30;
    color: @color42;
  }

  .curriculum-name {
    width: 100%;
  }

  .curriculum-name li {
    .mixin-padding(30/@baseSize, 30/@baseSize);
    height: 100/@baseSize;
    line-height: 104/@baseSize;
    border-bottom: 1px solid @colorDD;
  }

  .curriculum-name li em {
    width: 38/@baseSize;
    height: 38/@baseSize;
    display: block;
    float: left;
    border: 1px solid @green;
    border-radius: 4px;
    margin-top: 28/@baseSize;
  }

  .curriculum-name li em.icon {
    border: 1px solid @green;
  }

  .curriculum-name li em.icon i {
    width: 19/@baseSize;
    height: 20/@baseSize;
    margin-top: 9/@baseSize;
    margin-left: auto;
    margin-right: auto;
    background: url("../../assets/checkmarks.png") no-repeat;
    background-size: 100% 100%;
    display: block;
  }

  .curriculum-name li span {
    margin-left: 20/@baseSize;
    font-size: @fontSize30;
    color: @color42;
  }

  .pltne-btn {
    width: 100%;
    height: 80/@baseSize;
    line-height: 80/@baseSize;
    font-size: @fontSize30;
    color: @white;
    background: @green;
    margin-top: 80/@baseSize;
    text-align: center;
    position: fixed;
    bottom:0;
  }

</style>
