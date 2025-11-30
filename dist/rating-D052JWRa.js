
import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { uniqueId } from './utils.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';
import { cached } from '@glimmer/tracking';
import { assert } from '@ember/debug';
import { localCopy } from 'tracked-toolbox';
import { g, i, n } from 'decorator-transforms/runtime';

const RatingRange = setComponentTemplate(precompileTemplate("\n  <input ...attributes name={{@name}} type=\"range\" max={{@max}} value={{@value}} {{on \"change\" @handleChange}} />\n", {
  strictMode: true,
  scope: () => ({
    on
  })
}), templateOnly());

function isString(x) {
  return typeof x === 'string';
}
function lte(a, b) {
  return a <= b;
}
function percentSelected(a, b) {
  const diff = b + 1 - a;
  if (diff < 0) return 0;
  if (diff > 1) return 100;
  if (a === b) return 100;
  const percent = diff * 100;
  return percent;
}

const Stars = setComponentTemplate(precompileTemplate("\n  <div class=\"ember-primitives__rating__items\">\n    {{#each @stars as |star|}}\n      {{#let (uniqueId) as |id|}}\n        <span class=\"ember-primitives__rating__item\" data-number={{star}} data-percent-selected={{percentSelected star @currentValue}} data-selected={{lte star @currentValue}} data-readonly={{@isReadonly}}>\n          <label for=\"input-{{id}}\">\n            <span visually-hidden>{{star}} star</span>\n            <span aria-hidden=\"true\">\n              {{#if (isString @icon)}}\n                {{@icon}}\n              {{else}}\n                <@icon @value={{star}} @isSelected={{lte star @currentValue}} @percentSelected={{percentSelected star @currentValue}} @readonly={{@isReadonly}} />\n              {{/if}}\n            </span>\n          </label>\n\n          <input id=\"input-{{id}}\" type=\"radio\" name={{@name}} value={{star}} readonly={{@isReadonly}} checked={{lte star @currentValue}} />\n        </span>\n      {{/let}}\n    {{/each}}\n  </div>\n", {
  strictMode: true,
  scope: () => ({
    uniqueId,
    percentSelected,
    lte,
    isString
  })
}), templateOnly());

class RatingState extends Component {
  static {
    g(this.prototype, "_value", [localCopy("args.value")]);
  }
  #_value = (i(this, "_value"), void 0); // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  get value() {
    return this._value ?? 0;
  }
  get stars() {
    return Array.from({
      length: this.args.max ?? 5
    }, (_, index) => index + 1);
  }
  static {
    n(this.prototype, "stars", [cached]);
  }
  setRating = value => {
    if (this.args.readonly) {
      return;
    }
    if (value === this._value) {
      this._value = 0;
    } else {
      this._value = value;
    }
    this.args.onChange?.(value);
  };
  setFromString = value => {
    assert("[BUG]: value from input must be a string.", typeof value === "string");
    const num = parseFloat(value);
    if (isNaN(num)) {
      // something went wrong.
      // Since we're using event delegation,
      // this could be from an unrelated input
      return;
    }
    this.setRating(num);
  };
  /**
  * Click events are captured by
  * - radio changes (mouse and keyboard)
  *   - but only range clicks
  */
  handleClick = event => {
    // Since we're doing event delegation on a click, we want to make sure
    // we don't do anything on other elements
    const isValid = event.target instanceof HTMLInputElement && event.target.name === this.args.name && event.target.type === "radio";
    if (!isValid) return;
    const selected = event.target?.value;
    this.setFromString(selected);
  };
  /**
  * Only attached to a range element, if present.
  * Range elements don't fire click events on keyboard usage, like radios do
  */
  handleChange = event => {
    const isValid = event.target !== null && "value" in event.target;
    if (!isValid) return;
    this.setFromString(event.target.value);
  };
  static {
    setComponentTemplate(precompileTemplate("\n    {{yield (hash stars=this.stars total=this.stars.length handleClick=this.handleClick handleChange=this.handleChange setRating=this.setRating value=this.value) (hash total=this.stars.length value=this.value)}}\n  ", {
      strictMode: true,
      scope: () => ({
        hash
      })
    }), this);
  }
}

class Rating extends Component {
  name = `rating-${uniqueId()}`;
  get icon() {
    return this.args.icon ?? "★";
  }
  get isInteractive() {
    return this.args.interactive ?? true;
  }
  get isChangeable() {
    const readonly = this.args.readonly ?? false;
    return !readonly && this.isInteractive;
  }
  get isReadonly() {
    return !this.isChangeable;
  }
  get needsDescription() {
    return !this.isInteractive;
  }
  static {
    setComponentTemplate(precompileTemplate("\n    <RatingState @max={{@max}} @value={{@value}} @name={{this.name}} @readonly={{this.isReadonly}} @onChange={{@onChange}} as |r publicState|>\n      <fieldset class=\"ember-primitives__rating\" data-total={{r.total}} data-value={{r.value}} data-readonly={{this.isReadonly}} {{!-- We use event delegation, this isn't a primary interactive -- we're capturing events from inputs --}} {{!-- template-lint-disable no-invalid-interactive --}} {{on \"click\" r.handleClick}} ...attributes>\n        {{#let (component Stars stars=r.stars icon=this.icon isReadonly=this.isReadonly name=this.name total=r.total currentValue=r.value) as |RatingStars|}}\n\n          {{#if (has-block)}}\n            {{yield (hash max=r.total total=r.total value=r.value name=this.name isReadonly=this.isReadonly isChangeable=this.isChangeable Stars=RatingStars Range=(component RatingRange max=r.total value=r.value name=this.name handleChange=r.handleChange))}}\n          {{else}}\n            {{#if this.needsDescription}}\n              {{#if (has-block \"label\")}}\n                {{yield publicState to=\"label\"}}\n              {{else}}\n                <span visually-hidden class=\"ember-primitives__rating__label\">Rated\n                  {{r.value}}\n                  out of\n                  {{r.total}}</span>\n              {{/if}}\n            {{else}}\n              {{#if (has-block \"label\")}}\n                <legend>\n                  {{yield publicState to=\"label\"}}\n                </legend>\n              {{/if}}\n            {{/if}}\n\n            <RatingStars />\n          {{/if}}\n        {{/let}}\n\n      </fieldset>\n    </RatingState>\n  ", {
      strictMode: true,
      scope: () => ({
        RatingState,
        on,
        Stars,
        hash,
        RatingRange
      })
    }), this);
  }
}

export { Rating as R };
//# sourceMappingURL=rating-D052JWRa.js.map
