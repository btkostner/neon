<template>
  <div>
    <h1>Dashboard</h1>

    <h2>Stocks</h2>

    <nuxt-link to="/stocks/lyft">
      LYFT
    </nuxt-link>
    <nuxt-link to="/stocks/amrc">
      AMRC
    </nuxt-link>
  </div>
</template>

<script>
export default {
  auth: 'user'
}
</script>
