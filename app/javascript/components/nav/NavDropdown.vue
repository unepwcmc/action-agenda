<template>
  <span
    class="nav-dropdown"
    @click="toggleDropdown"
  >
    <img
      :src="userIconPath"
      alt="User navigation icon"
      class="nav-dropdown__icon nav-dropdown__icon--user"
    />
    <img
      :src="chevronIconPath"
      alt="Chevron icon"
      class="nav-dropdown__icon nav-dropdown__icon--chevron"
      :class="{ 'nav-dropdown__icon--chevron-open': showDropdown }"
    />
    <ul
      class="nav-dropdown__list"
      v-show="showDropdown"
    >
      <li class="nav-dropdown__list-item">
        <a
          :href="myDashboardPath"
          v-text="myDashboardText"
          class="nav-dropdown__link"
        />
      </li>
      <li class="nav-dropdown__list-item">
        <a
          :href="logOutPath"
          data-method="delete"
          rel="nofollow"
          v-text="logOutText"
          class="nav-dropdown__link"
        />
      </li>
      <li v-if="adminPath" class="nav-dropdown__list-item">
        <a
          :href="adminPath"
          v-text="adminText"
          class="nav-dropdown__link"
        />
      </li>
    </ul>
  </span>
</template>

<script>
export default {
  name: 'NavDropdown',
  props: {
    chevronIconPath: {
      type: String,
      required: true,
    },

    logOutPath: {
      type: String,
      required: true,
    },

    logOutText: {
      type: String,
      required: true,
    },

    myDashboardPath: {
      type: String,
      required: true,
    },

    myDashboardText: {
      type: String,
      required: true,
    },

    userIconPath: {
      type: String,
      required: true,
    },

    adminPath: {
      type: String,
      required: false,
    },

    adminText: {
      type: String,
      required: false,
    },
  },

  data() {
    return {
      showDropdown: false
    };
  },

  methods: {
    toggleDropdown() {
      this.showDropdown = this.showDropdown ? false : true
    }
  }
};
</script>
