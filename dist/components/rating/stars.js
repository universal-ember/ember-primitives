
import { uniqueId } from '../../utils.js';
import { isString, lte, percentSelected } from './utils.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const Stars = setComponentTemplate(precompileTemplate("\n  <div class=\"ember-primitives__rating__items\">\n    {{#each @stars as |star|}}\n      {{#let (uniqueId) as |id|}}\n        <span class=\"ember-primitives__rating__item\" data-number={{star}} data-percent-selected={{percentSelected star @currentValue}} data-selected={{lte star @currentValue}} data-readonly={{@isReadonly}}>\n          <label for=\"input-{{id}}\">\n            <span visually-hidden>{{star}} star</span>\n            <span aria-hidden=\"true\">\n              {{#if (isString @icon)}}\n                {{@icon}}\n              {{else}}\n                <@icon @value={{star}} @isSelected={{lte star @currentValue}} @percentSelected={{percentSelected star @currentValue}} @readonly={{@isReadonly}} />\n              {{/if}}\n            </span>\n          </label>\n\n          <input id=\"input-{{id}}\" type=\"radio\" name={{@name}} value={{star}} readonly={{@isReadonly}} checked={{lte star @currentValue}} />\n        </span>\n      {{/let}}\n    {{/each}}\n  </div>\n", {
  strictMode: true,
  scope: () => ({
    uniqueId,
    percentSelected,
    lte,
    isString
  })
}), templateOnly());

export { Stars };
//# sourceMappingURL=stars.js.map
