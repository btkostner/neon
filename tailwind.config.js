const colors = require('tailwindcss/colors')

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
    require('@tailwindcss/line-clamp')
  ],

  purge: [
    'lib/neon_web/**/*.html.eex',
    'lib/neon_web/**/*.html.leex'
  ],

  varaints: {
    extend: {
      underline: ['group-hover', 'group-focus', 'focus-within', 'hover', 'focus']
    }
  }
}
