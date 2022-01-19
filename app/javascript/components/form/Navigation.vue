<template>
  <div class="form-navigation">
    <button>Back/Save and exit</button>
    <button
      class="form-navigation__modal-button"
      @click.prevent="openModal"
    >
      Save and exit
    </button>
    <button>Next/Save</button>
    <modal
      v-bind="{ showModal }"
      @change="closeModal"
    >
      {{ modalBody }}
    </modal>
  </div>
</template>

<script>
import Modal from './Modal'

export default {
  name: 'form-navigation',

  components: { 
    Modal
  },

  data () {
    return {
      showModal: false
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