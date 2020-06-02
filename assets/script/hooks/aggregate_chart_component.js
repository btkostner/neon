import ApexCharts from 'apexcharts'

const AggregateChartComponent = {
  mounted () {
    this.dataEl = this.el.querySelector('.chart-data')
    this.chartEl = this.el.querySelector('.chart-body')

    this.chart = new ApexCharts(this.chartEl, {
      chart: {
        type: 'candlestick',
        fontFamily: 'inherit',
        foreColor: 'inherit',
        sparkline: {
          enabled: false
        },
        toolbar: {
          show: true,
          tools: {
            download: false
          }
        }
      },
      series: [],
      stroke: {
        width: 1
      },
      plotOptions: {
        candlestick: {
          colors: {
            upward: '#00c805',
            downward: '#ff5000'
          },
          wick: {
            useFillColor: true
          }
        }
      },
      tooltip: {
        x: {
          format: 'MM/dd/yyyy HH:mm'
        }
      },
      xaxis: {
        type: 'datetime',
        labels: {
          year: 'yyyy',
          month: 'MMM \'yy',
          day: 'dd MMM',
          hour: 'HH:mm'
        },
        tickAmount: 6
      },
      yaxis: {
        labels: {
          formatter: function (value) {
            return `$${value}`
          }
        },
      }
    })

    this.chart.render()
    this.updated()
  },

  updated () {
    const data = JSON.parse(this.dataEl.dataset.chart)
      .map((d) => ({
        x: new Date(d.t),
        y: [d.o, d.h, d.l, d.c]
      }))

    console.log(data)

    this.chart.updateSeries([{
      name: 'Aggregate',
      data
    }])
  },

  beforeDestroy () {
    this.chart.destroy()
  }
}

export default AggregateChartComponent
