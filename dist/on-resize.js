import { assert } from '@ember/debug';
import { registerDestructor } from '@ember/destroyable';
import Modifier from 'ember-modifier';

class OnResize extends Modifier {
  #callback = null;
  #element = null;
  #resizeObserver = new ResizeObserverManager();
  constructor(owner, args) {
    super(owner, args);
    registerDestructor(this, () => {
      if (this.#element && this.#callback) {
        this.#resizeObserver.unobserve(this.#element, this.#callback);
      }
    });
  }
  modify(element, [callback]) {
    assert(`{{onResize}}: callback must be a function, but was ${callback}`, typeof callback === 'function');
    if (this.#element && this.#callback) {
      this.#resizeObserver.unobserve(this.#element, this.#callback);
    }
    this.#resizeObserver.observe(element, callback);
    this.#callback = callback;
    this.#element = element;
  }
}
const onResize = OnResize;
const errorMessages = ['ResizeObserver loop limit exceeded', 'ResizeObserver loop completed with undelivered notifications.'];
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

export { ignoreROError as default, onResize };
//# sourceMappingURL=on-resize.js.map
