// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import VueResource from 'vue-resource'
import FastClick from 'fastclick'
import App from './App.vue'
import router from "./router/index"
import axios from 'axios';
import store from './store/index'
Vue.use(VueResource)
Vue.prototype.$axios=axios;

FastClick.attach(document.body)
Vue.config.productionTip = false

Vue.http.options.emulateJSON = true;
Vue.http.options.headers = {
  'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
};

/* eslint-disable no-new */
new Vue({
  el:'#app',
  router,
  store,
  template:'<App/>',
  components:{
    App
  }
})
