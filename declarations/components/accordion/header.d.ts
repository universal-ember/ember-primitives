import type { AccordionHeaderExternalSignature } from './public.ts';
import type { TOC } from '@ember/component/template-only';
interface Signature extends AccordionHeaderExternalSignature {
    Args: {
        value: string;
        isExpanded: boolean;
        disabled?: boolean;
        toggleItem: () => void;
    };
}
export declare const AccordionHeader: TOC<Signature>;
export default AccordionHeader;
//# sourceMappingURL=header.d.ts.map