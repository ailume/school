/**
 * Created by lume on 2017/10/12.
 */
import * as types from './mutation-types'

const mutations = {
  //
  [types.SET_USERS](state,payload){
    state.users = payload;
  },

  [types.SET_NAMEDATA](state,payload){
    state.nameData = payload;
  },

  // 类型
  [types.SET_TYPE](state,choolesType){
    state.choolesType = choolesType;
  },

  // 空间
  [types.SET_SPACE](state,spaceData){
    state.spaceStore = spaceData;
  },

  // 选修课
  [types.SET_SOPTIONAL](state,optionalData){
    state.optionalStore = optionalData;
  },

  // 课程通知
  [types.SET_CURRICULUM](state,curriculumData){
    state.curriculumStore = curriculumData;
  },


  //  班级
  [types.SET_DRADE](state,gradeData){
    state.gradeStore = gradeData;
  },

  //  班级
  [types.SET_NOTICE](state,schoolData){
    state.schoolStore = schoolData;
  },

  //  编辑
  [types.SET_MESSAGE](state,messageData){
    state.messageStore = messageData;
  },

  //  编辑
  [types.SET_EVALUATE](state,evaluate){
    state.evaluateInfo = evaluate;
  },





}

export default mutations
