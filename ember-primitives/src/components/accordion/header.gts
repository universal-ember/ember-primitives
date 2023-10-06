import { hash } from '@ember/helper';

import Trigger from './trigger';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

export const AccordionHeader: TOC<{
  Element: HTMLDivElement;
  Blocks: {
    default: [{ Trigger: WithBoundArgs<typeof Trigger, 'value' | 'isExpanded' | 'toggleItem'>; }];
  };
  Args: {
    value: string;
    isExpanded: boolean;
    toggleItem: () => void;
  }
}> = <template>
  <div role='heading' aria-level='3' ...attributes>
    {{yield (hash Trigger=(component Trigger value=@value isExpanded=@isExpanded toggleItem=@toggleItem))}}
  </div>
</template>

export default AccordionHeader;
