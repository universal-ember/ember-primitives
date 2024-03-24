import { assert } from '@ember/debug';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';
import { on } from '@ember/modifier';

const reset = event1 => {
  assert('[BUG]: reset called without an event.target', event1.target instanceof HTMLElement);
  let form1 = event1.target.closest('form');
  assert('Form is missing. Cannot use <Reset> without being contained within a <form>', form1 instanceof HTMLFormElement);
  form1.reset();
};
const Submit = setComponentTemplate(precompileTemplate("\n  <button type=\"submit\" ...attributes>Submit</button>\n", {
  strictMode: true
}), templateOnly());
const Reset = setComponentTemplate(precompileTemplate("\n  <button type=\"button\" {{on \"click\" reset}} ...attributes>{{yield}}</button>\n", {
  scope: () => ({
    on,
    reset
  }),
  strictMode: true
}), templateOnly());

export { Reset, Submit };
//# sourceMappingURL=buttons.js.map
