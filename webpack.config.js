const path = require('path');

module.exports = {
    mode: 'development', // Set to 'production' for production builds
    entry: './src/index.js', // The entry point of your application
    output: {
        filename: 'bundle.js', // The name of the output file
        path: path.resolve(__dirname, 'dist'), // The output directory
    },
    module: {
        rules: [
            {
                test: /\.js$/, // Apply this rule to .js files
                exclude: /node_modules/, // Exclude node_modules directory
                use: {
                    loader: 'babel-loader', // Use Babel for transpiling
                    options: {
                        presets: ['@babel/preset-env'], // Use the preset for ES6+
                    },
                },
            },
        ],
    },
};
