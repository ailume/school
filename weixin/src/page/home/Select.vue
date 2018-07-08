<template>
  <div class="box">
    <back></back>
    <h3 class="title">请选择通知范围</h3>
    <div class="curriculum clearfix">
      <ul class="curriculum-name">
        <li class="cleafix" v-for="(user,index) in this.nameData" :keyNumber="key">
          <div @click="chooseBtn(user,index)">
            <em :class="{ icon: user.selected }"><i></i></em>
            <span>{{user.toName}}</span>
          </div>

        </li>
      </ul>
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
  import {Toast} from 'vux'
  import Back from "../../components/common/Back.vue"
  import {mapGetters,mapMutations,mapState} from 'vuex'
  export default {
    components: {
      Back,
      Toast
    },
    mounted(){

    },
    computed: {
      ...mapGetters([
        "nameData",
      ])

    },
    created(){
    //  this.userSamr = this.nameData;
    },

    activated(){
        this.key += 1;
    //  this.userSamr = this.nameData;
       /* console.log(this.nameData.length)
        if(this.nameData.length == 0 ){
          this.$router.push({path: "grade"})
        }*/


    },

    methods: {
      chooseBtn(item, index){
        if (typeof item.selected === 'undefined') {
          item.selected = true;
        } else {
          item.selected = !item.selected;
        }
        //this.nameData[index] =item;
        this.$set(this.nameData, index, item);
        //this.setNamessData(this.nameData)
        this.$route.query.onItemClick(item, index);
      },
      pltneBtn(position, msg){
        let choices = [];
        this.nameData.forEach((course, index) => {
          if (course.selected) {
            //choices.push(course.name);
          }
        });

        this.$router.go(-1)

      },
      ...mapMutations({
        setNamessData:'SET_NAMEDATA'
      })

    },
    data(){
      return {
        isActive: false,
        students: [],

        showPositionValue: false,
        showToast: true,
        position: 'default',
        toastMessage: '',

        userSamr:[],

        key:1,
      }
    },
  }
</script>

<style lang="less" scoped>
  @import '../../style/minxin.less';
.box{
  padding-bottom:80/@baseSize;
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
