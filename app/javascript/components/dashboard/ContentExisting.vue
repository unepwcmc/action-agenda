<template>
  <div class="dashboard-content-existing">
    <div class="dashboard-content-existing__add-button-wrapper">
      <a
        :href="addButton.path"
        class="dashboard-content-existing__add-button"
      >
        <span
          class="dashboard-content-existing__add-button-text"
          v-text="addButton.text"
        />
      </a>
    </div>
    <dashboard-content-existing-table
      v-bind="{
        commitments,
        iconPathDestroy,
        iconPathEdit,
        iconPathShow,
        iconPathShowInactive,
        iconPathWarning,
        text
      }"
    />
  </div>
</template>

<script>
import DashboardContentExistingTable from "./ContentExistingTable";

export default {
  name: "DashboardContentExisting",

  components: { 
    DashboardContentExistingTable
  },

  props: {
    addButton: {
      type: Object,
      required: true
    },

    commitments: {
      type: Array,
      required: true
    },

    iconPathDestroy: {
      type: String,
      required: true
    },

    iconPathEdit: {
      type: String,
      required: true
    },

    iconPathShow: {
      type: String,
      required: true
    },

    iconPathShowInactive: {
      type: String,
      required: true
    },

    iconPathWarning: {
      type: String,
      required: true
    },

    text: {
      type: Object,
      required: true
    }
  }
}
</script>