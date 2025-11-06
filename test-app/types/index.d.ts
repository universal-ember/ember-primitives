import '@glint/environment-ember-loose';

import type * as testHelpers from '@ember/test-helpers';
import type * as testWaiters from '@ember/test-waiters';
import type { HelperLike } from '@glint/template';
import type PrimitivesRegistry from 'ember-primitives/template-registry';

declare global {
  declare const pauseTest: typeof testHelpers.pauseTest;
  declare const getSettledState: typeof testHelpers.getSettledState;
  declare const getPendingWaiterState: typeof testWaiters.getPendingWaiterState;
  declare const currentURL: typeof testHelpers.currentURL;
  declare const currentRouteName: typeof testHelpers.currentRouteName;
}

declare module '@glint/environment-ember-loose/registry' {
  // Remove this once entries have been added! 👇

  export default interface Registry extends PrimitivesRegistry {
    // Add any registry entries from other addons here that your addon itself uses (in non-strict mode templates)
    // See https://typed-ember.gitbook.io/glint/using-glint/ember/using-addons
    'page-title': HelperLike<{ Args: { Positional: [string] }; Return: string }>;
  }
}
