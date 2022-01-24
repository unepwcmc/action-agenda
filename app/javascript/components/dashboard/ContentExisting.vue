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
        class="table__row"
        v-for="commitment in commitments"
      >
        <p class="table__cell">
          <span class="table__cell-title">{{ commitment.name }}</span>
          <span>{{ commitment.description | trimmed }}</span>
        </p>
        <p class="table__cell">{{ commitment.state }}</p>
        <p class="table__cell table__cell--actions">
          <span
            class="table__cell-action"
            @click.prevent="destroy(commitment.id)"
          >
            <img
              class="table__cell-action-icon table__cell-action-icon--dashboard"
              :src="iconPathDestroy"
              :alt="text.icon_alts.destroy"
            />
          </span>
          <a
            class="table__cell-action"
            :href="showPath(commitment.id)"
          >
            <img
              class="table__cell-action-icon table__cell-action-icon--dashboard"
              :src="iconPathShow"
              :alt="text.icon_alts.show"
            />
          </a>
          <a
            class="table__cell-action"
            :href="editPath(commitment.id)"
          >
            <img
              class="table__cell-action-icon table__cell-action-icon--dashboard"
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

    text: {
      type: Object,
      required: true
    }
  },

  filters: {
    trimmed (text) {
      return typeof text == 'string' ? text.substring(0,150) + '...' : ''
    }
  },

  methods: {
    destroy (id) {
      console.log(`destroy ${id}; action to be implemented`)
    },

    editPath (id) {
      return `/commitments/${id}/edit`
    },

    showPath (id) {
      return `/commitments/${id}`
    }
  }
}
</script>