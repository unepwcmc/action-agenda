<template>
  <div class="dashboard-content-none">
    <div class="dashboard-content-none__inner">
      <img
        :src="iconPath"
        :alt="text.icon_alt"
      />
      <h3
        class="dashboard-content-none__heading"
        v-text="text.heading"
      />
      <p
        class="dashboard-content-none__sub"
        v-text="text.sub"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: "DashboardContentNone",

  props: {
    iconPath: {
      type: String,
      required: true
    },

    text: {
      type: Object,
      required: true
    }
  }
}
</script>