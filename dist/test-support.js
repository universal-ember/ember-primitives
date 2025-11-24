
import { assert } from '@ember/debug';
import { setupTabster as setupTabster$1 } from './tabster.js';
import { find, fillIn, settled, findAll, click } from '@ember/test-helpers';
import Router from '@ember/routing/router';
import { properLinks } from './proper-links.js';
import { c } from 'decorator-transforms/runtime';

/**
 * Sets up all support utilities for primitive components.
 * Including the tabster root.
 */
async function setup(owner) {
  await setupTabster$1(owner, {
    setTabsterRoot: false
  });
  document.querySelector('#ember-testing')?.setAttribute('data-tabster', '{ "root": {} }');
}

/**
 * A QUnit test utility for setting up the tabbing utility that a few of the components in ember-primitive use for providing enhanced keyboard support.
 *
 * ```gjs
 * import { module, test } from 'qunit';
 * import { setupRenderingTest } from 'ember-qunit';
 * import { setupTabster } from 'ember-primitives/test-support';
 *
 * module('your suite', function (hooks) {
 *   setupRenderingTest(hooks);
 *   setupTabster(hooks);
 *
 *   test('your test', async function (assert) {
 *      // ...
 *   });
 * });
 * ```
 *
 * This utility takes no options.
 */
