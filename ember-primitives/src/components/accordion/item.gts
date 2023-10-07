import Component from '@glimmer/component';
import { hash } from '@ember/helper';

import Content from './content';
import Header from './header';

import type { WithBoundArgs } from '@glint/template';

export function getDataState(isExpanded: boolean): string {
  return isExpanded ? 'open' : 'closed';
}

export class AccordionItem extends Component<{
  Element: HTMLDivElement;
  Blocks: {
    default: [{
      /**
       * The AccordionHeader component.
       */
      Header: WithBoundArgs<typeof Header, 'value' | 'isExpanded' | 'disabled' | 'toggleItem'>;
      /**
       * The AccordionContent component.
       */
      Content: WithBoundArgs<typeof Content, 'isExpanded' | 'disabled'>;
    }];
  };
  Args: {
    /**
     * The value of the accordion item.
     */
    value: string;
    /**
     * The currently selected value(s) of the accordion. Used to determine if the item is expanded.
     */
    selectedValue?: string | string[];
    /**
     * Whether the accordion item is disabled.
     */
    disabled?: boolean;
    /**
     * A callback that is called when the accordion item is toggled.
     */
    toggleItem: (value: string) => void;
  }
}> {
  <template>
    <div data-state={{getDataState this.isExpanded}} data-disabled={{@disabled}} ...attributes>
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
