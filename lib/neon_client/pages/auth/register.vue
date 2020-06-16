<template>
  <form @submit.prevent="register">
    <h1>Neon Registration</h1>

    <template v-if="error">
      <p>{{ error }}</p>
    </template>

    <input
      v-model="name"
      type="text"
      placeholder="Blake"
      required
    >

    <input
      v-model="email"
      type="email"
      placeholder="blake@example.com"
      required
    >

    <input
      v-model="password"
      type="password"
      placeholder="password"
      min="6"
      required
    >

    <input
      type="submit"
      value="Register"
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
    error: null,

    name: '',
    email: '',
    password: ''
  }),

  methods: {
    async register () {
      const { password } = this
      this.password = ''

      try {
        const res = await this.$apollo.mutate({
          mutation: gql`mutation ($name: String!, $email: String!, $password: String!) {
            register(name: $name, email: $email, password: $password) {
              token
              expiredAt
            }
          }`,
          variables: {
            name: this.name,
            email: this.email,
            password
          }
        })

        const { expiredAt, token } = res.data.register

        await this.$apolloHelpers.login(token, new Date(expiredAt))
        this.$router.push('/')
      } catch (err) {
        this.error = err.graphQLErrors.map((e) => e.message).join(' & ')
      }
    }
  }
}
</script>
