import Vue from 'vue'
import Router from 'vue-router'
import Home from '../page/home/ Home.vue'
import Type from '../page/home/Type.vue'
import Notice from '../page/home/Notice.vue'
import Grade from '../page/home/Grade.vue'
import Academic from '../page/home/Academic.vue'
import Curriculum from '../page/home/Curriculum.vue'
import Optional from '../page/home/Optional.vue'
import Space from '../page/home/Space.vue'
import Select from '../page/home/Select.vue'
import Posted from '../page/home/Posted.vue'
import Message from '../page/message/Message.vue'
import Evaluate from '../page/evaluate/EvaluateType.vue'
import GradeList from "../page/evaluate/GradeList.vue"
import RemarkInfo from "../page/evaluate/RemarkInfo.vue"
import Storage from "../page/evaluate/Storage.vue"

import JobList from "../page/publish/jobList.vue"
import Announce from "../page/publish/announce.vue"
import Publish from "../page/publish/publish.vue"

import PayrollList from "../page/payroll/PayrollList.vue"
import PayrollDetail from "../page/payroll/PayrollDetail.vue"

import spaceDetail from "../page/space/spaceDetail.vue"

Vue.use(Router)
export default new Router({
 // mode: 'history',
  routes: [
    // 发布通知
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/type',
      name: 'type',
      component: Type
    },
    {
      path: '/notice',
      name: 'notice',
      component: Notice
    },
    {
      path: '/grade',
      name: 'grade',
      component: Grade
    },
    {
      path: '/academic',
      name: 'academic',
      component: Academic
    },
    {
      path: '/curriculum',
      name: 'curriculum',
      component: Curriculum
    },
    {
      path: '/optional',
      name: 'optional',
      component: Optional
    },
    {
      path: '/space',
      name: 'space',
      component: Space
    },
    {
      path: '/select',
      name: 'select',
      component: Select
    },
    {
      path: '/posted',
      name: 'posted',
      component: Posted
    },


    // 通知列表
    {
      path: '/message',
      name: 'message',
      component: Message
    },


    // 评价
    {
      path: '/evaluate',
      name: 'evaluate',
      component: Evaluate
    },

    {
      path: '/gradeList',
      name: 'gradeList',
      component: GradeList
    },

    {
      path: '/remarkInfo',
      name: 'remarkInfo',
      component: RemarkInfo
    },

    {
      path: '/storage',
      name: 'storage',
      component: Storage
    },


    {
      path: '/jobList',
      name: 'jobList',
      component: JobList
    },

    {
      path: '/announce',
      name: 'announce',
      component: Announce
    },
    {
      path: '/publish',
      name: 'publish',
      component: Publish
    },
    {
      path: '/payrolllist',
      name: 'payrolllist',
      component: PayrollList
    },
    {
      path: '/payrolldetail',
      name: 'payrolldetail',
      component: PayrollDetail
    },


  
    {
      
      path: '/spaceDetail',
      name: 'spaceDetail',
      component: spaceDetail
    }


    

    


  ]
})
