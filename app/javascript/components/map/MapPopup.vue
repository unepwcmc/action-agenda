<template>
  <div>
    {{ content }}
    <BarChart :chartData="data" :options="options" />
  </div>
</template>

<script>
import BarChart from "../chart/BarChart";
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
      data: {
        labels: [65, 59, 80, 81, 56, 55, 40],
        datasets: [
          {
            label: "My First Dataset",
            data: [65, 59, 80, 81, 56, 55, 40],
            backgroundColor: [
              "rgba(255, 99, 132, 0.2)",
              "rgba(255, 159, 64, 0.2)",
              "rgba(255, 205, 86, 0.2)",
              "rgba(75, 192, 192, 0.2)",
              "rgba(54, 162, 235, 0.2)",
              "rgba(153, 102, 255, 0.2)",
              "rgba(201, 203, 207, 0.2)",
            ],
            borderColor: [
              "rgb(255, 99, 132)",
              "rgb(255, 159, 64)",
              "rgb(255, 205, 86)",
              "rgb(75, 192, 192)",
              "rgb(54, 162, 235)",
              "rgb(153, 102, 255)",
              "rgb(201, 203, 207)",
            ],
            borderWidth: 1,
          },
        ],
      },
      options: {
        scales: {
          y: {
            beginAtZero: true,
          },
        },
      },
    };
  },

  computed () {
    //method to get the url for the right country
  },

  created () {
    //api call based on the content?
  },

  methods: {
    getChartData () {
      axios
    }
  }
};
</script>