import type Trigger from './trigger.gts';
import type { WithBoundArgs } from '@glint/template';

export interface AccordionContentExternalSignature {
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
  Args: {};
}

export interface AccordionHeaderExternalSignature {
  /**
   * Add aria-level according to the heading level where the accordion is used (default: 3).
   * See https://www.w3.org/WAI/ARIA/apg/patterns/accordion/ for more information.
   */
  Element: HTMLDivElement;
  Blocks: {
    default: [
      {
        /**
         * The AccordionTrigger component.
         */
        Trigger: WithBoundArgs<typeof Trigger, 'value' | 'isExpanded' | 'disabled' | 'toggleItem'>;
      },
    ];
  };
  Args: {};
}

