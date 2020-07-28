<template>
  <div class="page">
    <h1>{{ symbol }}</h1>

    <div class="graph">
      <button
        :disabled="zoom === 'day'"
        @click="zoom = 'day'"
      >
        1 Day
      </button>

      <button
        :disabled="zoom === 'week'"
        @click="zoom = 'week'"
      >
        1 Week
      </button>

      <button
        :disabled="zoom === 'month'"
        @click="zoom = 'month'"
      >
        1 Month
      </button>

      <button
        :disabled="zoom === 'year'"
        @click="zoom = 'year'"
      >
        1 Year
      </button>

      <aggregate-graph
        :aggregates="aggregates"
      />
    </div>
  </div>
</template>

<style scoped>
  .page {
    padding: 1rem;
  }

  h1 {
    margin: 0;
  }

  .graph {
    max-height: 80vh;
    max-width: 100%;
    padding: 2rem 0;
  }
</style>

<script>
import gql from 'graphql-tag'

export default {
  auth: 'user',

  apollo: {
    aggregates: {
      query: gql`query($symbol: String!, $width: String!, $limit: Int!){
        aggregates(symbol: $symbol, width: $width, limit: $limit) {
          openPrice
          highPrice
          lowPrice
          closePrice
          insertedAt
        }
      }`,
      variables () {
        return {
          symbol: this.symbol,
          width: this.width,
          limit: this.limit
        }
      },
      subscribeToMore: {
        document: gql`subscription($symbol: String!, $width: String!){
          aggregate(symbol: $symbol, width: $width) {
            openPrice
            highPrice
            lowPrice
            closePrice
            insertedAt
          }
        }`,
        variables () {
          return {
            symbol: this.symbol,
            width: this.width
          }
        },
        updateQuery: (aggregates, { subscriptionData: { aggregate } }) => {
          // TODO: We could probably make this faster once we perfect sort order
          // TODO: We probably want to ensure this array doesn't get too long
          return aggregates
            .filter(a => (a.insertedAt !== aggregate.insertedAt))
            .push(aggregate)
        }
      }
    }
  },

  data: () => ({
    aggregates: [],

    zoom: 'day'
  }),

  computed: {
    limit () {
      switch (this.zoom) {
        case 'day':
          return 96

        case 'week':
          return 672

        case 'month':
          return 2920

        case 'year':
          return 35040

        default:
          return 666
      }
    },

    symbol () {
      return this.$route.params.symbol.toUpperCase()
    },

    width () {
      switch (this.zoom) {
        case 'day':
          return '5 minutes'

        default:
          return '15 minutes'
      }
    }
  }
}
</script>
