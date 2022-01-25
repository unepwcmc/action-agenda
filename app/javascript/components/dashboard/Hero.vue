<template>
  <div
    class="dashboard-hero"
    :class="modifierClass"
  >
    <div 
      :class="{ "container": !hasCommitments }"
    >
      <h2
        class="dashboard-hero__title"
        v-text="headingText"
      />
      <a
        v-if="!hasCommitments"
        :href="button.path"
        class="dashboard-hero__button"
      >
        <span
          class="dashboard-hero__button-text"
          v-text="button.text"
        />
      </a>
    </div>
  </div>
</template>

<script>
export default {
  name: "DashboardHero",

  props: {
    button: {
      type: Object,
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
  },

  computed: {
    modifierClass () {
      return this.hasCommitments ? "dashboard-hero--existing-commitments" : "dashboard-hero--no-commitments"
    }
  }
}
</script>