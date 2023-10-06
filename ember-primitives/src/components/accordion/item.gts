import Component from '@glimmer/component';
import { hash } from '@ember/helper';

import Content from './content';
import Header from './header';

import type { WithBoundArgs } from '@glint/template';

export interface AccordionItemSignature {
  Element: HTMLDivElement;
  Blocks: {
    default: [{
      Header: WithBoundArgs<typeof Header, 'value' | 'isExpanded' | 'toggleItem'>;
      Content: WithBoundArgs<typeof Content, 'isExpanded'>;
    }];
  };
  Args: {
    value: string;
    selectedValue?: string | string[];
    toggleItem: (value: string) => void;
  }
}

export class AccordionItem extends Component<AccordionItemSignature> {
  <template>
    <div ...attributes>
      {{yield
        (hash
          Header=(component Header value=this.args.value isExpanded=this.isExpanded toggleItem=this.toggleItem)
          Content=(component Content isExpanded=this.isExpanded)
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
    this.args.toggleItem(this.args.value);
  }
}

export default AccordionItem;
