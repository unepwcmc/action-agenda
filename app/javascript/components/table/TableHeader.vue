<template>
  <th>
    <span class="table__header">{{ filter.title }}</span>

    <div v-if="hasOptions" class="table__sorting" @click="sort()">
      <span alt="Sort results" class="table__sort table__sort--ascending"></span>
      <span alt="Sort results" class="table__sort table__sort--descending"></span>
    </div>
  </th>
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