import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { hash } from '@ember/helper';
import { modifier } from 'ember-modifier';
import { anchorTo } from './modifier.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i } from 'decorator-transforms/runtime';

const ref = modifier((element1, positional1) => {
  let fn1 = positional1[0];
  fn1(element1);
});
/**
 * A component that provides no DOM and yields two modifiers for creating
 * creating floating uis, such as menus, popovers, tooltips, etc.
 * This component currently uses [Floating UI](https://floating-ui.com/)
 * but will be switching to [CSS Anchor Positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning) when that lands.
 *
 * Example usage:
 * ```gjs
 * import { FloatingUI } from 'ember-primitives/floating-ui';
 *
 * <template>
 *   <FloatingUI as |reference floating|>
 *     <button {{reference}}> ... </button>
 *     <menu {{floating}}> ... </menu>
 *   </FloatingUI>
 * </template>
 * ```
 */
class FloatingUI extends Component {
  static {
    g(this.prototype, "reference", [tracked], function () {
      return undefined;
    });
  }
  #reference = (i(this, "reference"), void 0);
  static {
    g(this.prototype, "data", [tracked], function () {
      return undefined;
    });
  }
  #data = (i(this, "data"), void 0);
  setData = data1 => this.data = data1;
  setReference = element1 => {
    this.reference = element1;
  };
  static {
    setComponentTemplate(precompileTemplate("\n    {{#let (modifier anchorTo flipOptions=@flipOptions hideOptions=@hideOptions middleware=@middleware offsetOptions=@offsetOptions placement=@placement shiftOptions=@shiftOptions strategy=@strategy setData=this.setData) as |prewiredAnchorTo|}}\n      {{#let (if this.reference (modifier prewiredAnchorTo this.reference)) as |floating|}}\n        {{!-- @glint-nocheck -- Excessively deep, possibly infinite --}}\n        {{yield (modifier ref this.setReference) floating (hash setReference=this.setReference data=this.data)}}\n      {{/let}}\n    {{/let}}\n  ", {
      strictMode: true,
      scope: () => ({
        anchorTo,
        ref,
        hash
      })
    }), this);
  }
}

export { FloatingUI };
//# sourceMappingURL=component.js.map
