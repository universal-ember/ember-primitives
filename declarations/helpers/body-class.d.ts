/**
 * Initial inspo:
 * - https://github.com/ef4/ember-set-body-class/blob/master/addon/services/body-class.js
 * - https://github.com/ef4/ember-set-body-class/blob/master/addon/helpers/set-body-class.js
 */
import Helper from '@ember/component/helper';
export interface Signature {
    Args: {
        Positional: [
            /**
             * a space-delimited list of classes to apply when this helper is called.
             *
             * When the helper is removed from rendering, the clasess will be removed as well.
             */
            classes: string
        ];
    };
    /**
     * This helper returns nothing, as it is a side-effect that mutates and manages external state.
     */
    Return: undefined;
}
export default class BodyClass extends Helper<Signature> {
    localId: number;
    compute([classes]: [string]): undefined;
    willDestroy(): void;
}
export declare const bodyClass: typeof BodyClass;
//# sourceMappingURL=body-class.d.ts.map