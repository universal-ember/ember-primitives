import { hash } from "@ember/helper";

import { getDataState } from "./item.gts";
import Trigger from "./trigger.gts";

import type { AccordionHeaderExternalSignature } from "./public.ts";
import type { TOC } from "@ember/component/template-only";

interface Signature extends AccordionHeaderExternalSignature {
  Args: {
    value: string;
    isExpanded: boolean;
    disabled?: boolean;
    toggleItem: () => void;
  };
}

export const AccordionHeader: TOC<Signature> = <template>
  <div
    role="heading"
    aria-level="3"
    data-state={{getDataState @isExpanded}}
    data-disabled={{@disabled}}
    ...attributes
  >
    {{yield
      (hash
        Trigger=(component
          Trigger value=@value isExpanded=@isExpanded disabled=@disabled toggleItem=@toggleItem
        )
      )
    }}
  </div>
</template>;

export default AccordionHeader;
