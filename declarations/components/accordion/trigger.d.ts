import type { AccordionTriggerExternalSignature } from './public.ts';
import type { TOC } from '@ember/component/template-only';
interface Signature extends AccordionTriggerExternalSignature {
    Args: {
        isExpanded: boolean;
        value: string;
        disabled?: boolean;
        toggleItem: () => void;
    };
}
export declare const AccordionTrigger: TOC<Signature>;
export default AccordionTrigger;
//# sourceMappingURL=trigger.d.ts.map