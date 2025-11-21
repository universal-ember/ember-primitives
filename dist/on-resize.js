
import { assert } from '@ember/debug';
import { registerDestructor } from '@ember/destroyable';
import Modifier from 'ember-modifier';
import { resizeObserver } from './resize-observer.js';
export { ignoreROError } from './resize-observer.js';

class OnResize extends Modifier {
  #callback = null;
  #element = null;
  #resizeObserver = resizeObserver(this);
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

export { onResize };
//# sourceMappingURL=on-resize.js.map
