<template>
  <div class="container">
    <ul class="progress">
      <li class="progress__active">{{ title.active }}</li>
      <!-- the span has a peudoelement attached for styling -->
      <li class="progress__dormant"><span></span>{{ title.dormant }}</li>
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

