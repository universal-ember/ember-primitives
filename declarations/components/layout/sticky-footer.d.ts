import './sticky-footer.css';
import type { TOC } from '@ember/component/template-only';
export declare const StickyFooter: TOC<{
    /**
     * The wrapper element of the whole layout.
     * Valid parents for this element must have either a set height,
     * or a set max-height.
     */
    Element: HTMLDivElement;
    Blocks: {
        /**
         * This is the scrollable content, contained within a `<div>` element for positioning.
         * If this component is used as the main layout on a page,
         * the `<main>` element would be appropriate within here.
         */
        content: [];
        /**
         * This is the footer content, contained within a `<div>` element for positioning.
         * A `<footer>` element would be appropriate within here.
         *
         * This element will be at the bottom of the page if the content does not overflow the containing element and this element will be at the bottom of the content if there is overflow.
         */
        footer: [];
    };
}>;
export default StickyFooter;
//# sourceMappingURL=sticky-footer.d.ts.map