import { assert } from '@ember/debug';
import { registerDestructor } from '@ember/destroyable';

import Modifier, { type ArgsFor } from 'ember-modifier';

import { resizeObserver } from './resize-observer.ts';

import type Owner from '@ember/owner';

// re-export provided for convenience
export { ignoreROError } from './resize-observer.ts';

export interface Signature {
  /**
   * Any element that is resizable can have onResize attached
   */
  Element: Element;
  Args: {
    Positional: [
      /**
       * The ResizeObserver callback will only receive
       * one entry per resize event.
       *
       * See: [ResizeObserverEntry](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry)
       */
      callback: (entry: ResizeObserverEntry) => void,
    ];
  };
}

class OnResize extends Modifier<Signature> {
  #callback: ((entry: ResizeObserverEntry) => void) | null = null;
  #element: Element | null = null;

  #resizeObserver = resizeObserver(this);

  constructor(owner: Owner, args: ArgsFor<Signature>) {
    super(owner, args);

    registerDestructor(this, () => {
      if (this.#element && this.#callback) {
        this.#resizeObserver.unobserve(this.#element, this.#callback);
      }
    });
  }

  modify(element: Element, [callback]: [callback: (entry: ResizeObserverEntry) => void]) {
    assert(
      `{{onResize}}: callback must be a function, but was ${callback as unknown as string}`,
      typeof callback === 'function'
    );

    if (this.#element && this.#callback) {
      this.#resizeObserver.unobserve(this.#element, this.#callback);
    }

    this.#resizeObserver.observe(element, callback);

    this.#callback = callback;
    this.#element = element;
  }
}

export const onResize = OnResize;
