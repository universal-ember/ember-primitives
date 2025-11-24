/**
 * A QUnit test utility for setting up the tabbing utility that a few of the components in ember-primitive use for providing enhanced keyboard support.
 *
 * ```gjs
 * import { module, test } from 'qunit';
 * import { setupRenderingTest } from 'ember-qunit';
 * import { setupTabster } from 'ember-primitives/test-support';
 *
 * module('your suite', function (hooks) {
 *   setupRenderingTest(hooks);
 *   setupTabster(hooks);
 *
 *   test('your test', async function (assert) {
 *      // ...
 *   });
 * });
 * ```
 *
 * This utility takes no options.
 */
export declare function setupTabster(hooks: {
    beforeEach: (callback: () => void | Promise<void>) => unknown;
}): void;
//# sourceMappingURL=a11y.d.ts.map