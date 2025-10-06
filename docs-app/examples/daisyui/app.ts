import EmberRouter from '@ember/routing/router';

import PageTitleService from 'ember-page-title/services/page-title';
import { properLinks } from 'ember-primitives/proper-links';
import Application from 'ember-strict-application-resolver';

@properLinks
class Router extends EmberRouter {
  location = 'history';
  rootURL = '/examples/daisyui/';
}
Router.map(function () {
  this.route('avatar');
});

class App extends Application {
  modules = {
    './router': Router,
    './services/page-title': PageTitleService,
    ...import.meta.glob('./templates/**/*.gts', { eager: true }),
  };
}

App.create();
