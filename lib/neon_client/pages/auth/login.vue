<template>
  <basic-form
    :submit-function="login"
    header-text="Neon Login"
    submit-text="Login"
  >
    <form-input
      id="email"
      v-model="email"
      label="Email Address"
      placeholder="blake@example.com"
      type="email"
      validation="required|email"
    />

    <form-input
      id="password"
      v-model="password"
      label="Password"
      placeholder="correct horse battery staple"
      type="password"
      validation="required|min:8"
    />
  </basic-form>
</template>

<script>
export default {
  layout: 'dialog',
  auth: 'guest',

  data: () => ({
    email: '',
    password: ''
  }),

  methods: {
    async login () {
      await this.$store.dispatch('auth/login', {
        email: this.email,
        password: this.password
      })

      this.$router.push('/dashboard')
    }
  }
}
</script>
