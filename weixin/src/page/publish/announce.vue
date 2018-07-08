<template>
  <div class="box">
    <back></back>
    <h3 class="title">请选择作业发布对象</h3>
    <div class="curriculum clearfix">
      <div class="curriculum-list clearfix" v-for="(items,index) in scopeData" :key="index">
        <h4 class="titleTop" ref='isIcon'>
          <div class="titleTopLeft">
            <em>{{items.COURSE_SHORT_NAME}}</em><span>{{items.COURSE_NAME}}</span>
          </div>
          <div class="chooesAll"
          @click='chooseAll(items,index,items.COURSE_ID)'
          ><em
          :class="{ icon: items.selected }"
          ><i></i></em><span>全选</span></div>
        </h4>
        <ul class="curriculum-name">
          <li
           :data-choose = 'items.COURSE_ID'
           class="liclass cleafix" 
           v-for="(item,qt) in items.CLASS_LIST" 
           :key="qt" 
           @click="chooseBtn(item,index,items)"
           ref="reference"
           >
            <em
             :class="{ icon: item.selected }"
            ><i></i></em>
            <span>{{item.CLASS_NAME}}</span>
          </li>
        </ul>
      </div>
    </div>
    <p class="pltne-btn" @click="pltneBtn('middle')">完成</p>
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
import { Toast, Checker, CheckerItem, Checklist } from "vux";
import Back from "../../components/common/Back.vue";
import apiRouter from "../../config/api.js";
import { choose } from "../../utils/utils.js";
import { mapGetters, mapMutations } from "vuex";
export default {
  components: {
    Back,
    Toast,
    Checker,
    CheckerItem,
    Checklist
  },
  data() {
    return {
      showPositionValue: false,
      showToast: true,
      position: "default",
      toastMessage: "请选择",
      scopeData: [],
      demo1: "",
      commonList: ["China", "Japan", "America"],
      title: "seee",
      labelPosition: "",
      checklist001: [],
      courseId: ""
    };
  },
  computed: {},
  created() {},
  mounted() {
    this.showData();
  },
  methods: {
    showData() {
      let _this = this;
      this.$http.get(apiRouter.GET_HOMEWORKSCOPE).then(
        response => {
          if (response.body.status == 200) {
            _this.scopeData = response.body.data;
            console.log(_this.scopeData);
          }
        },
        response => {}
      );
    },

    change(val, label) {
      console.log("change", val, label);
    },

    /**
     * 单选
     */
    chooseBtn(item, groupIndex, items, courseId) {
      console.log(items);
      console.log(items.COURSE_ID);
      let arr = [];
      if (typeof item.selected === "undefined" || item.selected === false) {
        item.selected = true;
        let index = 0;
        for (let i = 0; i < items.CLASS_LIST.length; i++) {
          let li = items.CLASS_LIST[i].selected;
          if (li === true) {
            index += 1;
          }
        }
        if (index === items.CLASS_LIST.length) {
          items.selected = true;
          for (let i = 0; i < items.CLASS_LIST.length; i++) {
            items.CLASS_LIST[i].IS_ALL_CLASS = 1;
          }
        } else {
          items.selected = false;
          for (let i = 0; i < items.CLASS_LIST.length; i++) {
            items.CLASS_LIST[i].IS_ALL_CLASS = 0;
          }
        }
      } else {
        item.selected = false;
        items.selected = false;
        for (let i = 0; i < items.CLASS_LIST.length; i++) {
          items.CLASS_LIST[i].IS_ALL_CLASS = 0;
        }
      }
      //  this.scopeData.forEach((scopes, index) => {
      //     console.log(scopes)
      //     if (scopes.selected) {
      //         arr.push(scopes);
      //       }
      //     scopes.CLASS_LIST.forEach((scope) => {
      //       if (scope.selected) {
      //         arr.push(scope);
      //       }
      //     });
      //   });

      // for( let i=0; i < arr.length; i++ ){
      //       let li = arr[i].COURSE_ID
      //       if( li !== items.COURSE_ID ){
      //         arr[i].selected = false;
      //       }
      //   }
      choose(this.scopeData, items);
      this.$set(this.scopeData, groupIndex, this.scopeData[groupIndex]);
    },

    /**
     * 全选
     */
    chooseAll(item, index, classId) {
      let arr = [];
      console.log(item);
      if (typeof item.selected === "undefined" || item.selected === false) {
        item.selected = true;
        for (let i = 0; i < item.CLASS_LIST.length; i++) {
          let li = (item.CLASS_LIST[i].selected = true);
          let isAllClass = (item.CLASS_LIST[i].IS_ALL_CLASS = 1);
        }
      } else {
        item.selected = false;
        for (let i = 0; i < item.CLASS_LIST.length; i++) {
          let li = (item.CLASS_LIST[i].selected = false);
          let isAllClass = (item.CLASS_LIST[i].IS_ALL_CLASS = 0);
        }
      }
      // this.scopeData.forEach((scopes, index) => {
      //     console.log(scopes)
      //     if (scopes.selected) {
      //         arr.push(scopes);
      //       }
      //     scopes.CLASS_LIST.forEach((scope) => {
      //       if (scope.selected) {
      //         arr.push(scope);
      //       }
      //     });
      //   });

      // for( let i=0; i < arr.length; i++ ){
      //       let li = arr[i].COURSE_ID
      //       if( li !== item.COURSE_ID ){
      //         arr[i].selected = false;
      //       }
      //   }

      choose(this.scopeData, item);
      this.$set(this.scopeData, index, this.scopeData[index]);
    },

    pltneBtn(position) {
      let choices = [];
      this.scopeData.forEach((scopes, index) => {
        scopes.CLASS_LIST.forEach(scope => {
          if (scope.selected) {
            choices.push(scope);
          }
        });
      });

      if (choices.length > 0) {
        console.log(choices);
        let choicesString = JSON.stringify(choices);
        window.localStorage.setItem("CLAEEINFO", choicesString);
        this.$router.push({ path: "publish" });
      } else {
        this.position = position;
        this.showPositionValue = true;
      }
    }
  }
};
</script>

