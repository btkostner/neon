<script>
import { Line } from 'vue-chartjs'

export default {
  extends: Line,

  props: {
    aggregates: {
      type: Array,
      default: () => []
    }
  },

  computed: {
    chartData () {
      return [...this.aggregates].reverse()
    }
  },

  watch: {
    chartData () {
      this.draw()
    }
  },

  mounted () {
    this.draw()
  },

  methods: {
    draw () {
      this.renderChart({
        labels: this.chartData.map(a => new Date(a.insertedAt)),
        datasets: [{
          label: 'Open Price',
          data: this.chartData.map(a => a.openPrice),
          backgroundColor: ['transparent'],
          borderColor: ['#8cd5ff'],
          borderWidth: 2
        }]
      }, {
        legend: { display: false },
        maintainAspectRatio: false,
        responsive: true,
        scales: {
          xAxes: [{
            display: false
          }]
        }
      })
    }
  }
}
</script>
