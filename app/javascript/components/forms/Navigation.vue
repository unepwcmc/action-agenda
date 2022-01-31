<template>
  <div class="form-navigation">
    <div
      class="form-navigation__items"
    >
      <div class="form-navigation__items-side">
        <button
          v-if="dataModel === 'Criterium'"
          class="form-navigation__item form-navigation__item--first-page-left"
          v-text="navigationText.exit"
          @click.prevent="openModal"
        />
        <button
          v-else-if="isFirstPage"
          class="form-navigation__item form-navigation__item--first-page-left"
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
          v-if="dataModel === 'Criterium'"
          class="form-navigation__item form-navigation__item--rightmost"
          v-text="navigationText.next"
          @click.prevent="complete"
        />
        <button
          v-if="!firstPage"
          class="form-navigation__item form-navigation__item--save-middle-page"
          v-text="navigationText.exit.right"
          @click.prevent="openModal"
        />
        <button
          v-if="dataModel === 'Commitment' && !isLastPage"
          class="form-navigation__item form-navigation__item--rightmost form-navigation__item--next-commitment"
          v-text="navigationText.next"
          @click.prevent="nextPage"
        />
        <button
          v-if="dataModel === 'Commitment' && isLastPage"
          class="form-navigation__item form-navigation__item--rightmost"
          v-text="navigationText.save"
          @click.prevent="complete"
        />
      </div>
    </div>
    <form-modal
      v-bind="{
        exit,
        modalQuestionBody,
        modalText,
        showModal
      }"
      @change="closeModal"
    />
  </div>
</template>

<script>
import FormModal from "./Modal"

export default {
  name: "FormNavigation",

  components: { 
    FormModal
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

    dataModel: {
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