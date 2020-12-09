// import { polyfill } from 'es6-promise'
// polyfill()

import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'

Vue.use(Vuex)

import { storeTable } from './_store-table.js'

export default new Vuex.Store({
  modules: {
    table: storeTable
  }
})