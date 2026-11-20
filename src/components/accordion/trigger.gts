import { on } from "@ember/modifier";

import { getDataState } from "./item.gts";

import type { AccordionTriggerExternalSignature } from "./public.ts";
import type { TOC } from "@ember/component/template-only";

interface Signature extends AccordionTriggerExternalSignature {
  Args: {
    isExpanded: boolean;
    triggerId: string;
    contentId: string;
    disabled?: boolean;
    toggleItem: () => void;
  };
}

export const AccordionTrigger: TOC<Signature> = <template>
  <button
    type="button"
    id={{@triggerId}}
    aria-controls={{@contentId}}
    aria-expanded={{if @isExpanded "true" "false"}}
    data-state={{getDataState @isExpanded}}
    data-disabled={{@disabled}}
    aria-disabled={{if @disabled "true" "false"}}
    {{on "click" @toggleItem}}
    ...attributes
  >
    {{yield}}
  </button>
</template>;

export default AccordionTrigger;
