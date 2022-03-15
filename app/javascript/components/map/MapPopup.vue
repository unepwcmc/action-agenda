<template>
  <div>
    {{ content }}
    <BarChart :chartData="data" :options="options" />
  </div>
</template>

<script>
import axios from "axios";
import BarChart from "../chart/BarChart";
import { setAxiosHeaders } from "../../helpers/axios-helpers";

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
      colours: [
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
      ],
      data: {
        labels: [],
        datasets: [
          {
            label: "My First Dataset",
            data: [],
            backgroundColor: [
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
            ],
          },
        ],
      },
      options: {
        scales: {
          yAxes: [
            {
              ticks: {
                min: 0,
                max: 10,
                stepSize: 2,
              },
            },
          ],
        },
      },
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
      axios
        .get(url)
        .then((response) => {
          this.chartData = response.data.managers;
          console.log(response.data);
        })
        .then(() => this.populateChartData());
    },

    populateChartData() {
      //reset the data array so it doesn't add to it on each click
      this.data.labels = [];
      this.data.datasets[0].data = [];
      this.chartData.forEach((item) => {
        this.data.labels.push(item.name),
          this.data.datasets[0].data.push(item.count),
          console.log(item.count);
      });
      console.log(this.data);
    },
  },
};
</script>