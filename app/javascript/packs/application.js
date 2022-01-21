// import 'babel-polyfill'
// import { findPolyfill } from './utilities/polyfill-find'
// import 'url-search-params-polyfill'
// findPolyfill()

// dependencies
import 'core-js/stable'
import 'regenerator-runtime/runtime'
import Vue from 'vue';
import Turbolinks from 'turbolinks'
import TurbolinksAdapter from 'vue-turbolinks'
// import VueAnalytics from 'vue-analytics'
// import Vue2TouchEvents from 'vue2-touch-events'
// import VueLazyload from 'vue-lazyload'

// store
import store from '../store/store.js'

// components
import DashboardExistingCommitments from '../components/dashboard/ExistingCommitments'
import DashboardHero from '../components/dashboard/Hero'
import DashboardNavigation from '../components/dashboard/Navigation'
import DashboardNoCommitments from '../components/dashboard/NoCommitments'
import FilteredTable from '../components/table/FilteredTable'
import SurveyForm from '../components/forms/SurveyForm'
import MockProgressBar from '../components/progress/MockProgressBar'

Vue.config.productionTip = false
Vue.use(TurbolinksAdapter)

Turbolinks.start();

export const eventHub = new Vue()

document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('v-app')) {
    if (
      process.env.NODE_ENV == 'development' ||
      process.env.NODE_ENV == 'staging'
    ) {
      // Vue.use(VueAnalytics, { id: 'UA-12920389-5' }) // staging
    } else if (process.env.NODE_ENV == 'production') {
      // Vue.use(VueAnalytics, { id: 'UA-12920389-2' }) // production
    }

    Vue.prototype.$eventHub = new Vue()
    // Vue.use(Vue2TouchEvents)
    // Vue.use(VueLazyload)

    const app = new Vue({
      el: '#v-app',
      store,
      components: {
        DashboardExistingCommitments,
        DashboardHero,
        DashboardNavigation,
        DashboardNoCommitments,
        FilteredTable,
        SurveyForm,
        MockProgressBar
      }
    })
  }
})