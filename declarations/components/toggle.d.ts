import type { TOC } from '@ember/component/template-only';
export interface Signature<Value = any> {
    Element: HTMLButtonElement;
    Args: {
        /**
         * The pressed-state of the toggle.
         *
         * Can be used to control the state of the component.
         */
        pressed?: boolean;
        /**
         * Callback for when the toggle's state is changed.
         *
         * Can be used to control the state of the component.
         *
         * if a `@value` is passed to this `<Toggle>`, that @value will
         * be passed to the `@onChange` handler.
         *
         * This can be useful when using the same function for the `@onChange`
         * handler with multiple `<Toggle>` components.
         */
        onChange?: (value: Value | undefined, pressed: boolean) => void;
        /**
         * When used in a group of Toggles, this option will be helpful to
         * know which toggle was pressed if you're using the same @onChange
         * handler for multiple toggles.
         */
        value?: Value;
        /**
         * When controlling state in a wrapping component, this function can be used in conjunction with `@value` to determine if this `<Toggle>` should appear pressed.
         */
        isPressed?: (value?: Value | undefined) => boolean;
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
export declare const Toggle: TOC<Signature>;
export default Toggle;
//# sourceMappingURL=toggle.d.ts.map