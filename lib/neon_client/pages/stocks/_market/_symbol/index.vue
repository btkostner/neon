<template>
  <div :class="['page', style]">
    <header>
      <h1>{{ symbol.symbol }}</h1>

      <template v-if="diffPrice">
        {{ diffPrice }}
      </template>
    </header>

    <div class="graph">
      <svg ref="chart" />
    </div>

    <div>
      <form-input
        id="days"
        label="days"
        v-model.number="days"
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

  h1 {
    margin: 0;
  }

  .graph {
    background-color: var(--accent);
    height: 60vh;
    margin: 1rem 0;
    width: 100%;
  }
</style>

<script>
import d3 from 'd3'
import gql from 'graphql-tag'
import { startOfDay, startOfWeek, startOfMonth, startOfYear } from 'date-fns'

export default {
  apollo: {
    aggregates: {
      query: gql`query($symbol: ID!, $width: String!, $from: DateTime!) {
        aggregates: stockAggregates(symbolId: $symbol, width: $width, from: $from){
          openPrice
          highPrice
          lowPrice
          closePrice
          volume
          insertedAt
        }
      }`,
      variables () {
        return {
          symbol: this.symbol.id,
          from: this.fromDate,
          width: this.width
        }
      },
      skip () {
        return (this.symbol.id == null)
      },
      subscribeToMore: {
        document: gql`subscription ($symbol: ID!, $width: String!) {
          aggregate: stockAggregates(symbolId: $symbol, width: $width){
            openPrice
            highPrice
            lowPrice
            closePrice
            volume
            insertedAt
          }
        }`,
        variables () {
          return {
            symbol: this.symbol.id,
            width: this.width
          }
        },
        updateQuery: ({ aggregates }, { subscriptionData: { data: { aggregate }}}) => {
          const newAggregates = aggregates
            .filter((a) => (a.insertedAt !== aggregate.insertedAt))
            .push(aggregate)

          return { aggregates: newAggregates }
        },
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

  data: () => ({
    aggregates: [],
    symbol: {
      id: null
    },

    timeframe: 'day',

    days: 30
  }),

  computed: {
    aggregateData () {
      return this.aggregates
        .sort((a, b) => (a.insertedAt - b.insertedAt))
    },

    diffPrice () {
      if (this.firstData != null && this.lastData != null) {
        return this.firstData.openPrice - this.lastData.openPrice
      } else {
        return null
      }
    },

    firstData () {
      return this.aggregateData[0]
    },

    fromDate () {
      switch (this.timeframe) {
        case 'week':
          return startOfWeek(new Date())

        case 'month':
          return startOfMonth(new Date())

        case 'year':
          return startOfYear(new Date())

        default:
          return startOfDay(new Date())
      }
    },

    lastData () {
      return this.aggregateData[this.aggregateData.length - 1]
    },

    style () {
      if (this.diffPrice != null) {
        return (this.diffPrice > 0) ? 'up' : 'down'
      } else {
        return null
      }
    },

    width () {
      switch (this.timeframe) {
        case 'week':
          return '1 hour'

        case 'month':
          return '12 hours'

        case 'year':
          return '5 day'

        default:
          return '5 minutes'
      }
    }
  },

  methods: {
    async backfill () {
      await this.$apollo.mutate({
        mutation: gql`mutation($symbol: String!, $days: Integer!) {
          backfill: stockBackfill(symbolId: $symbol, days: $days) {
            openPrice
            highPrice
            lowPrice
            closePrice
            volume
            insertedAt
          }
        }`,
        variables: {
          symbol: this.symbol.id,
          days: this.days
        }
      })
    }
  }
}
</script>
