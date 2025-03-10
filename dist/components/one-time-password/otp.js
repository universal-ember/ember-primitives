import { assert } from '@ember/debug';
import { hash, fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { buildWaiter } from '@ember/test-waiters';
import { Reset, Submit } from './buttons.js';
import { OTPInput } from './input.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const waiter = buildWaiter("ember-primitives:OTP:handleAutoSubmitAttempt");
const handleFormSubmit = (submit, event) => {
  event.preventDefault();
  assert("[BUG]: handleFormSubmit was not attached to a form. Please open an issue.", event.currentTarget instanceof HTMLFormElement);
  const formData = new FormData(event.currentTarget);
  let code = "";
  for (const [key, value] of formData.entries()) {
    if (key.startsWith("code")) {
      // eslint-disable-next-line @typescript-eslint/restrict-plus-operands, @typescript-eslint/no-base-to-string
      code += value;
    }
  }
  submit({
    code
  });
};
function handleChange(autoSubmit, data, event) {
  if (!autoSubmit) return;
  if (!data.complete) return;
  assert("[BUG]: event target is not a known element type", event.target instanceof HTMLElement || event.target instanceof SVGElement);
  const form = event.target.closest("form");
  assert("[BUG]: Cannot handle event when <OTP> Inputs are not rendered within their <form>", form);
  const token = waiter.beginAsync();
  const finished = () => {
    waiter.endAsync(token);
    form.removeEventListener("submit", finished);
  };
  form.addEventListener("submit", finished);
  // NOTE: when calling .submit() the submit event handlers are not run
  form.requestSubmit();
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
