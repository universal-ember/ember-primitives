import './styles.css';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { buildWaiter, waitForPromise } from '@ember/test-waiters';
import { macroCondition, isTesting } from '@embroider/macros';
import { modifier } from 'ember-modifier';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i } from 'decorator-transforms/runtime';

const testWaiter = buildWaiter('ember-primitive:zoetrope-waiter');
const DEFAULT_GAP = 8;
const DEFAULT_OFFSET = 0;
class Zoetrope extends Component {
  static {
    g(this.prototype, "scrollerElement", [tracked], function () {
      return null;
    });
  }
  #scrollerElement = (i(this, "scrollerElement"), void 0);
  static {
    g(this.prototype, "currentlyScrolled", [tracked], function () {
      return 0;
    });
  }
  #currentlyScrolled = (i(this, "currentlyScrolled"), void 0);
  static {
    g(this.prototype, "scrollWidth", [tracked], function () {
      return 0;
    });
  }
  #scrollWidth = (i(this, "scrollWidth"), void 0);
  static {
    g(this.prototype, "offsetWidth", [tracked], function () {
      return 0;
    });
  }
  #offsetWidth = (i(this, "offsetWidth"), void 0);
  setCSSVariables = modifier((element1, _1, {
    gap: gap1,
    offset: offset1
  }) => {
    if (gap1) element1.style.setProperty('--zoetrope-gap', `${gap1}px`);
    if (offset1) element1.style.setProperty('--zoetrope-offset', `${offset1}px`);
  });
  scrollerWaiter = testWaiter.beginAsync();
  noScrollWaiter = () => {
    testWaiter.endAsync(this.scrollerWaiter);
  };
  configureScroller = modifier(element1 => {
    this.scrollerElement = element1;
    this.currentlyScrolled = element1.scrollLeft;
    const zoetropeResizeObserver1 = new ResizeObserver(() => {
      this.scrollWidth = element1.scrollWidth;
      this.offsetWidth = element1.offsetWidth;
    });
    zoetropeResizeObserver1.observe(element1);
    element1.addEventListener('scroll', this.scrollListener, {
      passive: true
    });
    element1.addEventListener('keydown', this.tabListener);
    requestAnimationFrame(() => {
      testWaiter.endAsync(this.scrollerWaiter);
    });
    return () => {
      element1.removeEventListener('scroll', this.scrollListener);
      element1.removeEventListener('keydown', this.tabListener);
      zoetropeResizeObserver1.unobserve(element1);
    };
  });
  tabListener = event1 => {
    const target1 = event1.target;
    const {
      key: key1,
      shiftKey: shiftKey1
    } = event1;
    if (!this.scrollerElement || this.scrollerElement === target1) {
      return;
    }
    if (key1 !== 'Tab') {
      return;
    }
    const nextElement1 = target1.nextElementSibling;
    const previousElement1 = target1.previousElementSibling;
    if (!shiftKey1 && !nextElement1 || shiftKey1 && !previousElement1) {
      return;
    }
    event1.preventDefault();
    let newTarget1 = null;
    if (shiftKey1) {
      newTarget1 = previousElement1;
    } else {
      newTarget1 = nextElement1;
    }
    if (!newTarget1) {
      return;
    }
    newTarget1?.focus({
      preventScroll: true
    });
    const rect1 = getRelativeBoundingClientRect(newTarget1, this.scrollerElement);
    this.scrollerElement?.scrollBy({
      left: rect1.left,
      behavior: this.scrollBehavior
    });
  };
  scrollListener = () => {
    this.currentlyScrolled = this.scrollerElement?.scrollLeft || 0;
  };
  get offset() {
    return this.args.offset ?? DEFAULT_OFFSET;
  }
  get gap() {
    return this.args.gap ?? DEFAULT_GAP;
  }
  get canScroll() {
    return this.scrollWidth > this.offsetWidth + this.offset;
  }
  get cannotScrollLeft() {
    return this.currentlyScrolled <= this.offset;
  }
  get cannotScrollRight() {
    return this.scrollWidth - this.offsetWidth - this.offset < this.currentlyScrolled;
  }
  get scrollBehavior() {
    if (macroCondition(isTesting())) {
      return 'instant';
    }
    return this.args.scrollBehavior || 'smooth';
  }
  scrollLeft = () => {
    if (!(this.scrollerElement instanceof HTMLElement)) {
      return;
    }
    const {
      firstChild: firstChild1
    } = this.findOverflowingElement();
    if (!firstChild1) {
      return;
    }
    const children1 = [...this.scrollerElement.children];
    const firstChildIndex1 = children1.indexOf(firstChild1);
    let targetElement1 = firstChild1;
    let accumalatedWidth1 = 0;
    for (let i1 = firstChildIndex1; i1 >= 0; i1--) {
      const child1 = children1[i1];
      if (!(child1 instanceof HTMLElement)) {
        continue;
      }
      accumalatedWidth1 += child1.offsetWidth + this.gap;
      if (accumalatedWidth1 >= this.offsetWidth) {
        break;
      }
      targetElement1 = child1;
    }
    const rect1 = getRelativeBoundingClientRect(targetElement1, this.scrollerElement);
    this.scrollerElement.scrollBy({
      left: rect1.left,
      behavior: this.scrollBehavior
    });
    waitForPromise(new Promise(requestAnimationFrame));
  };
  scrollRight = () => {
    if (!(this.scrollerElement instanceof HTMLElement)) {
      return;
    }
    const {
      activeSlide: activeSlide1,
      lastChild: lastChild1
    } = this.findOverflowingElement();
    if (!lastChild1) {
      return;
    }
    let rect1 = getRelativeBoundingClientRect(lastChild1, this.scrollerElement);
    // If the card is larger than the container then skip to the next card
    if (rect1.width > this.offsetWidth && activeSlide1 === lastChild1) {
      const children1 = [...this.scrollerElement.children];
      const lastChildIndex1 = children1.indexOf(lastChild1);
      const targetElement1 = children1[lastChildIndex1 + 1];
      if (!targetElement1) {
        return;
      }
      rect1 = getRelativeBoundingClientRect(targetElement1, this.scrollerElement);
    }
    this.scrollerElement?.scrollBy({
      left: rect1.left,
      behavior: this.scrollBehavior
    });
    waitForPromise(new Promise(requestAnimationFrame));
  };
  findOverflowingElement() {
    const returnObj1 = {
      firstChild: undefined,
      lastChild: undefined,
      activeSlide: undefined
    };
    if (!this.scrollerElement) {
      return returnObj1;
    }
    const parentElement1 = this.scrollerElement.parentElement;
    if (!parentElement1) {
      return returnObj1;
    }
    const containerRect1 = getRelativeBoundingClientRect(this.scrollerElement, parentElement1);
    const children1 = [...this.scrollerElement.children];
    // Find the first child that is overflowing the left edge of the container
    // and the last child that is overflowing the right edge of the container
    for (const child1 of children1) {
      const rect1 = getRelativeBoundingClientRect(child1, this.scrollerElement);
      if (rect1.right + this.gap >= containerRect1.left && !returnObj1.firstChild) {
        returnObj1.firstChild = child1;
      }
      if (rect1.left >= this.offset && !returnObj1.activeSlide) {
        returnObj1.activeSlide = child1;
      }
      if (rect1.right >= containerRect1.width && !returnObj1.lastChild) {
        returnObj1.lastChild = child1;
        break;
      }
    }
    if (!returnObj1.firstChild) {
      returnObj1.firstChild = children1[0];
    }
    if (!returnObj1.lastChild) {
      returnObj1.lastChild = children1[children1.length - 1];
    }
    return returnObj1;
  }
  static {
    setComponentTemplate(precompileTemplate("\n    <section class=\"ember-primitives__zoetrope\" {{this.setCSSVariables gap=this.gap offset=this.offset}} ...attributes>\n      {{#if (has-block \"header\")}}\n        <div class=\"ember-primitives__zoetrope__header\">\n          {{yield to=\"header\"}}\n        </div>\n      {{/if}}\n\n      {{#if (has-block \"controls\")}}\n        {{yield (hash cannotScrollLeft=this.cannotScrollLeft cannotScrollRight=this.cannotScrollRight canScroll=this.canScroll scrollLeft=this.scrollLeft scrollRight=this.scrollRight) to=\"controls\"}}\n      {{else}}\n        {{#if this.canScroll}}\n          <div class=\"ember-primitives__zoetrope__controls\">\n            <button type=\"button\" {{on \"click\" this.scrollLeft}} disabled={{this.cannotScrollLeft}}>Left</button>\n\n            <button type=\"button\" {{on \"click\" this.scrollRight}} disabled={{this.cannotScrollRight}}>Right</button>\n          </div>\n        {{/if}}\n      {{/if}}\n      {{#if (has-block \"content\")}}\n        <div class=\"ember-primitives__zoetrope__scroller\" {{this.configureScroller}}>\n          {{yield to=\"content\"}}\n        </div>\n      {{else}}\n        {{(this.noScrollWaiter)}}\n      {{/if}}\n    </section>\n  ", {
      strictMode: true,
      scope: () => ({
        hash,
        on
      })
    }), this);
  }
}
function getRelativeBoundingClientRect(childElement1, parentElement1) {
  if (!childElement1 || !parentElement1) {
    throw new Error('Both childElement and parentElement must be provided');
  }
  // Get the bounding rect of the child and parent elements
  const childRect1 = childElement1.getBoundingClientRect();
  const parentRect1 = parentElement1.getBoundingClientRect();
  // Get computed styles of the parent element
  const parentStyles1 = window.getComputedStyle(parentElement1);
  // Extract and parse parent's padding, and border, for all sides
  const parentPaddingTop1 = parseFloat(parentStyles1.paddingTop);
  const parentPaddingLeft1 = parseFloat(parentStyles1.paddingLeft);
  const parentBorderTopWidth1 = parseFloat(parentStyles1.borderTopWidth);
  const parentBorderLeftWidth1 = parseFloat(parentStyles1.borderLeftWidth);
  // Calculate child's position relative to parent's content area (including padding and borders)
  return {
    width: childRect1.width,
    height: childRect1.height,
    top: childRect1.top - parentRect1.top - parentBorderTopWidth1 - parentPaddingTop1,
    left: childRect1.left - parentRect1.left - parentBorderLeftWidth1 - parentPaddingLeft1,
    bottom: childRect1.top - parentRect1.top - parentBorderTopWidth1 - parentPaddingTop1 + childRect1.height,
    right: childRect1.left - parentRect1.left - parentBorderLeftWidth1 - parentPaddingLeft1 + childRect1.width
  };
}

export { Zoetrope, Zoetrope as default };
//# sourceMappingURL=index.js.map
