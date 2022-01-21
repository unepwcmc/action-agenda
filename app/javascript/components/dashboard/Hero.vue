<template>
  <div class="dashboard-hero">
    <span v-if="hasCommitments">Dashboard hero: existing</span>
    <span v-else>Dashboard hero: new</span>
  </div>
</template>

<script>
export default {
  name: "DashboardHero",

  props: {
    buttonText: {
      type: String,
      required: true
    },

    hasCommitments: {
      type: Boolean,
      required: true
    },

    headingText: {
      type: String,
      required: true
    }
  }
}
</script>