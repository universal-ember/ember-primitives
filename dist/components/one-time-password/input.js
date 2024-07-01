import Component from '@glimmer/component';
import { warn } from '@ember/debug';
import { isDestroyed, isDestroying } from '@ember/destroyable';
import { on } from '@ember/modifier';
import { buildWaiter } from '@ember/test-waiters';
import { selectAll, handlePaste, autoAdvance, handleNavigation, getCollectiveValue } from './utils.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const DEFAULT_LENGTH = 6;
function labelFor(inputIndex1, labelFn1) {
  if (labelFn1) {
    return labelFn1(inputIndex1);
  }
  return `Please enter OTP character ${inputIndex1 + 1}`;
}
let waiter = buildWaiter('ember-primitives:OTPInput:handleChange');
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
  handleChange = event1 => {
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
      let value1 = getCollectiveValue(event1.target, this.length);
      if (value1 === undefined) {
        warn(`Value could not be determined for the OTP field. was it removed from the DOM?`, {
          id: 'ember-primitives.OTPInput.missing-value'
        });
        return;
      }
      this.args.onChange({
        code: value1,
        complete: value1.length === this.length
      }, event1);
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
    setComponentTemplate(precompileTemplate("\n    <fieldset ...attributes>\n      {{#let (component Fields fields=this.fields handleChange=this.handleChange labelFn=@labelFn) as |CurriedFields|}}\n        {{#if (has-block)}}\n          {{yield CurriedFields}}\n        {{else}}\n          <CurriedFields />\n        {{/if}}\n      {{/let}}\n\n      <style>\n        .ember-primitives__sr-only { position: absolute; width: 1px; height: 1px; padding: 0;\n        margin: -1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border-width:\n        0; }\n      </style>\n    </fieldset>\n  ", {
      strictMode: true,
      scope: () => ({
        Fields
      })
    }), this);
  }
}

export { OTPInput };
//# sourceMappingURL=input.js.map
