// I reject this lint
/* eslint-disable ember/routes-segments-snake-case */
import EmberRouter from '@ember/routing/router';

import config from 'docs-app/config/environment';
import { properLinks } from 'ember-primitives/proper-links';

@properLinks({
  ignore: [
    // Fallback to Prember
    '/1-get-started/intro',
    '/2-accessibility/intro',
    '/3-components/external-link',
    '/3-components/link',
    '/3-components/modal',
    '/3-components/popover',
    '/3-components/portal-targets',
    '/3-components/portal',
    '/3-components/shadowed',
    '/3-components/switch',
    '/3-components/toggle',
    '/4-helpers/service',
    '/5-utils/color-scheme',
    '/5-utils/iframe',
    '/5-utils/proper-links',
    '/6-forms/1-intro',
    '/6-forms/2-switch',
    '/tests',
  ],
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
