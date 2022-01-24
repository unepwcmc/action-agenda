<template>
  <div class="relative">
    <filters 
      class="filters"
      :filters="filters"
      :total-items="totalItems"
    />

    <table class="table-head table-head--basic">
      <table-head :filters="attributes" />
    </table>

    <table class="table-body table-body--basic">
      <row v-for="item in items"
        :key="item._uid"
        :item="item">
      </row>
    </table>
    
    <pagination 
      :current-page="currentPage" 
      :items-per-page="itemsPerPage" 
      :total-items="totalItems" 
      :total-pages="totalPages"
      v-on:updated:page="getNewItems"
    />
  </div>
</template>

<script>
  import axios from 'axios'
  import { setAxiosHeaders } from '../../helpers/axios-helpers'
  import Filters from '../filters/Filters.vue'
  import TableHead from './TableHead.vue'
  import Row from './Row.vue'
  import Pagination from '../pagination/Pagination.vue'

  setAxiosHeaders(axios)

  export default {
    name: 'filtered-table',

    components: { 
      Filters, 
      Pagination,
      Row, 
      TableHead
    },

    props: {
      attributes: { type: Array },
      endpoint: {
        required: true,
        type: String
      },
      filters: { type: Array },
      paginatedRows: { type: Object }
    },

    data () {
      return {
        currentPage: 1,
        itemsPerPage: 10,
        items: [],
        sortDirection: 1,
        totalItems: 0,
        totalPages: 0
      }
    },

    created () {
      this.updateProperties(this.paginatedRows)
      // this.createSelectedFilterOptions()
      // this.items = this.rows
      // this.$store.dispatch('table/updateTotalItems', this.items.length)
    },

    mounted () {
      this.$eventHub.$on('getNewItems', this.getNewItems)
      // refilter the items when the filters are changed
      // this.$eventHub.$on('filtersChanged', this.filterItems)

      // repaginate the items when the previous/next buttons are clicked
      // this.$eventHub.$on('pageChanged', this.paginateItems)

      // sort the active items when a sort button is clicked
      // this.$eventHub.$on('sort', this.sortActiveItems)

      // only display the items that match the page number
      // this.filterItems()
    },

    computed: {
      selectedFilterOptions () {
        // return selected filter options in an appropriate format to loop over
        let options = []

        this.$store.state.selectedFilterOptions.forEach(filter => {
          if (filter.options.length !== 0) {
            filter.options.forEach(selectedOption => {
              let obj = {}

              obj.name = filter.name
              obj.option = selectedOption

              options.push(obj)
            })
          }
        })

        return options
      },

      hasSelected () {
        return this.selectedFilterOptions.length > 0
      },

      totalResults () {
        return this.$store.state.totalItems
      }
    },

    methods: {
      updateProperties (data) {
        this.currentPage = data.current_page
        this.itemsPerPage = data.per_page
        this.totalItems = data.total_entries
        this.totalPages = data.total_pages
        this.items = data.items
      },

      getNewItems () {
        let data = {
          items_per_page: this.itemsPerPage,
          requested_page: this.$store.state.table.requestedPage,
          filters: this.$store.state.table.selectedFilterOptions
        }
        console.log('data', data)
        // console.log(this.$store.state.table)

        axios.post(this.endpoint, data)
        .then(response => {
          console.log('here', response.data)
          this.updateProperties(response.data)
        })
        .catch(function (error) {
          console.log(error)
        })
      }
    }
  }


  //   methods: {
  //     filterItems () {
  //       this.$store.dispatch('table/clearActiveOptions')

  //       // an item must match one option from each filter (if any have been selected)
  //       this.items.forEach(item => {
  //         let filterMatch = true

  //         this.$store.state.table.selectedFilterOptions.forEach(filter => {
            
  //           // if there are some selected options check to see if one matches
  //           if (filter.options.length !== 0) {
  //             let optionMatch = false

  //             // if the filter is of type multiple you need to loop through an array
  //             // otherwise you are matching to a string
  //             if(filter.type === 'multiple') {
  //               const arrayOfValues = item[filter.name]

  //               arrayOfValues.forEach(value => {
  //                 filter.options.forEach(option => {
  //                   if (value == option) optionMatch = true
  //                 })
  //               })
  //             } else {
  //               filter.options.forEach(option => {
  //                 if (item[filter.name] == option) optionMatch = true
  //               })
  //             }

  //             // once filterMatch is set to false it will always be false and the item
  //             // will not be shown because it did match an option in one of the filters
  //             filterMatch = filterMatch && optionMatch
  //           }
  //         })

  //         // only push the item id into the active items array if there are no fails
  //         if (filterMatch) {
  //           this.$store.dispatch('table/updateActiveItems', item.id)
  //         }
  //       })

  //       this.paginateItems()
  //       this.$store.dispatch('table/updateCurrentPage', 1)
  //       this.$store.dispatch('table/updateTotalItems', this.$store.state.activeItems.length)
  //       this.$eventHub.$emit('activeItemsChanged');
  //     },

  //     // only display the items that match the page number
  //     paginateItems () {
  //       const pageStart = (this.$store.state.currentPage - 1) * this.itemsPerPage
  //       const pageEnd =  pageStart + this.itemsPerPage;

  //       this.itemsOnCurrentPage = this.$store.state.activeItems.slice(pageStart, pageEnd)

  //       // loop through all articles and update the active state
  //       this.items.forEach(item => {

  //         const isActive = this.itemsOnCurrentPage.indexOf(item.id) >= 0

  //         this.$set(item, 'isActive', isActive)
  //       })
  //     },

  //     createSelectedFilterOptions () {
  //       let array = []

  //       // create an empty array for each filter
  //       this.filters.forEach(filter => {
  //         if (filter.name !== undefined && filter.options.length > 0) {
  //           let obj = {}

  //           obj.name = filter.name
  //           obj.options = []
  //           obj.type = filter.type

  //           array.push(obj)
  //         }
  //       })

  //       this.$store.dispatch('table/setFilterOptions', array)
  //     },

  //     sortActiveItems (filter) {
  //       // sort the items using the main array the contains all data
  //       this.items.sort(this.compare(filter))

  //       // trigger filtering function so that the active items array is updated with
  //       // the new order and the results are paginated correctly
  //       this.filterItems()
  //     },

  //     compare (filter) {
  //       // use a negative to alternate the direction of the order
  //       this.sortDirection = this.sortDirection * -1

  //       // order the items using the correct property
  //       return (a, b) => {
  //         let result = (a[filter] < b[filter]) ? -1 : (a[filter] > b[filter]) ? 1 : 0;
          
  //         return result * this.sortDirection;
  //       }
  //     }
  //   }
  // }
</script>
