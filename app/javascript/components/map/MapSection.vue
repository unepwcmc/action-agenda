<template>
  <div>
    <MapFilter :items="countries" searchKey="name" />
    <MglMap
      class="map"
      container="map-test"
      ref="MglMap"
      :center.sync="center"
      :zoom.sync="zoom"
      :accessToken="accessToken"
      :mapStyle="mapStyle"
    >
      <template v-for="(marker, index) in spatialData">
        <MglMarker
          @click="onPopup(marker.id)"
          :coordinates="[marker.long, marker.lat]"
          :key="index"
          :ref="`marker${marker.id}`"
        >
          <MglPopup closeOnClick>
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
  </div>
</template>

<script>
import CustomMarker from "../marker/CustomMarker";
import MapFilter from "./MapFilter";
import MapPopup from "./MapPopup";
import Mapbox from "mapbox-gl";
import { MglMap, MglMarker, MglPopup } from "vue-mapbox";

export default {
  name: "MapSection",

  components: {
    CustomMarker,
    MapFilter,
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
    countries: {
      type: Array,
    },
  },

  data() {
    return {
      accessToken:
        "pk.eyJ1IjoidW5lcHdjbWMiLCJhIjoiY2wwcXd5bzJ4MmFjMzNicHd2MzI2dTZmbyJ9.1IhTncWca2v8OEwBGImx9Q",
      mapStyle: "mapbox://styles/unepwcmc/cl0qvsu6a00ag14n223a8bwr7",
      bounds: [],
      center: [2, 30],
      zoom: 2,
      showed: false,
      markerValues: [],
      maxValue: 0,
    };
  },

  created() {
    this.mapbox = Mapbox;
    this.setMaxValue();
  },

  mounted() {
    this.$root.$on("selected", this.zoomIn);
  },

  methods: {
    setMaxValue() {
      this.spatialData.forEach((marker) =>
        this.markerValues.push(marker.commitment_count)
      );
      this.maxValue = Math.max(...this.markerValues);
    },

    onPopup(id) {
      this.$root.$emit(`popup:${id}`, id);
    },

    openPopup(id) {
      const marker = this.$refs[`marker${id}`]
      marker[0].togglePopup()
      this.onPopup(id)
    },
    
    zoomIn(selected) {
      // Create a 'LngLatBounds' with both corners at the first coordinate - https://docs.mapbox.com/mapbox-gl-js/example/zoomto-linestring/
      this.bounds = new Mapbox.LngLatBounds(
        selected.coordinates[0],
        selected.coordinates[0]
      )
      // Extend the 'LngLatBounds' to include every coordinate in the bounds result.
      for (const coord of selected.coordinates) {
        this.bounds.extend(coord);
      }

      this.$refs.MglMap.map.fitBounds(this.bounds, {
        padding: 50,
      });
      this.openPopup(selected.id)
    },
  },
};
</script>