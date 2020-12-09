<template>
  <div class="relative">
    <filters :filters="filters"></filters>

    <table class="table table--head">
      <table-head :filters="filters"></table-head>
    </table>

    <table class="table table--body">
      <tbody>
        <row v-for="item in items"
          :key="item._uid"
          :item="item">
        </row>
      </tbody>
    </table>

    <p class="table__note">*All currency values in Euros</p>

    <!-- <pagination :items-per-page="config.itemsPerPage"></pagination> -->
  </div>
</template>

<script>
  import Filters from '../filters/Filters.vue'
  import SelectedFilter from '../filters/SelectedFilter.vue'
  import TableHead from './TableHead.vue'
  import Row from './Row.vue'
  import Pagination from '../pagination/Pagination.vue'

  export default {
    name: 'filtered-table',

    components: { SelectedFilter, Filters, TableHead, Row, Pagination },

    props: {
      filters: { type: Array },
      rows: { type: Array }
    },

    data () {
      return {
        config: {
          itemsPerPage: 10
        },
        items: [],
        itemsOnCurrentPage: [],
        sortDirection: 1
      }
    },

    created () {
      this.createSelectedFilterOptions()
      this.items = this.rows
      this.$store.dispatch('table/updateTotalItems', this.items.length)
    },

    mounted () {
      // refilter the items when the filters are changed
      this.$eventHub.$on('filtersChanged', this.filterItems)

      // repaginate the items when the previous/next buttons are clicked
      this.$eventHub.$on('pageChanged', this.paginateItems)

      // sort the active items when a sort button is clicked
      this.$eventHub.$on('sort', this.sortActiveItems)

      // only display the items that match the page number
      this.filterItems()
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
      filterItems () {
        this.$store.dispatch('table/clearActiveOptions')

        // an item must match one option from each filter (if any have been selected)
        this.items.forEach(item => {
          let filterMatch = true

          this.$store.state.selectedFilterOptions.forEach(filter => {
            
            // if there are some selected options check to see if one matches
            if (filter.options.length !== 0) {
              let optionMatch = false

              // if the filter is of type multiple you need to loop through an array
              // otherwise you are matching to a string
              if(filter.type === 'multiple') {
                const arrayOfValues = item[filter.name]

                arrayOfValues.forEach(value => {
                  filter.options.forEach(option => {
                    if (value == option) optionMatch = true
                  })
                })
              } else {
                filter.options.forEach(option => {
                  if (item[filter.name] == option) optionMatch = true
                })
              }

              // once filterMatch is set to false it will always be false and the item
              // will not be shown because it did match an option in one of the filters
              filterMatch = filterMatch && optionMatch
            }
          })

          // only push the item id into the active items array if there are no fails
          if (filterMatch) {
            this.$store.dispatch('table/updateActiveItems', item.id)
          }
        })

        this.paginateItems()
        this.$store.dispatch('table/updateCurrentPage', 1)
        this.$store.dispatch('table/updateTotalItems', this.$store.state.activeItems.length)
        this.$eventHub.$emit('activeItemsChanged');
      },

      // only display the items that match the page number
      paginateItems () {
        const pageStart = (this.$store.state.currentPage - 1) * this.config.itemsPerPage
        const pageEnd =  pageStart + this.config.itemsPerPage;

        this.itemsOnCurrentPage = this.$store.state.activeItems.slice(pageStart, pageEnd)

        // loop through all articles and update the active state
        this.items.forEach(item => {

          const isActive = this.itemsOnCurrentPage.indexOf(item.id) >= 0

          this.$set(item, 'isActive', isActive)
        })
      },

      createSelectedFilterOptions () {
        let array = []

        // create an empty array for each filter
        this.filters.forEach(filter => {
          if (filter.name !== undefined && filter.options.length > 0) {
            let obj = {}

            obj.name = filter.name
            obj.options = []
            obj.type = filter.type

            array.push(obj)
          }
        })

        this.$store.dispatch('table/setFilterOptions', array)
      },

      sortActiveItems (filter) {
        // sort the items using the main array the contains all data
        this.items.sort(this.compare(filter))

        // trigger filtering function so that the active items array is updated with
        // the new order and the results are paginated correctly
        this.filterItems()
      },

      compare (filter) {
        // use a negative to alternate the direction of the order
        this.sortDirection = this.sortDirection * -1

        // order the items using the correct property
        return (a, b) => {
          let result = (a[filter] < b[filter]) ? -1 : (a[filter] > b[filter]) ? 1 : 0;
          
          return result * this.sortDirection;
        }
      }
    }
  }
</script>
