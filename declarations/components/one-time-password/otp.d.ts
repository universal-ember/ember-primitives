import { Reset, Submit } from "./buttons";
import { OTPInput } from "./input";
import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';
export declare const OTP: TOC<{
    /**
     * The overall OTP Input is in its own form.
     * Modern UI/UX Patterns usually have this sort of field
     * as its own page, thus within its own form.
     *
     * By default, only the 'submit' event is bound, and is
     * what calls the `@onSubmit` argument.
     */
    Element: HTMLFormElement;
    Args: {
        /**
         * How many characters the one-time-password field should be
         * Defaults to 6
         */
        length?: number;
        /**
         * The on submit callback will give you the entered
         * one-time-password code.
         *
         * It will be called when the user manually clicks the 'submit'
         * button or when the full code is pasted and meats the validation
         * criteria.
         */
        onSubmit: (data: {
            code: string;
        }) => void;
        /**
         * Whether or not to auto-submit after the code has been pasted
         * in to the collective "field".  Default is true
         */
        autoSubmit?: boolean;
    };
    Blocks: {
        default: [
            {
                /**
                 * The collective input field that the OTP code will be typed/pasted in to
                 */
                Input: WithBoundArgs<typeof OTPInput, 'length' | 'onChange'>;
                /**
                 * Button with `type="submit"` to submit the form
                 */
                Submit: typeof Submit;
                /**
                 * Pre-wired button to reset the form
                 */
                Reset: typeof Reset;
            }
        ];
    };
}>;
//# sourceMappingURL=otp.d.ts.map