<template>
  <div class="table__row">
    <p class="table__cell">
      <span class="table__cell-title">{{ item.title }}</span>
      <span>{{ item.description | trimmed }}</span>
    </p>
    <p class="table__cell">{{ item.committed }}</p>
    <p class="table__cell">{{ item.duration_years || item.duration }}</p>
    <p class="table__cell">{{ item.stage }}</p>
    <p class="table__cell">
      <a 
        :href="item.url" 
        :title="item.title"
        class="table__button"
      >View</a>
    </p>
    <!-- <p class="table__cell">{{ checkForMultiples('country') }}</p> -->
  </div>
</template>

<script>
  export default {
    name: "row",
    props: {
      item: {
        required: true,
        type: Object,
      }
    },

    computed: {
      projectTitle () {
        return this.trim(this.item.title)
      }
    },

    filters: {
      trimmed (text) {
        return typeof text == 'string' ? text.substring(0,160) + '...' : ''
      }
    },

    methods: {
      checkForMultiples (field) {
        // set output to the first item in the array
        // if the array has more than 1 value then set output to 'multiple'
        let output = this.item[field][0]

        if(this.item[field].length > 1) {
          output = 'Multiple'
        } else {
          output = this.trim(output)
        }

        return output
      },

      trim (phrase) {
        const length = phrase.length
        let output

        if (length <= 30) {
          output = phrase
        } else {
          output = phrase.substring(0,27) + '...'
        }

        return output
      }
    }
  }
</script>
