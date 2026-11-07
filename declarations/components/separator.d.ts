import type { TOC } from "@ember/component/template-only";
type Orientation = "horizontal" | "vertical";
export interface Signature {
    Element: HTMLElement;
    Args: {
        /**
         * The tag name to use for the separator element.
         * Defaults to `<hr>` for non-decorative separators.
         * You can override this (e.g. `"li"` in menus, or `"span"` for inline separators).
         *
         * For example, in breadcrumbs where separators are siblings to `<li>` elements:
         * ```gjs
         * <Separator @as="li" @decorative={{true}}>/</Separator>
         * ```
         */
        as?: string;
        /**
         * When true, hides the separator from assistive technologies.
         *
         * Use this for purely decorative separators, such as breadcrumb slashes.
         */
        decorative?: boolean;
        /**
         * Sets `aria-orientation`. `separator` has an implicit orientation of `horizontal`.
         * Provide this when the separator is vertical.
         */
        orientation?: Orientation;
    };
    Blocks: {
        default: [];
    };
}
/**
 * A separator component that follows the ARIA `separator` role guidance.
 *
 * By default, this component renders a semantic separator (`<hr>`). When using a
 * non-`hr` tag via `@as`, it adds `role="separator"`.
 *
 * For purely decorative separators (e.g. breadcrumb slashes), set `@decorative={{true}}`
 * to apply `aria-hidden="true"`.
 *
 * For example:
 *
 * ```gjs live preview
 * import { Separator } from 'ember-primitives';
 *
 * <template>
 *   <nav>
 *     <ol style="display: flex; gap: 0.5rem; list-style: none; padding: 0;">
 *       <li><a href="/">Home</a></li>
 *       <Separator @as="li" @decorative={{true}}>/</Separator>
 *       <li><a href="/docs">Docs</a></li>
 *       <Separator @as="li" @decorative={{true}}>/</Separator>
 *       <li>Current</li>
 *     </ol>
 *   </nav>
 * </template>
 * ```
 */
export declare const Separator: TOC<Signature>;
export default Separator;
//# sourceMappingURL=separator.d.ts.map