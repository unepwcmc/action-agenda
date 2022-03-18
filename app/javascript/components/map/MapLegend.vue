<template>
  <div v-if="data.length > 0">
    <ul class="map__legend" v-for="item, key in data" :key="key">
      <li class="map__legend-item">
        <div class="map__legend-marker-container">
          <span 
            class="map__legend-marker" 
            :style="{ 'background-color': item.backgroundColor }" 
          />
        </div>
        <span>
          {{ item.label }},
          <strong> {{ item.data[0] }}</strong>
        </span>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'MapLegend',

    props: {
      data: {
        type: Array,
        require: false
      },
    },
    updated() {
      console.log('DATA', this.data)
    }
  }

</script>