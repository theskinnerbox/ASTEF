
var webpack = require('webpack');

module.exports = {
    entry: "./src/app.js",
    output: {
        path: './dist/',
        filename: "bundle.js"
    },
    module: {
        loaders: [
            {
                test: /\.js$/,
                loader: 'babel',
                exclude: /node_modules/
            },
            {
                test: /\.css$/,
                loader: "style!css"
            },
            {
                test: /\.woff2?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: "url?limit=10000&name=dist/[hash].[ext]"
            },
            {
                test: /\.(ttf|eot|svg)(\?[\s\S]+)?$/,
                loader: 'file?name=dist/[hash].[ext]'
            },
            {
                //IMAGE LOADER
                test: /\.(jpe?g|png|gif)$/i,
                loader:'file?name=dist/[hash].[ext]'
            },
            {
                test: /\.vue$/,
                loader: 'vue'
            }
        ]
    },
    plugins: [
        new webpack.optimize.DedupePlugin(),
        new webpack.optimize.UglifyJsPlugin({
            compress: {
                warnings: false
            }
        })
    ]
};
