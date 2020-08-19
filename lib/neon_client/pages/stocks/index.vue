<template>
  <div class="page">
    <div class="stocks">
      <div
        v-for="market in markets"
        :key="market.id"
      >
        <h1>{{ market.abbreviation }}</h1>

        <nuxt-link
          v-for="symbol in market.symbols"
          :key="symbol.id"
          :to="`/stocks/${market.abbreviation}/${symbol.symbol}`"
        >
          {{ symbol.symbol }}
        </nuxt-link>
      </div>
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
    markets: gql`query {
      markets: stockMarkets{
        id
        abbreviation

        symbols(limit:50){
          id
          symbol
        }
      }
    }`
  },

  data: () => ({
    markets: []
  })
}
</script>
