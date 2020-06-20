<template>
  <basic-form
    :submit-function="register"
    header-text="Neon Registration"
    submit-text="Register"
  >
    <form-input
      id="name"
      v-model="name"
      type="text"
      placeholder="Blake"
      label="Full Name"
      validation="required"
    />

    <form-input
      id="email"
      v-model="email"
      type="email"
      label="Email Address"
      placeholder="blake@example.com"
      validation="required|email"
    />

    <form-input
      id="password"
      v-model="password"
      type="password"
      label="Password"
      placeholder="correct horse battery staple"
      validation="required|min:8"
    />
  </basic-form>
</template>

<script>
import gql from 'graphql-tag'

export default {
  layout: 'dialog',

  data: () => ({
    name: '',
    email: '',
    password: ''
  }),

  methods: {
    async register () {
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
          password: this.password
        }
      })

      const { expiredAt, token } = res.data.register

      await this.$apolloHelpers.login(token, new Date(expiredAt))
      this.$router.push('/')
    }
  }
}
</script>
