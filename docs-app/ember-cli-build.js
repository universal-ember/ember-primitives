'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const sortBy = require('lodash.sortby');

module.exports = async function (defaults) {
  const app = new EmberApp(defaults, {
    // Add options here
    'ember-cli-babel': {
      enableTypeScriptTransform: true,
    },
  });

  // Use `app.import` to add additional libraries to the generated
  // output files.
  //
  // If you need to use different assets in different
  // environments, specify an object as the first parameter. That
  // object's keys should be the environment name and the values
  // should be the asset to use in that environment.
  //
  // If the library that you are including contains AMD or ES6
  // modules that you would like to import into your application
  // please specify an object with the list of modules as keys
  // along with the exports of each module as its value.

  const { createManifest, copyFile } = await import('kolay/build');

  const { Webpack } = require('@embroider/webpack');

  let optimizeForProduction = process.env.CI ? 'production' : 'development';

  class _Webpack extends Webpack {
    variants = [{ name: 'deployed-dev-build', runtime: 'browser', optimizeForProduction }];
  }

  return require('@embroider/compat').compatBuild(app, _Webpack, {
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
        devtool: process.env.CI ? 'source-map' : 'eval',
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
          createManifest.webpack({ src: 'public/docs', dest: 'docs' }),
          copyFile.webpack({
            src: '../docs-api/docs.json',
            dest: 'api-docs.json',
          }),
        ],
      },
    },
  });
};
