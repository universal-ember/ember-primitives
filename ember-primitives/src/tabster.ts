export async function setupTabster({
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
   */
  tabster?: boolean;
  setTabsterRoot?: boolean;
}) {
  const { createTabster, getDeloser, getMover, getTabster } = await import('tabster');

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
}
