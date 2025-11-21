
import Component from '@glimmer/component';
import { tracked, cached } from '@glimmer/tracking';
import { assert } from '@ember/debug';
import { isElement } from './narrowing.js';
import { createStore } from './store.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i, n } from 'decorator-transforms/runtime';

const LOOKUP = new WeakMap();
class Provide extends Component {
  get data() {
    assert(`@data is missing in <Provide>. Please pass @data.`, "data" in this.args);
    /**
    * This covers both classes and functions
    */
    if (typeof this.args.data === "function") {
      return createStore(this, this.args.data);
    }
    /**
    * Non-instantiable value
    */
    return this.args.data;
  }
  element;
  constructor(owner, args) {
    super(owner, args);
    assert(`@element may only be \`false\` or a string (or undefined (default when not set))`, this.args.element === undefined || this.args.element === false || typeof this.args.element === "string");
    if (this.useElementProvider) {
      this.element = document.createElement(this.args.element || "div");
      // This tells the browser to ignore everything about this element when it comes to styling
      this.element.style.display = "contents";
    } else {
      this.element = document.createTextNode("");
    }
    const key = this.args.key ?? this.args.data;
    LOOKUP.set(this.element, [key, () => this.data]);
  }
  get useElementProvider() {
    return this.args.element !== false;
  }
  static {
    setComponentTemplate(precompileTemplate("\n    {{#if (isElement this.element)}}\n      {{this.element}}\n\n      {{#in-element this.element}}\n        {{yield}}\n      {{/in-element}}\n\n    {{else}}\n      {{!-- NOTE! This type of provider will _allow_ non-descendents using the same key to find the provider and use it.\n\n        For example:\n          Provider\n            Consumer\n\n          Consumer (finds Provider)\n      --}}\n\n      {{this.element}}\n      {{yield}}\n\n    {{/if}}\n  ", {
      strictMode: true,
      scope: () => ({
        isElement
      })
    }), this);
  }
}
/**
 * How this works:
 * - starting at some deep node (Text, Element, whatever),
 *   start crawling up the ancenstry graph (of DOM Nodes).
 *
 * - This algo "tops out" (since we traverse upwards (otherwise this would be "bottoming out")) at the HTMLDocument (parent of the HTML Tag)
 *
 */
function findForKey(startElement, key) {
  let parent = startElement;
  while (parent) {
    let target = parent;
    while (target) {
      if (!(target instanceof Element) && !(target instanceof Text)) {
        target = target?.previousSibling;
        continue;
      }
      const maybe = LOOKUP.get(target);
      target = target?.previousSibling;
      if (!maybe) {
        continue;
      }
      if (maybe[0] === key) {
        return maybe[1];
      }
    }
    parent = parent.parentElement;
  }
}
class Consume extends Component {
  static {
    g(this.prototype, "getData", [tracked]);
  }
  #getData = (i(this, "getData"), void 0); // SAFETY: We do a runtime assert in the getter below.
  element;
  constructor(owner, args) {
    super(owner, args);
    this.element = document.createTextNode("");
  }
  get context() {
    // eslint-disable-next-line @typescript-eslint/no-this-alias
    const self = this;
    return {
      get data() {
        const getData = findForKey(self.element, self.args.key);
        assert(`Could not find provided context in <Consume>. Please assure that there is a corresponding <Provide> component before using this <Consume> component`, getData);
        // SAFETY: return type handled by getter's signature
        // eslint-disable-next-line @typescript-eslint/no-unsafe-return
        return getData();
      }
    };
  }
  static {
    n(this.prototype, "context", [cached]);
  }
  static {
    setComponentTemplate(precompileTemplate("\n    {{this.element}}\n\n    {{yield this.context}}\n  ", {
      strictMode: true
    }), this);
  }
}

export { Consume, Provide };
//# sourceMappingURL=dom-context.js.map
