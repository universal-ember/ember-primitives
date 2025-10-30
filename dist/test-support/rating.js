
import { assert } from '@ember/debug';
import { find, findAll, click, fillIn } from '@ember/test-helpers';

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

export { rating };
//# sourceMappingURL=rating.js.map
