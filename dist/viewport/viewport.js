import { registerDestructor } from '@ember/destroyable';
import { createService } from '../service.js';

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
function viewport(context) {
  return createService(context, ViewportObserverManager);
}
class ViewportObserverManager {
  #callbacks = new WeakMap();
  #handleIntersection = entries => {
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
  observe(element, callback) {
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
  unobserve(element, callback) {
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

export { viewport };
//# sourceMappingURL=viewport.js.map
