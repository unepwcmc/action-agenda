<template>
  <div class="dashboard-content-existing">
    <p
      v-for="commitment in commitments"
      v-text="commitment.name"
    />
  </div>
</template>

<script>
export default {
  name: "DashboardContentExisting",

  props: {
    commitments: {
      type: Array,
      required: true
    }
  }
}
</script>