import { assert } from '@ember/debug';
import { on } from '@ember/modifier';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

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
  strictMode: true,
  scope: () => ({
    on,
    reset
  })
}), templateOnly());

export { Reset, Submit };
//# sourceMappingURL=buttons.js.map
