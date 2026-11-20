import { Separator } from './separator';
import type { TOC } from "@ember/component/template-only";
import type { WithBoundArgs } from "@glint/template";
export interface Signature {
    Element: HTMLElement;
    Args: {
        /**
         * The accessible label for the breadcrumb navigation.
         * Defaults to "Breadcrumb"
         */
        label?: string;
    };
    Blocks: {
        default: [
            {
                /**
                 * A separator component to place between breadcrumb items.
                 * Typically renders as "/" or ">" and is decorative (aria-hidden="true").
                 * Pre-configured to render as an `<li>` element for proper HTML structure.
                 */
                Separator: WithBoundArgs<typeof Separator, "as" | "decorative">;
            }
        ];
    };
}
/**
 * A breadcrumb navigation component that displays the current page's location within a navigational hierarchy.
 *
 * Breadcrumbs help users understand their current location and provide a way to navigate back through the hierarchy.
 *
 * For example:
 *
 * ```gjs live preview
 * import { Breadcrumb } from 'ember-primitives';
 *
 * <template>
 *   <Breadcrumb as |b|>
 *     <li>
 *       <a href="/">Home</a>
 *     </li>
 *     <b.Separator>/</b.Separator>
 *     <li>
 *       <a href="/docs">Docs</a>
 *     </li>
 *     <b.Separator>/</b.Separator>
 *     <li aria-current="page">
 *       Breadcrumb
 *     </li>
 *   </Breadcrumb>
 * </template>
 * ```
 */
export declare const Breadcrumb: TOC<Signature>;
export default Breadcrumb;
//# sourceMappingURL=breadcrumb.d.ts.map