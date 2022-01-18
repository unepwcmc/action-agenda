<template>
  <div
    v-if="showModal"
    class="modal"
  >
    <div class="modal__inner">
      <div
        v-scroll-lock="showModal"
        class="modal__body"
      >
        <div class="modal__content">
          Title from props
          Slot for body or just pass as prop with paragraphing and bold text?
          Continue button with text from props
          Exit button with text and link from props
        </div>
      </div>
    </div>
    <div
      class="modal__overlay"
      @click.self="closeModal"
    />
  </div>
</template>

<script>
const ESCAPE_KEY = 27

export default {
  name: 'modal',

  model: {
    event: 'change',
    prop: 'showModal'
  },

  props: {
    showModal: {
      type: Boolean,
      required: true
    }
  },

  mounted () {
    window.addEventListener('keyup', this.onKeyup)
  },

  beforeDestroy () {
    window.removeEventListener('keyup', this.onKeyup)
  },

  methods: {
    closeModal () {
      this.$emit('change', false)
    },

    onKeyup (e) {
      if (e.keyCode === ESCAPE_KEY) {
        e.preventDefault()
        this.closeModal()
      }
    }
  }
}
</script>