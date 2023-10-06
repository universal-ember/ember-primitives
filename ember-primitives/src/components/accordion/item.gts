import Component from '@glimmer/component';
import { hash } from '@ember/helper';

import Content from './content';
import Header from './header';

import type { WithBoundArgs } from '@glint/template';

export interface AccordionItemSignature {
  Element: HTMLDivElement;
  Blocks: {
    default: [{
      Header: WithBoundArgs<typeof Header, 'value' | 'isExpanded' | 'disabled' | 'toggleItem'>;
      Content: WithBoundArgs<typeof Content, 'isExpanded' | 'disabled'>;
    }];
  };
  Args: {
    value: string;
    selectedValue?: string | string[];
    disabled?: boolean;
    toggleItem: (value: string) => void;
  }
}

export class AccordionItem extends Component<AccordionItemSignature> {
  <template>
    <div data-disabled={{@disabled}} ...attributes>
      {{yield
        (hash
          Header=(component Header value=this.args.value isExpanded=this.isExpanded disabled=@disabled toggleItem=this.toggleItem)
          Content=(component Content isExpanded=this.isExpanded disabled=@disabled)
        )
      }}
    </div>
  </template>

  get isExpanded(): boolean {
    if (Array.isArray(this.args.selectedValue)) {
      return this.args.selectedValue.includes(this.args.value);
    }

    return this.args.selectedValue === this.args.value;
  }

  toggleItem = (): void => {
    if (this.args.disabled) return;

    this.args.toggleItem(this.args.value);
  }
}

export default AccordionItem;