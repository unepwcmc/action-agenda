<template>
  <MglMap
    container="map-test"
    :center.sync="center"
    :zoom.sync="zoom"
    :accessToken="accessToken"
    :mapStyle="mapStyle"
  >
  </MglMap>
</template>

<script>
import Mapbox from "mapbox-gl";
import { MglMap } from "vue-mapbox";

export default {
  name: "MapSection",

  components: {
    MglMap
  },

  data() {
    return {
      accessToken:
        "pk.eyJ1IjoidW5lcHdjbWMiLCJhIjoiY2wwcXd5bzJ4MmFjMzNicHd2MzI2dTZmbyJ9.1IhTncWca2v8OEwBGImx9Q",
      mapStyle: "mapbox://styles/unepwcmc/cl0qvsu6a00ag14n223a8bwr7",
      center: [2, 30],
      zoom: 2,
    };
  },

  created() {
    // We need to set mapbox-gl library here in order to use it in template
    this.mapbox = Mapbox;
  }
};
</script>