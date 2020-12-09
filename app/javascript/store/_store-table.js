// import { filter } from "vue/types/umd"

export const storeTable = {
  namespaced: true,

  state: {
    // activeItems: [],
    requestedPage: 1,
    // searchId: '',
    selectedFilterOptions: [], // an array containing an object for each filter that has an array of selected options
    sortDirection: '',
    // sortField: '', 
    totalItemsOnCurrentPage: 0
  },

  actions: {
    clearActiveOptions ({ commit }) {
      commit('clearFilterOptions')
    },
    setFilterOptions ({ commit }, filterOptions) {
      commit('setFilterOptions', filterOptions)
    },
    // updateActiveItems ({ commit }, newOptions) {
    //   commit('updateFilterOptions', newOptions)
    // },
    updateRequestedPage ({ commit }, page) {
      commit('updateRequestedPage', page)
    },
    updateSearch ({ commit }, searchId) {
      commit('updateSearchId', searchId)
      commit('updateSortDirection', '')
      commit('updateSortField', '')
      commit('updateRequestedPage', 1)
    },
    // updateSortParameters ({ commit }, sortParamters) {
    //   commit('updateSortDirection', sortParamters.direction)
    //   commit('updateSortField', sortParamters.field)
    //   commit('updateRequestedPage', 1)
    // },
    updatePage ({ commit }, requestedPage) {
      commit('updateRequestedPage', requestedPage)
    },
    updateTotalItems ({ commit }, total) {
      commit('updateTotalItemsOnCurrentPage', total)
    }
  },

  mutations: {
    clearFilterOptions (state) {
      state.selectedFilterOptions.forEach(filter => {
        filter.options = []
      })
    },
    removeFilterOption (state, removeOption) {
      state.selectedFilterOptions.forEach(filter => {
        if(filter.name == removeOption.name){ 
          filter.options.forEach(option => {
            if(option == removeOption.option){
              const index = filter.options.indexOf(removeOption.option)

              filter.options.splice(index, 1)
            }
          })
        }
      })
    },
    setFilterOptions (state, options) {
      state.selectedFilterOptions = options
    },
    updateFilterOptions (state, newOptions) {
      // find the correct filter to update
      state.selectedFilterOptions.forEach(filter => {
        if(filter.name == newOptions.filter){

          // replace filter options array with newOptions array
          filter.options = newOptions.options
        }
      })
    },
    updateSearchId (state, searchId) {
      state.searchId = searchId
    },
    updateRequestedPage (state, page) {
      state.requestedPage = page
    },
    // updateSortDirection (state, direction) {
    //   state.sortDirection = direction
    // },
    // updateSortField (state, field) {
    //   state.sortField = field
    // },
    updateTotalItemsOnCurrentPage (state, total) {
      state.totalItemsOnCurrentPage = total
    },
  }
}