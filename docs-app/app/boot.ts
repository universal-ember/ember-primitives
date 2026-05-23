import { shouldRehydrate } from 'vite-ember-ssr/client';

import Application from './app.ts';
import environment from './config/environment.ts';

if (shouldRehydrate()) {
  const app = Application.create({ ...environment.APP, autoboot: false });

  void app.visit(window.location.pathname + window.location.search, {
    _renderMode: 'rehydrate',
  });
} else {
  Application.create(environment.APP);
}
