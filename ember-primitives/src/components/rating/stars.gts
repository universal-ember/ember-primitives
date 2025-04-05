import { uniqueId } from "../../utils.ts";
import { isString, lte, percentSelected } from "./utils.ts";

import type { ComponentIcons, StringIcons } from "./public-types.ts";
import type { TOC } from "@ember/component/template-only";

export const Stars: TOC<{
  Args: {
    // Configuration
    stars: number[];
    icon: StringIcons["icon"] | ComponentIcons["icon"];
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
      {{#let (uniqueId) as |id|}}
        <span
          class="ember-primitives__rating__item"
          data-number={{star}}
          data-percent-selected={{percentSelected star @currentValue}}
          data-selected={{lte star @currentValue}}
          data-readonly={{@isReadonly}}
        >
          <label for="input-{{id}}">
            <span visually-hidden>{{star}} star</span>
            <span aria-hidden="true">
              {{#if (isString @icon)}}
                {{@icon}}
              {{else}}
                <@icon
                  @value={{star}}
                  @isSelected={{lte star @currentValue}}
                  @percentSelected={{percentSelected star @currentValue}}
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
