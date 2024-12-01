import { assert } from '@ember/debug';
import { setupTabster as setupTabster$1 } from '../tabster.js';

/**
 * Sets up all support utilities for primitive components.
 * Including the tabster root.
 */
async function setup(owner) {
  setupTabster$1(owner, {
    setTabsterRoot: false
  });
  document.querySelector('#ember-testing')?.setAttribute('data-tabster', '{ "root": {} }');
}
function setupTabster(hooks) {
  hooks.beforeEach(function () {
    let owner = this.owner;
    assert(`Test does not have an owner, be sure to use setupRenderingTest, setupTest, or setupApplicationTest (from ember-qunit (or similar))`, owner);
    setup(this.owner);
  });
}

export { setupTabster };
//# sourceMappingURL=a11y.js.map
