export default {
  mode: 'spa',

  head: {
    title: 'neon',

    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: 'a stock trading app' }
    ],

    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ]
  },

  loading: {
    color: '#fff'
  },

  buildModules: [
    '@nuxtjs/eslint-module',
    '@nuxtjs/stylelint-module'
  ],

  modules: [
    // '@nuxtjs/apollo',
    // '@nuxtjs/pwa'
  ],

  build: {
    publicPath: '/app/'
  },

  srcDir: 'assets',

  generate: {
    dir: 'priv/static'
  },

  apollo: {
    tokenName: 'neon-token',
    cookieAttributes: {
      expires: 7,
      path: '/',
      secure: false
    },
    clientConfigs: {
      default: {
        httpEndpoint: 'http://localhost:4000',
        browserHttpEndpoint: '/graphql',
        httpLinkOptions: {
          credentials: 'same-origin'
        },
        wsEndpoint: 'ws://localhost:4000',
        persisting: true
      }
    }
  }
}
