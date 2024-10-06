import Component from '@glimmer/component';
import type { ComponentLike } from '@glint/template';
export interface ItemSignature<Value = any> {
    /**
     * The button element will have aria-pressed="true" on it when the button is in the pressed state.
     */
    Element: HTMLButtonElement;
    Args: {
        /**
         * When used in a group of Toggles, this option will be helpful to
         * know which toggle was pressed if you're using the same @onChange
         * handler for multiple toggles.
         */
        value?: Value;
    };
    Blocks: {
        default: [
            /**
             * the current pressed state of the toggle button
             *
             * Useful when using the toggle button as an uncontrolled component
             */
            pressed: boolean
        ];
    };
}
export type Item<Value = any> = ComponentLike<ItemSignature<Value>>;
export interface SingleSignature<Value> {
    Element: HTMLDivElement;
    Args: {
        /**
         * Optionally set the initial toggle state
         */
        value?: Value;
        /**
         * Callback for when the toggle-group's state is changed.
         *
         * Can be used to control the state of the component.
         *
         *
         * When none of the toggles are selected, undefined will be passed.
         */
        onChange?: (value: Value | undefined) => void;
    };
    Blocks: {
        default: [
            {
                /**
                 * The Toggle Switch
                 */
                Item: Item;
            }
        ];
    };
}
export interface MultiSignature<Value = any> {
    Element: HTMLDivElement;
    Args: {
        /**
         * Optionally set the initial toggle state
         */
        value?: Value[] | Set<Value> | Value;
        /**
         * Callback for when the toggle-group's state is changed.
         *
         * Can be used to control the state of the component.
         *
         *
         * When none of the toggles are selected, undefined will be passed.
         */
        onChange?: (value: Set<Value>) => void;
    };
    Blocks: {
        default: [
            {
                /**
                 * The Toggle Switch
                 */
                Item: Item;
            }
        ];
    };
}
interface PrivateSingleSignature<Value = any> {
    Element: HTMLDivElement;
    Args: {
        type?: 'single';
        /**
         * Optionally set the initial toggle state
         */
        value?: Value;
        /**
         * Callback for when the toggle-group's state is changed.
         *
         * Can be used to control the state of the component.
         *
         *
         * When none of the toggles are selected, undefined will be passed.
         */
        onChange?: (value: Value | undefined) => void;
    };
    Blocks: {
        default: [
            {
                Item: Item;
            }
        ];
    };
}
interface PrivateMultiSignature<Value = any> {
    Element: HTMLDivElement;
    Args: {
        type: 'multi';
        /**
         * Optionally set the initial toggle state
         */
        value?: Value[] | Set<Value> | Value;
        /**
         * Callback for when the toggle-group's state is changed.
         *
         * Can be used to control the state of the component.
         *
         *
         * When none of the toggles are selected, undefined will be passed.
         */
        onChange?: (value: Set<Value>) => void;
    };
    Blocks: {
        default: [
            {
                Item: Item;
            }
        ];
    };
}
export declare class ToggleGroup<Value = any> extends Component<PrivateSingleSignature<Value> | PrivateMultiSignature<Value>> {
}
export {};
//# sourceMappingURL=toggle-group.d.ts.map