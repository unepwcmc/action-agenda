<template>
  <ul class="progress">
    <li class="progress__active">{{ title.active }}</li>
    <!-- the span has a pseudoelement attached for styling -->
    <li class="progress__dormant"><span></span>{{ title.dormant }}</li>
  </ul>
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

