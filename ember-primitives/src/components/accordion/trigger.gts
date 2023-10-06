import { on } from '@ember/modifier';

import type { TOC } from '@ember/component/template-only';

export const AccordionTrigger: TOC<{
  Element: HTMLButtonElement;
  Blocks: {
    default: [];
  };
  Args: {
    isExpanded: boolean;
    value: string;
    disabled?: boolean;
    toggleItem: () => void;
  }
}> = <template>
  <button
    type="button"
    aria-controls={{@value}}
    aria-expanded={{@isExpanded}}
    data-disabled={{@disabled}}
    disabled={{@disabled}}
    {{on "click" @toggleItem}}
    ...attributes
  >
    {{yield}}
  </button>
</template>

export default AccordionTrigger;
