<template>
  <div class="filters">
    <span class="filter__title bold">Filters:</span>

    <data-filter v-for="(filter, index)  in filters"
      :key="`${filter.name}-${index}`"
      :name="filter.name"
      :title="filter.title" 
      :options="filter.options"
      :type="filter.type">
    </data-filter>
  </div>
</template>

<script>
  import DataFilter from './DataFilter.vue'
  // import DownloadCsv from '../forms/DownloadCsv.vue'

  export default {
    name: "filters",

    components: { DataFilter },

    props: {
      filters: {
        required: true,
        type: Array
      }
    },

    data () {
      return  {
        children: this.$children
      }
    },

    mounted () {
      this.$eventHub.$on('clickDropdown', this.updateDropdowns)
    },

    methods: {
      updateDropdowns (name) {
        this.children.forEach(filter => {
          filter.isOpen = filter.name == name
        })
      }
    }
  }
</script>