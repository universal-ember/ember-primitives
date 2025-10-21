
import Component from '@glimmer/component';
import { warn } from '@ember/debug';
import { isDestroyed, isDestroying } from '@ember/destroyable';
import { on } from '@ember/modifier';
import { buildWaiter } from '@ember/test-waiters';
import { handleNavigation, autoAdvance, handlePaste, selectAll, getCollectiveValue } from './utils.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const DEFAULT_LENGTH = 6;
function labelFor(inputIndex, labelFn) {
  if (labelFn) {
    return labelFn(inputIndex);
  }
  return `Please enter OTP character ${inputIndex + 1}`;
}
const waiter = buildWaiter("ember-primitives:OTPInput:handleChange");
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

export { OTPInput };
//# sourceMappingURL=input.js.map
