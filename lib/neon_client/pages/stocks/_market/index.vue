<template>
  <div class="page">
    <div class="stocks">
      <nuxt-link
        v-for="symbol in symbols"
        :key="symbol.id"
        :to="`/stocks/${symbol.market.abbreviation}/${symbol.symbol}`"
      >
        {{ symbol.symbol }} ({{ symbol.market.abbreviation }})
      </nuxt-link>
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

  .stocks {
    display: block;
    margin: 2rem 0;
  }

  .stocks a {
    display: block;
  }
</style>

<script>
import gql from 'graphql-tag'

export default {
  apollo: {
    symbols: {
      query: gql`query($market: String!) {
        symbols: stockSymbols(marketAbbreviation: $market){
          id
          symbol
          market{
            id
            abbreviation
          }
        }
      }`,
      variables () {
        return {
          market: this.market
        }
      }
    }
  },

  validate ({ params }) {
    return /[A-Z]{3,}/.test(params.market)
  },

  data: () => ({
    symbols: {}
  }),

  computed: {
    market () {
      return this.$route.params.market.toUpperCase()
    }
  }
}
</script>
