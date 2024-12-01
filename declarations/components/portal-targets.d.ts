import type { TOC } from '@ember/component/template-only';
export declare const TARGETS: Readonly<{
    popover: "ember-primitives__portal-targets__popover";
    tooltip: "ember-primitives__portal-targets__tooltip";
    modal: "ember-primitives__portal-targets__modal";
}>;
export declare function findNearestTarget(origin: Element, name: string): Element;
export interface Signature {
    Element: null;
}
export declare const PortalTargets: TOC<Signature>;
export default PortalTargets;
//# sourceMappingURL=portal-targets.d.ts.map