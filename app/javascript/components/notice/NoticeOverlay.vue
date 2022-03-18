<template>
  <div class="flash-notice__container" :class="{ closed: closed }" @click="close">
    <div class="flash-notice__card">
      <a 
        class="flash-notice__close-btn"
      >
        X
      </a>
      <div v-html="notice">
    </div>
  </div>
  </div>
</template>

<script>
export default {
  name: "NoticeOverlay",

  props: {
    notice: {
      type: String,
      default: ""
    }
  },

  data() {
    return {
      closed: false,
    };
  },

  methods: {
    close() {
      this.closed = !this.closed;
    },
  },
};
</script>