import { assert } from '@ember/debug';
import { click, find, findAll } from '@ember/test-helpers';

const selectors = {
  root: '.ember-primitives__rating',
  item: '.ember-primitives__rating__item',
  label: '.ember-primitives__rating__label',

  rootData: {
    total: '[data-total]',
    value: '[data-value]',
  },

  itemData: {
    number: '[data-number]',
    readonly: '[data-readonly]',
    selected: '[data-selected]',
    itemPercent: '[data-percent-selected]',
  },
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
export function rating(selector?: string) {
  const root = `${selector ?? ''}${selectors.root}`;

  return new RatingPageObject(root);
}

class RatingPageObject {
  #root: string;

  constructor(root: string) {
    this.#root = root;
  }

  get #rootElement() {
    const element = find(this.#root);

    assert(
      `Could not find the root element for the <Rating> component. Used the selector \`${this.#root}\`. Was it rendered?`,
      element
    );

    return element;
  }

  get #labelElement() {
    const element = find(`${this.#root} ${selectors.label}`);

    assert(`Could not find the label for the <Rating> component. Was it rendered?`, element);

    return element;
  }

  get label() {
    return this.#labelElement.textContent;
  }

  get #starElements() {
    const elements = findAll(`${this.#root} ${selectors.item}`);

    return elements as HTMLElement[];
  }

  get stars() {
    return this.#starElements.map((x) => x.textContent?.trim() || '').join(' ');
  }

  get value() {
    const value = this.#rootElement.getAttribute(`data-value`);

    assert(`data-value attribute is missing on element '${this.#root}'`, value);

    const number = parseInt(value, 10);

    return number;
  }

  get isReadonly() {
    return this.#starElements.every((x) => x.hasAttribute('data-readonly'));
  }

  async select(stars: number) {
    const root = this.#rootElement;

    const star = root.querySelector(`[data-number="${stars}"] input`);

    assert(
      `Could not find item/star in <Rating> with value '${stars}'. Is the number (${stars}) correct and in-range for this component?`,
      star
    );

    await click(star);
  }
}
