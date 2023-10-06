import { hash } from '@ember/helper';

import Trigger from './trigger';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

export const AccordionHeader: TOC<{
  Element: HTMLDivElement;
  Blocks: {
    default: [{ Trigger: WithBoundArgs<typeof Trigger, 'value' | 'isExpanded' | 'disabled' | 'toggleItem'>; }];
  };
  Args: {
    value: string;
    isExpanded: boolean;
    disabled?: boolean;
    toggleItem: () => void;
  }
}> = <template>
  <div role='heading' aria-level='3' data-disabled={{@disabled}} ...attributes>
    {{yield (hash Trigger=(component Trigger value=@value isExpanded=@isExpanded disabled=@disabled toggleItem=@toggleItem))}}
  </div>
</template>

export default AccordionHeader;
