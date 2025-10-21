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
export declare function setupRouting(owner: Owner, map: DSLCallback, options?: {
    rootURL: string;
}): void;
export declare function getRouter(owner: Owner): RouterService;
//# sourceMappingURL=routing.d.ts.map