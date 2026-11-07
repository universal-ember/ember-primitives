import Component from '@glimmer/component';
import { element } from 'ember-element-helper';
import { getSectionHeadingLevel } from 'which-heading-do-i-need';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';

class Heading extends Component {
  headingScopeAnchor;
  constructor(owner, args) {
    super(owner, args);
    this.headingScopeAnchor = document.createTextNode("");
  }
  get level() {
    return getSectionHeadingLevel(this.headingScopeAnchor);
  }
  get hLevel() {
    return `h${this.level}`;
  }
  static {
    setComponentTemplate(precompileTemplate("{{this.headingScopeAnchor}}\n\n{{#let (element this.hLevel) as |El|}}\n  <El ...attributes>\n    {{yield}}\n  </El>\n{{/let}}", {
      strictMode: true,
      scope: () => ({
        element
      })
    }), this);
  }
}

export { Heading };
//# sourceMappingURL=heading.js.map
