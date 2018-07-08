/**
 * Created by lume on 2017/9/25.
 */
import Vue from 'vue'
import Vuex from 'vuex'
//import * as actions from './actions'
import * as getters from './getters'
import state from './state'
import mutations from './mutations'
import createLogger from 'vuex/dist/logger'

Vue.use(Vuex)
const debug = process.env.NOOE_ENV != "production"

export default new Vuex.Store({
//  actions,
  getters,
  state,
  mutations,
  strict:debug,
  plugin:debug ? [createLogger()] : []
})

