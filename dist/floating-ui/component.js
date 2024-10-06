import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { hash } from '@ember/helper';
import { modifier } from 'ember-modifier';
import VelcroModifier from './modifier.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i } from 'decorator-transforms/runtime';

const ref = modifier((element1, positional1) => {
  let fn1 = positional1[0];
  fn1(element1);
});
class Velcro extends Component {
  static {
    g(this.prototype, "hook", [tracked], function () {
      return undefined;
    });
  }
  #hook = (i(this, "hook"), void 0);
  static {
    g(this.prototype, "velcroData", [tracked], function () {
      return undefined;
    });
  }
  #velcroData = (i(this, "velcroData"), void 0); // set by VelcroModifier
  setVelcroData = data1 => this.velcroData = data1;
  setHook = element1 => {
    this.hook = element1;
  };
  static {
    setComponentTemplate(precompileTemplate("\n    {{#let (modifier VelcroModifier flipOptions=@flipOptions hideOptions=@hideOptions middleware=@middleware offsetOptions=@offsetOptions placement=@placement shiftOptions=@shiftOptions strategy=@strategy setVelcroData=this.setVelcroData) as |loop|}}\n      {{#let (if this.hook (modifier loop this.hook)) as |loopWithHook|}}\n        {{!-- @glint-nocheck -- Excessively deep, possibly infinite --}}\n        {{yield (hash hook=(modifier ref this.setHook) setHook=this.setHook loop=loopWithHook data=this.velcroData)}}\n      {{/let}}\n    {{/let}}\n  ", {
      strictMode: true,
      scope: () => ({
        VelcroModifier,
        hash,
        ref
      })
    }), this);
  }
}

export { Velcro as default };
//# sourceMappingURL=component.js.map
