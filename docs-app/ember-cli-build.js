'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const sortBy = require('lodash.sortby');

module.exports = function (defaults) {
  let environment = EmberApp.env();
  let isProduction = environment === 'production';

  const app = new EmberApp(defaults, {
    // Add options here
    'ember-cli-babel': {
      enableTypeScriptTransform: true,
    },
    prember: {
      enabled: isProduction || process.env.PREMBER === 'true',
      urls: async function () {
        let data = await urlsForPrerender();

        let pages = data.map((markdownUrl) => markdownUrl.replace(/\.md$/, ''));

        console.debug('pre-rendered pages', pages);

        return pages;
      },
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

  const { Webpack } = require('@embroider/webpack');

  let optimizeForProduction = process.env.CI ? 'production' : 'development';

  class _Webpack extends Webpack {
    variants = [{ name: 'deployed-dev-build', runtime: 'browser', optimizeForProduction }];
  }

  const compiledApp = require('@embroider/compat').compatBuild(app, _Webpack, {
    extraPublicTrees: [],
    staticAddonTrees: true,
    staticAddonTestSupportTrees: true,
    staticHelpers: true,
    staticModifiers: true,
    staticComponents: true,
    splitControllers: true,
    splitRouteClasses: true,
    implicitModulesStrategy: 'packageNames',
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

  return require('prember').prerender(app, compiledApp);
};

const { createUnplugin } = require('unplugin');

const copyFile = createUnplugin((options) => {
  let { src, dest } = options ?? {};

  return {
    name: 'copy',
    async buildStart() {
      const path = await import('node:path');
      const fs = await import('fs/promises');

      let source = path.resolve(src);
      let name = source.split('/').reverse()[0];
      let file = await fs.readFile(source);
      let content = await file.toString();

      dest ??= name;

      await this.emitFile({
        type: 'asset',
        fileName: dest,
        source: content,
      });
    },
    watchChange(id) {
      console.debug('watchChange', id);
    },
  };
});

const createManifest = createUnplugin((options) => {
  let { src, dest, name, include, exclude } = options ?? {};

  dest ??= src;
  name ??= 'manifest.json';
  include ??= '**/*';
  exclude ??= [];

  return {
    name: 'create-manifest',
    async buildStart() {
      const path = await import('node:path');

      let reshaped = await buildManifest({
        src,
        include,
        exclude,
      });

      await this.emitFile({
        type: 'asset',
        fileName: path.join(dest, name),
        source: JSON.stringify(reshaped),
      });
    },
    watchChange(id) {
      console.debug('watchChange', id);
    },
  };
});

async function urlsForPrerender() {
  let manifest = await buildManifest({
    src: 'public/docs',
    include: '**/*',
    exclude: [],
  });

  return manifest.list.flat().map((tutorial) => tutorial.path);
}

async function buildManifest(options) {
  const { src, include, exclude } = options;

  const path = await import('node:path');
  const { globbySync } = await import('globby');

  let paths = globbySync(include, {
    cwd: path.join(process.cwd(), src),
    expandDirectories: true,
  });

  paths = paths.filter((path) => !exclude.some((pattern) => path.match(pattern)));

  return reshape(paths);
}

/**
 * @param {string[]} paths
 */
function reshape(paths) {
  let grouped = parse(paths);

  let entries = Object.entries(grouped);
  let first = entries[0];
  let firstTutorial = grouped[first[0]][0];

  let list = entries.map(([, tutorials]) => tutorials);

  return {
    first: firstTutorial,
    list,
    grouped,
  };
}

/**
 * @typedef {object} Manifest
 * @property {string[]} sections
 *
 * @typedef {object} Tutorial
 * @property {string} path
 * @property {string} name
 * @property {string} groupName
 * @property {string} tutorialName
 *
 * I don't know if we want this shape long term?
 * @typedef {{ [group: string ]: Tutorial[] }} Tutorials
 *
 * @param {string[]} paths
 *
 * @returns {Tutorials}
 */
function parse(paths) {
  let result = {};

  for (let path of paths) {
    if (!path.includes('/')) {
      result[path] ||= [];
      continue;
    }

    let [group, name] = path.split('/');

    if (!group) continue;
    if (!name) continue;

    let groupName = group.replaceAll(/[\d-]/g, '');

    result[group] ||= [];
    result[group].push({ path: `/${path}`, name, groupName });
    result[group].sort(betterSort('name'));
  }

  // Objects' keys in JS are sorted as they are created.
  // Since we want to use `betterSort` on the keys, we need a new object.
  let sortedKeys = Object.keys(result).sort(betterSort());

  let actualResult = {};

  for (let sortedKey of sortedKeys) {
    actualResult[sortedKey] = sortBy(result[sortedKey], (x) => x.name);
  }

  return actualResult;
}

/**
 * Tutorials (and groups) are all 123-name
 * This is so that we can sort them manually on the file system.
 * However, it's human understanding that 10 comes after 9 and before 11,
 * instead of the file system default of after 1 and before 2.
 *
 * This sort function fixes the sort to be intuitive.
 * If some file systems correctly sort files starting with numbers,
 * then this is a no-op.
 */
function betterSort(property) {
  return (a, b) => {
    let aFull = property ? a[property] : a;
    let bFull = property ? b[property] : b;

    let [aNumStr, ...aRest] = aFull.split('-');
    let [bNumStr, ...bRest] = bFull.split('-');

    // Throw things starting with x at the end
    if (aNumStr === 'x') return 1;
    if (bNumStr === 'x') return 1;

    let aNum = Number(aNumStr);
    let bNum = Number(bNumStr);

    if (aNum < bNum) return -1;
    if (aNum > bNum) return 1;

    let aName = aRest.join('-');
    let bName = bRest.join('-');

    return aName.localeCompare(bName);
  };
}
