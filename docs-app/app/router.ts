// I reject this lint
/* eslint-disable ember/routes-segments-snake-case */
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
  this.route('page', { path: '/:path' }, function () {
    this.route('sub-page', { path: '/:subPath' });
  });
});
