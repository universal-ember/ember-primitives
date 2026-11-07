import type { TOC } from "@ember/component/template-only";
export declare const TARGETS: Readonly<{
    popover: "ember-primitives__portal-targets__popover";
    tooltip: "ember-primitives__portal-targets__tooltip";
    modal: "ember-primitives__portal-targets__modal";
}>;
export declare function findNearestTarget(origin: Element, name: string): Element | undefined;
export interface Signature {
    Element: null;
}
export declare const PortalTargets: TOC<Signature>;
/**
 * For manually registering a PortalTarget for use with Portal
 */
export declare const PortalTarget: TOC<{
    Element: HTMLDivElement;
    Args: {
        /**
         * The name of the PortalTarget
         *
         * This exact string may be passed to `Portal`'s `@to` argument.
         */
        name: string;
    };
}>;
export default PortalTargets;
//# sourceMappingURL=portal-targets.d.ts.map