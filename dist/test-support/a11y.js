import { assert } from '@ember/debug';

/**
 * Sets up all support utilities for primitive components.
 * Including the tabster root.
 */
function setup(owner) {
  let service = owner.lookup('service:ember-primitives/setup');
  assert('Could not find the ember-primitives service', service);
  service.setup({
    setTabsterRoot: false
  });
  document.querySelector('#ember-testing')?.setAttribute('data-tabster', '{ "root": {} }');
}

export { setup };
//# sourceMappingURL=a11y.js.map
