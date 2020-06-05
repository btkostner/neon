<template>
  <div>
    <h1>Neon Login</h1>

    <input
      type="text"
      placeholder="blake"
    >

    <input
      type="password"
      placeholder="password"
    >

    <input
      type="submit"
      value="Log In"
    >
  </div>
</template>

<style scoped>
  div {
    padding: 1rem;
  }
</style>

<script>
export default {
  layout: 'dialog'
}
</script>
