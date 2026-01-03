import { uniqueId } from "../../utils.ts";
import { isString, lte } from "./utils.ts";

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
          data-selected={{lte star @currentValue}}
          data-readonly={{@isReadonly}}
        >
          <label for="input-{{id}}">
            <span visually-hidden>{{star}} star</span>
            {{#if @icon}}
              <span aria-hidden="true">
                {{#if (isString @icon)}}
                  {{@icon}}
                {{else}}
                  <@icon
                    @value={{star}}
                    @isSelected={{lte star @currentValue}}
                    @readonly={{@isReadonly}}
                  />
                {{/if}}
              </span>
            {{/if}}
          </label>

          <input
            id="input-{{id}}"
            type="radio"
            name={{@name}}
            value={{star}}
            readonly={{@isReadonly}}
            checked={{Object.is star @currentValue}}
          />
        </span>
      {{/let}}
    {{/each}}
  </div>
</template>;
