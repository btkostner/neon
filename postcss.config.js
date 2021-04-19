const path = require('path')
const purgecss = require('@fullhuman/postcss-purgecss')

module.exports = (options) => {
  const devMode = options.mode !== 'production'

  return {
    plugins: [
      'tailwindcss',
      'autoprefixer',

      ...(devMode ? [] : [purgecss({
        content: [
          path.resolve(__dirname, './lib/neon_web/**/*.ex'),
          path.resolve(__dirname, './lib/neon_web/**/*.html.eex'),
          path.resolve(__dirname, './lib/neon_web/**/*.html.leex')
        ]
      })])
    ]
  }
}
