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
export default {
  layout: 'dialog',
  auth: 'guest',

  data: () => ({
    name: '',
    email: '',
    password: ''
  }),

  methods: {
    async register () {
      await this.$store.dispatch('auth/register', {
        name: this.name,
        email: this.email,
        password: this.password
      })

      this.$router.push('/')
    }
  }
}
</script>
