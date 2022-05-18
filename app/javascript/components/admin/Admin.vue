<template>
  <div>
    <admin-tabs v-bind="{ changeTab, currentTab }" />
    <admin-table v-bind="{ commitments, currentTab, reviewCommitment }" />
  </div>
</template>

<script>
import axios from 'axios';
import { setAxiosHeaders } from '../../helpers/axios-helpers';
import AdminTable from './Table';
import AdminTabs from './Tabs';

export default {
  name: 'Admin',

  components: {
    AdminTable,
    AdminTabs
  },


  created () {
    setAxiosHeaders(axios);
    this.fetchCommitments();
  },

  data () {
    return {
      commitments: [],
      currentTab: 'Unassigned'
    };
  },

  computed: {
    filter () {
      switch (this.currentTab) {
        case 'Unassigned':
          return null;
        case 'Approved':
          return true;
        case 'Rejected':
          return false;
      }
    }
  },

  methods: {
    changeTab(tab) {
      this.currentTab = tab;
      this.fetchCommitments();
    },

    fetchCommitments () {
      axios
        .get(
          'imported_commitments.json',
          { params: { cfn_approved: this.filter } }
        )
        .then((response) => {
          this.commitments = response.data;
        })
    },

    reviewCommitment (value, commitmentId) {
      axios
        .put(
          `imported_commitments/${commitmentId}.json`,
          { commitment: { cfn_approved: value } }
        )
        .then((response) => {
          this.fetchCommitments();
        })
        .catch((error) => {
          console.log(error);
        });
    }
  }
}
</script>
