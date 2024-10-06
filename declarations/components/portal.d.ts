import { type TARGETS } from "./portal-targets";
import type { TOC } from '@ember/component/template-only';
export interface Signature {
    Args: {
        /**
         * The name of the PortalTarget to render in to.
         * This is the value of the `data-portal-name` attribute
         * of the element you wish to render in to.
         */
        to: (typeof TARGETS)[keyof typeof TARGETS] | (string & {});
    };
    Blocks: {
        /**
         * The portaled content
         */
        default: [];
    };
}
export declare const Portal: TOC<Signature>;
export default Portal;
//# sourceMappingURL=portal.d.ts.map