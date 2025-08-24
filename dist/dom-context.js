import Component from '@glimmer/component';
import { tracked, cached } from '@glimmer/tracking';
import { assert } from '@ember/debug';
import { createStore } from 'ember-primitives/store';
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
    const element = document.createElement("div");
    element.style.display = "contents";
    const key = this.args.key ?? this.args.data;
    LOOKUP.set(element, [key, () => this.data]);
    this.element = element;
  }
  static {
    setComponentTemplate(precompileTemplate("\n    {{this.element}}\n\n    {{#in-element this.element}}\n      {{yield}}\n    {{/in-element}}\n  ", {
      strictMode: true
    }), this);
  }
}
function findForKey(startElement, key) {
  let parent = startElement;
  while (parent = parent.parentElement) {
    const maybe = LOOKUP.get(parent);
    if (!maybe) {
      continue;
    }
    if (maybe[0] === key) {
      return maybe[1];
    }
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
    this.element = document.createElement("div");
    this.element.style.display = "contents";
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
    setComponentTemplate(precompileTemplate("\n    {{this.element}}\n\n    {{#in-element this.element}}\n      {{yield this.context}}\n    {{/in-element}}\n  ", {
      strictMode: true
    }), this);
  }
}

export { Consume, Provide };
//# sourceMappingURL=dom-context.js.map
