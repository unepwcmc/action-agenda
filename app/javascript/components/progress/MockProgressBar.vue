<template>
  <div class="container">
    <ul class="progress">
      <li class="progress__active">{{ title.active }}</li>
      <li class="progress__dormant">{{ title.dormant }}</li>
    </ul>
  </div>
</template>

<script>
export default {
  name: "MockProgressBar",
  props: {
    title: {
      type: Object,
      required: true,
    },
  },
};
</script>

