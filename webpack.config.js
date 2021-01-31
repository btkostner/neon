const path = require('path')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const TerserPlugin = require('terser-webpack-plugin')
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')

module.exports = (env, options) => {
  const devMode = options.mode !== 'production'

  return {
    entry: {
      app: ['./lib/neon_client/script/main.js']
    },

    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, './priv/static/script'),
      publicPath: '/script/'
    },

    devtool: devMode ? 'source-map' : undefined,

    module: {
      rules: [{
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      }, {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'postcss-loader'
        ]
      }]
    },

    optimization: {
      minimizer: [
        new TerserPlugin({ parallel: true }),
        new CssMinimizerPlugin()
      ]
    },

    plugins: [
      new MiniCssExtractPlugin({ filename: '../style/app.css' }),
      new CopyWebpackPlugin({
        patterns: [{ from: './lib/neon_client/static/', to: '../' }]
      })
    ]
  }
}
