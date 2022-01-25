<template>
  <div class="dashboard-content-existing">
    <table class="table-head table-head--dashboard">
      <div class="table-head__row">
        <div class="table-head__cell">
          <span
            class="table-head__title"
            v-text="text.my_commitments.heading"
          />
        </div>
        <div class="table-head__cell">
          <span
            class="table-head__title"
            v-text="text.upload_status.heading"
          />
        </div>
        <div class="table-head__cell">
          <span
            class="table-head__title"
            v-text="''"
          />
        </div>
      </div>
    </table>

    <table class="table-body table-body--dashboard">
      <div
        class="table-body__row"
        v-for="commitment in commitments"
      >
        <p class="table-body__cell">
          <span
            class="table-body__cell-title"
            v-text="commitment.name"
          />
          <span
            class="table-body__cell-description"
          >
           {{ commitment.description | trimmed }}
          </span>
        </p>
        <p
          v-if="live(commitment)"
          class="table-body__cell table-body__cell--live-state"
        >
          <span
            class="table-body__cell-state"
            v-text="text.upload_status.published"
          />
        </p>
        <p
          v-else
          class="table-body__cell table-body__cell--draft-state"
        >
          <span class="table-body__cell-content-wrapper">
            <img
              class="table-body__cell-icon table-body__cell-icon--warning"
              :src="iconPathWarning"
              :alt="text.icon_alts.warning"
            />
            <br>
            <span
              class="table-body__cell-state"
              v-text="text.upload_status.draft"
            />
            <span
              class="table-body__cell-draft-info"
              v-text="text.upload_status.draft_info"
            />
          </span>
        </p>
        <p class="table-body__cell table-body__cell--actions">
          <span
            class="table-body__cell-action table-body__cell-action--destroy"
            @click.prevent="destroy(commitment)"
          >
            <img
              class="table-body__cell-action-icon"
              :src="iconPathDestroy"
              :alt="text.icon_alts.destroy"
            />
          </span>
          <a
            v-if="live(commitment)"
            class="table-body__cell-action"
            :href="showPath(commitment)"
          >
            <img
              class="table-body__cell-action-icon"
              :src="iconPathShow"
              :alt="text.icon_alts.show"
            />
          </a>
          <img
            v-else
            class="table-body__cell-action-icon"
            :src="iconPathShowInactive"
            :alt="text.icon_alts.show_inactive"
          />
          <a
            class="table-body__cell-action"
            :href="editPath(commitment)"
          >
            <img
              class="table-body__cell-action-icon"
              :src="iconPathEdit"
              :alt="text.icon_alts.edit"
            />
          </a>
        </p>
      </div>
    </table>
  </div>
</template>

<script>
export default {
  name: "DashboardContentExisting",

  props: {
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
  },

  filters: {
    trimmed (text) {
      return typeof text == "string" ? text.substring(0,150) + "..." : "";
    }
  },

  methods: {
    destroy (commitment) {
      // to be updated to axios call once controller action is implemented
      // on successful deletion, should remove the row (or just refresh the page?)
      console.log(`destroy ${commitment.id}; action to be implemented`);
    },

    editPath (commitment) {
      return `/commitments/${commitment.id}/edit`;
    },

    live (commitment) {
      return commitment.state === "live";
    },

    showPath (commitment) {
      return `/commitments/${commitment.id}`;
    }
  }
}
</script>