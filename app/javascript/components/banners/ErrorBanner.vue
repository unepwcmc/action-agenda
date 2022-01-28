.vue
<template>
  <div>
    <div
      v-show="hasErrors"
      class="error animated-banner bg-danger"
    >
      <span
        v-for="(error, index) in errors"
        :key="index"
        class="error__message"
      >
        {{ index }}:
        <br>
        {{ error[0] }}
      </span>
    </div>
  </div>
</template>

<script>
export default {
  name: "ErrorBanner",
  props: {
    errors: {
      type: Object,
      required: true
    }
  },
  computed: {
    hasErrors() {
      return Object.keys(this.errors).length > 0
    }
  }
}
</script>