import { assert } from '@ember/debug';

import type SetupService from '../services/ember-primitives/setup.ts';
import type Owner from '@ember/owner';

/**
 * Sets up all support utilities for primitive components.
 * Including the tabster root.
 */
export function setup(owner: Owner) {
  let service = owner.lookup('service:ember-primitives/setup');

  assert('Could not find the ember-primitives service', service);

  (service as SetupService).setup({ setTabsterRoot: false });

  document.querySelector('#ember-testing')?.setAttribute('data-tabster', '{ "root": {} }');
}
