import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const Div = setComponentTemplate(precompileTemplate("\n  <div ...attributes>{{yield}}</div>\n", {
  strictMode: true
}), templateOnly());
const Label = setComponentTemplate(precompileTemplate("\n  <label for={{@for}} ...attributes>{{yield}}</label>\n", {
  strictMode: true
}), templateOnly());

export { Div, Label };
//# sourceMappingURL=typed-elements.js.map
