const path = require('path');
const apiMocker = require('connect-api-mocker');

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
    before: function(app) {
      app.use(apiMocker('/api', 'mocks/api'))
    },
    contentBase: path.join(__dirname, "src"),
    historyApiFallback: true
  }
};
