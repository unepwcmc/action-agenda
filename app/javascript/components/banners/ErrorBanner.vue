<template>
  <div
    class="error animated-banner bg-danger"
  >
    <span class="error__message" v-text="errorText" />
  </div>
</template>

<script>
export default {
  name: "ErrorBanner",
  props: {
    errorText: {
      type: String,
      required: true
    }
  }
}
</script>