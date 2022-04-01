<template>
  <li class="filter__option">
    <input type="checkbox" :id="optionId" v-model="isSelected" class="filter__checkbox" :class="{ 'filter__checkbox--active' : isSelected }">
    <label :for="optionId" class="filter__checkbox-label">{{ option }}</label>
  </li>
</template>

<script>
  export default {
    name: 'data-filter-option',

    props: {
      option: {
        type: String,
        required: true
      },
      selected: {
        type: Boolean,
        default: false
      }
    },

    data () {
      return {
        isSelected: this.selected
      }
    },

    computed : {
      optionId () {
        return this.option.toString().replace(' |(|)|_', '-').toLowerCase()
      }
    },
  }
</script>
