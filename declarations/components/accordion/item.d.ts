import Component from "@glimmer/component";
import type { AccordionItemExternalSignature } from "./public.ts";
export declare function getDataState(isExpanded: boolean): string;
interface Signature extends AccordionItemExternalSignature {
    Args: AccordionItemExternalSignature["Args"] & {
        selectedValue?: string | string[];
        disabled?: boolean;
        toggleItem: (value: string) => void;
    };
}
export declare class AccordionItem extends Component<Signature> {
    /**
     * `@value` only has to be unique within one accordion.
     * Element ids have to be unique across the document.
     */
    id: string;
    triggerId: string;
    contentId: string;
    get isExpanded(): boolean;
    toggleItem: () => void;
}
export default AccordionItem;
//# sourceMappingURL=item.d.ts.map