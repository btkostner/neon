export default {
  mode: 'spa',

  components: true,
  telemetry: false,

  srcDir: 'lib/neon_client',

  generate: {
    dir: 'priv/static',
    fallback: '404.html'
  },

  buildModules: [
    '@nuxt/components'
  ],

  env: {
    MIX_ENV: (process.env.MIX_ENV || 'dev')
  },

  modules: [
    '@nuxtjs/pwa'
  ],

  plugins: [
    '~/plugins/apollo.js',
    '~/plugins/vee-validate.js'
  ],

  css: [
    '~/assets/styles/variables.css',
    '~/assets/styles/main.css',
    '~/assets/styles/typography.css'
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

  build: {
    postcss: {
      plugins: {
        'postcss-color-mod-function': {}
      }
    },

    publicPath: '/app/',

    transpile: [
      'vee-validate/dist/rules'
    ]
  },

  loading: {
    color: 'var(--secondary-bg-color)'
  }
}
