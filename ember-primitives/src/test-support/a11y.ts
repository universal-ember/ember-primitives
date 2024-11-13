/* eslint-disable @typescript-eslint/no-unused-vars */
import { setupTabster } from '../tabster.ts';

import type Owner from '@ember/owner';

/**
 * Sets up all support utilities for primitive components.
 * Including the tabster root.
 */
export async function setup(owner: Owner) {
  setupTabster({ setTabsterRoot: false });

  document.querySelector('#ember-testing')?.setAttribute('data-tabster', '{ "root": {} }');
}
