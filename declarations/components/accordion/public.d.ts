import type Content from "./content";
import type Header from "./header";
import type Trigger from "./trigger";
import type { WithBoundArgs } from '@glint/template';
export interface AccordionTriggerExternalSignature {
    Element: HTMLButtonElement;
    Blocks: {
        default: [];
    };
}
export interface AccordionContentExternalSignature {
    Element: HTMLDivElement;
    Blocks: {
        default: [];
    };
}
export interface AccordionHeaderExternalSignature {
    /**
     * Add aria-level according to the heading level where the accordion is used (default: 3).
     * See https://www.w3.org/WAI/ARIA/apg/patterns/accordion/ for more information.
     */
    Element: HTMLDivElement;
    Blocks: {
        default: [
            {
                /**
                 * The AccordionTrigger component.
                 */
                Trigger: WithBoundArgs<typeof Trigger, 'value' | 'isExpanded' | 'disabled' | 'toggleItem'>;
            }
        ];
    };
}
export interface AccordionItemExternalSignature {
    Element: HTMLDivElement;
    Blocks: {
        default: [
            {
                /**
                 * Whether the accordion item is expanded.
                 */
                isExpanded: boolean;
                /**
                 * The AccordionHeader component.
                 */
                Header: WithBoundArgs<typeof Header, 'value' | 'isExpanded' | 'disabled' | 'toggleItem'>;
                /**
                 * The AccordionContent component.
                 */
                Content: WithBoundArgs<typeof Content, 'value' | 'isExpanded' | 'disabled'>;
            }
        ];
    };
    Args: {
        /**
         * The value of the accordion item.
         */
        value: string;
    };
}
//# sourceMappingURL=public.d.ts.map