
import Component from '@glimmer/component';
import { element } from 'ember-element-helper';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';

const LOOKUP = new WeakMap();
function levelOf(node) {
  let parent = node.parentElement;
  let level = 0;
  while (parent) {
    if (parent instanceof Element) {
      if (parent.tagName.toLowerCase() === "section") {
        level++;
      }
    }
    if (parent instanceof ShadowRoot) {
      parent = parent.host;
    }
    parent = parent.parentNode;
  }
  return level;
}
class Heading extends Component {
  headingScopeAnchor;
  constructor(owner, args) {
    super(owner, args);
    this.headingScopeAnchor = document.createTextNode("");
  }
  get level() {
    const existing = LOOKUP.get(this.headingScopeAnchor);
    if (existing) return existing;
    const parentLevel = levelOf(this.headingScopeAnchor);
    const myLevel = parentLevel + 1;
    LOOKUP.set(this.headingScopeAnchor, myLevel);
    return myLevel;
  }
  get hLevel() {
    return `h${this.level}`;
  }
  static {
    setComponentTemplate(precompileTemplate("\n    {{this.headingScopeAnchor}}\n\n    {{#let (element this.hLevel) as |El|}}\n      <El ...attributes>\n        {{yield}}\n      </El>\n    {{/let}}\n  ", {
      strictMode: true,
      scope: () => ({
        element
      })
    }), this);
  }
}

export { Heading };
//# sourceMappingURL=heading.js.map
