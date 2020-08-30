<template>
  <div />
</template>

<script>
export default {
  layout: 'dialog',
  auth: 'user',

  async mounted () {
    await this.$store.dispatch('auth/logout')
    this.$router.push('/')
  }
}
</script>
