/* eslint-disable @typescript-eslint/no-explicit-any */
import Service from '@ember/service';

import { createTabster, getMover, getTabster } from 'tabster';

/**
 * @internal
 */
export const PRIMITIVES = Symbol.for('ember-primitives-globals');

export default class EmberPrimitivesSetup extends Service {
  /**
   * Sets up required features for accessibility.
   */
  setup = ({
    tabster,
    setTabsterRoot,
  }: {
    /**
     * Let this setup function initalize tabster.
     * https://tabster.io/docs/core
     *
     * This should be done only once per application as we don't want
     * focus managers fighting with each other.
     *
     * Defaults to `true`,
     *
     * Will fallback to an existing tabster instance automatically if `getCurrentTabster` returns a value.
     */
    tabster?: boolean;
    setTabsterRoot?: boolean;
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

  #setupTabster = (tabster: ReturnType<typeof createTabster>) => {
    getMover(tabster);
  };
}
