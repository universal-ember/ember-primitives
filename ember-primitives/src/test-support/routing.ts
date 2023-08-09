import { assert } from '@ember/debug';
import Router from '@ember/routing/router';

import { properLinks } from '../proper-links';

import type Owner from '@ember/owner';
import type { DSLCallback } from '@ember/routing/lib/dsl';
import type RouterService from '@ember/routing/router-service';

/**
 * Allows setting up routes in tests without the need to scaffold routes in the actual app,
 * allowing for iterating on many different routing scenario / configurations rapidly.
 *
 * Example:
 * ```js
 * import { setupRouting } from 'ember-primitives/test-support';
 *
 *  ...
 *
 * test('my test', async function (assert) {
 *   setupRouting(this.owner, function () {
 *     this.route('foo');
 *     this.route('bar', function () {
 *       this.route('a');
 *       this.route('b');
 *     })
 *   });
 *
 *   await visit('/bar/b');
 * });
 * ```
 *
 */
export function setupRouting(owner: Owner, map: DSLCallback, options?: { rootURL: string }) {
  if (options?.rootURL) {
    assert('rootURL must begin with a forward slash ("/")', options?.rootURL?.startsWith('/'));
  }

  @properLinks
  class TestRouter extends Router {
    rootURL = options?.rootURL ?? '/';
  }

  TestRouter.map(map);

  owner.register('router:main', TestRouter);

  // eslint-disable-next-line ember/no-private-routing-service
  let iKnowWhatIMDoing = owner.lookup('router:main');

  // We need a public testing API for this sort of stuff
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (iKnowWhatIMDoing as any).setupRouter();
}

export function getRouter(owner: Owner) {
  return owner.lookup('service:router') as RouterService;
}
