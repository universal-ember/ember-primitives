
import Helper from '@ember/component/helper';
import { buildWaiter } from '@ember/test-waiters';

/**
 * Initial inspo:
 * - https://github.com/ef4/ember-set-body-class/blob/master/addon/services/body-class.js
 * - https://github.com/ef4/ember-set-body-class/blob/master/addon/helpers/set-body-class.js
 */
const waiter = buildWaiter('ember-primitives:body-class:raf');
let id = 0;
const registrations = new Map();
let previousRegistrations = [];
function classNames() {
  const allNames = new Set();
  for (const classNames of registrations.values()) {
    for (const className of classNames) {
      allNames.add(className);
    }
  }
  return [...allNames];
}
let frame;
let waiterToken;
function queueUpdate() {
  waiterToken ||= waiter.beginAsync();
  cancelAnimationFrame(frame);
  frame = requestAnimationFrame(() => {
    updateBodyClass();
    waiter.endAsync(waiterToken);
    waiterToken = undefined;
  });
}

/**
 * This should only add/remove classes that we tried to maintain via the body-class helper.
 *
 * Folks can set classes in their html and we don't want to mess with those
 */
function updateBodyClass() {
  const toAdd = classNames();
  for (const name of previousRegistrations) {
    document.body.classList.remove(name);
  }
  for (const name of toAdd) {
    document.body.classList.add(name);
  }
  previousRegistrations = toAdd;
}
class BodyClass extends Helper {
  localId = id++;
  compute([classes]) {
    const classNames = classes ? classes.split(/\s+/) : [];
    registrations.set(this.localId, classNames);
    queueUpdate();
  }
  willDestroy() {
    registrations.delete(this.localId);
    queueUpdate();
  }
}
const bodyClass = BodyClass;

export { bodyClass, BodyClass as default };
//# sourceMappingURL=body-class.js.map
