import Component from '@glimmer/component';
import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';
declare const Fields: TOC<{
    /**
     * Any attributes passed to this component will be applied to each input.
     */
    Element: HTMLInputElement;
    Args: {
        fields: unknown[];
        labelFn: (index: number) => string;
        handleChange: (event: Event) => void;
    };
}>;
export declare class OTPInput extends Component<{
    /**
     * The collection of individual OTP inputs are contained by a fieldset.
     * Applying the `disabled` attribute to this fieldset will disable
     * all of the inputs, if that's desired.
     */
    Element: HTMLFieldSetElement;
    Args: {
        /**
         * How many characters the one-time-password field should be
         * Defaults to 6
         */
        length?: number;
        /**
         * To Customize the label of the input fields, you may pass a function.
         * By default, this is `Please enter OTP character ${index + 1}`.
         */
        labelFn?: (index: number) => string;
        /**
         * If passed, this function will be called when the <Input> changes.
         * All fields are considered one input.
         */
        onChange?: (data: {
            /**
             * The text from the collective `<Input>`
             *
             * `code` _may_ be shorter than `length`
             * if the user has not finished typing / pasting their code
             */
            code: string;
            /**
             * will be `true` if `code`'s length matches the passed `@length` or the default of 6
             */
            complete: boolean;
        }, 
        /**
         * The last input event received
         */
        event: Event) => void;
    };
    Blocks: {
        /**
         * Optionally, you may control how the Fields are rendered, with proceeding text,
         * additional attributes added, etc.
         *
         * This is how you can add custom validation to each input field.
         */
        default?: [fields: WithBoundArgs<typeof Fields, 'fields' | 'handleChange' | 'labelFn'>];
    };
}> {
    #private;
    /**
     * This is debounced, because we bind to each input,
     * but only want to emit one change event if someone pastes
     * multiple characters
     */
    handleChange: (event: Event) => void;
    get length(): number;
    get fields(): any[];
}
export {};
//# sourceMappingURL=input.d.ts.map