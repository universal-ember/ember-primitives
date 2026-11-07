import { assert } from '@ember/debug';
import { find } from '@ember/test-helpers';

type Findable = Parameters<typeof find>[0] | Element;

/**
 * Find an element within a given element that has a shadow-root.
 *
 * If the `root` can't be found, or if there actually is no shadow root,
 * nothing will be returned.
 *
 * ```gjs
 * import { findInShadow } from 'ember-primitives/test-support';
 *
 * // ...
 *
 * test('...', async function (assert) {
 *    // ...
 *    const root = find('div.with-shadowdom');
 *    assert.dom(findInShadow(root, 'h1')).containsText('welcome');
 * });
 * ```
 */
export function findInShadow(root: Findable, query: string) {
  const rootElement = root instanceof Element ? root : find(root);

  return rootElement?.shadowRoot?.querySelector(query);
}

/**
 * Does the element have a shadow root?
 *
 * Using this utility function will only save a few characters over using its implementation directly.
 *
 * ```gjs
 * import { hasShadowRoot } from 'ember-primitives/test-support';
 *
 * // ...
 *
 * test('...', async function (assert) {
 *    // ...
 *    const el = find('div.with-shadowdom');
 *    assert.ok(hasShadowRoot(el), 'expecting el to have a shadow root');
 * });
 * ```
 */
export function hasShadowRoot(el: Element) {
  return Boolean(el.shadowRoot);
}

/**
 * Find an element within `root`, that has a shadow root.
 * The `root` param is optional, and if not provided, all of `#ember-testing` will be searched.
 *
 * This only returns the first-found shadow, so if you want a specifc shadow root,
 * you'll need to narrow down the search by specifying a `root`.
 *
 * ```gjs
 * import { findShadow } from 'ember-primitives/test-support';
 *
 * // ...
 *
 * test('...', async function (assert) {
 *    // ...
 *    const el = findShadow('div.with-shadowdom');
 *    // ...
 * });
 * ```
 */
export function findShadow(root?: Findable) {
  const rootElement = root
    ? root instanceof Element
      ? root
      : find(root)
    : document.getElementById('ember-testing');

  if (!rootElement) return;

  for (const element of rootElement.querySelectorAll('*')) {
    if (element.shadowRoot) {
      return element;
    }
  }
}

/**
 * For the first available shadow root on the page, query in to it, like you would with `querySelector`.
 *
 *
 * ```gjs
 * import { findInFirstShadow } from 'ember-primitives/test-support';
 *
 * // ...
 *
 * test('...', async function (assert) {
 *    // ...
 *    assert.dom(findInFirstShadow('h1')).containsText('welcome');
 * });
 * ```
 *
 * If there are multiple shadow roots on the page / test-render,
 * this is not the utility for you.
 *
 * For querying in specific shadow roots, you'll want to use `findInShadow`
 */
export function findInFirstShadow(query: string) {
  const host = findShadow();

  assert(`No element with a shadow root could be found`, host);

  return findInShadow(host, query);
}
