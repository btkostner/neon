const colors = require('tailwindcss/colors')
const plugin = require('tailwindcss/plugin')

module.exports = {
  mode: 'jit',

  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: colors.coolGray,
      red: colors.rose,
      green: colors.emerald,
      blue: colors.cyan
    }
  },

  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/line-clamp'),

    plugin(function({ addVariant, e }) {
      addVariant('phx-connected', ({ modifySelectors, separator }) => {
        modifySelectors(({ className }) => {
          return `.phx-connected .${e(`phx-connected${separator}${className}`)}`
        })
      })

      addVariant('phx-disconnected', ({ modifySelectors, separator }) => {
        modifySelectors(({ className }) => {
          return `.phx-disconnected .${e(`phx-disconnected${separator}${className}`)}`
        })
      })

      addVariant('phx-error', ({ modifySelectors, separator }) => {
        modifySelectors(({ className }) => {
          return `.phx-error .${e(`phx-error${separator}${className}`)}`
        })
      })

      addVariant('phx-click-loading', ({ modifySelectors, separator }) => {
        modifySelectors(({ className }) => {
          return `.phx-click-loading .${e(`phx-click-loading${separator}${className}`)}`
        })
      })
    })
  ],

  purge: [
    'lib/neon_web/**/*.ex',
    'lib/neon_web/**/*.html.eex',
    'lib/neon_web/**/*.html.leex'
  ]
}
