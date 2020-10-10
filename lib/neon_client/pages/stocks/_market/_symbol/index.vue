<template>
  <div :class="['page', style]">
    <header>
      <h1>{{ symbol.symbol }}</h1>

      <span
        ref="price"
        class="price"
      >
        {{ animation.price | currency }}

        <font-awesome-icon :icon="faAngleUp" />

        {{ animation.diffPrice | currency }}
      </span>

      <dl>
        <dt>Change:</dt>
        <dd>{{ animation.percentage | percentage }}</dd>

        <dt>Volume:</dt>
        <dd>{{ animation.volume | round }}</dd>
      </dl>
    </header>

    <div
      class="graph"
      @mousemove="graphMouseMove"
      @mouseleave="graphMouseOut"
    >
      <svg
        ref="chart"
        class="chart"
      />
    </div>

    <div>
      <form-input
        id="days"
        v-model.number="days"
        label="days"
        type="number"
      />

      <form-button @click="backfill">
        Backfill
      </form-button>
    </div>
  </div>
</template>

<style scoped>
  .page {
    --accent: var(--first-bg-color);

    padding: 1rem;
  }

  .page.up {
    --accent: var(--lime-300);
  }

  .page.down {
    --accent: var(--strawberry-300);
  }

  header {
    display: flex;
    flex-wrap: wrap;
    align-items: flex-end;
    align-content: flex-end;
    justify-content: flex-start;
  }

  h1 {
    margin: 0;
  }

  .graph svg {
    height: 100%;
    width: 100%;
  }

  .price {
    color: var(--accent);
    font-size: 1.2rem;
    margin: 0 0 0 calc(4ch * 0.8);
    transition: color 400ms ease;
  }

  .price >>> svg {
    margin: 0 0.5ch;
    transform: rotate(270deg);
    transition: transform 400ms ease;
  }

  .page.up .price >>> svg {
    transform: rotate(0deg);
  }

  .page.down .price >>> svg {
    transform: rotate(180deg);
  }

  dl {
    display: flex;
  }

  dt {
    margin: 0 1ch 0 4ch;
  }

  dd {
    color: var(--accent);
  }

  .tooltip {
    background-color: black;
    border: 1px solid blue;
    padding: 1rem;
    position: absolute;
    top: 0;
    transform: translate(-50%, 0);
  }

  .graph {
    height: 60vh;
    margin: 1rem 0;
    position: relative;
    width: 100%;
  }

  .graph >>> .open-close-line {
    fill: none;
    stroke-dasharray: 6;
    stroke-width: 1px;
    stroke: var(--silver-900);
  }

  .graph >>> .open-close-text {
    font-family: var(--font);
    font-size: 0.8rem;
    font-weight: 200;
    stroke: var(--silver-700);
  }

  .graph >>> .line {
    fill: none;
    stroke-width: 1.5;
    stroke: var(--accent);
  }

  .graph >>> .tooltip-line {
    fill: none;
    stroke-dasharray: 6 12;
    stroke-width: 2px;
    stroke: var(--blueberry-500);
  }

  .graph >>> .tooltip-dot {
    fill: var(--blueberry-300);
  }

  .graph >>> .tooltip-axis {
    font-family: var(--font);
    font-size: 0.8rem;
    font-weight: 200;
    stroke: var(--blueberry-500);
  }
</style>

<script>
import anime from 'animejs'
import * as d3 from 'd3'
import throttle from 'lodash/throttle'
import debounce from 'lodash/debounce'
import gql from 'graphql-tag'
import { faAngleUp } from '@fortawesome/free-solid-svg-icons'
import { set, startOfDay } from 'date-fns'

import * as formatting from '~/filters/formatting'

