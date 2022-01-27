<template>
  <ul class="dashboard-navigation">
    <li
      v-for="itemKey in Object.keys(navigation)"
      class="dashboard-navigation__item"
    >
      <a
        :href="navigation[itemKey].path"
        class="dashboard-navigation__item-link"
        v-text="navigation[itemKey].text"
      />
    </li>
  </ul>
</template>

<script>
export default {
  name: "DashboardNavigation",

  props: {
    navigation: {
      type: Object,
      required: true
    }
  }
}
</script>