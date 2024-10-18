'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const path = require('path');
const fs = require('fs');

module.exports = async function (defaults) {
  const { readPackageUpSync } = await import('read-package-up');

  let app = new EmberApp(defaults, {
    trees: {
      app: (() => {
        let sideWatch = require('@embroider/broccoli-side-watch');

        let paths = ['ember-primitives', '@nullvoxpopuli/primitives'].map((libraryName) => {
          let entry = require.resolve(libraryName);
          let { packageJson, path: packageJsonPath } = readPackageUpSync({ cwd: entry });
          let packagePath = path.dirname(packageJsonPath);

          console.debug(
            `Side-watching ${libraryName} from ${packagePath}, which started in ${entry}`
          );

          let toWatch = packageJson.files
            .map((f) => path.join(packagePath, f))
            .filter((p) => {
              if (!fs.existsSync(p)) return false;
              if (!fs.lstatSync(p).isDirectory()) return false;

              return true;
            });

          return toWatch;
        });

        return sideWatch('app', { watching: paths.flat() });
      })(),
    },
    'ember-cli-babel': {
      enableTypeScriptTransform: true,
    },
  });

  const { Webpack } = require('@embroider/webpack');

  return require('@embroider/compat').compatBuild(app, Webpack, {
    extraPublicTrees: [],
    staticAddonTrees: true,
    staticAddonTestSupportTrees: true,
    staticHelpers: true,
    staticModifiers: true,
    staticComponents: true,
    staticEmberSource: true,
    packagerOptions: {
      webpackConfig: {
        // Slow, but very nice
        devtool: 'source-map',
      },
    },
  });
};
