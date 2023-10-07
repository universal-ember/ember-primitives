import { on } from '@ember/modifier';

import { getDataState } from './item';

import type { TOC } from '@ember/component/template-only';

export const AccordionTrigger: TOC<{
  Element: HTMLButtonElement;
  Blocks: {
    default: [];
  };
  Args: {
    /**
     * Whether the accordion item is expanded or not.
     */
    isExpanded: boolean;
    /**
     * The value of the accordion item.
     */
    value: string;
    /**
     * Whether the accordion item is disabled or not.
     */
    disabled?: boolean;
    /**
     * A callback that is called when the accordion item is toggled.
     */
    toggleItem: () => void;
  }
}> = <template>
  <button
    type="button"
    aria-controls={{@value}}
    aria-expanded={{@isExpanded}}
    data-state={{getDataState @isExpanded}}
    data-disabled={{@disabled}}
    disabled={{@disabled}}
    {{on "click" @toggleItem}}
    ...attributes
  >
    {{yield}}
  </button>
</template>

export default AccordionTrigger;
