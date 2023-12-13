'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function (defaults) {
  let app = new EmberApp(defaults, {
    autoImport: {
      watchDependencies: ['ember-primitives'],
    },
    'ember-cli-babel': {
      enableTypeScriptTransform: true,
    },
  });

  const { Webpack } = require('@embroider/webpack');

  const { compatBuild, recommendedOptions } = require('@embroider/compat');

  return compatBuild(app, Webpack, {
    ...recommendedOptions.optimized,
    skipBabel: [{ package: 'qunit' }],
    packagerOptions: {
      webpackConfig: {
        devtool: 'source-map',
      },
    },
  });
};
