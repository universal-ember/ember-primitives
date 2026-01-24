// I reject this lint

import EmberRouter from '@ember/routing/router';

import config from 'docs-app/config/environment';
import { properLinks } from 'ember-primitives/proper-links';

@properLinks({
  ignore: ['/tests'],
})
export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('animations', function () {
    this.route('layout-toggle');
    this.route('dom-order');
    this.route('enter-exit');
    this.route('expand-cards');
    this.route('page', { path: '/:page' });
  });

  this.route('blocks', function () {
    this.route('page', { path: '/:page' });
  });
});
