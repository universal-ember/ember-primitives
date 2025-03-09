import Component from "@glimmer/component";
import { hash } from "@ember/helper";

import Content from "./content.gts";
import Header from "./header.gts";

import type { AccordionItemExternalSignature } from "./public.ts";

export function getDataState(isExpanded: boolean): string {
  return isExpanded ? "open" : "closed";
}

interface Signature extends AccordionItemExternalSignature {
  Args: AccordionItemExternalSignature["Args"] & {
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
