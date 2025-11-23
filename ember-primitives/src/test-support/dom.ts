import { assert } from '@ember/debug';
import { find } from '@ember/test-helpers';

type Findable = Parameters<typeof find>[0] | Element;

/**
 * Find an element within a shadow-root.
 */
export function findInShadow(root: Findable, query: string) {
  const rootElement = root instanceof Element ? root : find(root);

  return rootElement?.shadowRoot?.querySelector(query);
}

/**
 * Does the element have a shadow root?
 */
export function hasShadowRoot(el: Element) {
  return Boolean(el.shadowRoot);
}

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

export function findInFirstShadow(query: string) {
  const host = findShadow();

  assert(`No element with a shadow root could be found`, host);

  return findInShadow(host, query);
}
