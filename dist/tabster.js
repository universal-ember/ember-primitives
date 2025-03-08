import { registerDestructor } from '@ember/destroyable';

async function setupTabster(
/**
 * A destroyable object.
 * This is needed so that when the app (or tests) or unmounted or ending,
 * the tabster instance can be disposed of.
 */
context, {
  tabster,
  setTabsterRoot
} = {}) {
  const {
    createTabster,
    getDeloser,
    getMover,
    getTabster,
    disposeTabster
  } = await import('tabster');
  tabster ??= true;
  setTabsterRoot ??= true;
  if (!tabster) {
    return;
  }
  let existing = getTabster(window);
  let primitivesTabster = existing ?? createTabster(window);
  getMover(primitivesTabster);
  getDeloser(primitivesTabster);
  if (setTabsterRoot) {
    document.body.setAttribute('data-tabster', '{ "root": {} }');
  }
  registerDestructor(context, () => {
    disposeTabster(primitivesTabster);
  });
}

export { setupTabster };
//# sourceMappingURL=tabster.js.map
