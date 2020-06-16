export default {
  mode: 'spa',

  components: true,

  srcDir: 'lib/neon_client',

  build: {
    publicPath: '/app/'
  },

  generate: {
    dir: 'priv/static',
    fallback: '404.html'
  },

  buildModules: [
    '@nuxt/components'
  ],

  modules: [
    '@nuxtjs/pwa'
  ],

  plugins: [
    '~/plugins/apollo'
  ],

  css: [
    '~/assets/styles/variables.css',
    '~/assets/styles/main.css'
  ],

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
    color: 'var(--secondary-bg-color)'
  }
}
