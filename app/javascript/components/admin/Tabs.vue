<template>
  <div class="commitment-approvals__tabs">
    <div
      v-for="(tab, tabIndex) in tabs"
      :key="tabIndex"
      class="commitment-approvals__tab"
      :class="{'commitment-approvals__tab--active': currentTab === tab}"
      @click="changeTab(tab)"
      v-text="tab"
    />
  </div>
</template>

<script>
export default {
  name: 'AdminTabs',

  data () {
    return {
      tabs: ['Unassigned', 'Approved', 'Rejected']
    }
  },

  props: {
    changeTab: {
      type: Function,
      required: true
    },

    currentTab: {
      type: String,
      required: true
    }
  }
}
</script>