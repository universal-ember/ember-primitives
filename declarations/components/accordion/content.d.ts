import Component from '@glimmer/component';
import type { AccordionContentExternalSignature } from './public.ts';
interface Signature extends AccordionContentExternalSignature {
    Args: {
        isExpanded: boolean;
        value: string;
        disabled?: boolean;
    };
}
export declare class AccordionContent extends Component<Signature> {
    get isHidden(): boolean;
}
export default AccordionContent;
//# sourceMappingURL=content.d.ts.map