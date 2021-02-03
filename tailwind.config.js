const colors = require('tailwindcss/colors')
const plugin = require('tailwindcss/plugin')

module.exports = {
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
    'lib/neon_web/**/*.html.eex',
    'lib/neon_web/**/*.html.leex'
  ],

  variants: {
    extend: {
      backgroundColor: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      backgroundOpacity: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      borderColor: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      borderOpacity: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      boxShadow: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      gradientColorStops: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      opacity: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      ringColor: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      ringOffsetColor: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      ringOffsetWidth: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      ringOpacity: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      ringWidth: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      textColor: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading'],
      textDecoration: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading', 'group-hover', 'group-focus', 'focus-within', 'hover', 'focus'],
      textOpacity: ['phx-connected', 'phx-disconnected', 'phx-error', 'phx-click-loading']
    }
  }
}
