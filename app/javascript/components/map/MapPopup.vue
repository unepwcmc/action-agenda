<template>
  <div class="popup__container">
    <p>
      {{ content.name }},
      <strong>{{ content.commitment_count }}</strong> commitments
    </p>
    <div class="map__chart-container">
      <BarChart :chartData="data" :options="options" :key="randomKey" />
      <MapLegend :data="data.datasets" />
    </div>
    <a :href="url" target="_blank" class="map__button">view commitments</a>
  </div>
</template>

<script>
import axios from "axios";
import BarChart from "../chart/BarChart";
import CHART_COLORS from "../../constants"
import { setAxiosHeaders } from "../../helpers/axios-helpers";
import MapLegend from './MapLegend.vue';

export default {
  name: "MapPopup",

  components: { BarChart, MapLegend },

  props: {
    content: {
      type: Object,
    },
  },

  data() {
    return {
      id: this.content.id,
      chartData: Object,
      url: '',
      data: {
        labels: [''],
        datasets: [],
      },
      options: {
        responsive: false,
        maintainAspectRatio: false,
        scales: {
          yAxes: [
            {
              ticks: {
                min: 0,
                display: false,
              },
              scaleLabel: {
                display: true,
                fontSize: 25,
                labelString: 'Number of Commitments',
              }
            },
          ],
          xAxes: [
            {
              scaleFontSize: 100,
              scaleLabel: {
                display: true,
                fontSize: 25,
                labelString: 'Actor',
              }
            },
          ],
        },
        legend: {
          display: false,
        },
      },
      randomKey: Math.random(),
    };
  },

  created() {
    setAxiosHeaders(axios);
    this.$root.$on(`popup:${this.id}`, this.getChartData);
  },

  methods: {
    getChartData(id) {
      const url = `/country_commitments/${id}.json`;
      // TODO handle error
      axios
        .get(url)
        .then((response) => {
          this.chartData = response.data.managers;
          this.url = response.data.country_commitments_path;
        })
        .then(() => this.populateChartData());
    },

    populateChartData() {
      //reset the data array so it doesn't push to it on each click
      this.randomKey += 1;
      this.data.datasets = [];

      this.chartData.forEach((item, key) => {
        const ids = []
        const backgroundColor = CHART_COLORS[item.id] || "#E3E3E3"

        ids.push(item.id)

        this.data.datasets.push({
          data: [item.count],
          label: item.name,
          backgroundColor
        })
      });
    },
  },
};
</script>