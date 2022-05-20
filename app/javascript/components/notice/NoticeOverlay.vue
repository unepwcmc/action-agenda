<template>
  <div class="flash-notice__container" :class="{ closed: closed }">
    <div class="flash-notice__card">
      <h2 v-text="heading" />
      <p v-text="notice" />
      <p>
        <a
          :href="resendPath"
          :title="heading"
          v-text="resendText"
        />
      </p>
      <button
        class="flash-notice__close-button"
        v-text="closeText"
        @click="close"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: "NoticeOverlay",

  props: {
    closeText: {
      type: String,
      required: true
    },

    heading: {
      type: String,
      required: true
    },

    notice: {
      type: String,
      required: true
    },

    resendPath: {
      type: String,
      required: true
    },

    resendText: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      closed: false,
    };
  },

  methods: {
    close () {
      this.closed = !this.closed;
    },
  },
}
</script>