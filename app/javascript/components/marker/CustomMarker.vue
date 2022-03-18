<template>
  <span :class="'map__marker-' + size">
    <span>{{ content }}</span>
  </span>
</template>

<script>
  export default {
    name: "CustomMarker",

    props: {
      content: {
        type: [String, Number],
        default: 0
      },
      size: {
        type: Number, 
        default: 1
      }
    },
  }
</script>