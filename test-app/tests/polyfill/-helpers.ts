/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable ember/no-private-routing-service */
import { settled } from '@ember/test-helpers';

import type Router from '@ember/routing/router';

type MapFunction = Parameters<(typeof Router)['map']>[0];

interface SetupRouterOptions {
  active?: string | string[];
  map?: MapFunction;
  rootURL?: string;
}

const noop = () => {};

/**
 * A test helper to define a new router map in the context of a test.
 *
 * Useful for when an integration test may need to interact with the router service,
 * but since you're only rendering a component, routing isn't enabled (pre Ember 3.25).
 *
 * Also useful for testing custom link components.
 *
 * @example
 *
 * import { setupRouter } from '@crowdstrike/test-helpers';
 *
 * module('tests that need a router', function(hooks) {
 *   setupRouter(hooks, {
 *     active: ['some-route-path.foo', 2],
 *     map: function() {
 *       this.route('some-route-path', function() {
 *         this.route('hi');
 *         this.route('foo', { path: ':dynamic_segment' });
 *       });
 *     },
 *   });
 * })
 *
 *
 * @param {NestedHooks} hooks
 * @param {Object} configuration - router configuration, as it would be defined in router.js
 * @param {Array} [configuration.active] - route segments that make up the active route
 * @param {Function} configuration.map - the router map
 * @param {string} [configuration.rootURL] - the root URL of the application
 */
export function setupRouter(
  hooks: NestedHooks,
  { active, map = noop, rootURL = '/' }: SetupRouterOptions = {}
) {
  let originalMaps: unknown[] = [];

  hooks.beforeEach(async function () {
    // @ts-expect-error - not fixing - private api
    const router = this.owner.resolveRegistration('router:main');

    router.rootURL = rootURL;
    originalMaps = router.dslCallbacks;
    router.dslCallbacks = [];

    router.map(map);
    // @ts-expect-error - not fixing - private api
    this.owner.lookup('router:main').setupRouter();

    if (active) {
      const routerService = this.owner.lookup('service:router');

      routerService.transitionTo(...ensureArray(active));
      await settled();
    }
  });

  hooks.afterEach(function () {
    // @ts-expect-error - not fixing - private api
    const router = this.owner.resolveRegistration('router:main');

    router.dslCallbacks = originalMaps;
  });
}

/**
 * For setting up the currently configured router in your app
 *
 */
export function setupAppRouter(hooks: NestedHooks) {
  hooks.beforeEach(function () {
    // @ts-expect-error - not fixing - private api
    this.owner.lookup('router:main').setupRouter();
  });
}

export function ensureArray<T>(maybeArray?: T | T[]): T[] {
  if (Array.isArray(maybeArray)) {
    return maybeArray;
  }

  if (!maybeArray) {
    return [];
  }

  return [maybeArray];
}
