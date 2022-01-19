<template>
  <div
    v-if="showModal"
    class="modal"
  >
    <div class="modal__inner">
      <div class="modal__body">
        <div class="modal__content">
          <h3>Title from props</h3>
          <slot />
          <button>Continue button with text from props</button>
          <button>Exit button with text and link from props</button>
        <button
          class="modal__close"
          @click="closeModal"
        >
          Close modal button
        </button>
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