const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        include: [
          path.resolve(__dirname, 'src')
        ],
        use: [
          {
            loader: 'elm-webpack-loader',
            options: {
              warn: true
            }
          }
        ]
      }
    ]
  },
  resolve: {
    extensions: ['.elm', '.js'],
    modules: [
      path.resolve(__dirname, 'node_modules'),
      path.resolve(__dirname, 'src')
    ]
  },
  devServer: {
    contentBase: path.join(__dirname, "src"),
    historyApiFallback: true
  }
};