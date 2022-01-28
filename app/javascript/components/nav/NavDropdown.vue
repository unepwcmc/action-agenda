<template>
  <div class="nav-dropdown">
    <a @click="optionsDropdown">
      <img :src="iconPath" alt="User navigation icon" />
      <span
        class="nav-dropdown__icon text-center"
      />
    </a>
    <ul
      class="nav-dropdown__list"
      v-show="isOpen"
    >
      <li v-html="myAccount" />
      <li v-html="logout" />
    </ul>
  </div>
</template>

<script>
export default {
  name: 'NavDropdown',
  props: {
    iconPath: {
      type: String,
      required: true,
    },
    myAccount: {
      type: String,
      required: true,
    },
    logout: {
      type: String,
      required: true,
    },
  },

  data() {
    return {
      isOpen: false,
      itemsArray: [],
    };
  },

  mounted() {
    this.populateItems();
  },

  methods: {
    optionsDropdown() {
      this.isOpen ? (this.isOpen = false) : (this.isOpen = true);
    },
    populateItems() {
      this.itemsArray.push(this.myAccount, this.logout);
    },
  },
};
</script>
