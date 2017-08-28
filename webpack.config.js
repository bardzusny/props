var ExtractTextPlugin = require('extract-text-webpack-plugin');

const path = require('path');

module.exports = {
  entry: {
    main: ['./app/react/index.js']
  },
  output: {
    path: __dirname + '/app/assets/javascripts',
    filename: 'react_bundle.js'
  },
  module: {
    loaders: [
      {
        key: 'jsx',
        test: /\.jsx?$/,
        exclude: /(node_modules)/,
        loaders: ['babel']
      },
      {
        key: 'scss',
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract('css!sass')
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract('style-loader', 'css-loader?modules&importLoaders=1&localIdentName=[name]__[local]___[hash:base64:5]!postcss-loader'),
        include: path.join(__dirname, 'app/react'),
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract('style', 'css'),
        include: path.join(__dirname, 'node_modules'),
      },
    ],
  },

  postcss: [
    require('autoprefixer')
  ],

  resolve: {
    extensions: ['', '.js', '.jsx', '.js.jsx']
  },
  plugins: [
    new ExtractTextPlugin('../stylesheets/react_bundle.css', {
      allChunks: true
    })
  ]
};
