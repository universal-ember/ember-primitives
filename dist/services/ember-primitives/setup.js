import Service from '@ember/service';
import { getTabster, createTabster, getMover, getDeloser } from 'tabster';

/* eslint-disable @typescript-eslint/no-explicit-any */

/**
 * @internal
 */
const PRIMITIVES = Symbol.for('ember-primitives-globals');
class EmberPrimitivesSetup extends Service {
  /**
   * Sets up required features for accessibility.
   */
  setup = ({
    tabster,
    setTabsterRoot
  } = {}) => {
    tabster ??= true;
    setTabsterRoot ??= true;
    if (!tabster) {
      return;
    }
    let existing = getTabster(window);
    this.#setupTabster(existing ?? createTabster(window));
    if (setTabsterRoot) {
      document.body.setAttribute('data-tabster', '{ "root": {} }');
    }
  };
  #setupTabster = tabster => {
    getMover(tabster);
    getDeloser(tabster);
  };
}

export { PRIMITIVES, EmberPrimitivesSetup as default };
//# sourceMappingURL=setup.js.map
