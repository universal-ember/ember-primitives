import { settled } from '@ember/test-helpers';

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

export function createSsrApp() {
  const app = SsrApp.create({ autoboot: false });

  const originalVisit = app.visit.bind(app);

  Object.assign(app, {
    visit: async (...args: Parameters<typeof originalVisit>) => {
      const instance = await originalVisit(...args);

      await settled();

      return instance;
    },
  });

  return app;
}
