<template>
  <div class="table table--dashboard">
    <table class="table-head table-head--dashboard">
      <div 
        id="sticky"
        class="table-head__sticky"
        :class="{ 'table-head__sticky--stuck' : isSticky }"
      >
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
      </div>
    </table>

    <table class="table-body table-body--dashboard">
      <div
        class="table-body__row"
        v-for="commitment in commitments"
        :key="commitment.id"
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
            target="_blank"
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
            @click="goToEditPath(commitment)"
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
import axios from "axios";
import { setAxiosHeaders } from "../../helpers/axios-helpers";

export default {
  name: "DashboardContentExistingTable",

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

  data() {
    return {
      stickyTrigger: 0,
      isSticky: false
    }
  },

  mounted () {
    setAxiosHeaders(axios);
    this.setStickyTrigger()
    this.scrollHandler()
  },

  filters: {
    trimmed (description) {
      return typeof description === "string" ? description.substring(0,150) + "..." : "";
    }
  },

  methods: {
    destroy (commitment) {
      axios(`/commitments/${commitment.id}.json`, { method: 'delete' })
        .then((response) => {
          window.location.reload();
        })
        .catch((error) => {
          console.log("FAILED!", error.data);
        })
    },

    goToEditPath (commitment) {
      window.location.replace(`/commitments/${commitment.id}/edit`);
    },

    live (commitment) {
      return commitment.state === "live";
    },

    scrollHandler () {
      setInterval( () => {
        let scrollY = window.pageYOffset

        this.isSticky = scrollY > this.stickyTrigger ? true : false
      }, 100)
    },

    setStickyTrigger () {
      const stickyElement = document.getElementById('sticky')
      const stickyElementHeight = stickyElement.clientHeight
      const stickyYOffset = stickyElement.getBoundingClientRect().top + window.pageYOffset

      this.stickyTrigger = stickyElementHeight + stickyYOffset
    },

    showPath (commitment) {
      return `/commitments/${commitment.id}`;
    }
  }}
</script>