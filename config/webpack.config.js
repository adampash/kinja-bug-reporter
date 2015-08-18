var ExtractTextPlugin = require('extract-text-webpack-plugin');
var path = require('path');
var root = path.join(__dirname, '..');
var context = path.join(root, 'src');
var clientDir = path.join(context, 'client');

var modules = ['ui', 'mixins'];
var moduleDirectories = modules.map(function(mod) {
  return path.join(clientDir, mod);
});

module.exports = {
  entry: {
    background: path.join(context, 'background.coffee'),
    reporter: path.join(context, 'reporter.cjsx'),
    // reportstyle: path.join(context, 'styles/report.scss')
  },

  context: context,

  output: {
    path: path.join(root, 'build'),
    filename: '[name].js'
  },

  module: {
    loaders: [{
      test: /\.cjsx?$|\.coffee$/,
      loaders: ['react-hot', 'coffee', 'cjsx'],
      exclude: [path.join(root, 'node_modules'), path.join(context, 'node_modules')]
    },
    {
      test: /\.jpe?g$|\.gif$|\.png$|\.svg$|\.woff$|\.ttf$/,
      loader: 'file'
    },
    {
      test: /\.css$/,
      loader: ExtractTextPlugin.extract('style-loader', 'css-loader')
    },
    {
      test: /\.scss$/,
      loader: "style!css?sourceMap!autoprefixer-loader!ruby-sass"
    },
    ]
  },

  plugins: [
    new ExtractTextPlugin('../css/[name]-bundle.css')
  ],

  resolve: {
    extensions: ['', '.js', '.jsx', '.cjsx', '.coffee'],
    moduleDirectories: moduleDirectories,
    root: moduleDirectories

  },

  resolveLoader: {
    moduleDirectories: [
      moduleDirectories
    ]
  }
};
