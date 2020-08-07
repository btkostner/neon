<template>
  <div>
    <header>
      Stocks
      <template v-if="symbol">
        {{ symbol }}
      </template>

      <template v-if="market">
        ({{ market }})
      </template>
    </header>

    <div class="content">
      <nuxt-child />
    </div>
  </div>
</template>

<style scoped>

</style>

<script>
export default {
  auth: 'user',

  computed: {
    market () {
      if (this.$route.params.market) {
        return this.$route.params.market.toUpperCase()
      } else {
        return null
      }
    },

    symbol () {
      if (this.$route.params.symbol) {
        return this.$route.params.symbol.toUpperCase()
      } else {
        return null
      }
    }
  }
}
</script>
