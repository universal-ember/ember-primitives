import { assert } from '@ember/debug';
import { fn, hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { buildWaiter } from '@ember/test-waiters';
import { Submit, Reset } from './buttons.js';
import { OTPInput } from './input.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

let waiter = buildWaiter('ember-primitives:OTP:handleAutoSubmitAttempt');
const handleFormSubmit = (submit1, event1) => {
  event1.preventDefault();
  assert('[BUG]: handleFormSubmit was not attached to a form. Please open an issue.', event1.currentTarget instanceof HTMLFormElement);
  let formData1 = new FormData(event1.currentTarget);
  let code1 = '';
  for (let [key1, value1] of formData1.entries()) {
    if (key1.startsWith('code')) {
      code1 += value1;
    }
  }
  submit1({
    code: code1
  });
};
function handleChange(autoSubmit1, data1, event1) {
  if (!autoSubmit1) return;
  if (!data1.complete) return;
  assert('[BUG]: event target is not a known element type', event1.target instanceof HTMLElement || event1.target instanceof SVGElement);
  const form1 = event1.target.closest('form');
  assert('[BUG]: Cannot handle event when <OTP> Inputs are not rendered within their <form>', form1);
  const token1 = waiter.beginAsync();
  let finished1 = () => {
    waiter.endAsync(token1);
    form1.removeEventListener('submit', finished1);
  };
  form1.addEventListener('submit', finished1);
  // NOTE: when calling .submit() the submit event handlers are not run
  form1.requestSubmit();
}
const OTP = setComponentTemplate(precompileTemplate("\n  <form {{on \"submit\" (fn handleFormSubmit @onSubmit)}} ...attributes>\n    {{yield (hash Input=(component OTPInput length=@length onChange=(if @autoSubmit (fn handleChange @autoSubmit))) Submit=Submit Reset=Reset)}}\n  </form>\n", {
  strictMode: true,
  scope: () => ({
    on,
    fn,
    handleFormSubmit,
    hash,
    OTPInput,
    handleChange,
    Submit,
    Reset
  })
}), templateOnly());

export { OTP };
//# sourceMappingURL=otp.js.map
