<template>
  <div class="box">
    <back></back>
    <h3 class="title">请选择通知范围</h3>
    <div class="curriculum clearfix">
      <div class="curriculum-list clearfix" v-for="(items,index1) in curriculum">
        <h4><em>班</em><span>{{items.className}}</span></h4>
        <ul class="curriculum-name">
          <li class="cleafix" v-for="(item,index2) in items.members">
            <div class="curricu-left left" @click="chooseBtn(item,index1,index2)">
              <em :class="{ icon: item.selected }"><i></i></em>
              <span>{{ item.toName }}</span>
            </div>
            <div class="curricu-right right" @click="choosePoser(item,index1,index2)">
              <span>{{showChoiceHint(item)}}</span>
              <em> </em></div>
          </li>
        </ul>
      </div>
    </div>
    <p class="pltne-btn" @click="pltneBtn()">完成</p>
  </div>
</template>

<script>
  import Back from "../../components/common/Back.vue"
  import {mapGetters,mapMutations} from 'vuex'
  import apiRouter from "../../config/api.js"
  export default {
    components: {
      Back
    },
    computed: {
      ...mapGetters([
        "choolesType",
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
      chooseBtn(item, groupIndex,index2){
        if (typeof item.selected === 'undefined') {
          item.selected = true;
        } else {
          item.selected = !item.selected;
        }
        if(item.selected){
          this.curriculum[groupIndex].members[index2].users.forEach((user,index)=>{
            user.selected=false;
          })
        }
        this.$set(this.curriculum, groupIndex, this.curriculum[groupIndex]);

      },
      pltneBtn(){
        let path = this.$route.name
        let choices = [];
        this.curriculum.forEach((course, index) => {
          course.members.forEach((student) => {
            if (student.selected) {
              choices.push(...student.users);
            }else{
              student.users.forEach((user,index)=>{
                if(user.selected){
                  choices.push(user);
                }
              })
            }
          });
        });

        this.setGrade(choices)
        let gradeString = JSON.stringify(choices)
        window.localStorage.setItem("GRADE",gradeString)
        if( gradeString === "[]" && gradeString.length === 2 ){
          this.position = position
          this.toastMessage=msg
          this.showPositionValue = true
        }else{
          this.$router.push({path: "posted",query:{path:"Grade"}})
        }
      },

      choosePoser(item, index1, index2){
        let self = this;
        self.setNameData(item.users);
        this.$router.push({
          path: 'select', query: {
            onItemClick: function (item, index3) {
              self.onItemClick(item, index1, index2, index3);
            }
          }
        });
      },
      showData(){
     //   if (this.curriculum.length > 0)return;
        let _this = this;
        let pathUrl =apiRouter.SCOPE_GRADE +"?" +
          'objectId=' + this.objType.objectId +
          "&type=" + this.objType.type +
          "&objectName=" + this.objType.objectName;
        this.$http.get(pathUrl).then(response => {
          this.curriculum=response.body.data;
        }, response => {
          alert("请求失败了!!!!")
        });
      },

      onItemClick: function (item, index1, index2, index3) {
        let gradeBean = this.curriculum[index1];
        let memebersBean = gradeBean.members;
        let classBean = memebersBean[index2];
        classBean.selected=false;
        this.$set(classBean, index3, item);
        this.$set(gradeBean, index2, classBean);
        this.$set(this.curriculum, index1, gradeBean);
      },
      showChoiceHint: function (member) {
        let msg = '';
        member.users.forEach((user, index) => {
          if (user.selected) {
            msg += user.toName+",";
          }
        });
        if (msg.length === 0) {
            msg = '请选择';
        }
       // return msg.substring(0,msg.length-1) ;
          return msg;
      },

      ...mapMutations({
        setUsers: "SET_USERS",
        setNameData:'SET_NAMEDATA',
        setGrade:"SET_DRADE"
      })

    },
    data(){
      return {
        isActive: false,
        //  listName:"请选择"
        curriculum:[],
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
    overflow: hidden;
  }
  .curricu-left em {
    width: 38/@baseSize;
    height: 38/@baseSize;
    display: block;
    float: left;
    margin-top: 28/@baseSize;
    border: 1px solid @green;
    border-radius: 4px;
  }

  .curricu-left em.icon {
  }

  .curricu-left em.icon i {
    width: 19/@baseSize;
    height: 20/@baseSize;
    margin-top: 9/@baseSize;
    margin-left: auto;
    margin-right: auto;
    background: url("../../assets/checkmarks.png") no-repeat;
    background-size: 100% 100%;
    display: block;
  }

  .curricu-left span {
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

  .curricu-right{
    height: 100/@baseSize;
    overflow: hidden;
  }
  .curricu-right span {
    width: 200/@baseSize;
    height: 100/@baseSize;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    font-size: @fontSize30;
    color: @color42;
    display: inline-block;
    text-align: right;
  }

  .curricu-right em {
    width: 14/@baseSize;
    height: 24/@baseSize;
    background: url("../../assets/chevron right.png");
    background-size: 100% 100%;
    display: block;
    float: right;
    margin-top: 38/@baseSize;
    margin-left: 20/@baseSize;
  }

</style>
