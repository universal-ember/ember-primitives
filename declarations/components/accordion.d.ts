import Component from '@glimmer/component';
import AccordionItem from "./accordion/item";
import type { WithBoundArgs } from '@glint/template';
type AccordionSingleArgs = {
    /**
     * The type of accordion. If `single`, only one item can be selected at a time. If `multiple`, multiple items can be selected at a time.
     */
    type: 'single';
    /**
     * Whether the accordion is disabled. When `true`, all items cannot be expanded or collapsed.
     */
    disabled?: boolean;
    /**
     * When type is `single`, whether the accordion is collapsible. When `true`, the selected item can be collapsed by clicking its trigger.
     */
    collapsible?: boolean;
} & ({
    /**
     * The currently selected value. To be used in a controlled fashion in conjunction with `onValueChange`.
     */
    value: string;
    /**
     * A callback that is called when the selected value changes. To be used in a controlled fashion in conjunction with `value`.
     */
    onValueChange: (value: string | undefined) => void;
    /**
     * Not available in a controlled fashion.
     */
    defaultValue?: never;
} | {
    /**
     * Not available in an uncontrolled fashion.
     */
    value?: never;
    /**
     * Not available in an uncontrolled fashion.
     */
    onValueChange?: never;
    /**
     * The default value of the accordion. To be used in an uncontrolled fashion.
     */
    defaultValue?: string;
});
type AccordionMultipleArgs = {
    /**
     * The type of accordion. If `single`, only one item can be selected at a time. If `multiple`, multiple items can be selected at a time.
     */
    type: 'multiple';
    /**
     * Whether the accordion is disabled. When `true`, all items cannot be expanded or collapsed.
     */
    disabled?: boolean;
} & ({
    /**
     * The currently selected values. To be used in a controlled fashion in conjunction with `onValueChange`.
     */
    value: string[];
    /**
     * A callback that is called when the selected values change. To be used in a controlled fashion in conjunction with `value`.
     */
    onValueChange: (value?: string[] | undefined) => void;
    /**
     * Not available in a controlled fashion.
     */
    defaultValue?: never;
} | {
    /**
     * Not available in an uncontrolled fashion.
     */
    value?: never;
    /**
     * Not available in an uncontrolled fashion.
     */
    onValueChange?: never;
    /**
     * The default values of the accordion. To be used in an uncontrolled fashion.
     */
    defaultValue?: string[];
});
export declare class Accordion extends Component<{
    Element: HTMLDivElement;
    Args: AccordionSingleArgs | AccordionMultipleArgs;
    Blocks: {
        default: [
            {
                /**
                 * The AccordionItem component.
                 */
                Item: WithBoundArgs<typeof AccordionItem, 'selectedValue' | 'toggleItem' | 'disabled'>;
            }
        ];
    };
}> {
    _internallyManagedValue?: string | string[];
    get selectedValue(): string | string[] | undefined;
    toggleItem: (value: string) => void;
    toggleItemSingle: (value: string) => void;
    toggleItemMultiple: (value: string) => void;
}
export default Accordion;
//# sourceMappingURL=accordion.d.ts.map