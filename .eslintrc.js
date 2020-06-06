module.exports = {
  root: true,

  env: {
    browser: true,
    node: true
  },

  parserOptions: {
    parser: 'babel-eslint'
  },

  extends: [
    '@nuxtjs',
    'plugin:nuxt/recommended'
  ],

  plugins: [
    'graphql'
  ],

  rules: {
    'graphql/template-strings': ['error', {
      env: 'apollo',
      schemaJson: require('./priv/static/schema.json')
    }]
  }
}
