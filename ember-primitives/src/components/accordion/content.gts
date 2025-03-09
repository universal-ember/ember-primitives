import Component from "@glimmer/component";

import { getDataState } from "./item.gts";

import type { AccordionContentExternalSignature } from "./public.ts";

interface Signature extends AccordionContentExternalSignature {
  Args: {
    isExpanded: boolean;
    value: string;
    disabled?: boolean;
  };
}

export class AccordionContent extends Component<Signature> {
  <template>
    <div
      role="region"
      id={{@value}}
      data-state={{getDataState @isExpanded}}
      hidden={{this.isHidden}}
      data-disabled={{@disabled}}
      ...attributes
    >
      {{yield}}
    </div>
  </template>

  get isHidden() {
    return !this.args.isExpanded;
  }
}

export default AccordionContent;