<style lang="less" scoped>
@import "../../style/minxin.less";
.box {
  padding-bottom: 80 / @baseSize;
}

.title {
  height: 60 / @baseSize;
  background: @green;
  padding-left: 30 / @baseSize;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  font-size: @fontSize30;
  color: @white;
  line-height: 60 / @baseSize;
}

.curriculum-list {
  width: 100%;
}

.curriculum-list h4.titleTop {
  .mixin-padding(30/@baseSize, 30/@baseSize);
  height: 100 / @baseSize;
  line-height: 100 / @baseSize;
  border-bottom: 1px solid @colorDD;
}

.curriculum-list h4.titleTop .titleTopLeft em {
  width: 40 / @baseSize;
  height: 40 / @baseSize;
  display: block;
  float: left;
  text-align: center;
  line-height: 40 / @baseSize;
  background: @green;
  border-radius: 4px;
  color: @white;
  margin-top: 28 / @baseSize;
}

.curriculum-list h4.titleTop .titleTopLeft span {
  margin-left: 20 / @baseSize;
  float: left;
  font-size: @fontSize30;
  color: @color42;
}

.curriculum-name {
  width: 100%;
}

.curriculum-name .liclass {
  .mixin-padding(30/@baseSize, 30/@baseSize);
  height: 100 / @baseSize;
  border-bottom: 1px solid @colorDD;
  display: flex;
  align-items: center;
  align-content: center;
  align-self: center;
}

// .curriculum-name .liclass em {
//   width: 38/@baseSize;
//   height: 38/@baseSize;
//   display: block;
//   float: left;
//   border: 1px solid @green;
//   border-radius: 50%;
//   margin-top: 28/@baseSize;
// }

.curriculum-name .liclass em.icon {
  border: 1px solid @green;
}

.curriculum-name .liclass em.icon i {
  width: 19 / @baseSize;
  height: 20 / @baseSize;
  margin-top: 9 / @baseSize;
  margin-left: auto;
  margin-right: auto;
  background: url("../../assets/checkmarks.png") no-repeat;
  background-size: 100% 100%;
  display: block;
}

.liclass em {
  width: 38 / @baseSize;
  height: 38 / @baseSize;
  display: block;
  border: 1px solid @colorDD;
  border-radius: 5px;
}

.curriculum-name .liclass span {
  margin-left: 20 / @baseSize;
  font-size: @fontSize30;
  color: @color42;
}

.pltne-btn {
  width: 100%;
  height: 80 / @baseSize;
  line-height: 80 / @baseSize;
  font-size: @fontSize30;
  color: @white;
  background: @green;
  margin-top: 80 / @baseSize;
  text-align: center;
  position: fixed;
  bottom: 0;
}

.demo1-item {
  border: 1px solid @colorDD;
  width: 38 / @baseSize;
  height: 38 / @baseSize;
  display: flex;
  align-items: center;
}
.demo1-item-selected {
  border: 1px solid green;
}
.demo1-item-selected em {
  width: 20 / @baseSize;
  height: 20 / @baseSize;
  margin-left: auto;
  margin-right: auto;
  background: url("../../assets/checkmarks.png") no-repeat;
  background-size: 100% 100%;
  align-self: center;
  display: block;
}
.curriculum-name .liclass .vux-checker-box {
  width: 38 / @baseSize;
  height: 38 / @baseSize;
}

.titleTop {
  display: flex;
  justify-content: space-between;
  align-content: center;
}

.chooesAll {
  display: flex;
  justify-content: center;
  align-items: center;
}
.chooesAll em {
  width: 38 / @baseSize;
  height: 38 / @baseSize;
  display: block;
  border: 1px solid @colorDD;
  border-radius: 5px;
}

.chooesAll span {
  margin-left: 5px;
}

.chooesAll em.icon {
  border: 1px solid @green;
  border-radius: 5px;
}

.chooesAll em.icon i {
  width: 19 / @baseSize;
  height: 20 / @baseSize;
  margin-top: 9 / @baseSize;
  margin-left: auto;
  margin-right: auto;
  background: url("../../assets/checkmarks.png") no-repeat;
  background-size: 100% 100%;
  display: block;
}
</style>
