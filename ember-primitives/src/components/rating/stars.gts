import { uniqueId } from "../../utils.ts";
import { isString, lte, percentSelected, shouldShowHalfIcon } from "./utils.ts";

import type { ComponentIcons, StringIcons } from "./public-types.ts";
import type { TOC } from "@ember/component/template-only";

export const Stars: TOC<{
  Args: {
    // Configuration
    stars: number[];
    icon: StringIcons["icon"] | ComponentIcons["icon"];
    iconHalf?: string | ComponentIcons["icon"];
    step: number;
    isReadonly: boolean;

    // HTML Boilerplate
    name: string;

    // State
    currentValue: number;
    total: number;
  };
}> = <template>
  <div class="ember-primitives__rating__items">
    {{#each @stars as |star|}}
      {{#let (uniqueId) (percentSelected star @currentValue) as |id percent|}}
        <span
          class="ember-primitives__rating__item"
          data-number={{star}}
          data-percent-selected={{percent}}
          data-selected={{lte star @currentValue}}
          data-readonly={{@isReadonly}}
        >
          <label for="input-{{id}}">
            <span visually-hidden>{{star}} star</span>
            <span aria-hidden="true">
              {{#if (isString @icon)}}
                {{#if (shouldShowHalfIcon @iconHalf percent)}}
                  {{! iconHalf is guaranteed to be a string here due to shouldShowHalfIcon check }}
                  {{@iconHalf}}
                {{else}}
                  {{@icon}}
                {{/if}}
              {{else}}
                {{! When icon is a component, use it with percentSelected for gradient rendering }}
                <@icon
                  @value={{star}}
                  @isSelected={{lte star @currentValue}}
                  @percentSelected={{percent}}
                  @readonly={{@isReadonly}}
                />
              {{/if}}
            </span>
          </label>

          <input
            id="input-{{id}}"
            type="radio"
            name={{@name}}
            value={{star}}
            readonly={{@isReadonly}}
            checked={{lte star @currentValue}}
          />
        </span>
      {{/let}}
    {{/each}}
  </div>
</template>;
