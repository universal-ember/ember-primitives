import Component from '@glimmer/component';
import type { AccordionItemExternalSignature } from './public.ts';
export declare function getDataState(isExpanded: boolean): string;
interface Signature extends AccordionItemExternalSignature {
    Args: AccordionItemExternalSignature['Args'] & {
        selectedValue?: string | string[];
        disabled?: boolean;
        toggleItem: (value: string) => void;
    };
}
export declare class AccordionItem extends Component<Signature> {
    get isExpanded(): boolean;
    toggleItem: () => void;
}
export default AccordionItem;
//# sourceMappingURL=item.d.ts.map