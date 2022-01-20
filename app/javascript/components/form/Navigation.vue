<template>
  <div class="form-navigation">
    <div
      class="form-navigation__items"
      :class="{ itemsModifierClass }"
    >
      <div class="form-navigation__items-side form-navigation__items-side--left">
        <button
          v-if="model === 'Criteria'"
          class="form-navigation__item form-navigation__item--exit"
          v-text="navigationText.exit"
          @click.prevent="openModal"
        />
        <button
          v-else-if="isFirstPage"
          class="form-navigation__item form-navigation__item--save-first-page"
          v-text="navigationText.exit.left"
          @click.prevent="openModal"
        />
        <button
          v-else
          class="form-navigation__item form-navigation__item--back"
          v-text="navigationText.back"
          @click.prevent="prevPage"
        />
      </div>
      <div class="form-navigation__items-side form-navigation__items-side--right">
        <button
          v-if="model === 'Criteria'"
          class="form-navigation__item form-navigation__item--complete"
          v-text="navigationText.next"
          @click.prevent="complete"
        />
        <button
          v-if="isMiddlePage"
          class="form-navigation__item form-navigation__item--save-middle-page"
          v-text="navigationText.exit.right"
          @click.prevent="openModal"
        />
        <button
          v-if="model === 'Commitment' && !isLastPage"
          class="form-navigation__item form-navigation__item--next"
          v-text="navigationText.next"
          @click.prevent="nextPage"
        />
        <button
          v-if="model === 'Commitment' && isLastPage"
          class="form-navigation__item form-navigation__item--save-last-page"
          v-text="navigationText.save"
          @click.prevent="complete"
        />
      </div>
    </div>
    <modal
      v-bind="{
        exit, modalQuestionBody, modalText, showModal
      }"
      @change="closeModal"
    />
  </div>
</template>

<script>
import Modal from './Modal'

export default {
  name: 'navigation',

  components: { 
    Modal
  },

  props: {
    complete: {
      type: Function,
      required: true
    },

    exit: {
      type: Function,
      required: true
    },

    isFirstPage: {
      type: Boolean,
      default: true
    },
 
    isLastPage: {
      type: Boolean,
      default: false
    },

    modalQuestionBody: {
      type: String,
      required: true
    },

    modalText: {
      type: Object,
      required: true
    },

    model: {
      type: String,
      required: true
    },

    navigationText: {
      type: Object,
      required: true
    },

    prevPage: {
      type: Function,
      required: true
    },

    nextPage: {
      type: Function,
      required: true
    }
  },

  data () {
    return {
      showModal: false
    }
  },

  computed: {
    isMiddlePage () {
      return !this.isFirstPage && !this.isLastPage;
    },

    itemsModifierClass () {
      return `form-navigation__items--${this.model}`;
    }
  },

  methods: {
    closeModal () {
      this.showModal = false
    },

    openModal () {
      this.showModal = true
    }
  }
}
</script>