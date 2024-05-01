'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const sideWatch = require('@embroider/broccoli-side-watch');
const path = require('path');

module.exports = async function (defaults) {
  // This package is published incorrectly or their docs are wrong
  // findUp should be a named export.
  const { packageUp } = await import('package-up');

  async function watchLibraries(...libraries) {
    const promises = libraries.map(async (libraryName) => {
      let entry = require.resolve(libraryName);
      let manifestPath = await packageUp({ cwd: entry });
      let packagePath = path.dirname(manifestPath);
      let manifest = require(manifestPath);
      let toWatch = manifest.files.map((f) => path.join(packagePath, f));

      return toWatch;
    });

    const paths = await Promise.all(promises);

    return sideWatch('app', { watching: paths.flat() });
  }

  const app = new EmberApp(defaults, {
    trees: {
      app: await watchLibraries('ember-primitives'),
    },
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
