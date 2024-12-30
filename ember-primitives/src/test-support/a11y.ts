import { assert } from '@ember/debug';

import { setupTabster as _setupTabster } from '../tabster.ts';

import type Owner from '@ember/owner';

/**
 * Sets up all support utilities for primitive components.
 * Including the tabster root.
 */
async function setup(owner: Owner) {
  _setupTabster(owner, { setTabsterRoot: false });

  document.querySelector('#ember-testing')?.setAttribute('data-tabster', '{ "root": {} }');
}

export function setupTabster(hooks: {
  beforeEach: (callback: () => void | Promise<void>) => unknown;
}) {
  hooks.beforeEach(function (this: { owner: object }) {
    let owner = this.owner;

    assert(
      `Test does not have an owner, be sure to use setupRenderingTest, setupTest, or setupApplicationTest (from ember-qunit (or similar))`,
      owner
    );

    setup(this.owner as Owner);
  });
}