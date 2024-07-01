import Service from '@ember/service';
/**
 * @internal
 */
export declare const PRIMITIVES: unique symbol;
export default class EmberPrimitivesSetup extends Service {
    #private;
    /**
     * Sets up required features for accessibility.
     */
    setup: ({ tabster, setTabsterRoot, }?: {
        /**
         * Let this setup function initalize tabster.
         * https://tabster.io/docs/core
         *
         * This should be done only once per application as we don't want
         * focus managers fighting with each other.
         *
         * Defaults to `true`,
         *
         * Will fallback to an existing tabster instance automatically if `getTabster` returns a value.
         */
        tabster?: boolean;
        setTabsterRoot?: boolean;
    }) => void;
}
//# sourceMappingURL=setup.d.ts.map