import { assert } from '@ember/debug';
import { fn, hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { buildWaiter } from '@ember/test-waiters';

import { Reset, Submit } from './buttons';
import { OTPInput } from './input';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

let waiter = buildWaiter('ember-primitives:OTP:handleAutoSubmitAttempt');

const handleFormSubmit = (submit: (data: { code: string }) => void, event: SubmitEvent) => {
  event.preventDefault();

  assert(
    '[BUG]: handleFormSubmit was not attached to a form. Please open an issue.',
    event.currentTarget instanceof HTMLFormElement,
  );

  let formData = new FormData(event.currentTarget);

  let code = '';

  for (let [key, value] of formData.entries()) {
    if (key.startsWith('code')) {
      code += value;
    }
  }

  submit({
    code,
  });
};

function handleChange(
  autoSubmit: boolean | undefined,
  data: { code: string; complete: boolean },
  event: Event,
) {
  if (!autoSubmit) return;
  if (!data.complete) return;

  assert(
    '[BUG]: event target is not a known element type',
    event.target instanceof HTMLElement || event.target instanceof SVGElement,
  );

  const form = event.target.closest('form');

  assert('[BUG]: Cannot handle event when <OTP> Inputs are not rendered within their <form>', form);

  const token = waiter.beginAsync();
  let finished = () => {
    waiter.endAsync(token);
    form.removeEventListener('submit', finished);
  };

  form.addEventListener('submit', finished);

  // NOTE: when calling .submit() the submit event handlers are not run
  form.requestSubmit();
}

export const OTP: TOC<{
  /**
   * The overall OTP Input is in its own form.
   * Modern UI/UX Patterns usually have this sort of field
   * as its own page, thus within its own form.
   *
   * By default, only the 'submit' event is bound, and is
   * what calls the `@onSubmit` argument.
   */
  Element: HTMLFormElement;
  Args: {
    /**
     * How many characters the one-time-password field should be
     * Defaults to 6
     */
    length?: number;

    /**
     * The on submit callback will give you the entered
     * one-time-password code.
     *
     * It will be called when the user manually clicks the 'submit'
     * button or when the full code is pasted and meats the validation
     * criteria.
     */
    onSubmit: (data: { code: string }) => void;

    /**
     * Whether or not to auto-submit after the code has been pasted
     * in to the collective "field".  Default is true
     */
    autoSubmit?: boolean;
  };
  Blocks: {
    default: [
      {
        /**
         * The collective input field that the OTP code will be typed/pasted in to
         */
        Input: WithBoundArgs<typeof OTPInput, 'length' | 'onChange'>;
        /**
         * Button with `type="submit"` to submit the form
         */
        Submit: typeof Submit;
        /**
         * Pre-wired button to reset the form
         */
        Reset: typeof Reset;
      },
    ];
  };
}> = <template>
  <form {{on 'submit' (fn handleFormSubmit @onSubmit)}} ...attributes>
    {{yield
      (hash
        Input=(component
          OTPInput length=@length onChange=(if @autoSubmit (fn handleChange @autoSubmit))
        )
        Submit=Submit
        Reset=Reset
      )
    }}
  </form>
</template>;
