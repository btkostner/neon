<template>
  <div>
    <h1>Homepage</h1>
    <nuxt-link to="/dashboard">
      Dashboard
    </nuxt-link>
  </div>
</template>

<style scoped>
  div {
    padding: 1rem;
  }
</style>

<script>
export default {
  layout: 'marketing',
  auth: false
}
</script>
