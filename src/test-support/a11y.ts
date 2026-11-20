import { assert } from '@ember/debug';

import { setupTabster as _setupTabster } from '../tabster.ts';

import type Owner from '@ember/owner';

/**
 * Sets up all support utilities for primitive components.
 * Including the tabster root.
 */
async function setup(owner: Owner) {
  await _setupTabster(owner, { setTabsterRoot: false });

  document.querySelector('#ember-testing')?.setAttribute('data-tabster', '{ "root": {} }');
}

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
export function setupTabster(hooks: {
  beforeEach: (callback: () => void | Promise<void>) => unknown;
}) {
  hooks.beforeEach(async function (this: { owner: object }) {
    const owner = this.owner;

    assert(
      `Test does not have an owner, be sure to use setupRenderingTest, setupTest, or setupApplicationTest (from ember-qunit (or similar))`,
      owner
    );

    await setup(this.owner as Owner);
  });
}
