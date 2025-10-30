import { type TARGETS } from './portal-targets';
import type { TOC } from "@ember/component/template-only";
type Targets = (typeof TARGETS)[keyof typeof TARGETS];
export interface Signature {
    Args: {
        /**
         * The name of the PortalTarget to render in to.
         * This is the value of the `data-portal-name` attribute
         * of the element you wish to render in to.
         *
         * This can also be an Element which pairs nicely with query-utilities such as the platform-native `querySelector`
         */
        to?: (Targets | (string & {})) | Element;
        /**
         * Set to true to append to the portal instead of replace
         *
         * Default: false
         */
        append?: boolean;
        /**
         * For ember-wormhole style behavior, this argument may be an id,
         * or a selector.
         * This can also be an element, in which case the behavior is identical to `@to`
         */
        wormhole?: string | Element;
    };
    Blocks: {
        /**
         * The portaled content
         */
        default: [];
    };
}
/**
 * Polyfill for ember-wormhole behavior
 *
 * Example usage:
 * ```gjs
 * import { wormhole, Portal } from 'ember-primitives/components/portal';
 *
 * <template>
 *   <div id="the-portal"></div>
 *
 *   <Portal @to={{wormhole "the-portal"}}>
 *     content renders in the above div
 *   </Portal>
 * </template>
 *
 * ```
 */
export declare function wormhole(query: string | null | undefined | Element): Element | null;
export declare const Portal: TOC<Signature>;
export default Portal;
//# sourceMappingURL=portal.d.ts.map