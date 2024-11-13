import { registerDestructor } from '@ember/destroyable';

export async function setupTabster(
  /**
   * A destroyable object.
   * This is needed so that when the app (or tests) or unmounted or ending,
   * the tabster instance can be disposed of.
   */
  context: object,
  {
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
     * Will fallback to an existing tabster instance automatically if `getTabster` returns a value.
     *
     * If `false` is explicitly passed here, you'll also be in charge of teardown.
     */
    tabster?: boolean;
    setTabsterRoot?: boolean;
  } = {}
) {
  const { createTabster, getDeloser, getMover, getTabster, disposeTabster } = await import(
    'tabster'
  );

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
