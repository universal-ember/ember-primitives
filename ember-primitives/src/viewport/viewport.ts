import { registerDestructor } from '@ember/destroyable';

import { createService } from '../service.ts';

/**
 * Creates or returns the ViewportObserverManager.
 *
 * Only one of these will exist per owner.
 *
 * Has only two methods:
 * - observe(element, callback: (intersectionObserverEntry) => void, options?)
 * - unobserve(element, callback: (intersectionObserverEntry) => void)
 *
 * Like with the underlying IntersectionObserver API (and all event listeners),
 * the callback passed to unobserve must be the same reference as the one
 * passed to observe.
 */
export function viewport(context: object) {
  return createService(context, ViewportObserverManager);
}

export interface ViewportOptions {
  /**
   * A margin around the root. Can have values similar to the CSS margin property.
   * The values can be percentages. This set of values serves to grow or shrink each
   * side of the root element's bounding box before computing intersections.
   * Defaults to all zeros.
   */
  rootMargin?: string;
  /**
   * Either a single number or an array of numbers which indicate at what percentage
   * of the target's visibility the observer's callback should be executed. If you only
   * want to detect when visibility passes the 50% mark, you can use a value of 0.5.
   * If you want the callback to run every time visibility passes another 25%, you would
   * specify the array [0, 0.25, 0.5, 0.75, 1]. The default is 0 (meaning as soon as
   * even one pixel is visible, the callback will be run).
   */
  threshold?: number | number[];
}

class ViewportObserverManager {
  #callbacks = new WeakMap<Element, Set<(entries: IntersectionObserverEntry) => unknown>>();

  #handleIntersection = (entries: IntersectionObserverEntry[]) => {
    for (const entry of entries) {
      const callbacks = this.#callbacks.get(entry.target);

      if (callbacks) {
        for (const callback of callbacks) {
          callback(entry);
        }
      }
    }
  };

  #observer = new IntersectionObserver(this.#handleIntersection, {
    /**
     * NOTE: clipping is unaffected by rootMargin if the intersection is with anything
     *       other than the specified "root".
     *       And since we don't specify the "root", this effectively means the window viewport.
     *       (hence the utility name: "viewport")
     */
  });

  constructor() {
    registerDestructor(this, () => {
      this.#observer?.disconnect();
    });
  }

  /**
   * Initiate the observing of the `element` or add an additional `callback`
   * if the `element` is already observed.
   *
   * @param {object} element
   * @param {function} callback The `callback` is called whenever the `element`
   *    intersects with the viewport. It is called with an `IntersectionObserverEntry`
   *    object for the particular `element`.
   */
  observe(element: Element, callback: (entry: IntersectionObserverEntry) => unknown) {
    const callbacks = this.#callbacks.get(element);

    if (callbacks) {
      callbacks.add(callback);
    } else {
      this.#callbacks.set(element, new Set([callback]));
      this.#observer.observe(element);
    }
  }

  /**
   * End the observing of the `element` or just remove the provided `callback`.
   *
   * It will unobserve the `element` if the `callback` is not provided
   * or there are no more callbacks left for this `element`.
   *
   * @param {Element | undefined | null} element
   * @param {function?} callback - The `callback` to remove from the listeners
   *   of the `element` intersection changes.
   */
  unobserve(
    element: Element | undefined | null,
    callback: (entry: IntersectionObserverEntry) => unknown
  ) {
    if (!element) {
      return;
    }

    const callbacks = this.#callbacks.get(element);

    if (!callbacks) {
      return;
    }

    callbacks.delete(callback);

    if (!callback || !callbacks.size) {
      this.#callbacks.delete(element);
      this.#observer.unobserve(element);
    }
  }
}
