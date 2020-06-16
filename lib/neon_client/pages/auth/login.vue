<template>
  <form @submit.prevent="login">
    <h1>Neon Login</h1>

    <input
      v-model="email"
      type="text"
      placeholder="blake"
    >

    <input
      v-model="password"
      type="password"
      placeholder="password"
    >

    <input
      type="submit"
      value="Log In"
    >
  </form>
</template>

<style scoped>
  div {
    padding: 1rem;
  }
</style>

<script>
import gql from 'graphql-tag'

export default {
  layout: 'dialog',

  data: () => ({
    email: '',
    password: ''
  }),

  methods: {
    async login () {
      const res = await this.$apollo.mutate({
        mutation: gql`mutation ($email: String!, $password: String!) {
          login(email: $email, password: $password) {
            email
          }
        }`,
        variables: {
          email: this.email,
          password: this.password
        }
      })

      console.log('res', res)
    }
  }
}
</script>
