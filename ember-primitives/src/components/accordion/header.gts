import { hash } from '@ember/helper';

import { getDataState } from './item';
import Trigger from './trigger';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

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

interface Signature extends AccordionHeaderExternalSignature {
  Args: AccordionHeaderExternalSignature['Args'] & {
    value: string;
    isExpanded: boolean;
    disabled?: boolean;
    toggleItem: () => void;
  };
}

export const AccordionHeader: TOC<Signature> = <template>
  <div
    role="heading"
    aria-level="3"
    data-state={{getDataState @isExpanded}}
    data-disabled={{@disabled}}
    ...attributes
  >
    {{yield
      (hash
        Trigger=(component
          Trigger value=@value isExpanded=@isExpanded disabled=@disabled toggleItem=@toggleItem
        )
      )
    }}
  </div>
</template>;

export default AccordionHeader;
