<template>
  <tr @click="openModal()" v-show="item.isActive">
    <td>{{ item.id }}</td>
    <td :title="item.title">{{ projectTitle }}</td>
    <td>{{ checkForMultiples('ecosystem') }}</td>
    <td>{{ checkForMultiples('country') }}</td>
    <td>{{ item.total_project_cost }}</td>
    <td>{{ item.primary_funding }}</td>
    <td>{{ checkForMultiples('donors') }}</td>
    <td>{{ checkForMultiples('partners') }}</td>
    <td>{{ item.end_date }}</td>
  </tr>
</template>

<script>
  import { eventHub } from '../../home.js'

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
      openModal () {
        this.$store.commit('updateModalContent', this.item)

        eventHub.$emit('openModal')
      },

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
