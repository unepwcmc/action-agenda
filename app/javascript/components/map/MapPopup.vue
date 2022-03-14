<template>
  <div>
    {{ content }}
  </div>
</template>

<script>
  export default {
    name: "MapPopup",
    props: {
      content: {
        type: Object
      }
    }
  }
</script>