<script>
import { HorizontalBar } from "vue-chartjs";

export default {
  name: "BarChart",

  extends: HorizontalBar,

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