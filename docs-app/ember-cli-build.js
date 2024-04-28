'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = async function (defaults) {
  const app = new EmberApp(defaults, {
    // Add options here
    'ember-cli-babel': {
      enableTypeScriptTransform: true,
      disableDecoratorTransforms: true,
    },
    babel: {
      plugins: [
        // add the new transform.
        require.resolve('decorator-transforms'),
      ],
    },
  });

  const { kolay } = await import('kolay/webpack');

  const { Webpack } = require('@embroider/webpack');

  let optimizeForProduction = process.env.CI ? 'production' : 'development';

  class _Webpack extends Webpack {
    variants = [{ name: 'deployed-dev-build', runtime: 'browser', optimizeForProduction }];
  }

  return require('@embroider/compat').compatBuild(app, Webpack, {
    extraPublicTrees: [],
    staticAddonTrees: true,
    staticAddonTestSupportTrees: true,
    staticHelpers: true,
    staticModifiers: true,
    staticComponents: true,
    // ember-inspector does not work with this flag
    // staticEmberSource: true,
    packagerOptions: {
      webpackConfig: {
        devtool: 'source-map',
        resolve: {
          alias: {
            path: 'path-browserify',
          },
          fallback: {
            path: require.resolve('path-browserify'),
            assert: require.resolve('assert'),
            fs: false,
          },
        },
        node: {
          global: false,
          __filename: true,
          __dirname: true,
        },
        plugins: [
          kolay({
            src: 'public/docs',
            packages: ['ember-primitives'],
          }),
        ],
        module: {
          rules: [
            {
              test: /\.(woff|woff2|eot|ttf|otf)$/,
              use: ['file-loader'],
            },
            {
              test: /.css$/i,
              use: [
                {
                  loader: 'postcss-loader',
                  options: {
                    postcssOptions: {
                      config: 'config/postcss.config.js',
                    },
                  },
                },
              ],
            },
          ],
        },
      },
    },
  });
};
