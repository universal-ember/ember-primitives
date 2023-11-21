import Component from '@glimmer/component';
import { hash } from '@ember/helper';

import Content from './content';
import Header from './header';

import type { WithBoundArgs } from '@glint/template';

export function getDataState(isExpanded: boolean): string {
  return isExpanded ? 'open' : 'closed';
}

export interface AccordionItemExternalSignature {
  Element: HTMLDivElement;
  Blocks: {
    default: [
      {
        /**
         * Whether the accordion item is expanded.
         */
        isExpanded: boolean;
        /**
         * The AccordionHeader component.
         */
        Header: WithBoundArgs<typeof Header, 'value' | 'isExpanded' | 'disabled' | 'toggleItem'>;
        /**
         * The AccordionContent component.
         */
        Content: WithBoundArgs<typeof Content, 'value' | 'isExpanded' | 'disabled'>;
      },
    ];
  };
  Args: {
    /**
     * The value of the accordion item.
     */
    value: string;
  };
}

interface Signature extends AccordionItemExternalSignature {
  Args: AccordionItemExternalSignature['Args'] & {
    selectedValue?: string | string[];
    disabled?: boolean;
    toggleItem: (value: string) => void;
  };
}

export class AccordionItem extends Component<Signature> {
  <template>
    <div data-state={{getDataState this.isExpanded}} data-disabled={{@disabled}} ...attributes>
      {{yield
        (hash
          isExpanded=this.isExpanded
          Header=(component
            Header
            value=@value
            isExpanded=this.isExpanded
            disabled=@disabled
            toggleItem=this.toggleItem
          )
          Content=(component Content value=@value isExpanded=this.isExpanded disabled=@disabled)
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
  };
}

export default AccordionItem;
