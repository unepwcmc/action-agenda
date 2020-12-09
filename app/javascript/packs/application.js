// import 'babel-polyfill'
// import { findPolyfill } from './utilities/polyfill-find'
// import 'url-search-params-polyfill'
// findPolyfill()

// dependencies
import Vue from 'vue/dist/vue.esm'
// import VueAnalytics from 'vue-analytics'
// import Vue2TouchEvents from 'vue2-touch-events'
// import VueLazyload from 'vue-lazyload'

// store
import store from '../store/store.js'

// components
import FilteredTable from '../components/table/FilteredTable'

export const eventHub = new Vue()

document.addEventListener('DOMContentLoaded', () => {
  if(document.getElementById('v-app')) {
    
    if(process.env.NODE_ENV == 'development' || process.env.NODE_ENV == 'staging') {
      // Vue.use(VueAnalytics, { id: 'UA-12920389-5' }) // staging
    } else if(process.env.NODE_ENV == 'production') {
      // Vue.use(VueAnalytics, { id: 'UA-12920389-2' }) // production
    }

    Vue.prototype.$eventHub = new Vue()

    // Vue.use(Vue2TouchEvents)

    // Vue.use(VueLazyload)

    const app = new Vue({
      el: '#v-app',
      store,
      components: {
	      FilteredTable,
      }
    })
  }
})