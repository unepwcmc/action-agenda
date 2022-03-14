<template>
  <!-- <div id="map" class="map"> -->
  <MglMap
    container="map-test"
    :center.sync="center"
    :accessToken="accessToken"
    :mapStyle="mapStyle"
  >
    <!-- <MglMarker
      :coordinates.sync="markerCoordinates"
      color='green'
    /> -->
    <!-- <MglGeojsonLayer
      type="fill"
      :sourceId="sourceId"
      :layerId="layerId"
      :source="geojson"
      @click="handleClick"
    /> -->
  </MglMap>
  <!-- </div> -->
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
        "pk.eyJ1IjoidW5lcHdjbWMiLCJhIjoiRXg1RERWRSJ9.taTsSWwtAfFX_HMVGo2Cug",
      mapStyle: "mapbox://styles/mapbox/streets-v11",
      center: [-74.5, 40], // starting position [lng, lat]
      zoom: 9, // starting zoom
    };
  },

  created() {
    // We need to set mapbox-gl library here in order to use it in template
    this.mapbox = Mapbox;
  }
};
</script>