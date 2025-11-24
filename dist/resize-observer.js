
import { assert } from '@ember/debug';
import { registerDestructor } from '@ember/destroyable';
import { createStore } from './store.js';
import { findOwner } from './utils.js';

/**
 * Creates or returns the ResizeObserverManager.
 *
 * Only one of these will exist per owner.
 *
 * Has only two methods:
 * - observe(element, callback: (resizeObserverEntry) => void)
 * - unobserve(element, callback: (resizeObserverEntry) => void)
 *
 * Like with the underlying ResizeObserver API (and all event listeners),
 * the callback passed to unobserved must be the same reference as the one
 * passed to observe.
 */
function resizeObserver(context) {
  const owner = findOwner(context);
  assert(`Could not find owner on the passed context (to resizeObserver). resizeObserver can only be used on an object whos lifetime is in someone entangled with the application (which incidentally has an "owner").`, owner);
  return createStore(owner, ResizeObserverManager);
}
class ResizeObserverManager {
  #callbacks = new WeakMap();
  #handleResize = entries => {
    for (const entry of entries) {
      const callbacks = this.#callbacks.get(entry.target);
      if (callbacks) {
        for (const callback of callbacks) {
          callback(entry);
        }
      }
    }
  };
  #observer = new ResizeObserver(this.#handleResize);
  constructor() {
    ignoreROError();
    registerDestructor(this, () => {
      this.#observer?.disconnect();
    });
  }

  /**
   * Initiate the observing of the `element` or add an additional `callback`
   * if the `element` is already observed.
   *
   * @param {object} element
   * @param {function} callback The `callback` is called whenever the size of
   *    the `element` changes. It is called with `ResizeObserverEntry` object
   *    for the particular `element`.
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
   * @param {object} element
   * @param {function?} callback - The `callback` to remove from the listeners
   *   of the `element` size changes.
   */
  unobserve(element, callback) {
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
const errorMessages = ['ResizeObserver loop limit exceeded', 'ResizeObserver loop completed with undelivered notifications.'];

/**
 * Ignores "ResizeObserver loop limit exceeded" error in Ember tests.
 *
 * This "error" is safe to ignore as it is just a warning message,
 * telling that the "looping" observation will be skipped in the current frame,
 * and will be delivered in the next one.
 *
 * For some reason, it is fired as an `error` event at `window` failing Ember
 * tests and exploding Sentry with errors that must be ignored.
 */
function ignoreROError() {
  if (typeof window.onerror !== 'function') {
    return;
  }
  const onError = window.onerror;
  window.onerror = (...args) => {
    const [message] = args;
    if (typeof message === 'string') {
      if (errorMessages.includes(message)) return true;
    }
    onError(...args);
  };
}

export { ignoreROError, resizeObserver };
//# sourceMappingURL=resize-observer.js.map
