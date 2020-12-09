<template>
  <tr>
    <td>{{ item.id }}</td>
    <td :title="item.title">{{ projectTitle }}</td>
    <!-- <td>{{ checkForMultiples('ecosystem') }}</td>
    <td>{{ checkForMultiples('country') }}</td> -->
    <td>{{ item.total_project_cost }}</td>
    <td>{{ item.primary_funding }}</td>
    <!-- <td>{{ checkForMultiples('donors') }}</td>
    <td>{{ checkForMultiples('partners') }}</td> -->
    <td>{{ item.end_date }}</td>
  </tr>
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
