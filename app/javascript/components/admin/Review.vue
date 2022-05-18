<template>
  <td class="commitment-approvals__review">
    <button 
      v-if="currentTab !== 'Approved'"
      class="commitment-approvals__button commitment-approvals__button--approve"
      @click="reviewCommitment(true, commitmentId)"
    >
      Approve
    </button>
    <button
      v-if="currentTab !== 'Rejected'"
      class="commitment-approvals__button commitment-approvals__button--reject"
      @click="reviewCommitment(false, commitmentId)"
    >
      Reject
    </button>
  </td>
</template>

<script>
export default {
  name: 'AdminReview',

  props: {
    commitmentId: {
      type: Number,
      required: true
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
