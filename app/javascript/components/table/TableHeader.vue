<template>
  <div class="table-head__cell">
    <span class="table-head__title">{{ filter.title }}</span>

    <div 
      v-if="hasOptions" 
      class="table-body__sorting" 
      @click="sort()"
    >
      <span alt="Sort results" class="table-body__sort table-body__sort--ascending"></span>
      <span alt="Sort results" class="table-body__sort table-body__sort--descending"></span>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'table-header',

    props: {
      filter: {
        required: true,
        type: Object
      }
    },

    computed: {  
      // only show the sort buttons if the title has a filter
      hasOptions () {
        return this.filter.options != undefined || this.filter.name != undefined
      }
    },

    methods: {
      sort () {
        this.$eventHub.$emit('sort', this.filter.name)
      }
    }
  }
</script>