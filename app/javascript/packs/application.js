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
import VueMapbox from "vue-mapbox";
import Mapbox from "mapbox-gl";
// import VueAnalytics from 'vue-analytics'
// import Vue2TouchEvents from 'vue2-touch-events'
// import VueLazyload from 'vue-lazyload'

// store
import store from '../store/store.js'

// components
import DashboardContentExisting from '../components/dashboard/ContentExisting'
import DashboardContentNone from '../components/dashboard/ContentNone'
import DashboardHero from '../components/dashboard/Hero'
import DashboardNavigation from '../components/dashboard/Navigation'
import FilteredTable from '../components/table/FilteredTable'
import SurveyForm from '../components/forms/SurveyForm'
import MockProgressBar from '../components/progress/MockProgressBar'
import NavDropdown from '../components/nav/NavDropdown'
import MapSection from '../components/map/MapSection'
import NoticeOverlay from '../components/notice/NoticeOverlay'

//mapbox
import 'mapbox-gl/dist/mapbox-gl.css';
Mapbox.workerClass = require('worker-loader!mapbox-gl/dist/mapbox-gl-csp-worker').default;

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
    Vue.use(VueMapbox, { mapboxgl: Mapbox }); 
    Vue.prototype.$eventHub = new Vue()
    // Vue.use(Vue2TouchEvents)
    // Vue.use(VueLazyload)

    const app = new Vue({
      el: '#v-app',
      store,
      components: {
        DashboardContentExisting,
        DashboardContentNone,
        DashboardHero,
        DashboardNavigation,
        FilteredTable,
        MockProgressBar,
        MapSection,
        NavDropdown,
        SurveyForm,
        NavDropdown,
        NoticeOverlay
      }
    })
  }
})