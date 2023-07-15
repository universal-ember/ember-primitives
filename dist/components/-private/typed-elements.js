import templateOnly from '@ember/component/template-only';
import { setComponentTemplate } from '@ember/component';
import { precompileTemplate } from '@ember/template-compilation';

const Div = setComponentTemplate(precompileTemplate(`<div ...attributes>{{yield}}</div>`, {
  strictMode: true
}), templateOnly("typed-elements", "Div"));
const Label = setComponentTemplate(precompileTemplate(`<label for={{@for}} ...attributes>{{yield}}</label>`, {
  strictMode: true
}), templateOnly("typed-elements", "Label"));

export { Div, Label };
//# sourceMappingURL=typed-elements.js.map
