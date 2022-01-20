<template>
  <div
    v-if="showModal"
    class="modal"
  >
    <div class="modal__inner">
      <div class="modal__body">
        <div class="modal__content">
          <p class="modal__question">
            <b v-text="modalText.question" />
          </p>
          <div
            class="modal__question-body"
            v-html="modalQuestionBody"
          />
          <button
            class="modal__button modal__button--continue"
            v-text="modalText.continue"
            @click="closeModal"
          />
          <button
            class="modal__button modal__button--exit"
            v-text="modalText.exit"
            @click="exit"
          />
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
  name: 'FormModal',

  model: {
    event: 'change',
    prop: 'showModal'
  },

  props: {
    exit: {
      type: Function,
      required: true
    },

    modalQuestionBody: {
      type: String,
      required: true
    },

    modalText: {
      type: Object,
      required: true
    },

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