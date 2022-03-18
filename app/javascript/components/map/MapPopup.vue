<template>
  <div class="popup__container">
    <p>
      {{ content.name }},
      <strong>{{ content.commitment_count }}</strong> commitments
    </p>
    <BarChart :chartData="data" :options="options" :key="randomKey" />
    <p>
      {{ this.text }}
    </p>
    <button @click="onClick" class="map__button">view commitments</button>
  </div>
</template>

<script>
import axios from "axios";
import BarChart from "../chart/BarChart";
import { setAxiosHeaders } from "../../helpers/axios-helpers";
import Turbolinks from "turbolinks";

export default {
  name: "MapPopup",

  components: { BarChart },

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
        "rgb(255, 99, 132)",
        "rgb(255, 159, 64)",
        "rgb(255, 205, 86)",
        "rgb(75, 192, 192)",
        "rgb(54, 162, 235)",
        "rgb(153, 102, 255)",
        "rgb(201, 203, 207)",
        "rgb(255, 99, 132)",
        "rgb(255, 159, 64)",
        "rgb(75, 192, 192)",
        "rgb(54, 162, 235)",
        "rgb(255, 99, 132)",
        "rgb(255, 159, 64)",
        "rgb(75, 192, 192)",
        "rgb(54, 162, 235)",
      ],
      data: {
        labels: [this.content.name],
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
            },
          ],
        },
        legend: {
          display: true,
          position: "top",
          align: "start",
          maxWidth: 40,
        },
      },
      randomKey: Math.random(),
    };
  },

  created() {
    //api call based on the content?
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
          console.log(response.data);
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