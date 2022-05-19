<template>
  <table class="commitment-approvals__table">
    <thead>
      <tr class="commitment-approvals__table-column-headings">
        <th class="commitment-approvals__table-column-heading">Name</th>
        <th class="commitment-approvals__table-column-heading">Description</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <tr
        v-for="(commitment, commitmentIndex) in commitments"
        :key="commitmentIndex"
        class="commitment-approvals__commitment"
      >
        <td v-text="commitment.name" />
        <td v-text="commitment.description" />
        <admin-review
          v-bind="{
            currentTab,
            commitmentId: commitment.id,
            reviewCommitment
          }"
        />
      </tr>
    </tbody>
  </table>
</template>

<script>
import AdminReview from './Review';

export default {
  name: 'AdminTable',

  components: {
    AdminReview
  },

  props: {
    commitments: {
      type: Array,
      default: () => []
    },

    currentTab: {
      type: String,
      required: true
    },

    reviewCommitment: {
      type: Function,
      required: true
    }
  },
}
</script>