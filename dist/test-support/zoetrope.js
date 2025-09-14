import { click } from '@ember/test-helpers';

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

export { ZoetropeHelper };
//# sourceMappingURL=zoetrope.js.map
