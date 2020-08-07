<template>
  <div />
</template>

<script>
export default {
  layout: 'dialog',
  auth: 'user',

  mounted () {
    this.$store.commit('auth/logout')
    this.$router.push('/')
  }
}
</script>
