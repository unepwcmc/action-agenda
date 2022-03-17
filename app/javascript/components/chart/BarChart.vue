<script>
import { Bar } from "vue-chartjs";

export default {
  name: "BarChart",

  extends: Bar,

  props: {
    chartData: {
      type: Object,
    },
    options: {
      type: Object,
    },
  },
  
  mounted() {
    this.renderChart(this.chartData, this.options);
  },
};
</script>