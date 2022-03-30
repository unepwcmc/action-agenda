<template>
  <div class="filters">
    <data-filter v-for="(filter, index)  in filters"
      :key="`${filter.name}-${index}`"
      :name="filter.name"
      :title="filter.title" 
      :options="filter.options"
      :type="filter.type"
      :presetFilterOptions="presetOptionsForFilterType(filter.name)">
    </data-filter>
  </div>
</template>

<script>
  import DataFilter from './DataFilter.vue'

  export default {
    name: "filters",

    components: { DataFilter },

    props: {
      filters: {
        required: true,
        type: Array
      },
      presetFilters: {
        required: true,
        type: Array,
        default: []
      }
    },

    data () {
      return  {
        children: this.$children
      }
    },

    mounted () {
      this.createSelectedFilterOptions()

      this.$eventHub.$on('clickDropdown', this.updateDropdowns)
    },

    methods: {
      updateDropdowns (name) {
        this.children.forEach(filter => {
          filter.isOpen = filter.name == name
        })
      },

      createSelectedFilterOptions () {
        let array = []

        // create an empty array for each filter
        this.filters.forEach(filter => {

          if (filter.name !== undefined && filter.options.length > 0) {
            const preselected = this.presetOptionsForFilterType(filter.name)

            let obj = {}

            obj.name = filter.name
            obj.options = preselected
            obj.type = filter.type

            array.push(obj)
          }
        })

        this.$store.dispatch('table/setFilterOptions', array)
      },

      presetOptionsForFilterType(filterName) {
        const preselected = this.presetFilters.filter(obj => {
            return obj.name === filterName
          })
        return preselected.length > 0 ? preselected[0]['options'] : []
      }
    }
  }
</script>