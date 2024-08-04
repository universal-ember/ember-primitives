import { dataFrom } from 'form-data-utils';
import type { TOC } from '@ember/component/template-only';
type Data = ReturnType<typeof dataFrom>;
export declare const dataFromEvent: typeof dataFrom;
export interface Signature {
    Element: HTMLFormElement;
    Args: {
        /**
         *  Any time the value of any field is changed this function will be called.
         */
        onChange: (
        /**
         * The data from the form as an Object of `{ [field name] => value }` pairs.
         * This is generated from the native [FormData](https://developer.mozilla.org/en-US/docs/Web/API/FormData)
         *
         * Additional fields/inputs/controls can be added to this data by specifying a
         * "name" attribute.
         */
        data: Data, 
        /**
         * Indicates whether the `onChange` function was called from the `input` or `submit` event handlers.
         */
        eventType: 'input' | 'submit', 
        /**
         * The raw event, if needed.
         */
        event: Event | SubmitEvent) => void;
    };
    Blocks: {
        /**
         * The main content for the form. This is where inputs / fields / controls would go.
         * Within the `<form>` content, `<button type="submit">` will submit the form, which
         * triggers the `@onChange` event.
         */
        default: [];
    };
}
export declare const Form: TOC<Signature>;
export default Form;
//# sourceMappingURL=form.d.ts.map