function setupTabster(hooks) {
  hooks.beforeEach(async function () {
    const owner = this.owner;
    assert(`Test does not have an owner, be sure to use setupRenderingTest, setupTest, or setupApplicationTest (from ember-qunit (or similar))`, owner);
    await setup(this.owner);
  });
}

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
function findInShadow(root, query) {
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
function hasShadowRoot(el) {
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
function findShadow(root) {
  const rootElement = root ? root instanceof Element ? root : find(root) : document.getElementById('ember-testing');
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
function findInFirstShadow(query) {
  const host = findShadow();
  assert(`No element with a shadow root could be found`, host);
  return findInShadow(host, query);
}

/**
 * Fill the OTP input
 *
 * ```gjs
 * import { fillOTP } from 'ember-primitives/test-support';
 *
 * test('...', async function(assert) {
 *   // ...
 *   await fillOTP('123456');
 *   // ...
 * })
 *
 * ```
 *
 * @param {string} code the code to fill the input(s) with.
 * @param {string} [ selector ] if there are multiple OTP components on a page, this can be used to select one of them.
 */
async function fillOTP(code, selector) {
  const ancestor = selector ? find(selector) : document;
  assert(`Could not find ancestor element, does your selector match an existing element?`, ancestor);
  const fieldset = ancestor instanceof HTMLFieldSetElement ? ancestor : ancestor.querySelector('fieldset');
  assert(`Could not find containing fieldset element (this holds the OTP Input fields). Was the OTP component rendered?`, fieldset);
  const inputs = fieldset.querySelectorAll('input');
  assert(`code cannot be longer than the available inputs. code is of length ${code.length} but there are ${inputs.length}`, code.length <= inputs.length);
  const chars = code.split('');
  assert(`OTP Input for index 0 is missing!`, inputs[0]);
  assert(`Character at index 0 is missing`, chars[0]);
  for (let i = 0; i < chars.length; i++) {
    const input = inputs[i];
    const char = chars[i];
    assert(`Input at index ${i} is missing`, input);
    assert(`Character at index ${i} is missing`, char);
    input.value = char;
  }
  await fillIn(inputs[0], chars[0]);

  // Account for out-of-settled-system delay due to RAF debounce.
  await new Promise(resolve => requestAnimationFrame(resolve));
  await settled();
}

const selectors = {
  root: '.ember-primitives__rating',
  item: '.ember-primitives__rating__item',
  label: '.ember-primitives__rating__label'};
const stars = {
  selected: '★',
  unselected: '☆'
};

/**
 * Test utility for interacting with the
 * Rating component.
 *
 * Simulates user behavior and provides high level functions so you don't need to worry about the DOM.
 *
 * Actual elements are not exposed, as the elements are private API.
 * Even as you build a design system, the DOM should not be exposed to your consumers.
 */
function rating(selector) {
  const root = `${selector ?? ''}${selectors.root}`;
  return new RatingPageObject(root);
}
class RatingPageObject {
  #root;
  constructor(root) {
    this.#root = root;
  }
  get #rootElement() {
    const element = find(this.#root);
    assert(`Could not find the root element for the <Rating> component. Used the selector \`${this.#root}\`. Was it rendered?`, element);
    return element;
  }
  get #labelElement() {
    const element = find(`${this.#root} ${selectors.label}`);
    assert(`Could not find the label for the <Rating> component. Was it rendered?`, element);
    return element;
  }
  get label() {
    return this.#labelElement.textContent?.replaceAll(/\s+/g, ' ').trim();
  }
  get #starElements() {
    const elements = findAll(`${this.#root} ${selectors.item}`);
    assert(`There are no stars/items. Is the <Rating> component misconfigured?`, elements.length > 0);
    return elements;
  }
  get stars() {
    const elements = this.#starElements;
    return elements.map(x => x.hasAttribute('data-selected') ? stars.selected : stars.unselected).join(' ');
  }
  get starTexts() {
    const elements = this.#starElements;
    return elements.map(x => x.querySelector('[aria-hidden]')?.textContent?.trim()).join(' ');
  }
  get value() {
    const value = this.#rootElement.getAttribute(`data-value`);
    assert(`data-value attribute is missing on element '${this.#root}'`, value);
    const number = parseFloat(value);
    return number;
  }
  get isReadonly() {
    return this.#starElements.every(x => x.hasAttribute('data-readonly'));
  }
  async select(stars) {
    const root = this.#rootElement;
    const star = root.querySelector(`[data-number="${stars}"] input`);
    if (star) {
      await click(star);
      return;
    }

    /**
     * When we don't have an input, we require an input --
     * which is also the only way we can choose non-integer values.
     *
     * Should be able to be a number input or range input.
     */
    const input = root.querySelector('input[type="number"], input[type="range"]');
    if (input) {
      await fillIn(input, `${stars}`);
      return;
    }
    const available = [...root.querySelectorAll('[data-number]')].map(x => x.getAttribute('data-number'));
    assert(`Could not find item/star in <Rating> with value '${stars}' (or a number or range input with the same "name" value). Is the number (${stars}) correct and in-range for this component? The found available values are ${available.join(', ')}.`);
  }
}

/**
 * Allows setting up routes in tests without the need to scaffold routes in the actual app,
 * allowing for iterating on many different routing scenario / configurations rapidly.
 *
 * Example:
 * ```js
 * import { setupRouting } from 'ember-primitives/test-support';
 *
 *  ...
 *
 * test('my test', async function (assert) {
 *   setupRouting(this.owner, function () {
 *     this.route('foo');
 *     this.route('bar', function () {
 *       this.route('a');
 *       this.route('b');
 *     })
 *   });
 *
 *   await visit('/bar/b');
 * });
 * ```
 *
 */
function setupRouting(owner, map, options) {
  if (options?.rootURL) {
    assert('rootURL must begin with a forward slash ("/")', options?.rootURL?.startsWith('/'));
  }
  const TestRouter = c(class TestRouter extends Router {
    rootURL = options?.rootURL ?? '/';
  }, [properLinks]);
  TestRouter.map(map);
  owner.register('router:main', TestRouter);

  // eslint-disable-next-line ember/no-private-routing-service
  const iKnowWhatIMDoing = owner.lookup('router:main');

  // We need a public testing API for this sort of stuff

  // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
  iKnowWhatIMDoing.setupRouter();
}

/**
 * A small utility that only gives you a _typed_ router service.
 */
function getRouter(owner) {
  return owner.lookup('service:router');
}

/* eslint-disable @typescript-eslint/no-non-null-assertion */
class ZoetropeHelper {
  parentSelector = '.ember-primitives__zoetrope';
  constructor(parentSelector) {
    if (parentSelector) {
      this.parentSelector = parentSelector;
    }
  }
  async scrollLeft() {
    await click(`${this.parentSelector} .ember-primitives__zoetrope__controls button:first-child`);
  }
  async scrollRight() {
    await click(`${this.parentSelector} .ember-primitives__zoetrope__controls button:last-child`);
  }
  visibleItems() {
    const zoetropeContent = document.querySelectorAll(`${this.parentSelector} .ember-primitives__zoetrope__scroller > *`);
    let firstVisibleItemIndex = -1;
    let lastVisibleItemIndex = -1;
    for (let i = 0; i < zoetropeContent.length; i++) {
      const item = zoetropeContent[i];
      const rect = item.getBoundingClientRect();
      const parentRect = item.parentElement.getBoundingClientRect();
      if (rect.right >= parentRect?.left && rect.left <= parentRect?.right) {
        if (firstVisibleItemIndex === -1) {
          firstVisibleItemIndex = i;
        }
        lastVisibleItemIndex = i;
      } else if (firstVisibleItemIndex !== -1) {
        break;
      }
    }
    return Array.from(zoetropeContent).slice(firstVisibleItemIndex, lastVisibleItemIndex + 1);
  }
  visibleItemCount() {
    return this.visibleItems().length;
  }
}

export { ZoetropeHelper, fillOTP, findInFirstShadow, findInShadow, findShadow, getRouter, hasShadowRoot, rating, setupRouting, setupTabster };
//# sourceMappingURL=test-support.js.map
