import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { isDestroyed, isDestroying } from '@ember/destroyable';
import { uniqueId } from '@ember/helper';
import { on } from '@ember/modifier';
import { buildWaiter } from '@ember/test-waiters';

const DEFAULT_LENGTH = 6;

//  https://web.dev/sms-otp-form/
// https://developer.mastercard.com/unified-checkout-solutions/documentation/use-cases/click-to-pay/ui-components/otp-input/
// https://www.cssscript.com/otp-input/
//
// This whole thing can be replicated with a single input and some *crazy* CSS
//  https://dev.to/madsstoumann/using-a-single-input-for-one-time-code-352l

const autoAdvance = (event: Event) => {
  assert(
    '[BUG]: autoAdvance called on non-input element',
    event.target instanceof HTMLInputElement,
  );

  let value = event.target.value;

  if (value.length === 1 && /\d/.test(value)) {
    let nextElement = event.target.nextElementSibling;

    if (nextElement instanceof HTMLElement) {
      nextElement.focus?.();
    }

    return;
  }

  const digits = value;
  let i = 0;
  let currElement: HTMLInputElement | null = event.target;

  while (currElement) {
    currElement.value = digits[i++] || '';

    if (currElement.nextElementSibling instanceof HTMLInputElement) {
      currElement = currElement.nextElementSibling;
    } else {
      break;
    }
  }
};

function labelFor(inputIndex: number, labelFn: undefined | ((index: number) => string)) {
  if (labelFn) {
    return labelFn(inputIndex);
  }

  return `Please enter OTP character ${inputIndex + 1}`;
}

let waiter = buildWaiter('ember-primitives:OTPInput:handleChange');

export class OTPInput extends Component<{
  /**
   * Any attributes passed to this component will be applied to each input.
   */
  Element: HTMLInputElement;
  Args: {
    /**
     * How many characters the one-time-password field should be
     * Defaults to 6
     */
    length?: number;

    /**
     * To Customize the label of the input fields, you may pass a function.
     * By default, this is `Please enter OTP character ${index + 1}`.
     */
    labelFn?: (index: number) => string;

    /**
     * If passed, this function will be called when the <Input> changes.
     * All fields are considered one input.
     */
    onChange?: (
      data: {
        /**
         * The text from the collective <Input>
         *
         * `code` _may_ be shorter than `length`
         * if the user has not finished typing / pasting their code
         */
        code: string;
        /**
         * will be `true` if `code`'s length matches the passed `@length` or the default of 6
         */
        complete: boolean;
      },
      /**
       * The last input event received
       */
      event: Event,
    ) => void;
  };
}> {
  /**
   * This is debounced, because we bind to each input,
   * but only want to emit one change event if someone pastes
   * multiple characters
   */
  handleChange = (event: Event) => {
    if (!this.args.onChange) return;

    if (!this.#token) {
      this.#token = waiter.beginAsync();
    }

    if (this.#frame) {
      cancelAnimationFrame(this.#frame);
    }

    if (this.#timer) {
      clearTimeout(this.#timer);
    }

    // We  use requestAnimationFrame to be friendly to rendering.
    // We don't know if onChange is going to want to cause paints
    // (it's also how we debounce, under the assumption that "paste" behavior
    //  would be fast enough to be quicker than inamiot frames
    //   (see logic in autoAdvance)
    //  )
    this.#frame = requestAnimationFrame(() => {
      waiter.endAsync(this.#token);

      if (isDestroyed(this) || isDestroying(this)) return;
      if (!this.args.onChange) return;

      let value = getCollectiveValue(this.id, this.length);

      this.args.onChange({ code: value, complete: value.length === this.length }, event);
    });
  };

  id = uniqueId();
  #token: unknown | undefined;
  #frame: number | undefined;
  #timer: number | undefined;

  get length() {
    return this.args.length ?? DEFAULT_LENGTH;
  }

  get fields() {
    // We only need to iterate a number of times,
    // so we don't care about the actual value or
    // referential integrity here
    return new Array(this.length);
  }

  <template>
    {{#each this.fields as |_field i|}}
      <input
        data-primitives-code-segment='{{this.id}}:{{i}}'
        name='code{{i}}'
        type='number'
        max='9'
        min='0'
        step='1'
        ...attributes
        aria-label={{labelFor i @labelFn}}
        {{on 'input' autoAdvance}}
        {{on 'input' this.handleChange}}
      />
    {{/each}}
  </template>
}

function getCollectiveValue(id: string, length: number) {
  let elements = document.querySelectorAll(`[data-primitives-code-segment^="${id}:"]`);

  let value = '';

  assert(
    `found elements do not match length (${length}). Was the same OTP input rendered more than once?`,
    elements.length === length,
  );

  for (let element of elements) {
    assert(
      '[BUG]: how did the queried elements become a non-input element?',
      element instanceof HTMLInputElement,
    );
    value += element.value;
  }

  return value;
}
