import { assert } from '@ember/debug';
import Router from '@ember/routing/router';
import { properLinks } from '../proper-links.js';
import { c } from 'decorator-transforms/runtime';

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
function setupRouting(owner, map, options) {
  if (options?.rootURL) {
    assert('rootURL must begin with a forward slash ("/")', options?.rootURL?.startsWith('/'));
  }
  const TestRouter = c(class TestRouter extends Router {
    rootURL = options?.rootURL ?? '/';
  }, [properLinks]);
  TestRouter.map(map);
  owner.register('router:main', TestRouter);

  // eslint-disable-next-line ember/no-private-routing-service
  let iKnowWhatIMDoing = owner.lookup('router:main');

  // We need a public testing API for this sort of stuff
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  iKnowWhatIMDoing.setupRouter();
}
function getRouter(owner) {
  return owner.lookup('service:router');
}

export { getRouter, setupRouting };
//# sourceMappingURL=routing.js.map
