import 'decorator-transforms/globals';
import './styles/app.css';

import Application from '@ember/application';
import compatModules from '@embroider/virtual/compat-modules';

import loadInitializers from 'ember-load-initializers';
import { sync } from 'ember-primitives/color-scheme';
import Resolver from 'ember-resolver';

import config from './config/environment';
import { install } from './icons';

sync();
install();

// @babel/traverse (from babel-plugin-ember-template-imports)
// accesses process.....
// maybe one day we can have a browser-only version?
// But they aren't used.... so.. that's fun.
Object.assign(window, {
  process: { env: {} },
  Buffer: {},
});

console.log(compatModules);

export default class App extends Application {
  modulePrefix = config.modulePrefix;
  podModulePrefix = config.podModulePrefix;
  Resolver = Resolver.withModules(compatModules);
}

loadInitializers(App, config.modulePrefix, compatModules);
