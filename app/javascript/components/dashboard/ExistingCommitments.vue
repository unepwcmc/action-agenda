<template>
  <div class="dashboard-existing-commitments">
    <p
      v-for="commitment in commitments"
      v-text="commitment.name"
    />
  </div>
</template>

<script>
export default {
  name: "DashboardExistingCommitments",

  props: {
    commitments: {
      type: Array,
      required: true
    }
  }
}
</script>