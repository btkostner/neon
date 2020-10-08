<template>
  <div class="page">
    <ol>
      <li
        v-for="symbol in symbols"
        :key="symbol.id"
      >
        <stock-symbol-list-item
          :symbol-id="symbol.id"
        />
      </li>
    </ol>
  </div>
</template>

<style scoped>
  .page {
    padding: 1rem;
  }

  ol {
    list-style: none;
    margin: 0;
    padding: 0;
  }
</style>

<script>
import gql from 'graphql-tag'

export default {
  apollo: {
    symbols: gql`query {
      symbols: stockSymbols(limit:25){
        id
        symbol

        market {
          abbreviation
        }
      }
    }`
  },

  data: () => ({
    symbols: []
  })
}
</script>
