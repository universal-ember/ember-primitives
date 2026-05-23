import PageTitleService from 'ember-page-title/services/page-title';
import Application from 'ember-strict-application-resolver';

import Router from './router.ts';

export default class SsrApp extends Application {
  modules = {
    ...import.meta.glob('./router.ts', { eager: true }),
    ...import.meta.glob('./templates/**/*.{gjs,gts,md}', { eager: true }),
    ...import.meta.glob('./routes/**/*.{gjs,gts,js,ts,md}', { eager: true }),
    './router': Router,
    './services/page-title': PageTitleService,
  };
}

/**
 * Exported so vite-ember-ssr's worker can await it with a timeout per
 * render (`settledTimeout`, default 10s). Demos with `ReactiveImage`
 * register `waitForPromise` waiters that never resolve under Node
 * (happy-dom doesn't fire `<img>` onload), so an unbounded `settled()`
 * inside `app.visit` would hang the whole render forever.
 */
export { settled } from '@ember/test-helpers';

export function createSsrApp() {
  return SsrApp.create({ autoboot: false });
}
