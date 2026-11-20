import Component from "@glimmer/component";
import { hash } from "@ember/helper";

import { uniqueId } from "../../utils.ts";
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
  /**
   * `@value` only has to be unique within one accordion.
   * Element ids have to be unique across the document.
   */
  id = `ember-primitives__accordion-${uniqueId()}`;
  triggerId = `${this.id}__trigger`;
  contentId = `${this.id}__content`;

  <template>
    <div data-state={{getDataState this.isExpanded}} data-disabled={{@disabled}} ...attributes>
      {{yield
        (hash
          isExpanded=this.isExpanded
          Header=(component
            Header
            triggerId=this.triggerId
            contentId=this.contentId
            isExpanded=this.isExpanded
            disabled=@disabled
            toggleItem=this.toggleItem
          )
          Content=(component
            Content
            triggerId=this.triggerId
            contentId=this.contentId
            isExpanded=this.isExpanded
            disabled=@disabled
          )
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