export default {
  apollo: {
    aggregates: {
      query: gql`query($symbol: ID!, $width: String!, $from: DateTime!) {
        aggregates: stockAggregates(symbolId: $symbol, width: $width, from: $from){
          id
          openPrice
          highPrice
          lowPrice
          closePrice
          volume
          records
          insertedAt
        }
      }`,
      variables () {
        return {
          symbol: this.symbol.id,
          from: startOfDay(new Date()),
          width: '5 minutes'
        }
      },
      skip () {
        return (this.symbol.id == null)
      },
      subscribeToMore: {
        document: gql`subscription ($symbol: ID!, $width: String!) {
          aggregate: stockNewAggregate(symbolId: $symbol, width: $width){
            id
            openPrice
            highPrice
            lowPrice
            closePrice
            volume
            records
            insertedAt
          }
        }`,
        variables () {
          return {
            symbol: this.symbol.id,
            width: '5 minutes'
          }
        },
        updateQuery: ({ aggregates }, { subscriptionData: { data: { aggregate } } }) => {
          const newAggregates = aggregates
            .filter(a => (a.insertedAt !== aggregate.insertedAt))
            .concat([aggregate])

          return { aggregates: newAggregates }
        }
      }
    },

    symbol: {
      query: gql`query($market: String!, $symbol: String!) {
        symbol: stockSymbol(marketAbbreviation: $market, symbol: $symbol) {
          id
          symbol
          market {
            id
            abbreviation
          }
        }
      }`,
      variables () {
        return {
          market: this.$route.params.market.toUpperCase(),
          symbol: this.$route.params.symbol.toUpperCase()
        }
      }
    }
  },

  filters: {
    ...formatting
  },

  data: () => ({
    faAngleUp,

    aggregates: [],
    symbol: {
      id: null
    },

    timeframe: 'day',
    days: 30,

    graph: {
      x: null,
      xMin: null,
      xMax: null,

      y: null,
      yMin: null,
      yMax: null,
      yPad: null,

      openLine: null,
      closeLine: null,
      currentLine: null
    },

    tooltip: {
      minX: null,
      maxX: null,

      showingX: null
    },

    animation: {
      diffPrice: 0,
      percentage: 0,
      price: 0,
      tooltipPrice: 0,
      volume: 0
    }
  }),

  computed: {
    aggregateData () {
      return this.aggregates
        .map(d => ({
          closePrice: Number(d.closePrice),
          highPrice: Number(d.highPrice),
          insertedAt: new Date(d.insertedAt),
          lowPrice: Number(d.lowPrice),
          openPrice: Number(d.openPrice),
          volume: Number(d.volume),
          records: Number(d.records)
        }))
        .sort((a, b) => (a.insertedAt - b.insertedAt))
    },

    dayTime: () => (hours, minutes = 0) => {
      return set(new Date(), { hours, minutes, seconds: 0, milliseconds: 0 })
    },

    diffPrice () {
      if (this.firstData != null && this.lastData != null) {
        return this.lastData.openPrice - this.firstData.openPrice
      } else {
        return 0
      }
    },

    firstData () {
      return this.aggregateData[0]
    },

    lastData () {
      return this.aggregateData[this.aggregateData.length - 1]
    },

    percentage () {
      if (this.firstData != null && this.lastData != null) {
        return (this.lastData.openPrice - this.firstData.openPrice) / this.lastData.openPrice * 100
      } else {
        return 0
      }
    },

    price () {
      if (this.lastData) {
        return this.lastData.openPrice
      } else {
        return 0
      }
    },

    style () {
      if (this.diffPrice != null && this.diffPrice > 0) {
        return 'up'
      } else if (this.diffPrice != null && this.diffPrice < 0) {
        return 'down'
      } else {
        return null
      }
    },

    volume () {
      if (this.lastData != null) {
        return this.lastData.volume
      } else {
        return 0
      }
    }
  },

  watch: {
    aggregateData: {
      deep: true,
      handler () {
        this.drawGraph()
        this.drawGraphLine()
        this.updateGraphTooltip()
      }
    },

    diffPrice (diffPrice) {
      anime({
        targets: this.animation,
        diffPrice,
        round: 1000,
        easing: 'easeOutExpo',
        duration: 1000
      })
    },

    'graph.x' () {
      this.drawGraphMarketLines()
    },

    percentage (percentage) {
      anime({
        targets: this.animation,
        percentage,
        round: 1000,
        easing: 'easeOutExpo',
        duration: 1000
      })
    },

    price (price) {
      anime({
        targets: this.animation,
        price,
        round: 1000,
        easing: 'easeOutExpo',
        duration: 1000
      })
    },

    'tooltip.maxX' () {
      this.drawGraphTooltip()
    },

    'tooltip.showingX' () {
      this.drawGraphTooltip()
    },

    volume (volume) {
      anime({
        targets: this.animation,
        volume,
        round: 1000,
        easing: 'easeOutExpo',
        duration: 400
      })
    }
  },

  methods: {
    async backfill () {
      await this.$apollo.mutate({
        mutation: gql`mutation($symbol: String!, $days: Int!) {
          backfill: stockBackfill(symbolId: $symbol, days: $days) {
            __typename
          }
        }`,
        variables: {
          symbol: this.symbol.id,
          days: this.days
        }
      })
    },

    drawGraph () {
      const { height, width } = this.$refs.chart.getBoundingClientRect()

      this.graph.xMin = this.dayTime(2)
      this.graph.xMax = this.dayTime(22)

      this.graph.x = d3.scaleTime()
        .domain([
          this.graph.xMin,
          this.graph.xMax
        ])
        .range([0, width])

      this.graph.yMin = d3.min(this.aggregateData, d => d.openPrice)
      this.graph.yMax = d3.max(this.aggregateData, d => d.closePrice)
      this.graph.yPad = (this.graph.yMax - this.graph.yMin) * 0.1

      this.graph.y = d3.scaleLinear()
        .domain([
          this.graph.yMin - this.graph.yPad,
          this.graph.yMax + this.graph.yPad
        ])
        .range([height - this.remToPx(4), 0])
    },

    drawGraphLine () {
      const svg = d3.select(this.$refs.chart)

      const line = (!svg.select('#data-line').empty())
        ? svg.select('#data-line')
        : svg.append('path').attr('id', 'data-line').attr('class', 'line')

      line
        .datum(this.aggregateData)
        .attr('d', d3.line()
          .x(d => this.graph.x(d.insertedAt))
          .y(d => this.graph.y(d.openPrice))
        )
    },

    drawGraphMarketLines () {
      const { height } = this.$refs.chart.getBoundingClientRect()
      const svg = d3.select(this.$refs.chart)

      // TODO: Update these values with market open and close
      this.graph.openLine = this.graph.x(this.dayTime(7))
      this.graph.closeLine = this.graph.x(this.dayTime(15))

      svg.select('#open-line').remove()
      svg.append('line')
        .attr('id', 'open-line')
        .attr('x1', this.graph.openLine)
        .attr('y1', 0)
        .attr('x2', this.graph.openLine)
        .attr('y2', height - this.remToPx(3) - 6)
        .attr('class', 'open-close-line')

      svg.select('#open-text').remove()
      svg.append('text')
        .attr('id', 'open-text')
        .attr('x', this.graph.openLine)
        .attr('y', height - this.remToPx(2.8))
        .attr('text-anchor', 'middle')
        .attr('class', 'open-close-text')
        .text('open')

      svg.select('#close-line').remove()
      svg.append('line')
        .attr('id', 'close-line')
        .attr('x1', this.graph.closeLine)
        .attr('y1', 0)
        .attr('x2', this.graph.closeLine)
        .attr('y2', height - this.remToPx(3) - 6)
        .attr('class', 'open-close-line')

      svg.select('#close-text').remove()
      svg.append('text')
        .attr('id', 'close-text')
        .attr('x', this.graph.closeLine)
        .attr('y', height - this.remToPx(2.8))
        .attr('text-anchor', 'middle')
        .attr('class', 'open-close-text')
        .text('close')
    },

    drawGraphTooltip () {
      const { height } = this.$refs.chart.getBoundingClientRect()
      const svg = d3.select(this.$refs.chart)

      const currentX = (this.tooltip.showingX || this.tooltip.maxX)
      const [currentXDate, currentYValue] = this.graphCords(currentX)

      const [xDate, yValue] = (currentYValue != null)
        ? [currentXDate, currentYValue]
        : this.graphCords(this.tooltip.maxX)

      const x = this.graph.x(xDate)

      const line = (!svg.select('.tooltip-line').empty())
        ? svg.select('.tooltip-line')
        : svg.append('line').attr('class', 'tooltip-line')

      line
        .datum(this.aggregateData)
        .attr('x1', x)
        .attr('y1', 6)
        .attr('x2', x)
        .attr('y2', height - this.remToPx() - 12)

      const text = (!svg.select('.tooltip-axis').empty())
        ? svg.select('.tooltip-axis')
        : svg.append('text').attr('class', 'tooltip-axis')

      text
        .attr('x', x)
        .attr('y', height - this.remToPx(0.8))
        .attr('text-anchor', 'middle')
        .text(xDate.toLocaleTimeString())

      const circle = (!svg.select('.tooltip-dot').empty())
        ? svg.select('.tooltip-dot')
        : svg.append('circle').attr('class', 'tooltip-dot')

      circle
        .datum(this.aggregateData)
        .attr('r', 6)
        .attr('class', 'tooltip-dot')
        .attr('cx', x)
        .attr('cy', this.graph.y(yValue))
    },

    graphCords (x) {
      const coeff = 1000 * 60 * 5

      const xDate = this.graph.x.invert(x)
      const roundedDate = new Date(Math.round(xDate.getTime() / coeff) * coeff)
      const roundedTime = roundedDate.getTime()

      const matchingData = this.aggregateData.find(v => (v.insertedAt.getTime() === roundedTime))
      const yValue = (matchingData) ? matchingData.openPrice : null

      return [roundedDate, yValue]
    },

    graphMouseMove: throttle(function (e) {
      if (e.offsetX < this.tooltip.minX) {
        this.tooltip.showingX = this.tooltip.minX
      } else if (e.offsetX > this.tooltip.maxX) {
        this.tooltip.showingX = this.tooltip.maxX
      } else {
        this.tooltip.showingX = e.offsetX
      }
    }, 100),

    graphMouseOut: debounce(function (e) {
      this.tooltip.showingX = null
    }, 1000),

    remToPx (rems = 1) {
      return rems * parseFloat(getComputedStyle(document.documentElement).fontSize)
    },

    updateGraphTooltip () {
      this.tooltip.minX = this.graph.x(d3.min(this.aggregateData, d => d.insertedAt))
      this.tooltip.maxX = this.graph.x(d3.max(this.aggregateData, d => d.insertedAt))
    }
  }
}
</script>
