import { click } from '@ember/test-helpers';

export class ZoetropeHelper {
  parentSelector = '.ember-primitives__zoetrope';

  constructor(parentSelector?: string) {
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
}
