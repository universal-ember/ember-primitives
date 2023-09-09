import './styles.css';

import Component from '@glimmer/component';
import { assert, warn } from '@ember/debug';
import { isDestroyed, isDestroying } from '@ember/destroyable';
import { uniqueId } from '@ember/helper';
import { on } from '@ember/modifier';
import { buildWaiter } from '@ember/test-waiters';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

const DEFAULT_LENGTH = 6;

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

const Fields: TOC<{
  /**
   * Any attributes passed to this component will be applied to each input.
   */
  Element: HTMLInputElement;
  Args: {
    fields: unknown[];
    id: string;
    labelFn: (index: number) => string;
    handleChange: (event: Event) => void;
  };
}> = <template>
  {{#each @fields as |_field i|}}
    <label>
      <span class='sr-only'>{{labelFor i @labelFn}}</span>
      <input
        data-primitives-code-segment='{{@id}}:{{i}}'
        name='code{{i}}'
        type='text'
        inputmode='numeric'
        ...attributes
        {{on 'input' autoAdvance}}
        {{on 'input' @handleChange}}
      />
    </label>
  {{/each}}
</template>;

export class OTPInput extends Component<{
  /**
   * The collection of individual OTP inputs are contained by a fieldset.
   * Applying the `disabled` attribute to this fieldset will disable
   * all of the inputs, if that's desired.
   */
  Element: HTMLFieldSetElement;
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
  Blocks: {
    /**
     * Optionally, you may control how the
     */
    default?: [fields: WithBoundArgs<typeof Fields, 'fields' | 'handleChange' | 'labelFn'>];
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
    //  would be fast enough to be quicker than individual frames
    //   (see logic in autoAdvance)
    //  )
    this.#frame = requestAnimationFrame(() => {
      waiter.endAsync(this.#token);

      if (isDestroyed(this) || isDestroying(this)) return;
      if (!this.args.onChange) return;

      let value = getCollectiveValue(event.target, this.id, this.length);

      if (value === undefined) {
        warn(`Value could not be determined for the OTP field. was it removed from the DOM?`, {
          id: 'ember-primitives.OTPInput.missing-value',
        });

        return;
      }

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
    <fieldset ...attributes>
      {{#let
        (component
          Fields fields=this.fields id=this.id handleChange=this.handleChange labelFn=@labelFn
        )
        as |CurriedFields|
      }}
        {{#if (has-block)}}
          {{yield CurriedFields}}
        {{else}}
          <CurriedFields />
        {{/if}}
      {{/let}}
    </fieldset>
  </template>
}

function getCollectiveValue(elementTarget: EventTarget | null, id: string, length: number) {
  if (!elementTarget) return;

  assert(
    `[BUG]: somehow the element target is not HTMLElement`,
    elementTarget instanceof HTMLElement,
  );

  let parent: null | HTMLElement | ShadowRoot;

  // TODO: should this logic be extracted?
  //       why is getting the target element within a shadow root hard?
  if (!(elementTarget instanceof HTMLInputElement)) {
    if (elementTarget.shadowRoot) {
      parent = elementTarget.shadowRoot;
    } else {
      parent = elementTarget.parentElement;
    }
  } else {
    parent = elementTarget.parentElement;
  }

  assert(`[BUG]: somehow the input fields were rendered without a parent element`, parent);

  let elements = parent.querySelectorAll(`[data-primitives-code-segment^="${id}:"]`);

  let value = '';

  assert(
    `found elements (${elements.length}) do not match length (${length}). Was the same OTP input rendered more than once?`,
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
