import Component from '@glimmer/component';
import { warn } from '@ember/debug';
import { isDestroyed, isDestroying } from '@ember/destroyable';
import { on } from '@ember/modifier';
import { buildWaiter } from '@ember/test-waiters';

import {
  autoAdvance,
  getCollectiveValue,
  handleNavigation,
  handlePaste,
  selectAll,
} from './utils.ts';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

const DEFAULT_LENGTH = 6;

function labelFor(inputIndex: number, labelFn: undefined | ((index: number) => string)) {
  if (labelFn) {
    return labelFn(inputIndex);
  }

  return `Please enter OTP character ${inputIndex + 1}`;
}

const waiter = buildWaiter('ember-primitives:OTPInput:handleChange');

const Fields: TOC<{
  /**
   * Any attributes passed to this component will be applied to each input.
   */
  Element: HTMLInputElement;
  Args: {
    fields: unknown[];
    labelFn: (index: number) => string;
    handleChange: (event: Event) => void;
  };
}> = <template>
  {{#each @fields as |_field i|}}
    <label>
      <span class="ember-primitives__sr-only">{{labelFor i @labelFn}}</span>
      <input
        name="code{{i}}"
        type="text"
        inputmode="numeric"
        autocomplete="off"
        ...attributes
        {{on "click" selectAll}}
        {{on "paste" handlePaste}}
        {{on "input" autoAdvance}}
        {{on "input" @handleChange}}
        {{on "keydown" handleNavigation}}
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
         * The text from the collective `<Input>`
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
      event: Event
    ) => void;
  };
  Blocks: {
    /**
     * Optionally, you may control how the Fields are rendered, with proceeding text,
     * additional attributes added, etc.
     *
     * This is how you can add custom validation to each input field.
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

      const value = getCollectiveValue(event.target, this.length);

      if (value === undefined) {
        warn(`Value could not be determined for the OTP field. was it removed from the DOM?`, {
          id: 'ember-primitives.OTPInput.missing-value',
        });

        return;
      }

      this.args.onChange({ code: value, complete: value.length === this.length }, event);
    });
  };

  #token: unknown;
  #frame: number | undefined;

  get length() {
    return this.args.length ?? DEFAULT_LENGTH;
  }

  get fields() {
    // We only need to iterate a number of times,
    // so we don't care about the actual value or
    // referential integrity here
    return new Array<undefined>(this.length);
  }

  <template>
    <fieldset ...attributes>
      {{#let
        (component Fields fields=this.fields handleChange=this.handleChange labelFn=@labelFn)
        as |CurriedFields|
      }}
        {{#if (has-block)}}
          {{yield CurriedFields}}
        {{else}}
          <CurriedFields />
        {{/if}}
      {{/let}}

      <style>
        .ember-primitives__sr-only { position: absolute; width: 1px; height: 1px; padding: 0;
        margin: -1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border-width:
        0; }
      </style>
    </fieldset>
  </template>
}
