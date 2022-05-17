<template>
  <div>
    <div 
      :class="{'commitment-approvals__tab--active': currentTab === 'unassigned'}"
      @click="select('unassigned')"
    >
      Unassigned
    </div>
    <div 
      :class="{'commitment-approvals__tab--active': currentTab === 'confirmed'}"
      @click="select('confirmed')"
    >
      Approved
    </div>
    <div 
      :class="{'commitment-approvals__tab--active': currentTab === 'rejected'}"
      @click="select('rejected')"
    >
      Rejected
    </div>

    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Description</th>
          <th></th>
        </tr>
      </thead>
      <tbody v-for="(commitment, commitmentIndex) in commitments" :key="commitmentIndex">
        <tr>
          <td>{{ commitment.name }}</td>
          <td>{{ commitment.description }}</td>
          <td>
            <button 
              v-if="currentTab != 'confirmed'"
              class="commitment-approvals__button--approve"
              @click="confirm(true, commitment.id, commitmentIndex)"
            >
              Approve
            </button>
            <button
              v-if="currentTab != 'rejected'"
              class="commitment-approvals__button--reject"
              @click="confirm(false, commitment.id, commitmentIndex)"
            >
              Reject
            </button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from "axios";
import { setAxiosHeaders } from "../../helpers/axios-helpers";

export default {
  name: "ConfirmCommitments",

  created() {
    setAxiosHeaders(axios);
    this.fetchData();
  },

  data() {
    return {
      currentTab: 'unassigned',
      commitments: []
    };
  },

  methods: {
    select(status) {
      this.currentTab = status;
      this.fetchData();
    },

    fetchData() {
      const filter = this.filterParam();
      axios
        .get('imported_commitments.json', { params: { cfn_approved: filter } })
        .then((response) => {
          this.commitments = response.data;
        })
    },

    confirm(value, id, index) {
      axios
        .put(`imported_commitments/${id}.json`, { commitment: { cfn_approved: value } })
        .then((response) => {
          this.commitments.splice(index, 1);
        })
        .catch(function(error) {
          console.log(error);
        });
    },

    filterParam() {
      switch (this.currentTab) {
        case 'unassigned':
          return null;
        case 'confirmed':
          return true;
        case 'rejected':
          return false;
        default:
          return 'unassigned';
      }
    }
  }
}
</script>
