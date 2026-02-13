import 'decorator-transforms/globals';
import './styles/app.css';

import PageTitleService from 'ember-page-title/services/page-title';
import { sync } from 'ember-primitives/color-scheme';
import Application from 'ember-strict-application-resolver';

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

export default class App extends Application {
  modules = {
    ...import.meta.glob('./router.ts', { eager: true }),
    ...import.meta.glob('./templates/**/*.{gjs,gts,md}', { eager: true }),
    ...import.meta.glob('./routes/**/*.{gjs,gts,js,ts,md}', { eager: true }),
    './services/page-title': PageTitleService,
  };
}
