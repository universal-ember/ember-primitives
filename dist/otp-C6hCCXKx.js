
import { assert, warn } from '@ember/debug';
import { hash, fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { buildWaiter } from '@ember/test-waiters';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';
import Component from '@glimmer/component';
import { isDestroyed, isDestroying } from '@ember/destroyable';

function getInputs(current) {
  const fieldset = current.closest('fieldset');
  assert('[BUG]: fieldset went missing', fieldset);
  return [...fieldset.querySelectorAll('input')];
}
function nextInput(current) {
  const inputs = getInputs(current);
  const currentIndex = inputs.indexOf(current);
  return inputs[currentIndex + 1];
}
function selectAll(event) {
  const target = event.target;
  assert(`selectAll is only meant for use with input elements`, target instanceof HTMLInputElement);
  target.select();
}
function handlePaste(event) {
  const target = event.target;
  assert(`handlePaste is only meant for use with input elements`, target instanceof HTMLInputElement);
  const clipboardData = event.clipboardData;
  assert(`Could not get clipboardData while handling the paste event on OTP. Please report this issue on the ember-primitives repo with a reproduction. Thanks!`, clipboardData);

  // This is typically not good to prevent paste.
  // But because of the UX we're implementing,
  // we want to split the pasted value across
  // multiple text fields
  event.preventDefault();
  const value = clipboardData.getData('Text');
  const digits = value;
  let i = 0;
  let currElement = target;
  while (currElement) {
    currElement.value = digits[i++] || '';
    const next = nextInput(currElement);
    if (next instanceof HTMLInputElement) {
      currElement = next;
    } else {
      break;
    }
  }

  // We want to select the first field again
  // so that if someone holds paste, or
  // pastes again, they get the same result.
  target.select();
}
function handleNavigation(event) {
  switch (event.key) {
    case 'Backspace':
      return handleBackspace(event);
    case 'ArrowLeft':
      return focusLeft(event);
    case 'ArrowRight':
      return focusRight(event);
  }
}
function focusLeft(event) {
  const target = event.target;
  assert(`only allowed on input elements`, target instanceof HTMLInputElement);
  const input = previousInput(target);
  input?.focus();
  requestAnimationFrame(() => {
    input?.select();
  });
}
function focusRight(event) {
  const target = event.target;
  assert(`only allowed on input elements`, target instanceof HTMLInputElement);
  const input = nextInput(target);
  input?.focus();
  requestAnimationFrame(() => {
    input?.select();
  });
}
const syntheticEvent = new InputEvent('input');
function handleBackspace(event) {
  if (event.key !== 'Backspace') return;

  /**
   * We have to prevent default because we
   * - want to clear the whole field
   * - have the focus behavior keep up with the key-repeat
   *   speed of the user's computer
   */
  event.preventDefault();
  const target = event.target;
  if (target && 'value' in target) {
    if (target.value === '') {
      focusLeft({
        target
      });
    } else {
      target.value = '';
    }
  }
  target?.dispatchEvent(syntheticEvent);
}
function previousInput(current) {
  const inputs = getInputs(current);
  const currentIndex = inputs.indexOf(current);
  return inputs[currentIndex - 1];
}
const autoAdvance = event => {
  assert('[BUG]: autoAdvance called on non-input element', event.target instanceof HTMLInputElement);
  const value = event.target.value;
  if (value.length === 0) return;
  if (value.length > 0) {
    if ('data' in event && event.data && typeof event.data === 'string') {
      event.target.value = event.data;
    }
    return focusRight(event);
  }
};
function getCollectiveValue(elementTarget, length) {
  if (!elementTarget) return;
  assert(`[BUG]: somehow the element target is not HTMLElement`, elementTarget instanceof HTMLElement);
  let parent;

  // TODO: should this logic be extracted?
  //       why is getting the target element within a shadow root hard?
  if (!(elementTarget instanceof HTMLInputElement)) {
    if (elementTarget.shadowRoot) {
      parent = elementTarget.shadowRoot;
    } else {
      parent = elementTarget.closest('fieldset');
    }
  } else {
    parent = elementTarget.closest('fieldset');
  }
  assert(`[BUG]: somehow the input fields were rendered without a parent element`, parent);
  const elements = parent.querySelectorAll('input');
  let value = '';
  assert(`found elements (${elements.length}) do not match length (${length}). Was the same OTP input rendered more than once?`, elements.length === length);
  for (const element of elements) {
    assert('[BUG]: how did the queried elements become a non-input element?', element instanceof HTMLInputElement);
    value += element.value;
  }
  return value;
}

const DEFAULT_LENGTH = 6;
function labelFor(inputIndex, labelFn) {
  if (labelFn) {
    return labelFn(inputIndex);
  }
  return `Please enter OTP character ${inputIndex + 1}`;
}
const waiter$1 = buildWaiter("ember-primitives:OTPInput:handleChange");
const Fields = setComponentTemplate(precompileTemplate("\n  {{#each @fields as |_field i|}}\n    <label>\n      <span class=\"ember-primitives__sr-only\">{{labelFor i @labelFn}}</span>\n      <input name=\"code{{i}}\" type=\"text\" inputmode=\"numeric\" autocomplete=\"off\" ...attributes {{on \"click\" selectAll}} {{on \"paste\" handlePaste}} {{on \"input\" autoAdvance}} {{on \"input\" @handleChange}} {{on \"keydown\" handleNavigation}} />\n    </label>\n  {{/each}}\n", {
  strictMode: true,
  scope: () => ({
    labelFor,
    on,
    selectAll,
    handlePaste,
    autoAdvance,
    handleNavigation
  })
}), templateOnly());
class OTPInput extends Component {
  /**
  * This is debounced, because we bind to each input,
  * but only want to emit one change event if someone pastes
  * multiple characters
  */
  handleChange = event => {
    if (!this.args.onChange) return;
    if (!this.#token) {
      this.#token = waiter$1.beginAsync();
    }
    if (this.#frame) {
      cancelAnimationFrame(this.#frame);
    }
    // We  use requestAnimationFrame to be friendly to rendering.
    // We don't know if onChange is going to want to cause paints
    // (it's also how we debounce, under the assumption that "paste" behavior
    //  would be fast enough to be quicker than individual frames
    //   (see logic in autoAdvance)
    //  )
    this.#frame = requestAnimationFrame(() => {
      waiter$1.endAsync(this.#token);
      if (isDestroyed(this) || isDestroying(this)) return;
      if (!this.args.onChange) return;
      const value = getCollectiveValue(event.target, this.length);
      if (value === undefined) {
        warn(`Value could not be determined for the OTP field. was it removed from the DOM?`, {
          id: "ember-primitives.OTPInput.missing-value"
        });
        return;
      }
      this.args.onChange({
        code: value,
        complete: value.length === this.length
      }, event);
    });
  };
  #token;
  #frame;
  get length() {
    return this.args.length ?? DEFAULT_LENGTH;
  }
  get fields() {
    // We only need to iterate a number of times,
    // so we don't care about the actual value or
    // referential integrity here
    return new Array(this.length);
  }
  static {
    setComponentTemplate(precompileTemplate("\n    <fieldset ...attributes>\n      {{#let (component Fields fields=this.fields handleChange=this.handleChange labelFn=@labelFn) as |CurriedFields|}}\n        {{#if (has-block)}}\n          {{yield CurriedFields}}\n        {{else}}\n          <CurriedFields />\n        {{/if}}\n      {{/let}}\n\n      <style>\n        .ember-primitives__sr-only {\n          position: absolute;\n          width: 1px;\n          height: 1px;\n          padding: 0;\n          margin: -1px;\n          overflow: hidden;\n          clip: rect(0, 0, 0, 0);\n          white-space: nowrap;\n          border-width: 0;\n        }\n      </style>\n    </fieldset>\n  ", {
      strictMode: true,
      scope: () => ({
        Fields
      })
    }), this);
  }
}

const reset = event => {
  assert("[BUG]: reset called without an event.target", event.target instanceof HTMLElement);
  const form = event.target.closest("form");
  assert("Form is missing. Cannot use <Reset> without being contained within a <form>", form instanceof HTMLFormElement);
  form.reset();
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

export { OTPInput as O, OTP as a };
//# sourceMappingURL=otp-C6hCCXKx.js.map
