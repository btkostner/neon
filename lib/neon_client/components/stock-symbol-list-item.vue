<template>
  <nuxt-link
    :class="['box', style]"
    :to="href"
  >
    <h1 v-if="$apollo.queries.symbol.loading">
      Loading...
    </h1>
    <h1 v-else>
      {{ symbol.name }}
    </h1>

    <h2 v-if="!$apollo.queries.symbol.loading">
      {{ symbol.symbol }} on {{ symbol.market.abbreviation }}
    </h2>

    <h3 v-if="!$apollo.queries.symbol.loading">
      {{ animation.price | currency }}

      <font-awesome-icon :icon="faAngleUp" />
    </h3>

    <h4 v-if="!$apollo.queries.symbol.loading">
      {{ animation.percentage | percentage }}
    </h4>

    <div class="left-hide" />
    <svg ref="chart" />
  </nuxt-link>
</template>

<style scoped>
  .box {
    --accent: var(--first-fg-color);

    align-content: flex-start;
    align-items: flex-start;
    background-color: var(--black-800);
    border-radius: 3px;
    border: 1px solid var(--black-900);
    display: grid;
    grid-gap: 1ch;
    grid-template-columns: auto 1fr auto;
    grid-template-rows: auto auto 1fr;
    grid-template-areas:
      "title . price"
      "info . diff"
      ". . .";
    margin: 1rem 0;
    padding: 1rem;
    position: relative;
  }

  .box.up {
    --accent: var(--lime-300);
  }

  .box.down {
    --accent: var(--strawberry-300);
  }

  h1,
  h2,
  h3,
  h4 {
    margin: 0;
    padding: 0;
    position: relative;
    z-index: 2;
  }

  h3,
  h4 {
    text-align: right;
    color: var(--accent);
  }

  h1 {
    grid-area: title;
  }

  h2 {
    grid-area: info;
  }

  h3 {
    grid-area: price;
  }

  h4 {
    grid-area: diff;
  }

  .left-hide {
    background: linear-gradient(to right, var(--black-800) 80%, rgba(11, 11, 11, 0));
    height: 100%;
    left: 0;
    position: absolute;
    top: 0;
    width: 40%;
    z-index: 1;
  }

  svg {
    height: calc(100% - 2rem);
    left: 0;
    position: absolute;
    top: 1rem;
    width: calc(100% - 16ch);
    z-index: 0;
  }
</style>

<script>
import anime from 'animejs'
import * as d3 from 'd3'
import gql from 'graphql-tag'
import { faAngleUp } from '@fortawesome/free-solid-svg-icons'
import { subHours } from 'date-fns'

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
          from: this.startDate(),
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
      query: gql`query($symbol: ID!) {
        symbol: stockSymbol(id: $symbol){
          id
          symbol
          name

          market{
            id
            abbreviation
            name
          }
        }
      }`,
      variables () {
        return {
          symbol: this.symbolId
        }
      }
    }
  },

  filters: {
    ...formatting
  },

  props: {
    symbolId: {
      type: String,
      required: true
    }
  },

  data: () => ({
    faAngleUp,

    aggregates: [],
    symbol: {},

    animation: {
      diffPrice: 0,
      percentage: 0,
      price: 0,
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

    diffPrice () {
      if (this.firstData != null && this.lastData != null) {
        return this.lastData.openPrice - this.firstData.openPrice
      } else {
        return 0
      }
    },

    href () {
      if (this.symbol.market != null) {
        return `/stocks/${this.symbol.market.abbreviation}/${this.symbol.symbol}`
      } else {
        return '#'
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
    }
  },

  watch: {
    aggregateData: {
      deep: true,
      handler () {
        this.drawGraph()
      }
    },

    diffPrice (diffPrice) {
      anime({
        targets: this.animation,
        diffPrice,
        round: 1000,
        easing: 'easeOutExpo',
        duration: 200
      })
    },

    percentage (percentage) {
      anime({
        targets: this.animation,
        percentage,
        round: 1000,
        easing: 'easeOutExpo',
        duration: 200
      })
    },

    price (price) {
      anime({
        targets: this.animation,
        price,
        round: 1000,
        easing: 'easeOutExpo',
        duration: 200
      })
    }
  },

  methods: {
    drawGraph () {
      const { height, width } = this.$refs.chart.getBoundingClientRect()
      const svg = d3.select(this.$refs.chart)

      svg.selectAll('*').remove()

      const x = d3.scaleTime()
        .domain(d3.extent(this.aggregateData, d => d.insertedAt))
        .range([0, width])

      const y = d3.scaleLinear()
        .domain([
          d3.min(this.aggregateData, d => d.openPrice) - 10,
          d3.max(this.aggregateData, d => d.openPrice) + 10
        ])
        .range([height, 0])

      svg.append('path')
        .datum(this.aggregateData)
        .attr('fill', 'none')
        .attr('stroke', 'var(--accent)')
        .attr('stroke-width', 1.5)
        .attr('d', d3.line()
          .x(d => x(d.insertedAt))
          .y(d => y(d.openPrice))
        )
    },

    startDate () {
      return subHours(new Date(), 24)
    }
  }
}

</script>
