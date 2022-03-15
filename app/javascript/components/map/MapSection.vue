<template>
  <MglMap
    class="map"
    container="map-test"
    :center.sync="center"
    :zoom.sync="zoom"
    :accessToken="accessToken"
    :mapStyle="mapStyle"
  >
    <template v-for="(marker, index) in spatialData">
      <MglMarker @click="onPopUp(marker.id)" :coordinates="[marker.long, marker.lat]" :key="index">
        <MglPopup >
          <MapPopup :content="marker" />
        </MglPopup>
        <CustomMarker
          slot="marker"
          class="map__marker"
          :size="
            Math.trunc((100 * marker.commitment_count) / maxValue / 20) + 1
          "
          :content="marker.commitment_count"
          :key="index + 0.8"
        />
      </MglMarker>
    </template>
  </MglMap>
</template>

<script>
import CustomMarker from "../marker/CustomMarker";
import MapPopup from "./MapPopup";
import Mapbox from "mapbox-gl";
import { MglMap, MglMarker, MglPopup } from "vue-mapbox";

export default {
  name: "MapSection",

  components: {
    CustomMarker,
    MapPopup,
    MglMap,
    MglMarker,
    MglPopup,
  },

  props: {
    spatialData: {
      type: Array,
      required: true,
    },
  },

  data() {
    return {
      accessToken:
        "pk.eyJ1IjoidW5lcHdjbWMiLCJhIjoiY2wwcXd5bzJ4MmFjMzNicHd2MzI2dTZmbyJ9.1IhTncWca2v8OEwBGImx9Q",
      mapStyle: "mapbox://styles/unepwcmc/cl0qvsu6a00ag14n223a8bwr7",
      center: [2, 30],
      zoom: 2,
      markerValues: [],
      maxValue: 0,
    };
  },

  created() {
    this.mapbox = Mapbox;

    this.setMaxValue();
  },

  methods: {
    setMaxValue() {
      this.spatialData.forEach((marker) =>
        this.markerValues.push(marker.commitment_count)
      );
      this.maxValue = Math.max(...this.markerValues);
    },

    onPopUp(id) {
      this.$root.$emit(`popup:${id}`, id)
    }
  },
};
</script>