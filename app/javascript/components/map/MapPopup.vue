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
    <button @click="onClick" class="map__button">view commitments</button>
  </div>
</template>

<script>
import axios from "axios";
import BarChart from "../chart/BarChart";
import { setAxiosHeaders } from "../../helpers/axios-helpers";
import Turbolinks from "turbolinks";
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
      text: '',
      colors: [
        "#97001F",
        "#6054BA",
        "#00483A",
        "#E7C802",
        "#4bc0c0",
        "#43B2ED",
        "#6380ff",
        "#ff6384",
        "#ffa040",
        "#003e78",
      ],
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
          this.text = response.data.text;
        })
        .then(() => this.populateChartData());
    },

    onClick() {
      Turbolinks.visit(this.url);
    },

    populateChartData() {
      //reset the data array so it doesn't push to it on each click
      this.randomKey += 1;
      this.data.datasets = [];

      this.chartData.forEach((item, key) => {
        this.data.datasets.push({
          data: [item.count],
          label: item.name,
          backgroundColor: this.colors[key],
        })
      });
    },
  },
};
</script>